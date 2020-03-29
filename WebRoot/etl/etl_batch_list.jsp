<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 
<title>批次管理</title> 
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
#addRowBatch1 .l-btn-left{
	padding-top: 3px;
}
#addRowProcessRelation1 .l-btn-left{
	padding-top: 3px;
}
 
.input_file{width:70px; margin-left:-70px;height:21px; filter:alpha(opacity=0); opacity:0;}
.top{
	position: relative;
	top:-21px;
}
</style>
<script type="text/javascript">
$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 80);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 80);
});

var relationSelectIndex;
var batchId;
function testOnSelect(){
	
	var batchIds=[];
	var selected = etlBatch.getAllSelected();
	if(selected.length>1){
		$.messager.alert('系统提示','只能选择一个批次','warning');
		return;
	}else if(selected.length== 0) {
		$.messager.alert('系统提示','请选择一个批次','warning');
		return;
	}else{
		batchId=selected[0].batchId;
		$("#taskManger").panel("setTitle","任务组关系配置    &nbsp;&nbsp;&nbsp;&nbsp;当前批次:&nbsp;"+selected[0].batchName);
		var opt=etlProcessRelation.getOptions();
		opt.url="processRelation_findAllProcessRelation.action";
		etlProcessRelation.load({batchId:batchId});
		}
}
function testOn(rowIndex,rowData){
	var selectedIndex=rowIndex;	
	var _uuid = rowData.uuid;
	if(typeof(_uuid)=='undefined' || _uuid==''){
		return;
	}
	batchId=rowData.batchId;
	$("#taskManger").panel("setTitle","任务组关系配置 ");
	$("#selectBatchId").val(rowData.batchName);
	var opt=etlProcessRelation.getOptions();
	opt.url="processRelation_findAllProcessRelation.action";
	etlProcessRelation.load({batchId:batchId});
}
function relationSelect(rowIndex,rowData){
	relationSelectIndex=rowIndex;
}

