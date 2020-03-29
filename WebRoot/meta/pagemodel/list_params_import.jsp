﻿<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<html>
	<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<title>参数导入</title>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/css_new.css"/>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
	</head>
	<body>
		<div style="background: url(/vpf/images/form_bg.png) right bottom repeat-x;">
		<form name="xform" id="xform" action="${pageContext.request.contextPath}/metaxml_changeImport.action?modelName=${modelName}" 
					method="post" enctype="multipart/form-data" target="commitArea">
			<table border="0" cellpadding="1" cellspacing="1" width="100%">
				<tbody>
					<tr style="height: 30px;">
						<td width="32%" align="right">导入方式
							<font color="red">*</font>
						</td>
						<td style="width: 10px;"></td>
						<td>
							<select name="importMode" id="importMode" class="easyui-combobox" style="width: 170px;">
							  <option value="">请选择</option>
							  <option value="1">删除已有数据，全量导入</option>
							  <option value="2">保留已有数据，追加新数据</option>
						   </select> 
						   <span id="importModeMsg" style="color: red;font-size:12px;"></span>
						</td>
					</tr>
					
					<tr style="height: 30px;">
						<td align="right">选择导入文件<font color="red">*</font></td>
						<td style="width: 10px;"></td>
						<td>
							<input type="text" class="input_eq" id="importFile" style="font-size: 12px;width: 170px;" readonly/>
							<input type="button" class="inputd" value="选择文件"/>
							<input type="file" name="file" onchange="$('#importFile').val($(this).val())" 
								style="width:66px;height:20px;margin-left:-70px;margin-top:2px;filter:alpha(opacity=0);opacity:0;"/>
							<span id="fileMsg" style="color: red;font-size:12px;"></span>
						</td>
					</tr>
					<tr style="height: 30px;">
						<td colspan="3" align="center">
							<input type="button" value="导入 " class="zh_btnbg2" id="importbt">
							<input type="button" value="关闭" class="zh_btnbg2" id="closebt"> 
						</td>
					</tr>
				</tbody>
			</table>
		</form>
		<div id="promptArea" align="center" style="background: url('${pageContext.request.contextPath}/images/error.jpg') no-repeat center 0%;height:252px;">
			<div class="text" style="padding-top:90px; width:290px; word-wrap:break-word" >
				<font style="font-size:12px;">
				请检查导入文件:<br />
				1、文件类型是否为xls<br />
				2、文件数据是否完整<br />
				3、文件数据是否冲突<br />
				4、Excel模板格式未做修改<br />
				建议导出原数据备份后再导入，以免导入过程中破坏原数据.
				</font>
			</div>
		</div>
		<iframe name="commitArea" id="commitArea"  style="display:none" 
					src="${pageContext.request.contextPath}/meta/pagemodel/importResult.jsp"  
					width="100%" align="center" height="252" frameborder="no" border="0″ marginwidth="0" 
					allowtransparency="true" marginheight="0" scrolling="no">
		</iframe>
		</div>
	</body>
</html>