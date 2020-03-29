<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>公告信息</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/common.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/prettify.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all_new.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/form-util.js"></script>
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
.tabs-panels{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
	border: none;
}
</style>
<script type="text/javascript">
$(function () {
    var attachment= ${attachment};
    var tbody="";
    if(attachment!=null&&attachment!=""){
    $.each(attachment,function(n,value) { 
          var trs = "";
          trs += "<tr id=\""+n+"\"> <td width='60%'>" +value.sfilename+"</td> <td width='20%'><a href='#' onclick = 'javascript:uploadfile(\""+ value.attachId +"\")'><span style='color:red'>下载</span></a></td></tr>";
          tbody += trs;
        });
      $("#attachment").append(tbody);
    }
  
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
}
</script>
</head>
<body class="easyui-layout">
	<div region="center" border="false" style="background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;">
	<form name="formSave" id="formSave" method="post">
		<div id="myTab1_Content0" class="form_style">
			<table cellSpacing="0" cellpadding="0" border="0" width="100%" height="100%">
				<tr>
					<td height="32px" width="120px;" class="searchTitle">公告标题：</td>
					<td height="32px">
						<div>
						<h3>
						<c:out value="${message.messTitle}"/>
						</h3>
						</div>
					</td>
				</tr>
				<tr>
					<td height="32px" width="120px;" class="searchTitle" style="vertical-align: text-top; line-height: 33px;">公告内容：</td>
					<td height="150px" style="padding: 0; padding-right: 2px;vertical-align: text-top;">
						<div style="text-indent:24px;line-height: 20px; padding: 0 5px; height: 150px;overflow: auto;">
							<div style=""><c:out value="${message.messContent}"/></div>
						</div>
					</td>
				</tr>	
						
				<%
				if(request.getAttribute("attachment")!=null&&request.getAttribute("attachment")!=""){
				%>
			  <tr>
					<td height="32px" width="120px;" class="searchTitle" style="vertical-align: text-top; line-height: 33px;">附   件：</td>
					<td height="200px" style="padding: 0; padding-right: 2px;vertical-align: text-top;">
					<div style="text-indent:24px;line-height: 20px; padding: 0 5px; height: 200px;overflow: auto;">
	                <table id="attachment"></table>
                    </div>
					</td>
			</tr>
			  <%} %>
			</table>
		</div>
	</form>
	</div>
</body>
</html>
﻿
