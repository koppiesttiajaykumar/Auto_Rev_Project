package com.automation.servlet;

import com.automation.util.DBConfig;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/processBulkCSV")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 20,
        maxRequestSize = 1024 * 1024 * 100
)
public class BulkCSVProcessorServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String PROCEDURE =
            "{CALL InsertTestResult(?,?,?,?,?,?,?,?,?,?,?,?,?)}";

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String toolName = request.getParameter("toolName");

        String automationOwner =
                request.getParameter("automationOwner");

        if(toolName==null || toolName.trim().isEmpty()){

            toolName="Unknown Tool";

        }

        if(automationOwner==null ||
                automationOwner.trim().isEmpty()){

            automationOwner="Unknown Owner";

        }

        int totalFiles=0;
        int totalRows=0;
        int batchCount=0;

        DBConfig config=new DBConfig();

        try(

                Connection conn=
                        DriverManager.getConnection(
                                config.getUrl(),
                                config.getUsername(),
                                config.getPassword());

                CallableStatement stmt=
                        conn.prepareCall(PROCEDURE);

                ){

            conn.setAutoCommit(false);

            for(Part part:request.getParts()){

                if(!"csvFiles".equals(part.getName()) ||
                        part.getSize()==0){

                    continue;

                }

                totalFiles++;

                BufferedReader br=
                        new BufferedReader(
                                new InputStreamReader(
                                        part.getInputStream(),
                                        "UTF-8"));

                String line;

                boolean firstRow=true;

                int lineNumber=0;

                while((line=br.readLine())!=null){

                    lineNumber++;

                    if(firstRow){

                        firstRow=false;

                        continue;

                    }

                    if(line.trim().isEmpty()){

                        continue;

                    }

                    String[] data=
                            line.split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)");

                    if(data.length<10){

                        continue;

                    }

                    if(data[0].trim()
                            .equalsIgnoreCase("ClassName")){

                        continue;

                    }

                    try{

                        BigDecimal time=
                                BigDecimal.ZERO;

                        String value=data[9].trim();

                        if(!value.isEmpty()){

                            time=new BigDecimal(value);

                        }

                        String testCase=data[3].trim();

                        if(testCase.length()>255){

                            testCase=
                                    testCase.substring(0,255);

                        }

                        stmt.setString(1,data[0].trim());

                        stmt.setString(2,data[1].trim());

                        stmt.setString(3,data[2].trim());

                        stmt.setString(4,testCase);

                        stmt.setString(5,data[4].trim());

                        stmt.setString(6,data[5].trim());

                        stmt.setString(7,data[6].trim());

                        stmt.setString(8,data[7].trim());

                        stmt.setBigDecimal(9,time);

                        stmt.setString(10,data[8].trim());

                        stmt.setTimestamp(
                                11,
                                new Timestamp(
                                        System.currentTimeMillis()));

                        stmt.setString(
                                12,
                                toolName);

                        stmt.setString(
                                13,
                                automationOwner);

                        stmt.addBatch();

                        totalRows++;

                        batchCount++;
                        // Execute batch after every 500 records
                        if (batchCount >= 500) {

                            stmt.executeBatch();
                            stmt.clearBatch();

                            conn.commit();

                            batchCount = 0;

                            System.out.println(
                                    "500 Records Inserted Successfully...");
                        }

                    } catch (NumberFormatException ex) {

                        System.out.println(
                                "Invalid Time at Line "
                                + lineNumber
                                + " : "
                                + ex.getMessage());

                    } catch (Exception ex) {

                        System.out.println(
                                "Skipping Line "
                                + lineNumber
                                + " : "
                                + ex.getMessage());

                    }

                }

                br.close();

            }

            // Insert remaining records
            if (batchCount > 0) {

                stmt.executeBatch();

                stmt.clearBatch();

                conn.commit();

            }

            request.setAttribute(
                    "message",
                    "Upload Successful!\n\n"
                    + "Automation Tool : "
                    + toolName
                    + "\nAutomation Owner : "
                    + automationOwner
                    + "\nFiles Uploaded : "
                    + totalFiles
                    + "\nTotal Test Cases : "
                    + totalRows);

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Upload Failed : "
                    + e.getMessage());

        }

        request.getRequestDispatcher(
                "bulkUpload.jsp")
                .forward(request, response);

    }

}