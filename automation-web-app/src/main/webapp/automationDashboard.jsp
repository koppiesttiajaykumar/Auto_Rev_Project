<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Automation Summary Dashboard</title>

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
    }

    body {
        background: #f8f9fa;
        color: #333;
    }

    .navbar {
        background-color: #1a237e; 
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 0 40px;
        height: 60px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: sticky;
        top: 0;
        z-index: 1000;
    }

    .navbar-brand {
        color: #ffffff;
        font-size: 20px;
        font-weight: 700;
        letter-spacing: 0.5px;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .navbar-links {
        display: flex;
        list-style: none;
        gap: 10px;
        height: 100%;
    }

    .navbar-links li { height: 100%; }

    .navbar-links a {
        color: #cbd5e1;
        text-decoration: none;
        font-size: 15px;
        font-weight: 500;
        padding: 0 20px;
        display: flex;
        align-items: center;
        height: 100%;
        transition: all 0.2s ease;
        border-bottom: 3px solid transparent;
    }

    .navbar-links a:hover, .navbar-links a.active {
        color: #ffffff;
        background-color: rgba(255, 255, 255, 0.1);
        border-bottom: 3px solid #00f2fe; 
    }

    .container {
        max-width: 1250px;
        margin: 40px auto;
        background: white;
        padding: 35px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    h2 {
        text-align: center;
        color: #2c3e50;
        margin-bottom: 35px;
        font-size: 26px;
        font-weight: 700;
    }

    .form-row {
        display: flex;
        gap: 20px;
        flex-wrap: wrap;
        align-items: flex-end;
        margin-bottom: 25px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
        flex: 1;
        min-width: 220px;
    }

    label {
        font-weight: 600;
        margin-bottom: 8px;
        color: #495057;
        font-size: 14px;
    }

    select, input[type=date] {
        width: 100%;
        padding: 10px 14px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 15px;
        color: #495057;
        background-color: #fff;
    }

    .btn-actions-container {
        display: flex;
        gap: 12px;
    }

    button[type="submit"] {
        padding: 12px 30px;
        background: #0056b3;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.15s;
    }

    button[type="submit"]:hover { background: #004085; }

    .btn-clear-date {
        padding: 12px 20px;
        background: #e2e8f0;
        color: #475569;
        border: 1px solid #cbd5e1;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
    }
    .btn-clear-date:hover { background: #cbd5e1; color: #1e293b; }

    .summary-header { margin-top: 40px; margin-bottom: 15px; }
    .summary-header h3 { color: #2c3e50; font-size: 20px; }
    .summary-header .meta-info { font-size: 14px; color: #6c757d; margin-top: 4px; }

    .table-responsive {
        width: 100%;
        overflow-x: auto;
        margin-top: 15px;
        border: 1px solid #dee2e6;
        border-radius: 4px;
    }

    .report-table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
    }

    .report-table th, .report-table td {
        border: 1px solid #dee2e6;
        padding: 14px 16px;
        text-align: center;
    }

    .report-table th {
        background-color: #f1f3f5;
        color: #343a40;
        font-size: 14px;
        font-weight: 600;
        text-transform: uppercase;
        white-space: nowrap;
    }

    .report-table td { font-size: 16px; font-weight: 700; color: #212529; }
    .text-pass { color: #2b8a3e !important; }
    .text-fail { color: #c92a2a !important; }

    .error {
        margin-top: 20px;
        padding: 12px 15px;
        background: #fff5f5;
        color: #c92a2a;
        border: 1px solid #ffa8a8;
        border-radius: 4px;
        font-weight: 600;
    }
</style>

<script>
    // 🧹 Clears inputs and auto-submits to load all day logs natively
    function clearDateAndReload() {
        document.getElementById("startDateInput").value = "";
        document.getElementById("endDateInput").value = "";
        
        // Form references selection
        var currentTool = document.getElementsByName("toolName")[0].value;
        if(currentTool !== "") {
            document.getElementById("dashboardForm").submit();
        }
    }

    // Boundary consistency logic
    function checkFormValidation(event) {
        var start = document.getElementById("startDateInput").value;
        var end = document.getElementById("endDateInput").value;

        if ((start === "" && end !== "") || (start !== "" && end === "")) {
            alert("Kripya dono dates select karein ya dono ko khali (blank) chhodein.");
            event.preventDefault();
            return false;
        }
        return true;
    }
</script>
</head>
<body>

<nav class="navbar">
    <a class="navbar-brand" href="#">⚙️ QE Automation Hub</a>
    <ul class="navbar-links">
        <li><a href="automationDashboard.jsp" class="active">🏠 Dashboard</a></li>
        <li><a href="bulkUpload.jsp">📤 Bulk Upload</a></li>
        <li><a href="index.jsp">📊 Advanced Reports</a></li>
    </ul>
</nav>

<div class="container">

    <h2>📈 Automation Quality Dashboard</h2>

    <form id="dashboardForm" action="getAutomationSummary" method="get" onsubmit="return checkFormValidation(event)">
        <div class="form-row">
            
            <div class="form-group">
                <label>Select Tool / Module</label>
                <select name="toolName" required>
                    <option value="">-- Select Tool --</option>
                    <option value="Automation-Tool" ${searchedTool=='Automation-Tool'?'selected':''}>Automation-Tool</option>
                    <option value="Selenium" ${searchedTool=='Selenium'?'selected':''}>Selenium</option>
                    <option value="Tosca" ${searchedTool == 'Tosca' ? 'selected' : ''}>Tosca</option>
                </select>
            </div>

            <div class="form-group">
                <label>Start Date</label>
                <input type="date" id="startDateInput" name="startDate" value="${startDateRaw}">
            </div>

            <div class="form-group">
                <label>End Date</label>
                <input type="date" id="endDateInput" name="endDate" value="${endDateRaw}">
            </div>
            
            <div class="form-group btn-actions-container">
                <button type="button" class="btn-clear-date" onclick="clearDateAndReload()">Clear Dates</button>
                <button type="submit">Generate Report</button>
            </div>
            
        </div>
    </form>

    <c:if test="${not empty error}">
        <div class="error">⚠️ ${error}</div>
    </c:if>

    <c:if test="${not empty searchedTool}">
        
        <div class="summary-header">
            <h3>📊 Date-wise Metric Summary</h3>
            <div class="meta-info">
                <strong>Target Application:</strong> ${searchedTool}  |  <strong>Applied Boundary:</strong> ${selectedCriteria}
            </div>
        </div>

        <div class="table-responsive">
            <table class="report-table">
                <thead>
                    <tr>
                        <th>Execution Date</th>
                        <th>Total Cases</th>
                        <th>Total Pass</th>
                        <th>Total Fail</th>
                        <th>Pass %</th>
                        <th>Fail %</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${summaryResultsList}">
                        <tr>
                            <td style="color: #2c3e50; font-weight: 600;">${row.testDate}</td>
                            <td>${row.totalCases}</td>
                            <td class="text-pass">${row.totalPass}</td>
                            <td class="text-fail">${row.totalFail}</td>
                            <td class="text-pass">${row.passPercentage}%</td>
                            <td class="text-fail">${row.failPercentage}%</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        
        <c:if test="${empty summaryResultsList}">
            <div style="text-align:center; padding: 20px; color:#7f8c8d; font-weight:600;">
                📭 Selected range data scope returned empty metrics set.
            </div>
        </c:if>
            
    </c:if>

</div>

</body>
</html>