<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Automation Dashboard</title>

<style>
body{
    font-family: Arial, sans-serif;
    background:#f4f6f9;
    margin:30px;
}

h2{
    color:#333;
}

table{
    width:100%;
    border-collapse:collapse;
    margin-top:20px;
}

table,th,td{
    border:1px solid #ddd;
}

th{
    background:#007bff;
    color:white;
    padding:10px;
}

td{
    padding:8px;
}

tr:nth-child(even){
    background:#f2f2f2;
}

input[type=text]{
    padding:8px;
    width:250px;
}

button{
    padding:8px 15px;
    background:#007bff;
    color:white;
    border:none;
    cursor:pointer;
}

button:hover{
    background:#0056b3;
}
</style>

</head>

<body>

<h2>Automation Dashboard</h2>

<form action="getResults" method="get">
    <input type="text"
           name="toolName"
           placeholder="Enter Tool Name"
           value="${searchedTool}"
           required>
    <button type="submit">Search</button>
</form>

<hr>

<c:if test="${not empty results}">

    <h3>
    Results for : <c:out value="${searchedTool}"/>
    </h3>

    <table>
        <tr>
            <th>ID</th>
            <th>Class Name</th>
            <th>Test Case Name</th>
            <th>Status</th> <th>Test Case</th>
            <th>Module</th>
            <th>Suite</th>
            <th>Browser</th>
            <th>Build No</th>
            <th>Time (Sec)</th>
            <th>Environment</th>
            <th>Date</th>
        </tr>

        <c:forEach var="row" items="${results}">
            <tr>
                <td>${row.id}</td>
                <td>${row.className}</td>
                <td>${row.testCaseName}</td>
                <td>${row.status}</td> <td>${row.testCase}</td>
                <td>${row.moduleName}</td>
                <td>${row.suiteName}</td>
                <td>${row.operatingBrowser}</td>
                <td>${row.buildNo}</td>
                <td>${row.timeInSeconds}</td>
                <td>${row.environment}</td>
                <td>${row.testDate}</td>
            </tr>
        </c:forEach>
    </table>

</c:if>

<c:if test="${empty results && not empty searchedTool}">
    <h3 style="color:red;">
    No Records Found
    </h3>
</c:if>

</body>
</html>