function save(){
	etlBatch.endEdit(etlBatch_index);
	var changes = etlBatch.getChanges('inserted'); 
	if(changes.length>1){
		$.messager.alert('系统提示','保存只能一个！','warning');
	}
	else{
		if(changes.length==0){
			changes = etlBatch.getChanges('updated');
		} 
		var uuid=changes[0].uuid;
		var batchId1=changes[0].batchId;
		var batchName=changes[0].batchName;
		var dataDate=changes[0].dataDate;
		var endDate=changes[0].endDate;
		var runFlag=changes[0].runFlag;
		var startTime=changes[0].startTime;
		var endTime=changes[0].endTime;
		if(batchId1!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,batchId:batchId1,batchName:batchName,dataDate:dataDate,endDate:endDate,runFlag:runFlag,startTime:startTime,endTime:endTime},
					url: "batch_save.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','保存成功','warning');	
							etlBatch.reload();	
							$('#editRowBatch').removeAttr("disabled");
							$('#addRowBatch').removeAttr("disabled");	
							 batchId=batchId1;
							//$.messager.prompt("设置作业","生成作业个数",makeJob);

												
						}
						if(result==2){
							$.messager.alert('系统提示','存在此数据','warning');
							etlBatch.deleteRow(etlBatch_index);
						}
						if(result==3){
							$.messager.alert('系统提示','修改成功','warning');
							etlBatch.reload();
							$('#editRowBatch').removeAttr("disabled");
							$('#addRowBatch').removeAttr("disabled");
						}
					}
				});
	
		}
		else
		{
					$.messager.alert('系统提示','行数据校验有问题，请检查输入项。','warning');	
		}
	}
}
function makeJob(value){
//	alert(value);
	var patrn=/^[0-9]{1,20}$/; 
	if (!patrn.exec(value)){
		$.messager.prompt("设置作业","生成作业个数(请输入数字)",makeJob);
	}else{
		
		$.ajax({
			cache:false,
			type: 'post',
			dataType : "Json",
			data:{count:value,batchId:batchId},
			url: "job_makeJobByBatchId.action",
			success:function(data){
				var result=eval("(" + data + ")");
				if(result==1){
					$.messager.alert('系统提示','作业生成成功','warning');	
				}else{
					$.messager.alert('系统提示','作业生成失败','warning');
				}
				
			}
		});	
	}
}
function relationSave(){
	etlProcessRelation.endEdit(etlProcessRelation_index);
	var changes = etlProcessRelation.getChanges('inserted'); 
	if(changes.length>1){
		$.messager.alert('系统提示','保存只能一个！','warning');
	}
	else{
		if(changes.length==0){
			changes = etlProcessRelation.getChanges('updated');
		} 
		var uuid=changes[0].uuid;
		var batchId=changes[0].batchId;
		var processId=changes[0].processId;
		var previousProcessId=changes[0].previousProcessId;
        var processName = changes[0].processName;
        var preprocessName = changes[0].preprocessName;
        
        var prs = etlProcessRelation.getRows();
        for(var i = 0;i<prs.length-1;i++){
        	 if(uuid!=''&& typeof uuid !== 'undefined'){
                 if(uuid== prs[i].uuid){
                     break;
                     }
              }
    		var tt = prs[i].processName;
    		var tp = prs[i].preprocessName;
			if(tt==''){
				break;
			}
    		if(tt == processName){
    			if(preprocessName==''&& typeof tp === 'undefined'){
    				$.messager.confirm('检查框','数据配置有误！配置的数据中有重复的数据.',null);
    				etlProcessRelation_index = null;
    				etlProcessRelation.rejectChanges();	
    				$('#editRowProcessRelation').removeAttr("disabled");
    				$('#addRowProcessRelation').removeAttr("disabled");
    				 return ;
    			}else if (preprocessName==tp){
    				$.messager.confirm('检查框','数据配置有误！配置的数据中有重复的数据.',null);
    				etlProcessRelation_index = null;
    				etlProcessRelation.rejectChanges();	
    				$('#editRowProcessRelation').removeAttr("disabled");
    				$('#addRowProcessRelation').removeAttr("disabled");
    				 return ;
    			}
    			 
    		}
    	}
		if(batchId!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,batchId:batchId,processId:processId,previousProcessId:previousProcessId,processName:processName,preprocessName:preprocessName},
					url: "processRelation_save.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','保存成功','warning');
							etlProcessRelation.reload();											
							$('#editRowProcessRelation').removeAttr("disabled");
							$('#addRowProcessRelation').removeAttr("disabled");
						}
						if(result==2){
							$.messager.alert('系统提示','存在此数据','warning');
							etlProcessRelation.reload();	
							$('#editRowProcessRelation').removeAttr("disabled");
							$('#addRowProcessRelation').removeAttr("disabled");
						}
					}
				});
	
		}
	}
}

function configRelation(){
	window.location.href = "${pageContext.request.contextPath}/process_toConfig.action?processId="+processId;
	return false;
}

function del(){
	etlBatch.endEdit(etlBatch_index);
	etlBatch_index = null;
	etlBatch.rejectChanges();
	$('#editRowBatch').removeAttr("disabled");
	$('#addRowBatch').removeAttr("disabled");
	var uuids = [];
	var selected = etlBatch.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    uuids.push(selected[i].uuid);
	}
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要删除的记录','warning');
		return;
	}else{
		$.messager.confirm('系统提示','确定要删除选中的纪录吗',function(btn){
			if(btn){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					url: "batch_remove.action?uuids="+uuids,
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','删除成功','warning');
							etlBatch.reload();
													
						}else{
							$.messager.alert('系统提示','删除失败','warning');																
						}
					}
				});
				}
			});
		
	}
}

function relationDel(){
	etlProcessRelation.endEdit(etlProcessRelation_index);
	etlProcessRelation_index= null;
	etlProcessRelation.rejectChanges();
	$('#editRowProcessRelation').removeAttr("disabled");
	$('#addRowProcessRelation').removeAttr("disabled");
	var uuids = [];
	var selected = etlProcessRelation.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    uuids.push(selected[i].uuid);
	}
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要删除的记录','warning');
		return;
	}else{
		$.messager.confirm('系统提示','确定要删除选中的纪录吗',function(btn){
			if(btn){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					url: "processRelation_remove.action?uuids="+uuids,
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','删除成功','warning');
							
							etlProcessRelation.reload();	
							etlProcessRelation.unselectAll();									
						}else{
							$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
						}
					}
				});
				}
			});
	}
}

