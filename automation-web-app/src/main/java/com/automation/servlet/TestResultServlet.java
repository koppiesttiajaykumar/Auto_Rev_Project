package com.automation.servlet;

import com.automation.model.TestResult;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/getResults")
public class TestResultServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Database name ko wapas 'automation_rev' kar diya hai aur security parameters jodh diye hain
    private final String jdbcURL = "jdbc:mysql://192.168.1.25:3306/automation_rev?allowPublicKeyRetrieval=true&useSSL=false&serverTimezone=UTC";
    private final String jdbcUsername = "ajay";
    private final String jdbcPassword = "Ajay@123";
    
    
    static CallableStatement stmt;
    
    
    
    public void getTestCaseCount()
    {
    	
    }
    

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String toolName = Optional.ofNullable(request.getParameter("toolName"))
                                  .map(String::trim)
                                  .orElse("");

        List<TestResult> resultList = new ArrayList<>();

        if (!toolName.isEmpty()) {
            String callProcedure = "{CALL GetToolResults(?)}";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                     CallableStatement stmt = conn.prepareCall(callProcedure)) {
                    
                    stmt.setString(1, toolName);
                    
                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            TestResult result = new TestResult();
                            result.setId(rs.getInt("Id"));
                          //  result.setClassName(rs.getString("ClassName"));
                        //    result.setTestCaseName(rs.getString("TestCaseName"));
                            result.setStatus(rs.getString("Status"));
                            result.setTestCase(rs.getString("TestCase"));
                            result.setModuleName(rs.getString("ModuleName"));
                            result.setSuiteName(rs.getString("SuiteName"));
                        //    result.setOperatingBrowser(rs.getString("OperatingBrowser"));
                          //  result.setBuildNo(rs.getString("BuildNo"));
                            result.setTimeInSeconds(rs.getBigDecimal("TimeInSeconds").doubleValue());
                            result.setEnvironment(rs.getString("Environment"));
                            
                            if (rs.getTimestamp("TestDate") != null) {
                                result.setTestDate(rs.getTimestamp("TestDate").toLocalDateTime());
                            }
                            
                            result.setToolName(rs.getString("ToolName"));
                            resultList.add(result);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("results", resultList);
        request.setAttribute("searchedTool", toolName);
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}