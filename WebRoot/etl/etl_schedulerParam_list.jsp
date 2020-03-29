<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>调度参数管理</title>
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
.input_file{width:80px; margin-left:-80px;height:21px;  filter:alpha(opacity=0); opacity:0;}
</style>

<script type="text/javascript">
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
});

								function getTemplate(){
									$('#formSearch').form('submit',{
									url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"SchedulerParam"
									});
								}
							
								function getTaskByPage(){
									var pageNo = $('#deptGrid').datagrid('getPager');
									var pageSize = $(pager).pagination("options");
									window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"SchedulerParam&pageSize="+pageSize+"&pageNo="+pageNo;
									return false;
								}
							
								function getTaskByData(){
									$('#formSearch').form('submit',{
										url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"SchedulerParam"
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
										 if(updateUpdata!=null&&updateUpdata!=""){
												messager.progress(obj);
											   $.ajaxFileUpload({  
										        	 url: "inputExcel_inputExcelBatchParam.action?modelName="+"BatchParam",
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
										                	for(var i=0;i<zNodes.length;i++){
										                		errorInfo+=zNodes[i]+"\r\r";
										                    }
										                	 messager.close();  
										                	 $.messager.alert('系统提示',errorInfo,'warning');    
										                }  else{
										                	 messager.close();  
										                	 $.messager.alert('系统提示','导入成功！','warning');
										                	 etlschedulerParam.reload();
											                 }
										            	                 
										             }
										         });
											 }else{
												 $.messager.alert('系统提示','请选择导入文件！！！','warning');
											}
								        
								}
			
							
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">批次编号：</td>
				<td height="40px">
					<input type="text" name="batchId" id="batchId" class="input_eq" style="width:100px"/>
				</td>
				<td height="40px">参数名称：</td>
				<td height="40px">
					<input type="text" name="paramName" id="paramName" class="input_eq" style="width:100px"/>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查 询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	
		<div class="gridDiv">
			<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" rownumbers="false" singleSelect="false" editable="true" url="batchParam_list.action" striped="true" fit="true" height="100%"  title="调度参数管理" id="etlschedulerParam">
			<r:toolbar id="addRow" text="添加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>    
			<r:toolbar text="删除" iconCls="icon-remove" onClick="remove();"></r:toolbar> 
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editParam();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
			<r:toolbar text="导出模板" iconCls="icon-exportTemplate" onClick="getTemplate();"></r:toolbar>
			<r:toolbar text="<input style='border: 1px #c0c0c0 solid; height: 20px; width:150px; margin-top:-25px' type='text' id='txt1' name='txt1' /><input type='button' style='height: 22px;margin-top:-25px' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/>"></r:toolbar>>
			<r:toolbar text="导入" iconCls="icon-import" onClick="inExcel();"></r:toolbar>
			<r:toolbar text="导出" iconCls="icon-export" onClick="getTaskByData();"></r:toolbar>
			<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
			<r:col  field="batchId" title="批次ID" sortable="true" width="120">
				<r:editorCombobox  editable="false" required="true" missingMessage="不能为空" url="${pageContext.request.contextPath}/batch_list.action" valueField="batchId" textField="batchId"></r:editorCombobox>
			</r:col>
			
			<r:col field="paramId" editable="false" sortable="true" title="参数ID" width="150">
				<r:editorText validType="paramIdValid" required="true" missingMessage="不能为空"></r:editorText>
			</r:col>
			<r:col field="paramName" title="参数名称" sortable="true" width="170"></r:col> 
			<r:col field="paramType" title="参数类型" sortable="true" dictId="etl.paramType" width="180">
				<r:editorDictSelect required="true" missingMessage="不能为空" onSelect="vvv(record);"></r:editorDictSelect>
			</r:col>    
			<r:col field="paramValue" title="参数值" sortable="true" width="160" >
				<r:editorText required="true" missingMessage="不能为空"></r:editorText>
			</r:col>    
			
			<r:col field="forecastType" title="预处理类型" sortable="true" dictId="etl.forecastType" width="180">
				<r:editorDictSelect required="true" missingMessage="不能为空"></r:editorDictSelect>
			</r:col> 
			
			<r:col  field="serverId" title="服务器ID" sortable="true" width="180">
				<r:editorCombobox  editable="false" url="${pageContext.request.contextPath}/server_findAllServersByCombobox.action" required="true" missingMessage="不能为空" valueField="serverId" textField="serverId"></r:editorCombobox>
			</r:col> 
			<r:col field="remark"  title="备注" sortable="true" width="100"></r:col>
		<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>>
	</r:grid>
		
	</div>

</body>
<script>

function editParam(){
	  var changes = etlschedulerParam.getChanges();
	  if(!etlschedulerParam_index){
		  if(!(changes &&changes.length > 0)){
			var selected = etlschedulerParam.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlschedulerParam.getRowIndex(selected[0]);
				etlschedulerParam_index = rownum;
				etlschedulerParam.removeEditor(['paramId']);
				etlschedulerParam.beginEdit(rownum);
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			$('#addRow').attr('disabled','false');
			}
		}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}

function cancelEdit(){
	etlschedulerParam.endEdit(etlschedulerParam_index);
	etlschedulerParam_index = null;
	etlschedulerParam.rejectChanges();
	$('#editRow').removeAttr("disabled");
	$('#addRow').removeAttr("disabled");
}

//重置查询信息
function rese(){
	$('#batchId').val('');
	$('#paramName').val('');
}

