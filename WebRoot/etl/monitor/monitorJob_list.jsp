<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
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
.input_file{width:140px; margin-left:-140px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>

<script type="text/javascript">
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
});

function reStart(){
	var data = jobList.getAllSelected();
	var jobIds = [];
	if(data.length<1){
		alert("请选择要运行的作业");
		return;
	}else{
		for(var i=0;i<data.length;i++){

				if(data[i].dataDate.year>data[i].endDate.year){
					alert(data[i].jobId+"的数据日期大于结束日期");
					return;
				}
				if(data[i].dataDate.year==data[i].endDate.year&&data[i].dataDate.month>data[i].endDate.month){
					alert(data[i].jobId+"的数据日期大于结束日期");
					return;
				}
				if(data[i].dataDate.year==data[i].endDate.year&&data[i].dataDate.month==data[i].endDate.month&&data[i].dataDate.date>data[i].endDate.date){
					alert(data[i].jobId+"的数据日期大于结束日期");
					return;
				}
				jobIds.push(data[i].jobId);
			
		}
	}
	var batchId = document.getElementById("batchId").value;
	if(confirm("确定要重新开始调度批次吗?")){
		$.ajax( {
			url :"${pageContext.request.contextPath}/monitor_restartMonitor.action?jobIds="+jobIds,
			type : "POST",
			data : {"jobIds":jobIds},
			dataType : "json",
			success : function(data) {
				if(data.result=="4"){
					alert("批次正在运行，请不要重复点击");
				}else if(data.result=="1"){	
					alert("启动成功!");
				}else{
					alert("启动失败!");
				}
				changeBatch();
			},
			error : function(data) {
			}
		});
	}
	
}

function stopBatch(){
	var batchId = document.getElementById("batchId").value;
	var jobIds = [];
	var data = jobList.getAllSelected();
	if(data.length<1){
		alert("请选择要停止的作业");
		return;
	}else{
		
		for(var i=0;i<data.length;i++){

			if(data[i].runFlag=="1"||data[i].runFlag=="4"){
				
				jobIds.push(data[i].jobId);
			}else{
				alert(data[i].jobId+"还没开始,不可以停止！请检查！");
				return ;
			}
		}
	}
	
	if(confirm("确定要停止批次吗?")){
		$.ajax( {
			url : "${pageContext.request.contextPath}/monitor_stopMonitor.action?jobIds="+jobIds,
			type : "POST",
			dataType : "json",
			success : function(data) {
				if(data.result=="1"){
					alert("停止成功!");
				}
				if(data.result=="-1"){
					alert("停止失败!");
				}
				//getBatchInfo();
			},
			error : function(data) {
			}
		});
	}
	changeBatch();
}

function processContinue(){
	var batchId = document.getElementById("batchId").value;
	var data = jobList.getAllSelected();
	var jobIds = [];
	if(data.length<1){
		alert("请选择要运行的作业");
		return;
	}else{
		for(var i=0;i<data.length;i++){

			if(data[i].runFlag=="-1"||data[i].runFlag=="2"){
				alert(data[i].jobId+"的状态有问题！请检查！");
				return;
			}else if(data[i].runFlag=="1"){
				alert(data[i].jobId+"正在运行！请重新选择");
				return;
			}else{
				
				if(data[i].dataDate.year>data[i].endDate.year){
					alert(data[i].jobId+"的数据日期大于结束日期");
					return;
				}
				if(data[i].dataDate.year==data[i].endDate.year&&data[i].dataDate.month>data[i].endDate.month){
					alert(data[i].jobId+"的数据日期大于结束日期");
					return;
				}
				if(data[i].dataDate.year==data[i].endDate.year&&data[i].dataDate.month==data[i].endDate.month&&data[i].dataDate.date>data[i].endDate.date){
					alert(data[i].jobId+"的数据日期大于结束日期");
					return;
				}
				jobIds.push(data[i].jobId);
			}
			
		}
	}
	if(confirm("确定从当前状态继续调度批次吗?")){
		$.ajax( {
			url : "${pageContext.request.contextPath}/monitor_startAndContinueMonitor.action?jobIds="+jobIds,
			type : "POST",
			dataType : "json",
			success : function(data) {
				if(data.result=="1"){
					alert("逻辑校验发现错误!");
				}
				if(data.result=="2"){
					alert("运行成功!");
				}
				if(data.result=="-1"){
					alert("运行失败!");
				}if(data.result=="4"){
					alert("批次正在运行，请不要重复点击");
				}
				changeBatch();
			},
			error : function(data) {
			}
		});
	}
}

