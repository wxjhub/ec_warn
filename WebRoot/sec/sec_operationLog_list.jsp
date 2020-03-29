<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.vprisk.com/tags/rmp" prefix="rmp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>操作日志</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript">
function init(){
<%
Calendar calendar = Calendar.getInstance();
calendar.setTime(new Date());
calendar.set(Calendar.HOUR_OF_DAY, 0);
calendar.set(Calendar.MINUTE, 0);
calendar.set(Calendar.SECOND, 0);
 
Date start = calendar.getTime();

calendar.add(Calendar.DAY_OF_MONTH, 1);
calendar.add(Calendar.SECOND, -1);
 
Date end = calendar.getTime();
SimpleDateFormat formater2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
String s=formater2.format(start);
String e= formater2.format(end);

request.setAttribute("start", s);
request.setAttribute("end", e);

%>
}

function query(){
	var logName=$('#logName').val();
	var userName=$('#userName').val();
	var userRealName=$('#userRealName').val();
	var startDate=$('#startDate').datetimebox('getValue');
	var endDate=$('#endDate').datetimebox('getValue');
	var isAuditLog=$('#auditLog').combobox('getValue');
	/* var logType=$('#logType').combobox('getValue'); */
	
	$('#operationLogGrid').datagrid({
		url:'${pageContext.request.contextPath}/operationLog_findAllOperationLog.action',
		queryParams: {
			logName:logName,
			userName:userName,
			userRealName:userRealName,
			startDate:startDate,
			endDate:endDate,
			isAuditLog:isAuditLog
			/* logType:logType */
		}
	});
 } 

function resetForm(formId){
	$("#" + formId + " input[type!='button'][type!='hidden']").each(function(i){
		var obj = $(this);
		var classValue = obj.attr("class");
		if(classValue && classValue.indexOf("easyui-combo") > -1) {
			obj.combobox("clear");
		} else if(classValue && classValue.indexOf("easyui-date") > -1) {
			obj.datebox("clear");
		} else {
			obj.val("");
		}
	});
}

function resetCondition(){
	resetForm("formSearch");
	$("#logType").combobox("clear");
	$("#auditLog").combobox("clear");
}

$(function(){
	var height = $('.gridDiv').parent().parent()[0].clientHeight - $("#formSearch").height() - 74;
	$('.gridDiv').height(height);
	
	$('#operationLogGrid').datagrid({
		title:'操作日志列表',
		iconCls:'icon-computer',
		width:'100%',
		height:355,
		fit: true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'',//请求数据的url
		pagination:true,
		fitColumns:true,
		columns:[[
			{field:'userName', title:"用户名",  width:100,editor:'text'},
			{field:'userRealName', title:"用户姓名",   width:100,editor:'text'},
			{field:'userOrgName', title:"用户机构",   width:150,editor:'text'},
			{field:'clientIp', title:"客户端IP地址",  width:100,editor:'text'},
			/* {field:'logType', title:"所属模块",   width:100,editor:'text'}, */
			{field:'logName', title:"日志信息",   width:250,editor:'text'},
			{field:'operateTime', title:"日志时间",  width:150},
			{field:'logId', title:"详细", align:'center', width:50, 
				formatter:function(value){
	    			if(value == null || value == "") 
				  		return "<a href='#' style='color:gray'>详细</a>";
				  	else
				  		return "<a href='${pageContext.request.contextPath}/operationLog_findOperationLogByLogId.action?logId="+value+"'><font color='blue'>详细</font></a>";
			    }
			}
			
		]]
	});
	
	$(function(){
	   $('#auditLog').combobox({
	 		panelHeight:'100%'
	   });
    });
	
	$('#logType').combobox({   
	    url:'${pageContext.request.contextPath}/operationLog_getdata.action',   
	    valueField:'id',   
	    textField:'text'  
	}); 
	
});
</script>
</head>
<body onload="init()">
<!--pageright begin-->
<div class="majorword" style="padding-left: 30px">
	<FORM name="formSearch" id="formSearch" method="post">
	<table cellSpacing="0" cellpadding="0" border="0">
	    <tr style="height: 32px;">
	      <td height="40px">日志名称:</td>
	      <td height="40px"><input class="input_eq" type="text" id="logName" name="logName" style="width:150px;height:20px"/></td>
	      <td height="40px">用户名:</td>
	      <td height="40px"><input class="input_eq" type="text" id="userName" name="userName" style="width:150px;height:20px"/></td>
	      <td height="40px">用户姓名:</td>
	      <td height="40px"><input class="input_eq" type="text" id="userRealName" name="userRealName" style="width:150px;height:20px"/></td>
	      <td height="40px">审计日志:</td>
	      <td height="40px">
	         <select name="auditLog" class="easyui-combobox" id="auditLog" style="width: 50px;">
		       <rmp:option dictId="sys.operationLog.auditLog" prompt="  "></rmp:option>
	         </select>
	      </td>
	    </tr>
	    <tr style="height: 32px;">
	      <td height="40px">起始时间:</td>
	      <td height="40px"><input class="easyui-datetimebox" id="startDate" name="startDate" style="width:150px;padding:0px" value="${start}"/></td>
	      <td height="40px">结束时间:</td>
	      <td height="40px"><input class="easyui-datetimebox" type="text" id="endDate" name="endDate" style="width:150px" value="${end}"/></td>
	 <%--      <td height="40px">所属模块:</td>
	      <td height="40px">
	         <select name="logType" class="easyui-combobox" id="logType" style="width: 150px;">
		       <rmp:option dictId="sys.operationLog.logType" prompt="  "></rmp:option>
	         </select>
	         <input id="logType" class="easyui-combobox" name="logType" />  
	         
	      </td> --%>
	      <td colspan="2">
	         <input class="inputd" type="button" value="查  询" onclick="query()"/>
	         <input class="inputd" type="button" value="重  置" onclick="resetCondition()"/>
	      </td>
	    </tr>
	</table>
	</FORM>
	<div class="clear"></div>
</div>
<div class="gridDiv">
   <table id="operationLogGrid" ></table>
</div>
</body>
</html>