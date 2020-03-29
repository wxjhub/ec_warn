<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setDateHeader("Expires", 0); //防止代理服务器缓存页面
	String organStr=request.getParameter("organStr");
%>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>密码重置</title>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
#formSave{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	border:1px solid #c0c0c0;
	border-top-style:none;
	background:#fff url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
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
</script>
</head>
<body>
	<div class="table_b1 mar_30">
	<div class="table_tt" style="margin-top: 30px;"><span>密码重置</span></div>
		<FORM name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;height: 315px">
			<div id="myTab1_Content0" >
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td width="100px" height="32px">柜员号：</td>
						<td width="260px" height="32px">
							<input type="text" class="easyui-validatebox input_eq2" required="true" missingMessage="请输入柜员号！" validType="length[6,18]" name="oldPwd"  id="oldPwd"/>
							<span style="color: red;font-size: 15px;"> *</span>
						</td>
					</tr>
					<tr>
						<td width="100px" height="32px">柜员名：</td>
						<td width="170px" height="32px">
							<input type="text" class="easyui-validatebox input_eq2" name="userName" id="userName" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td colspan="4" height="50" style="color: red">提示：带（*）为必填项</td>
					</tr>
				</table>
			</div>
		</FORM>
		<div class="tool_btn">
			<div style="float: right;">
				<input class="zh_btnbg2" type="button" onclick="submitForm();" id="submit" value="提交"/>
				<input type="button" id="reset" class="zh_btnbg2" value="重置"/>
				<input type="button" onclick="cancel()" class="zh_btnbg2" id="cancel" value="返回" />
			</div>
		</div>
	</div>
</body>
</html>
﻿
