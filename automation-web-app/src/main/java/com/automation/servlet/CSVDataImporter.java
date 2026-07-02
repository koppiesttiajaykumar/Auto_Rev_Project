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

public class CSVDataImporter {

    private static DBConfig dbConfig;
    private static final String CALL_PROCEDURE = "{CALL InsertTestResult(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}";

    public static void main(String[] args) {
        if (!loadDriverAndConfig()) {
            return;
        }

        String userHome = System.getProperty("user.home");
        Path csvDirectoryPath = Paths.get(userHome, "Downloads", "csvfiles");

        processDirectory(csvDirectoryPath);
    }

    private static boolean loadDriverAndConfig() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            dbConfig = new DBConfig(); 
            return true;
        } catch (ClassNotFoundException e) {
            System.out.println("❌ Error: MySQL Driver missing in Classpath!");
            e.printStackTrace();
            return false;
        }
    }

    private static void processDirectory(Path directoryPath) {
        System.out.println("🚀 [START] Scanning folder: " + directoryPath.toString());

        if (!Files.exists(directoryPath) || !Files.isDirectory(directoryPath)) {
            System.out.println("❌ Error: Directory not found at: " + directoryPath.toString());
            return;
        }

        try {
            List<Path> csvFiles = Files.list(directoryPath)
                                       .filter(path -> path.toString().toLowerCase().endsWith(".csv"))
                                       .collect(Collectors.toList());

            if (csvFiles.isEmpty()) {
                System.out.println("ℹ️ No CSV files found to process inside 'csvfiles' folder.");
                return;
            }

            importCSVData(csvFiles);

        } catch (IOException e) {
            System.out.println("❌ IO Error while scanning directory!");
            e.printStackTrace();
        }
    }

    private static void importCSVData(List<Path> csvFiles) {
        int totalFilesProcessed = 0;
        int totalRowsInserted = 0;

        try (Connection conn = DriverManager.getConnection(dbConfig.getUrl(), dbConfig.getUsername(), dbConfig.getPassword());
             CallableStatement stmt = conn.prepareCall(CALL_PROCEDURE)) {
            
            conn.setAutoCommit(false); 

            for (Path file : csvFiles) {
                System.out.println("📄 Processing File: " + file.getFileName());
                try (BufferedReader br = Files.newBufferedReader(file)) {
                    String line;
                    boolean isHeader = true;

                    while ((line = br.readLine()) != null) {
                        if (isHeader) {
                            isHeader = false; 
                            continue;
                        }
                        if (line.trim().isEmpty()) continue;

                        String[] data = line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)"); 

                        if (data.length < 10) {
                            System.out.println("⚠️ [SKIP ROW] Columns less than 10 in: " + file.getFileName());
                            continue; 
                        }

                        try {
                            stmt.setString(1, data[0].trim()); 
                            stmt.setString(2, data[1].trim()); 
                            stmt.setString(3, data[2].trim()); 
                            
                            // DATA TRUNCATION SAFETY CHECK
                            String testCaseDesc = data[3].trim();
                            if (testCaseDesc.length() > 255) {
                                testCaseDesc = testCaseDesc.substring(0, 255);
                            }
                            stmt.setString(4, testCaseDesc);   
                            
                            stmt.setString(5, data[4].trim()); 
                            stmt.setString(6, data[5].trim()); 
                            stmt.setString(7, data[6].trim()); 
                            stmt.setString(8, data[7].trim()); 

                            String timeStr = data[9].trim();
                            stmt.setBigDecimal(9, timeStr.isEmpty() ? BigDecimal.ZERO : new BigDecimal(timeStr));
                            
                            stmt.setString(10, data[8].trim()); 
                            stmt.setTimestamp(11, new Timestamp(System.currentTimeMillis())); 
                            stmt.setString(12, "Automation-Tool-Console"); 

                            stmt.addBatch();
                            totalRowsInserted++;
                        } catch (Exception e) {
                            System.out.println("❌ [ROW ERROR] Error parsing row: " + e.getMessage());
                        }
                    }
                }
                totalFilesProcessed++;
            }

            if (totalRowsInserted > 0) {
                stmt.executeBatch();
                conn.commit(); 
                System.out.println("✅ Success: Processed " + totalFilesProcessed + " files. Total " + totalRowsInserted + " records inserted!");
                System.out.println("📁 Files are kept safe inside the source folder.");
            } else {
                System.out.println("⚠️ Warning: No valid rows matched requirements.");
            }

        } catch (SQLException | IOException e) {
            System.out.println("❌ CRITICAL: Database/IO Error occurred during data import!");
            e.printStackTrace();
        }
        System.out.println("🏁 [END] Execution finished.");
    }
}