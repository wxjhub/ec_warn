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
<title>交易成功率监控配置</title>
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
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
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
				       name="batchId"  onChange="batchIdChange(newValue,oldValue)" panelHeight="200px"></r:combobox>
				     
			     </td>
				<td height="40px">任务组：</td>
				<td height="40px">
				     <r:combobox url="" valueField="taskSetId" textField="taskSetName" id="processId" style="width:156px" 
				       name="processId" panelHeight="200px" onChange="taskSetChange(newValue,oldValue)"></r:combobox>
			     </td>
				<td height="40px">任务：</td>
				<td height="40px">
				        <input type="hidden" id="taskId" name="taskId" value="${detail.taskId}">
				        <input type="text" class="input_eq2" id="taskName" name="taskName" value="${detail.taskName}" readonly="readonly"
				        style="width:120px">
						<input type="button" class="inputd" value="选择" onclick="selectTask()">
			     </td>
			     <td height="40px">运行状态：</td>
				 <td height="40px">
				     <r:dictCombobox id="runFlag" name="runFlag" dictId="warn_batch_etl_runFlag" style="width:156px;" nullText=""></r:dictCombobox>
			     </td>
			     <td height="40px">数据日期：</td>
				 <td height="40px">
				     <input class="easyui-datebox" id="asOfDate" name="asOfDate"  style="width: 156px; padding: 0px"/></td>
			     </td>
			    
			</tr>
		    <tr>
		        <td height="40px" colspan="8" style="text-align:center;padding-left:60px;">
				    <input id="filter_sumit" class="inputd" type="button" value="查询" onclick="submitBtn()" /> 
					<input id="filter_reset" class="inputd" type="reset" onclick="resetBtn()" value="重 置" />
				</td>
		    </tr>
		</table>
	</form>

	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" onDblClickCell="editDbClick(rowIndex)" onDblClickRow="editDbClick(rowIndex)"
			idField="uuid" rownumbers="false" singleSelect="false" editable="false" url="warnBatchHisTaskLog_query.action"
			striped="true" fit="true" height="100%" title="跑批调度日志" id="warnBatchGrid">
			<r:col field="uuid" title="ID" checkbox="true" sortable="true" width="200"></r:col>
			<r:col  field="batchName" title="批次" sortable="true"  width="200"></r:col>
			<r:col  field="processName" title="任务组" sortable="true"  width="200"></r:col>
			<r:col  field="taskName" title="任务" sortable="true"  width="250"></r:col>
			<r:col  field="stdTime" title="开始时间" sortable="true"  width="130" formatter="formatterTime(value,rowData,rowIndex)"></r:col>
			<r:col  field="endTime" title="结束时间" sortable="true"  width="130" formatter="formatterTime(value,rowData,rowIndex)"></r:col>
			<r:col  field="runTime" title="运行时长" sortable="true"  width="80" dictId="warn_batch_content"></r:col>
			<r:col field="runFlag" title="运行状态" sortable="true" width="80" dictId="warn_batch_etl_runFlag"></r:col>
			<r:col field="asOfDate" title="数据日期" sortable="true" width="80"  dateFormat="yyyy-MM-dd"></r:col>
			<r:col field="count" title="运行次数" sortable="true" width="60"></r:col>
			<r:col field="sumcount" title="总运行次数" sortable="true" width="70"></r:col>
			<r:col field="createDate" title="记录时间" sortable="true" width="150" formatter="formatterTime(value,rowData,rowIndex)"></r:col>
			<r:pagination id="pag"></r:pagination>
		</r:grid>
	</div>
</body>
<script>
	//预警次数改变事件
	function batchIdChange(newV,oldV){
		if(newV == ''){
			return;
		}
		changeTaskSet($('#processId'),newV);
		
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
	//改变任务组下拉框数据
	function taskSetChange(taskSet,batchId){
		$('#taskId').val(''); 
		$('#taskName').val(''); 
	}
	//重置查询信息
	function resetBtn() {
			$('#batchId').combobox('setValue','');
			$('#processId').combobox('setValue','');
			$('#taskId').val(''); 
			$('#taskName').val(''); 
			$('#runFlag').combobox('setValue',''); 
			$('#asOfDate').datebox('setValue',''); 
	}
	//查询方法
	function submitBtn() {
		var options = $('#warnBatchGrid').datagrid("options");
		options.queryForm = "formSearch";
		$('#warnBatchGrid').datagrid("load");
	}
	//格式化日期数据
	function formatterTime(value,rowData,rowIndex){
		if(value){
			return format(new Date(value.time),"yyyy-MM-dd HH:mm:ss");
		} 
	}
	function format(date,str){
	    var mat={};
	    mat.M=date.getMonth()+1;//月份记得加1
	    mat.H=date.getHours();
	    mat.s=date.getSeconds();
	    mat.m=date.getMinutes();
	    mat.Y=date.getFullYear();
	    mat.D=date.getDate();
	    mat.d=date.getDay();//星期几
	    mat.d=check(mat.d);
	    mat.H=check(mat.H);
	    mat.M=check(mat.M);
	    mat.D=check(mat.D);
	    mat.s=check(mat.s);
	    mat.m=check(mat.m);
	　　　 return mat.Y+"-"+mat.M+"-"+mat.D+" "+mat.H+":"+mat.m+":"+mat.s;
	}
	//检查是不是两位数字，不足补全
	function check(str){
	    str=str.toString();
	    if(str.length<2){
	        str='0'+ str;
	    }
	    return str;
	}
	//选择任务
	function selectTask(){
		var taskSetId = $('#processId').combobox('getValue');
		if(taskSetId && taskSetId != "" && taskSetId != null){
			showModalCenter ("${pageContext.request.contextPath}/mnt/mnt_warn_batch_sel_task.jsp?taskSetId="+taskSetId, function(data){
				$("#taskId").val(data[0].id);
				$("#taskName").val(data[0].name);
			}, "70%", "60%", "选择任务");
		} else {
			$.messager.alert('系统提示','请先选择任务组！','warning');
			return;
		}
		
	}
</script>
</html>

