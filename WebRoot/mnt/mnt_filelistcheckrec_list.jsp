<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="/WEB-INF/tld/rmp.tld"  prefix="rmp" %>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>关联系统LIST文件监控</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
.input_file{width:140px; margin-left:-140px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>

<script type="text/javascript">
var date = new Date();
var y = date.getFullYear();
var m = date.getMonth() + 1;
var d = date.getDate()-1;
var dataDate = y + '-' + (m < 10 ? ('0' + m) : m) + '-'
		+ (d < 10 ? ('0' + d) : d);
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
	$('#asOfDate').datebox('setValue', dataDate);
});
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post" style="padding: 10px 0 10px 30px;">
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<INPUT name="pageNo1" id="pageNo1"type="hidden" value="${param.success}"> 
		<INPUT name="pageNo2" id="pageNo2"type="hidden" value="${param.lrmsdate}"> 
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td>数据日期:</td>
				<td>
					<input class="easyui-datebox" id="asOfDate" name="asOfDate" style="width: 120px; padding: 0px" />
				</td>
				<td>系统名称： <select name="soursesysName" id="soursesysName">
						<option value="">---请选择---</option>
						<rmp:option dictId="sourseSys"></rmp:option>
				</select>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
					<input id="filter_reset2" class="inputd" type="button" onclick="back()" value="返回"/>
				</td>
			</tr>
			<tr>
				<td colspan="3">
					<span style="color:red;font-weight: bold">每次查询都会去重新加载系统文件数量信息，会造成速度慢</span>
				</td>
			</tr>
		</table>
	</form>
	<!-- url="filelistcheck_findFileListCheckList.action?asOfDate=\"+$('#asOfDate').datebox('getValue')+\"" -->
		<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" 
		rownumbers="false" singleSelect="false" editable="true" url="filelistcheck_findFileListCheckList.action=\"+$('#asOfDate').datebox('getValue')+\"" 
		striped="true" fit="true" height="100%"  title="关联系统LIST文件监控" id="lrmsMoni">
			<r:col  field="uuid" title="ID"  checkbox="false"   sortable="true" width="260" editable="false" hidden="true">
			</r:col>
			<r:col  field="soursesysName" title="关联系统号" editable="false" dictId="sourseSys" sortable="true" width="150">
				<r:editorDictSelect></r:editorDictSelect>
			</r:col>
			<%-- <r:col  field="listSendNum" title="文件接受数chklist"  editable="false" sortable="true" width="150">
			</r:col> --%>
			<r:col  field="listNum" title="文件接受实际数" editable="false" sortable="true" width="150">
			</r:col>
			
			<%-- <r:col  field="listNumSend" title="文件发送数"  editable="false" sortable="true" width="100">
			</r:col>
			
			<r:col  field="factFileRecNum" title="文件发送实际数"  editable="false" sortable="true" width="100">
			</r:col>
			 --%>
			
			<r:col  field="asOfDate" title="数据日期" editable="false" sortable="true" width="100">
				<r:editorDate format="yyyy-MM-dd"></r:editorDate>
			</r:col>
			<r:col  field="col1" title="预留"  hidden="true" sortable="true" width="100">
			</r:col>
			<r:col  field="col2" title="预留"  hidden="true" sortable="true" width="100">
			</r:col>
		<r:pagination id="pag"></r:pagination>
	</r:grid>
		
	</div>
</body>
<script>
//重置查询信息
function rese(){
	$("#soursesysName").val('');
	$('#asOfDate').datebox('setValue');
	$('#scriptType').val('');
}

function back(){
	window.location.href="${pageContext.request.contextPath}/mon/mon_filesend_control_list.jsp";
}

function submi(){
	var jsonData = {
			soursesysName:$("#soursesysName").val(),
			asOfDate:$('#asOfDate').datebox('getValue'),
			newpage:1,page:1
			};
	$('#lrmsMoni').datagrid('options').queryParams = jsonData;
	$('#lrmsMoni').datagrid('clearSelections');
	$('#lrmsMoni').datagrid({
		'url' : 'filelistcheck_findFileListCheckList.action'
	});
// 	lrmsMoni.load(jsonData);
}
	</script>
</html>

