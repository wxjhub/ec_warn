<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 
<title>作业管理</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<h:js src="jquery-1.7.2.min.js"></h:js>
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
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
.input_file{width:130px; margin-left:-130px;height:21px; filter:alpha(opacity=0); opacity:0;}
.top{
	position: relative;
	top:-21px;
}

</style>
<script type="text/javascript">
//修改和新增的标志位
var flag="${param.jobId}";
$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 80);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 80);
	
});

var relationSelectIndex;
var batchId;
var jobId;












//--------------------------------------------------------------------------------
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
					
					sels[i+1]=new Option(d.batchId,d.batchId);
				}
			  },
			  dataType: "json"
			});
	}
});
function loadJob(value){//新增作业               选中 批次时获取批次参数
	//$.ajax({
	//	url: "job_findMaxJobIdByBatch.action?batchId="+value,
		//  success: function(data){
		//  	console.info(data);
		//  },
		//  dataType: "json"
	//});
	var opt=etlProcessRelation.getOptions();
	opt.url="batchParam_list.action";
	etlProcessRelation.load({batchId:value});
}

function formatD(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	return y+"-"+m+"-"+d;
}
$(function(){
	$('#dataDate').datebox({   
		
		formatter:formatD
	 });  
	$('#endDate').datebox({   
		formatter:formatD
	});
});






//保存时执行动作
function save_job_param(){
	etlProcessRelation.endEdit(etlProcessRelation_index);
	var checkValue=$("#batchId").val();
	if(checkValue==''){
		$.messager.alert('系统提示','请选择一个批次！','warning');
		return;
	}
	
	var flag = true;
	var dataDate=$("#dataDate").datebox("getValue");
	var endDate=$("#endDate").datebox("getValue");
	var jobUUID=$("#jobUUID").val();
	var jobName=$("#jobName").val();
	if(jobUUID==""){
		flag = false;
	}
	if (dataDate!="" && endDate!="" && jobName!=""){
		var uuid="${param.uuid}";//
		if(!uuid) uuid=undefined;//undefined 保证不像后台传送数据
		var jobId = $("#jobId").val();
		var batchId=$("#batchId").val();
		var runFlag=$("#runFlag").val();
		$.ajax({
			cache:false,
			type: 'post',
			//dataType : "Json",
			data:{uuid:uuid,batchId:batchId,jobId:jobId,dataDate:dataDate,runFlag:runFlag,endDate:endDate,jobName:jobName},
			url: "job_save.action",
			success:function(data){
				//console.info(data);
				var result=data;
				
				if(result!=2&&result!=3){//新增作业成功
					//保存作业后回显作业id
					$("#jobId").val(result);
				}

				//拿到改变的作业参数---针对修改而言
				var changes = etlProcessRelation.getChanges('updated');
				if(!flag) changes=etlProcessRelation.getRows();//如果是新增 则拿到所有批次参数
				//console.info(changes);
				if(changes.length==0) {
					$.messager.alert('系统提示','保存成功','warning');
					location.href='etl_job_list.jsp';return;
					
				}
				var uuid='';var jobId='';var batchId='';var serverId='';var paramId='';var paramName='';var paramValue='';var paramType='';var forecastType='';var remark='';
				var json='[';
				 for(var i=0;i<changes.length;i++){
					// uuid+=changes[i].uuid+',';
					// jobId+=changes[i].jobId+',';
					// batchId+=changes[i].batchId+',';
					// serverId+=changes[i].serverId+',';
					// paramId+=changes[i].paramId+',';
					// paramName+=changes[i].paramName+',';
					if(!changes[i].jobId) changes[i].jobId=$("#jobId").val();
					if(!flag) 
						json+='{"jobId":"'+changes[i].jobId+'","batchId":"'+changes[i].batchId+'","serverId":"'+changes[i].serverId+'","paramId":"'+changes[i].paramId+'","paramName":"'+changes[i].paramName+'","paramValue":"'+changes[i].paramValue+'","paramType":"'+changes[i].paramType+'","forecastType":"'+changes[i].forecastType+'","remark":"'+changes[i].remark+'"}';
						else json+='{"uuid":"'+changes[i].uuid+'","jobId":"'+changes[i].jobId+'","batchId":"'+changes[i].batchId+'","serverId":"'+changes[i].serverId+'","paramId":"'+changes[i].paramId+'","paramName":"'+changes[i].paramName+'","paramValue":"'+changes[i].paramValue+'","paramType":"'+changes[i].paramType+'","forecastType":"'+changes[i].forecastType+'","remark":"'+changes[i].remark+'"}';
						if(i<changes.length-1){
							json+=',';
						}
					}
				 json+=']';
				// console.info(json);
				$.ajax({// 作业参数的保存
					cache:false,
					type: 'post',
					//dataType : "Json",
					data:{params:json},
					url: "schedulerParam_saveParamItems.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','保存成功','warning');
							location.href='etl_job_list.jsp';
						}
						
					}
				});
			}
		});
	}else{
	    $.messager.alert('系统提示','表单填写有误！','warning');
	}
	


	
	
}
</script>
</head>

