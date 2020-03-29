<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://www.vprisk.com/tags/webcomp" prefix="w"%>
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
<h:js src="default/dialog.js"></h:js>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />

<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
</style>
<script type="text/javascript">

var datadate;
var enddate;


function loadProcess(){
	
	var jobId = document.getElementById("jobUUID").value;
	var batchId = document.getElementById("batchUUID").value;
	var opt=flexProcess.getOptions();
//	alert(jobId);
	opt.url="process_findProcessByJob.action";
	flexProcess.load({batchId:batchId,jobId:jobId});
}	


	 function loadTask(rowIndex,rowData){
		 var jobId = document.getElementById("jobUUID").value;
		 var auto;
		 var a;
	     if(typeof rowIndex == "string"){
		    a = rowData.processId;
			auto = 2;
		}else{
			auto = 1;
			// alert(typeof rowIndex);
			var rows = flexProcess.getData();
		    for(var i=0;i<rows.rows.length;i++){
				 if(rows.rows[i].runFlag=="1"){
						  a=rows.rows[i].processId;
						  flexProcess.selectRow(i);
						  break;
					 }
			 }
					  
			if(a==null){
				 if(rows.rows.length==0){
						  a="";
				}else{
					
					a = rows.rows[0].processId;
				}
					    	
			}
	}
				 
		
	    var batchId = document.getElementById("batchId").value;
		var opt=flexTask.getOptions();
		opt.url="task_findTaskByProcess.action";
		flexTask.load({processId:a,batchId:batchId,jobId:jobId});
}
function getBatchInfo(){
	var batchId ="<%=request.getParameter("batchId")%>" ;
	var jobId ="<%=request.getParameter("jobId")%>" ;
	document.getElementById("batchId").innerHTML =batchId;
	document.getElementById("jobId").innerHTML =jobId;
	$("#jobUUID").attr("value",jobId);
	$("#batchUUID").attr("value",batchId);
	$.ajax( {
		url : "${pageContext.request.contextPath}/job_findJobByJobId.action?batchId=" + batchId+"&jobId="+jobId,
		type : "POST",
		data : "",
		dataType : "json",
		success : function(data) {
			//alert(data);
			var zNodes = eval(data);
			
			var v_asofdate = zNodes[0].dataDate;
			var v_enddate = zNodes[0].endDate;
			datadate = zNodes[0].dataDate;
			enddate	= zNodes[0].endDate;
			var v_runflag = zNodes[0].runFlag;
			//var v_uuid =  zNodes[0].uuid;
			//alert(v_asofdate);
			setButton(v_runflag);
			//alert(v_uuid);
			document.getElementById("td_asofdate").innerHTML = formatDate(v_asofdate);
			if(v_enddate!=null){
				document.getElementById("td_enddate").innerHTML = formatDate(v_enddate);
			}
			else{
				document.getElementById("td_enddate").innerHTML = "";
			}
			//document.getElementById("td_enddate")
			
			//$("#uuid").attr("value",v_uuid);
			//alert($("#uuid").attr("value"));
			loadProcess();		
		},
		error : function(data) {
			alert("批次信息取值出错,请重试");
		}
	});
	
}

//datebox format 方法
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

