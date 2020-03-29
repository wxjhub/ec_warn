<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>元数据模型-主表信息</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script language="javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<script type="text/javascript">
//网格初始化
$(function() {
	$('#multiSql').combobox({
		url:"${pageContext.request.contextPath}/userTable_listAllUser.action",
		valueField:"id",
		textField:"text",
		panelWidth:180,
		panelHeight:350,
		onSelect:function(){
			searchRole();
		}
	});
	var heightValue = $(document).height() - 95;
	if(heightValue < 400)
		heightValue = 400;
	$('#userTableGrid').datagrid({
		title:'系统用户表',
		width:'100%',
		height:heightValue,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'${pageContext.request.contextPath}/userTable_listAllUserXmlJson.action',		//请求数据的url
		sortOrder:'desc',				//采用降序排序
		columns:[[
			{field:'tableName,multiSql', checkbox:true, width:20},
			{field:'tableName', title:"表名", width:300},
			{field:'comment', title:"表中文注释", align:'center', width:300},
			{field:'multiSql', title:'隶属用户', align:'center', width:200},
			{field:'deployFlag', title:'发布标识', align:'center', width:150}
		]],
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		},
		toolbar:[{							//工具栏
			id:'btnsend',
			text:'发布系统用户表',
			iconCls:'icon-add',
			handler:function(){			
				//var url="${pageContext.request.contextPath}/metadata/userTable_toGenMetaXml.action";
				//document.getElementById("formSearch").action = url;
				//document.getElementById("formSearch").submit();
				var selected = $('#userTableGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要发布的用户表！','warning');
					return;
				}
				
				var allTable = '';
				for(var i=0; i<selected.length-1; i++) {
					allTable +="tableName=" +  selected[i].tableName + '&';
				}
				allTable = allTable +  "tableName=" +  selected[selected.length-1].tableName;
				
				var user = $('#multiSql').combobox('getValue');
				window.location.href="${pageContext.request.contextPath}/userTable_toGenMetaXml.action?" + allTable+"&user="+user;	
				return false;
			}
		}]
	});
});

//条件查询、分页查询
function searchRole(){
    var tableName = $('#tableName').val();
    var multiSql = $('#multiSql').combobox('getValue');
	$('#userTableGrid').datagrid('reload', {
		tableName:tableName,
		user:multiSql
	}); 
}

function resetForm(){
	$("#tableName").val("");
	$('#multiSql').combobox('clear');
	searchRole();
}
</script>
</head>
<body>
<div class="mar_30 majorword">
<form name="formSearch" id="formSearch" method="post">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">表名：</td>
				<td height="40px">
					<input type="text" name="tableName" id="tableName" class="input_eq" style="width:120px"/>
				</td>
				<td height="40px">表用户：</td>
				<td height="40px">
					<select name="multiSql" id="multiSql" class="easyui-combotree" style="width:160px"></select>
				</td>
				<td>
					<input class="inputd" type="button" value="查 询" onclick="searchRole()" />
					<input class="inputd" type="button" value="重 置" onclick="resetForm()"/>
				</td>
			</tr>
		</table>
</form>
</div>
<div class="gridDiv">
	<table id="userTableGrid" ></table>
</div>
</body>
</html>