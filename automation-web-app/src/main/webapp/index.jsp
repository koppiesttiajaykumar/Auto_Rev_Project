<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Automation Dashboard</title>

<style>
    /* 🎨 Global Settings */
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
        border-bottom: 3px solid #00f2fe; /* Glowing cyan underline */
    }

    /* Main Content Wrapper Box */
    .main-content {
        max-width: 95%; /* Screen ke according automatic adjust hoga */
        margin: 40px auto;
        background: white;
        padding: 35px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
    }

    h2 {
        color: #2c3e50;
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 25px;
    }

    h3 {
        color: #2c3e50;
        margin-top: 25px;
        margin-bottom: 15px;
    }

    /* Form Layout containing the Select Drop-down */
    .search-box {
        display: flex;
        gap: 15px;
        margin-bottom: 25px;
        align-items: center;
    }

    /* 🎯 Stylish Dropdown Menu */
    select {
        padding: 11px 15px;
        width: 320px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 15px;
        color: #495057;
        background-color: #fff;
        cursor: pointer;
        transition: border-color 0.15s;
    }

    select:focus {
        border-color: #0056b3;
        outline: 0;
    }

    button {
        padding: 11px 25px;
        background: #0056b3;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.15s;
    }

    button:hover {
        background: #004085;
    }

    /* 📦 Table ko automatic fit karne wala dynamic wrapper */
    .table-responsive {
        width: 100%;
        overflow-x: auto; /* Choti screen par page nahi hilega, table ke andar scroll chalega */
        margin-top: 20px;
        border-radius: 4px;
        border: 1px solid #dee2e6;
    }

    /* 📊 Updated Crisp Table Structure */
    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        table-layout: auto;
    }

    table th, table td {
        border: 1px solid #dee2e6;
        padding: 12px 10px;
        text-align: center;
        font-size: 14px;
        word-wrap: break-word; /* Lambe text ko tod kar niche le aayega */
        max-width: 300px; /* Space compression ke liye target lock */
    }

    th {
        background-color: #f1f3f5;
        color: #343a40;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        white-space: nowrap; /* Header broken nahi dikhenge */
    }

    td {
        color: #495057;
    }

    tr:nth-child(even) {
        background-color: #f8f9fa;
    }
    
    tr:hover {
        background-color: #f1f3f5;
    }

    /* Test case description readable look ke liye align left */
    table td:nth-child(3) {
        text-align: left;
        font-size: 13.5px;
        line-height: 1.4;
    }
</style>

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

<div class="main-content">

    <h2>Automation Dashboard</h2>

    <form action="getResults" method="get" class="search-box">
        
        <select name="toolName" required>
            <option value="">-- Select Tool / Environment --</option>
            <option value="Automation-Tool" ${searchedTool == 'Automation-Tool' ? 'selected' : ''}>
                Automation-Tool
            </option>
            <option value="Selenium" ${searchedTool == 'Selenium' ? 'selected' : ''}>
                Selenium
            </option>
        </select>
        
        <button type="submit">Search</button>
    </form>

    <hr style="border: 0; border-top: 1px solid #dee2e6; margin: 25px 0;">

    <c:if test="${not empty results}">

        <h3>
        Results for : <c:out value="${searchedTool}"/>
        </h3>

        <div class="table-responsive">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Status</th>
                        <th>Test Case</th>
                        <th>Module Name</th>
                        <th>Suite Name</th>
                        <th>Time (Sec)</th>
                        <th>Environment</th>
                        <th>Test Date</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="row" items="${results}">
                        <tr>
                            <td>${row.id}</td>
                            <td style="font-weight: 700; color: ${row.status.equalsIgnoreCase('pass') || row.status.equalsIgnoreCase('P') || row.status.equalsIgnoreCase('Y') ? '#2b8a3e' : '#c92a2a'};">
                                ${row.status}
                            </td>
                            <td>${row.testCase}</td>
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