function appendRow(){
	 var changes = etlBatch.getChanges();
	  if(!etlBatch_index&&!(changes &&changes.length > 0)){
			$('#editRowBatch').removeAttr("disabled");
			$('#addRowBatch').removeAttr("disabled");
			$('#editRowBatch').attr('disabled','false');
			$('#addRowBatch').attr('disabled','false');
			var newrow = {"batchId":"","batchName":"","dataDate":"","endDate":"","runFlag":"","startTime":"","endTime":""};
			var edit =  {
					field:"batchId", 
					editor:{
						type:'validatebox',
						options:{
							validType:"batchIdValid",
							required:"true",
							missingMessage:"不能为空"
						}
					}
			};
			etlBatch.appendRow(newrow,edit);
			var rows = etlBatch.getRows();
			etlBatch_index = rows.length-1;  
			etlBatch.beginEdit(rows.length-1);
			etlProcessRelation.load({batchId:"@"});
			$("#selectBatchId").val("");
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}

function relationAppendRow(){
	 var changes = etlProcessRelation.getChanges();
	  if(!etlProcessRelation_index&&!(changes &&changes.length > 0)){
			if(batchId!=null){
				$('#editRowProcessRelation').removeAttr("disabled");
				$('#addRowProcessRelation').removeAttr("disabled");
				$('#editRowProcessRelation').attr('disabled','false');
				$('#addRowProcessRelation').attr('disabled','false');
				var newrow = {"batchId":""+batchId+"","processName":"","preprocessName":"","processId":"","previousProcessId":""};
			 	 var edit =  {
									field:"processName", 
									editor:{
										type:'combobox',
										options:{
										url:"${pageContext.request.contextPath}/process_findProcessToList.action",
										valueField :"processId",
										textField :"processName",
										/*不可编辑*/
										editable:false
										}
									}
							};
				etlProcessRelation.appendRow(newrow,edit);
				var rows = etlProcessRelation.getRows();
				etlProcessRelation_index = rows.length-1;  
				etlProcessRelation.beginEdit(rows.length-1);
			}else{
				$.messager.alert('系统提示','请选择批次！','warning');	
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
	
}

function testInsertRow(){
	var rows = $('#userGrid').datagrid('getRows');
	var row = rows[1];
	row.realName = "在index为1处，插入一行";
	var param = {
			index:1,
			row:row
		};
	etlProcess.insertRow(param);
}
function testUpdateRow(){
	var rows = $('#userGrid').datagrid('getRows');
	var row = rows[1];
	row.realName = "更新首行数据";
	var param = {
			index:0,
			row:row
		};
	userGrid.updateRow(param);
}
function testGetChanges(){
	var changes = userGrid.getChanges();      
	var insertedchanges = userGrid.getChanges('inserted');      
	var deletedchanges = userGrid.getChanges('deleted');
	var updatedchanges = userGrid.getChanges('updated');
	alert('改变的数据有'+changes.length+'行，其中插入'+insertedchanges.length+'行，更新'+updatedchanges.length+'行，删除'+deletedchanges.length+'行');
}

function getTaskByPage(){
	var pageNo = $('#deptGrid').datagrid('getPager');
	var pageSize = $(pager).pagination("options");
	window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"Batch&pageSize="+pageSize+"&pageNo="+pageNo;
	return false;
}
function getBatchByData(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"Batch"
	});
}

function getProlationByData(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"ProcessRelation"
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
		        	 url: "inputExcel_inputExcelBatch.action?modelName="+"Batch",
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
		                	 etlBatch.reload();
		                  }
		            	       
		             }
		         });
			 }else{
				 $.messager.alert('系统提示','请选择导入文件！！！','warning');
			}
}

function inprExcel(){
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在导入请稍后";
	obj.text;
	obj.interval = 400; 
	
	 var updateUpdata = $('#upload1').val();
	// alert(updateUpdata);
	 if(updateUpdata!=null&&updateUpdata!=""){
		 messager.progress(obj);
		   $.ajaxFileUpload({  
	        	 url: "inputExcel_inputExcelProcessRelation.action?modelName="+"ProcessRelation",
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
	                	}  else{
	                		 messager.close();  
	                	 $.messager.alert('系统提示','导入成功！','warning');
	                  }
	            	       
	             }
	         });
		 }else{
			 $.messager.alert('系统提示','请选择导入文件！！！','warning');
		}
    
}

