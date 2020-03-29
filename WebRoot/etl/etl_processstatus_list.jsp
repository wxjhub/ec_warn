<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务组状态管理</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
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
$('#filter_submit').click(function(){
	var jsonData = {
			jobId:$('#jobId').val(),
			processId:$('#processId').val(),
			runFlag:$('#runFlag').combobox('getValue'),
			newpage:1,page:1
			};
	etlProcessStatus.load(jsonData);
});

//重置查询信息
$('#filter_reset').click(function(){
	
	$('#processId').val('');
	$('#runFlag').val('');
});
			
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
var data = [{'id':'1','text':'正在运行'},{'id':'2','text':'已经完成'},{'id':'0','text':'未运行'},{'id':'3','text':'停止'},{'id':'-1','text':'出错！！'}];
</script>
</head>
<body>
	 <form name="formSearch" id="formSearch" method="post" style="padding: 0px 0 0px 0px;">
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}">
		<INPUT name="jobId" id="jobId" type="hidden" value="${param.jobId}">
		<!--<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">任务组编号：</td>
				<td height="40px">
					<input id="processId" name="processId" value="" class="input_eq" style="width:100px"/> 
				</td>
				<td height="40px">运行状态：</td>
				<td height="40px">
					 <select name="runFlag" class="easyui-combobox" id="runFlag" style="width: 100px;">
							<rmp:option dictId="etl.taskflag.runflag" prompt=""></rmp:option>
					</select>
					
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset"  value="重 置"/>
				</td>
			</tr>
		</table>-->
	</form> 
	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true"  idField="processId" singleEdit="true" editable="true" url="processStatus_findAllProcessStatus.action?jobId=\"+$('#jobId').val()+\"" striped="true" fit="true" height="100%" title="任务组状态管理" id="etlProcessStatus" rownumbers="false" singleSelect="false">
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editProcessStatus();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
			<r:toolbar text="任务状态配置" iconCls="icon-sysmrg" onClick="taskStatusConfig();return false;"></r:toolbar>
			<r:toolbar text="返回" iconCls="icon-back" onClick="goback();return false;"></r:toolbar>
			<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
			<r:col  field="jobId" title="作业编号" sortable="true"  align="center" width="100" editable="false"></r:col>
			<r:col  field="batchId" title="批次编号" sortable="true"  align="center" width="100" editable="false"></r:col>
			<r:col field="processId" title="任务组编号" sortable="true" editable="false" align="center" width="100" ></r:col> 
			<r:col  field="dataDate"  editable="false" sortable="true" title="数据日期"   width="100" rowspan="2" >   
					<r:editorDate  format="yyyy-MM-dd"/>
			</r:col>  
			<r:col  field="startTime" editable="false" title="开始时间"  sortable="true"  width="150" rowspan="2" >   
					<r:editorDate  hasTime ="true" format="yyyy-MM-dd"/>
			</r:col>  
			<r:col  field="endTime" editable="false" title="结束时间" sortable="true"   width="150" rowspan="2" >
					<r:editorDate  hasTime ="true" format="yyyy-MM-dd"/>
			</r:col>  
			<r:col field="runTime" editable="false" title="运行时间" sortable="true" align="center" width="100" ></r:col>  
			<r:col formatter="formatterRunFlag(value)"    field="runFlag" sortable="true" title="运行状态"  align="center" width="150">
				<r:editorCombobox editable="false" required="true" missingMessage="不能为空"  data="data" valueField="id"></r:editorCombobox>
			</r:col> 
		</r:grid>
	</div>

</body>
<script type="text/javascript">

function editProcessStatus(){
	  var changes = etlProcessStatus.getChanges();
	  if(!etlProcessStatus_index&&!(changes &&changes.length > 0)){    

			var selected = etlProcessStatus.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlProcessStatus.getRowIndex(selected[0]);
				etlProcessStatus_index = rownum;
				etlProcessStatus.beginEdit(rownum);
			$('#editRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
	  }
}

function cancelEdit(){
	etlProcessStatus.endEdit(etlProcessStatus_index);
	etlProcessStatus_index = null;
	etlProcessStatus.rejectChanges();
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

function taskStatusConfig(){
	var selected = etlProcessStatus.getAllSelected();
	if(selected.length==0){
		$.messager.alert('系统提示','请选择要修改的记录','warning');
	}else if(selected.length>1){
		$.messager.alert('系统提示','当前选择的条目大于一个，请选择一个记录进行修改','warning');
	}else{
		window.location.href="${pageContext.request.contextPath}/process_toStatusConfig.action?jobId="+selected[0].jobId+"&processId="+selected[0].processId;
		return false;
	}
}

function save(){
	$.messager.confirm('系统提示','确定要保存记录吗',function(btn){
     	if(btn){
     		etlProcessStatus.endEdit(etlProcessStatus_index);
			var vali = etlProcessStatus.validateRow(etlProcessStatus_index);
    		if(vali){
				var selected = etlProcessStatus.getChanges('inserted');
				
				if(selected.length>1){
					$.messager.alert('系统提示','保存只能一个！','warning');
				}else{
					if(selected.length==0){
						selected = etlProcessStatus.getChanges('updated');
					}
					if(selected.length==0){
						$.messager.alert('系统提示','请选择编辑后再保存!','warning');
						return;
					}
					var uuid = selected[0].uuid;
					var jobId=selected[0].jobId;
					var processId=selected[0].processId;
					var batchId = selected[0].batchId;
					var dataDate=selected[0].dataDate;
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
					
					if(uuid!=""){
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "text",
								data:{uuid:uuid,batchId:batchId,jobId:jobId,processId:processId,dataDate:dataDate,startTime:startTime,endTime:endTime,runTime:runTime,runFlag:runFlag},
								url: "processStatus_save.action",
								error:function(data){
									
											$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
														
									
									},
								success:function(data){
									
										  if(data=="1"){

											  $.messager.alert('系统提示','保存成功','warning');
											  	etlProcessStatus.reload();
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
	window.location.href = "${pageContext.request.contextPath}/etl/etl_job_list.jsp";
	return false;
}
</script>
</html>

