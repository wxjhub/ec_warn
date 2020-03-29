<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 
<title>ActiveMq监控</title> 
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
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
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
$(function(){
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 80);
});
function searchPendingMessage(){
	var selected = etlClientStatus.getAllSelected();
	var clientName;
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要查看的客户端','warning');
		return;
	}else{
		clientName = selected[0].name;
	}
	$("#clientStatus").hide();
	$("#clientMessage").panel("open");
	$("#clientStatus").panel("setTitle","客户端: "+clientName+"消息列表");
	$("#clientMessage").show();
	//etlTaskRelation.reload();
	var opt=etlClientMessage.getOptions();
	opt.url="activeMqMonitor_listMessageByQueueName.action";
	etlClientMessage.load({clientName:clientName});
}

function searchActiveClient(){
	var selected = etlClientStatus.getAllSelected();
	var clientName;
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要查看的客户端','warning');
		return;
	}else{
		clientName = selected[0].name;
	}
	$("#clientStatus").hide();
	$("#clientName").panel("open");
	$("#clientStatus").panel("setTitle","客户端名称: "+clientName);
	$("#clientName").show();
	//etlTaskRelation.reload();
	var opt=etlClientName.getOptions();
	opt.url="activeMqMonitor_listClientByQueueName.action";
	etlClientName.load({clientName:clientName});
}	

function formatterStatus(value){
	if(value!=null){
		if(value){
			return "存活";
		}else{
			return "死亡";	
		}
	}else{
		return "死亡";	
	}
}

function backClientStatus(){
	$("#clientName").hide();
	$("#clientStatus").panel("open");
	$("#clientStatus").panel("setTitle","客户端状态");
	$("#clientStatus").show();
	//etlTaskRelation.reload();
	etlClientStatus.reload();
	
}
function backClient(){
	$("#clientMessage").hide();
	$("#clientStatus").panel("open");
	$("#clientStatus").panel("setTitle","客户端状态");
	$("#clientStatus").show();
	//etlTaskRelation.reload();
	etlClientStatus.reload();
}
function redo(){
	

	$.ajax( {
		url : "${pageContext.request.contextPath}/activeMqMonitor_mqStatus.action",
		type : "POST",
		data : "",
		dataType : "json",
		success : function(data) {
			var zNodes = eval(data);
			if(data=="1"){
				alert("信息取值出错,请重试");
			}else{
					var name = zNodes.rows[0].brokerName;
					var version = zNodes.rows[0].brokerVersion;
					var url = zNodes.rows[0].vMURL;
					var counsumerSize	= zNodes.rows[0].counsumerSize;
					var memoryPercent = zNodes.rows[0].memoryPercentUsage;
					var connectSize =  zNodes.rows[0].connectSize;
					document.getElementById("brokerName").innerHTML =name;
					document.getElementById("brokerVersion").innerHTML =version;
					document.getElementById("url").innerHTML =url;
					document.getElementById("counsumerSize").innerHTML =counsumerSize;
					document.getElementById("memoryPercentUsage").innerHTML =memoryPercent;
					document.getElementById("connectSize").innerHTML =connectSize;
					
					//$("#brokerName").text(name);
					//$("#brokerVersion").text(version);
					//$("#url").text(url);
					//$("#dataDirectory").text(directory);
					//$("#memoryPercentUsage").text(memoryPercent);
					//$("#connectSize").text(connectSize);
					var opt=etlClientStatus.getOptions();
					opt.url="activeMqMonitor_listQueueStatus.action";
					etlClientStatus.load();
				}
		},
		error : function(data) {
			alert("信息取值出错,请重试");
		}
	});
}
</script>
<style type="text/css">
	table td{
	border: 0px solid #c0c0c0;
	}
