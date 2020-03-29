<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>创建公告</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/prettify.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/upload/uploadify.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/prettify.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/form-util.js"></script>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/jquery.uploadify-3.1.js" type="text/javascript"></script> 
<script src="${pageContext.request.contextPath}/sec/sec_attach.js" type="text/javascript"></script> 

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

SWFUpload.prototype.getFlashHTML = function () {
// Flash Satay object syntax: http://www.alistapart.com/articles/flashsatay
var obj = ['<object id="', this.movieName, '" type="application/x-shockwave-flash" data="', this.settings.flash_url, '" width="', this.settings.button_width, '" height="', this.settings.button_height, '" class="swfupload">'].join(""),
params = [
'<param name="wmode" value="', this.settings.button_window_mode, '" />',
'<param name="movie" value="', this.settings.flash_url, '" />',
'<param name="quality" value="high" />',
'<param name="menu" value="false" />',
'<param name="allowScriptAccess" value="always" />',
'<param name="flashvars" value="', this.getFlashVars(), '" />'
].join("");
if (navigator.userAgent.search(/MSIE/) > -1) {
obj = ['<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" id="', this.movieName, '" width="', this.settings.button_width, '" height="', this.settings.button_height, '" class="swfupload">'].join("");
params += '<param name="src" value="' + this.settings.flash_url + '" />';
}
return [obj, params, '</object>'].join("");
};


$(function(){
	$('#status').combobox({
		panelHeight:'100%'
	});
});

function saveMessage(){
	if(!$("#formSave").form('validate')){
		return ;
	}
	$('#formSave').form('submit', {
		url:"message_saveMessage.action",
		success:function(data){
			data=data.split(",")[0];
			hasException(data);
			if(data=="ok") {
				if($("#messId").val()==""){
					$.messager.alert('系统提示','添加成功','warning');
				}else{
					$.messager.alert('系统提示','修改成功','warning');
				}
				window.location.href = "${pageContext.request.contextPath}/sec/sec_message_list.jsp";
			}
		}
	});
};

function goBack(){
	window.location.href = "${pageContext.request.contextPath}/sec/sec_message_list.jsp";
}
$(function(){
    //表格自适应屏幕高度
	$(function(){
    	var heightValue = $(document).height() - 150;
    	if (heightValue > 300)
    	    $("#formSave").height(heightValue);
    });
});

