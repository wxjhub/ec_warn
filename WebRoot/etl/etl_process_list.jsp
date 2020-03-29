<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN"
	xml:lang="zh-CN">
	
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务组管理</title>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<style type="text/css">
body {
	font-family: "微软雅黑";
	behavior:url(${pageContext.request.contextPath}/css/csshover.htc);
}

.font {
	color: red
}
.inputd
{
width:50px;
}
.input_file{width:70px; margin-left:-70px;height:21px; filter:alpha(opacity=0); opacity:0;}
.top{
	position: relative;
	top:-21px;
}
.margin{
    margin-left:0px;
}

#addprocess1 .l-btn-left{
	padding-top: 3px;
}
#addRowProcess1 .l-btn-left{
	padding-top: 3px;
}
</style>
<script type="text/javascript">
$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 75);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 75);
});
var flag=0;
var TaskRelationData=function(){
	var uuid="";
	var processId="";
	var taskId="";
	var previousTaskId="";
	var pretaskDesc="";
	var processName="";
	var taskDesc="";
};
function testOnSelect(){
	var selected = etlProcess.getAllSelected();
	if(selected.length>1){
		$.messager.alert('系统提示','只能选择一个任务组','warning');
		return;
	}else if(selected.length== 0) {
		$.messager.alert('系统提示','请选择一个任务组','warning');
		return;
	}else{
		processId=selected[0].processId;
		TaskRelationData.processId=processId;
		TaskRelationData.processName=selected[0].processName;
		$("#taskManger").panel("setTitle","任务关系管理    &nbsp;&nbsp;&nbsp;&nbsp;当前任务组:&nbsp;"+selected[0].processName);
		var opt=etlTaskRelation.getOptions();
		opt.url="taskRelation_findAllTaskRelation.action";
		$("#taskRelationForm").hide();
		$("#taskRelationForm").panel("close");
		$("#taskRelationInfo").show();
		etlTaskRelation.load({processId:processId});
		}
}

function testOn(rowIndex,rowData){
	var selectedIndex=rowIndex;	
	var processId=rowData.processId;
	var _uuid = rowData.uuid;
	if(typeof(_uuid)=='undefined' || _uuid==''){
		return;
	}
	TaskRelationData.processId=rowData.processId;
	TaskRelationData.processName=rowData.processName;
	$("#taskManger").panel("setTitle","任务关系管理  ");
	var opt=etlTaskRelation.getOptions();
	opt.url="taskRelation_findAllTaskRelation.action";
	$("#taskRelationForm").hide();
	$("#taskRelationForm").panel("close");
	$("#taskRelationInfo").show();
	$("#selectProcessId").val(rowData.processName);
	etlTaskRelation.load({processId:processId});
}
function testOnRelationSelect(rowIndex,rowData){
	selectedRelationIndex=rowIndex;	
	TaskRelationData.uuid=rowData.uuid;
	TaskRelationData.processId=rowData.processId;
	TaskRelationData.taskId=rowData.taskId;
	TaskRelationData.previousTaskId=rowData.previoustaskId;
	TaskRelationData.taskDesc=rowData.taskDesc;
	TaskRelationData.pretaskDesc=rowData.pretaskDesc;
}

function save(){
	etlProcess.endEdit(etlProcess_index);
	var changes = etlProcess.getChanges('inserted'); 
	if(changes.length>1){
		$.messager.alert('系统提示','保存只能一个！','warning');
	}
	else{
		var vali = etlProcess.validateRow(etlProcess_index);
		if(vali){
			if(changes.length==0){
				changes = etlProcess.getChanges('updated');
			} 
			var uuid=changes[0].uuid;
			var processId=changes[0].processId;
			var processName=changes[0].processName;
			var useText=changes[0].useText;
			var createTime=changes[0].createTime;
			if(processId!=""){
					$.ajax({
						cache:false,
						type: 'post',
						dataType : "Json",
						data:{uuid:uuid,processId:processId,processName:processName,useText:useText,createTime:createTime},
						url: "process_save.action",
						success:function(data){
							var result=eval("(" + data + ")");
							if(result==1){
								$.messager.alert('系统提示','保存成功','warning');	
								etlProcess.reload();	
								$('#editRowProcess').removeAttr("disabled");
								$('#addRowProcess').removeAttr("disabled");	
							//	 batchId=batchId1;
								
							}
							else if(result==2){
								$.messager.alert('系统提示','存在此数据','warning');
								etlProcess.deleteRow(etlProcess_index);
							}
							else if(result==3){
								$.messager.alert('系统提示','修改成功','warning');
								etlProcess.reload();
																											
							}
						}
					});
			}
			else
			{
				$.messager.alert('系统提示','保存项有空值！','warning');	
						
			}
		}else{
			$.messager.alert('系统提示','输入项有错误！','warning');

		}
		
	}
}
function configRelation(){
	window.location.href = "${pageContext.request.contextPath}/process_toConfig.action?processId="
		+ processId;
	return false;
}

