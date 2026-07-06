package com.automation.servlet;

import com.automation.util.DBConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.stream.Collectors;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/processBulkCSV")
public class BulkCSVProcessorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DBConfig dbConfig;

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            dbConfig = new DBConfig(); 
        } catch (ClassNotFoundException e) {
            throw new ServletException("MySQL Driver missing", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userHome = System.getProperty("user.home");
        Path csvDirectoryPath = Paths.get(userHome, "Downloads", "csvfiles");
        
        String callProcedure = "{CALL InsertTestResult(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        int totalFilesProcessed = 0;
        int totalRowsInserted = 0;

        if (!Files.exists(csvDirectoryPath) || !Files.isDirectory(csvDirectoryPath)) {
            request.setAttribute("error", "Directory not found at: " + csvDirectoryPath.toString());
            request.getRequestDispatcher("bulkUpload.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DriverManager.getConnection(dbConfig.getUrl(), dbConfig.getUsername(), dbConfig.getPassword());
             CallableStatement stmt = conn.prepareCall(callProcedure)) {
            
            conn.setAutoCommit(false); 

            List<Path> csvFiles = Files.list(csvDirectoryPath)
                                       .filter(path -> path.toString().toLowerCase().endsWith(".csv"))
                                       .collect(Collectors.toList());

            for (Path file : csvFiles) {
                System.out.println("Processing File: " + file.getFileName());
                try (BufferedReader br = Files.newBufferedReader(file)) {
                    String line;
                    boolean isHeader = true;

                    while ((line = br.readLine()) != null) {
                        if (isHeader) {
                            isHeader = false; 
                            continue;
                        }

                        if (line.trim().isEmpty()) {
                            continue;
                        }

                        // Split data safely keeping internal quoted commas safe
                        String[] data = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)"); 

                        if (data.length < 10) {
                            System.out.println("[SKIP ROW] Columns are less than 10. Found: " + data.length);
                            continue; 
                        }

                        try {
                            stmt.setString(1, data[0].trim()); // ClassName
                            stmt.setString(2, data[1].trim()); // TestCaseName
                            stmt.setString(3, data[2].trim()); // Status
                            stmt.setString(4, data[3].trim()); // TestCase Description
                            stmt.setString(5, data[4].trim()); // ModuleName
                            stmt.setString(6, data[5].trim()); // SuiteName
                            stmt.setString(7, data[6].trim()); // OperatingBrowser
                            stmt.setString(8, data[7].trim()); // BuildNo

                            String timeStr = data[9].trim();
                            stmt.setBigDecimal(9, timeStr.isEmpty() ? BigDecimal.ZERO : new BigDecimal(timeStr));
                            
                            stmt.setString(10, data[8].trim()); // Environment / URL Text
                            stmt.setTimestamp(11, new Timestamp(System.currentTimeMillis())); // Current Date/Time
                            stmt.setString(12, "Automation-Tool"); // Tool Name fallback

                            stmt.addBatch();
                            totalRowsInserted++;
                        } catch (Exception e) {
                            System.out.println("[ROW ERROR] Error parsing row data: " + e.getMessage());
                        }
                    }
                }
                totalFilesProcessed++;
            }

            if (totalRowsInserted > 0) {
                stmt.executeBatch();
                conn.commit(); 
                
                // 🎯 [REMOVED] Deletion loop has been completely removed to keep files safe!
                
                request.setAttribute("message", "Successfully processed " + totalFilesProcessed + " files. Total " + totalRowsInserted + " records inserted!");
            } else {
                request.setAttribute("error", "Data Processing Failed! No rows matched requirements.");
            }

        } catch (SQLException e) {
            request.setAttribute("error", "Database Error: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("bulkUpload.jsp").forward(request, response);
    }
}