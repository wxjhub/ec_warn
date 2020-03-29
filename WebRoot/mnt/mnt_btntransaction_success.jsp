<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="/WEB-INF/tld/rmp.tld"  prefix="rmp" %>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>按钮交易成功率展示</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
.input_file{width:140px; margin-left:-140px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>

<script type="text/javascript">
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
});


function courseStatustype(value, rowData, rowIndex){
	if(value>0){
		return '<span style="color:red">'+value+'</span>';
	}
	if(value==0){
		return value;
	}
}
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
                <td height="40px">按钮名称：<input id="btnName" type="text"></td>
				<td height="40px">采集日期:</td>
				<td height="40px">
				<input class="easyui-datebox" id="recordDate" name="recordDate" style="width: 150px; padding: 0px" /></td>
			</tr>
			<tr>
				<td colspan="6">
				<input id="filter_submit" class="inputd" type="button" value="查询"
					onclick="submi()" />
				<input id="filter_reset" class="inputd" type="reset"
					onclick="rese()" value="重 置" />
				</td>
			</tr>
		</table>
	</form>
	
	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" 
		rownumbers="false" singleSelect="false" editable="true" url="btnTranStranSucss_findBtnTranStranSucssList.action" 
		striped="true" fit="true" height="50%"  title="成功率展示" id="lrmsMoni">
		<r:toolbar id="editRow" text="查看实时成功率" iconCls="icon-edit" onClick="findService();"></r:toolbar>  
			<r:col  field="btnName" title="按钮名称" editable="false" sortable="true" width="150">
			</r:col>
			<r:col  field="btnPath" title="方法路径" editable="false" sortable="true" width="150">
			</r:col>
			<r:col  field="localSystem" title="所属系统" editable="false" sortable="true" width="100" >
			</r:col>
			<r:col  field="rate" title="按钮成功率(%)" sortable="true" width="150" editable="false">
			</r:col>
			<r:col  field="succCount" title="成功条数" sortable="true" width="150" editable="false">
			</r:col>
			<r:col  field="allCount" title="总条数" sortable="true" width="150" editable="false">
			</r:col>
			<%-- <r:col  field="recordDate" title="采集日期" sortable="true" width="150" editable="false" dateFormat="yyyy-MM-dd">
			</r:col> --%>
			<r:col  field="recordDate" title="采集日期" sortable="true" width="150" editable="false" dateFormat="yyyy-MM-dd" hasTime="true">
			</r:col>
		<r:pagination id="pag"></r:pagination>
	</r:grid>
	</div>
</body>
<script>
function findService(){
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在手动检测";
	obj.text;
	obj.interval = 400; 
	messager.progress(obj);
	$.ajax({
		type: 'post',
		dataType : "Json",
		url: "${pageContext.request.contextPath}/btnTranStranSucss_btnTranStranSucss.action",
		success:function(data){
			messager.close();
			$.messager.alert('系统提示','手动检测完成！','warning');
			lrmsMoni.reload();	 
		}
	});
}

//重置查询信息
function rese(){
	$('#sourseSys').combobox('setValue','');
	$('#recordDate').datebox('setValue','');
}

function submi(){
	var jsonData = {
			btnName: $('#btnName').val(),
			recordDate: $('#recordDate').datebox('getValue'),
			newpage:1,page:1
			};
	lrmsMoni.load(jsonData);
}
</script>
</html>

