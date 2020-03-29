<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<title>监控系统-首页</title>
</head>
<body>
<script> 
document.onreadystatechange=function(){ 
	 if(document.readyState=="complete"){ 
	    document.getElementById('loading_div').style.display='none'; 
	 } 
};
 </script> 
 <div id="loading_div" style="position:absolute;width:100%;height:100%;left:0px;top:0px;background-color:#e7f1fd;filter:alpha(opacity=100)">
 	<center>
 	<div style="margin-top: 20%;border: 5px #6593cf solid;width: 200px; height: 46px;background: #fff;padding-top: 5px;padding-bottom: 7px;">
 		<table width="170px">
 		<tr>
 			<td align="center" height="30px;"><img alt="" src="${pageContext.request.contextPath}/images/loading_img.gif"></td>
 		</tr>
 		<tr>
 			<td align="center">正在载入数据，请等待…</td>
 		</tr>
 		</table>
 	</div>
 	</center>
 </div>
</body>
</html>
