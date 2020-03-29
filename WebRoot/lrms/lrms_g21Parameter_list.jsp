<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参数补录</title>
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

								function getTemplate(){
									window.location.href="${pageContext.request.contextPath}/lrmsdownloadTemplate.action?modelName="+"ParameterCollection";
								}
							
								function getTaskByData(){
									window.location.href="${pageContext.request.contextPath}/lrmsexportExcel.action?modelName="+"ParameterCollection";
								}
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
										        	 url: "lrmsinputExcel_inputExcelParameterCollection.action?modelName="+"ParameterCollection",
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
										                }  else{
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
				<td height="40px">报表编号：<input id="repCode" type="text"></td>
				<td height="40px">分析项表示：<input id="itemId" type="text"></td>
				<td height="40px">科目编号：<input id="ruleId" type="text"></td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	
		<div class="gridDiv">
			<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" rownumbers="false" singleSelect="true" editable="true" url="paracol_findAllparameterCollection.action" striped="true" fit="true" height="100%"  title="G21维表配置" id="lrmsMoni" >
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editParam();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
		    <r:toolbar text="<span style='position:relative;top:-3px;'><input style='border: 1px #c0c0c0 solid; height: 18px; width:300px;' type='text' id='txt1' name='txt1' /><input type='button' style='height: 20px;cur' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/></span>"></r:toolbar>
				<r:toolbar text="导入" iconCls="icon-import" onClick="inExcel();"></r:toolbar>
			<r:toolbar text="导出" iconCls="icon-export" onClick="getTaskByData();"></r:toolbar>
			<r:toolbar text="导出模板" iconCls="icon-exportTemplate" onClick="getTemplate();"></r:toolbar>
			<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
			<r:col  field="repCode" title="报表编号"   editable="false"  sortable="true" width="160">
			</r:col>
			<r:col field="repName" sortable="true" title="报表名称"  editable="false" width="120">
			</r:col>
			<r:col field="itemId" title="分析项表示" sortable="true" editable="false" width="120">
			</r:col>    
			<r:col field="itemName" title="分析项名称" sortable="true" editable="false" width="118">
			</r:col>
			<r:col field="ruleId" title="科目编号" sortable="true"  width="110">
			<r:editorText required="true" missingMessage="不能为空"></r:editorText>
			</r:col>    
			<r:col field="sign" title="计算方向" sortable="true"  width="110">
			<r:editorText required="true" missingMessage="不能为空"></r:editorText>
			</r:col> 
			<r:col field="typeId" title="对应指标列" sortable="true"  width="110">
			<r:editorText required="true" missingMessage="不能为空"></r:editorText>
			</r:col> 
			<r:col  field="ruleTpe" title="处理类型" sortable="true" width="110">
			<r:editorText required="true" missingMessage="不能为空"></r:editorText>
			</r:col> 
			<r:col  field="ruleDesc" title="处理描述" sortable="true" width="110">
			</r:col> 
		<r:pagination id="pag"></r:pagination>
	</r:grid>
		
	</div>

</body>
<script>

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
				lrmsMoni.removeEditor(['uuid']);
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

//重置查询信息
function rese(){
	$('#scriptType').val('');
	$("#dataDate").datebox('setValue');
}

function submi(){
	var jsonData = {
			repCode:$('#repCode').val(),
			itemId:$('#itemId').val(),
			ruleId:$('#ruleId').val(),
			newpage:1,page:1
			};
	lrmsMoni.load(jsonData);
	
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
					var repCode=selected[0].repCode;
					var repName=selected[0].repName;
					var itemId=selected[0].itemId;
					var itemName=selected[0].itemName;
					var ruleId=selected[0].ruleId;
					var typeId=selected[0].typeId;
					var sign=selected[0].sign;
					var ruleTpe=selected[0].ruleTpe;
					var ruleDesc=selected[0].ruleDesc;
					if(uuid!=""){
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "Json",
								data:{uuid:uuid,repCode:repCode,repName:repName,itemId:itemId,itemName:itemName,ruleId:ruleId,sign:sign,ruleTpe:ruleTpe,ruleDesc:ruleDesc,typeId:typeId},
								url: "paracol_save.action",
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
											}
										else if(data=="3"){
										  	$.messager.alert('系统提示','修改成功','warning');
										  	lrmsMoni.reload();
										  	$('#editRow').removeAttr("disabled");
											$('#addRow').removeAttr("disabled");
											lrmsMoni_index = null;
										}else{
												$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
															
														
												}
										}
							});
		
					}else{
								$.messager.alert('系统提示','保存项有空值！','warning');	
						}
				}
			}else{
				$.messager.alert('系统提示','输入项有错误！','warning');	
			}
}
	function remove(){
		$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
         	if(btn){
		var uuids = [];
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
				url: "${pageContext.request.contextPath}/monitor_remove.action?uuids="+uuids,
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
			lrmsMoni.beginEdit(rows.length-1);
		  }else{
			  $.messager.alert('系统提示','当前有正在编辑！','warning');
			  }
	}

	</script>
</html>