function editProcessRelation(){
	 var changes = etlProcessRelation.getChanges();
	  if(!etlProcessRelation_index&&!(changes &&changes.length > 0)){
			var selected = etlProcessRelation.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlProcessRelation.getRowIndex(selected[0]);
				etlProcessRelation_index = rownum;
				etlProcessRelation.removeEditor(['processName']);
				etlProcessRelation.beginEdit(rownum);
			$('#editRowProcessRelation').removeAttr("disabled");
			$('#addRowProcessRelation').removeAttr("disabled");
			$('#editRowProcessRelation').attr('disabled','false');
			$('#addRowProcessRelation').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');

		  }
}

function cancelBatch(){
	etlBatch.endEdit(etlBatch_index);
	etlBatch_index = null;
	etlBatch.rejectChanges();
	$('#editRowBatch').removeAttr("disabled");
	$('#addRowBatch').removeAttr("disabled");
}

function editBatch(){
	 var changes = etlBatch.getChanges();
	  if(!etlBatch_index&&!(changes &&changes.length > 0)){
			var selected = etlBatch.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = etlBatch.getRowIndex(selected[0]);
				etlBatch_index = rownum;
				etlBatch.removeEditor(['batchId']);
				etlBatch.beginEdit(rownum);
			$('#editRowBatch').removeAttr("disabled");
			$('#addRowBatch').removeAttr("disabled");
			$('#editRowBatch').attr('disabled','false');
			$('#addRowBatch').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}


function getTemplate(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"Batch"
	});
}

function getPrelationTemplate(){
	$('#formSearch').form('submit',{
		url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"ProcessRelation"
	});
}

function rese(){
	$('#batchId').val('');
	$('#batchName').val('');
}

function submi(){
	var jsonData = {
			batchId:$('#batchId').val(),
			batchName:$('#batchName').val(),
			newpage:1,page:1
			};
	etlBatch.load(jsonData);
	
}

function cancelProcessRelation(){
	etlProcessRelation.endEdit(etlProcessRelation_index);
	etlProcessRelation_index = null;
	etlProcessRelation.rejectChanges();	
	$('#editRowProcessRelation').removeAttr("disabled");
	$('#addRowProcessRelation').removeAttr("disabled");
}
$.extend($.fn.validatebox.defaults.rules, {
    batchIdValid: {
		validator: function (value) {   
        	if(/^(\w){3,16}$/.test(value)){
        		  if(value){
				        var exist=$.ajax({
				                url:"batch_checkunique.action?batchId="+value,
				                data:{},
				                async:false
				            }).responseText;
				        if(exist=="0"){
							 $.fn.validatebox.defaults.rules.batchIdValid.message ="";
				            return true;
				        }else{
				        	$.fn.validatebox.defaults.rules.batchIdValid.message ="参数ID重复，无法使用！";
				            return false;
					    }
					  
		        }else{
		        	$.fn.validatebox.defaults.rules.batchIdValid.message ="";
		            return true;
			    }

			}else{
				 $.fn.validatebox.defaults.rules.batchIdValid.message ="只可输入3-16位开头英文数字和_";
				return false;
			}
	      
    	},
   		 message: ''
 	}
	
});	
</script>
</head>
<body class="easyui-layout" border="false" onload="page_top()">

<div id="mm" style="width:200px;display:none;">
       <div iconCls="icon-export"  onClick="getBatchByData();">数据导出</div> 
    <div iconCls="icon-import" onClick="inExcel();">导入</div>
	<div iconCls="icon-exportTemplate" onClick="getTemplate();">模版导出</div>  
	<%-- 
	<div iconCls="icon-save" onClick="save();">保存</div>  
	<div iconCls="icon-redo" onClick="cancelBatch();">取消</div> 
	<div iconCls="icon-search" onClick="checkPocessRelation();">关系校验</div> 
	--%>  
</div> 
	
