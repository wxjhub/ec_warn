<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String model = request.getParameter("modelName");
	String processId = request.getParameter("processId");
%>
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务状态管理</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
		body {
			font-family: "微软雅黑";
		}
		.font{color:red}
</style>
<script type="text/javascript">		
//调整grid的高度
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent().height());
});
			//查询提交
			$('#filter_submit').click(function(){
				var jsonData = {
						taskId:$('#taskId').val(),
						runFlag:$('#runFlag').combobox('getValue'),
						newpage:1,page:1
						};
				etlTaskStatus.load(jsonData);
			});
		
			//重置查询信息
			$('#filter_reset').click(function(){
				//$('#batchName').val('');
				$('#taskId').val('');
				$('#runFlag').val('');
			});
			var data = [{'id':'1','text':'正在运行'},{'id':'2','text':'已经完成'},{'id':'0','text':'未运行'},{'id':'3','text':'停止'},{'id':'-1','text':'出错！！'}];
			function formatDate(value) {
				if(value!=null&&value!=""){

				var m = value.month + 1;
				var d = value.date;
				var y = value.year + 1900;
				var h = value.hours;
				var min = value.minutes;
				var s = value.seconds;
				if(m<10) m = '0' + m;
				if(d<10) d = '0' + d;
				if(h<10) h = '0' + h;
				if(min<10) min = '0' + min;
				if(s<10) s = '0' + s;
				return y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;
				}
			}
</script>
</head>
<body>

	<form name="formSearch" id="formSearch" method="post" style="padding: 0px 0 0px 0px;">
		<INPUT name="pageNo" id="pageNo" type="hidden" value="${param.pageNo}"> 
		<INPUT name="jobId" id="jobId" type="hidden" value="${jobId}"> 
		<INPUT name="processId" id="processId" type="hidden" value="${processId}"> 
		<!--<table cellSpacing="0" cellpadding="0" border="0">
		
			<tr>
				<td height="40px">任务编号：</td>
				<td height="40px">
					<input id="taskId" name="taskId" value="" class="input_eq" style="width:100px"/> 
				</td>
				<td height="40px">运行状态：</td>
				<td height="40px">
					
					<select id="runFlag" required="true" editable="false" missingMessage="请选择运行状态"name="runFlag" class="easyui-combobox"  style="width: 100px;">
                            <rmp:option dictId="etl.taskflag.runflag"  currentValue="请选择"></rmp:option>
					</select>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset" value="重 置"/>
				</td>
			</tr>
		</table>-->
	</form>
	<div class="gridDiv">                                                                                                                            
	<r:grid sortable="true" remoteSort="true" pagination="true" hasTip="true" idField="taskId" singleEdit="true" editable="true" url="taskStatus_findAllTaskStatus.action?jobId=\"+$('#jobId').val()+\"&processId=\"+$('#processId').val()+\"" striped="true" fit="true" height="100%"  title="任务状态管理" id="etlTaskStatus" rownumbers="false" singleSelect="false">
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editProcessStatus();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
			<r:toolbar text="返回" iconCls="icon-back" onClick="goback();"></r:toolbar>
			<r:col field="uuid" checkbox="true" editable="false"></r:col>   
			<r:col field="batchId" title="批次编号"  align="center" sortable="true" width="100" editable="false"></r:col>
			<r:col field="jobId" title="作业编号"  align="center" sortable="true" width="100" editable="false"></r:col>
			<r:col field="processId" title="任务组编号" sortable="true" editable="false" align="center" width="100" ></r:col>  
			<r:col field="taskId" title="任务编号" sortable="true" editable="false" align="center" width="100" ></r:col>  
			<r:col field="taskName" title="任务名称" sortable="true" editable="false" align="center" width="100" ></r:col>  
			<r:col field="scriptName" title="脚本名称" sortable="true" editable="false" align="center" width="100" ></r:col>  
			<r:col field="dataDate"  editable="false" title="数据日期" sortable="true" align="center" width="80" rowspan="2" >   
					<r:editorDate  format="yyyy-MM-dd"/>
			</r:col>  
			<r:col  field="startTime" editable="false" title="开始时间" sortable="true" align="center" width="130" rowspan="2" >   
					<r:editorDate  hasTime ="true" format="yyyy-MM-dd"/>
			</r:col>  
			<r:col  field="endTime" editable="false" title="结束时间" sortable="true" align="center" width="130" rowspan="2" >
					<r:editorDate  hasTime ="true" format="yyyy-MM-dd"/>
			</r:col>  
			<r:col field="runTime" editable="false" title="运行时间" sortable="true" align="center" width="60" ></r:col>  
			<r:col formatter="formatterRunFlag(value)" field="runFlag" sortable="true" title="运行状态"  align="center" width="80">
				<r:editorCombobox editable="false" required="true" missingMessage="不能为空"  data="data" valueField="id"></r:editorCombobox>
			</r:col> 
			<r:col field="errorMessage" title="状态信息" sortable="true" editable="false" align="center" width="100" ></r:col>  
		</r:grid>
	</div>
