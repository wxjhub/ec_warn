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
<title>交易成功率监控</title>
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
//导出模板
function getTemplate(){
	window.location.href="${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"CodeMap";
}
//导出数据
function getTaskByData(){
	window.location.href="${pageContext.request.contextPath}/exportExcelALM.action?modelName="+"CodeMap";
}
//导入数据
function inExcel(){
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在导入请稍后";
	obj.text;
	obj.interval = 400; 
								
	var updateUpdata = $('#upload').val();
	if(updateUpdata!=null&&updateUpdata!=""){
		messager.progress(obj);
		$.ajaxFileUpload({  
			url: "alminputExcel_inputExcelCodeMap.action?modelName="+"CodeMap",
			secureuri:false,  
			fileElementId: 'upload',//文件选择框的id属性  
			dataType:'json',//服务器返回的格式，可以是json  
			error: function(request) {      // 设置表单提交出错
				messager.close(); 
				$.messager.alert('系统提示','导入失败！！','warning');
			},
			success: function(data) { // 设置表单提交完成使用方法
				var zNodes = eval(data); 
				if(zNodes.length>0){
					var errorInfo ="";
					for(var i=0;i<zNodes.length;i++){
						errorInfo+=zNodes[i]+"\r\r";
					}
					messager.close();  
					$.messager.alert('系统提示',errorInfo,'warning');   
					lrmsMoni.reload(); 
				} else{
					messager.close();  
					$.messager.alert('系统提示','导入成功！','warning');
					lrmsMoni.reload();
				}							            	                 
			}
		});
	}else{
		$.messager.alert('系统提示','请选择导入文件！！！','warning');
	}
								        
}	


</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
<%-- 		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<INPUT name="pageNo1" id="pageNo1"type="hidden" value="${param.success}"> 
		<INPUT name="pageNo2" id="pageNo2"type="hidden" value="${param.lrmsdate}">  --%>
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
			<td height="40px">交易名称：<input id="transactionName" type="text"></td>
				<%-- <td height="40px">系统：</td>
				<td height="40px">
					<select name="sourseSys" class="easyui-combobox" id="sourseSys" style="width: 150px">
						<rmp:option dictId="sourseSys" currentValue="${param.sourseSys}"
							prompt="">
						</rmp:option>
					</select></td> --%>

				<td height="40px">数据日期:</td>
				<td height="40px">
				
				<input class="easyui-datebox" id="dataDate"
					name="dataDate" style="width: 150px; padding: 0px" /></td>
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
		rownumbers="false" singleSelect="false" editable="true" url="transactionSuccess_findTransactionSuccessList.action" 
		striped="true" fit="true" height="50%"  title="全天交易成功率监控" id="lrmsMoni">
			<r:col  field="transactionName" title="交易名称" editable="false" sortable="true" width="150">
			</r:col>
			<r:col  field="code" title="响应码" editable="false" sortable="true" width="150">
			</r:col>
			<r:col  field="codeName" title="响应码名称" editable="false" sortable="true" width="150" >
			<r:editorText></r:editorText>
			</r:col>
			<r:col  field="sum" title="当天交易量" editable="false" sortable="true" width="150" >
			<r:editorText></r:editorText>
			</r:col>
			<r:col  field="ratio" title="比率" sortable="true" width="100" editable="false">
			<r:editorText></r:editorText>
			</r:col>
		<r:pagination id="pag"></r:pagination>
	</r:grid>
	</div>

			<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid2" 
		rownumbers="false" singleSelect="false" editable="true" url="transactionSuccess_findTransactionSuccessList2.action" 
		striped="true" fit="true" height="50%"  title="实时交易成功率监控" id="lrmsMoni2">
			<r:col  field="transactionName" title="交易名称" editable="false" sortable="true" width="150">
			</r:col>
			<r:col  field="code" title="响应码" editable="false" sortable="true" width="150">
			</r:col>
			<r:col  field="codeName" title="响应码名称" editable="false" sortable="true" width="150" >
			<r:editorText></r:editorText>
			</r:col>
			<r:col  field="sum" title="实时交易量" editable="false" sortable="true" width="150" >
			<r:editorText></r:editorText>
			</r:col>
			<r:col  field="ratio" title="比率" sortable="true" width="100" editable="false">
			<r:editorText></r:editorText>
			</r:col>
		<r:pagination id="pag"></r:pagination>
	</r:grid>
	</div> 
</body>
<script>

//重置查询信息
function rese(){
	//$("#courseName").val('');
	//$('#scriptType').val('');
	$('#transactionName').combobox('transactionName','');
	$('#dataDate').datebox('setValue','');
}

function submi(){
	var jsonData = {
			//transactionName: $('#transactionName').combobox('getValue'),
			transactionName:$('#transactionName').val(),
			dataDate: $('#dataDate').datebox('getValue'),
			newpage:1,page:1
			};
	lrmsMoni.load(jsonData);
	lrmsMoni2.load(jsonData);
}

	</script>
</html>

