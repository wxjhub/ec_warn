<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/rmp"  prefix="rmp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN"
	xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>指标参数管理</title>
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
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<style type="text/css">
body {
	font-family: "微软雅黑";
}

.font {
	color: red
}

.input_file{width:130px; margin-left:-130px;height:21px; filter:alpha(opacity=0); opacity:0;}
.top{
	position: relative;
	top:-21px;
}
</style>
<script type="text/javascript">
var abc;
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
});
var flag=0;
var selectedRelationIndex;

function testOn(){
	var opt=lrmsTaskRelation.getOptions();
	opt.url="cashParameter_findAllCashParameter.action";
	lrmsTaskRelation.load({settingId:"${param.uuid}"});
}
function testOnRelationSelect(rowIndex,rowData){
	selectedRelationIndex=rowIndex;	
	//CashParameter.uuid=rowData.uuid;
	//CashParameter.paramName=rowData.paramName;
	//CashParameter.limitTime=rowData.limitTime;
	//CashParameter.settingId=rowData.settingId;
	//CashParameter.amount=rowData.amount;
	//CashParameter.expiredChurnrate=rowData.expiredChurnrate;
	//CashParameter.unexpiredChurnrate=rowData.unexpiredChurnrate;
}


function yhd(){
	$('#preTaskTypeId').combobox({
		onSelect: function(){
		
 		//changeOption1();
			}
		});
	$('#currTaskTypeId').combobox({
		onSelect: function(){
 		//changeOption();
			}
		});
}
function dblClickRow(rowIndex,rowData){    
}

function testabc(){
	//alert("test");
}     
function testBeforeLoad(){
}
function testLoad(){
	userGrid.load({
		d:32,
		abc:'abc'
		});
}

function btnAdd(){
	 var changes = lrmsTaskRelation.getChanges();
	  if(!lrmsTaskRelation_index&&!(changes &&changes.length > 0)){
			$('#editRowProcess1').removeAttr("disabled");
			$('#addRowProcess1').removeAttr("disabled");
			$('#editRowProcess1').attr('disabled','false');
			$('#addRowProcess1').attr('disabled','false');
			var newrow = {paramName:"",limitTime:"",amount:"",expiredChurnrate:"",unexpiredChurnrate:""};
			lrmsTaskRelation.appendRow(newrow);
			var rows = lrmsTaskRelation.getRows();
			lrmsTaskRelation_index = rows.length-1;  
			lrmsTaskRelation.beginEdit(rows.length-1);
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}
function btnDel(){
	var uuids = [];
	var selected = lrmsTaskRelation.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    uuids.push(selected[i].uuid);
	}
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
			url: "ldx_remove.action?uuids="+uuids,
			success:function(data){
				var result=eval("(" + data + ")");
				if(result==1){
					$.messager.alert('系统提示','删除成功','warning');
					lrmsTaskRelation.reload();										
				}else{
					$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
				}
			}
		});
			}
			});
	}
}
function intrExcel(){
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在导入请稍后";
	obj.text;
	obj.interval = 400; 
		var abc=$('#selectProcessId1').val();
	var updateUpdata = $('#upload1').val();
	if(updateUpdata!=null&&updateUpdata!=""){
		messager.progress(obj);
		$.ajaxFileUpload({  
			url: "lrmsinputExcel_inputExcelLdxParameterDetails.action?modelName="+"LdxParameterDetails",
			secureuri:false,  
			fileElementId: 'upload1',//文件选择框的id属性  
			dataType:'json',//服务器返回的格式，可以是json  
			error: function(request) {      // 设置表单提交出错
			 messager.close(); 
			 $.messager.alert('系统提示','导入失败！！','warning');
			},
			success: function(data) { // 设置表单提交完成使用方法
				var zNodes = eval(data); 
				if(zNodes.length>0){
					var errorInfo ="";
					//alert(zNodes);
					for(var i=0;i<zNodes.length;i++){
					//alert(zNodes[i]);
						errorInfo+=zNodes[i]+"\r\r";
					}
					 messager.close();    
					 $.messager.alert('系统提示',errorInfo,'warning');  
				}else{
					  messager.close();    
					 $.messager.alert('系统提示','导入成功！','warning');
					 lrmsTaskRelation.load({settingId:abc});
				}
				            
			}
		});
	}else{
		 $.messager.alert('系统提示','请选择导入文件！！！','warning');
	}									        

}
function stress()
{
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在跳转请稍后";
	obj.text;
	obj.interval = 400; 
	messager.progress(obj);
	//messager.close();
}
function getTemplate(){
	window.location.href="${pageContext.request.contextPath}/lrmsdownloadTemplate.action?modelName="+"LdxParameterDetails";
}

