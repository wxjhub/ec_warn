<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>基本信息</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>

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
$(function(){
	var heightValue = $(document).height() - 150;
	if (heightValue > 300)
	    $("#formSave").height(heightValue);
});
</script>



</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><span>基本信息</span></div>
	<FORM name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;height: 315px">
		<div id="myTab1_Content0" >
			<table cellSpacing="0" cellpadding="0" border="0">
				<tr>
					<td width="80px" height="32px">用户姓名：</td>
					<td width="260px" height="32px">
						<input type="text" class="input_eq2" name="realName" id="realName" value="${user.realName}" disabled="disabled"/>
					</td>
					<td width="80px" height="32px" style="padding-left: 20px">邮&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;件：</td>
					<td width="170px" height="32px">
						<input type="text" name="email" id="email" value="${user.email}" class="input_eq2" disabled="disabled"/>
					</td>
				</tr>
				<tr>
					<td height="32px">所属机构：</td>
					<td height="32px">
						<input type="text" style="width: 150px" name="orgName" id="orgName" value="${orgName}" class="input_eq2" disabled="disabled"/>
					</td>
					<td height="32px" style="padding-left: 20px">身份证号：</td>
					<td height="32px">
						<input type="text" style="width: 150px" name="idcard" id="idcard" value="${user.idcard}" class="input_eq2" disabled="disabled"/>
					</td>
				</tr>
				
				<tr>
					
					<td height="32px" >家庭电话：</td>
					<td height="32px">
						<input type="text"
						style="width: 150px" name="famliyPhone" id="famliyPhone" value="${user.famliyPhone}" disabled="disabled"
						class="input_eq2"/>
					</td>
					<td height="32px" style="padding-left: 20px">办公电话：</td>
					<td height="32px">
						<input type="text" 
						style="width: 150px" name="officePhone" id="officePhone" value="${user.officePhone}"
						disabled="disabled" class="input_eq2"/>
					</td>
				</tr>
				<tr>
					<td height="32px" >移动电话：</td>
					<td height="32px" colspan="3">
						<input type="text"
						style="width: 150px" name="mobilePhone" id="mobilePhone" value="${user.mobilePhone}"
					    disabled="disabled" class="input_eq2" >
					</td>
				</tr>
				
				<tr>
					<td height="32px">用户角色：</td>
					<td height="32px" colspan="3">
						<input type="text" style="width: 510px;" disabled="disabled" name="roleName" id="roleName" value="${roleName}" class="input_eq2"/>
					</td>
				</tr>
			</table>
		</div>
	</FORM>
	<div class="tool_btn">
		<div style="float: right;">
		</div>
	</div>
</div>
</body>
</html>
﻿