function del(){
	var uuids = [];
	var selected = etlProcess.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    uuids.push(selected[i].uuid);
	}
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要删除的记录','warning');
		return;
	}else{
		$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
			if(btn){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuids[0]},
					url: "process_remove.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','删除成功','warning');
							etlProcess.reload();										
						}else if(result==2){
							$.messager.alert('系统提示','该任务组在批次里有记录！','warning');																
						}else{
							$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
						}
					}
				});
				}
			});
		
	}
}
function yhd(){
	$('#preTaskTypeId').combobox({
		onSelect: function(){
		
 		//changeOption1();
			}
		});
	$('#currTaskTypeId').combobox({
		onSelect: function(){
 		//changeOption();
			}
		});
}
function dblClickRow(rowIndex,rowData){    
}

function testabc(){
	//alert("test");
}     
function testBeforeLoad(){
}
function testLoad(){
	userGrid.load({
		d:32,
		abc:'abc'
		});
}
function appendRow(){
	 var changes = etlProcess.getChanges();
	  if(!etlProcess_index&&!(changes &&changes.length > 0)){
			$('#editRowProcess').removeAttr("disabled");
			$('#addRowProcess').removeAttr("disabled");
			$('#editRowProcess').attr('disabled','false');
			$('#addRowProcess').attr('disabled','false');
			var newrow = {"processId":"","processName":"","useText":"","createTime":""};
			var edit =  {
					field:"processId", 
					editor:{
						type:'validatebox',
						options:{
							validType:"processIdValidator",
							required:"true",
							missingMessage:"不能为空"
						}
					}
			};
			etlProcess.appendRow(newrow,edit);
			var rows = etlProcess.getRows();
			etlProcess_index = rows.length-1;  
			etlProcess.beginEdit(rows.length-1);
			etlTaskRelation.load({processId:"@"});
			$("#selectProcessId").val("");
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}
function selectRelationRow(rowIndex,rowData){	
	selectedRelationIndex=rowIndex;	
	processId=rowData.processId;
	etlTaskRelation.load({processId:processId});
}

function btnAdd(){
	if(typeof(TaskRelationData.processId)=="undefined") {
		$.messager.alert('系统提示','请选择要增加的任务组','warning');
	}
	else{
		$("#taskRelationInfo").hide();
		$("#taskRelationForm").panel("open");
		$("#taskRelationForm").show();
		$("#taskManger").panel("setTitle","任务关系配置");
		$("#currTask").empty();
		$("#selectTaskRelation").empty();
		$("#taskRelationLeft").empty();
		$("#processName1").val(TaskRelationData.processId);
		$("#uuid").val('');
		
		queryTaskType();  
	}
}
function btnEdit(){
	if(typeof(TaskRelationData.uuid)=="undefined") {
		$.messager.alert('系统提示','请选择要重新编辑的任务关系','warning');
	}else{
		$("#taskRelationInfo").hide();
		$("#taskRelationForm").panel("open");
		$("#taskRelationForm").show();
		$("#currTask").empty();
		$("#selectTaskRelation").empty();
		$("#taskRelationLeft").empty();
		$("#uuid").val(TaskRelationData.uuid);
		$("#processName1").val(TaskRelationData.processId);
		var info=$("<option style='height:60px' value='"+TaskRelationData.taskId+"'>"+TaskRelationData.taskDesc+"</option>");
   		var info_copy=$("<option style='height:60px' value='"+TaskRelationData.previousTaskId+"'>"+TaskRelationData.pretaskDesc+"</option>");
   		$("#currTask").append(info);		
		$("#selectTaskRelation").append(info_copy);
		queryTaskType();  			
	}
}
function btnDel(){
	var uuids = [];
	var processIds=[];
	var taskIds=[];
	var selected = etlTaskRelation.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    uuids.push(selected[i].uuid);
	    processIds.push(selected[i].processId);
	    taskIds.push(selected[i].taskId);
	}
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要删除的记录','warning');
		return;
	}else{
		$.ajax({
			cache:false,
			type: 'post',
			dataType : "Json",
			url: "taskRelation_remove.action?uuids="+uuids+"&processId="+processIds+"&taskId="+taskIds,
			success:function(data){
				var result=eval("(" + data + ")");
				if(result==1){
					$.messager.alert('系统提示','删除成功','warning');
					etlTaskRelation.reload();										
				}else{
					$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
				}
			}
		});
	}
}
function save_process(){

	var flag = true;
	$('#processFormSave input').each(function () {
	    if ($(this).attr('required') || $(this).attr('validType')) {
		    if (!$(this).validatebox('isValid')) {
		        flag = false;
		        return;
		    }
	    }
	});
	
	if (flag){
		document.getElementById("processId").disabled=false;
	    document.forms['processFormSave'].action="${pageContext.request.contextPath}/process_save.action";
		document.forms['processFormSave'].submit();
	}
	else{
	    $.messager.alert('系统提示','表单填写有误！','warning');
	}	
}
function inExcel(){
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在导入请稍后";
	obj.text;
	obj.interval = 400; 
	
	var updateUpdata = $('#upload').val();
	// alert(updateUpdata);
	if(updateUpdata!=null&&updateUpdata!=""){
		messager.progress(obj);
		$.ajaxFileUpload({  
			url: "inputExcel_inputExcelProcess.action?modelName="+"Process",
			secureuri:false,  
			fileElementId: 'upload',//文件选择框的id属性  
			dataType:'json',//服务器返回的格式，可以是json  
			error: function(request) {      // 设置表单提交出错
			 messager.close(); 
			 $.messager.alert('系统提示','导入失败！！','warning');
			},
			success: function(data) { // 设置表单提交完成使用方法
				var zNodes = eval(data); 
				if(zNodes.length>0){
					var errorInfo ="";
					//alert(zNodes);
					for(var i=0;i<zNodes.length;i++){
					//alert(zNodes[i]);
						errorInfo+=zNodes[i]+"\r\r";
					}
					 messager.close();    
					 $.messager.alert('系统提示',errorInfo,'warning');  
				}else{
					 messager.close();    
					 $.messager.alert('系统提示','导入成功！','warning');
					 etlProcess.reload();
				}
				            
			}
		});
	}else{
		 $.messager.alert('系统提示','请选择导入文件！！！','warning');
	}									        
}