<div id="mm1" style="width:200px;display:none;">
    <div iconCls="icon-exportTemplate"  onClick="getPrelationTemplate();">导出模版</div> 
    <div iconCls="icon-export" onClick="getProlationByData();">导出数据</div>
	<div iconCls="icon-import" onClick="inExcel();">导入</div> 
	<%--  
	<div iconCls="icon-save" onClick="relationSave();">保存</div>  
	<div iconCls="icon-redo" onClick="cancelProcessRelation();">取消</div>
	--%> 
</div> 

	<div region="west"  style="width:500px;border-left: none;" border="true" title="批次管理">
	<form name="formSearch" id="formSearch" method="post" style="padding: 9px 0 10px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">批次编号：</td>
				<td height="40px">
					<input type="text" name="batchId" id="batchId" class="input_eq" style="width:90px"/>
				</td>
				<td height="40px">批次名称：</td>
				<td height="40px">
					<input type="text" name="batchName" id="batchName" class="input_eq" style="width:90px"/>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" onclick="submi()" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	<div class="gridDiv0" id="gridDiv0">
	<%--<r:toolbar id="addRowBatch" text="操作"></r:toolbar> 
	<r:toolbar text="模板" iconCls="icon-exportTemplate" onClick="getTemplate();"></r:toolbar>		
	<r:toolbar text="导入" iconCls="icon-import" onClick="inExcel();"></r:toolbar>
						<r:toolbar text="导出" iconCls="icon-export" onClick="getBatchByData();"></r:toolbar>
	 --%>
					<r:grid sortable="true" remoteSort="true"  pagination="true" idField="uuid" editable="true" singleEdit="true" rownumbers="false" singleSelect="true" url="batch_findAllBatchs.action" fit="true" onSelect="testOn(a,b);" striped="true" height="100%" id="etlBatch">
						  <r:toolbar id="addRowBatch1" text="操作"></r:toolbar>
						<r:toolbar text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>
						<r:toolbar text="编辑" iconCls="icon-edit" onClick="editBatch();"></r:toolbar>
						<r:toolbar text="删除" iconCls="icon-remove" onClick="del();"></r:toolbar>
						<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelBatch();"></r:toolbar>
						<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
						<r:toolbar text="关系校验" iconCls="icon-search" onClick="checkPocessRelation();"></r:toolbar>					
						<r:toolbar text="<input style='border: 1px #c0c0c0 solid; height: 18px; width:240px;' type='text' id='txt' name='txt' /><input type='button' style='height: 19px;border: 0.5px #c0c0c0 solid' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload' name='upload' onchange='txt.value=this.value'/>"></r:toolbar>
						           
						<r:col field="uuid" checkbox="true" editable="false"   rowspan="2"></r:col>						  
						<r:col field="batchId" editable="false" title="批次编号" width="170" rowspan="2" sortable="true" >
							<r:editorText validType="batchIdValid" required="true" missingMessage="不能为空" ></r:editorText>
						</r:col>
						<r:col field="batchName" title="批次名称"   width="170" rowspan="2" sortable="true">
							<r:editorText  required="true" missingMessage="不能为空" ></r:editorText>
						</r:col>   
						<r:col  field="dataDate" title="数据日期"   width="150" rowspan="2" sortable="true">   
							<r:editorDate required="true" editable="false" missingMessage="不能为空" format="yyyy-MM-dd"/>
						</r:col>  
						<r:col  field="endDate" title="结束日期"   width="150" rowspan="2"  sortable="true" >   
							<r:editorDate required="false" editable="false"   format="yyyy-MM-dd" />						
						</r:col>     
						<r:col field="useText"  title="描述" sortable="true" width="200"></r:col>
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"  displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
					</div>
			</div>
			<div region="center" style="width:220px;background-color:#E7F1FD;" border="true" id="taskManger" title="任务组关系管理" >
			<form name="formreSearch" id="formreSearch" method="post" style="padding-left: 20px;">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td height="40px">选中批次：</td>
						<td height="40px">
							<input type="text" name="batchId" id="selectBatchId" disabled="disabled" class="input_eq" style="width:150px"/>
						</td>
					</tr>
				</table>
			</form>
			<%--
			<r:toolbar text="模板" iconCls="icon-exportTemplate" onClick="getPrelationTemplate();"></r:toolbar>
			 <r:toolbar text="导入" iconCls="icon-import" onClick="inprExcel();"></r:toolbar>
						<r:toolbar text="导出" iconCls="icon-export" onClick="getProlationByData();"></r:toolbar>
			 --%>
			<div class="gridDiv1" id="gridDiv1">
					<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" singleEdit="true" editable="true" url="" striped="true" fit="true" height="100%" rownumbers="false" id="etlProcessRelation"  onSelect="relationSelect(a,b);">
						<r:toolbar id="addRowProcessRelation1" text="操作"   ></r:toolbar>    
					    <r:toolbar text="增加" iconCls="icon-add" onClick="relationAppendRow();"></r:toolbar>
					    <r:toolbar text="保存" iconCls="icon-save" onClick="relationSave();"></r:toolbar>
					    <r:toolbar text="取消" iconCls="icon-redo" onClick="cancelProcessRelation();"></r:toolbar>
					    <r:toolbar text="删除" iconCls="icon-remove" onClick="relationDel();"></r:toolbar>
					    <r:toolbar text="编辑" iconCls="icon-edit" onClick="editProcessRelation();"></r:toolbar>  
						<r:toolbar text="<input style='border: 1px #c0c0c0 solid; height: 18px; width:240px; margin-top:-15px' type='text' id='txt1' name='txt1' /><input type='button' style='height: 19px;border: 0.5px #c0c0c0 solid ' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/>"></r:toolbar>
						<r:col field="uuid" checkbox="true" editable="false"   width="100" rowspan="2"></r:col>
						<r:col field="processId"  hidden="true" editable="false"  width="180" rowspan="2"></r:col>
						<r:col field="previousProcessId"  hidden="true" editable="false" width="180" rowspan="2"></r:col>	
						<r:col field="processName" title="任务组名称" sortable="true"  width="180" rowspan="2">
						  <r:editorCombobox editable="false" url="${pageContext.request.contextPath}/process_findProcessToList.action" valueField="processId" textField="processName"></r:editorCombobox>
						</r:col>
						<r:col field="preprocessName" title="前置任务组名称" sortable="true"   width="200" rowspan="2" >
							<r:editorCombobox editable="false" url="${pageContext.request.contextPath}/process_findProcessToList.action" valueField="processId" textField="processName"></r:editorCombobox>
						</r:col>   			
					
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"  displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
			</div>
			</div>
		<br>
		
	<div id="win" iconCls="icon-save" title="My Window">  
		   Window Content   
  	</div>


