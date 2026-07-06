<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Automation Summary Dashboard</title>

<style>
    /* 🎨 Reset & Base Setup */
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

    /* 🧭 Corporate Level Top Navigation Bar */
    .navbar {
        background-color: #1a237e; /* Royal Corporate Blue */
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

    .navbar-links li {
        height: 100%;
    }

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
        border-bottom: 3px solid #00f2fe; /* Glowing Cyan line */
    }

    /* 📦 Main Frame Card Layout */
    .container {
        max-width: 1200px;
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

    /* 🛠 Form Configurations Layout */
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

    .form-group.checkbox-inline {
        flex-direction: row;
        align-items: center;
        min-width: auto;
        padding-bottom: 12px;
    }

    label {
        font-weight: 600;
        margin-bottom: 8px;
        color: #495057;
        font-size: 14px;
    }

    .form-group.checkbox-inline label {
        margin-bottom: 0;
        display: flex;
        align-items: center;
        gap: 8px;
        cursor: pointer;
        font-size: 15px;
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

    /* Metrics Section Area */
    .checkboxArea {
        background: #fdfdfd;
        padding: 15px 20px;
        border-radius: 4px;
        border: 1px solid #e9ecef;
        margin: 20px 0;
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
    }

    .checkboxArea p {
        width: 100%;
        font-weight: 600;
        color: #495057;
        font-size: 14px;
        margin-bottom: -5px;
    }

    .checkboxArea label {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 500;
        cursor: pointer;
        font-size: 15px;
    }

    button {
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

    button:hover { background: #004085; }

    /* 📊 Clean & Crisp Responsive Grid Table Layout */
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
function toggleDate(){
    var single = document.getElementById("isSingleDay").checked;
    var endDiv = document.getElementById("endDateDiv");
    var endInput = document.getElementById("endDateInput");
    
    if(single){
        endDiv.style.display = "none";
        endInput.removeAttribute("required");
    } else {
        endDiv.style.display = "flex";
        endInput.setAttribute("required", "required");
    }
}
window.onload = toggleDate;
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

    <form action="getAutomationSummary" method="get">
        <div class="form-row">
            
            <div class="form-group">
                <label>Select Tool / Module</label>
                <select name="toolName" required>
                    <option value="">-- Select Tool --</option>
                    <option value="Automation-Tool" ${searchedTool=='Automation-Tool'?'selected':''}>
                        Automation-Tool
                    </option>
                    <option value="Selenium" ${searchedTool=='Selenium'?'selected':''}>
                        Selenium
                    </option>
                </select>
            </div>

            <div class="form-group checkbox-inline">
                <label>
                    <input type="checkbox" id="isSingleDay" name="isSingleDay" value="true" onchange="toggleDate()" ${not empty isSingleDay?'checked':''}>
                    Single Day
                </label>
            </div>

            <div class="form-group">
                <label>Start Date</label>
                <input type="date" name="startDate" value="${startDateRaw}" required>
            </div>

            <div class="form-group" id="endDateDiv">
                <label>End Date</label>
                <input type="date" id="endDateInput" name="endDate" value="${endDateRaw}">
            </div>
            
        </div>

        <div class="checkboxArea">
            <p>Select Metrics to Display</p>
            <label><input type="checkbox" name="showTotal" value="true" ${not empty showTotal?'checked':''}> Total Test Cases</label>
            <label><input type="checkbox" name="showPass" value="true" ${not empty showPass?'checked':''}> Total Pass</label>
            <label><input type="checkbox" name="showFail" value="true" ${not empty showFail?'checked':''}> Total Fail</label>
            <label><input type="checkbox" name="showPassPer" value="true" ${not empty showPassPer?'checked':''}> Pass %</label>
            <label><input type="checkbox" name="showFailPer" value="true" ${not empty showFailPer?'checked':''}> Fail %</label>
        </div>

        <button type="submit">Generate Report</button>
    </form>

    <c:if test="${not empty error}">
        <div class="error">
            ⚠️ ${error}
        </div>
    </c:if>

    <c:if test="${not empty searchedTool}">
        
        <c:if test="${empty showTotal && empty showPass && empty showFail && empty showPassPer && empty showFailPer}">
            <div class="error" style="background:#fff9db; color:#e67e22; border-color:#ffe066;">
                ℹ️ Table hide context active. Please choose at least one analytical metric above to plot columns.
            </div>
        </c:if>

        <c:if test="${not empty showTotal || not empty showPass || not empty showFail || not empty showPassPer || not empty showFailPer}">
            
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
                            <c:if test="${not empty showTotal}"><th>Total Cases</th></c:if>
                            <c:if test="${not empty showPass}"><th>Total Pass</th></c:if>
                            <c:if test="${not empty showFail}"><th>Total Fail</th></c:if>
                            <c:if test="${not empty showPassPer}"><th>Pass %</th></c:if>
                            <c:if test="${not empty showFailPer}"><th>Fail %</th></c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${summaryResultsList}">
                            <tr>
                                <td style="color: #2c3e50; font-weight: 600;">${row.testDate}</td>
                                
                                <c:if test="${not empty showTotal}">
                                    <td>${row.totalCases}</td>
                                </c:if>
                                
                                <c:if test="${not empty showPass}">
                                    <td class="text-pass">${row.totalPass}</td>
                                </c:if>
                                
                                <c:if test="${not empty showFail}">
                                    <td class="text-fail">${row.totalFail}</td>
                                </c:if>
                                
                                <c:if test="${not empty showPassPer}">
                                    <td class="text-pass">${row.passPercentage}%</td>
                                </c:if>
                                
                                <c:if test="${not empty showFailPer}">
                                    <td class="text-fail">${failPercentage}%</td>
                                </c:if>
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
    </c:if>

</div>

</body>
</html>