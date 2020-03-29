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
<title>sql阻塞监控</title>
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

function courseStatustype(value, rowData, rowIndex){
	if(value==0){
		return '<span style="color:red">'+"异常"+'</span>';
	}
	if(value==1){
		return "正常";
	}
}


function checkRefresh() {
	if (document.getElementById('chk_refresh').checked) {
			setTimeout('checkRefresh()', 5000);
			submi();
		} else {
			clearInterval(begin);
		}
	};

</script>

<!-- <script type="text/javascript">
function myrefresh(){
	
	window.location.reload();
}
setTimeout('myrefresh()',1000);

</script> -->
</head>
<body>
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<INPUT name="pageNo1" id="pageNo1"type="hidden" value="${param.success}"> 
		<INPUT name="pageNo2" id="pageNo2"type="hidden" value="${param.lrmsdate}"> 
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">用户名：<input id="username" type="text"></td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
				
				<td><input type="checkbox" id="chk_refresh"
					onclick="checkRefresh();" value="自动刷新" />自动刷新</td> 
			</tr>
		</table>
	</form>
		<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" 
		rownumbers="false" singleSelect="false" editable="true" url="sqlBlock_serviceServer.action" 
		striped="true" fit="true" height="100%"  title="sql阻塞监控" id="lrmsMoni">
			<%-- <r:toolbar id="addRowProcess" text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editParam();"></r:toolbar>
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
			<r:toolbar  text="删除" iconCls="icon-remove" onClick="remove();"></r:toolbar> --%>
			 <r:toolbar text="服务检测" iconCls="icon-remove" onClick="findService();"></r:toolbar> 
			
			<r:col  field="username" title="用户名" sortable="true" width="50" editable="false">
			</r:col>
			<r:col  field="sid" title="id" editable="false" sortable="true" width="50">
			</r:col>
			<r:col  field="event" title="事件" editable="false" sortable="true" width="200">
			</r:col>
			<r:col  field="sqlId" title="sqlId" editable="false" sortable="true" width="150">
			</r:col>
			<r:col  field="command" title="command" editable="false" sortable="true" width="70" >
			</r:col>
			<%-- <r:col  field="blockingInstance" title="blockingInstance" editable="false" sortable="true" width="150" >
			</r:col>
			<r:col  field="blockingSession" title="blockingSession" editable="false" sortable="true" width="150" >
			</r:col> --%>
			<r:col  field="lastCallEt" title="时间" editable="false" sortable="true" width="50" >
			</r:col>
			<r:col  field="status" title="活动状态" sortable="true" width="70" editable="false">
			</r:col>
			<r:col  field="waitClass" title="waitClass" sortable="true" width="80" editable="false">
			</r:col>
			
			
			<r:col field="collectDate" title="采集时间" sortable="true"
				width="130" hasTime="true" dateFormat="yyyy-MM-dd" editable="false">
			</r:col>
			<r:col  field="courseStatus" title="阻塞状态"  editable="false" sortable="true" width="100"  formatter="courseStatustype(value, rowData, rowIndex)" >
			</r:col>
			<r:col  field="warningLevl" title="预警级别" sortable="true"  width="100" dictId="ec.warnLvl" editable="false">
			<r:editorDictSelect missingMessage="预警级别不能为空" required="true"></r:editorDictSelect>
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
	obj.msg = "正在进行服务检测";
	obj.text;
	obj.interval = 400; 
	messager.progress(obj);
	$.ajax({
		type: 'post',
		dataType : "Json",
		url: "${pageContext.request.contextPath}/sqlBlock_serviceServer.action",
		success:function(data){
			messager.close();
			$.messager.alert('系统提示','检测完成！','warning');
			lrmsMoni.reload();
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
				//window.location.href="${pageContext.request.contextPath}/lrms/lrms_quotamonitor_list.jsp"; 	 
			}
	});
}
function courseStatustype(value, rowData, rowIndex){
	if(value==0){
		return '<span style="color:red">'+"异常"+'</span>';
	}
	if(value==1){
		return "正常";
	}
}

function password(values){
	return '*******';
	
}
//重置查询信息
function rese(){
	$("#username").val('');
	$('#scriptType').val('');
}

function submi(){
	var jsonData = {
			username:$("#username").val(),
			newpage:1,page:1
			};
	lrmsMoni.load(jsonData);
}
function editParam(){
	  var changes = lrmsMoni.getChanges();
	  if(!lrmsMoni_index){
		  if(!(changes &&changes.length > 0)){
			var selected = lrmsMoni.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = lrmsMoni.getRowIndex(selected[0]);
				lrmsMoni_index = rownum;
				//lrmsMoni.removeEditor(['subjectId']);
				lrmsMoni.beginEdit(rownum);
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			$('#addRow').attr('disabled','false');
			}
		}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}

