<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
<title>现金流压力测试</title>
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
    $('#dataDate').datebox({   
     }); 
    	        
   
});
function appendRow(){
	 var changes = lrmsCash.getChanges();
	  if(!lrmsCash_index&&!(changes &&changes.length > 0)){
			$('#editRowProcess').removeAttr("disabled");
			$('#addRowProcess').removeAttr("disabled");
			$('#editRowProcess').attr('disabled','false');
			$('#addRowProcess').attr('disabled','false');
			var newrow = {settingName:"",dataDate:"",settingDesc:"",runFlag:"",editTime:""};
			var edit =  {
					field:"settingName",
					editor:{
						type:'validatebox',
						options:{
							validType:"processIdValidator"
						}
					}
			};
			lrmsCash.appendRow(newrow,edit);
			var rows = lrmsCash.getRows();
			lrmsCash_index = rows.length-1;  
			lrmsCash.beginEdit(rows.length-1);
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}
function del(){
	var selected = lrmsCash.getAllSelected();
	  var uuid=selected[0].uuid;
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要删除的记录','warning');
		return;
	}else{
		$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
			if(btn){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid},
					url: "cash_remove.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','删除成功','warning');
							lrmsCash.reload();
							getCashList();
							lrmsTaskRelation.load();										
						}else{
							$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
						}
					}
				});
				}
			});
		
	}
}
function save(){
	lrmsCash.endEdit(lrmsCash_index);
	var vali = lrmsCash.validateRow(lrmsCash_index);
	if(vali){
	var changes = lrmsCash.getChanges('inserted'); 
	if(changes.length>1){
		$.messager.alert('系统提示','保存只能一个！','warning');
	}
	else{
		if(changes.length==0){
			changes = lrmsCash.getChanges('updated');
		} 
		var uuid=changes[0].uuid;
		var settingName=changes[0].settingName;
		var dataDate=changes[0].dataDate;
		var settingDesc=changes[0].settingDesc;
		var runFlag=changes[0].runFlag;
		var lgbcRate=changes[0].lgbcRate;
		var currency=changes[0].currency;
		var editTime=changes[0].editTime;
		if(uuid!=""&&settingName!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,settingName:settingName,dataDate:dataDate,settingDesc:settingDesc,runFlag:runFlag,currency:currency,lgbcRate:lgbcRate,editTime:editTime},
					url: "cash_save.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','保存成功','warning');
							getCashList();
							lrmsCash.reload();	
							$('#editRowProcess').removeAttr("disabled");
							$('#addRowProcess').removeAttr("disabled");	
						//	 batchId=batchId1;
							
						}
						else if(result==2){
							$.messager.alert('系统提示','存在此数据','warning');
							lrmsCash.reload();	
							$('#editRowProcess').removeAttr("disabled");
							$('#addRowProcess').removeAttr("disabled");	
							lrmsCash.deleteRow(lrmsCash_index);
						}
						else if(result==3){
							$.messager.alert('系统提示','修改成功','warning');
							lrmsCash.reload();
							getCashList();
							$('#editRowProcess').removeAttr("disabled");
							$('#addRowProcess').removeAttr("disabled");															
						}
					}
				});
		}
		else
		{
			lrmsCash.endEdit(lrmsCash_index);
			lrmsCash_index = null;
			lrmsCash.rejectChanges();	
			$('#editRowProcess').removeAttr("disabled");
			$('#addRowProcess').removeAttr("disabled");
			$.messager.alert('系统提示','保存项有空值！','warning');	
					
		}
	}
	}else
	{
		$.messager.alert('系统提示','输入项有错误！','warning');
	}
}
function testabc(){
	//alert("test");
} 
function editProcess(){
	 var changes = lrmsCash.getChanges();
	  if(!lrmsCash_index&&!(changes &&changes.length > 0)){
			var selected = lrmsCash.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = lrmsCash.getRowIndex(selected[0]);
				lrmsCash_index = rownum;
				lrmsCash.removeEditor(['uuid']);
				lrmsCash.beginEdit(rownum);
				$('#editRowProcess').removeAttr("disabled");
				$('#addRowProcess').removeAttr("disabled");
				$('#editRowProcess').attr('disabled','false');
				$('#addRowProcess').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}
function cancelProcess(){
	lrmsCash.endEdit(lrmsCash_index);
	lrmsCash_index = null;
	lrmsCash.rejectChanges();
	$('#editRowProcess').removeAttr("disabled");
	$('#addRowProcess').removeAttr("disabled");
	
}
function getCashList(){
	$.ajax( {
		url : "${pageContext.request.contextPath}/cash_list.action",
		type : "POST",
		data : "",
		dataType : "json",
		success : function(data) {
			var zNodes = eval(data);
			var sele = $("#setting");
			sele.html("");
			sele.append("<option value='' selected='selected'>"+"---请选择---"+"</option>");
			for(var i=0;i<zNodes.length;i++){
					sele.append("<option value="+zNodes[i].uuid+">"+zNodes[i].settingName+"</option>");
			}
			
		},
		error : function(data) {
			alert("场景表信息出错,请重试");
		}
	});
	
}
function rese(){
	$('#setting').val('');
	$("#dataDate").datebox('setValue');
}
function submi(){
	var jsonData = {
			uuid:$('#setting').val(),
			dataDate:$("#dataDate").datebox('getValue'),
			newpage:1,page:1
			};
	lrmsCash.load(jsonData);
	
}
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
});
function testOn(rowIndex,rowData){
	$("#selectProcessId").val(rowData.settingName);
	$("#selectProcessId1").val(rowData.uuid);
	//var selectedIndex=rowIndex;	
	//var opt=lrmsTaskRelation.getOptions();
//	opt.url="cashParameter_findAllCashParameter.action";
	//window.location.href="cashParameter_findAllCashParameter.action?settingId"+rowData.uuid;
	//$("#taskRelationForm").hide();
	//$("#taskRelationForm").panel("close");
	//$("#taskRelationInfo").show();
	//lrmsTaskRelation.load({settingId:rowData.uuid});
}
function cashParamter()
{
	var selected = lrmsCash.getAllSelected();
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择一个场景在配置参数！','warning');
	}else
	{
	var settingName=$("#selectProcessId").val();
	var uuid=$("#selectProcessId1").val();
	window.location.href = "${pageContext.request.contextPath}/lrms/lrms_cashflow1_list.jsp?uuid="+uuid+"&settingName="+settingName;
	}
}
function cashParamter1()
{
	var selected = lrmsCash.getAllSelected();
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择一个场景在配置指标参数！','warning');
	}else
	{
	var settingName=$("#selectProcessId").val();
	var uuid=$("#selectProcessId1").val();
	window.location.href = "${pageContext.request.contextPath}/lrms/lrms_cashflowDetials_list.jsp?uuid="+uuid+"&settingName="+settingName;
	}
}
function stress()
{
	 var changes = lrmsCash.getChanges();
	 var selected = lrmsCash.getAllSelected();
	 if(selected.length==0)
		 $.messager.alert('系统提示','请选择场景!!!','warning');
	 else{
		var uuid=$("#selectProcessId1").val();
		$.ajax({
			    cache:false,
				type: 'post',
				dataType : "Json",
				url: "cash_prodExec.action?uuid="+uuid,
				error: function(request) {      //
					   messager.close(); 
						 $.messager.alert('系统提示','调用失败！！','warning');
			             },
				success:function(data){
			        		if(data=="runnable success"){
			        			$.messager.alert('系统提示','存储过程调用成功','warning');
			     				window.open("http://172.16.251.137:8080/bi");
				     		} else{
					     		$.messager.alert('系统提示',data,'warning');
					     	} 
			}
		});
	 }

}
</script>
</head>
<body onload="getCashList()">

	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;;">
		<INPUT name="pageNo" id="pageNo" type="hidden" value="${param.pageNo}">
		<input name="processId1"  type="hidden" id="selectProcessId1"/>
		<input name="processId"  type="hidden" id="selectProcessId"/>
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">场景：</td>
				<td height="40px">
					<select name="setting"   id="setting">
					    <option value="">---请选择---</option>
					</select>
				</td>
				<td height="40px">数据日期：<input id="dataDate" type="text"></td>
				<td>
				<input id="filter_submit" class="inputd" type="button" onclick="submi()" value="查 询" /> 
				<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置" />
				</td>
			</tr>
		</table>
		</form>
	
