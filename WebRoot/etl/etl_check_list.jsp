<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="refresh" content="20">
<title>服务器检测</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
.input_file{width:260px; margin-left:-260px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>
<script type="text/javascript">
//条件查询、分页查询
function searchUser(){
    var serverName = $('#serverName')[0].value;
    $('#etlCheck').datagrid('reload', {
    	serverName:serverName
 
	});    
 }


$(function(){
	$('#etlCheck').datagrid({
		title:'服务器检测',
		width:'100%',
		height:380,
		nowrap: false,
		striped: true,
		collapsible:false,
		url:'check_list.action',
		idField:'serverName',					//标识字段
		sortName: 'date',
		sortOrder: 'asc',
		remoteSort: false,
		fitColumns:true,
		scroll:true,
		columns:[[
			{field:'serverId',title:'服务器ID', width:180},
			{field:'serverName',title:'服务器名称', width:180},
			{field:'url',title:'服务器地址',width:240},
			{field:'isActivity',title:'连接状态',width:180,
				formatter:function(value) {
					//alert(value);
    			if(value) {
    				
    				return '<span style="color:green">已连接</span>';
    			}else{
    				return '<span style="color:red">断开</span>';
        			}
			}
				},
			{field:'date',title:'上次检测时间',width:180,
				formatter:function(value) {
				return formatDate(value);
			}
			}
		]],
		pagination:true,
		rownumbers:false,
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		}
	});
	var p = $('#etlCheck').datagrid('getPager');
	$(p).pagination({
		onBeforeRefresh:function(){
			//alert('before refresh');
		}
	});

	//查询提交
	$('#filter_submit').click(function(){
		var jsonData = {
				serverName:$('#serverName').val(),
				newpage:1
				};
		$('#etlCheck').datagrid('options').queryParams=jsonData;
		$('#etlCheck').datagrid('load');
	});

	//重置查询信息
	$('#filter_reset').click(function(){
		$('#serverName').val('');
		$('#etlCheck').datagrid('options').queryParams="";
	});

	var pager = $('#etlCheck').datagrid('getPager');
	$(pager).pagination({
		pageSize:10,
		pageList:[5,10,15],
		beforePageText:"第",
		afterPageText:"页  共{pages}页",
		displayMsg:"当前显示 {from} - {to} 条记录   共 {total} 条记录"
	});

	$('select').combobox({
		panelHeight:'100%'
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
	return y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;
}
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">服务器名称：</td>
				<td height="40px">
					<input type="text" name="serverName" id="serverName" class="input_eq" style="width:100px"/>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	<div class="gridDiv">
		<table id="etlCheck" name="etlCheck"></table>
	</div>

</body>
</html>