function getTaskByPage(){
	var pageNo = $('#deptGrid').datagrid('getPager');
	var pageSize = $(pager).pagination("options");

	//var pageNo = $('#etlTask').datagrid("pageNumber");
	//var pageSize = $('#etlTask').datagrid("pageSize");
	//alert(pageNo+"="+pageSize);
	window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"Process&pageSize="+pageSize+"&pageNo="+pageNo;
}

function getTaskByData(){
	window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"cash";
}

function getTaskRelationByData(){

		var abc=$('#selectProcessId1').val();
		window.location.href="${pageContext.request.contextPath}/lrmsexportExcel.action?modelName="+"LdxParameterDetails";

	
}


function show4(){
	var win = $.messager.progress({
		title:'正在保存    请稍等......',
		msg:'正在加载  数据...'
	});
	setTimeout(function(){
		$.messager.progress('close');
	},5000);
}



function formatDate(value,rowData) {
	if(typeof(rowData.createTime)=="object"&&value!=null&&value!=""){
		var m = value.month + 1;
		var d = value.date;
		var y = value.year + 1900;
		var h = value.hours;
		var min = value.minutes;
		var s = value.seconds;
		if(m<10) m = '0' + m;
		if(d<10) d = '0' + d;
		if(h<10) h = '0' + h;
		if(min<10) min = '0' + min;
		if(s<10) s = '0' + s;
		rowData.createTime=y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;
		return y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;	
	}
}

function btnEdit(){
	 var changes = lrmsTaskRelation.getChanges();
	  if(!lrmsTaskRelation_index&&!(changes &&changes.length > 0)){
			var selected = lrmsTaskRelation.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = lrmsTaskRelation.getRowIndex(selected[0]);
				lrmsTaskRelation_index = rownum;
				lrmsTaskRelation.removeEditor(['uuid']);
				lrmsTaskRelation.beginEdit(rownum);
				$('#editRowProcess1').removeAttr("disabled");
				$('#addRowProcess1').removeAttr("disabled");
				$('#editRowProcess1').attr('disabled','false');
				$('#addRowProcess1').attr('disabled','false');
			}
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
}
function cancelProcess1(){
	lrmsTaskRelation.endEdit(lrmsTaskRelation_index);
	lrmsTaskRelation_index = null;
	lrmsTaskRelation.rejectChanges();
	$('#editRowProcess1').removeAttr("disabled");
	$('#addRowProcess1').removeAttr("disabled");
	
}

function rese(){
	$('#paraName').val('');
}

