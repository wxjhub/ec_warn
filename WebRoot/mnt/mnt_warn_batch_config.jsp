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
<title>跑批调度日志</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/all.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css"
	rel="stylesheet" type="text/css" />
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
				<td height="40px">批次：</td>
				<td height="40px">
				   <r:combobox url="${pageContext.request.contextPath}/warnBatchConfig_queryBatchId.action" 
				   valueField="batchId" textField="batchName" id="batchId" style="width:156px" 
				       name="batchId"  onChange="batchIdChange(newValue,oldValue)"></r:combobox>
				     
			     </td>
				<td height="40px">任务组：</td>
				<td height="40px">
				     <r:combobox url="" valueField="taskSetId" textField="taskSetName" id="taskSetId" style="width:156px" 
				       name="taskSetId"  onChange="taskSetIdChange(newValue,oldValue)"></r:combobox>
			     </td>
				<td height="40px">任务：</td>
				<td height="40px">
				     <r:combobox url="" valueField="taskId" textField="taskName" id="taskId" style="width:156px" 
				       name="taskId" onChange="taskIdChange(newValue,oldValue)"></r:combobox>
			     </td>
			     <td height="40px">预警级别：</td>
				<td height="40px">
				     <r:dictCombobox id="warnLevl" name="warnLevl" dictId="ec.warnLvl" style="width:156px;" nullText=""></r:dictCombobox>
			     </td>
			     <td height="40px">预警内容：</td>
				<td height="40px">
				     <r:dictCombobox id="warnContent" name="warnContent" dictId="warn_batch_content" style="width:156px;" nullText=""></r:dictCombobox>
			     </td>
			</tr>
			<tr>
			     <td height="40px" colspan="8" style="text-align:center;padding-left:60px;">
				    <input id="filter_submit" class="inputd" type="button" value="查询" onclick="submitBtn()" /> 
					<input id="filter_reset" class="inputd" type="reset" onclick="resetBtn()" value="重 置" />
				</td>
			</tr>
		</table>
	</form>

	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" onDblClickCell="editDbClick(rowIndex)" onDblClickRow="editDbClick(rowIndex)"
			idField="uuid" rownumbers="false" singleSelect="false" editable="false" url="warnBatchConfig_query.action?sort=batchId"
			striped="true" fit="true" height="100%" title="跑批预警配置" id="warnBatchGrid">
			<r:toolbar id="addRow" text="增加" iconCls="icon-add" onClick="addObj();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editParam();"></r:toolbar>
			<r:toolbar text="删除" iconCls="icon-remove" onClick="remove();"></r:toolbar>
			<r:col field="uuid" title="ID" checkbox="true" sortable="true" width="260">
			</r:col>
			<r:col  field="batchName" title="批次" sortable="true"  width="200">
			</r:col>
			<r:col  field="taskSetName" title="任务组" sortable="true"  width="200">
			</r:col>
			<r:col  field="taskName" title="任务" sortable="true"  width="300">
			</r:col>
			<r:col  field="warnLevl" title="预警级别" sortable="true"  width="100" dictId="ec.warnLvl">
			</r:col>
			<r:col  field="warnContent" title="预警内容" sortable="true"  width="100" dictId="warn_batch_content">
			</r:col>
			<r:col field="warnContentValue" title="预警内容值" sortable="true" width="100" formatter="formatter(value,rowData,rowIndex)">
			</r:col>
			<r:pagination id="pag"></r:pagination>
		</r:grid>
	</div>
</body>
<script>
	function formatter(value,rowData,rowIndex){
		if(value && rowData.warnContent == '02'){
			return value+"秒";
		} else {
			return value;
		}
	}
	//预警次数改变事件
	function batchIdChange(newV,oldV){
		if(newV == ''){
			return;
		}
		changeTaskSet($('#taskSetId'),newV);
		
	}
	function taskSetIdChange(newV,oldV){
		if(newV == ''){
			return;
		}
		changeTask($('#taskId'),newV);
		
	}
	//改变任务组下拉框数据
	function changeTaskSet(taskSet,batchId){
		$(taskSet).combobox('setValue','');
		$(taskSet).combobox('reload','${pageContext.request.contextPath}/warnBatchConfig_queryTaskSetId.action?batchId='+batchId); 
		
	}
	//改变任务下拉框数据
	function changeTask(task,taskSetId){
		$(task).combobox('setValue','');
		$(task).combobox('reload','${pageContext.request.contextPath}/warnBatchConfig_queryTaskId.action?taskSetId='+taskSetId); 
		
	}
	//重置查询信息
	function resetBtn() {
			$('#batchId').combobox('setValue','');
			$('#taskSetId').combobox('setValue','');
			$('#taskId').combobox('setValue',''); 
			$('#warnLevl').combobox('setValue',''); 
			$('#warnContent').combobox('setValue',''); 
	}
	//查询方法
	function submitBtn() {
		var options = $('#warnBatchGrid').datagrid("options");
		options.queryForm = "formSearch";
		$('#warnBatchGrid').datagrid("load");
	}
	//编辑方法
	function editParam() {
		var selected = $('#warnBatchGrid').datagrid('getSelections');
		if(selected.length == 0) {
			$.messager.alert('系统提示','请选择要修改的机构！','warning');
			return;
		}
		if(selected.length >1) {
			$.messager.alert('系统提示','只能选择一个机构进行编辑！','warning');
			return;
		}

		$("#formSearch")[0].action = "${pageContext.request.contextPath}/warnBatchConfig_toForm.action?uuid="+selected[0].uuid;
		$("#formSearch")[0].submit();
	}
    
    //删除方法
	function remove() {
		$.messager
				.confirm(
						'系统提示',
						'确定要删除选中的记录吗',
						function(btn) {
							if (btn) {
								var uuids = [];
								var selected = warnBatchGrid.getAllSelected();
								for ( var i = 0; i < selected.length; i++) {
									uuids.push(selected[i].uuid);
								}
								if (selected.length == 0) {
									$.messager.alert('系统提示', '请选择要删除的记录','warning');
									return;
								} else {
									$.ajax({
												type : 'post',
												dataType : "Json",
												url : "${pageContext.request.contextPath}/warnBatchConfig_remove.action?uuid="
														+ uuids,
												success : function(data) {
													$.messager.alert('系统提示',
															'删除成功', 'warning');
													warnBatchGrid.unselectAll();
													warnBatchGrid.reload();
												}
											});
								}
							}
						});
	}
	//新增方法
	function addObj() {
		$("#formSearch")[0].action = "${pageContext.request.contextPath}/warnBatchConfig_toForm.action";
		$("#formSearch")[0].submit();
	}
</script>
</html>