function setButton(flag){
	if(flag == '1'){
		document.getElementById('btn_rest').disabled=true;
		document.getElementById('btn_cont').disabled=true;
		document.getElementById('btn_stop').disabled=false;
	}else if (flag == '4') {
		document.getElementById('btn_rest').disabled=true;
		document.getElementById('btn_cont').disabled=true;
		document.getElementById('btn_stop').disabled=false;
	}else if (flag == '-1') {//批次出错状态只有重新开始能点击
		document.getElementById('btn_rest').disabled=false;
		document.getElementById('btn_cont').disabled=true;
		document.getElementById('btn_stop').disabled=true;
	}else {
		document.getElementById('btn_rest').disabled=false;
		document.getElementById('btn_cont').disabled=false;
		document.getElementById('btn_stop').disabled=true;
	}
	if(flag == '1') {
		document.getElementById("td_runflag").innerHTML = '运行中';
		document.getElementById("td_runflag").style.color="green";
		$("#btn_rest").val("重新运行");
	} else if(flag == '2') {
		document.getElementById("td_runflag").innerHTML = '已完成';
		document.getElementById("td_runflag").style.color="black";
	}else if(flag == '3') {
		document.getElementById("td_runflag").innerHTML = '停止';
		document.getElementById("td_runflag").style.color="black";
	}else if(flag == '-1') {
		document.getElementById("td_runflag").innerHTML = '出错';
		document.getElementById("td_runflag").style.color="red";
	}else if(flag == '4') {
		document.getElementById("td_runflag").innerHTML = '预处理';
		document.getElementById("td_runflag").style.color="green";
	}else {
		document.getElementById("td_runflag").innerHTML = '未运行';
		document.getElementById("td_runflag").style.color="black";
	}
}
function reload(){
	getBatchInfo();
	loadProcess();
}
function checkRefresh(){
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


function onRowClick(com,grid){
	tid = com.substr(3);
	//alert(tid);
}

function reStart(){
	if(enddate!=null){
		if(datadate.year>enddate.year){
			alert("数据日期大于结束日期");
			return;
		}
		if(datadate.year==enddate.year&&datadate.month>enddate.month){
			alert("数据日期大于结束日期");
			return;
		}
		if(datadate.year==enddate.year&&datadate.month==enddate.month&&datadate.date>enddate.date){
			alert("数据日期大于结束日期");
			return;
		}
	}
	var jobUUID = document.getElementById("jobUUID").value;
	var jobId = [];
	jobId.push(jobUUID);
	if(confirm("确定要重新开始调度批次吗?")){
		$.ajax( {
			url :"${pageContext.request.contextPath}/monitor_restartMonitor.action?jobIds="+jobId,
			type : "POST",
			dataType : "json",
			success : function(data) {
				if(data.result=="4"){
					alert("批次正在运行，请不要重复点击");
				}else if(data.result=="1"){	
					alert("启动成功!");
				}else{
					alert("启动失败!");
				}
				getBatchInfo();
			},
			error : function(data) {
			}
		});
	}
	loadProcess();
}

function stopBatch(){
	var jobUUID = document.getElementById("jobUUID").value;
	var jobId = [];
	jobId.push(jobUUID);
	if(confirm("确定要停止批次吗?")){
		$.ajax( {
			url : "${pageContext.request.contextPath}/monitor_stopMonitor.action?jobIds="+jobId,
			type : "POST",
			dataType : "json",
			success : function(data) {
				if(data.result=="1"){
					alert("停止成功!");
				}
				if(data.result=="-1"){
					alert("停止失败!");
				}
				getBatchInfo();
			},
			error : function(data) {
			}
		});
	}
	loadProcess();
}

function processContinue(){
	var jobUUID = document.getElementById("jobUUID").value;
	var jobIds = [];
	jobIds.push(jobUUID);
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
				getBatchInfo();
			},
			error : function(data) {
			}
		});
	}
	loadProcess();
}

$(function() {
	$("#batchPanel").panel({
		width:1094
	});
});

var currentRowData ;
function updateButton(value, rowData, rowIndex){

	if(value=="-1"){
		currentRowData = rowData;
		//出错信息为红色
		currentRowData.errorMessage = '<font color=\"red\">'+currentRowData.errorMessage+'</font>';
		return '出错 '+'<button class="inputd" onclick="recoverStatus();">' +'恢复'+ ' </button>';
	}else if(value=="0"){
		return '未运行';
	}else if(value=="1"){
		return '正在运行';
	}else if(value=="2"){
		return '已完成';
	}
	
}
function recoverStatus(){
	dialog.open();
	
}
function recover(){
	var stat1 = $("#status1").attr("checked");
	var status;
	//var stat2 = $("#status2").attr("checked");
	if(stat1=="checked"){
		status = 1;
	}else{
		status = 0;
	}
	var  taskId = currentRowData.taskId;
	var  processId = currentRowData.processId;
	var jobId = document.getElementById("jobUUID").value;
	$.ajax( {
		url : "${pageContext.request.contextPath}/taskStatus_recoverStatus.action",
		type : "POST",
		data : {"jobId":jobId,"taskId":taskId,"processId":processId,"status":status},
		dataType : "json",
		success : function(data) {
			if(data=="1"){
				alert("状态修改成功!");
				dialog.close();
			}else{
				alert("状态修改失败!");
			}
		
			currentRowData = null;
			reload();
		},
		error : function(data) {
			alert("状态修改失败!");
		}
	});
	
}
function clossed(){
	dialog.close();
}

