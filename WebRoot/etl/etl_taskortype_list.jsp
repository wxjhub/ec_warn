<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务管理</title>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>

<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
	behavior:url(${pageContext.request.contextPath}/css/csshover.htc);
}
.font{color:red}
#caozuo .l-btn-left{
	padding-top: 3px;
}
.input_file{width:160px; margin-left:-160px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>
<script type="text/javascript">
var temp;
var temp2;
$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 120);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 35);
});
var datascriptType = [{'id':'1','text':'shell'},{'id':'2','text':'bat'},{'id':'3','text':'存储过程'},{'id':'4','text':'perl'}];

//datebox format 方法
function formatDate(value) {
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

function getTemplate(){
	$('#formSearch').form('submit',{
	url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"Task"
});
}

function getTaskByPage(){
	var pageNo = $('#deptGrid').datagrid('getPager');
	var pageSize = $(pager).pagination("options");

	//var pageNo = $('#etlTask').datagrid("pageNumber");
	//var pageSize = $('#etlTask').datagrid("pageSize");
	//alert(pageNo+"="+pageSize);
	window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"Task&pageSize="+pageSize+"&pageNo="+pageNo;
	return false;
}

function getTaskByData(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"Task"
	});
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
		        	 url: "inputExcel_inputExcelTask.action?modelName="+"Task",
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
		                }  else{
		                	 messager.close();  
		                	 $.messager.alert('系统提示','导入成功！','warning');
		                	 etlTask.reload();
		                  }
		            	                
		             }
		         });
			 }else{
				 $.messager.alert('系统提示','请选择导入文件！！！','warning');
			}
        
}

function getTaskTypes(){
	$.ajax({
		url : "${pageContext.request.contextPath}/taskType_findTaskTypes.action",
		type : "POST",
		data : "",
		dataType : "json",
		async:false, 
		success : function(data) {
			var zNodes = eval(data);
			for(var i=0;i<zNodes.length;i++){	
				$('#tasktypeid').append("<option value='"+zNodes[i].taskTypeId+"'>"+zNodes[i].taskTypeName+"</option>");
			}
		},
		error : function(data) {
			alert("获取任务分类列表信息出错,请重试");
		}
	});
}
</script>

</head>
<body class="easyui-layout" border="false" onload="page_top()">
<div id="mm" style="width:200px;display:none;">
    <div iconCls="icon-export"  onClick="getTaskByData();">数据导出</div> 
    <div iconCls="icon-import" onClick="inExcel();">导入</div>
	<div iconCls="icon-exportTemplate" onClick="getTemplate();">模版导出</div>   
