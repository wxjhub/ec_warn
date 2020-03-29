<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>调度日志管理</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:js src="default/date.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
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
}
.font{color:red}
.input_file{width:260px; margin-left:-260px;height:21px; filter:alpha(opacity=0); opacity:0;}
td{margin: 12px}
#topDiv{position: relative;overflow: hidden;}

</style>

<script type="text/javascript">
		var x = $(document).width();  
		
        var y = $(document).height(); 
       
	$(function(){
		 	
		//alert($(document).height());
		//alert($(document.body).height());
        $("#div1").css({width:x,height:y,left:0,top:50}); 
        $("#topDiv").css({width:x,height:y,left:0,top:0}); 
        $("#div2").css({width:x,height:y,left:x,top:50}); 
        $("#div3").css({width:x,height:y,left:2*x,top:50});
        
		//batchHis.resize({width:x,height:0.89*y});
		//processHis.resize({width:x,height:0.8*y});
		//taskHis.resize({width:x,height:0.8*y});
        $('#dataDate').datebox({   
         }); 
        	        
       
	});
	function left(){
		
		var l=$("#div1").css('left');
		var ll=l.substring(0,l.length-2);
		if(ll==0){
			//alert(12);
			$("#div1").animate({ 
				   left:-x
				  }, 1000 );
				$("#div2").animate({ 
					 left:0
				  }, 1000 );
				$("#div3").animate({ 
					 left:x
				  }, 1000 );
			batchHis.resize({height:0.89*y});
			processHis.resize({height:0.89*y});
		}else if(ll==-x){
			//第二次左移
			$("#div1").animate({ 
				   left:-2*x
				  }, 1000 );
				$("#div2").animate({ 
					 left:-x
				  }, 1000 );
				$("#div3").animate({ 
					 left:0
				  }, 1000 );
				processHis.resize({});
				taskHis.resize({height:0.89*y});
		}

	}
	function right(){
		var l=$("#div3").css('left');
		var ll=l.substring(0,l.length-2);
		//alert(x/2);
		if(ll==x){//第二次右移
			$("#batchId").removeAttr("disabled") ;
			$("#jobId").removeAttr("disabled") ;
			$("#count").removeAttr("disabled") ;
			$('#dataDate').removeAttr("disabled") ;  
			$("#dataDate").removeAttr("disabled") ;
			$('#sub1').show();
			$('#resetButton').show();
			$("#div1").animate({ 
				   left:0
				  }, 1000 );
				$("#div2").animate({ 
					 left:x
				  }, 1000 );
				$("#div3").animate({ 
					 left:2*x
				  }, 1000 );
				batchHis.resize({width:0.9*x});
				aa=true;
		}else if(ll==0){
		
			$("#div1").animate({ 
				   left:-x
				  }, 1000 );
				$("#div2").animate({ 
					 left:0
				  }, 1000 );
				$("#div3").animate({ 
					 left:x
				  }, 1000 );
				  bb=true;
		}
	}