function intrExcel(){
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在导入请稍后";
	obj.text;
	obj.interval = 400; 
	
	var updateUpdata = $('#upload1').val();
	if(updateUpdata!=null&&updateUpdata!=""){
		messager.progress(obj);
		$.ajaxFileUpload({  
			url: "inputExcel_inputExcelTaskRelation.action?modelName="+"TaskRelation",
			secureuri:false,  
			fileElementId: 'upload1',//文件选择框的id属性  
			dataType:'json',//服务器返回的格式，可以是json  
			error: function(request) {      // 设置表单提交出错
			 messager.close(); 
			 $.messager.alert('系统提示','导入失败！！','warning');
			},
			success: function(data) { // 设置表单提交完成使用方法
				var zNodes = eval(data); 
				if(zNodes.length>0){
					var errorInfo ="";
					//alert(zNodes);
					for(var i=0;i<zNodes.length;i++){
					//alert(zNodes[i]);
						errorInfo+=zNodes[i]+"\r\r";
					}
					 messager.close();    
					 $.messager.alert('系统提示',errorInfo,'warning');  
				}else{
					 messager.close();    
					 $.messager.alert('系统提示','导入成功！','warning');
				}
				            
			}
		});
	}else{
		 $.messager.alert('系统提示','请选择导入文件！！！','warning');
	}									        
}


function getTemplate(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"Process"
	});
}

function getTaskrelationTemplate(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"TaskRelation"
	});
}