function submi(){
	var jsonData = {
			batchId:$('#batchId').val(),
			paramName:$('#paramName').val(),
			newpage:1,page:1
			};
	etlschedulerParam.load(jsonData);
	
}
$.extend($.fn.validatebox.defaults.rules, {
    paramIdValid: {
        validator: function (value) {
        	if(/^@(\w){3,16}$/.test(value)){
				  if(value){
					  	var rows=etlschedulerParam.getData();
					  	var tar=$("#etlschedulerParam").datagrid('getEditor',{index:etlschedulerParam_index,field:'batchId'}).target;
					  	var batchId=tar.combobox('getValue');
				        var exist=$.ajax({
				                url:"batchParam_checkunique.action?paramId="+value+"&batchId="+batchId,
				                data:{},
				                async:false
				            }).responseText;
				        if(exist=="0"){
							 $.fn.validatebox.defaults.rules.paramIdValid.message ="";
				            return true;
				        }else{
				        	$.fn.validatebox.defaults.rules.paramIdValid.message ="参数ID重复，无法使用！";
				            return false;
					    }
			        }else{
			        	$.fn.validatebox.defaults.rules.paramIdValid.message ="";
			            return true;
				    }
			}else{
				 $.fn.validatebox.defaults.rules.paramIdValid.message ="只可输入3-16位以@符开头英文数字和_";
				return false;
			}
	      
    	},
   		 message: ''
 	}
	
});

function save(){
	$.messager.confirm('系统提示','确定要保存记录吗',function(btn){
     	if(btn){
			etlschedulerParam.endEdit(etlschedulerParam_index);
			var vali = etlschedulerParam.validateRow(etlschedulerParam_index);
			if(vali){
				var selected = etlschedulerParam.getChanges('inserted');
				
				if(selected.length>1){
					$.messager.alert('系统提示','保存只能一个！','warning');
				}else{
					if(selected.length==0){
						selected = etlschedulerParam.getChanges('updated');
					}
					//if(selected.length==0){
						//$.messager.alert('系统提示','请选择编辑后再保存!','warning');
						//return;
					//}
					var uuid = selected[0].uuid;
					var batchId=selected[0].batchId;
					var paramId=selected[0].paramId;
					var paramName=selected[0].paramName;
					var paramValue=selected[0].paramValue;
					var paramType=selected[0].paramType;
					var serverId =selected[0].serverId;
					var forecastType=selected[0].forecastType;
					var runState=selected[0].runState;
					var errorMessage=selected[0].errorMessage;
					var remark=selected[0].remark;
					if(paramId!=""){
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "Json",
								data:{uuid:uuid,batchId:batchId,serverId:serverId,paramId:paramId,paramName:paramName,paramValue:paramValue,paramType:paramType,forecastType:forecastType,remark:remark},
								url: "batchParam_save.action",
								error:function(data){
											$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
									},
								success:function(data){
									
										  if(data=="1"){
											  
											  	$.messager.alert('系统提示','保存成功','warning');
											  	etlschedulerParam.reload();
											  	$('#editRow').removeAttr("disabled");
												$('#addRow').removeAttr("disabled");
												etlschedulerParam_index = null;
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
	function remove(){
		$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
         	if(btn){
		var uuids = [];
		var serverIds=[];
		var selected = etlschedulerParam.getAllSelected();
		for(var i=0; i<selected.length; i++){
		    uuids.push(selected[i].uuid);
		    serverIds.push(selected[i].serverId);
		}
		if(selected.length== 0) {
			$.messager.alert('系统提示','请选择要删除的记录','warning');
			return;
		}else{
			
			$.ajax({
			
				type: 'post',
				dataType : "Json",
				url: "${pageContext.request.contextPath}/batchParam_remove.action?uuids="+uuids+"&serverIds="+serverIds,
				success:function(data){
						window.location.href="${pageContext.request.contextPath}/etl/etl_schedulerParam_list.jsp";
						return false; 	 
					}
			});
			
	}
         	}
     	});
	}
	function appendRow(){
		  var changes = etlschedulerParam.getChanges();
		  if(!etlschedulerParam_index&&!(changes &&changes.length > 0)){
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			$('#addRow').attr('disabled','false');
			var newrow = {batchId:"",paramId:"",serverId:"",paramName:"",paramValue:"",paramType:"",forecastType:"",remark:""};
			var edit =  {
					field:"paramId", 
					editor:{
							type:'validatebox',
							options:{
								validType:"paramIdValid",
								required:"true",
								missingMessage:"不能为空"
							}
					}
			};
			
			etlschedulerParam.appendRow(newrow,edit);
			var rows = etlschedulerParam.getRows();
			etlschedulerParam_index = rows.length-1;  
			etlschedulerParam.beginEdit(rows.length-1);
		  }else{
			  $.messager.alert('系统提示','当前有正在编辑！','warning');
			  }
	}


	function vvv(record){
		if (record.id=="1") {
			
			var e = etlschedulerParam.getEditor(
					{
						'index' : etlschedulerParam_index,
						'field' : 'serverId'
					}).target;
					e.combobox( {required : true,width:180});
			var editor = etlschedulerParam.getEditor(
							{
								'index' : etlschedulerParam_index,
								'field' : 'forecastType'
							});
			editor.target.combobox( {
						required : true,
						width:180
					});

			
				
		} else {
			var target = etlschedulerParam.getEditor(
					{
						'index' : etlschedulerParam_index,
						'field' : 'forecastType'
					}).target;
			target.combobox( {
						required : false,
						width:180
					});
			var editor = etlschedulerParam.getEditor(
					{
						'index' : etlschedulerParam_index,
						'field' : 'serverId'
					}).target;
					editor.combobox( {required : false,width:180});


		}
		}
	</script>
</html>