</script>
<script type="text/javascript">
function formatDate(value) {
	
	if(typeof(value)=="object"&&value!=null&&value!=""){
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
		return y + '-' + m + '-' + d;
	}
}
function formatDateTime(value){
	if(typeof(value)=="object"&&value!=null&&value!=""){
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
		return y + '-' + m + '-' + d+" "+h+":"+min+":"+s;
	}
}
function submi(id){
	var batchId=$("#batchId").val();
	var jobId=$("#jobId").val();
	var dataDate=$("#dataDate").datebox('getValue');
	var count=$("#count").val();
	//alert(dataDate);
	if(id=="sub1"){
		var opt=batchHis.getOptions();
		opt.url="schedulerLog_batchHistList.action";
		batchHis.load({jobId:jobId,batchId:batchId,count:count,dataDate:dataDate,page:1});
	}else if(id=="sub2"){
		var processId=$("#processId").val();
		var opt=processHis.getOptions();
		opt.url="schedulerLog_processHistList.action";
		processHis.load({jobId:jobId,batchId:batchId,count:count,processId:processId,dataDate:dataDate,page:1});
	}else if(id=="sub3"){
		var processId=$("#processId").val();
		var taskId=$("#taskId").val();
		var opt=taskHis.getOptions();
		opt.url="schedulerLog_taskHistList.action";
		taskHis.load({jobId:jobId,batchId:batchId,count:count,processId:processId,taskId:taskId,dataDate:dataDate,page:1});
	}
	
}
//单击查看按钮 级联查看
function view(a){
	
	if(a.id=='view1'){
		if(batchHis.getAllSelected().length==0) return;
		viewgroup('',batchHis.getAllSelected()[0]);
	}else if(a.id=='view2'){
		if(processHis.getAllSelected().length==0) return;
		viewtask('',processHis.getAllSelected()[0]);
	}
}
//双击查看任务组
var aa=true;
function viewgroup(index,data){
	//if(aa){left();aa=false;}
	left();
	var opt=processHis.getOptions();
	opt.url="schedulerLog_processHistList.action";
	
	var dd = formatDate(data.dataDate);
	processHis.reload({jobId:data.jobId,batchId:data.batchId,dataDate:dd,count:data.count});
	//回显查询条件
	$("#batchId").val(data.batchId);
	$("#batchId").attr('disabled','disabled');
	$("#jobId").val(data.jobId);
	$("#jobId").attr('disabled','disabled');
	$("#count").val(data.count);
	$("#count").attr('disabled','disabled');
	$('#dataDate').datebox('setValue',dd);  
	$("#dataDate").attr('disabled','disabled');
	$('#sub1').hide();
	$('#resetButton').hide();
	
}
//双击查看任务
var bb=true;
function viewtask(index,data){
	//if(bb){left();bb=false;}
	left();
	var opt=taskHis.getOptions();
	opt.url="schedulerLog_taskHistList.action";
	var dd = formatDate(data.dataDate);
	taskHis.reload({jobId:data.jobId,batchId:data.batchId,dataDate:dd,count:data.count,processId:data.processId});
}
function showState(value){
	if(value==0) return "未完成";
	else if(value==-1) return "出错";
	else if (value==2) return "完成";
	else return "未完成";
	return value;
}
</script>
</head>
<body style="overflow: hidden;">
	<div id="topDiv"  >
	<!-- <input type="button" onclick="left()" value="向左"><input type="button" onclick="right()" value="向右"> -->
	<form action="">
	<table cellSpacing="" cellpadding=""  style="margin-left: 30px">
			<tr>
				<td height="40px" >
					批次ID：<input id="batchId" name="batchId" value="" class="input_eq" style="width:80px" /> 
				</td>
				<td height="40px" >
					作业ID：<input id="jobId" name="jobId" value="" class="input_eq" style="width:80px" /> 
				</td>
				<td>&nbsp;&nbsp;&nbsp;</td>
				<td height="40px">
					运行次数:<input id="count" name="count" value="" class="input_eq" style="width:70px"/> 
				</td><td>&nbsp;&nbsp;&nbsp;</td>
				<td height="40px" >
					数据日期:<input id="dataDate" type="text">
				</td><td>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<input id="sub1" class="inputd"  type="button"  onclick="submi(id)" value="查 询"/>
				</td><td>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<input id="resetButton" class="inputd"  type="reset"  onclick="submi(id)" value="重置" />
				</td>
				<!--  <td height="40px">
					任务组ID:<input id="processId" name="batchId" value="" class="input_eq" style="width:80px"/> 
				</td><td>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<input id="sub2" class="inputd"  type="button"  onclick="submi(id)" value="查 询"/>
				</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td height="40px">
					任务ID:<input id="taskId" name="" value="" class="input_eq" style="width:80px"/> 
				</td><td>&nbsp;&nbsp;&nbsp;</td>
				<td>
					<input id="sub3" class="inputd"  type="button"  onclick="submi(id)" value="查 询"/>
				</td>
				-->
			</tr>
		</table></form>
	<!--#################################1111111111111111111111111111################################  -->
	<div id="div1" style="position: absolute; "  >
		<!--  <form name="schedulerLog_" id="formSearch1" method="post" style="padding: 20px 0 20px 30px;"></form>-->
		
		
	
	
	<div class="gridDiv" style="">
	<r:grid sortable="true" remoteSort="true"  pagination="true" idField="batchId"  editable="false" url="schedulerLog_batchHistList.action" 
				striped="true" height="400px"  title="批次调度日志" id="batchHis" rownumbers="false" singleSelect="true" 
				onDblClickRow="viewgroup(rwoIndex,rowData)" fit="false">
		<r:toolbar id="view1" text="查看" iconCls="icon-view" onClick="view(this)"></r:toolbar>
		
		<r:col  field="uuid" checkbox="true" editable="false" align="left"></r:col>   
		<r:col  field="batchId" title="批次ID" align="left"  sortable="true" width="100" editable="false">
		</r:col>
		<r:col  field="jobId" title="作业ID" align="left"  sortable="true" width="100" editable="false">
		</r:col>
		<r:col field="startTime" title="开始时间" align="left"  sortable="true" width="140" editable="false" formatter="formatDateTime(value)">
		</r:col>   
		<r:col field="endTime"  title="结束时间" width="140"  sortable="true" align="left" formatter="formatDateTime(value)"></r:col>
		<r:col field="runTime"  title="运行时长" width="100"  sortable="true"  align="left"></r:col>
		<r:col field="runFlag"  title="运行状态" width="100"  sortable="true" align="left" formatter="showState(value)"></r:col>
		<r:col field="dataDate"  title="数据日期" width="100"  sortable="true"  align="left" formatter="formatDate(value)"></r:col>
		<r:col field="count"  title="运行次数" width="100"  sortable="true"  align="left" ></r:col>
		<r:col field="sumCount"  title="总运行次数" width="100"  sortable="true" align="left" ></r:col>
		<r:col field="createDate"  title="记录时间" width="100"  sortable="true"  align="left" formatter="formatDate(value)"></r:col>
		<r:pagination id="pag1"></r:pagination>
	</r:grid>
		<br>
	</div>