function getTaskByPage(){
	var pageNo = $('#deptGrid').datagrid('getPager');
	var pageSize = $(pager).pagination("options");

	//var pageNo = $('#etlTask').datagrid("pageNumber");
	//var pageSize = $('#etlTask').datagrid("pageSize");
	//alert(pageNo+"="+pageSize);
	window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"Process&pageSize="+pageSize+"&pageNo="+pageNo;
	return false;
}

function getTaskByData(){
		$('#formSearch').form('submit',{
			url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"Process"
		});
}

function getTaskRelationByData(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"TaskRelation"
	});
}
		$(function(){
			//初始化的时候光标停留的地方
			 //双击从左到右 
	        document.getElementById("taskRelationLeft").ondblclick=function(){
	        	move('taskRelationLeft','selectTaskRelation');
			};
			//双击从右到左
			document.getElementById("selectTaskRelation").ondblclick=function(){
				move('selectTaskRelation', 'taskRelationLeft');
	 	    };
	 	   
	 				 	  
		changeOption();
		changeOption1();
	 });	
function saveTaskSelectList(){
	var taskIdOptionValues = "";
	var selectTaskRelation = document.getElementById("selectTaskRelation");
	var selectTaskRelationOptions = selectTaskRelation.options;
	for(var i=0;i<selectTaskRelationOptions.length;i++){
		if(taskIdOptionValues==null||taskIdOptionValues==""){
			taskIdOptionValues = selectTaskRelationOptions[i].value;//后置任务
		}else{
			taskIdOptionValues+=","+selectTaskRelationOptions[i].value;//后置任务
		}
    }
	var uuid=$('#uuid').val();
	var processId=$('#processName1').val();//当前组
	var taskType=$('#currTask').val();//当前任务的类型
	var taskNamedq=$('#currTask').val();//dq任务
	//alert(processId+"-----"+taskType+"-----"+taskNamedq+"------"+taskIdOptionValues);
		$.ajax({
				cache:false,
				type: 'post',
				dataType : "Json",
				url: "taskRelation_saveRealtionTask.action?uuid="+uuid+"&taskIdOptionValues="+taskIdOptionValues+"&taskType="+taskType+"&processId="+processId+"&taskNamedq="+taskNamedq,
				success:function(data){
				var result=eval("(" + data + ")");
				    if(result==1){
						$.messager.alert('系统提示','保存成功','warning');
						$("#taskRelationForm").hide();
						$("#taskRelationForm").panel("close");
						$("#taskRelationInfo").show();
						etlTaskRelation.reload();
						
				    }else{
						$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																										
					}
				}
		});				
}
//返回
function goBack(){
	window.location.href = "${pageContext.request.contextPath}/taskRelation_goBack.action?processId="+'${processId}';
	return false;
}
									 															
function move(from,to){
	var _fromSelect=document.getElementById(from);
	var _fromSelectOptions = _fromSelect.options;
	var ii = _fromSelect.selectedIndex;
	if(ii<0){
		return;
	}
	
	var _toSelect=document.getElementById(to);
	var _toSelectOptions = _toSelect.options;
	//判断选择的option是否在另一个select中已经存在
	for(var i=0;i<_toSelectOptions.length;i++){
		if(_toSelectOptions[i].value==_fromSelectOptions[ii].value){
			_fromSelectOptions.remove(ii);
			_toSelectOptions[i].selected=true;
			return;
		}
	}
	_toSelect.appendChild(_fromSelectOptions.options[ii]);
}																				

function changeOption(){
	//d

	var taskTypeId=$("#currTaskTypeId").val();
	$("#currTask").empty();
	$.ajax( {
		url : 'task_findTaskByTaskType.action',
		type : "POST",
		data : {taskTypeId:taskTypeId},
		dataType : "json",
		success : function(data) {
			var zNodes = eval(data);
			var sele = $("#currTask");
			for(var i=0;i<zNodes.length;i++){
				var v_taskName=zNodes[i].taskName;
				var v_taskId=zNodes[i].taskId;
				var v_taskType=zNodes[i].taskType;
				var v_taskDesc=zNodes[i].taskDesc;
				sele.append("<option value="+v_taskId+">"+ v_taskDesc+"</option>");
			}
		},
		error : function(data) {
			 $.messager.alert('系统提示','批次信息取值出错,请重试!','warning');			
		}
	});
}

