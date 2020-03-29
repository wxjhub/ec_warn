<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="/WEB-INF/tld/rmp.tld" prefix="rmp"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN"
	xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务选择</title>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
}

.font {
	color: red
}

.input_file {
	width: 140px;
	margin-left: -140px;
	height: 21px;
	filter: alpha(opacity = 0);
	opacity: 0;
}
</style>

<script type="text/javascript">
	$(function() {
		$('.gridDiv').height(
				$('.gridDiv').parent().parent()[0].clientHeight - 63);
	});
	
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post"
		style="padding: 10px 0 10px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">任务编号：</td>
				<td height="40px">
				   <input type="text" class="input_eq2" id="taskId" name="taskId"" value="">
				     
			     </td>
			     <td height="40px" colspan="8" style="text-align:center;padding-left:60px;">
				    <input id="filter_submit" class="inputd" type="button" value="查询" onclick="submitBtn()" /> 
					<input id="filter_reset" class="inputd" type="reset" onclick="resetBtn()" value="重 置" />
					<input id="filter_reset" class="inputd" type="button" onclick="okBtn()" value="确定" />
				</td>
			</tr>
		</table>
	</form>

	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" url="warnBatchConfig_queryTask.action?taskSetId=${param.taskSetId}"
			idField="uuid" rownumbers="false" singleSelect="true" editable="false" 
			striped="true" fit="true" height="100%" title="选择任务" id="grid">
			<r:col field="uuid" title="ID" checkbox="true" sortable="true" width="260">
			</r:col>
			<r:col  field="taskId" title="任务编号" sortable="true"  width="200">
			</r:col>
			<r:col  field="taskName" title="任务名称" sortable="true"  width="300">
			</r:col>
			<r:pagination id="pag"></r:pagination>
		</r:grid>
	</div>
</body>
<script>
	//重置查询信息
	function resetBtn() {
			$('#taskId').val(''); 
	}
	function okBtn() {
		var selected = $('#grid').datagrid('getSelections');
	 	if(selected.length <= 0){
	 		$.messager.alert('系统提示','请至少选择一个记录！','warning');
 	 		return false;
 	 	}
		var result = [];
		for(var i=0;i<selected.length;i++){
			var row = {};
			row['id'] = selected[i].taskId;
			row['name'] = selected[i].taskName;
			result.push(row);
		}
		closeModalCenter(result);	
	}
	//查询方法
	function submitBtn() {
		var options = $('#grid').datagrid("options");
		options.queryForm = "formSearch";
		$('#grid').datagrid("load");
	}
	
</script>
</html>