</style>
</head>
<body onload="redo()">
<FORM name="formDel" id="formDel" action="#" method="post" style="margin: 20px 30px 0 30px;">
	<div class="easyui-panel" title="ActiveMq监控" >
	
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0" align="0" class="thead">
		<tr style="CURSOR: hand">
			<td width="20%" height="26" align="center" class="m_usenan">ActiveMq服务名称</td>
			<td width="15%" height="26" align="center" class="m_usenan">ActiveMq版本</td>
			<td width="10%" height="26" align="center" class="m_usenan">所在主机名</td>
			<td width="15%" height="26" align="center" class="m_usenan">活动客户端数量</td>
			<td width="15%" height="26" align="center" class="m_usenan">内存使用比例</td>
			<td width="15%" height="26" align="center" class="m_usenan">连接数</td>
		</tr>
		<tr style="CURSOR: hand">
			<td height="26"  align="center" bgcolor="#FFFFFF" class="m_uselist" id="brokerName"> 
			</td>
			
			<td align="center" bgcolor="#FFFFFF" class="m_uselist" id="brokerVersion">
			</td>
			
			<td  height="26" align="center"  bgcolor="#FFFFFF" class="m_uselist"  id="url">
			</td>
			
			<td height="26" align="center"  bgcolor="#FFFFFF" class="m_uselist" id="counsumerSize">
			</td>
			<td height="26" align="center" bgcolor="#FFFFFF" class="m_uselist" id="memoryPercentUsage">
			</td>
			<td  height="26" align="center"  bgcolor="#FFFFFF" class="m_uselist" id="connectSize">
			</td>
			
		</tr>
		<tr style="CURSOR: hand">
			<td height="26" align="center" class="m_usenan" colspan="6"></td>
		</tr>
	</table>
	</div>
	</FORM>
	<br/>
	<div style="margin: 20px 30px 0 30px;">
	<div class="easyui-panel" title="客户端状态" id="clientStatus"   width="auto" >
	
				<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" singleEdit="true" editable="false" url="" striped="true"  height="300" rownumbers="false" id="etlClientStatus">
					<r:toolbar id="addRowProcessRelation" text="查看待发消息" iconCls="icon-sysmrg" onClick="searchPendingMessage();"></r:toolbar>    
					<r:toolbar text="查看活动客户端" iconCls="icon-search" onClick="searchActiveClient();"></r:toolbar> 
					<r:col field="url"  checkbox="true" width="200" rowspan="2"></r:col>
					<r:col field="name"  title="客户端名称"    width="200" rowspan="2"></r:col>
					<r:col field="consumerCount" title="活动客户端数量" sortable="true"  width="200" rowspan="2"></r:col>
					<r:col field="queueSize" title="待发消息" sortable="true"   width="200" rowspan="2"></r:col>   			
					<r:col field="dequeueCount" title="出列消息"   width="200" rowspan="2"></r:col>
					<r:col field="enqueueCount" title="入列消息" width="200" rowspan="2"></r:col>	
					<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"></r:pagination>
				</r:grid>

	</div>
	<div class="easyui-panel" title="客户端名称：" closed="true" noheader="true"  width="auto"  id="clientName" >
				<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" singleEdit="true" editable="false" url="" striped="true"  height="300" rownumbers="false" id="etlClientName">
					<r:toolbar id="back" text="返回"  onClick="backClientStatus();"iconCls="icon-redo" ></r:toolbar>    
					<r:col field="clientId"  title="客户端连接ID" width="200" rowspan="2"></r:col>
					<r:col field="sessionId"  title="会话ID"    width="200" rowspan="2"></r:col>
					<r:col field="enqueueCount" title="入列消息" sortable="true"  width="200" rowspan="2"></r:col>
					<r:col field="dequeueCount" title="出列消息" sortable="true"   width="200" rowspan="2"></r:col>   			
					<r:col field="pendingQueueSize" title="待发消息"   width="200" rowspan="2"></r:col>
					<r:col field="isActive" title="状态" width="200" rowspan="2" formatter="formatterStatus(value)"></r:col>	
					<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"></r:pagination>
				</r:grid>
	</div>
	
	<div class="easyui-panel" title="客户端名称：" closed="true" noheader="true"  width="auto"  id="clientMessage" >
				<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" singleEdit="true" editable="false" url="" striped="true"  height="300" rownumbers="false" id="etlClientMessage">
					<r:toolbar id="back" text="返回"  onClick="backClient();"iconCls="icon-redo" ></r:toolbar>    
					<r:col field="jMSMessageID"  title="消息ID" width="200" rowspan="2"></r:col>
					<r:col field="sourceId" title="消息来源" sortable="true"  width="200" rowspan="2"></r:col>
					<r:col field="jMSTimestamp" title="产生时间" sortable="true"   width="200" rowspan="2"></r:col>   			
					<r:col field="jMSDeliveryMode" title="持久化状态"   width="200" rowspan="2"></r:col>
					<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10"></r:pagination>
				</r:grid>
	</div>
	</div>
</body>

</html>