function changeOption1(){
	var taskType=$("#preTaskTypeId").val();
	$.ajax( {
		url : 'task_findTaskByTaskType.action?taskTypeId='+taskType,
		type : "POST",
		dataType : "json",
		success : function(data) {
			var zNodes = eval(data);
			var sele = $("#taskRelationLeft");
			sele.html("");
			for(var i=0;i<zNodes.length;i++){
				var v_taskName=zNodes[i].taskName;
				var v_taskId=zNodes[i].taskId;
				var v_taskDesc=zNodes[i].taskDesc;
				sele.append("<option value="+v_taskId+">"+ v_taskDesc+"</option>");
			}
			
		},
		error : function(data) {
			 $.messager.alert('系统提示','批次信息取值出错,请重试!','warning');											
		}
	});		
}

$.extend($.fn.validatebox.defaults.rules, {
	
	processName: {
        validator: function (value) {
	        var processName=$("#processName").val();
	      
	        if(!""==processName||!processName==null){
		            $.fn.validatebox.defaults.rules.processName.message ="请选择任务组！";
		            return true;
	        }else{
	        	$.fn.validatebox.defaults.rules.processName.message ="";
	            return true;
		    }
    	},
   		 message: ''
 	}
});

function show4(){
	var win = $.messager.progress({
		title:'正在保存    请稍等......',
		msg:'正在加载  数据...'
	});
	setTimeout(function(){
		$.messager.progress('close');
	},5000);
}

function queryTaskRelation(){
 //查询框按钮
 	var taskId=$("#taskText").val();
	$.ajax({
		   type: "POST",
		   url: "taskRelation_findTaskByText.action",
		   data: {taskId:taskId},
		   success: function(msg){
			   	var data=$.parseJSON(msg);
				$("#taskRelationLeft").empty();
			   	for(var i=0;i<data.length;i++){
			   		var input_info=$("<option style='height:60px' value='"+data[i].taskId+"'>"+data[i].taskId+"</option>");
			   		$("#taskRelationLeft").append(input_info);
			   	}											   
		   }
	});//end ajax
}

