package com.automation.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;

public class CSVImporter {

    // Folder containing CSV files
    private static final String CSV_FOLDER = "C:\\Reports\\CSV";

    public static void importCSVFiles() {

        DBConfig config = new DBConfig();

        String sql = "INSERT INTO TestResults "
                + "(ClassName, TestCaseName, Status, TestCase, ModuleName,"
                + "SuiteName, OperatingBrowser, BuildNo,"
                + "TimeInSeconds, Environment, TestDate)"
                + " VALUES (?,?,?,?,?,?,?,?,?,?,NOW())";

        try (
                Connection con = DriverManager.getConnection(
                        config.getUrl(),
                        config.getUsername(),
                        config.getPassword());

                PreparedStatement ps = con.prepareStatement(sql);
        ) {

            File folder = new File(CSV_FOLDER);

            File[] csvFiles = folder.listFiles((dir, name) ->
                    name.toLowerCase().endsWith(".csv"));

            if (csvFiles == null || csvFiles.length == 0) {

                System.out.println("No CSV files found.");

                return;
            }

            for (File file : csvFiles) {

                System.out.println("Reading : " + file.getName());

                BufferedReader br = new BufferedReader(new FileReader(file));

                String header = br.readLine();

                if (header == null) {

                    br.close();

                    continue;
                }

                String[] headers = header.split(",");

                Map<String, Integer> map = new HashMap<>();

                for (int i = 0; i < headers.length; i++) {

                    map.put(headers[i].trim(), i);

                }

                String line;

                while ((line = br.readLine()) != null) {

                    String[] data = line.split(",", -1);

                    ps.setString(1, data[map.get("ClassName")]);
                    ps.setString(2, data[map.get("Test Case Name")]);
                    ps.setString(3, data[map.get("Status")]);
                    ps.setString(4, data[map.get("Test Case Description")]);
                    ps.setString(5, data[map.get("Module Name")]);
                    ps.setString(6, data[map.get("Suite Name")]);

                    // Browser -> OperatingBrowser
                    ps.setString(7, data[map.get("Browser")]);

                    ps.setString(8, data[map.get("Build No")]);

                    String time = data[map.get("Time in Seconds")];

                    if (time == null || time.trim().isEmpty()) {

                        ps.setDouble(9, 0);

                    } else {

                        ps.setDouble(9, Double.parseDouble(time));

                    }

                    // Default Environment
                    ps.setString(10, "QA");

                    ps.addBatch();
                }

                br.close();

                System.out.println(file.getName() + " Imported Successfully.");
            }

            ps.executeBatch();

            System.out.println("All CSV Files Imported Successfully.");

        } catch (Exception e) {

            e.printStackTrace();
        }

    }
}