<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>操作日志历史数据</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>

<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}

#operationLogForm{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	border:1px solid #c0c0c0;
	border-top-style:none;
	background:#fff url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
}

.tabs-panels{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
}
.combo{
	display:inline-block;
	white-space:nowrap;
	font-size:12px;
	margin:0;
	padding:0;
	border-radius:5px;
	-moz-border-radius:5px;
	border:1px solid #d8d8d8;
	background:#fff;
}
.combo-text{
	font-size:12px;
	border:0px;
	line-height:20px;
	height:20px;
	padding:0px;
	*height:18px;
	*line-height:18px;
	_height:18px;
	_line-height:18px;
	background:url(${pageContext.request.contextPath}/images/select_bg.png) repeat-x;
}
</style>

<script type="text/javascript">
$(function(){
	$('#goBack').click(function(){
		window.location.href="${pageContext.request.contextPath}/sec/sec_operationLog_list.jsp";
	});
	
	var heightValue = $(document).height() - 150;
	if (heightValue > 0)
	    $("#log").height(heightValue);
});
</script>
</head>
<body>
<div style="padding: 30px; padding-bottom: 0;">
	<div class="table_tt">
		<font class="blue">操作日志历史数据</font>
	</div>
	<form name="operationLogForm" id="operationLogForm" method="post">
		<div id="log" style="padding: 25px 0 0 25px;height: 315px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td width="80px" height="32px"> 日志名称：</td>
				<td width="260px" height="32px">
					<input type="text" name="logName" class="easyui-validatebox input_eq2"  id="logName" value="${operationLog.logName}" readonly="readonly"/>
				</td>
				<td width="80px" height="32px" style="padding-left: 20px">日志类型：</td>
				<td width="260px" height="32px">
					<input type="text" name="logType" class="easyui-validatebox input_eq2" id="logType" value="${operationLog.logType}" readonly="readonly"/>
				</td>
			</tr>
			<%--
			<tr>
				<td width="80px" height="32px">交易id：</td>
				<td width="260px" height="32px">
					<input type="text" name="transId" class="easyui-validatebox input_eq2" id="transId" value="${operationLog.transId}" readonly="readonly"/>
				</td>
				<td width="80px" height="32px" style="padding-left: 20px">交易类型：</td>
				<td width="260px" height="32px">
					<input type="text" name="transType" class="easyui-validatebox input_eq2" id="transType" value="${operationLog.transType}" readonly="readonly"/>
				</td>
			</tr>
			 
			<tr>
				<td width="80px" height="32px">上一版本数据:</td>
				<td width="260px" height="65px" colspan="3">
					<textarea rows="3" cols="62" style="border: 1px solid #ccc;" readonly="readonly">${operationLog.logDataLast}</textarea>
				</td>
			</tr>
			--%>
			<tr>
			    <td width="80px" height="32px">当前数据：</td>
				<td width="260px" height="60px" colspan="3">
					<textarea rows="6" cols="62" style="border: 1px solid #ccc;" readonly="readonly">${operationLog.logData}</textarea>
				</td>  
			</tr>
			<tr>
				<td width="80px" height="32px">数据主键：</td>
				<td width="260px" height="32px">
					<input type="text" name="logDataId"  class="easyui-validatebox input_eq2"  id="logDataId" value="${operationLog.logDataId}" readonly="readonly"/>
				</td>
				<td width="80px" height="32px"  style="padding-left: 20px">日志信息：</td>
				<td width="260px" height="32px">
					<input type="text" name="logMsg" class="easyui-validatebox input_eq2" id="logMsg" value="${operationLog.logMsg}" readonly="readonly"/>
				</td>
			</tr>
			<tr>
			    <td width="80px" height="32px">用户登录名：</td>
				<td width="260px" height="32px">
					<input type="text" name="userName"  class="easyui-validatebox input_eq2" id="userName" value="${operationLog.userName}" readonly="readonly"/>
				</td>
				<td width="80px" height="32px"  style="padding-left: 20px">用户姓名：</td>
				<td width="260px" height="32px">
					<input type="text" name="userRealName"  class="easyui-validatebox input_eq2" id="userRealName" value="${operationLog.userRealName}" readonly="readonly"/>
				</td>
				
			</tr>
			<tr>
		        <td width="80px" height="32px">用户机构：</td>
				<td width="260px" height="32px">
					<input type="text" name="userOrgName"  class="easyui-validatebox input_eq2" id="userOrgName" value="${operationLog.userOrgName}" readonly="readonly"/>
				</td>
				<td width="80px" height="32px" style="padding-left: 20px">操作时间：</td>
				<td width="260px" height="32px">
					<input type="text" name="operateTime"   class="easyui-validatebox input_eq2"  id="operateTime" value="${operationLog.operateTime}" readonly="readonly"/>
				</td>
			</tr>
		</table>
		</div>
	</form>
	<div class="tool_btn">
		<div style="padding-left: 20px;">
			<input type="button" id="goBack" class="inputd" value="返回" />
		</div>
	</div>
</div>
</body>
</html>
﻿