function queryTaskType(selectedTypeId){
	
	$("#currTaskTypeId").empty();
	$("#preTaskTypeId").empty();
	$.ajax({
		   type: "POST",
		   url: "taskRelation_findAllTaskType.action",
		   data: {},
		   success: function(msg){
			   	var data=$.parseJSON(msg);								
				$("#currTaskTypeId").empty();
				var taskType_null=$("<option style='height:60px' value=''></option>");
				var taskType_null_copy=$("<option style='height:60px' value=''></option>");
		   		$("#currTaskTypeId").append(taskType_null);
		   		$("#preTaskTypeId").append(taskType_null_copy);
			   	for(var i=0;i<data.length;i++){
			   		if(!selectedTypeId){
			   			var taskType_info=$("<option style='height:60px' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
			   		}else{
				   		if(selectedTypeId==data[i].taskTypeId){
			   				var taskType_info=$("<option style='height:60px' selected='selected' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
					   	}else{
					   		var taskType_info=$("<option style='height:60px' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
						}
				   	}
			   		var taskType_info_copy=$("<option style='height:60px' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
			   		$("#currTaskTypeId").append(taskType_info);
			   		$("#preTaskTypeId").append(taskType_info_copy);
			   		
			   	}
		   }
	});//end ajax
}
						         
function checkPreTask(){
 	var taskIdOptionValues = "";
	var selectTaskRelation = document.getElementById("selectTaskRelation");
	var selectTaskRelationOptions = selectTaskRelation.options;
	for(var i=0;i<selectTaskRelationOptions.length;i++){
				if(taskIdOptionValues==null||taskIdOptionValues==""){
					taskIdOptionValues = selectTaskRelationOptions[i].value;//后置任务
				}else{
					taskIdOptionValues+=","+selectTaskRelationOptions[i].value;//后置任务
				}
	}
	var taskRelations = etlTaskRelation.getRows();
	var processId=$('#processName1').val();
	var taskNamedq=$('#currTask').val();
	for(var i = 0;i<taskRelations.length;i++){
		var tt = taskRelations[i].taskId;
		var tp = taskRelations[i].previoustaskId;

		if(tt == taskNamedq){
			if(taskIdOptionValues==''&& typeof tp === 'undefined'){
				$.messager.confirm('检查框','数据配置有误！配置的数据中有重复的数据.',null);
				 return ;
			}else if (taskIdOptionValues.indexOf(tp)!=-1){
				$.messager.confirm('检查框','数据配置有误！配置的数据中有重复的数据.',null);
				 return ;
			}
			 
		}
	}
	if(taskNamedq!=null){
		$.ajax({
			cache:false,
			type: 'post',
			dataType : "Json",
			url: "taskRelation_checkPreTask.action?taskIdOptionValues="+taskIdOptionValues+"&processId="+processId+"&taskNamedq="+taskNamedq,
			success:function(data){
					 if(data==1){
						 $.messager.confirm('检查框','数据配置无误.确定提交吗？',function(r){   
							     if (r){   
							    	 saveTaskSelectList();
							    }   
							 });  
					 }else if(data==0||data==2){
						 $.messager.confirm('检查框','数据配置有误！配置的数据中有重复的数据.',function(r){   
						 });  
					 }
				}
		});
	}else{
		$.messager.alert('系统提示','保存项有空值！','warning');	
	}
	
}

function formatDate(value,rowData) {
	if(typeof(rowData.createTime)=="object"&&value!=null&&value!=""){
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
		rowData.createTime=y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;
		return y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;	
	}
}
function editProcess(){
	 var changes = etlProcess.getChanges();
	  if(!etlProcess_index&&!(changes &&changes.length > 0)){
			var selected = etlProcess.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlProcess.getRowIndex(selected[0]);
				etlProcess_index = rownum;
				etlProcess.removeEditor(['processId']);
				etlProcess.beginEdit(rownum);
				$('#editRowProcess').removeAttr("disabled");
				$('#addRowProcess').removeAttr("disabled");
				$('#editRowProcess').attr('disabled','false');
				$('#addRowProcess').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}

function cancelProcess(){
	etlProcess.endEdit(etlProcess_index);
	etlProcess_index = null;
	etlProcess.rejectChanges();
	$('#editRowProcess').removeAttr("disabled");
	$('#addRowProcess').removeAttr("disabled");
	
}
function rese(){
	$('#processId').val('');
	$('#processName').val('');
}

function submi(){
	var jsonData = {
			processId:$('#processId').val(),
			processName:$('#processName').val(),
			newpage:1,page:1
			};
	etlProcess.load(jsonData);
	
}

								
</script>
</head>
<body class="easyui-layout" border="false" onload="page_top()">
<div id="mm" style="width:200px; display:none;">
    <div iconCls="icon-exportTemplate"  onClick="getTemplate();">导出模版</div> 
    <div iconCls="icon-export" onClick="getTaskByData();">导出数据</div>
	<div iconCls="icon-import" onClick="inExcel();">导入</div> 
</div> 
<div id="mm1" style="width:200px; display:none;">
    <div iconCls="icon-exportTemplate"  onClick="getTemplate();">导出模版</div> 
    <div iconCls="icon-export"  onClick="getTaskRelationByData();">导出数据</div>
	<div iconCls="icon-import" onClick="inExcel();">导入</div>  
</div> 
	<div region="west" style="width:500px;border-left: none;overflow: hidden;" border="true" title="任务组管理" >
		<form name="formSearch" id="formSearch" method="post" style="padding: 9px 0 10px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">任务组编号：</td>
				<td height="40px"><input type="text" name="processId"
					id="processId" class="input_eq" style="width: 60px" /></td>
				<td height="40px">任务组名称：</td>
				<td height="40px"><input type="text" name="processName"
					id="processName" class="input_eq" style="width: 60px" /></td>
				<td>
				<input id="filter_submit" class="inputd" type="button" onclick="submi()" value="查 询" /> 
				<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置" />
				</td>
			</tr>
		</table>
		</form>
<div class="gridDiv0" id="gridDiv0">
	<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" editable="true"  singleEdit="true" url="process_findAllProcess.action" striped="true" fit="true" height="100%" id="etlProcess" onSelect="testOn(a,b);" onBeforeLoad="testabc();" rownumbers="false" singleSelect="true">
		<r:toolbar id="addRowProcess1" text="操作"></r:toolbar>
		<r:toolbar text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>
		<r:toolbar text="删除" iconCls="icon-remove" onClick="del();"></r:toolbar>
		<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelProcess();"></r:toolbar>
		<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
		<r:toolbar text="编辑" iconCls="icon-edit" onClick="editProcess();"></r:toolbar>
		<r:toolbar text="关系校验" iconCls="icon-search" onClick="checkTaskRelation();"></r:toolbar>
		<r:toolbar text="<input style='border: 1px #c0c0c0 solid; height: 20px; width:240px; margin-top:-25px' type='text' id='txt1' name='txt1' /><input type='button' style='height: 22px; margin-top:-25px' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/>"></r:toolbar>
		<r:col field="uuid" checkbox="true" editable="false"   width="100" rowspan="2"></r:col>
		<r:col field="processId" title="任务组编号" sortable="true"  width="170" editable="false" rowspan="2">
			<r:editorText validType="processIdValidator" required="true" missingMessage="不能为空">
			</r:editorText>
		</r:col>
		<r:col field="processName" title="任务组名称" sortable="true"  width="210" rowspan="2">
			<r:editorText  required="true" missingMessage="不能为空" ></r:editorText>
		</r:col>
		<r:col field="useText" title="作用描述"  sortable="true"  width="170" rowspan="2"></r:col>
		<r:col  field="createTime" editable="false"  title="任务创建时间"  sortable="true"  width="180" rowspan="2">
			<r:editorDate format="yyyy-MM-dd" hasTime="true"/>
		</r:col>
	<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
	</r:grid>
</div>
</div>

<div region="center" style="width:120px;background-color:#E7F1FD;" border="true" id="taskManger" title="任务关系管理">
<form name="formtrSearch" id="formtrSearch" method="post" style="padding-left: 20px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">选中任务组：</td>
				<td height="40px"><input type="text" name="processId" id="selectProcessId" disabled="disabled" class="input_eq" style="width: 150px" /></td>
		</table>
		</form>
<div class="gridDiv1" id="taskRelationInfo">
	
<r:grid sortable="true" remoteSort="true"  pagination="true" idField="uuid" onDblClickRow="btnEdit();" singleEdit="true" url="" striped="true" fit="true" height="100%"  onSelect="testOnRelationSelect(a,b);" id="etlTaskRelation" onBeforeLoad="testabc();" rownumbers="false" singleSelect="false">
		<r:toolbar  text="　　操作"  id="addprocess1"></r:toolbar>
		<r:toolbar text="增加" iconCls="icon-add" onClick="btnAdd();"></r:toolbar>
		<r:toolbar text="编辑" iconCls="icon-edit" onClick="btnEdit();"></r:toolbar>
		<r:toolbar text="删除" iconCls="icon-remove" onClick="btnDel();"></r:toolbar>
		<r:toolbar text="<input style='border: 1px #c0c0c0 solid; height: 20px; width:240px; margin-top:-25px' type='text' id='txt1' name='txt1' /><input type='button' style='height: 22px; margin-top:-25px' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/>"></r:toolbar>
		<r:col field="uuid" checkbox="true" editable="false"   width="150" rowspan="2">	</r:col>
		<r:col field="taskId" title="任务编号" sortable="true" hidden="true"  width="200" rowspan="2" ></r:col>
		<r:col field="taskDesc" title="任务名称"  sortable="true"   width="200" rowspan="2" ></r:col>
		<r:col field="pretaskDesc" title="前置任务名称" sortable="true"  width="200" rowspan="2" ></r:col>
		<r:col field="previoustaskId" title="前置任务编号" sortable="true" hidden="true"  width="200" rowspan="2"></r:col>
		<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
</r:grid>

</div>	
<div class="easyui-panel" closed="true" noheader="true"  id="taskRelationForm" fit="true" width="auto" style="border: 1px solid #cccccc; background: white;float: right;margin-right: 0px;">
<table  border="1">
	<TR>
		<TD noWrap style="padding-left: 25px;">
		<form id="TaskRelationSearch" name="TaskRelationSearch" method="post">
		<input type="hidden" name="processName1" id="processName1" value="" />
			<table style="width: 470px;">
				<tr><td style="display:none;"><b>uuid:</b></td>
					<td style="display:none;" height="30px;">
					<input type="text" name="uuid" id="uuid" value="" class="input_eq" style="width: 100px;" /></td>
				</tr>
				<tr>
					<td width="100"><b>任务分类:</b></td>
					<td height="30px;">
						<select editable="false" name="currTaskTypeId" onchange="changeOption();" id="currTaskTypeId" style="width: 105px;">
						</select>
					</td>
					
				</tr>
				
				<tr>
					<td width="100"><b>当前任务:</b>&nbsp;
				<td height="30px;">
						<%--<SELECT editable="false" name="currTask" id="currTask" required="true" missingMessage="该输入项为必输项" style="width: 105px;">
						</SELECT>
						 --%>
						<select class="easyui-validatebox" editable="false" name="currTask" id="currTask" required="true" 
						missingMessage="该输入项为必输项" style="width: 105px;" >
						</select>
						</td>
					</td>
				
				</tr>
				<tr>
					<td width="100"><b>前置任务分类:</b></td>
					<td>
						<select editable="false" name="preTaskTypeId" onchange="changeOption1();" id="preTaskTypeId" style="width: 105px;">
						</select>
					</td>
	
	
				</tr>
			</table>
			<div class="zh_btn" style="margin-right: 25px;">
				<div style="float: left; background: #00ccff;">
					<select editable="false" size="10" id="taskRelationLeft" name="trtaskRelationLeft" class="input" style="width: 100px; height: 200px;" multiple="multiple">
					</select>
				</div>
			<div style="float: left; padding: 50px 20px 0 20px;">
				<input type="button" value="" id="PutRightOne" class="add1" onclick="move('taskRelationLeft','selectTaskRelation');" /><br />
				<br />
				<br />
				<br />
				<br />
				<input type="button" value="" id="PutLeftOne" class="add3" onclick="move('selectTaskRelation', 'taskRelationLeft');"/><br />
			</div>
			<div>
				<select editable="false" size="10" id="selectTaskRelation" name="selectTaskRelation" class="input" style="width: 100px; height: 200px;" multiple="multiple">
				</select>
			</div>
			</div>
			<input class="zh_btnbg2" type="button" value="保存" onclick=checkPreTask(); style="margin: 10px 0 10px 0" />
			<input class="zh_btnbg2" type="button" value="返回" onclick=goBack(); style="margin: 10px 0 10px 0"/>
		 </form>
		</TD>
	</TR>
</table>
</div>
</div>


</body>
<script type="text/javascript">

$.extend($.fn.validatebox.defaults.rules, {
	processIdValidator: {
        validator: function (value) {
        	if(/^(\w){3,16}$/.test(value)){
          		  if(value){
  				        var exist=$.ajax({
  				                url:"process_checkunique.action?processId="+value,
  				                data:{},
  				                async:false
  				            }).responseText;
  				        if(exist=="0"){
  							 $.fn.validatebox.defaults.rules.processIdValidator.message ="";
  				            return true;
  				        }else{
  				        	$.fn.validatebox.defaults.rules.processIdValidator.message ="参数ID重复，无法使用！";
  				            return false;
  					    }
  					  
  		        }else{
  		        	$.fn.validatebox.defaults.rules.processIdValidator.message ="";
  		            return true;
  			    }
			}else{
				 $.fn.validatebox.defaults.rules.processIdValidator.message ="只可输入3-16位英文数字和_";
				return false;
			}
	      
    	},
   		 message: ''
 	}
});

function checkTaskRelation(){
	var selected = etlProcess.getAllSelected();
	if(selected.length==0){
		$.messager.alert('系统提示','请选择要检测的任务组！','warning');
	}else if(selected.length>1){
		$.messager.alert('系统提示','同时只能检测一个任务组！','warning');
	}else{
	$.post( 
			"${pageContext.request.contextPath}/relationcheck_TaskCheck.action",
		     {
			 	processId:selected[0].processId
			 },function (data){
				 var result=eval("(" + data + ")");
                 $.messager.alert('系统提示',result.message,'warning');
	});
	}
}
</script>
<script type="text/javascript">
function page_top(){
	//$("#taskRelationInfo .pagination").addClass("top");
	$("#gridDiv0 .datagrid-toolbar").css("height","55px");
	var s =window.screen.width;
	if(s<=1270)
	{
		$("#taskRelationInfo .datagrid-toolbar").css("height","57px");
	}
   
	$(function(){
		$("#addRowProcess1").splitbutton({
			menu:'#mm'
		});
	});
	$(function(){
		$("#addprocess1").splitbutton({
			menu:'#mm1'
		});
	});
	
}
</script>
</html>