<body class="easyui-layout" border="false">
	<div region="north" style="height:140px;border-left: none;" border="true" title="作业信息管理">
	<form name="formSearch" id="formSearch" method="post" style="padding: 9px 0 10px 30px;">
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<INPUT name="uuid" id="jobUUID"type="hidden" value="${param.uuid}"> 
		<table cellSpacing="12.5px" cellpadding="0" width="100%">
			<tr>
				<td height="30px">批次编号：</td>
				<td height="30px">
				
				<select  name="batchId" id="batchId" class="input_eq" style="width:100px" onchange="loadJob(this.value);">
					
					</select>
				</td>
					<td height="30px">作业名称：</td>
				<td height="30px">
					<input type="text" name="jobName" id="jobName" class="input_eq easyui-validatebox" style="width:100px" missingMessage="请输入作业名称" required="true"/>
				</td>
				
				<td height="30px">运行状态：</td>
				<td height="30px">
					<select  name="runFlag" id="runFlag" class="input_eq" style="width:100px" >
					<rmp:option dictId="etl.batch.runflag"></rmp:option>
					<!--  	<option value="0"> 未运行</option>
						<option value="1"> 正在运行</option>
						<option value="2"> 已完成</option>
						<option value="-1">出错</option>-->
					</select> 
				</td>
				<td height="30px" id="jobIdName">作业编号：</td>
				<td height="30px">
					<input type="text" name="jobId" id="jobId" class="input_eq" style="width:100px"  onmousemove="tipShow()" onmouseout="tipHidden()" readonly="readonly" /><span style="color:red" id="tip"></span>
				</td>
			</tr>
			<tr>
			
				
				<td height="30px">数据日期：</td>
				<td height="30px">
					<input type="text" name="dataDate" id="dataDate" class="easyui-validatebox input_eq" style="width:100px" required="true" missingMessage="请输入数据日期"/>
				</td>
				<td height="30px">结束日期：</td>
				<td height="30px">
					<input type="text" name="endDate" id="endDate" class="easyui-validatebox input_eq" style="width:100px" required="true"  missingMessage="请输入结束日期"  />&nbsp;&nbsp;&nbsp;
				</td>
				<td height="30px">开始时间：</td>
				<td height="30px">
					<input type="text" name="dataDate" id="startTime" class="input_eq" style="width:100px" readonly="readonly" disabled="disabled" />
				</td>
				<td height="30px">结束时间：</td>
				<td height="30px">
					<input type="text" name="dataDate" id="endTime" class="input_eq" style="width:100px" readonly="readonly" disabled="disabled"/>
					<!-- <input type="button" onclick="test()"> -->
				</td>
				<!-- <td>
					<input id="filter_submit" class="inputd" type="button" onclick="submi()" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td> -->
			</tr>
		</table>
	</form>
	</div>
	<div region="center" style="height:400px;background-color:#E7F1FD;" border="true" id="taskManger" title="作业参数信息管理" >
	<div class="gridDiv0" id="gridDiv0">
					<r:grid sortable="true" width="300px" remoteSort="true" pagination="true" idField="uuid" singleEdit="false" editable="true" url="" striped="true" fit="true" height="100%" rownumbers="false" id="etlProcessRelation"  >
						
						<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
						
						<r:col field="paramId" editable="false" sortable="true" title="参数ID" width="80">
							<r:editorText validType="paramIdValid"></r:editorText>
						</r:col>
						<r:col field="paramName" title="参数名称" sortable="true" width="80"></r:col> 
						<r:col field="paramType" title="参数类型" sortable="true" dictId="etl.paramType" width="100" editable="false">
							<r:editorDictSelect required="true" missingMessage="不能为空" onSelect="vvv(record);"></r:editorDictSelect>
						</r:col>    
						<r:col field="paramValue" title="参数值" sortable="true" width="80" >
							<r:editorText required="true" missingMessage="不能为空"></r:editorText>
						</r:col>    
						
						<r:col field="forecastType" title="预处理类型" sortable="true" dictId="etl.forecastType" width="100" editable="false">
							<r:editorDictSelect  missingMessage="不能为空"></r:editorDictSelect>
						</r:col> 
						
						
						<r:col field="remark"  title="备注" sortable="true" width="100"></r:col>
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"   onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
					
					</div><br/>
					<div><CENTER><input id="filter_submit" class="inputd" type="button" onclick="save_job_param()" value="保  存"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input id="filter_cancel" class="inputd" type="button" onclick="location.href='etl_job_list.jsp'" value="取  消"/></CENTER></div>
			
			
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
	//console.info( etlProcessRelation_index);
	
	if (record.id=="1") {
		
		
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
		
			}
	//alert(record.id=="1");
	}
