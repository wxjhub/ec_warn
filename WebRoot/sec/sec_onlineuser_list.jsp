<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>在线登录用户</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all_new.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<style type="text/css">
#formSearch .panel-body{
	border-bottom-style: none;
}
</style>
<script type="text/javascript">
function getJsonQueryCondition(){
	return {
		username: $("#username").val()
	};
}
$(function(){
	var height = $('.gridDiv').parent().parent()[0].clientHeight - $("#formSearch").height() - 74;
	//网格最小高度
	height = height < 300 ? 300 : height;
	$('.gridDiv').height(height);
	$('#onLineUser').datagrid({
		title:'在线登录用户',
		iconCls:'icon-computer',
		width:'100%',
		fit: true,
		nowrap: false,
		striped: true,
		url:'${pageContext.request.contextPath}/onLineUser_list.action',
		//queryParams:getJsonQueryCondition(),
		idField:'id',
		//fitColumns:true,
		scroll:true,
		columns:[[
			{field:'id', checkbox:true, width:20},
			{field:'username',title:'用户名', width:150},
			{field:'realname',title:'姓名',width:150},
			{field:'userIp',title:'IP地址', width:150},
			{field:'createTime',title:'登录时间', width:150},
			{field:'sessionstatus',title:'session状态', width:100,
				formatter:function(value){
	       			if(value == '0') {
		       			return "正常";
		       		} else if(value == '1'){
			       		return "异常";
			       	}
	       			return null;
	    		},
	    		styler:function(value){
					if (value == '1'){
						return 'color:red;';
					}
				}
			}
		]],
		toolbar:[
			{
				id:'btndel',
				text:'强制签退',
				iconCls:'icon-remove',
				handler:function(){
					var selected = $('#onLineUser').datagrid('getSelections');
					if(selected.length == 0) {
						$.messager.alert('系统提示','请选择要强制签退的用户！','warning');
						return false;
					}
					var str = "";
					for(var i=0; i<selected.length; i++) {
						str += "id=" + selected[i].id + "&";
					}
					$.messager.confirm('系统提示','确定要强制签退吗?', function(ok){
						if(!ok) return false;
						$.ajax({
							  url: "${pageContext.request.contextPath}/onLineUser_kickOnLineUser.action",
							  type: "POST",
							  data: str,
							  success: function(data){  	
									 if(data.message != null){
										var msg = eval("(" + data.message + ")");
										if(msg) 
											$.messager.alert('系统提示', msg.errorMsg, 'warning');
									} else { 
										$('#onLineUser').datagrid("clearSelections");
										$('#onLineUser').datagrid("load");
									}  
							  }    
						});
					});
				}
			}
		]
	});

	//查询提交
	$('#filter_submit').click(function(){
		$('#onLineUser').datagrid("clearSelections");
		$('#onLineUser').datagrid('reload', getJsonQueryCondition());
	});
	
	//重置查询信息
	$('#filter_reset').click(function(){
		$("#username").val("");
		$('#onLineUser').datagrid('options').queryParams="";
	});
});
</script>
<style type="text/css">
.input_file{width:150px; margin-left:-150px;height:21px; filter:alpha(opacity=0); opacity:0;position: absolute;z-index: 10000;margin-top: 10px;}
.input_file2{width:105px; margin-left:-105px;height:21px; filter:alpha(opacity=0); opacity:0;position: absolute;z-index: 10000;margin-top: 10px;}
.save_btn{border:0px; width:56px;height:21px;background:url(../images/save_btn.jpg);
	font-family:'Microsoft YaHei';
	font-size:12px;
	padding-left:10px;
	padding-top:0px;
}
.save_btn:hover{border:0px; width:56px;height:21px;background:url(../images/save_btn_hover.jpg)}
</style>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post"  style="padding: 20px 0 20px 30px;">
			<table cellSpacing="0" cellpadding="0" border="0">
				<tr>
					<td height="40px">柜员号：</td>
					<td height="40px">
						<input type="text" id="username" name="username" class="input_eq">
					</td>
					<td>
						<input id="filter_submit" class="inputd" type="button" value="查 询"/>
						<input id="filter_reset" class="inputd" type="button" value="重 置"/>
					</td>
				</tr>
			</table>
	</form>
<div class="gridDiv" style="height: 300px">
	<table id="onLineUser"></table>
</div>
</body>
</html>

