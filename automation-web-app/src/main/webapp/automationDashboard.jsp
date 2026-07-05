<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Automation Dashboard</title>
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, Roboto, sans-serif;
    }

    body {
        background: #f0f2f5;
        padding: 40px 20px;
        color: #333;
    }

    .container {
        max-width: 1200px;
        margin: auto;
        background: white;
        padding: 35px;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
    }

    h2 {
        text-align: center;
        color: #1a237e;
        margin-bottom: 35px;
        font-size: 28px;
        font-weight: 700;
        letter-spacing: 0.5px;
    }

    .form-row {
        display: flex;
        gap: 24px;
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
        padding: 11px 15px;
        border: 1px solid #ced4da;
        border-radius: 6px;
        font-size: 15px;
        color: #495057;
        background-color: #fff;
        transition: border-color 0.2s, box-shadow 0.2s;
    }

    select:focus, input[type=date]:focus {
        border-color: #3f51b5;
        outline: 0;
        box-shadow: 0 0 0 0.2rem rgba(63, 81, 181, 0.25);
    }

    .checkboxArea {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        border: 1px solid #e9ecef;
        margin: 25px 0;
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
        color: #495057;
    }

    input[type="checkbox"] {
        width: 16px;
        height: 16px;
        cursor: pointer;
    }

    button {
        padding: 12px 30px;
        background: #3f51b5;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.2s, transform 0.1s;
        box-shadow: 0 2px 6px rgba(63, 81, 181, 0.3);
    }

    button:hover {
        background: #303f9f;
    }

    button:active {
        transform: scale(0.98);
    }

    .summary-header {
        margin-top: 40px;
        margin-bottom: 25px;
        padding-bottom: 15px;
        border-bottom: 2px solid #e9ecef;
    }

    .summary-header h3 {
        color: #1a237e;
        font-size: 22px;
    }

    .summary-header .meta-info {
        font-size: 14px;
        color: #6c757d;
        margin-top: 5px;
        font-weight: 500;
    }

    .cardContainer {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 20px;
        margin-top: 25px;
    }

    .card {
        padding: 24px 20px;
        border-radius: 10px;
        color: white;
        text-align: center;
        transition: transform 0.3s, box-shadow 0.3s;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.15);
    }

    .card-title {
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        opacity: 0.9;
        font-weight: 600;
        margin-bottom: 12px;
    }

    .card-value {
        font-size: 38px;
        font-weight: 700;
    }

    .blue { background: linear-gradient(135deg, #1e3c72, #2a5298); }
    .green { background: linear-gradient(135deg, #11998e, #38ef7d); }
    .red { background: linear-gradient(135deg, #ff416c, #ff4b2b); }
    .orange { background: linear-gradient(135deg, #ff8c00, #e52d27); }
    .purple { background: linear-gradient(135deg, #6a11cb, #2575fc); }

    .error {
        margin-top: 20px;
        padding: 15px;
        background: #ffebee;
        color: #c62828;
        border-left: 5px solid #d32f2f;
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

<div class="container">

    <h2>📊 Automation Quality Dashboard</h2>

    <form action="getAutomationSummary" method="get">
        <div class="form-row">
            
            <div class="form-group">
                <label>Select Tool</label>
                <select name="toolName" required>
                    <option value="">Select</option>
                    <option value="Automation-Tool-Console" ${searchedTool=='Automation-Tool-Console'?'selected':''}>
                        Automation-Tool-Console
                    </option>
                    <option value="Tosca" ${searchedTool=='Tosca'?'selected':''}>
                        Tosca
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
            <label>
                <input type="checkbox" name="showTotal" value="true" ${not empty showTotal?'checked':''}>
                Total Test Cases
            </label>
            <label>
                <input type="checkbox" name="showPass" value="true" ${not empty showPass?'checked':''}>
                Total Pass
            </label>
            <label>
                <input type="checkbox" name="showFail" value="true" ${not empty showFail?'checked':''}>
                Total Fail
            </label>
            <label>
                <input type="checkbox" name="showPassPer" value="true" ${not empty showPassPer?'checked':''}>
                Pass %
            </label>
            <label>
                <input type="checkbox" name="showFailPer" value="true" ${not empty showFailPer?'checked':''}>
                Fail %
            </label>
        </div>

        <button type="submit">Generate Report</button>
    </form>

    <c:if test="${not empty error}">
        <div class="error">
            ⚠️ ${error}
        </div>
    </c:if>

    <c:if test="${not empty searchedTool}">

        <div class="summary-header">
            <h3>Metrics Summary</h3>
            <div class="meta-info">
                <strong>Tool:</strong> ${searchedTool}  |  <strong>Criteria:</strong> ${selectedCriteria}
            </div>
        </div>

        <div class="cardContainer">

            <c:if test="${not empty showTotal}">
                <div class="card blue">
                    <div class="card-title">Total Test Cases</div>
                    <div class="card-value">${totalCases}</div>
                </div>
            </c:if>

            <c:if test="${not empty showPass}">
                <div class="card green">
                    <div class="card-title">Total Pass</div>
                    <div class="card-value">${totalPass}</div>
                </div>
            </c:if>

            <c:if test="${not empty showFail}">
                <div class="card red">
                    <div class="card-title">Total Fail</div>
                    <div class="card-value">${totalFail}</div>
                </div>
            </c:if>

            <c:if test="${not empty showPassPer}">
                <div class="card orange">
                    <div class="card-title">Pass Percentage</div>
                    <div class="card-value">${passPercentage}%</div>
                </div>
            </c:if>

            <c:if test="${not empty showFailPer}">
                <div class="card purple">
                    <div class="card-title">Fail Percentage</div>
                    <div class="card-value">${failPercentage}%</div>
                </div>
            </c:if>

        </div>
    </c:if>

</div>

</body>
</html>