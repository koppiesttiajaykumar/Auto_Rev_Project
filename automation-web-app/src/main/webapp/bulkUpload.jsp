<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c"
	uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt"
	uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Bulk CSV Upload</title>

<style>

*{
	margin:0;
	padding:0;
	box-sizing:border-box;
	font-family:'Segoe UI',sans-serif;
}

body{
	background:#f5f7fb;
}

.navbar{
	height:60px;
	background:#1a237e;
	display:flex;
	align-items:center;
	justify-content:space-between;
	padding:0 40px;
}

.navbar-brand{
	color:#fff;
	font-size:22px;
	font-weight:bold;
	text-decoration:none;
}

.navbar ul{
	list-style:none;
	display:flex;
}

.navbar ul li{
	margin-left:20px;
}

.navbar ul li a{
	color:white;
	text-decoration:none;
	padding:20px 15px;
	display:block;
}

.navbar ul li a:hover{
	background:#0d47a1;
}

.container{

	width:600px;
	margin:40px auto;
	background:white;
	padding:30px;
	border-radius:8px;
	box-shadow:0 2px 10px rgba(0,0,0,.2);

}

h2{

	text-align:center;
	color:#1a237e;
	margin-bottom:25px;

}

.form-group{

	margin-bottom:20px;

}

label{

	display:block;
	font-weight:bold;
	margin-bottom:8px;

}

.searchable-select-wrapper{

	position:relative;
	width:100%;

}

.searchable-select-wrapper input{

	width:100%;
	padding:12px;
	border:2px solid #1a237e;
	border-radius:6px;
	font-size:15px;

}

.select-dropdown-list{

	display:none;
	position:absolute;
	width:100%;
	max-height:220px;
	overflow-y:auto;
	background:white;
	border:1px solid #ccc;
	border-radius:5px;
	box-shadow:0 2px 8px rgba(0,0,0,.2);
	z-index:999;

}

.select-dropdown-list div{

	padding:10px;
	cursor:pointer;

}

.select-dropdown-list div:hover{

	background:#1a237e;
	color:white;

}

.upload-box{

	border:2px dashed #1a237e;
	padding:30px;
	text-align:center;
	border-radius:6px;
	background:#eef2ff;

}

.upload-box.disabled{

	opacity:.5;

}

button{

	width:100%;
	padding:14px;
	background:#1a237e;
	color:white;
	border:none;
	border-radius:6px;
	font-size:16px;
	cursor:pointer;

}

button:disabled{

	opacity:.5;
	cursor:not-allowed;

}

.success{

	margin-top:20px;
	padding:12px;
	background:#d4edda;
	color:#155724;
	border-radius:5px;

}

.error{

	margin-top:20px;
	padding:12px;
	background:#f8d7da;
	color:#721c24;
	border-radius:5px;

}

</style>

</head>

<body>

<nav class="navbar">

<a class="navbar-brand" href="#">

QE Automation Hub

</a>

<ul>

<li>

<a href="automationDashboard.jsp">

Dashboard

</a>

</li>

<li>

<a href="bulkUpload.jsp">

Bulk Upload

</a>

</li>

<li>

<a href="index.jsp">

Advanced Reports

</a>

</li>

</ul>

</nav>

<div class="container">

<h2>

Bulk CSV Upload

</h2>

<form
action="processBulkCSV"
method="post"
enctype="multipart/form-data">

<!-- Automation Tool -->

<div class="form-group">

<label>

🛠 Automation Tool

<span style="color:red">*</span>

</label>

<div class="searchable-select-wrapper">

<input
type="hidden"
id="toolName"
name="toolName">

<input
type="text"
id="toolSearch"
placeholder="Type or Scroll Tool..."
autocomplete="off">

<div
id="toolDropdown"
class="select-dropdown-list">

<fmt:bundle basename="config">

<c:forEach
var="i"
begin="1"
end="20">

<fmt:message
key="tool.${i}"
var="tool"/>