<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" editable="true"   singleEdit="true" url="cash_findAllCashs.action" striped="true" fit="true" height="100%"  id="lrmsCash" onSelect="testOn(a,b);" onBeforeLoad="testabc();" title="压力测试" rownumbers="false" singleSelect="true">
			<r:toolbar id="addRowProcess" text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>
		<r:toolbar text="删除" iconCls="icon-remove" onClick="del();"></r:toolbar>
		<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
		<r:toolbar id="editRowProcess" text="编辑" iconCls="icon-edit" onClick="editProcess();"></r:toolbar>
		<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelProcess();"></r:toolbar>
		<r:toolbar text="压力测试" iconCls="icon-redo" onClick="stress();"></r:toolbar>
		<r:toolbar text="现金流参数配置" iconCls="icon-redo" onClick="cashParamter()"></r:toolbar>
		<r:toolbar text="指标参数配置" iconCls="icon-redo" onClick="cashParamter1()"></r:toolbar>
		<r:col field="uuid" checkbox="true" editable="true"   width="100" rowspan="2"></r:col>
		<r:col field="settingName" title="场景名称" sortable="true"  width="180" editable="false" rowspan="2">
		<r:editorText required="true" missingMessage="不能为空"></r:editorText>
		</r:col>
		<r:col field="dataDate" title="数据日期" sortable="true"  width="180" rowspan="2">
		<r:editorDate required="true" editable="false" missingMessage="不能为空" format="yyyy-MM-dd"/>
		</r:col>
		<r:col field="currency" title="币种"   sortable="true"   width="180" rowspan="2" dictId="lrms.currency" >
		<r:editorDictSelect required="true" missingMessage="不能为空"></r:editorDictSelect>
		</r:col>
		<r:col field="lgbcRate" title="保函违约率" sortable="true"  width="158" rowspan="2">
		<r:editorText required="true" missingMessage="不能为空"></r:editorText>
		</r:col>
		<r:col field="settingDesc" title="场景描述"  sortable="true"  width="180" rowspan="2">
		<r:editorText required="true" missingMessage="不能为空"></r:editorText>
		</r:col>
		<r:col  field="editTime" editable="false"  title="变更时间"  sortable="true"  width="180" rowspan="2">
			<r:editorDate format="yyyy-MM-dd"/>
		</r:col>
		<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99"  pageSize="10" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
	</r:grid>
		
	</div>

</body>
</html>

