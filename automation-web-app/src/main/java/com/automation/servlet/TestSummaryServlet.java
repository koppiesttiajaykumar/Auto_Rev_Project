package com.automation.servlet;

//import com.automation.model.TestResult;
import com.automation.util.DBConfig;
import java.io.IOException;
import java.sql.*;
//import java.util.ArrayList;
//import java.util.List; 
import java.util.Optional;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/getSummary")
public class TestSummaryServlet extends HttpServlet {
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String toolName = Optional.ofNullable(request.getParameter("toolName")).map(String::trim).orElse("");
        
        // Checkboxes states fetch karna
        String showTotal = request.getParameter("showTotal");
        String showPass = request.getParameter("showPass");
        String showFail = request.getParameter("showFail");
        String showPassPer = request.getParameter("showPassPer");
        String showFailPer = request.getParameter("showFailPer");

        int totalCases = 0;
        int totalPass = 0;
        int totalFail = 0;
        double passPercentage = 0.0;
        double failPercentage = 0.0;

        if (!toolName.isEmpty()) {
            String callProcedure = "{CALL GetToolResultsWithMetrics(?)}";

            try (Connection conn = DriverManager.getConnection(dbConfig.getUrl(), dbConfig.getUsername(), dbConfig.getPassword());
                 CallableStatement stmt = conn.prepareCall(callProcedure)) {
                
                stmt.setString(1, toolName);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    // Hame badi table nahi chahiye, toh bas pehli row se metrics nikal lenge
                    if (rs.next()) {
                        totalCases = rs.getInt("TotalCases");
                        totalPass = rs.getInt("TotalPass");
                        totalFail = rs.getInt("TotalFail");
                        passPercentage = rs.getDouble("PassPercentage");
                        failPercentage = rs.getDouble("FailPercentage");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Send counts to JSP
        request.setAttribute("searchedTool", toolName);
        request.setAttribute("totalCases", totalCases);
        request.setAttribute("totalPass", totalPass);
        request.setAttribute("totalFail", totalFail);
        request.setAttribute("passPercentage", passPercentage);
        request.setAttribute("failPercentage", failPercentage);

        // Keep UI checkbox state retained
        request.setAttribute("showTotal", showTotal);
        request.setAttribute("showPass", showPass);
        request.setAttribute("showFail", showFail);
        request.setAttribute("showPassPer", showPassPer);
        request.setAttribute("showFailPer", showFailPer);

        request.getRequestDispatcher("summary.jsp").forward(request, response);
    }
}