function changeCash(){
	var settingName = document.getElementById("setting").value;
	var jsonData = {
			settingName:$('#setting').val(),
			newpage:1
			};
	var opt=lrmsCash.getOptions();
  opt.url="cash_list.action";
  lrmsCash.load(jsonData);
}	
function reload(){
	changeCash();
}
function right()
{
	window.location.href="${pageContext.request.contextPath}/lrms/lrms_stressTesting_list.jsp";
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
function success(par)
{
	$('#selectProcessId').val(par.setting);
}
function submi(){
	var jsonData = {
			paraName:$('#paraName').val(),
			newpage:1,page:1
			};
	lrmsTaskRelation.load(jsonData);
	
}
</script>
</head>
<body>
	<form name="formtrSearch" id="formtrSearch" method="post" style="padding-left: 20px;">
		<INPUT name="pageNo" id="pageNo" type="hidden" value="${param.pageNo}">
		<input  name="processId1"  type="hidden" id="selectProcessId1" value="${param.uuid}"/>
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
					<td height="40px">参数名称：</td>
			
				<td height="40px" width="180px">
				
					<select name="paraName"   id="paraName" >
					    <option value="">---请选择---</option>
					    <rmp:option dictId="lrms.ldx.paramName"></rmp:option>    
					</select>
				</td>
				<td>

					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
		</table>
		</form>	
		<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" title="指标参数配置" pagination="true" idField="uuid" editable="true" onLoadSuccess="success(par)"   singleEdit="true"  url="ldx_findAllCashParameter.action" striped="true" fit="true" height="100%"  onSelect="testOnRelationSelect(a,b);" id="lrmsTaskRelation" onBeforeLoad="testabc();" rownumbers="false" singleSelect="true">
		<r:toolbar  text="增加" id="addRowProcess1"  iconCls="icon-add" onClick="btnAdd();"></r:toolbar>
		<r:toolbar text="编辑" id="editRowProcess1"  iconCls="icon-edit" onClick="btnEdit();"></r:toolbar>
		<r:toolbar text="删除" iconCls="icon-redo" onClick="btnDel();"></r:toolbar>
		<r:toolbar text="保存" iconCls="icon-save" onClick="save1();"></r:toolbar>
		<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelProcess1();"></r:toolbar>
		<r:toolbar text="导出模板" iconCls="icon-exportTemplate" onClick="getTemplate();"></r:toolbar>
		<r:toolbar text="<span style='position:relative;top:-3px;'><input style='border: 1px #c0c0c0 solid; height: 18px; width:200px;' type='text' id='txt1' name='txt1' /><input type='button' style='height: 20px;cur' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/></span>"></r:toolbar>
		<r:toolbar text="导入" iconCls="icon-import" onClick="intrExcel();"></r:toolbar>
		<r:toolbar text="导出" iconCls="icon-export" onClick="getTaskRelationByData();"></r:toolbar>
		<r:col field="uuid" checkbox="true" editable="false"   width="150" rowspan="2">	</r:col>
		<r:col field="paramName" title="参数名称"  sortable="true"   width="600"   dictId="lrms.ldx.paramName">
     	<r:editorDictSelect required="true" missingMessage="不能为空" panelHeight="400"></r:editorDictSelect>
		</r:col>
		<r:col field="convrate" title="折算率" sortable="true"  width="100" rowspan="2">
		<r:editorText required="true" missingMessage="必须为百分数"></r:editorText>
		</r:col>
		<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg=" {from}/{to}页 共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
</r:grid>
		
	</div>
</body>
<script type="text/javascript">
function page_top(){
	//$("#taskRelationInfo .pagination").addClass("top");
	$("#taskRelationInfo .datagrid-toolbar").css("height","55px");
	
}
function save1(){
	lrmsTaskRelation.endEdit(lrmsTaskRelation_index);
	var vali = lrmsTaskRelation.validateRow(lrmsTaskRelation_index);
	if(vali){
	var changes = lrmsTaskRelation.getChanges('inserted'); 
	if(changes.length>1){
		$.messager.alert('系统提示','保存只能一个！','warning');
	}
	else{
		if(changes.length==0){
			changes = lrmsTaskRelation.getChanges('updated');
		} 
		var uuid=changes[0].uuid;
		var paramName=changes[0].paramName;
		var settingId=$('#selectProcessId1').val();
		var convrate=changes[0].convrate;
		var lessConvrate=changes[0].lessConvrate;
		var moreConvrate=changes[0].moreConvrate;
		if(uuid!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,paramName:paramName,convrate:convrate},
					url: "ldx_save.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','保存成功','warning');	
							lrmsTaskRelation.reload();	
							$('#editRowProcess1').removeAttr("disabled");
							$('#addRowProcess1').removeAttr("disabled");	
						//	 batchId=batchId1;
						}
						else if(result==2){
							$('#editRowProcess1').removeAttr("disabled");
							$('#addRowProcess1').removeAttr("disabled");
							lrmsTaskRelation.reload();
							$.messager.alert('系统提示','存在此数据','warning');
							lrmsCash.deleteRow(lrmsCash_index);
							
						}
						else if(result==3){
							$.messager.alert('系统提示','修改成功','warning');
							lrmsTaskRelation.reload();
							$('#editRowProcess1').removeAttr("disabled");
							$('#addRowProcess1').removeAttr("disabled");															
						}
					}
				});
		}
		else
		{
			lrmsCash.endEdit(lrmsCash_index);
			lrmsCash_index = null;
			lrmsCash.rejectChanges();	
			$('#editRowProcess1').removeAttr("disabled");
			$('#addRowProcess1').removeAttr("disabled");
			$.messager.alert('系统提示','保存项有空值！','warning');	
					
		}
	}
	}else
	{
		$.messager.alert('系统提示','输入项有错误！','warning');	
	}
}
</script>
</html>