</div> 
<div region="west" style="width:500px;border-left: none;overflow: hidden; " id="west"  border="true" title=
	"任务管理" >
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px" width="60px" >任务编号：</td>
				<td height="40px">
					<input type="text" name="taskId" id="taskId" class="input_eq" style="width:90px"/>
				</td>
				<td height="40px">任务名称：<input type="text" name="taskDesc" id="taskDesc" class="input_eq" style="width:80px"/></td>
				</tr>
				<tr>
				<td height="40px" width="62px" >脚本类型：</td>
				<td height="40px" width="50px" >
					<select name="scriptType"   id="scriptType">
					    <option value="">---请选择---</option>
						<rmp:option dictId="etl.script.type"></rmp:option>
					</select>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" onclick="submi()" value="查 询" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
		<div class="gridDiv0" id="gridDiv0">
		<r:grid sortable="true" remoteSort="true"  pagination="true"  idField="uuid" singleEdit="true" fit="true" rownumbers="false" singleSelect="true" editable="true" url="task_findAllTasks.action" striped="true" height="100%" id="etlTask">
			<r:toolbar text="操作" id="caozuo"></r:toolbar>
			<r:toolbar id="addRowTask" text="添加" iconCls="icon-add" onClick="appendRow_task();"></r:toolbar>    
			<r:toolbar text="删除" iconCls="icon-remove" onClick="removeTask();"></r:toolbar> 
			<r:toolbar text="保存" iconCls="icon-save" onClick="save_task();"></r:toolbar>
			<r:toolbar id="editRowTask" text="编辑" iconCls="icon-edit" onClick="editTask();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEditTask();"></r:toolbar>
			<r:toolbar text="<input style='border: 1px #c0c0c0 solid; height: 20px; width:240px;margin-top:-25px' type='text' id='txt1' name='txt1' /><input type='button' style='height: 22px;margin-top:-25px' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/>"></r:toolbar>
			
		
			<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
			<r:col  field="taskId" editable="false" title="任务编号" sortable="true"   width="110" >
							<r:editorText   validType="taskIdValidator" required="true" missingMessage="不能为空"></r:editorText>
			</r:col>
			<r:col field="taskDesc"  title="任务名称" width="100" sortable="true"     >
								<r:editorText  required="true" missingMessage="不能为空"></r:editorText>
			</r:col>
			<r:col field="scriptName"  title="程序脚本名称" width="200"  sortable="true"   >
								<r:editorText  required="true" missingMessage="不能为空"></r:editorText>
			</r:col>
			<r:col field="taskName"  title="程序名称"   width="100" sortable="true" editable="false">
				
			</r:col>   
			<r:col field="taskType" title="任务分类"    width="150" objName="taskTypeName" sortable="true" >
				<r:editorCombobox editable="false" required="true"  url="${pageContext.request.contextPath}/taskType_findTaskTypes.action" missingMessage="不能为空" valueField="taskTypeId" textField="taskTypeName"></r:editorCombobox>
			</r:col> 
			<r:col  field="server" title="服务器名称" width="150" objName="serverName" sortable="true" >
				<r:editorCombobox editable="false" required="true" missingMessage="不能为空" url="${pageContext.request.contextPath}/server_findAllServersByCombobox.action" valueField="serverId" textField="serverName"></r:editorCombobox>
			</r:col> 
			<r:col field="scriptType" title="任务脚本类型" dictId="etl.script.type"  sortable="true"  width="150">
				<r:editorDictSelect required="true" missingMessage="不能为空"></r:editorDictSelect>
			</r:col> 
			<r:col field="useText"  title="作用描述" width="60"  sortable="true"    ></r:col>
			
				<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
		</r:grid>
		</div>
		</div>
		 <div region="center" id="resourceList" style="background-color:#E7F1FD;" border="true" title="任务类型管理" >
		<div class="gridDiv1">
			<r:grid sortable="true" remoteSort="true"  pagination="true" idField="uuid" editable="true" singleEdit="true" rownumbers="false" singleSelect="false" 
					url="taskType_findAllTaskTypes.action"  striped="true" fit="true" height="100%" id="etlTaskType">
				<r:toolbar id="addRowTaskType" text="添加" iconCls="icon-add" onClick="appendRow_type();"></r:toolbar>    
				<r:toolbar text="删除" iconCls="icon-remove" onClick="removeType();"></r:toolbar> 
				<r:toolbar text="保存" iconCls="icon-save" onClick="save_taskType();"></r:toolbar>
				<r:toolbar id="editRowTaskType" text="编辑" iconCls="icon-edit" onClick="editTaskType();"></r:toolbar>
				<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEditTaskType();"></r:toolbar>
				<r:col  field="taskTypeId" checkbox="true" sortable="true"  editable="false"></r:col>   
				<r:col  field="taskTypeName" title="任务分类名称" sortable="true"    width="110">
						<r:editorText  required="true" missingMessage="不能为空"></r:editorText>
				</r:col>
				<r:col field="taskTypeDesc" title="任务分类描述" sortable="true"    width="200"></r:col>   
				<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>

			</r:grid>
			</div>
		</div>
