<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>通知列表</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script src="${pageContext.request.contextPath}/js/showModalCenter.js" type="text/javascript"></script>
<style type="text/css">
#formSearch .panel-body{
	border-bottom-style: none;
}
</style>
<script type="text/javascript">
$(function(){
	//网格最小高度
	$('#notice').datagrid({
		url:'notice_currentNoticeList.action',
		width:'100%',
		striped: false,
		collapsible:false,
		idField:'messId',
		fitColumns:true,
		scroll:true,
		columns:[[
			{field:'noticeTitle',title:'标题', width:150},
			{field:'pubDate',title:'发布时间', width:150},
			{field:'realName',title:'发布人', width:150},
			{field:'noticeId',title:'详细', align:'center',width:150,
				formatter:function(value){
					return "<a style='text-decoration: underline; color: blue;' href=\"#\" onclick=\"showNotice('" + value + "');\">内容</a>";
				}
			}
		]]
	});
});
function showNotice(value){
	showModalCenter ("${pageContext.request.contextPath}/notice_showNoticeDetail.action?noticeId=" + value, function(data){
		
	}, "600", "360", "通知信息");
	
}
</script>
</head>
<body>
<div class="gridDiv">
	<table id="notice"></table>
</div>
</body>
</html>

