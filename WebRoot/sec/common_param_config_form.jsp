<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setDateHeader("Expires", 0); //防止代理服务器缓存页面
	String organStr=request.getParameter("organStr");
%>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>创建系统参数</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/prettify.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/form-util.js"></script>
<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
#formSave{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	border:1px solid #c0c0c0;
	border-top-style:none;
	background:#fff url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
}
.combo{
	display:inline-block;
	white-space:nowrap;
	font-size:12px;
	margin:0;
	padding:0;
	border-radius:5px;
	-moz-border-radius:5px;
	border:1px solid #d8d8d8;
	background:#fff;
}
.combo-text{
	font-size:12px;
	border:0px;
	line-height:20px;
	height:20px;
	padding:0px;
	*height:18px;
	*line-height:18px;
	_height:18px;
	_line-height:18px;
	/*background:url(${pageContext.request.contextPath}/images/select_bg.png) repeat-x;*/
	border-radius:5px;
	-moz-border-radius:5px;
	-webkit-border-radius: 5px;
	border-top-right-radius:0px;
	-moz-border-radius-topright:0px;
	-webkit-border-bottom-right-radius:0px;
	border-bottom-right-radius:0px;
	-moz-border-radius-bottomright:0px;
	-webkit-border-bottom-right-radius:0px;
}
</style>
<script type="text/javascript">
$(function(){
	$('#status').combobox({
		data:[
		      {value:'1',text:'启用'},
		      {value:'0',text:'撤销'}
		      ],
		panelHeight:'100%'
	});
	
	if($('#status').combobox("getValue") == ""){
		$('#status').combobox("setValue", "1");
	};
});

function saveMessage(){
	if(!$("#formSave").form('validate')){
		return ;
	}
	$('#formSave').form('submit', {
		url:"paramconfig_saveParam.action",
		success:function(data){
			if(data="ok") {
				if($("#uuid").val()==""){
					$.messager.alert('系统提示','添加成功','warning');
				}else{
					$.messager.alert('系统提示','修改成功','warning');
				}
				window.location.href = "${pageContext.request.contextPath}/sec/common_param_config_list.jsp";
			}
		}
	});
};

function goBack(){
	window.location.href = "${pageContext.request.contextPath}/sec/common_param_config_list.jsp";
}
$(function(){
    //表格自适应屏幕高度
    var heightValue = $(document).height() - 95;
    if (heightValue > 350)
        $("#tt").tabs({height: heightValue});
});
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

	$("#" + formId + " textarea").val("");
}
</script>
<style type="text/css">
	.tree-node-hover{
		background:#D0E5F5;
	}
	.tree-node{
		height:20px;
		white-space:nowrap;
		cursor:pointer;
	}
</style>
</head>
<body>
<div class="table_b1 mar_30">
	<div class="table_tt" style="margin-top: 0px;"><font class="blue" id="msg"><c:out value="${empty paramconfig.uuid ? '新增' : '编辑'}系统参数"/></font></div>
			<form name="formSave" id="formSave" method="post" style="padding: 25px 25px 0 25px;height: 315px">
				<input type="hidden" id="uuid" name="uuid" value="${paramconfig.uuid}"></input>
				<div id="myTab1_Content0">
					<table cellSpacing="0" cellpadding="0" border="0">
						<tr>
							<td width="80px" height="32px" class="searchTitle">参数名称：</td>
							<td height="32px" width="260px" colspan="3">
								<input type="text" id="paramId" name="paramId" value="${paramconfig.paramId}" class="input_eq2 easyui-validatebox" style="width: 260px;" required="true" validType="length[1,100]">
								<span style="color: red;font-size: 15px;"> *</span>
							</td>						
						</tr>
						<tr>
							<td width="80px" height="32px" class="searchTitle">参数值：</td>
							<td width="420px" height="32px" colspan="3" style="padding:5px;padding-left:0px;">
							    <input type="text" id="paramValue" name="paramValue" value="${paramconfig.paramValue}" class="input_eq2 easyui-validatebox" style="width: 400px;" required="true" validType="length[1,200]">								
							    <span style="color: red;font-size: 15px;"> *</span>
							</td>
						</tr>
					    <tr>
							<td width="80px" height="32px" class="searchTitle">状态：</td>
							<td width="40px" height="32px" colspan="3">
								<input name="status" style="width: 150px" class="easyui-combobox" id="status" value="${paramconfig.status}" >
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
						</tr>
						<tr>
							<td width="80px" height="32px" class="searchTitle" style="vertical-align: text-top; line-height: 33px;">备注：</td>
							<td width="40px" height="32px" colspan="3" style="padding:5px;padding-left:0px;">
								<textarea class="input_eq2 easyui-validatebox" name="paramDesc" style="height: 40px; width: 400px;"  validType="length[1,250]"><c:out value="${paramconfig.paramDesc}"/></textarea>								
							</td>
						</tr>
						<tr>
							<td colspan="4" height="50" style="color: red">提示：带（*）为必填项</td>
						</tr>
					</table>
				</div>
			</form>
			<div class="tool_btn">
				<div style="float: right;">
					<input class="zh_btnbg2" type="submit" id="submit" value="保存" onclick="saveMessage();"/>
					<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" />
				</div>
			</div>
</div>
</body>
</html>
﻿
