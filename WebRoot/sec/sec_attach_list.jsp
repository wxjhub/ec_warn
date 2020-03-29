<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>附件管理</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all_new.js"></script>
<style type="text/css">
#formSearch .panel-body{
	border-bottom-style: none;
}
</style>
<script type="text/javascript">

$(function(){
	var height = $('.gridDiv').parent().parent()[0].clientHeight - - 74;
	//网格最小高度
	height = height < 300 ? 300 : height;
	$('.gridDiv').height(height);
	$('#attach').datagrid({
		title:'附件管理',
		iconCls:'icon-computer',
		width:'100%',
		fit: true,
		nowrap: false,
		striped: true,
		collapsible:false,
		url:'${pageContext.request.contextPath}/attach_list.action',
		idField:'attachId',
		fitColumns:true,
		scroll:true,
		pagination:true,
		columns:[[
			{field:'attachId', checkbox:true, width:20},
			{field:'sfilename',title:'文件名称', width:100},
			{field:'filesize',title:'文件大小', width:150},
			{field:'dowload',title:'操作', align:'center',width:80,
				formatter:function(value,row,index)
			       {
					 return  "<a href='#' onclick = 'javascript:uploadfile(\""+ row.attachId +"\")'><span style='color:red'>下载</span></a>";
					   
			       }
	    	}
		]],
		toolbar:[
			{
				id:'btnadd',
				text:'添加',
				iconCls:'icon-add',
				handler:function(){
					$("#formSearch")[0].action = "${pageContext.request.contextPath}/attach_toForm.action?flag=1";
					$("#formSearch")[0].submit();
				}
			},{
				id:'btnedit',
				text:'编辑',
				iconCls:'icon-edit',
				handler:function(){
					var selected = $('#attach').datagrid('getSelections');
					if(selected.length == 0) {
						$.messager.alert('系统提示','请选择要修改的记录!','warning');
						return;
					}
					if(selected.length >1) {
						$.messager.alert('系统提示','当前选择记录大于一个，请选择一个记录进行修改','warning');
						return;
					} else {
						$("#formSearch")[0].action = "${pageContext.request.contextPath}/attach_toForm.action?flag=2&uuid=" + selected[0].uuid;
						$("#formSearch")[0].submit();
					}
				}
			}
		]
	});

});

//下载文件 
function uploadfile(uuid){    
  	$('#formSave').form('submit',{
		url:'attach_uploadAttach.action?uuid='+uuid,
		success:function(data){
		var result=data;
		hasException(result);
	} 
	}); 
	//window.location.href="${pageContext.request.contextPath}/attach_uploadAttach.action?uuid="+uuid;
}
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
	</form>
<form name="formSave" id="formSave" method="post" >
<div class="gridDiv" style="height: 300px">
	<table id="attach"></table>
</div>
</form>
</body>
</html>

