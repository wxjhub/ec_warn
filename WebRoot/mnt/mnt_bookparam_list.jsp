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
<title>通讯录参数维护</title>
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
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<INPUT name="pageNo1" id="pageNo1"type="hidden" value="${param.success}"> 
		<INPUT name="pageNo2" id="pageNo2"type="hidden" value="${param.lrmsdate}"> 
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">预警级别：
				<select name="bookWarnLvl"   id="bookWarnLvl" >
					    <option value="">---请选择---</option>
					    <rmp:option dictId="ec.warnLvl"></rmp:option>    
					</select>
				</td>
				<td height="40px">姓名：<input id="bookName" type="text"></td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	
		<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" 
		rownumbers="false" singleSelect="false" editable="true" url="bookparam_findBookParamList.action" 
		striped="true" fit="true" height="100%"  title="通讯录参数维护" id="lrmsMoni">
			<r:toolbar id="addRowProcess" text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editParam();"></r:toolbar>
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
			<r:toolbar  text="删除" iconCls="icon-remove" onClick="remove();"></r:toolbar>
			<r:col  field="uuid" title="ID"  checkbox="true"   sortable="true" width="260" editable="false" hidden="flase">
			</r:col>
			<r:col  field="bookName" title="姓名" sortable="true" width="150">
			<r:editorText missingMessage="姓名不能为空" required="true"></r:editorText>
			</r:col>
			<r:col  field="bookTele" title="手机号码" sortable="true" width="150">
			<r:editorText missingMessage="手机号码不能为空" required="true"></r:editorText>
			</r:col>
			 <r:col field="warnSort" title="报警分类" sortable="true"
				width="140" dictId="ec.warnSort">
				<r:editorDictSelect missingMessage="不能为空"  required="false"></r:editorDictSelect>
			</r:col> 
			<r:col  field="bookWarnLvl" title="预警级别" sortable="true" width="100" dictId="ec.warnLvl">
			<r:editorDictSelect missingMessage="预警级别不能为空" required="true"></r:editorDictSelect>
			</r:col>
			<r:col  field="bookValues" title="短信通知内容" sortable="true" width="300">
			<r:editorText ></r:editorText>
			</r:col>
		
			
			
		 <r:col field="startTime" title="开始接受短信时间" sortable="true"
				width="100" dictId="mon.time.hour">
				<r:editorDictSelect missingMessage="不能为空"  required="false"></r:editorDictSelect>
			</r:col> 
			 <r:col field="endTime" title="结束接受短信时间" sortable="true"
				width="100" dictId="mon.time.hour">
				<r:editorDictSelect missingMessage="不能为空"  required="false"></r:editorDictSelect>
			</r:col> 
		<r:pagination id="pag"></r:pagination>
	</r:grid>
		
	</div>
</body>
<script>
//重置查询信息
function rese(){
	$("#bookName").val('');
	$("#bookWarnLvl").val('');
	$('#scriptType').val('');
}

function submi(){
	var jsonData = {
			bookName:$("#bookName").val(),
			bookWarnLvl:$("#bookWarnLvl").val(),
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
					var bookName = selected[0].bookName;
					var bookTele = selected[0].bookTele;
					var bookWarnLvl = selected[0].bookWarnLvl;
					var bookValues = selected[0].bookValues;
					var warnSort = selected[0].warnSort;
					var startTime = selected[0].startTime;
					var endTime = selected[0].endTime;
					var reg = /^[1][3-8][0-9]{9}$/;
					if(bookWarnLvl==""||bookWarnLvl.indexOf(" ")!=-1){
						$.messager.alert('系统提示','预警级别不能为空！','warning');
						lrmsMoni_index = null;
						lrmsMoni.rejectChanges();
						lrmsMoni.unselectAll();
						$('#editRow').removeAttr("disabled");
						$('#addRow').removeAttr("disabled");
					}else if(!reg.test(bookTele)){
						$.messager.alert('系统提示','手机号码格式错误！','warning');
						lrmsMoni_index = null;
						lrmsMoni.rejectChanges();
						lrmsMoni.unselectAll();
						$('#editRow').removeAttr("disabled");
						$('#addRow').removeAttr("disabled");
					}else{ 
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "Json",
								data:{uuid:uuid,bookName:bookName,bookTele:bookTele,bookWarnLvl:bookWarnLvl,bookValues:bookValues,warnSort:warnSort,startTime:startTime,endTime:endTime},
								url: "bookparam_save.action",
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
										$.messager.alert('系统提示','该手机号码在该报警分类已存在，数据保存失败','warning');
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
			}else{
				$.messager.alert('系统提示','输入项有错误！','warning');	
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
				url: "${pageContext.request.contextPath}/bookparam_remove.action?uuid="+uuids,
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

