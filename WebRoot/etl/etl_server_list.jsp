<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>服务器管理</title>
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

.font{color:red}
.input_file{width:140px; margin-left:-140px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>
</head>
<body>
 <form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">服务器名称：</td>
				<td height="40px">
					<input id="serverName" name="serverName" value="" class="input_eq" style="width:130px"/> 
				</td>
				<td height="40px">服务器类型：</td>
				<td height="40px">
					<select name="serverType"   id="serverType" class="input_eq" style="width:130px" >
						 <rmp:option dictId="etl.serverType" prompt="--请选择--"  defaultValue="" ></rmp:option>
					</select>
				</td>
				<td>
					<input id="filter_submit" class="inputd"  type="button"  onclick="submi()" value="查 询"/>
					<input id="filter_reset" class="inputd" type="button" onclick="clearFun()"   value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	
	<div class="gridDiv">
		<r:grid pagination="true" idField="serverId" fit="false" singleEdit="true" editable="true" url="server_findAllServers.action" striped="true" height="100%"  title="服务器管理" id="etlServer" rownumbers="false" singleSelect="false">
		<r:toolbar text="服务检测" iconCls="icon-search" onClick="checkServerStatus();"></r:toolbar>
		
		<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
		<r:col  field="serverId" title="服务器编号"   width="120" editable="false">
			<r:editorText required="true" missingMessage="不能为空" validType="serverIdValidator"></r:editorText>
		</r:col>
		<r:col field="serverName" title="服务器名称"   width="130" >
			<r:editorText  required="true" missingMessage="不能为空" ></r:editorText>
		</r:col>   
		<r:col field="serverType" title="服务器类型" dictId="etl.serverType"   width="200">
			<r:editorDictSelect required="true" missingMessage="不能为空"></r:editorDictSelect>
		</r:col> 
		
		<r:col field="serverUrl"  title="服务器地址" width="170"    ></r:col>
		<r:col field="serverPort"  title="服务器端口" width="100"    ></r:col>
		<r:col field="serverUserName"  title="用户名" width="150"   ></r:col>
		<r:col field="serverPassWord"  title="密码" width="130"    ></r:col>
		<r:col field="runflg"  title="上次检查运行状态" editable="false" width="120"    formatter="formatterStatus(value)"></r:col>
		<r:pagination id="pag"></r:pagination>
	</r:grid>
		<br>
	</div>
</body>
<script>
function editServer(){
	  var changes = etlServer.getChanges();
	  if(!etlServer_index&&!(changes &&changes.length > 0)){

			var selected = etlServer.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlServer.getRowIndex(selected[0]);
				etlServer_index = rownum;
				etlServer.removeEditor(['serverId']);
				etlServer.beginEdit(rownum);
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			$('#addRow').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
	  }
}

function cancelEdit(){
	etlServer.endEdit(etlServer_index);
	etlServer_index = null;
	etlServer.rejectChanges();
	$('#editRow').removeAttr("disabled");
	$('#addRow').removeAttr("disabled");

}

function formatterStatus(value){
	if(value == '2') {
		return "正常";
	} else if(value == '-1'||value == '1') {
		return "断开连接";
	}else{
		return "";
	}
}

function checkServerStatus(){
	
	var serverIds=[];
	var selected = etlServer.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    serverIds.push(selected[i].serverId);
	}
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要检查的服务器','warning');
		return;
	}else{
		var messager = new Messager();
		var obj = new Object();
		obj.title = "系统提示";
		obj.msg = "正在检查服务器";
		obj.text;
		obj.interval = 400; 
		messager.progress(obj);
				
		$.ajax({
		
			type: 'post',
			dataType : "Json",
			url: "${pageContext.request.contextPath}/server_checkServerState.action?serverIds="+serverIds,
			success:function(data){
				var servers="";
				for(var i=0;i<serverIds.length;i++){
					servers+=serverIds[i];
					if(i!=serverIds.length-1){
						servers+=",";
					}
				}
					  if(data == 1){
						  jsonData = {
								  	serverIds:servers,
									check:1,
									newpage:1
									};
						  messager.close();
						  etlServer.reload(jsonData);
					   }else{
						   messager.close();
						   $.messager.alert('警告提示','检查的服务器出错，请稍后再试！');					   }
				}
		});
		
}
}
function submi(){
	var jsonData;
	if($('#serverType').val()){
		jsonData = {
			serverName:$('#serverName').val(),
			serverType:$('#serverType').val(),
			newpage:1,page:1
			};
		}else{
			jsonData = {
					serverName:$('#serverName').val(),
					newpage:1,page:1
					};
		}
	etlServer.load(jsonData);
	
}


