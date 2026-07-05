package com.automation.servlet;

import com.automation.util.DBConfig;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/getAutomationSummary")
public class AutomationDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DBConfig dbConfig;

    @Override
    public void init() throws ServletException {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            dbConfig = new DBConfig();

        } catch (ClassNotFoundException e) {

            throw new ServletException("Unable to load MySQL Driver", e);

        }

    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String toolName = request.getParameter("toolName");

        String singleDay = request.getParameter("isSingleDay");

        String startDate = request.getParameter("startDate");

        String endDate = request.getParameter("endDate");

        request.setAttribute("searchedTool", toolName);

        request.setAttribute("isSingleDay", singleDay);

        request.setAttribute("startDateRaw", startDate);

        request.setAttribute("endDateRaw", endDate);

        request.setAttribute("showTotal",
                request.getParameter("showTotal"));

        request.setAttribute("showPass",
                request.getParameter("showPass"));

        request.setAttribute("showFail",
                request.getParameter("showFail"));

        request.setAttribute("showPassPer",
                request.getParameter("showPassPer"));

        request.setAttribute("showFailPer",
                request.getParameter("showFailPer"));

        if (toolName == null || toolName.trim().isEmpty()) {

            request.setAttribute("error",
                    "Please select Tool.");

            request.getRequestDispatcher(
                    "automationDashboard.jsp")
                    .forward(request, response);

            return;

        }

        if (startDate == null || startDate.isEmpty()) {

            request.setAttribute("error",
                    "Please select Start Date.");

            request.getRequestDispatcher(
                    "automationDashboard.jsp")
                    .forward(request, response);

            return;

        }

        Timestamp startTimestamp;

        Timestamp endTimestamp;

        String criteria;

        if ("true".equals(singleDay)) {

            startTimestamp =
                    Timestamp.valueOf(startDate + " 00:00:00");

            endTimestamp =
                    Timestamp.valueOf(startDate + " 23:59:59");

            criteria = "Date : " + startDate;

        }

        else {

            if (endDate == null || endDate.isEmpty()) {

                request.setAttribute("error",
                        "Please select End Date.");

                request.getRequestDispatcher(
                        "automationDashboard.jsp")
                        .forward(request, response);

                return;

            }

            startTimestamp =
                    Timestamp.valueOf(startDate + " 00:00:00");

            endTimestamp =
                    Timestamp.valueOf(endDate + " 23:59:59");

            criteria =
                    "Range : "
                    + startDate
                    + " To "
                    + endDate;

        }

        request.setAttribute("selectedCriteria", criteria);

        String procedure =
                "{CALL GetAutomationSummaryMetrics(?,?,?)}";

        try (

                Connection conn =
                        DriverManager.getConnection(

                                dbConfig.getUrl(),

                                dbConfig.getUsername(),

                                dbConfig.getPassword());

                CallableStatement stmt =
                        conn.prepareCall(procedure);

        ) {

            stmt.setString(1, toolName);

            stmt.setTimestamp(2, startTimestamp);

            stmt.setTimestamp(3, endTimestamp);
            
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {

                request.setAttribute(
                        "totalCases",
                        rs.getInt("TotalCases"));

                request.setAttribute(
                        "totalPass",
                        rs.getInt("TotalPass"));

                request.setAttribute(
                        "totalFail",
                        rs.getInt("TotalFail"));

                request.setAttribute(
                        "passPercentage",
                        rs.getDouble("PassPercentage"));

                request.setAttribute(
                        "failPercentage",
                        rs.getDouble("FailPercentage"));

            }
            else {

                request.setAttribute("totalCases",0);
                request.setAttribute("totalPass",0);
                request.setAttribute("totalFail",0);
                request.setAttribute("passPercentage",0);
                request.setAttribute("failPercentage",0);

            }

            rs.close();

        }

        catch (SQLException e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    e.getMessage());

        }

        request.getRequestDispatcher(
                "automationDashboard.jsp")
                .forward(request,response);

    }

}