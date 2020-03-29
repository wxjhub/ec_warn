<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/tld/rmp.tld"  prefix="rmp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 
<title>内端网络连接情况</title> 
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
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
.input_file{width:130px; margin-left:-130px;height:21px; filter:alpha(opacity=0); opacity:0;}
.top{
	position: relative;
	top:-21px;
}
</style>
<script type="text/javascript">
$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 80);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 80);
});
function findService(){
	var selected = lrmsMoni.getAllSelected();
	if (selected.length == 0) {
		$.messager.alert('系统提示', '请选择要执行的数据信息', 'warning');
		return;
	} else{
		
	
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在进行服务检测";
	obj.text;
	obj.interval = 400; 
	messager.progress(obj);
	$.ajax({
		type: 'post',
		data : selected[0],
		dataType : "Json",
		url: "${pageContext.request.contextPath}/localNetwork_serviceServer.action",
		success:function(data){
			messager.close();
			if(data==1){
				$.messager.alert('系统提示','找不到节点IP为'+selected[0].pointIP+'的用户名或密码，请配置后检测！','error');
			}else{
				var a = eval("("+data+")");
				//$.each(a,function(index,item){
				//	var key = a[index].line;
				//	$('#taskManger').div($('#taskManger').div())+"<br>"+key+"</br>";
				//})
				$('#taskManger').html("<br>"+a.mess+"</br>");
				$.messager.alert('系统提示','检测完成！','warning');
				//$('#editRow').removeAttr("disabled");
				//$('#addRow').removeAttr("disabled");
					//window.location.href="${pageContext.request.contextPath}/lrms/lrms_quotamonitor_list.jsp"; 	 
			}
			lrmsMoni.reload();
			}
	});
	}
}
function statustype(value, rowData, rowIndex){
	if(value==0){
		return '<span style="color:red">'+"异常"+'</span>';
	}
	if(value==1){
		return "正常";
	}
}
//重置查询信息
function rese(){
	$("#hostName").val('');
	//$('#scriptType').val('');
}

function submi(){
	var jsonData = {
			hostName:$("#hostName").val(),
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
					var netIP = selected[0].netIP;
					var netPort = selected[0].netPort;
					var remark = selected[0].remark;
					var col1 = selected[0].col1;
					var col2 = selected[0].col2;
					var re =  /^([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.([0-9]|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])$/;  
					if(!re.test(netIP)){  
						$.messager.alert('系统提示','<span style="color:red">'+"IP地址格式错误"+'</span>','warning');
					} else{
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "Json",
								data:{uuid:uuid,netIP:netIP,netPort:netPort,remark:remark,col1:col1,col2:col2},
								url: "network_save.action",
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
									}else if(data=="2"){
										$.messager.alert('系统提示','存在此数据','warning');
									 	lrmsMoni.reload();
									 	$('#editRow').removeAttr("disabled");
										$('#addRow').removeAttr("disabled");
										lrmsMoni_index = null;
									}else if(data=="3"){
									 	$.messager.alert('系统提示','保存失败','warning');
									 	lrmsMoni.reload();
									 	$('#editRow').removeAttr("disabled");
										$('#addRow').removeAttr("disabled");
										lrmsMoni_index = null;
									}else{
										$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
									}
								}
							});
						}
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
				url: "${pageContext.request.contextPath}/network_remove.action?uuid="+uuids,
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
</head>
<%String status = (String)request.getAttribute("status"); 
%>
<body class="easyui-layout" border="false" onload="page_top()">
	<div region="west" style="width:780px;border-left: none;" border="true" title="网络监控">
		<form name="formSearch" id="formSearch" method="post" style="padding: 9px 0 10px 30px;">
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<INPUT name="pageNo1" id="pageNo1"type="hidden" value="${param.success}"> 
		<INPUT name="pageNo2" id="pageNo2"type="hidden" value="${param.lrmsdate}"> 
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">主机名称：<input id="hostName" type="text" value=""></td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
		<div class="gridDiv0" id="gridDiv0" style="padding-left: 10px;">
			<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" 
		rownumbers="false" singleSelect="true" editable="true" url="localNetwork_findNetWorkList.action" 
		striped="true" fit="true" height="100%"  title="本端网络监控" id="lrmsMoni" >
<%-- 			<r:toolbar id="addRowProcess" text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar> --%>
<%-- 			<r:toolbar  text="删除" iconCls="icon-remove" onClick="remove();"></r:toolbar> --%>
<%-- 			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editParam();"></r:toolbar> --%>
<%-- 			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar> --%>
<%-- 			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar> --%>
			<r:toolbar text="执行网络检测" iconCls="icon-remove" onClick="findService();"></r:toolbar>
			<r:col  field="uuid" title="ID"  checkbox="true"   sortable="true" width="260" editable="false">
			</r:col>
			<r:col  field="hostName" title="主机名称" sortable="true" width="150" editable="false">
<%-- 			<r:editorText missingMessage="不能为空" required="true"></r:editorText> --%>
			</r:col>
			<r:col  field="hostIp" title="主机IP" sortable="true" width="150" editable="false">
<%-- 			<r:editorText missingMessage="不能为空" required="true"></r:editorText> --%>
			</r:col>
		<%-- 	<r:col  field="portName" title="对端名称" sortable="true" width="150" editable="false"> --%>
<%-- 			<r:editorText  missingMessage="不能为空" required="true"></r:editorText> --%>
		<%-- 	</r:col> --%>
			<r:col  field="hostPort" title="端口" sortable="true" width="150" editable="false">
<%-- 			<r:editorText  missingMessage="不能为空" required="true"></r:editorText> --%>
			</r:col>
			<%-- <r:col  field="netMeaning" title="含义" sortable="true" width="100" editable="false">
			<r:editorText></r:editorText>
			</r:col> --%>
			<r:col field="collectDate" title="采集时间" sortable="true"
				width="130" hasTime="true" dateFormat="yyyy-MM-dd" editable="false">
			</r:col>
			<r:col  field="status" title="状态" sortable="true" width="150" editable="false"  formatter="statustype(value, rowData, rowIndex)">
<%-- 			<r:editorText  missingMessage="不能为空" required="true"></r:editorText> --%>
			</r:col>
			<r:col  field="warningLevl" title="预警级别" sortable="true" width="150" editable="false"  dictId="ec.warnLvl">
<%-- 			<r:editorText  missingMessage="不能为空" required="true"></r:editorText> --%>
			</r:col>
			<r:col  field="col1" title="预留1"  hidden="true" sortable="true" width="100" editable="false">
			<r:editorText></r:editorText>
			</r:col>
			<r:col  field="col2" title="预留2"  hidden="true" sortable="true" width="100" editable="false">
			<r:editorText></r:editorText>
			</r:col>
			<r:col  field="col3" title="预留3"  hidden="true" sortable="true" width="100" editable="false">
			<r:editorText></r:editorText>
			</r:col>
		<r:pagination id="pag"></r:pagination>
	</r:grid>
		</div>
	</div>
	<div region="center" style="width:220px;background-color:white;" border="true" id="taskManger" title="网络执行监控信息" >
	</div>
	<br>
</body>

<script type="text/javascript">
function formatterBatchRunFlag(value){
	if(value == '-1') {
		return "出错";
	} else if(value == '0') {
		return "未运行";
	}else if(value == '1') {
		return "正在运行";
	}else if(value == '2') {
		return "已完成";
	}
}
</script>
<script type="text/javascript">
function page_top(){
	//$("#gridDiv1 .pagination").addClass("top");
	$("#gridDiv1 .datagrid-toolbar").css("height","55px");
}
</script>
</html>

