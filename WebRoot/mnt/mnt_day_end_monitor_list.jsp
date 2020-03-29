<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="/WEB-INF/tld/rmp.tld"  prefix="rmp" %>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>日终监控</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="default/pagination.js"></h:js>
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
.input_file{width:140px; margin-left:-140px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>

<script type="text/javascript">
var date = new Date();
var y = date.getFullYear();
var m = date.getMonth() + 1;
var d = date.getDate()-1;
var dataDate = y + '-' + (m < 10 ? ('0' + m) : m) + '-'
		+ (d < 10 ? ('0' + d) : d);
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
	$('#asOfDate').datebox('setValue', dataDate);
	$("#asOfDate").attr('required','true');
});
</script>

<script type="text/javascript">
//导出模板
function getTemplate(){
	window.location.href="${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"CodeMap";
}
//导出数据
function getTaskByData(){
	window.location.href="${pageContext.request.contextPath}/exportExcelALM.action?modelName="+"CodeMap";
}
//导入数据
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
			url: "alminputExcel_inputExcelCodeMap.action?modelName="+"CodeMap",
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
					lrmsMoni.reload(); 
				} else{
					messager.close();  
					$.messager.alert('系统提示','导入成功！','warning');
					lrmsMoni.reload();
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
	<%-- 	<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<INPUT name="pageNo1" id="pageNo1"type="hidden" value="${param.success}"> 
		<INPUT name="pageNo2" id="pageNo2"type="hidden" value="${param.lrmsdate}">   --%>
		 <table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">数据日期：</td>
				<td height="40px"><input class="easyui-datebox" id="asOfDate"
					name="asOfDate"  style="width: 150px; padding: 0px"  required="true"/></td>
			</tr>
			<tr>
				<td colspan="6">
				<input id="filter_submit" class="inputd" type="button" value="查询"
					onclick="submi()" />
				<input id="filter_reset" class="inputd" type="reset"
					onclick="rese()" value="重 置" />
				</td>
			</tr>
		</table> 
	</form>
	
		<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" 
		rownumbers="false" singleSelect="false" editable="true" url="dayEndMonitor_findList.action?asOfDate=\"+$('#asOfDate').datebox('getValue')+\""   
		striped="true" fit="true" height="50%"  title="日终监控" id="lrmsMoni">
			
			<r:col field="batchId" title="批次编号" sortable="true" width="150"  editable="false" hidden="true">
			</r:col>
			<<r:col  field="batchName" title="批次名称" editable="false" sortable="true" width="250">
			</r:col>
			<r:col field="jobId" title="作业编号" sortable="true" width="150" editable="false">
			</r:col>
			<r:col field="processId" title="任务组编号" sortable="true" width="150" editable="false" hidden="true">
			</r:col>
			<r:col field="processName" title="任务组名称" sortable="true" width="150" editable="false">
			</r:col>
			<r:col field="taskId" title="任务编号" sortable="true" width="150" editable="false" hidden="true">
			</r:col>
			<r:col field="taskName" title="任务名称" sortable="true" width="150" editable="false">
			</r:col>
			<%-- <r:col field="runFlag" title="运行状态" sortable="true" width="150"  editable="false">
			</r:col> --%>
			<r:col field="runFlag" title="运行状态" sortable="true" width="80" dictId="warn_batch_etl_runFlag"></r:col>
			<r:col field="runTime" title="运行时长" sortable="true" width="150" editable="false">
			</r:col>
			<r:col field="count" title="运行次数" sortable="true" width="150" editable="false">
			</r:col>
			<r:col field="errorMessage" title="错误信息" sortable="true" width="150" editable="false">
			</r:col>
			<r:col field="asOfDate" title="数据日期" sortable="true" width="130" dateFormat="yyyy-MM-dd" editable="false">
			</r:col>
			<%-- <r:col  field="asOfDate" title="数据日期" editable="false" sortable="true" width="100">
				<r:editorDate format="yyyy-MM-dd"></r:editorDate>
			</r:col> --%>
			<r:col field="stdTime" title="开始时间" sortable="true" width="150" editable="false" hasTime="true" dateFormat="yyyy-MM-dd">
			</r:col>
			<r:col field="endTime" title="结束时间" sortable="true" width="150" editable="false" hasTime="true" dateFormat="yyyy-MM-dd">
			</r:col>
		
		<r:pagination id="pag"></r:pagination>
	</r:grid>
	</div>
</body>
<script>

//重置查询信息
function rese(){
	$('#asOfDate').datebox('setValue', '');
}

function submi(){
	var  asOfDate=$('#asOfDate').datebox('getValue');
	//alert(asOfDate);
	var jsonData = {
			asOfDate:asOfDate ,
			newpage:1,page:1
			};
	lrmsMoni.load(jsonData);
	
}
	</script>
</html>