</body>

<script type="text/javascript">
function pocessRunStatus(){
	var selected = etlBatch.getAllSelected();
	if(selected.length==0){
		$.messager.alert('系统提示','请选择要配置的批次！','warning');
	}else if(selected.length>1){
		$.messager.alert('系统提示','同时只能配置一个批次下的任务组状态！','warning');
	}else{
		window.location.href="${pageContext.request.contextPath}/batch_toStatusConfig.action?batchId="+selected[0].batchId;
	}
}
function checkPocessRelation(){
	
	var selected = etlBatch.getAllSelected();
	if(selected.length==0){
		$.messager.alert('系统提示','请选择要检测的批次！','warning');
	}else if(selected.length>1){
		$.messager.alert('系统提示','同时只能检测一个批次！','warning');
	}else{
		$.post( 
				"${pageContext.request.contextPath}/relationcheck_ProcessCheck.action",
			     {
				 	batchId:selected[0].batchId
				 },function (data){
					 var result=eval("(" + data + ")");
	                  $.messager.alert('系统提示',result.message,'warning');
		});
	}
}

function formatterBatchRunFlag(value){
	if(value == '-1') {
		return "出错";
	} else if(value == '0') {
		return "未运行";
	}else if(value == '1') {
		return "正在运行";
	}else if(value == '2') {
		return "已完成";
	}
}
</script>

<script type="text/javascript">
function page_top(){
	//$("#gridDiv1 .pagination").addClass("top");
	var s =window.screen.width;
   $("#gridDiv0 .datagrid-toolbar").css("height","55px");
   if(s<=1270)
   {
   $("#gridDiv1 .datagrid-toolbar").css("height","57px");
   }
	$(function(){
		$("#addRowBatch1").splitbutton({
			menu:'#mm'
		});
	});
	$(function(){
		$("#addRowProcessRelation1").splitbutton({
			menu:'#mm1'
		});
	});
	
}
</script>
</html>

