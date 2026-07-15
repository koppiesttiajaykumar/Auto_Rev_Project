<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Automation Dashboard</title>

<style>
    /* 🎨 Global Layout Definitions */
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

    /* 🧭 Premium Modern Navigation Bar Styling */
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

    /* Main Content Wrapper Box */
    .main-content {
        width: 98%;           
        max-width: 1650px; 
        margin: 20px auto;
        background: white;
        padding: 25px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    h2 { color: #2c3e50; font-size: 24px; font-weight: 700; margin-bottom: 25px; }
    h3 { color: #2c3e50; margin-top: 25px; margin-bottom: 15px; }

    /* Form Design setup */
    .search-box {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 25px;
        align-items: center;
    }

    select, input[type="text"], input[type="date"] {
        padding: 10px 12px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 14px;
        color: #495057;
        background-color: #fff;
    }
    
    select { width: 200px; cursor: pointer; }
    input[type="text"] { width: 240px; }

    button[type="submit"] {
        padding: 10px 22px;
        background: #0056b3;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
    }

    button[type="submit"]:hover { background: #004085; }
    
    .btn-clear-date {
        padding: 10px 18px;
        background: #e2e8f0;
        color: #475569;
        border: 1px solid #cbd5e1;
        border-radius: 4px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
    }
    
    .btn-clear-date:hover { background: #cbd5e1; color: #1e293b; }

    .search-badge-info {
        background: #f1f5f9;
        border-left: 5px solid #0056b3;
        padding: 12px 20px;
        margin-bottom: 15px;
        font-size: 15px;
        font-weight: 600;
        color: #334155;
        border-radius: 4px;
    }
    .search-badge-info span { color: #c92a2a; background: #fee2e2; padding: 2px 8px; border-radius: 4px; }

    .summary-container { display: flex; gap: 20px; margin-bottom: 25px; }
    .card {
        padding: 12px 20px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 700;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        display: flex;
        flex-direction: column;
        min-width: 130px;
    }
    .card .count { font-size: 24px; font-weight: 800; }
    .card-pass { background-color: #ebfbee; color: #2b8a3e; border: 1px solid #b2f2bb; }
    .card-fail { background-color: #fff5f5; color: #c92a2a; border: 1px solid #ffa8a8; }

    /* 🔥 FIXED RESPONSIVE TABLE CONFIGURATION (No Slide/Scroll bars) */
    .table-responsive {
        width: 100%;
        overflow-x: hidden; /* Horizontal scroll ko permanently hide kiya */
        margin-top: 20px;
        border-radius: 4px;
        border: 1px solid #dee2e6;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        table-layout: fixed; /* Pure layout width ko strictly bind karega */
    }

    table th, table td {
        border: 1px solid #dee2e6;
        padding: 10px 6px;   /* Padding compressed taaki text wrap ho sake */
        text-align: center;
        font-size: 13px;     /* Optimal read-size text fit layout */
        word-wrap: break-word; /* Lambe class aur method names auto down-wrap honge */
        vertical-align: middle;
    }

    th {
        background-color: #f1f3f5;
        color: #343a40;
        font-weight: 600;
        text-transform: uppercase;
    }

    /* 🎯 Dynamic Structural Column Width Mapping */
    table th:nth-child(1), table td:nth-child(1) { width: 5%; }   /* ID */
    table th:nth-child(2), table td:nth-child(2) { width: 7%; }   /* Status */
    table th:nth-child(3), table td:nth-child(3) { width: 26%; text-align: left; } /* Test Case Name */
    table th:nth-child(4), table td:nth-child(4) { width: 24%; text-align: left; } /* Test Case */
    table th:nth-child(5), table td:nth-child(5) { width: 12%; }  /* Module Name */
    table th:nth-child(6), table td:nth-child(6) { width: 10%; }  /* Suite Name */
    table th:nth-child(7), table td:nth-child(7) { width: 5%; }   /* Time (Sec) */
    table th:nth-child(8), table td:nth-child(8) { width: 5%; }   /* Environment */
    table th:nth-child(9), table td:nth-child(9) { width: 6%; }   /* Test Date */

    tr:nth-child(even) { background-color: #f8f9fa; }
    tr:hover { background-color: #f1f3f5; }
</style>

<script>
    function resetDatePickers() {
        document.getElementById("startDateInput").value = "";
        document.getElementById("endDateInput").value = "";
    }

    function validateAndSubmit(event) {
        var startDate = document.getElementById("startDateInput").value;
        var endDate = document.getElementById("endDateInput").value;

        if ((startDate === "" && endDate !== "") || (startDate !== "" && endDate === "")) {
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
        <li><a href="automationDashboard.jsp">🏠 Dashboard</a></li>
        <li><a href="bulkUpload.jsp">📤 Bulk Upload</a></li>
        <li><a href="index.jsp" class="active">📊 Advanced Reports</a></li>
    </ul>
</nav>

<div class="main-content">
    <h2>Advanced Automation Reports</h2>

    <form action="getResults" method="get" class="search-box" onsubmit="return validateAndSubmit(event)">
        <select name="toolName" required>
            <option value="">-- Select Tool / Environment --</option>
            <option value="Automation-Tool" ${searchedTool == 'Automation-Tool' ? 'selected' : ''}>Automation-Tool</option>
            <option value="Selenium" ${searchedTool == 'Selenium' ? 'selected' : ''}>Selenium</option>
            <option value="Tosca" ${searchedTool == 'Tosca' ? 'selected' : ''}>Tosca</option>
        </select>

        <select name="statusFilter">
            <option value="ALL" ${statusFilter == 'ALL' ? 'selected' : ''}>-- All Status --</option>
            <option value="PASS" ${statusFilter == 'PASS' ? 'selected' : ''}>PASS</option>
            <option value="FAIL" ${statusFilter == 'FAIL' ? 'selected' : ''}>FAIL</option>
        </select>

        <input type="text" name="searchTestCaseName" placeholder="Search by Test Case Name..." value="${searchTestCaseName}">

        <input type="date" id="startDateInput" name="startDate" value="${startDate}">
        <input type="date" id="endDateInput" name="endDate" value="${endDate}">
        
        <button type="button" class="btn-clear-date" onclick="resetDatePickers()">Clear Dates</button>
        <button type="submit">Search</button>
    </form>

    <hr style="border: 0; border-top: 1px solid #dee2e6; margin: 25px 0;">

    <c:if test="${not empty displaySearchedName && not empty results}">
        <div class="search-badge-info">
            Filtered Metrics for Test Case: <span><c:out value="${displaySearchedName}"/></span>
        </div>
        <div class="summary-container">
            <div class="card card-pass">
                <span>TOTAL PASS</span>
                <span class="count">${passCount}</span>
            </div>
            <div class="card card-fail">
                <span>TOTAL FAIL</span>
                <span class="count">${failCount}</span>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty results}">
        <h3>Results for: <c:out value="${searchedTool}"/></h3>
        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Status</th>
                        <th>Test Case Name</th>
                        <th>Test Case</th>
                        <th>Module Name</th>
                        <th>Suite Name</th>
                        <th>Time (Sec)</th>
                        <th>Env</th>
                        <th>Test Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${results}">
                        <tr>
                            <td>${row.id}</td>
                            <c:set var="statusUpper" value="${row.status.toUpperCase().trim()}" />
                            <c:choose>
                                <c:when test="${statusUpper == 'N' || statusUpper == 'PASS' || statusUpper == 'P'}">
                                    <td style="font-weight: 700; color: #2b8a3e;">PASS</td>
                                </c:when>
                                <c:when test="${statusUpper == 'Y' || statusUpper == 'FAIL' || statusUpper == 'F'}">
                                    <td style="font-weight: 700; color: #c92a2a;">FAIL</td>
                                </c:when>
                                <c:otherwise>
                                    <td style="font-weight: 700; color: #495057;">${row.status}</td>
                                </c:otherwise>
                            </c:choose>
                            <td style="text-align: left;">${row.testCaseName}</td>
                            <td style="text-align: left;">${row.testCase}</td>
                            <td>${row.moduleName}</td>
                            <td>${row.suiteName}</td>
                            <td>${row.timeInSeconds}</td>
                            <td>${row.environment}</td>
                            <td>${row.testDate}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

    <c:if test="${empty results && not empty searchedTool}">
        <h3 style="color: #c92a2a; background: #fff5f5; padding: 12px; border: 1px solid #ffa8a8; border-radius: 4px; font-size: 16px; font-weight: 600;">
        ⚠️ No Records Found
        </h3>
    </c:if>
</div>
</body>
</html>