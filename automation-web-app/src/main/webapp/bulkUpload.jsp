<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Bulk CSV Importer</title>
<style>
    body { font-family: Arial, sans-serif; background:#f4f6f9; margin:40px; text-align: center;}
    .container { background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); max-width: 500px; margin: auto; }
    h2 { color:#2c3e50; }
    p { color: #555; font-size: 14px; }
    .path-highlight { background: #efe; color: #27ae60; padding: 10px; border-radius: 4px; font-family: monospace; font-weight: bold; margin: 15px 0; border: 1px solid #2ecc71; }
    button { background: #e74c3c; color: white; cursor: pointer; border: none; padding: 12px 20px; font-size: 16px; border-radius: 4px; width: 100%; font-weight: bold;}
    button:hover { background: #c0392b; }
    .msg-success { color: #27ae60; font-weight: bold; margin-top: 20px; background: #e8f8f5; padding: 10px; border-radius: 4px;}
    .msg-error { color: #c0392b; font-weight: bold; margin-top: 20px; background: #f9ebea; padding: 10px; border-radius: 4px;}
</style>
</head>
<body>

<div class="container">
    <h2>Daily Automation CSV Processor</h2>
    <p>Click the button below to process files from <strong>Downloads/csvfiles</strong> directly into MySQL via Stored Procedure.</p>
    
    <div class="path-highlight">
        Target Folder: Downloads/csvfiles
    </div>
    
    <form action="processBulkCSV" method="post">
        <button type="submit">Sync Data and Clear Folder</button>
    </form>

    <c:if test="${not empty message}">
        <div class="msg-success">${message}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="msg-error">${error}</div>
    </c:if>
</div>

</body>
</html>