</script>
<script type="text/javascript">
$(function(){
	//alert(flag);
	//console.info(flag);
	if(flag){//说明为修改作业
//		console.info("开始修改");
		var jobId="${param.jobId}";

		
	
		//var opt=etlProcessRelation.getOptions();
		//console.info(opt);
		//opt.url="schedulerParam_list.action";
		//console.info(opt);
		//etlProcessRelation.load({jobId:jobId});
		//显示作业实例
		$("#jobId").val("${param.jobId}");
		//console.info("${param.jobId}");
		$("#batchId").val("${param.batchId}");
		//console.info($("#batchId option[value='${param.batchId}']"));
		$("#batchId option[value='${param.batchId}']").attr("selected",true);
		$("#dataDate").datebox("setValue","${param.dataDate}"=="null"?"":"${param.dataDate}");
		$("#endDate").datebox("setValue","${param.endDate}"=="null"?"":"${param.endDate}");
		$("#runFlag").val("${param.runFlag}");
		var jj = decodeURI(decodeURI('${param.jobName}')); 
		$("#jobName").val(jj);
		$("#batchId").val("${param.batchId}");
		if("${param.startTime}"=="null") $("#startTime").val("");
		else $("#startTime").val("${param.startTime}");
		if("${param.endTime}"=="null") $("#endTime").val("");
		else $("#endTime").val("${param.endTime}");
	}else{
		$("#jobId").hide();
		$("#jobIdName").hide();
		
	}
});
setTimeout(function(){
	if(flag){
		$("#batchId").val("${param.batchId}");
		//$("#runFlag").val("${param.runFlag}");
		$("#etlProcessRelation").datagrid({

	        url:"schedulerParam_list.action?jobId="+flag});
	}
},2000);
function test(){
	//$("#batchId option[value='${param.batchId}']").attr("selected",true);
	$("#batchId").val("${param.batchId}");
	//$("#runFlag").val("${param.runFlag}");
	$("#etlProcessRelation").datagrid({

        url:"schedulerParam_list.action?jobId="+flag});
}
function tipShow(){
	if(!flag){
		//$("#tip").text("后台自动生成");
	}
}
function tipHidden(){
	//$("#tip").text("");
}
</script>
</html>

