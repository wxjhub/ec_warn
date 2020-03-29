<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>公告管理</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<style type="text/css">
#formSearch .panel-body{
	border-bottom-style: none;
}
</style>
<script type="text/javascript">
function getJsonQueryCondition(){
	return {
		status: $("#status").combobox("getValue"),
		messTitle: $("#messTitle").val(),
		pubDate: $("#pubDate").datebox("getValue")
	};
}
$(function(){
	var height = $('.gridDiv').parent().parent()[0].clientHeight - $("#formSearch").height() - 74;
	//网格最小高度
	height = height < 300 ? 300 : height;
	$('.gridDiv').height(height);
	$('#message').datagrid({
		title:'公告管理',
		iconCls:'icon-computer',
		width:'100%',
		fit: true,
		nowrap: false,
		striped: true,
		collapsible:false,
		url:'${pageContext.request.contextPath}/message_list.action',
		queryParams:getJsonQueryCondition(),
		idField:'messId',
		fitColumns:true,
		scroll:true,
		pagination:true,
		columns:[[
			{field:'messId', checkbox:true, width:20},
			{field:'messTitle',title:'标题', width:150},
			{field:'messType',title:'类型', width:150},
			{field:'startDate',title:'开始时间', width:150},
			{field:'endDate',title:'结束时间', width:150},
			{field:'pubDate',title:'发布时间', width:150},
			{field:'realName',title:'发布人', width:150},
			{field:'status',title:'状态', align:'center',width:150,
				formatter:function(value){
					if(value == '1') {
		       			return "启用";
		       		} else if(value == '0'){
			       		return "<font color='red'>撤销</font>";
			       	}
	    		}
	    	}
		]],
		toolbar:[
			{
				id:'btnadd',
				text:'添加',
				iconCls:'icon-add',
				handler:function(){
					$("#formSearch")[0].action = "${pageContext.request.contextPath}/message_toForm.action";
					$("#formSearch")[0].submit();
				}
			},{
				id:'btnedit',
				text:'编辑',
				iconCls:'icon-edit',
				handler:function(){
					var selected = $('#message').datagrid('getSelections');
					if(selected.length == 0) {
						$.messager.alert('系统提示','请选择要修改的公告!','warning');
						return;
					}
					if(selected.length >1) {
						$.messager.alert('系统提示','当前选择公告大于一个，请选择一个公告进行修改','warning');
						return;
					} else {
						$("#formSearch")[0].action = "${pageContext.request.contextPath}/message_toForm.action?messId=" + selected[0].messId;
						$("#formSearch")[0].submit();
					}
				}
			},{
				id:'btnuse',
				text:'启用',
				iconCls:'icon-use',
				handler:function(){
					var selected = $('#message').datagrid('getSelections');
					if(selected.length == 0) {
						$.messager.alert('系统提示','请选择需启用的公告！','warning');
						return false;
					}
					var str = "";
					for(var i=0; i<selected.length; i++) {
						if(selected[i].status=='1') {
							$.messager.alert('系统提示','公告:['+selected[i].messTitle+']已启用！','warning');
							return false;
						}
						str += "messId=" + selected[i].messId + "&";
					}
					str += "status=1";
					$.messager.confirm('系统提示','确定要启用吗?', function(ok){
						if(!ok) return false;
						$.ajax({    
							  url: "message_updateStatus.action",
							  type: "POST",
							  data: str,
							  success: function(data){  	
									if(data.message!=null){
										var msg = eval("(" + data.message + ")");
										if(msg) 
											$.messager.alert('系统提示', msg.errorMsg, 'warning');
									} else {
										$('#message').datagrid("clearSelections");
										$('#message').datagrid("load");
									} 
							  }    
						});
					});
				}
			},{
				id:'btncel',
				text:'撤销',
				iconCls:'icon-remove',
				handler:function(){
					var selected = $('#message').datagrid('getSelections');
					if(selected.length == 0) {
						$.messager.alert('系统提示','请选择需撤销的公告！','warning');
						return false;
					}
					var str = "";
					for(var i=0; i<selected.length; i++) {
						if(selected[i].status=='0') {
							$.messager.alert('系统提示','公告:['+selected[i].messTitle+']已撤销！','warning');
							return false;
						}
						str += "messId=" + selected[i].messId + "&";
					}
					str += "status=0";
					$.messager.confirm('系统提示','确定要撤销吗?', function(ok){
						if(!ok) return false;
						$.ajax({    
							  url: "message_updateStatus.action",
							  type: "POST",
							  data: str,
							  success: function(data){  	
									if(data.message!=null){
										var msg = eval("(" + data.message + ")");
										if(msg) 
											$.messager.alert('系统提示', msg.errorMsg, 'warning');
									} else {
										$('#message').datagrid("clearSelections");
										$('#message').datagrid("load");
									} 
							  }    
						});
					});
				}
			},{
				id:'btndel',
				text:'删除',
				iconCls:'icon-remove',
				handler:function(){
					var selected = $('#message').datagrid('getSelections');
					if(selected.length == 0) {
						$.messager.alert('系统提示','请选择需删除的公告！','warning');
						return false;
					}
					var str = "";
					for(var i=0; i<selected.length; i++) {
						str += "messId=" + selected[i].messId + "&";
					}
					$.messager.confirm('系统提示','确定要删除吗?', function(ok){
						if(!ok) return false;
						$.ajax({    
							  url: "message_removeMessage.action",
							  type: "POST",
							  data: str,
							  success: function(data){  	
									if(data.message!=null){
										var msg = eval("(" + data.message + ")");
										if(msg) 
											$.messager.alert('系统提示', msg.errorMsg, 'warning');
									} else {
										$('#message').datagrid("clearSelections");
										$('#message').datagrid("load");
									} 
							  }    
						});
					});
				}
			}
		]
	});

	$('#status').combobox({
		panelHeight:'100%'
	});

	//查询提交
	$('#filter_submit').click(function(){
		$('#message').datagrid("clearSelections");
		$('#message').datagrid('load', getJsonQueryCondition());
	});
	
	//重置查询信息
	$('#filter_reset').click(function(){
		$("#status").combobox("clear");
		$("#messTitle").val("");
		$("#pubDate").datebox("clear");
		$('#message').datagrid('options').queryParams="";
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
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
			<table cellSpacing="0" cellpadding="0" border="0" >
				<tr>
					<td height="60px">标题：</td>
					<td height="40px">
						<input type="text" id="messTitle" name="messTitle" value="${param.messTitle}" class="input_eq">
					</td>
					<td height="60px">发布时间：</td>
					<td height="40px">
						<input type="text" id="pubDate" style="width: 150px" name="pubDate" value="${param.pubDate}" class="easyui-datebox">
					</td>
					<td height="60px">状态：</td>
					<td height="40px">
						<select name="status" style="width: 150px" class="easyui-combobox" id="status">
							<rmp:option dictId="sys.status" currentValue="${param.status}" prompt=""></rmp:option>
						</select>
					</td>
					<td>
						<input id="filter_submit" class="inputd" type="button" value="查 询"/>
						<input id="filter_reset" class="inputd" type="button" value="重 置"/>
					</td>
				</tr>
			</table>
	</form>
<div class="gridDiv" style="height: 300px">
	<table id="message"></table>
</div>
</body>
</html>

