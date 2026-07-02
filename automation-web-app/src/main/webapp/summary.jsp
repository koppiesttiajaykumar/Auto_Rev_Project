<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Automation Metrics Dashboard</title>
<style>
    body { font-family: Arial, sans-serif; background:#f4f6f9; margin:30px; }
    h2 { color:#333; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); background: #fff;}
    table, th, td { border: 1px solid #ddd; }
    th { background: #007bff; color: white; padding: 12px 10px; text-align: center; font-size: 15px;}
    td { padding: 14px 10px; text-align: center; font-size: 18px; font-weight: bold;}
    select, button { padding: 8px; font-size: 14px; border-radius: 4px; border: 1px solid #ccc;}
    button { background: #007bff; color: white; cursor: pointer; border: none;}
    button:hover { background: #0056b3; }
    .checkbox-panel { margin: 15px 0; padding: 15px; background: #fff; border: 1px solid #ddd; border-radius: 4px; }
    .checkbox-panel label { margin-right: 20px; font-weight: 500; cursor: pointer; }
    .no-data { color: red; font-weight: bold; margin-top: 20px; }
</style>
</head>
<body>

<h2>Automation Quality Dashboard</h2>

<%-- Action is targeted to the new unique servlet URL --%>
<form action="getSummary" method="get">
    <label for="toolName"><strong>Select Tool:</strong></label>
    <select name="toolName" id="toolName" required>
        <option value="">-- Select Option --</option>
        <option value="Tosca" ${searchedTool eq 'Tosca' ? 'selected' : ''}>Tosca</option>
        <option value="Selenium" ${searchedTool eq 'Selenium' ? 'selected' : ''}>Selenium</option>
    </select>

    <div class="checkbox-panel">
        <p style="margin: 0 0 10px 0;"><strong>Select Metrics to Display:</strong></p>
        <label><input type="checkbox" name="showTotal" value="true" ${not empty showTotal ? 'checked' : ''}> Total Test Cases</label>
        <label><input type="checkbox" name="showPass" value="true" ${not empty showPass ? 'checked' : ''}> Total Pass</label>
        <label><input type="checkbox" name="showFail" value="true" ${not empty showFail ? 'checked' : ''}> Total Fail</label>
        <label><input type="checkbox" name="showPassPer" value="true" ${not empty showPassPer ? 'checked' : ''}> Pass Percentage</label>
        <label><input type="checkbox" name="showFailPer" value="true" ${not empty showFailPer ? 'checked' : ''}> Fail Percentage</label>
    </div>

    <button type="submit">Execute Summary Query</button>
</form>

<hr>

<c:if test="${not empty searchedTool}">
    
    <%-- Warning if no checkbox is checked --%>
    <c:if test="${empty showTotal && empty showPass && empty showFail && empty showPassPer && empty showFailPer}">
        <p class="no-data">Please select at least one checkbox metric to display the metrics table.</p>
    </c:if>

    <%-- Render Static Table Layout dynamically based on Checkbox mapping --%>
    <c:if test="${not empty showTotal || not empty showPass || not empty showFail || not empty showPassPer || not empty showFailPer}">
        <h3>Metrics Summary for Tool: <c:out value="${searchedTool}"/></h3>
        
        <table>
            <thead>
                <tr>
                    <c:if test="${not empty showTotal}"><th>Total Test Cases</th></c:if>
                    <c:if test="${not empty showPass}"><th>Total Pass</th></c:if>
                    <c:if test="${not empty showFail}"><th>Total Fail</th></c:if>
                    <c:if test="${not empty showPassPer}"><th>Pass Percentage</th></c:if>
                    <c:if test="${not empty showFailPer}"><th>Fail Percentage</th></c:if>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <c:if test="${not empty showTotal}">
                        <td>${totalCases}</td>
                    </c:if>
                    
                    <c:if test="${not empty showPass}">
                        <td style="color: #28a745;">${totalPass}</td>
                    </c:if>
                    
                    <c:if test="${not empty showFail}">
                        <td style="color: #dc3545;">${totalFail}</td>
                    </c:if>
                    
                    <c:if test="${not empty showPassPer}">
                        <td style="color: #28a745;">${passPercentage}%</td>
                    </c:if>
                    
                    <c:if test="${not empty showFailPer}">
                        <td style="color: #dc3545;">${failPercentage}%</td>
                    </c:if>
                </tr>
            </tbody>
        </table>
    </c:if>
</c:if>

</body>
</html>