package com.automation.servlet;

import com.automation.util.DBConfig;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
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
        String singleDay = request.getParameter("isSingleDay");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Retaining parameters back to JSP UI state
        request.setAttribute("searchedTool", toolName);
        request.setAttribute("isSingleDay", singleDay);
        request.setAttribute("startDateRaw", startDate);
        request.setAttribute("endDateRaw", endDate);

        // UI Metrics Visibility setup flags
        request.setAttribute("showTotal", request.getParameter("showTotal"));
        request.setAttribute("showPass", request.getParameter("showPass"));
        request.setAttribute("showFail", request.getParameter("showFail"));
        request.setAttribute("showPassPer", request.getParameter("showPassPer"));
        request.setAttribute("showFailPer", request.getParameter("showFailPer"));

        if (toolName == null || toolName.trim().isEmpty() || startDate == null || startDate.isEmpty()) {
            request.setAttribute("error", "Please select Tool and Start Date.");
            request.getRequestDispatcher("automationDashboard.jsp").forward(request, response);
            return;
        }

        Timestamp startTimestamp;
        Timestamp endTimestamp;
        String criteria;

        if ("true".equals(singleDay)) {
            startTimestamp = Timestamp.valueOf(startDate + " 00:00:00");
            endTimestamp = Timestamp.valueOf(startDate + " 23:59:59");
            criteria = "Date : " + startDate;
        } else {
            if (endDate == null || endDate.isEmpty()) {
                request.setAttribute("error", "Please select End Date.");
                request.getRequestDispatcher("automationDashboard.jsp").forward(request, response);
                return;
            }
            startTimestamp = Timestamp.valueOf(startDate + " 00:00:00");
            endTimestamp = Timestamp.valueOf(endDate + " 23:59:59");
            criteria = "Range : " + startDate + " To " + endDate;
        }

        request.setAttribute("selectedCriteria", criteria);

        String procedure = "{CALL GetAutomationSummaryMetrics(?,?,?)}";
        List<Map<String, Object>> summaryList = new ArrayList<>();

        // 🎯 Instantiating DBConfig exactly the way you designed it
        DBConfig dbConfig = new DBConfig();

        // Establishing Connection safely using your non-static methods
        try (Connection conn = DriverManager.getConnection(
                    dbConfig.getUrl(), 
                    dbConfig.getUsername(), 
                    dbConfig.getPassword());
             CallableStatement stmt = conn.prepareCall(procedure)) {

            stmt.setString(1, toolName);
            stmt.setTimestamp(2, startTimestamp);
            stmt.setTimestamp(3, endTimestamp);
            
            try (ResultSet rs = stmt.executeQuery()) {
                // Fetching the structured layout rows map loop
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
            request.setAttribute("error", "Database Error: " + e.getMessage());
        }

        request.getRequestDispatcher("automationDashboard.jsp").forward(request, response);
    }
}