$.extend($.fn.validatebox.defaults.rules, {
	serverIdValidator: {
        validator: function (value) {
        	if(/^(\w){3,16}$/.test(value)){
				  if(value){
					        var exist=$.ajax({
					                url:"server_checkServerId.action?serverId="+value,
					                data:{},
					                async:false
					            }).responseText;
					        if(exist=="0"){
								 $.fn.validatebox.defaults.rules.serverIdValidator.message ="";
					            return true;
					        }else{
					        	$.fn.validatebox.defaults.rules.serverIdValidator.message ="参数ID重复，无法使用！";
					            return false;
						    }
						  
			        }else{
			        	$.fn.validatebox.defaults.rules.serverIdValidator.message ="";
			            return true;
				    }
			}else{
				 $.fn.validatebox.defaults.rules.serverIdValidator.message ="只可输入3-16位英文数字和_";
				return false;
			}
	      
    	},
   		 message: ''
 	}
});

	function save(){
		$.messager.confirm('系统提示','确定要保存记录吗',function(btn){
         	if(btn){
				etlServer.endEdit(etlServer_index);
				var vali = etlServer.validateRow(etlServer_index);
        		if(vali){
					var selected = etlServer.getChanges('inserted');
					
					if(selected.length>1){
						$.messager.alert('系统提示','保存只能一个！','warning');
					}else{
						if(selected.length==0){
							selected = etlServer.getChanges('updated');
						}
						if(selected.length==0){
							$.messager.alert('系统提示','请选择编辑后再保存!','warning');
							return;
						}
						var uuid = selected[0].uuid;
						var serverId=selected[0].serverId;
						var serverName=selected[0].serverName;
						var serverUrl=selected[0].serverUrl;
						var serverPort=selected[0].serverPort;
						var serverUserName=selected[0].serverUserName;
						var serverPassWord=selected[0].serverPassWord;
						var serverType=selected[0].serverType;
						
						if(serverId!=""){
								$.ajax({
									cache:false,
									type: 'post',
									dataType : "Json",
									data:{uuid:uuid,serverId:serverId,serverName:serverName,serverUrl:serverUrl,serverPort:serverPort,serverUserName:serverUserName,serverPassWord:serverPassWord,serverType:serverType},
									url: "server_saveServer.action",
									error:function(data){
										
												$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
															
										
										},
									success:function(data){
										
											  if(data=="1"){
												  
												  	$.messager.alert('系统提示','保存成功','warning');
												  	etlServer.reload();
												  	$('#editRow').removeAttr("disabled");
													$('#addRow').removeAttr("disabled");
											
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
		var cancel=[];
		var selected = etlServer.getAllSelected();
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
				url: "${pageContext.request.contextPath}/server_remove.action?uuids="+uuids+"&serverIds="+serverIds,
				success:function(data){
						  if(data == 1){
							$.messager.alert('警告提示','存在关联任务，不能删除，请修改后重试！');
						   }else{
							window.location.href="${pageContext.request.contextPath}/etl/etl_server_list.jsp"; 
							return false;	 
						   }
					}
			});
			
	}
 	}
	});
	}
	function appendRow(){
		 var changes = etlServer.getChanges();
		  if(!etlServer_index&&!(changes &&changes.length > 0)){
				$('#editRow').removeAttr("disabled");
				$('#addRow').removeAttr("disabled");
				$('#editRow').attr('disabled','false');
				$('#addRow').attr('disabled','false');
				
				var newrow = {"serverId":"","serverName":"","serverType":"","serverUrl":"","serverUserName":""};
				var edit =  {
						field:"serverId", 
						editor:{
							type:'validatebox',
							options:{
								validType:"serverIdValidator",
								required:"true",
								missingMessage:"不能为空"
							}
						}
				};
				
				etlServer.appendRow(newrow,edit);
				var rows = etlServer.getRows();
				etlServer_index = rows.length-1;  
				etlServer.beginEdit(rows.length-1);
		  }else{
			  $.messager.alert('系统提示','当前有正在编辑！','warning');
		 }
	}
	function clearFun() {
		$('#serverName').val('');
		$('#serverType')[0].selectedIndex = 0;
		
	}
	
		function searchFun(){
			var serverNamev=$("#serverName").val();
			var serverTypev=$("#serverType").combobox('getValue');
		   $('#etlServer').datagrid('load',{
			   serverName:serverNamev,
			   serverType:serverTypev
			});    
			
	}
		function getTemplate(){
			$('#formSearch').form('submit',{
				url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"Server"
				});
		}
	
		function getTaskByPage(){
			var pageNo = $('#deptGrid').datagrid('getPager');
			var pageSize = $(pager).pagination("options");
			window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"Server&pageSize="+pageSize+"&pageNo="+pageNo;
			return false;
		}
	
		function getTaskByData(){
			$('#formSearch').form('submit',{
				url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"Server"
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
				        	 url: "inputExcel_inputExcelServer.action?modelName="+"Server",
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
				                	 etlServer.reload();
				                  }
				            	                 
				             }
				         });
					 }else{
						 $.messager.alert('系统提示','请选择导入文件！！！','warning');
					}
		        
		}
		$(function(){
			var xxx=$(document).height()-$('#formSearch').height()-45;
			etlServer.resize({height:xxx});
			//$('.gridDiv').height($('.gridDiv').parent().parent().height() - 63);
		});
</script>
</html>

