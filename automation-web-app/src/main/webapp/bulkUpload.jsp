<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dynamic Bulk CSV Importer</title>
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
        border-bottom: 3px solid #00f2fe; 
    }

    .container { 
        background: #fff; 
        padding: 35px; 
        border-radius: 8px; 
        box-shadow: 0 4px 12px rgba(0,0,0,0.05); 
        max-width: 550px; 
        margin: 50px auto; 
        text-align: center;
    }

    h2 { 
        color: #2c3e50; 
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 15px;
    }

    p { 
        color: #6c757d; 
        font-size: 15px; 
        line-height: 1.5;
        margin-bottom: 25px;
    }

    .upload-zone {
        border: 2px dashed #1a237e;
        padding: 40px 20px;
        border-radius: 6px;
        background: #f0f2ff;
        margin-bottom: 25px;
        transition: border-color 0.2s;
    }
    
    .upload-zone:hover {
        border-color: #00f2fe;
    }

    .file-input {
        display: block;
        width: 100%;
        margin-top: 15px;
        font-size: 14px;
    }

    button { 
        background: #1a237e; 
        color: white; 
        cursor: pointer; 
        border: none; 
        padding: 14px 20px; 
        font-size: 16px; 
        border-radius: 6px; 
        width: 100%; 
        font-weight: 600;
        box-shadow: 0 2px 5px rgba(26, 35, 126, 0.2);
        transition: background-color 0.15s;
    }

    button:hover { 
        background: #0f172a; 
    }

    button:active {
        transform: scale(0.99);
    }

    .msg-success { 
        color: #2e7d32; 
        font-weight: 600; 
        margin-top: 20px; 
        background: #e8f5e9; 
        padding: 12px; 
        border-radius: 4px;
        border-left: 4px solid #2e7d32;
        text-align: left;
    }

    .msg-error { 
        color: #c62828; 
        font-weight: 600; 
        margin-top: 20px; 
        background: #ffebee; 
        padding: 12px; 
        border-radius: 4px;
        border-left: 4px solid #d32f2f;
        text-align: left;
    }
</style>
</head>
<body>

<nav class="navbar">
    <a class="navbar-brand" href="#">⚙️ QE Automation Hub</a>
    <ul class="navbar-links">
        <li><a href="automationDashboard.jsp">🏠 Dashboard</a></li>
        <li><a href="bulkUpload.jsp" class="active">📤 Bulk Upload</a></li>
        <li><a href="index.jsp">📊 Advanced Reports</a></li>
    </ul>
</nav>

<div class="container">
    <h2>Daily Automation CSV Uploader</h2>
    <p>Upload single or multiple CSV files. The data will be dynamically read and securely processed directly into MySQL.</p>
    
    <form action="processBulkCSV" method="post" enctype="multipart/form-data">
        <div class="upload-zone">
            <label for="csvFiles" style="font-weight:600; color:#1a237e; font-size: 16px;">
                📁 Drag & Drop or Browse Files
            </label>
            <input type="file" id="csvFiles" name="csvFiles" class="file-input" multiple accept=".csv" required />
        </div>
        <button type="submit">🚀 Upload and Sync Data</button>
    </form>

    <c:if test="${not empty message}">
        <div class="msg-success">✅ ${message}</div>
    </c:if>
    
    <c:if test="${not empty error}">
        <div class="msg-error">⚠️ ${error}</div>
    </c:if>
</div>

</body>
</html>