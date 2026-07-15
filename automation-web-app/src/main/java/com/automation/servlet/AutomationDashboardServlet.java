package com.automation.servlet;

import com.automation.util.DBConfig;
import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/getAutomationSummary")
public class AutomationDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ServletException("Unable to load MySQL Driver", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String toolName = request.getParameter("toolName");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Trim and string normalization
        toolName = (toolName != null) ? toolName.trim() : "";
        startDate = (startDate != null) ? startDate.trim() : "";
        endDate = (endDate != null) ? endDate.trim() : "";

        // UI persistent parameters injection
        request.setAttribute("searchedTool", toolName);
        request.setAttribute("startDateRaw", startDate);
        request.setAttribute("endDateRaw", endDate);

        if (toolName.isEmpty()) {
            request.setAttribute("error", "Please select a Tool to view metrics summary.");
            request.getRequestDispatcher("automationDashboard.jsp").forward(request, response);
            return;
        }

        String criteria;
        if (!startDate.isEmpty() && !endDate.isEmpty()) {
            criteria = "Range: " + startDate + " To " + endDate;
        } else {
            criteria = "All Lifetime Lifecycle Runs (By Default)";
        }
        request.setAttribute("selectedCriteria", criteria);

        String procedure = "{CALL GetAutomationSummaryMetrics(?,?,?)}";
        List<Map<String, Object>> summaryList = new ArrayList<>();
        DBConfig dbConfig = new DBConfig();

        try (Connection conn = DriverManager.getConnection(dbConfig.getUrl(), dbConfig.getUsername(), dbConfig.getPassword());
             CallableStatement stmt = conn.prepareCall(procedure)) {

            stmt.setString(1, toolName);
            
            // ✅ Plain string delivery safely bypassed if empty
            if (!startDate.isEmpty() && !endDate.isEmpty()) {
                stmt.setString(2, startDate);
                stmt.setString(3, endDate);
            } else {
                stmt.setString(2, "DEFAULT");
                stmt.setString(3, "DEFAULT");
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("testDate", rs.getString("TestDate"));
                    row.put("totalCases", rs.getInt("TotalCases"));
                    row.put("totalPass", rs.getInt("TotalPass"));
                    row.put("totalFail", rs.getInt("TotalFail"));
                    row.put("passPercentage", rs.getDouble("PassPercentage"));
                    row.put("failPercentage", rs.getDouble("FailPercentage"));
                    summaryList.add(row);
                }
            }
            request.setAttribute("summaryResultsList", summaryList);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database System Error: " + e.getMessage());
        }

        request.getRequestDispatcher("automationDashboard.jsp").forward(request, response);
    }
}