function saveMessageOrgan(){
	var organs = organTree_.window.getSelectNodes();
	if (organs.length == 0) {
		$.messager.alert('系统提示','您还未选择机构!','warning');
	} else {
		var messageOrgan = "[";
		for(var i = 0, len = organs.length; i < len ; i++){
			messageOrgan += "{";
			messageOrgan += "'orgId': '" + organs[i].id + "'";
			messageOrgan += "}";
			if(i < len - 1)
				messageOrgan += ",";	
		}
		messageOrgan += "]";	
		
		$.ajax({
			 cache:false,
			 type: "post",
			 url: "message_saveMessageOrgan.action",
			 data: {"messageOrgan": messageOrgan, "messId": $("#messId").val()},
			 success:function(data){
				 $.messager.alert('系统提示','修改成功!','info');
			 }
		});
	}
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
<div style="padding:30px 30px 0 30px;">
	<div class="table_tt" style="margin-top: 0px;"  ><font class="blue" id="msg"><c:out value="${empty message.messId ? '新增' : '编辑'}公告"/></font></div>
			<form name="formSave" id="formSave" method="post" style="padding: 25px 25px 0 25px;height: 315px;overflow-y: scroll;position: relative;" enctype="multipart/form-data" >
				<input type="hidden" id="messId" name="messId" value="${message.messId}"></input>
				<div id="myTab1_Content0">
					<table cellSpacing="0" cellpadding="0" border="0">
						<tr>
							<td width="80px" height="32px" class="searchTitle">公告标题：</td>
							<td height="32px" width="260px">
								<input type="text" id="messTitle" name="messTitle" value="${message.messTitle}" class="input_eq2 easyui-validatebox" style="width: 156px;" required="true" validType="length[1,40]">
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
							<td width="80px" height="32px" class="searchTitle">公告类型：</td>
							<td width="260px" height="32px">
								<input type="text" id="messType" name="messType" value="${message.messType}" class="input_eq2 easyui-validatebox" validType="length[1,8]">
							</td>
						</tr>
						<tr>
							<td width="80px" height="32px" class="searchTitle">开始时间：</td>
							<td width="40px" height="32px">
								<input type="text" id="startDate" name="startDate" value="${message.startDate}" class="easyui-datebox" style="width: 156px;">
							</td>
							<td width="80px" height="32px" class="searchTitle">结束时间：</td>
							<td width="40px" height="32px">
								<input type="text" name="endDate" value="${message.endDate}" class="easyui-datebox" style="width: 156px;">
							</td>
						</tr>
						<tr>
							<td width="80px" height="32px" class="searchTitle">状态：</td>
							<td width="40px" height="32px" colspan="3">
								<select name="status" class="easyui-combobox" id="status">
									<rmp:option dictId="sys.status" currentValue="${message.status}" prompt="" defaultValue="1"></rmp:option>
								</select>
							</td>
						</tr>
						<tr>
							<td width="80px" height="32px" class="searchTitle" style="vertical-align: text-top; line-height: 33px;">公告内容：</td>
							<td width="40px" height="32px" colspan="3" style="padding:5px;padding-left:0px;">
								<textarea class="input_eq2 easyui-validatebox" name="messContent" style="height: 120px; width: 400px;" required="true" validType="length[1,1900]"><c:out value="${message.messContent}"/></textarea>
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
						</tr>
						
						<tr>
							<td width="80px" height="32px" class="searchTitle">附件上传：</td>
							<td width="300px" height="32px" colspan="3">
							<input type="hidden" name="attachids" id="attachids" /><!-- 存放附件的ID -->
							<input type="hidden" name="functype" id="functype" value="1" /> <!-- 区分不同功能的类型 公告管理为 1 -->
							<input type="hidden" name="sizelimit" id="sizelimit" value="${sizelimit}"/><!-- 允许上传文件的最大值 -->
							<input type="hidden" name="filetype" id="filetype" value="${filetype}"/><!-- 允许上传的文件类型 -->
							<input type="hidden" name="attachobj" id="attachobj" value='${attachobj}'  /><!-- 编辑页面附件数据 -->	
							<input type="file"  name="uploadfile"  id="uploadfile"  >
							<div id="fileQueue"  ></div>
							<div><table id="attach"></table></div>
							</td>
						</tr>
						
					    <tr>
							<td width="80px" height="32px" class="searchTitle">备注：</td>
							<td width="500px" height="32px" colspan="3" >
						    <b>	1、上传的附件大小${sizelimit}以内;<br>
							
							2、可允许上传的附件类型包括${filetype}。</b>
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
					<%-- <input type="button" class="zh_btnbg2" value="重置" onclick="resetForm('formSave');"/>--%>
					<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" />
				</div>
			</div>
		<%-- 
		<c:if test="${not empty message.messId}">
		<div title="所属机构" closable="false" style="overflow:hidden;">
			<div class="easyui-layout" fit="true">
				<div region="center" border="false" style="background:#fff;overflow:hidden">
					<iframe name="organTree_" scrolling="yes" frameborder="0" src="${pageContext.request.contextPath}/sec/tree/sec_organ_tree.jsp?displayButton=false&enable=true&url=message_loadMessageOrganTree.action?messId=${message.messId}" style="width:100%;height: 100%;background: none;"></iframe>
				</div>
				<div region="south" border="false">
					<div class="tool_btn2">
						<table style="float: left;"><tbody><tr><td>
							<input type="button" class="zh_btnbg2" value="保存" onclick="saveMessageOrgan();"/>
							<input type="button" class="zh_btnbg2" value="重置" onclick="organTree_.window.clearSelections();"/>
						</td></tr></tbody></table>
						<div style="float: right;">
							<input type="button" class="zh_btnbg2" onclick="goBack()" value="返回" />
						</div>
						<div style="clear:both;"></div>
					</div>
				</div>
			</div>
		</div>
		</c:if>
		--%>
</div>
</body>
</html>
﻿