</body>

<script type="text/javascript">

function editProcessStatus(){
	  var changes = etlTaskStatus.getChanges();
	  if(!etlTaskStatus_index&&!(changes &&changes.length > 0)){

			var selected = etlTaskStatus.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlTaskStatus.getRowIndex(selected[0]);
				etlTaskStatus_index = rownum;
				etlTaskStatus.beginEdit(rownum);
			$('#editRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
	  }
}

function cancelEdit(){
	etlTaskStatus.endEdit(etlTaskStatus_index);
	etlTaskStatus_index = null;
	etlTaskStatus.rejectChanges();
	$('#editRow').removeAttr("disabled");
}
function  formatterRunFlag(value){

	if(value == "2"){
		return "已经完成";
	}else if(value == "-1"){
		return "出错！！";
	}else if(value == "1"){
		return "正在运行";
	}else if(value == "0"){
		return "未运行";
	}else if(value == "3"){
		return "停止";
	}
	
}



function save(){
	$.messager.confirm('系统提示','确定要保存记录吗',function(btn){
     	if(btn){
     		etlTaskStatus.endEdit(etlTaskStatus_index);
			var vali = etlTaskStatus.validateRow(etlTaskStatus_index);
    		if(vali){
				var selected = etlTaskStatus.getChanges('inserted');
				
				if(selected.length>1){
					$.messager.alert('系统提示','保存只能一个！','warning');
				}else{
					if(selected.length==0){
						selected = etlTaskStatus.getChanges('updated');
					}
					if(selected.length==0){
						$.messager.alert('系统提示','请选择编辑后再保存!','warning');
						return;
					}
					var uuid = selected[0].uuid;
					var batchId=selected[0].batchId;
					var jobId=selected[0].jobId;
					var processId=selected[0].processId;
					var taskId=selected[0].taskId;
					var taskName=selected[0].taskName;
					var dataDate= selected[0].dataDate;
					var startTime="";
					if(selected[0].endTime){
						startTime=selected[0].startTime;
					}
					var endTime="";
					if(selected[0].endTime){
						endTime=selected[0].endTime;
					}
					var runTime=selected[0].runTime;
					var runFlag=selected[0].runFlag;
					var scriptName=selected[0].scriptName;
					var errorMessage=selected[0].errorMessage;
					if(uuid!=""){
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "text",
								data:{uuid:uuid,batchId:batchId,jobId:jobId,processId:processId,startTime:startTime,taskId:taskId,taskName:taskName,endTime:endTime,runTime:runTime,scriptName:scriptName,dataDate:dataDate,errorMessage:errorMessage,runFlag:runFlag},
								url: "taskStatus_save.action",
								error:function(data){
											$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
									},
								success:function(data){
											  if(data=="1"){
												$.messager.alert('系统提示','保存成功','warning');
													etlTaskStatus.reload();
												  	$('#editRow').removeAttr("disabled");
											}else{
												$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
												}
										}
							});
		
					}else{
								$.messager.alert('系统提示','保存项有空值！','warning');	
						}
				}
     	}else{
			$.messager.alert('系统提示','输入项有错误！','warning');	
		}		
     	}
 	});
		
}
function goback(){
	window.location.href="${pageContext.request.contextPath}/job_toStatusConfig.action?jobId="+$('#jobId').val();
}
</script>
</html>

