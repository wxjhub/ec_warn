<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 
<title>作业管理</title> 
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
.input_file{width:130px; margin-left:-130px;height:21px; filter:alpha(opacity=0); opacity:0;}
.top{
	position: relative;
	top:-21px;
}
</style>
<script type="text/javascript">
var flag="${param.jobId}";
$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 80);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 80);
});

var relationSelectIndex;
var batchId;
var jobId;
function testOnSelect(){
	
	var batchIds=[];
	var selected = etlBatch.getAllSelected();
	if(selected.length>1){
		$.messager.alert('系统提示','只能选择一个作业','warning');
		return;
	}else if(selected.length== 0) {
		$.messager.alert('系统提示','请选择一个作业','warning');
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
	batchId=rowData.batchId;
	jobId= rowData.jobId;
	$("#taskManger").panel("setTitle","作业参数配置 ");
	$("#selectJobId").val(rowData.jobId);
	var opt=etlProcessRelation.getOptions();
	opt.url="schedulerParam_list.action";
	etlProcessRelation.load({jobId:jobId});
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
		var jobId = changes[0].jobId;
		var batchId=changes[0].batchId;
		var dataDate=changes[0].dataDate;
		var endDate=changes[0].endDate;
		var runFlag=changes[0].runFlag;
		if(batchId!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,batchId:batchId,jobId:jobId,dataDate:dataDate,runFlag:runFlag,endDate:endDate},
					url: "job_save.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','保存成功','warning');	
							etlBatch.reload();	
							$('#editRowBatch').removeAttr("disabled");
							$('#addRowBatch').removeAttr("disabled");								
						}
						if(result==2){
							$.messager.alert('系统提示','存在此数据','warning');
							etlBatch.deleteRow(etlBatch_index);
						}
						if(result==3){
							$.messager.alert('系统提示','修改成功','warning');
							etlBatch.reload();
						}
					}
				});
	
		}
		else
		{
					$.messager.alert('系统提示','保存项有空值！','warning');	
		}
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
		var uuid = changes[0].uuid;
		var paramId=changes[0].paramId;
		var paramName=changes[0].paramName;
		var paramValue=changes[0].paramValue;
		var paramType=changes[0].paramType;
		var serverId =changes[0].serverId;
		var forecastType=changes[0].forecastType;
		var remark=changes[0].remark;
		if(batchId!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,jobId:jobId,batchId:batchId,serverId:serverId,paramId:paramId,paramName:paramName,paramValue:paramValue,paramType:paramType,forecastType:forecastType,remark:remark},
					url: "schedulerParam_save.action",
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
	//etlBatch.endEdit(etlBatch_index);
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
					url: "job_remove.action?uuids="+uuids,
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
					url: "schedulerParam_remove.action?uuids="+uuids,
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
			var newrow = {"jobId":"","batchId":"","dataDate":"","runFlag":""};
			var edit =  {
					field:"jobId", 
					editor:{
						type:'validatebox',
						options:{
							validType:"jobIdValid"
						}
					}
			};
			etlBatch.appendRow(newrow,edit);
			var rows = etlBatch.getRows();
			etlBatch_index = rows.length-1;  
			etlBatch.beginEdit(rows.length-1);
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
				var newrow = {paramId:"",paramName:"",paramValue:"",paramType:"",forecastType:"",serverId:"",remark:""};
				var edit =  {
						field:"paramId", 
						editor:{
							type:'validatebox',
							options:{
								validType:"paramIdValid"
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
				etlProcessRelation.removeEditor(['paramId']);
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
	 //var changes = etlBatch.getChanges();
	  if(true){
			var selected = etlBatch.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				//var rownum1 = etlBatch.getRowIndex(selected[0]);
				var rownum=selected[0];
				//etlBatch_index = rownum1;
				//etlBatch.removeEditor(['batchId']);
				//etlBatch.beginEdit(rownum);
				//console.info(rownum.startTime);
				if(rownum.startTime){
					var a=rownum.startTime;
					
					var b=a.hours+"";
					var c=a.minutes+"";
					if(b.length==1) b="0"+b;
					if(c.length==1) c="0"+c;
					var d=a.year+1900;
					var e=a.month+1;
					var f=a.date;
					rownum.startTime=d+"-"+(e<10?'0'+e:e)+"-"+(f<10?'0'+f:f)+" "+b+":"+c;
				}
				if(rownum.endTime){
					var a=rownum.endTime;
					var b=a.hours+"";
					var c=a.minutes+"";
					if(b.length==1) b="0"+b;
					if(c.length==1) c="0"+c;
					var d=a.year+1900;
					var e=a.month+1;
					var f=a.date;
					rownum.endTime=d+"-"+(e<10?'0'+e:e)+"-"+(f<10?'0'+f:f)+" "+b+":"+c;
				}
				//编辑之前首先检查任务的运行状态。如果是正在运行的状态。则给出提示，不允许编辑
				var jobJsonText=$.ajax({
				                url:"job_findJobByJobId.action?jobId="+rownum.jobId,
				                data:{},
				                async:false
				            }).responseText;
				var jobJsob = eval(jobJsonText);
				if(jobJsob[0].runFlag=="1"){
					$.messager.alert('系统提示','该任务正在运行，不能修改！','warning');
					return;
				}
				location.href='${pageContext.request.contextPath}/etl/etl_job_change.jsp?'+'jobId='+rownum.jobId+'&uuid='+rownum.uuid+'&batchId='+rownum.batchId+
				'&dataDate='+rownum.dataDate+'&endDate='+rownum.endDate+'&startTime='+rownum.startTime+'&endTime='+rownum.endTime+'&runFlag='+rownum.runFlag+'&jobName='+encodeURI(encodeURI(rownum.jobName));
			//$('#editRowBatch').removeAttr("disabled");
			//$('#addRowBatch').removeAttr("disabled");
			//$('#editRowBatch').attr('disabled','false');
			//$('#addRowBatch').attr('disabled','false');
			}
	  }else{
		 $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}
function rese(){
	$('#batchId').val('');
	$('#jobId').val('');
}

function submi(){
	var jsonData = {
			batchId:$('#batchId').val(),
			jobName:$('#jobId').val(),
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
	jobIdValid: {
		validator: function (value) {   
        	if(/^(\w){3,16}$/.test(value)){
        		  if(value){
				        var exist=$.ajax({
				                url:"job_checkunique.action?jobId="+value,
				                data:{},
				                async:false
				            }).responseText;
				        if(exist=="0"){
							 $.fn.validatebox.defaults.rules.jobIdValid.message ="";
				            return true;
				        }else{
				        	$.fn.validatebox.defaults.rules.jobIdValid.message ="参数ID重复，无法使用！";
				            return false;
					    }
					  
		        }else{
		        	$.fn.validatebox.defaults.rules.jobIdValid.message ="";
		            return true;
			    }

			}else{
				 $.fn.validatebox.defaults.rules.jobIdValid.message ="只可输入3-16位开头英文数字和_";
				return false;
			}
	      
    	},
   		 message: ''
 	},
    paramIdValid: {
        validator: function (value) {
        	if(/^@(\w){3,16}$/.test(value)){
				  if(value){
				        var exist=$.ajax({
				                url:"schedulerParam_checkunique.action?paramId="+value+"&jobId="+jobId,
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

$(function(){
	if(flag){
		var sels=document.getElementById("batchId").options;
	  	sels[0]=new Option("${param.batchId}","${param.batchId}");
	}else{
		$.ajax({
			  url: "batch_findBatchList.action",
			  success: function(data){
			  	var sels=document.getElementById("batchId").options;
			  	sels[0]=new Option("---请选择---    ","");
				for(var i=0;i<data.length;i++){
					var d=data[i];
					
					sels[i+1]=new Option(d.batchName,d.batchId);
				}
			  },
			  dataType: "json"
			});
	}
});

</script>
</head>
<body class="easyui-layout" border="false">
	<div region="west" style="width:590px;border-left: none;" border="true" title="作业管理">
	<form name="formSearch" id="formSearch" method="post" style="padding: 9px 0 10px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="30px">批次名称：</td>
				<td height="30px">
					<select  name="batchId" id="batchId" class="input_eq" style="width:150px;">
					
					</select>
				</td>
				<td height="30px">作业名称：</td>
				<td height="30px">
					<input type="text" name="jobId" id="jobId" class="input_eq" style="width:100px"/>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" onclick="submi()" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	<div class="gridDiv0" id="gridDiv0">
					<r:grid sortable="true" remoteSort="true"  pagination="true" idField="uuid" editable="false" singleEdit="true" rownumbers="false" singleSelect="true" url="job_findAllBatchStatus.action" fit="true" onSelect="testOn(a,b);" striped="true" height="100%" id="etlBatch">
						<r:toolbar id="addRowBatch" text="增加" iconCls="icon-add" onClick="location.href='${pageContext.request.contextPath}/etl/etl_job_change.jsp'"  ></r:toolbar>    
						<r:toolbar id="editRowBatch" text="修改" iconCls="icon-edit" onClick="editBatch();"></r:toolbar>
						<r:toolbar text="删除" iconCls="icon-remove" onClick="del();"  ></r:toolbar> 
						<r:toolbar text="任务组运行状态" iconCls="icon-sysmrg" onClick="pocessRunStatus();return false;"></r:toolbar>    			
						<r:col field="uuid" checkbox="true" editable="false"   width="100" rowspan="2"></r:col>		
						<r:col field="batchId" title="批次编号" width="100" rowspan="2" sortable="true" >
							<r:editorCombobox editable="false" url="${pageContext.request.contextPath}/batch_list.action" missingMessage="不能为空" valueField="batchId" textField="batchId"></r:editorCombobox>
						</r:col>
						<r:col field="jobId" editable="false" title="作业编号" width="100" rowspan="2" sortable="true" >
						</r:col>
						<r:col field="jobName" title="作业名称"  width="100" rowspan="2"  sortable="true">                      
						</r:col>				  
			
						<r:col field="runFlag" title="运行状态" dictId="etl.batch.runflag"  width="100" rowspan="2"  sortable="true">                      
						</r:col>
						<r:col  field="dataDate" title="数据日期"   width="150" rowspan="2" sortable="true" >  
						<r:editorDate required="true" editable="false" missingMessage="不能为空" format="yyyy-MM-dd"/> 
						</r:col>  
						 <r:col  field="endDate" title="结束日期"   width="150" rowspan="2" sortable="true" >   
						 <r:editorDate required="true" editable="false" missingMessage="不能为空" format="yyyy-MM-dd"/> 
						</r:col>    
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
					</div>
			</div>
			<div region="center" style="width:400px;background-color:#E7F1FD;" border="true" id="taskManger" title="作业参数管理" >
			<form name="formreSearch" id="formreSearch" method="post" style="padding-left: 20px;">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td height="40px">选中作业：</td>
						<td height="40px">
							<input type="text" name="batchId" id="selectJobId" disabled="disabled" class="input_eq" style="width:150px"/>
						</td>
					</tr>
				</table>
			</form>
			<div class="gridDiv1" id="gridDiv1">
					<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" singleEdit="true" editable="false" url="" striped="true" fit="true" height="100%" rownumbers="false" id="etlProcessRelation"  onSelect="relationSelect(a,b);">
						<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
						
						<r:col field="paramId" editable="false" sortable="true" title="参数ID" width="80">
							<r:editorText validType="paramIdValid"></r:editorText>
						</r:col>
						<r:col field="paramName" title="参数名称" sortable="true" width="80"></r:col>   
						<r:col field="paramType" title="参数类型" sortable="true" dictId="etl.paramType" width="100">
							<r:editorDictSelect required="true" missingMessage="不能为空" onSelect="vvv(record);"></r:editorDictSelect>
						</r:col>  
						<r:col field="paramValue" title="参数值" sortable="true" width="80" >
						
							<r:editorText required="true" missingMessage="不能为空"></r:editorText>
						</r:col>    
						
						<r:col  field="serverId" title="服务器ID" sortable="true" width="100">
							<r:editorCombobox  editable="false" url="${pageContext.request.contextPath}/server_findAllServersByCombobox.action" required="true" missingMessage="不能为空" valueField="serverId" textField="serverId"></r:editorCombobox>
						</r:col> 
						<r:col field="remark"  title="备注" sortable="true" width="100"></r:col>
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"  displayMsg=" {from}-{to}条 共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
			</div>
			</div>
		<br>
</body>

<script type="text/javascript">
function pocessRunStatus(){
	var selected = etlBatch.getAllSelected();
	if(selected.length==0){
		$.messager.alert('系统提示','请选择要配置的批次！','warning');
	}else if(selected.length>1){
		$.messager.alert('系统提示','同时只能配置一个批次下的任务组状态！','warning');
	}else{
		window.location.href="${pageContext.request.contextPath}/job_toStatusConfig.action?jobId="+selected[0].jobId;
		return false;
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


function vvv(record){
	if (record.id=="1") {
		var e = etlProcessRelation.getEditor(
				{
					'index' : etlProcessRelation_index,
					'field' : 'serverId'
				}).target;
				e.combobox( {required : true,width:100});
		var editor = etlProcessRelation.getEditor(
						{
							'index' : etlProcessRelation_index,
							'field' : 'forecastType'
						});
		editor.target.combobox( {
					required : true,
					width:100
				});
	} else {
		var target = etlProcessRelation.getEditor(
				{
					'index' : etlProcessRelation_index,
					'field' : 'forecastType'
				}).target;
		target.combobox( {
					required : false,
					width:100
				});
		var editor = etlProcessRelation.getEditor(
				{
					'index' : etlProcessRelation_index,
					'field' : 'serverId'
				}).target;;
				editor.combobox( {required : false,width:100});
				//editor.target.validateBox('destroy');
			}
	}
</script>
<script type="text/javascript">

</script>
</html>