</body>
<script>
function editTask(){
	var changes = etlTask.getChanges();
	  if(!etlTask_index&&!(changes &&changes.length > 0)){
			var selected = etlTask.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlTask.getRowIndex(selected[0]);
				etlTask_index = rownum;
				etlTask.removeEditor(['taskId']);
				etlTask.beginEdit(rownum);
			$('#editRowTask').removeAttr("disabled");
			$('#addRowTask').removeAttr("disabled");
			$('#editRowTask').attr('disabled','false');
			$('#addRowTask').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}

function cancelEditTask(){
	etlTask.endEdit(etlTask_index);
	
	
	etlTask_index = null;
	etlTask.rejectChanges();	
	$('#editRowTask').removeAttr("disabled");
	$('#addRowTask').removeAttr("disabled");
}


function editTaskType(){
	  var changes = etlTaskType.getChanges();
	  if(!etlTaskType_index&&!(changes &&changes.length > 0)){
			var selected = etlTaskType.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlTaskType.getRowIndex(selected[0]);
				etlTaskType_index = rownum;
				etlTaskType.beginEdit(rownum);
			$('#editRowTaskType').removeAttr("disabled");
			$('#addRowTaskType').removeAttr("disabled");
			$('#editRowTaskType').attr('disabled','false');
			$('#addRowTaskType').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}

function cancelEditTaskType(){
	etlTaskType.endEdit(etlTaskType_index);
	etlTaskType_index = null;
	etlTaskType.rejectChanges();	
	$('#editRowTaskType').removeAttr("disabled");
	$('#addRowTaskType').removeAttr("disabled");
}
function submi(){
	var jsonData = {
			taskId:$('#taskId').val(),
			taskDesc:$('#taskDesc').val(),
			scriptType:$('#scriptType').val(),
			newpage:1,page:1
			};
	etlTask.load(jsonData);
	
}

//重置查询信息
function rese(){
	$('#taskId').val('');
	$('#taskDesc').val('');
	$('#scriptType').val('');
}

$.extend($.fn.validatebox.defaults.rules, {
	taskIdValidator: {
        validator: function (value) {
        	if(/^(\w){3,16}$/.test(value)){
				  if(value){
				        var exist=$.ajax({
				                url:"task_checkunique.action?taskId="+value,
				                data:{},
				                async:false
				            }).responseText;
				        if(exist=="0"){
							 $.fn.validatebox.defaults.rules.taskIdValidator.message ="";
				            return true;
				        }else{
				        	$.fn.validatebox.defaults.rules.taskIdValidator.message ="参数ID重复，无法使用！";
				            return false;
					    }
			        }else{
			        	$.fn.validatebox.defaults.rules.taskIdValidator.message ="";
			            return true;
				    }
			}else{
				 $.fn.validatebox.defaults.rules.taskIdValidator.message ="只可输入3-16位英文数字和_";
				return false;
			}
	      
    	},
   		 message: ''
 	}
});

		function appendRow_task(){
			var changes = etlTask.getChanges();
			  if(!etlTask_index&&!(changes &&changes.length > 0)){
					$('#editRowTask').removeAttr("disabled");
					$('#addRowTask').removeAttr("disabled");
					$('#editRowTask').attr('disabled','false');
					$('#addRowTask').attr('disabled','false');
					var newrow = {"taskId":"","taskName":"","taskDesc":"","scriptName":"","taskType":"","server":"","scriptType":"","useText":""};
					var edit =  {
							field:"taskId", 
							editor:{
								type:'validatebox',
								options:{
									validType:"taskIdValidator",
									required:"true",
									missingMessage:"不能为空"
								}
							}
					};
					
					etlTask.appendRow(newrow,edit);
					var rows = etlTask.getRows();
					etlTask_index = rows.length-1;  
					etlTask.beginEdit(rows.length-1);
			  }else{
				  $.messager.alert('系统提示','当前有正在编辑！','warning');
				  }
		}
		
		function appendRow_type(){
			var changes = etlTaskType.getChanges();
			  if(!etlTaskType_index&&!(changes &&changes.length > 0)){
					$('#editRowTaskType').removeAttr("disabled");
					$('#addRowTaskType').removeAttr("disabled");
					$('#editRowTaskType').attr('disabled','false');
					$('#addRowTaskType').attr('disabled','false');
					var newrow = {"taskTypeName":"","taskTypeDesc":""};
					etlTaskType.appendRow(newrow);
					var rows = etlTaskType.getRows();
					etlTaskType_index = rows.length-1;  
					etlTaskType.beginEdit(rows.length-1);
			  }else{
				  $.messager.alert('系统提示','当前有正在编辑！','warning');
				  }
		}
		
		function removeTask(){
			$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
             	if(btn){
		    var uuids = [];
			var selected = etlTask.getAllSelected();
			for(var i=0; i<selected.length; i++){
			    uuids.push(selected[i].taskId);
			}
			
			if(selected.length == 0) {
				$.messager.alert('系统提示','请选择要删除的用户','warning');
				return;
			}else{
				$.ajax({
					
					type: 'post',
					dataType : "Json",
					url: "${pageContext.request.contextPath}/task_remove.action?uuids="+uuids,
					success:function(data){
							  if(data == 1){
								$.messager.alert('警告提示','存在关联任务，不能删除，请修改后重试！');
							   }else{
								   etlTask.reload();
							   }
						},
						error:function(data){
							 etlTask.reload();
							}
				});
			}
             	}
         	});
		}
		function removeType(){
		    var uuids = [];
			var selected = etlTaskType.getAllSelected();
			for(var i=0; i<selected.length; i++){
			    uuids.push(selected[i].taskTypeId);
			}
			if(selected.length == 0) {
				$.messager.alert('系统提示','请选择要删除的用户','warning');
				return;
			}else{

				$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
                 	if(btn){
        				$.ajax({
        					
        					type: 'post',
        					dataType : "Json",
        					url: "${pageContext.request.contextPath}/taskType_remove.action?uuids="+uuids,
        					success:function(data){
        							  if(data == 1){
        								$.messager.alert('警告提示','存在关联任务，不能删除，请修改后重试！');
        							   }else{
        								   etlTaskType.reload();
        							   }
        						},
        					error:function(data){
        							 etlTaskType.reload();
                					}
        				});
                 	}
             	});
				
				}
			
		}
		function save_task(){
			$.messager.confirm('系统提示','确定要保存记录吗',function(btn){
             	if(btn){
                 	alert(etlTask_index);
             		etlTask.endEdit(etlTask_index);
             		var vali = etlTask.validateRow(etlTask_index);
        			if(vali){
        			var selected = etlTask.getChanges('inserted');
        			
        			if(selected.length>1){
        				$.messager.alert('系统提示','保存只能一个！','warning');
        			}else{
        				if(selected.length==0){
        					selected = etlTask.getChanges('updated');
        				}
        				if(selected.length==0){
        					$.messager.alert('系统提示','请选择编辑后再保存!','warning');
        					return;
        				}
        				var uuid = selected[0].uuid;
        				var taskId=selected[0].taskId;
        				var taskDesc=selected[0].taskDesc;  
        				var taskType=selected[0].taskType.taskTypeId;
        				var scriptName=selected[0].scriptName;
        				var taskName=selected[0].taskName;
        				var scriptType=selected[0].scriptType;
        				var server=selected[0].server.serverId;
        				var useText=selected[0].useText;
        				
        				if(taskId!=""){
        						$.ajax({
        							cache:false,
        							type: 'post',
        							dataType : "Json",
        							data:{uuid:uuid,taskId:taskId,taskDesc:taskDesc,taskType:taskType,scriptName:scriptName,taskName:taskName,scriptType:scriptType,server:server,useText:useText},
        							url: "task_save.action",
        							error:function(data){
            							$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
			

        								},
        							success:function(data){
        									  if(data=="1"){
        										  
        										  	$.messager.alert('系统提示','保存成功','warning');
        										  	etlTask.reload();
        										  	$('#editRowTask').removeAttr("disabled");
        											$('#addRowTask').removeAttr("disabled");
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

		
		function checkuniqueTask(){
		
			$.post( 
				"${pageContext.request.contextPath}/task_checkunique.action",
			     {
				    taskId:$('#taskId').val()
				 },function (data){
					 var result=eval("(" + data + ")");
					 if(result==1)
					 {
						// $.messager.alert('存在此id的task','warning');
						if($('#taskIdOld').val()==""){
							$("#warnMessage").show(4);
						}
						 }	
					 if(result==0)
					 {
						// $.messager.alert('存在此id的task','warning');
						$("#warnMessage").hide(4);
						//$("#submit").attr("disabled", false);
						 }					 					 
				 }

					 
					
			);
			}
		function save_taskType(){
			$.messager.confirm('系统提示','确定要保存记录吗',function(btn){
             	if(btn){
			etlTaskType.endEdit(etlTaskType_index);
			var selected = etlTaskType.getChanges('inserted');
			
			if(selected.length>1){
				$.messager.alert('系统提示','保存只能一个！','warning');
			}else{
				if(selected.length==0){
					selected = etlTaskType.getChanges('updated');
				}
				if(selected.length==0){
					$.messager.alert('系统提示','请选择编辑后再保存!','warning');
					return;
				}
				var taskTypeId = selected[0].taskTypeId;
				var taskTypeName=selected[0].taskTypeName;
				var taskTypeDesc=selected[0].taskTypeDesc;  
				
				if(taskTypeName!=""){
						$.ajax({
							cache:false,
							type: 'post',
							dataType : "Json",
							data:{taskTypeId:taskTypeId,taskTypeName:taskTypeName,taskTypeDesc:taskTypeDesc},
							url: "taskType_save.action",
							error:function(data){
							
										$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
													
												
										
								},
								
							success:function(data){
									  if(data=="1"){
										  
										  	$.messager.alert('系统提示','保存成功','warning');
											etlTaskType.reload();
											$('#editRowTaskType').removeAttr("disabled");
											$('#addRowTaskType').removeAttr("disabled");
									}else{
											$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
														
										
											}
									}
						});

				}else{
							$.messager.alert('系统提示','保存项有空值！','warning');	
					}
			}
             	
              	}
         	});
		}
			
		function checkuniqueTaskType(){
			$.post( 
				"${pageContext.request.contextPath}/taskType_checkunique.action",
			     {
					taskTypeName:$('#taskTypeName').val()
				 },function (data){
					 var result=eval("(" + data + ")");
					 if(result.flag==0&&'${task.taskTypeName}'=="")
					 {
						// $.messager.alert('存在此id的task','warning');

						$("#warnMessage").show(4);
						$("#taskTypeName").focus();
						 }	
					 if(result.flag==1)
					 {
						// $.messager.alert('存在此id的task','warning');

						$("#warnMessage").hide(4);
						 }					 					 
				 }

					 
					
			);
			}
       
function testResize(){
	alert("here");
	etlTask.resize({width:'100%',height:100});
}
</script>
<script type="text/javascript">
function page_top(){
	$("#gridDiv0 .datagrid-toolbar").css("height","55px");
	$(function(){
		$("#caozuo").splitbutton({
			menu:'#mm'
		});
	});
}
</script>
</html>

