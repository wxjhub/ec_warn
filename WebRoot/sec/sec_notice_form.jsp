<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>创建通知</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
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
		panelHeight:'100%'
	});
});

function saveMessage(){
	if(!$("#formSave").form('validate')){
		return ;
	}
	$('#formSave').form('submit', {
		url:"notice_saveNotice.action",
		success:function(data){
			if(data="ok") {
				if($("#noticeId").val()==""){
					$.messager.alert('系统提示','添加成功','warning');
				}else{
					$.messager.alert('系统提示','修改成功','warning');
				}
				window.location.href = "${pageContext.request.contextPath}/sec/sec_notice_list.jsp";
			}
		}
	});
};

function goBack(){
	window.location.href = "${pageContext.request.contextPath}/sec/sec_notice_list.jsp";
}
$(function(){
    //表格自适应屏幕高度
    $(function(){
    	var heightValue = $(document).height() - 150;
    	if (heightValue > 300)
    	    $("#formSave").height(heightValue);
    });
});

function selectOrgan(){
	showModalCenter ("${pageContext.request.contextPath}/sec/tree/sec_organ_tree.jsp?enable=true&url=notice_loadNoticeOrganTree.action?noticeId=${notice.noticeId}", function(data){
			var organIdArr = "";
			var organNameArr = "";
			for(var i = 0, len = data.length; i < len; i++){
				organIdArr += data[i].id;
				organNameArr += data[i].name;
				if(i < len - 1) {
					organIdArr += ",";
					organNameArr += ",";
				}
			}
			$("#organId").val(organIdArr);
			$("#organName").val(organNameArr);
		}, "400", "88%", "机构树");
}
</script>
</head>
<body>
<div style="padding:30px 30px 0 30px;">
<div class="table_tt" style="margin-top: 0px;"><font class="blue" id="msg"><c:out value="${empty notice.noticeId ? '新增' : '编辑'}通知"/></font></div>
	<form name="formSave" id="formSave" method="post"  style="padding: 25px 25px 0 25px;height:315px">
		<input type="hidden" id="noticeId" name="noticeId" value="${notice.noticeId}"></input>
		<div id="myTab1_Content0">
			<table cellSpacing="0" cellpadding="0" border="0">
				<tr>
					<td height="32px" width="80" class="searchTitle">通知标题：</td>
					<td height="32px" width="260">
						<input type="text" name="noticeTitle" value="${notice.noticeTitle}" class="input_eq2 easyui-validatebox" required="true" validType="length[1,40]">
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td height="32px" width="80" class="searchTitle">通知类型：</td>
					<td height="32px" width="260">
						<input type="text" name="noticeType" value="${notice.noticeType}" class="input_eq2 easyui-validatebox" validType="length[1,8]">
					</td>
				</tr>
				<tr>
					<td height="32px" width="80" class="searchTitle">开始时间：</td>
					<td height="32px" width="40">
						<input type="text" name="startDate" value="${notice.startDate}" class="easyui-datebox" style="width: 156px;">
					</td>
					<td height="32px" width="80" class="searchTitle">结束时间：</td>
					<td height="32px" width="40">
						<input type="text" name="endDate" value="${notice.endDate}" class="easyui-datebox" style="width: 156px;">
					</td>
				</tr>
				<tr>
					<td height="32px" width="80" class="searchTitle">所属机构：</td>
					<td height="32px" width="40">
						<input type="hidden" id="organId" value="${requestScope.organId}" name="organId" >
						<input type="text" id="organName" value="${requestScope.organName}" class="input_eq2">
						<input type="button" class="inputd" value="选择" onclick="selectOrgan();">
					</td>
					<td height="32px" width="80" class="searchTitle">状态：</td>
					<td height="32px" width="40" colspan="3">
						<select name="status" class="easyui-combobox" id="status" style="width: 156px">
							<rmp:option dictId="sys.status" currentValue="${notice.status}" prompt="" defaultValue="1"></rmp:option>
						</select>
					</td>
				</tr>
				<tr>
					<td height="32px" width="80" class="searchTitle" style="vertical-align: text-top; line-height: 33px;">通知内容：</td>
					<td height="32px" width="40" colspan="3" style="padding:5px;padding-left:0px;">
						<textarea class="input_eq2 easyui-validatebox" name="noticeContent" style="height: 120px; width: 400px;" required="true" validType="length[1,1900]"><c:out value="${notice.noticeContent}"/></textarea>
						<span style="color: red;font-size: 15px;"> *</span>
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
</div>
</body>
</html>
﻿
