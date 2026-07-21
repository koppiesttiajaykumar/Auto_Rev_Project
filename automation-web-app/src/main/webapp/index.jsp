<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Advanced Automation Reports</title>

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

    select, input[type="text"], input[type="date"], .searchable-select-wrapper input {
        padding: 10px 12px;
        border: 1px solid #ced4da;
        border-radius: 4px;
        font-size: 14px;
        color: #495057;
        background-color: #fff;
    }
    
    select { width: 220px; cursor: pointer; }
    input[type="text"] { width: 240px; }

    /* 🔍 Real-time Searchable Dropdown Style Adjustments */
    .searchable-select-wrapper {
        position: relative;
        display: inline-block;
        width: 230px;
    }

    .searchable-select-wrapper input {
        width: 100%;
        cursor: text; 
        background-image: url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23495057%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E');
        background-repeat: no-repeat;
        background-position: right 12px top 50%;
        background-size: 10px auto;
        padding-right: 30px;
    }

    .select-dropdown-list {
        display: none;
        position: absolute;
        top: 100%;
        left: 0;
        right: 0;
        background: white;
        border: 1px solid #cbd5e1;
        border-radius: 4px;
        max-height: 200px;
        overflow-y: auto;
        z-index: 1010;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }

    .select-dropdown-list div {
        padding: 10px 12px;
        cursor: pointer;
        font-size: 14px;
        color: #334155;
    }

    .select-dropdown-list div:hover {
        background-color: #f1f5f9;
        color: #1a237e;
    }

    /* Message fallback inside selection panel */
    .no-match-found {
        padding: 10px 12px;
        font-size: 13px;
        color: #94a3b8;
        font-style: italic;
        background: #f8fafc;
        text-align: center;
    }

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

    /* 🔥 FIXED RESPONSIVE TABLE CONFIGURATION */
    .table-responsive {
        width: 100%;
        overflow-x: hidden; 
        margin-top: 20px;
        border-radius: 4px;
        border: 1px solid #dee2e6;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        background: #fff;
        table-layout: fixed; 
    }

    table th, table td {
        border: 1px solid #dee2e6;
        padding: 10px 6px;   
        text-align: center;
        font-size: 13px;     
        word-wrap: break-word; 
        vertical-align: middle;
    }

    th {
        background-color: #f1f3f5;
        color: #343a40;
        font-weight: 600;
        text-transform: uppercase;
    }

    /* 🎯 Dynamic Structural Column Width Mapping */
    table th:nth-child(1), table td:nth-child(1)   { width: 4%; }   /* ID */
    table th:nth-child(2), table td:nth-child(2)   { width: 6%; }   /* Status */
    table th:nth-child(3), table td:nth-child(3)   { width: 22%; text-align: left; } /* Test Case Name */
    table th:nth-child(4), table td:nth-child(4)   { width: 20%; text-align: left; } /* Test Case Description */
    table th:nth-child(5), table td:nth-child(5)   { width: 11%; }  /* Module Name */
    table th:nth-child(6), table td:nth-child(6)   { width: 9%; }   /* Suite Name */
    table th:nth-child(7), table td:nth-child(7)   { width: 5%; }   /* Time (Sec) */
    table th:nth-child(8), table td:nth-child(8)   { width: 5%; }   /* Env */
    table th:nth-child(9), table td:nth-child(9)   { width: 6%; }   /* Test Date */
    table th:nth-child(10), table td:nth-child(10) { width: 12%; text-align: left; font-weight: 600; } /* Automation Owner */

    tr:nth-child(even) { background-color: #f8f9fa; }
    tr:hover { background-color: #f1f3f5; }
</style>

    <script>
        function validateAndSubmit(event) {
            var startDate = document.getElementById("startDateInput").value;
            var endDate = document.getElementById("endDateInput").value;

            if ((startDate === "" && endDate !== "") || (startDate !== "" && endDate === "")) {
                alert("Kripya dono dates select karein ya dono ko khali (blank) chhodein.");
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
        
        <!-- Dynamic Tools Dropdown -->
        <select name="toolName" required>
            <option value="">-- Select Tool / Environment --</option>
            <fmt:bundle basename="config">
                <c:forEach var="t" begin="1" end="20">
                    <fmt:message key="tool.${t}" var="toolItem" />
                    <c:if test="${not empty toolItem and !toolItem.startsWith('???')}">
                        <option value="${toolItem}" ${searchedTool == toolItem ? 'selected' : ''}>${toolItem}</option>
                    </c:if>
                </c:forEach>
            </fmt:bundle>
        </select>

        <!-- Status Filter Dropdown -->
        <select name="statusFilter">
            <option value="ALL" ${statusFilter == 'ALL' ? 'selected' : ''}>-- All Status --</option>
            <option value="PASS" ${statusFilter == 'PASS' ? 'selected' : ''}>PASS</option>
            <option value="FAIL" ${statusFilter == 'FAIL' ? 'selected' : ''}>FAIL</option>
        </select>

        <!-- 🔍 [RESTORED] Test Case Name Text Search Box -->
        
         <input type="text" name="searchTestCaseName" placeholder="Search by Test Case Name..." value="${searchTestCaseName}">

        <!-- 👤 Real-time Searchable & Scrollable Automation Owner Input Component -->
        <div class="searchable-select-wrapper">
            <input type="hidden" id="hiddenOwnerFilter" name="automationOwnerFilter" value="${not empty automationOwnerFilter ? automationOwnerFilter : 'ALL'}" />
            
            <input type="text" id="ownerSearchInput" autocomplete="off"
                   placeholder="${automationOwnerFilter == 'ALL' || empty automationOwnerFilter ? 'Type or scroll Owner...' : automationOwnerFilter}" 
                   value="${automationOwnerFilter == 'ALL' ? '' : automationOwnerFilter}"
                   onclick="openDropdown()" onkeyup="filterDropdownOptions()" />
            
            <div id="ownerDropdownList" class="select-dropdown-list">
                <div onclick="selectOwnerOption('ALL', '-- All Owners --')">-- All Owners --</div>
                <fmt:bundle basename="config">
                    <c:forEach var="i" begin="1" end="20">
                        <fmt:message key="owner.${i}" var="ownerName" />
                        <c:if test="${not empty ownerName and !ownerName.startsWith('???')}">
                            <div class="owner-option" onclick="selectOwnerOption('${ownerName}', '${ownerName}')">${ownerName}</div>
                        </c:if>
                    </c:forEach>
                </fmt:bundle>
            </div>
        </div>

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

    <!-- First load checker boundary: Blanks the UI data unless tool configuration is requested -->
    <c:if test="${not empty results and not empty searchedTool}">
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
                        <th>Automation Owner</th>
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
                            <td style="text-align: left; color: #1a237e;">
                                <c:out value="${not empty row.automationOwner ? row.automationOwner : 'Unassigned'}"/>
                            </td>
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

<script type="text/javascript">
function openDropdown() {
    document.getElementById("ownerDropdownList").style.display = "block";
}

function filterDropdownOptions() {
    var input = document.getElementById("ownerSearchInput");
    var filter = input.value.toUpperCase();
    var listContainer = document.getElementById("ownerDropdownList");
    var options = listContainer.getElementsByClassName("owner-option");
    
    listContainer.style.display = "block";
    var visibleCount = 0;
    
    for (var i = 0; i < options.length; i++) {
        var txtValue = options[i].textContent || options[i].innerText;
        
        // 🎯 LIVE PREFIX STARTS-WITH LOOKUP
        if (txtValue.toUpperCase().startsWith(filter)) {
            options[i].style.display = "block";
            visibleCount++;
        } else {
            options[i].style.display = "none";
        }
    }

    var existingMsg = document.getElementById("noMatchMsg");
    if(existingMsg) { existingMsg.remove(); }

    if (visibleCount === 0) {
        var noMatchDiv = document.createElement("div");
        noMatchDiv.id = "noMatchMsg";
        noMatchDiv.className = "no-match-found";
        noMatchDiv.innerHTML = "❌ No names start with '" + input.value + "'";
        listContainer.appendChild(noMatchDiv);
    }
}

function selectOwnerOption(paramVal, displayLabel) {
    document.getElementById("hiddenOwnerFilter").value = paramVal;
    var input = document.getElementById("ownerSearchInput");
    
    if(paramVal === 'ALL') {
        input.value = ""; 
        input.placeholder = "All Owners Selected";
    } else {
        input.value = displayLabel;
    }
    
    document.getElementById("ownerDropdownList").style.display = "none";
}

document.addEventListener("click", function(event) {
    var wrapper = document.querySelector(".searchable-select-wrapper");
    if (wrapper && !wrapper.contains(event.target)) {
        document.getElementById("ownerDropdownList").style.display = "none";
        
        var input = document.getElementById("ownerSearchInput");
        var hiddenVal = document.getElementById("hiddenOwnerFilter").value;
        
        if (hiddenVal === "ALL" && input.value === "") {
            input.placeholder = "Select Automation Owner...";
        }
    }
});
</script>
</body>
</html>
