<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>通知信息</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/prettify.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/form-util.js"></script>
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
.tabs-panels{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
	border: none;
}
</style>
<script type="text/javascript">
</script>
</head>
<body class="easyui-layout">
	<div region="center" border="false" style="background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;">
	<form name="formSave" id="formSave" method="post">
		<div id="myTab1_Content0" class="form_style">
			<table cellSpacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td height="32px" width="120px;" class="searchTitle">通知标题：</td>
					<td height="32px">
						<div>
						<h3>
						<c:out value="${notice.noticeTitle}"/>
						</h3>
						</div>
					</td>
				</tr>
				<tr>
					<td height="32px" width="120px;" class="searchTitle" style="vertical-align: text-top; line-height: 33px;">通知内容：</td>
					<td height="200px" style="padding: 0; padding-right: 2px;vertical-align: text-top;">
						<div style="text-indent:24px;line-height: 20px; padding: 0 5px; height: 230px;overflow: auto;">
							<div style=""><c:out value="${notice.noticeContent}"/></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</form>
	</div>
</body>
</html>
﻿
