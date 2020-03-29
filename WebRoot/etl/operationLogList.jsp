<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>操作日志</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js" charset="utf-8"></script>
<style type="text/css" >
		body {
			font-family: "微软雅黑";
			behavior:url(${pageContext.request.contextPath}/css/csshover.htc);
		}
</style>
<script type="text/javascript" charset="utf-8">
function query(){
	var logName=$('#logName').val();
	var userName=$('#userName').val();
	var userRealName=$('#userRealName').val();
	var startDate=$('#startDate').datetimebox('getValue');
	var endDate=$('#endDate').datetimebox('getValue');
	
	$('#operationLogGrid').datagrid('reload', {
		logName:logName,
		userName:userName,
		userRealName:userRealName,
		startDate:startDate,
		endDate:endDate,page:1
	});    
 } 
function clearFun(){
	//document.$("#formSearch").reset();
	//logName userName userRealName operateTime
	//startDate endDate
	$("#logName").val('');
	$("#userName").val('');
	$("#userRealName").val('');
	$('#startDate').datetimebox('setValue','');
	$('#endDate').datetimebox('setValue','');
 }
$(function(){
	var lastIndex;
	$('#operationLogGrid').datagrid({
		title:'操作日志列表',
		iconCls:'icon-computer',
		width:'100%',
		height:355,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'${pageContext.request.contextPath}/operationLog_findAllOperationLog.action',//请求数据的url
		pagination:true,
		pageSize:15,
		columns:[[
			{field:'logName', title:"日志名称", align:'center',sortable : true, width:120,editor:'text'},
			{field:'userName', title:"用户名", align:'center', sortable : true,width:140,editor:'text'},
			{field:'userRealName', title:"用户姓名", align:'center',sortable : true, width:140,editor:'text'},
			{field:'userOrgName', title:"用户机构", align:'center', sortable : true,width:150,editor:'text'},
			{field:'clientIp', title:"客户端IP地址", align:'center',sortable : true, width:218,editor:'text'},
			{field:'operateTime', title:"操作时间", align:'center',sortable : true, width:190,
				formatter:function(value){
	    			if(value != null) {
				  		return formatDate(value);
	    			}
			    }
			},
			{field:'url', title:"查看历史数据", align:'center',sortable : true, width:82,
				formatter:function(value){
				return value;    
			    }
			}
		]]
	});
	$(function(){
	   $('select').combobox({
	 		panelHeight:'100%'
	   });
    });
	var pager = $('#operationLogGrid').datagrid('getPager');
	$(pager).pagination({
		pageSize:10,
		pageList:[5,10,15],
		beforePageText:"第",
		afterPageText:"页  共{pages}页",
		displayMsg:"当前显示 {from} - {to} 条记录   共 {total} 条记录"
	});
});

//datebox format 方法
function formatDate(value) {
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
									return y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;
								}

</script>
</head>
<body>
<!--pageright begin-->
<div class="majorword" style="padding-left: 30px">
	<FORM name="formSearch" id="formSearch" method="post">
	<INPUT name="pageNo" type="hidden" value="${param.pageNo}"> 
	<table cellSpacing="0" cellpadding="0" border="0">
	    <tr>
	      <td height="40px" width="60px">日志名称:</td>
	      <td height="40px"><input class="input_eq" type="text" id="logName" name="logName" style="width:65px;height:20px"/></td>
	      <td height="40px" width="60px">用户名:</td>
	      <td height="40px"><input class="input_eq" type="text" id="userName" name="userName" style="width:65px;height:20px"/></td>
	      <td height="40px" width="60px">用户姓名:</td>
	      <td height="40px"><input class="input_eq" type="text" id="userRealName" name="userRealName" style="width:65px;height:20px"/></td>
	       <td height="40px" width="60px">起始时间:</td>
	      <td height="40px"><input class="easyui-datetimebox" id="startDate" name="startDate" style="width:130px;padding:0px"/></td>
	      <td height="40px" width="60px">结束时间:</td>
	      <td height="40px"><input class="easyui-datetimebox" type="text" id="endDate" name="endDate" style="width:130px"/></td>
	      
	      
	      <td>
	         <input class="inputd" type="button" value="查  询" onclick="query()"/>
	         <input class="inputd" type="button" value="重  置" onclick="clearFun()"/>
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