function seeDetail(value, rowData, rowIndex){
	var batchId = document.getElementById("jobId").value;
	var paramter11 = 'batchId='+batchId+'&processId='+rowData.processId+'&taskId='+rowData.taskId;
	var aa = '<a href="${pageContext.request.contextPath}/taskStatus_toForm.action?'+paramter11+'">'+value+'</a>';
	return aa;
}
</script>
	</head>
	<body onload="getBatchInfo();" style="background-color:#EAF4FE;" >
   
	<div style="paddingTop: 2px;">&nbsp;</div>
	 <FORM name="formDel" id="formDel" action="#" method="post" style="margin: 20px 30px 0 30px;">
    	<div class="easyui-panel" title="作业监控" id="batchPanel">
    	
        <table width="100%" border="0" cellpadding="0" cellspacing="0" align="0"  class="thead" style="border-style: none">
		<tr style="CURSOR: hand">
			<td width="10%" height="26" align="center" class="m_usenan">批次</td>
			<td width="10%" height="26" align="center" class="m_usenan">作业</td>
			<td width="15%" height="26" align="center" class="m_usenan">数据日期</td>
			<td width="15%" height="26" align="center" class="m_usenan">运行状态</td>
			<td width="15%" height="26" align="center" class="m_usenan">结束日期</td>
			<td width="20%" height="26" align="center" class="m_usenan">批次操作</td>
			<td width="20%" height="26" align="center" class="m_usenan">刷新操作</td>
		</tr>
		<tr style="CURSOR: hand">
			<td height="26" align="center" bgcolor="#FFFFFF" id="batchId" class="m_uselist"> 
			</td>
			<td height="26" align="center" bgcolor="#FFFFFF" id="jobId" class="m_uselist"> 
			
			</td>
		
			<td id="td_asofdate" align="center"  bgcolor="#FFFFFF" class="m_uselist"></td>
			<td id="td_runflag" align="center" bgcolor="#FFFFFF" class="m_uselist">
				<c:choose>
					<c:when test="${p_runflag=='1'}">运行中</c:when>
					<c:when test="${p_runflag=='2'}">已完成</c:when>
					<c:when test="${p_runflag=='3'}">停止</c:when>
					<c:when test="${p_runflag=='-1'}">出错</c:when>
					<c:when test="${p_runflag=='4'}">预处理</c:when>
					<c:otherwise>未运行</c:otherwise>
				</c:choose>
			</td>
			<td id="td_enddate" align="center" bgcolor="#FFFFFF" class="m_uselist"></td>
			<td width="25%" height="26" align="center" bgcolor="#FFFFFF" class="m_uselist">
				<input type="button" class="zh_btnbg2" id="btn_stop" disabled="disabled" value="停止" onclick="stopBatch();" />&nbsp;&nbsp;&nbsp;
				<input type="button" class="zh_btnbg2" id="btn_cont" disabled="disabled" value="开始" onclick="processContinue();" />&nbsp;&nbsp;&nbsp;
				<input type="button" class="zh_btnbg2" id="btn_rest" disabled="disabled" value="重新运行" onclick="reStart();" />
			</td>
			<td height="26" align="center" bgcolor="#FFFFFF" class="m_uselist">
			   <!--  
				<input type="button" class="zh_btnbg2" id="btn_modify" value="修改任务" onclick="taskModify();" />&nbsp;&nbsp;&nbsp;
				-->
				<input type="checkbox" id="chk_refresh" onclick="checkRefresh();" value="自动刷新" />自动刷新
			</td>
			<input type="hidden" id="jobUUID" name="jobUUID" value=""></input>
			<input type="hidden" id="batchUUID" name="batchUUID" value="" >
			
		</tr>
		<tr style="CURSOR: hand">
			<td height="26" align="center" bgcolor="#FFFFFF" class="m_usenan" colspan="6"></td>
		</tr>
	</table>
	</div>
    </FORM>
	<table width="95%" border="0" cellpadding="0" cellspacing="1" align="center"  style="margin: 0px 30px 0 30px;">
		<tr>
			<td width="229px;">
				<div class="gridDiv" id="tabs1" style="width:100%;margin:0 auto;" align="left">
					<r:grid sortable="true" remoteSort="true" title="任务组" pagination="true" onLoadSuccess="loadTask();" onClickRow="loadTask(rowIndex,rowData);" idField="processId" singleEdit="true"  rownumbers="false" singleSelect="true" editable="false" url="" height="400px" width="229px" striped="true" id="flexProcess">
						<r:col  field="processId" hidden="true"></r:col>  						
						<r:col  field="processName" title="任务组名称" sortable="false" width="120" rowspan="2"></r:col>  
						<r:col  field="runFlag" title="运行状态" dictId="etl.process.runflag" width="100" rowspan="2"></r:col>  	
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"  displayMsg=" {from}/{to}页 共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>	
					</r:grid>
				</div>
			</td>
			<td width="95%">
				<div class="gridDiv" id="tabs2" style="width:100%;margin:0 auto;" align="left">
					<r:grid sortable="true" remoteSort="true"  pagination="true" hasTip="true" nowrap="true" title="任务运行状态" idField="taskId" singleEdit="true"  rownumbers="false" singleSelect="true" editable="false" height="400px" url="" striped="true"  id="flexTask">
						<r:col  field="taskId" hidden="true"></r:col>  
						<r:col  field="processId" hidden="true"></r:col>  
						<r:col  field="dataDate" title="数据日期" width="80" rowspan="2" formatter="formatDate(value);"></r:col>  
						<r:col  field="taskDesc" title="任务名称" width="120" rowspan="2" sortable="false"></r:col>
						<r:col  field="scriptName" title="脚本名称" width="200" rowspan="2" sortable="false"></r:col>
						<r:col  field="scriptType" title="脚本类型"  dictId="etl.script.type" width="50" rowspan="2" sortable="false"></r:col>
						<r:col  field="startTime" title="开始时间" width="100" rowspan="2" formatter="formatTime(value);"></r:col>
						<r:col  field="endTime" title="结束时间" width="100" rowspan="2" formatter="formatTime(value);"></r:col>  
						<r:col  field="runTime" title="运行时间" width="70" rowspan="2"></r:col>
						<r:col  field="runFlag" title="运行状态" width="100" dictId="etl.task.runflag" rowspan="2" formatter="updateButton(value, rowData, rowIndex);"></r:col>
						<r:col  field="errorMessage" title="状态信息" width="80" rowspan="2" ></r:col>
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
				</div>
			</td>
		</tr>
	</table>
	<w:dialog id="dialog" name="dialogName" title="提示框..." iconCls="icon-search"  closable="false" 
		 closed="true" loadingMessage="正在载入" width="260" height="150">
		<div style="height: 50px;">
			<center style="margin-top:30px;">
				<h:radio value="0" id="status1" text="已完成" name="recoverStatus"></h:radio>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<h:radio value="1" id="status2" text="未运行" checked="true" name="recoverStatus"></h:radio>
			</center>
		</div>
		<center>
			<a class="easyui-linkbutton" iconCls="icon-ok" href="javascript:void(0)" onclick="recover();">确定</a>
			<a class="easyui-linkbutton" iconCls="icon-cancel" href="javascript:void(0)" onclick="clossed();">关闭</a>
		</center>
	</w:dialog>
	
	</body>
	
</html>