</div>
		
		
	<!--#################################22222222222222222222222222222222222222################################  -->
	<div id="div2" style="position: absolute;display:inline; ">
	<!-- 	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				
				
				
				<td>
					<input id="sub2" class="inputd"  type="button"  onclick="submi(id)" value="查 询"/>
				</td>
			</tr>
		</table>
	</form> -->
	
	<div class="gridDiv" style="">
		<r:grid sortable="true" remoteSort="true"  pagination="true" idField="processId"  editable="false" url="#" striped="true" height="300"  title="任务组调度日志" id="processHis" 
		onDblClickRow="viewtask(index,data)" rownumbers="false" singleSelect="true" fit="false">
		<r:toolbar id="view2" text="查看" iconCls="icon-view" onClick="view(this)"></r:toolbar>
		<r:toolbar id="" text="返回" iconCls="icon-back" onClick="right()"></r:toolbar>
		<r:col  field="uuid" checkbox="true" editable="false" align="left"></r:col> 
		<r:col  field="batchId" title="批次ID" align="left"  sortable="true" width="100" editable="false">
		</r:col>  
		<r:col  field="jobId" title="作业ID" align="left"  sortable="true" width="100" editable="false">
		</r:col>
		<r:col  field="processId" title="任务组ID"  sortable="true" align="left" width="100" editable="false">
		</r:col>
		<r:col field="startTime" title="开始时间"  sortable="true" align="left" width="140" editable="false" formatter="formatDateTime(value)">
		</r:col>   
		
		
		<r:col field="endTime"  title="结束时间" width="140"  sortable="true" align="left" formatter="formatDateTime(value)"></r:col>
		<r:col field="runTime"  title="运行时长" width="100"   sortable="true" align="left" ></r:col>
		<r:col field="runFlag"  title="运行状态" width="100"  sortable="true" align="left" formatter="showState(value)"></r:col>
		<r:col field="dataDate"  title="数据日期" width="100"  sortable="true"  align="left" formatter="formatDate(value)"></r:col>
		<r:col field="count"  title="运行次数" width="100"   sortable="true" align="left" ></r:col>
		<r:col field="sumCount"  title="总运行次数" width="100"   sortable="true" align="left" ></r:col>
		<r:col field="createDate"  title="记录时间" width="100"  sortable="true"  align="left" formatter="formatDate(value)"></r:col>
		<r:pagination id="pag2"></r:pagination>
	</r:grid>
		<br>
	</div>
</div>
	
	
	
	<!--#################################33333333333333333333333333333################################  -->
	<div id="div3" style="display:inline; position: absolute;">
		<!-- <form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				
				<td>
					<input id="sub3" class="inputd"  type="button"  onclick="submi(id)" value="查 询"/>
				</td>
			</tr>
		</table>
	</form>
	 -->
	<div class="gridDiv" style="">
		<r:grid sortable="true" remoteSort="true"  pagination="true" idField="taskId"   editable="false"  url="#" striped="true" height="300"  title="任务调度日志" id="taskHis" rownumbers="false" singleSelect="true" fit="false">
		<r:toolbar id="" text="返回" iconCls="icon-back" onClick="right()"></r:toolbar>
		
		<r:col  field="uuid" checkbox="true" editable="false" align="left"></r:col>  
		<r:col  field="batchId" title="批次ID"  width="100" editable="false"  sortable="true" align="left">
		</r:col>  
		<r:col  field="jobId" title="作业ID" align="left"  sortable="true" width="100" editable="false">
		</r:col>
		<r:col  field="processId" title="任务组ID" align="left" width="100"  sortable="true" editable="false">
		</r:col> 
		<r:col  field="taskId" title="任务ID" align="left" width="100"  sortable="true" editable="false">
		</r:col>
		<r:col field="startTime" title="开始时间" align="left" width="140"  sortable="true" editable="false" formatter="formatDateTime(value)">
		</r:col>   
		
		
		<r:col field="endTime"  title="结束时间" width="140"  sortable="true" align="left" formatter="formatDateTime(value)"></r:col>
		<r:col field="runTime"  title="运行时长" width="100"  sortable="true"  align="left" ></r:col>
		<r:col field="runFlag"  title="运行状态" width="100"  sortable="true" align="left" formatter="showState(value)"></r:col>
		<r:col field="dataDate"  title="数据日期" width="100"  sortable="true" align="left" formatter="formatDate(value)"></r:col>
		<r:col field="count"  title="运行次数" width="100"   sortable="true" align="left" ></r:col>
		<r:col field="sumCount"  title="总运行次数" width="100"  sortable="true"  align="left" ></r:col>
		<r:col field="createDate"  title="记录时间" width="100"  sortable="true" align="left" formatter="formatDate(value)"></r:col>
		<r:pagination id="pag3"></r:pagination>
	</r:grid>
		<br>
	</div>
</div>	
		
	
	<script type="text/javascript">
	
		$(function(){
			batchHis.resize({height:0.89*y});
		});
 </script>
</div>
</body>
 
</html>