function getBatchList(){
	$.ajax( {
		url : "${pageContext.request.contextPath}/batch_findBatchList.action",
		type : "POST",
		data : "",
		dataType : "json",
		success : function(data) {
			var zNodes = eval(data);
			var sele = $("#batchId");
			sele.html("");
			sele.append("<option value='' selected='selected'>"+"---请选择---"+"</option>");
			for(var i=0;i<zNodes.length;i++){
					sele.append("<option value="+zNodes[i].batchId+">"+zNodes[i].batchName+"</option>");
			}
			
		},
		error : function(data) {
			alert("获取批次列表信息出错,请重试");
		}
	});
	
}		
function ddlClick(rowIndex,rowData){
	var batchId = document.getElementById("batchId").value;
	//alert(rowData.jobId+"!!"+batchId);
	window.location.href = "${pageContext.request.contextPath}/etl/monitor/processMonitor.jsp?jobId="+rowData.jobId+"&batchId="+rowData.batchId;
}
function changeBatch(){
	var batchId = document.getElementById("batchId").value;
	var jsonData = {
			batchId:$('#batchId').val(),
			jobId:$('#jobId').val(),
			jobName:$('#jobName').val(),
			runStatus:$('#runStatus').val(),
			newpage:1
			};
	var opt=jobList.getOptions();
	opt.url="job_findJobByBatch.action";
	jobList.load(jsonData);
}	
function reload(){
	changeBatch();
}

function aa(){
	//alert("111");
	if(document.getElementById('chk_refresh').checked){
		reload();
		startRefresh();
	}
	else
		clearInterval(begin);
}
function checkRefresh(){
	//alert("111");
	if(document.getElementById('chk_refresh').checked){
		reload();
		startRefresh();
	}
	else
		clearInterval(begin);
}

function startRefresh(){
	begin = setInterval("reload()",15000);
}

function stopRefresh(){
	clearInterval(begin);
}

</script>
</head>
<body onload="getBatchList();" >
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px" >作业编号：
					<input type="text" name="jobId" id="jobId" class="input_eq" style="width:150px"/>
				</td>
				<td height="40px">批次编号：<select name="batchId"   id="batchId" class="input_eq" style="width:150px" >
					<option value="" selected="selected">---请选择---</option>
					</select></td>
			
				</tr>
			　　　<tr>
				<td height="40px">作业名称：
					<input type="text" name="jobName" id="jobName" class="input_eq" style="width:150px"/>
				</td>
				
				<td height="40px">运行状态：<select name="runStatus"   id="runStatus" class="input_eq" style="width:150px" >
						 <rmp:option dictId="etl.batch.runflag" prompt="---请选择---"  defaultValue=""></rmp:option>
					</select>
				</td>
				
				<td>
					<input id="filter_submit" class="inputd" type="button"  value="查 询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
				
				<td >
					<input type="checkbox" id="chk_refresh" onclick="aa();" value="自动刷新" />自动刷新
				</td>
			</tr>
		</table>
	</form>
	
			<div class="gridDiv" id="gridDiv">
					<r:grid sortable="true" remoteSort="true"  pagination="true" idField="uuid" editable="false" onDblClickRow="ddlClick(rowIndex,rowData);" singleEdit="true" rownumbers="false" singleSelect="false" url="job_findJobByBatch.action" fit="true"  striped="true" height="100%" id="jobList">
						<r:toolbar id="addRowBatch" text="开始" iconCls="icon-add" onClick="processContinue();"  ></r:toolbar>    
						<r:toolbar text="停止" iconCls="icon-remove" onClick="stopBatch();"  ></r:toolbar>     			
						<r:toolbar text="重新运行" iconCls="icon-save" onClick="reStart();" ></r:toolbar>
						<r:col field="uuid" checkbox="true" editable="false"   rowspan="2"></r:col>		
						
						<r:col field="batchId" title="批次名称" width="160" rowspan="2" sortable="true" >
						</r:col>
						<r:col field="jobId" editable="false" title="作业编号" width="160" rowspan="2" sortable="true" >
							<r:editorText validType="jobIdValid"></r:editorText>
						</r:col>
										  
						<r:col field="jobName" title="作业名称" width="150" rowspan="2" sortable="true" >
						</r:col>
			
						<r:col field="runFlag" title="运行状态" dictId="etl.batch.runflag"  width="80" rowspan="2"  sortable="true">                      
						</r:col>
						<r:col  field="dataDate" title="数据日期" formatter="formatDate(value);"  width="100" rowspan="2" sortable="true">   
						</r:col>  
						<r:col  field="endDate" title="结束日期" formatter="formatDate(value);" width="100" rowspan="1"></r:col>  						
						<r:col  field="startTime" title="开始时间" width="150" rowspan="1" formatter="formatTime(value);"></r:col> 
						<r:col  field="endTime" title="结束时间" width="150" formatter="formatTime(value);" rowspan="1"></r:col>   
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
					</div>

</body>
<script>


//重置查询信息
function rese(){
	$('#batchId').val('');
	$('#jobId').val('');
	$('#jobName').val('');
	$('#runStatus').val('');
}

function submi(){
	var jsonData = {
			batchId:$('#batchId').val(),
			jobId:$('#jobId').val(),
			jobName:$('#jobName').val(),
			runStatus:$('#runStatus').val(),
			newpage:1
			};
	jobList.load(jsonData);
	
}

function formatDate(value) {
	if(value != null) {
		var m = value.month + 1;
		var d = value.date;
		var y = value.year + 1900;
		var h = value.hours;
		var min = value.minutes;
		var s = value.seconds;
		if(m<10) m = '0' + m;
		if(d<10) d = '0' + d;
		return y + '-' + m + '-' + d;
	}
}

function formatTime(value) {
	if(value != null) {
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
		return y + '-' + m + '-' + d + ' '+ h+':'+min+':'+s;
	}
}

	</script>
</html>

