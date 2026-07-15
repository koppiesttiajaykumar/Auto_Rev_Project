package com.automation.servlet;

import com.automation.util.DBConfig;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Collection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/processBulkCSV")
// 🌟 Multipart configuration enable kiya taaki files handle ho sakein
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB per file
    maxRequestSize = 1024 * 1024 * 50     // 50MB total request size
)
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
        
        String callProcedure = "{CALL InsertTestResult(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

        int totalFilesProcessed = 0;
        int totalRowsInserted = 0;

        // Form se saari uploaded parts/files nikalna
        Collection<Part> parts = request.getParts();

        try (Connection conn = DriverManager.getConnection(dbConfig.getUrl(), dbConfig.getUsername(), dbConfig.getPassword());
             CallableStatement stmt = conn.prepareCall(callProcedure)) {
            
            conn.setAutoCommit(false); 

            for (Part part : parts) {
                // Check karein ki part ek valid CSV file hi ho
                if (part.getName().equals("csvFiles") && part.getSize() > 0) {
                    String fileName = getFileName(part);
                    
                    if (fileName != null && fileName.toLowerCase().endsWith(".csv")) {
                        System.out.println("Processing Uploaded File: " + fileName);
                        
                        // Direct input stream se read karna bina local disk par save kiye
                        try (BufferedReader br = new BufferedReader(new InputStreamReader(part.getInputStream()))) {
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
                }
            }

            if (totalRowsInserted > 0) {
                stmt.executeBatch();
                conn.commit(); 
                request.setAttribute("message", "Successfully processed " + totalFilesProcessed + " uploaded file(s). Total " + totalRowsInserted + " records inserted!");
            } else {
                request.setAttribute("error", "Data Processing Failed! No valid CSV data found.");
            }

        } catch (SQLException e) {
            request.setAttribute("error", "Database Error: " + e.getMessage());
            e.printStackTrace();
        }

        request.getRequestDispatcher("bulkUpload.jsp").forward(request, response);
    }

    // Helper method: Part header se file ka naam nikalne ke liye
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}