package com.automation.servlet;

import com.automation.model.TestResult;
import com.automation.util.DBConfig; 
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
    
    private final DBConfig dbConfig = new DBConfig();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Frontend Form se saare parameters capture karein
        String toolName = Optional.ofNullable(request.getParameter("toolName")).map(String::trim).orElse("");
        String startDate = Optional.ofNullable(request.getParameter("startDate")).map(String::trim).orElse("");
        String endDate = Optional.ofNullable(request.getParameter("endDate")).map(String::trim).orElse("");
        String statusFilter = Optional.ofNullable(request.getParameter("statusFilter")).map(String::trim).orElse("ALL");
        String searchTestCaseName = Optional.ofNullable(request.getParameter("searchTestCaseName")).map(String::trim).orElse("");
        String automationOwnerFilter = Optional.ofNullable(request.getParameter("automationOwnerFilter")).map(String::trim).orElse("ALL");

        List<TestResult> resultList = new ArrayList<>();
        int passCount = 0;
        int failCount = 0;

        // 2. Data load tabhi hoga jab tool select kiya gaya ho (Blank load blocker)
        if (!toolName.isEmpty()) {
            // Updated syntax mapping pointing exactly to 6 question mark slots
            String callProcedure = "{CALL GetToolResults(?,?,?,?,?,?)}";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                
                try (Connection conn = DriverManager.getConnection(dbConfig.getUrl(), dbConfig.getUsername(), dbConfig.getPassword());
                     CallableStatement stmt = conn.prepareCall(callProcedure)) {
                    
                    stmt.setString(1, toolName);
                    
                    // Date boundaries configuration
                    if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                        stmt.setString(2, startDate);
                        stmt.setString(3, endDate);
                    } else {
                        stmt.setString(2, "DEFAULT");
                        stmt.setString(3, "DEFAULT");
                    }
                    
                    stmt.setString(4, statusFilter);
                    stmt.setString(5, searchTestCaseName);
                    stmt.setString(6, automationOwnerFilter);
                    
                    try (ResultSet rs = stmt.executeQuery()) {
                        while (rs.next()) {
                            String currentStatus = Optional.ofNullable(rs.getString("Status")).orElse("").toUpperCase().trim();
                            String currentTestCaseName = Optional.ofNullable(rs.getString("TestCaseName")).orElse("");

                            TestResult result = new TestResult();
                            result.setId(rs.getInt("Id"));
                            result.setTestCaseName(currentTestCaseName);
                            result.setStatus(rs.getString("Status"));
                            result.setTestCase(rs.getString("TestCase"));
                            result.setModuleName(rs.getString("ModuleName"));
                            result.setSuiteName(rs.getString("SuiteName"));
                            result.setTimeInSeconds(rs.getBigDecimal("TimeInSeconds") != null ? rs.getBigDecimal("TimeInSeconds").doubleValue() : 0.0);
                            result.setEnvironment(rs.getString("Environment"));
                            
                            if (rs.getTimestamp("TestDate") != null) {
                                result.setTestDate(rs.getTimestamp("TestDate").toLocalDateTime());
                            }
                            result.setToolName(rs.getString("ToolName"));
                            
                            // Fetch the Automation Owner string from ResultSet row cell
                            result.setAutomationOwner(rs.getString("AutomationOwner"));

                            // Pass and Fail counters verification based on exact test case search
                            if (!searchTestCaseName.isEmpty()) {
                                if (currentStatus.equals("N") || currentStatus.equals("PASS") || currentStatus.equals("P")) {
                                    passCount++;
                                } else if (currentStatus.equals("Y") || currentStatus.equals("FAIL") || currentStatus.equals("F")) {
                                    failCount++;
                                }
                            }
                            
                            resultList.add(result);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 3. Request scope variables back to JSP mapping panel
        request.setAttribute("results", resultList);
        request.setAttribute("searchedTool", toolName);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("automationOwnerFilter", automationOwnerFilter);
        
        // Niche blue badge ko value dene ke liye displaySearchedName set rahega
        request.setAttribute("displaySearchedName", searchTestCaseName); 
        
        // ✅ FIXED BOX: Input text box ko completely khali (blank) karne ke liye empty string bhejenge
        request.setAttribute("searchTestCaseName", ""); 
        
        request.setAttribute("passCount", passCount);
        request.setAttribute("failCount", failCount);
        
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
