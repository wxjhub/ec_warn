<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>list</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
</head>
<body>
<script type="text/javascript">
</script>

<div style="padding:30px 30px 0 30px;">
	<div class="table_tt" style="margin-top: 0px;"  ><font class="blue" id="atta"><c:out value="${empty message.messId ? '新增' : '编辑'}附件"/></font></div>
	<form name="formSave" id="formSave" method="post" style="padding: 25px 25px 0 25px;height: 315px;overflow-y: scroll;position:relative;" enctype="multipart/form-data" >
				<div id="myTab1_Content0">
					<table cellSpacing="0" cellpadding="0" border="0">		
		              <tr>
							<td width="80px" height="32px" >附件上传：</td>
							<td width="200px" height="32px" colspan="3">
							<input type="hidden" name="attachids" id="attachids" /><!-- 存放附件的ID -->
							<input type="hidden" name="functype" id="functype" value="1" /> <!-- 区分不同功能的类型 -->
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
							<td width="200px" height="32px" colspan="3" >
						    <b>	1、上传的附件大小${sizelimit}以内;<br>
							
							2、可允许上传的附件类型包括${filetype}。</b>
							</td>
						</tr>
</table>
</div>
</form>

			
</div>

</body>
</html>