<c:if
test="${not empty tool && !tool.startsWith('???')}">

<div class="tool-option">

${tool}

</div>

</c:if>

</c:forEach>

</fmt:bundle>

</div>

</div>

</div>
<!-- Automation Owner -->

<div class="form-group">

<label>

👤 Automation Owner

<span style="color:red">*</span>

</label>

<div class="searchable-select-wrapper">

<input
type="hidden"
id="automationOwner"
name="automationOwner">

<input
type="text"
id="ownerSearch"
placeholder="Type or Scroll Owner..."
autocomplete="off">

<div
id="ownerDropdown"
class="select-dropdown-list">

<fmt:bundle basename="config">

<c:forEach
var="i"
begin="1"
end="20">

<fmt:message
key="owner.${i}"
var="owner"/>

<c:if
test="${not empty owner && !owner.startsWith('???')}">

<div class="owner-option">

${owner}

</div>

</c:if>

</c:forEach>

</fmt:bundle>

</div>

</div>

</div>

<!-- CSV Upload -->

<div
id="uploadBox"
class="upload-box">

<p>

Choose one or more CSV Files

</p>

<br>

<input
type="file"
id="csvFiles"
name="csvFiles"
accept=".csv"
multiple
required>

</div>

<br>

<button
type="submit">

Upload CSV

</button>

</form>

<c:if test="${not empty message}">

<div class="success">

${message}

</div>

</c:if>

<c:if test="${not empty error}">

<div class="error">

${error}

</div>

</c:if>

</div>

<script>

var toolInput=document.getElementById("toolSearch");
var toolHidden=document.getElementById("toolName");
var toolDropdown=document.getElementById("toolDropdown");

toolInput.onclick=function(){

toolDropdown.style.display="block";

};

toolInput.onkeyup=function(){

var filter=toolInput.value.toUpperCase();

var items=toolDropdown.getElementsByClassName("tool-option");

for(var i=0;i<items.length;i++){

var txt=items[i].innerHTML;

if(txt.toUpperCase().indexOf(filter)>-1){

items[i].style.display="block";

}else{

items[i].style.display="none";

}

}

};

var toolItems=document.getElementsByClassName("tool-option");

for(var i=0;i<toolItems.length;i++){

toolItems[i].onclick=function(){

toolInput.value=this.innerHTML.trim();

toolHidden.value=this.innerHTML.trim();

toolDropdown.style.display="none";

};

}

var ownerInput=document.getElementById("ownerSearch");
var ownerHidden=document.getElementById("automationOwner");
var ownerDropdown=document.getElementById("ownerDropdown");

ownerInput.onclick=function(){

ownerDropdown.style.display="block";

};

ownerInput.onkeyup=function(){

var filter=ownerInput.value.toUpperCase();

var items=ownerDropdown.getElementsByClassName("owner-option");

for(var i=0;i<items.length;i++){

var txt=items[i].innerHTML;

if(txt.toUpperCase().indexOf(filter)>-1){

items[i].style.display="block";

}else{

items[i].style.display="none";

}

}

};

var ownerItems=document.getElementsByClassName("owner-option");

for(var i=0;i<ownerItems.length;i++){

ownerItems[i].onclick=function(){

ownerInput.value=this.innerHTML.trim();

ownerHidden.value=this.innerHTML.trim();

ownerDropdown.style.display="none";

};

}

document.addEventListener("click",function(e){

if(!toolInput.contains(e.target) &&
!toolDropdown.contains(e.target)){

toolDropdown.style.display="none";

}

if(!ownerInput.contains(e.target) &&
!ownerDropdown.contains(e.target)){

ownerDropdown.style.display="none";

}

});

document.querySelector("form").onsubmit=function(){

if(toolHidden.value==""){

alert("Please Select Automation Tool");

return false;

}

if(ownerHidden.value==""){

alert("Please Select Automation Owner");

return false;

}

return true;

};

</script>

</body>

</html>