function cancelEdit(){
	lrmsMoni.endEdit(lrmsMoni_index);
	lrmsMoni_index = null;
	lrmsMoni.rejectChanges();
	lrmsMoni.unselectAll();
	$('#editRow').removeAttr("disabled");
	$('#addRow').removeAttr("disabled");
}


function save(){
			lrmsMoni.endEdit(lrmsMoni_index);
			var vali = lrmsMoni.validateRow(lrmsMoni_index);
			if(vali){
				var selected = lrmsMoni.getChanges('inserted');
				
				if(selected.length>1){
					$.messager.alert('系统提示','保存只能一个！','warning');
				}else{
					if(selected.length==0){
						selected = lrmsMoni.getChanges('updated');
					}
					var uuid = selected[0].uuid;
					var hostName = selected[0].hostName;
					var localIP = selected[0].localIP;
					var courseCode = selected[0].courseCode;
					var courseName = selected[0].courseName;
					var courseMeaning = selected[0].courseMeaning;
					var maxCourseNum = selected[0].maxCourseNum;
					var courseNum = selected[0].courseNum;
					var collectDate = selected[0].collectDate;
					var courseStatus = selected[0].courseStatus;
					var warningLevl = selected[0].warningLevl;
					var remark = selected[0].remark;
					var col1 = selected[0].col1;
					var col2 = selected[0].col2;
					var col3 = selected[0].col3;
					var userName = selected[0].userName;
					var userPassword = selected[0].userPassword;
					var queryOrder = selected[0].queryOrder;
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "Json",
								data:{uuid:uuid,hostName:hostName,localIP:localIP,courseCode:courseCode,
									courseName:courseName,courseMeaning:courseMeaning,maxCourseNum:maxCourseNum,
									courseNum:courseNum,collectDate:collectDate,courseStatus:courseStatus,
									warningLevl:warningLevl,remark:remark,col1:col1,col2:col2,col3:col3
									,userName:userName,userPassword:userPassword,queryOrder:queryOrder},
								url: "applyprosoft_save.action",
								error:function(data){
									$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
								},
								success:function(data){
									if(data=="1"){
										$.messager.alert('系统提示','保存成功','warning');
										lrmsMoni.reload();
										$('#editRow').removeAttr("disabled");
										$('#addRow').removeAttr("disabled");
										lrmsMoni_index = null;
										lrmsMoni.unselectAll();
									}else if(data=="2"){
										$.messager.alert('系统提示','存在此数据','warning');
									 	lrmsMoni.reload();
									 	$('#editRow').removeAttr("disabled");
										$('#addRow').removeAttr("disabled");
										lrmsMoni_index = null;
										lrmsMoni.unselectAll();
									}else if(data=="3"){
									 	$.messager.alert('系统提示','保存失败','warning');
									 	lrmsMoni.reload();
									 	$('#editRow').removeAttr("disabled");
										$('#addRow').removeAttr("disabled");
										lrmsMoni_index = null;
										lrmsMoni.unselectAll();
									}else{
										$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
										lrmsMoni.unselectAll();
									}
								}
							});
					}
				}
}
	function remove(){
		$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
       	if(btn){
		var uuids =[];
		var selected = lrmsMoni.getAllSelected();
		for(var i=0; i<selected.length; i++){
		    uuids.push(selected[i].uuid);
		}
		if(selected.length== 0) {
			$.messager.alert('系统提示','请选择要删除的记录','warning');
			return;
		}else{
			
			$.ajax({
			
				type: 'post',
				dataType : "Json",
				url: "${pageContext.request.contextPath}/applyprosoft_remove.action?uuid="+uuids,
				success:function(data){
						$.messager.alert('系统提示','删除成功','warning');
						lrmsMoni.reload();
						
						$('#editRow').removeAttr("disabled");
						$('#addRow').removeAttr("disabled");
						//window.location.href="${pageContext.request.contextPath}/lrms/lrms_quotamonitor_list.jsp"; 	 
					}
			});
			
	}
       	}
   	});
	}
	function appendRow(){
		$('#lrmsMoni').datagrid('unselectAll');
		  var changes = lrmsMoni.getChanges();
		  if(!lrmsMoni_index&&!(changes &&changes.length > 0)){
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			$('#addRow').attr('disabled','false');
			var newrow = {targetName:"",dataDate:"",currency:"",monFlag:"",monValue:"",warnValue:"",resValue:"",reguValue:""};
			lrmsMoni.appendRow(newrow);
			var rows = lrmsMoni.getRows();
			lrmsMoni_index = rows.length-1;  
			$('#lrmsMoni').datagrid('selectRecord',null);
			lrmsMoni.beginEdit(rows.length-1);
			
		  }else{
			  $.messager.alert('系统提示','当前有正在编辑！','warning');
			  }
	}
	</script>
</html>

