<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN"
	xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
#addRowProcess1 .l-btn-left{
	padding-top: 3px;
}
.input_file{width:80px; margin-left:-80px;height:21px; filter:alpha(opacity=0); opacity:0;}
.top{
	position: relative;
	top:-21px;
}
</style>
<script type="text/javascript">
var abc;
$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 75);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 75);
});
var flag=0;
var selectedRelationIndex;
var CashParameter=function(){
	var uuid="";
	var paramName="";
	var limitTime="";
	var settingId="";
	var amount="";
	var expiredChurnrate="";
	var unexpiredChurnrate="";
};

function testOn(rowIndex,rowData){
	$("#selectProcessId").val(rowData.settingName);
	$("#selectProcessId1").val(rowData.uuid);
	if(rowData.settingName.length!=0&&rowData.uuid.length!=0)
	{
		var selectedIndex=rowIndex;	
		var opt=lrmsTaskRelation.getOptions();
		opt.url="cashParameter_findAllCashParameter.action";
		lrmsTaskRelation.load({settingId:rowData.uuid});
	}
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
		var editTime=changes[0].editTime;
		var currency=changes[0].currency;
		var lgbcRate=changes[0].lgbcRate;
		var orgId=changes[0].orgId;
		if(uuid!=""&&settingName!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,settingName:settingName,dataDate:dataDate,settingDesc:settingDesc,runFlag:runFlag,editTime:editTime,currency:currency,lgbcRate:lgbcRate,orgId:orgId},
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
function configRelation(){
	window.location.href = "${pageContext.request.contextPath}/process_toConfig.action?processId="
		+ processId;
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
							lrmsTaskRelation.load();
							$("#selectProcessId").val(' ');
							lrmsCash.reload();
							getCashList();										
						}else{
							$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
						}
					}
				});
				}
			});
		
	}
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
function appendRow(){
	 var changes = lrmsCash.getChanges();
	  if(!lrmsCash_index&&!(changes &&changes.length > 0)){
			$('#editRowProcess').removeAttr("disabled");
			$('#addRowProcess').removeAttr("disabled");
			$('#editRowProcess').attr('disabled','false');
			$('#addRowProcess').attr('disabled','false');
			var newrow = {lgbcRate:"",settingName:"",dataDate:"",settingDesc:"",runFlag:"",editTime:""};
			var edit =  {
					field:"settingName",
					editor:{
						type:'validatebox',
						options:{
							validType:"processIdValidator",
							required:"true",
							missingMessage:"不能为空"
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


function btnAdd(){
	var selected = lrmsCash.getAllSelected();
	if(selected.length!=0)
	{
	 var changes = lrmsTaskRelation.getChanges();
	  if(!lrmsTaskRelation_index&&!(changes &&changes.length > 0)){
			$('#editRowProcess1').removeAttr("disabled");
			$('#addRowProcess1').removeAttr("disabled");
			$('#editRowProcess1').attr('disabled','false');
			$('#addRowProcess1').attr('disabled','false');
			var newrow = {paramName:"",limitTime:"",amount:"",expiredChurnrate:"",unexpiredChurnrate:""};
			var edit =  {
					field:"paramName",
					editor:{
						type:'combobox',
						options:{
						    data:[{'id':'1001','text':'现金及存放央行款项'},{'id':'1002','text':'存放同业款项'},{'id':'1003','text':'拆放同业'},{'id':'1004','text':'买入返售资产'},{'id':'1005','text':'各项贷款'},{'id':'1006','text':'债券投资和债权投资'}
						         ,{'id':'1009','text':'向中央银行借款'},{'id':'1011','text':'同业存放活期款项'},{'id':'1012','text':'同业存放定期款项'},{'id':'1013','text':'同业拆入'},{'id':'1014','text':'卖出回购款项'},{'id':'1016','text':'个人活期款项'}
						         ,{'id':'1017','text':'个人定期款项'},{'id':'1018','text':'对公活期款项'},{'id':'1019','text':'对公定期款项'},{'id':'1023','text':'表外非衍生金融产品'},{'id':'1024','text':'衍生金融产品'},{'id':'1026','text':'其他现金流'}
						         ,{'id':'1007','text':'其他资产'},{'id':'1020','text':'发行债券'}],
							valueField:"id",
							textField:"text",
							validType:"taskIdValidator",
							required:"true",
							missingMessage:"不能为空"
						}
					}
			};	
			var edit1 =  {
					field:"limitTime",
					editor:{
						type:'combobox',
						options:{
						    data:[{'id':'1','text':'1天'},{'id':'2','text':'7天'},{'id':'3','text':'1个月'},{'id':'4','text':'2个月'},{'id':'5','text':'3个月'},{'id':'6','text':'6个月'}
				                 ,{'id':'7','text':'1年'},{'id':'8','text':'1年以上'}],
							valueField:"id",
							textField:"text",
							validType:"taskIdValidator1",
							required:"true",
							missingMessage:"不能为空"
						}
					}
			};
			lrmsTaskRelation.appendRow(newrow,[edit,edit1]);
			var rows = lrmsTaskRelation.getRows();
			lrmsTaskRelation_index = rows.length-1;  
			lrmsTaskRelation.beginEdit(rows.length-1);
	  }else{
		  $.messager.alert('系统提示','当前有正在编辑！','warning');
		  }
	}else
	{
		$.messager.alert('系统提示','请选择一个场景在添加！','warning');
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
			url: "cashParameter_remove.action?uuids="+uuids,
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
function save_process(){

	var flag = true;
	$('#processFormSave input').each(function () {
	    if ($(this).attr('required') || $(this).attr('validType')) {
		    if (!$(this).validatebox('isValid')) {
		        flag = false;
		        return;
		    }
	    }
	});
	
	if (flag){
		document.getElementById("processId").disabled=false;
	    document.forms['processFormSave'].action="${pageContext.request.contextPath}/process_save.action";
		document.forms['processFormSave'].submit();
	}
	else{
	    $.messager.alert('系统提示','表单填写有误！','warning');
	}	
}
function intrExcel(){
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在导入请稍后";
	obj.text;
	obj.interval = 400; 
	var selected = lrmsCash.getAllSelected();
	if(selected.length!=0)
	{
		var abc=$('#selectProcessId1').val();
	var updateUpdata = $('#upload1').val();
	if(updateUpdata!=null&&updateUpdata!=""){
		$.ajax({
			cache:false,
			type: 'post',
			dataType : "Json",
			url: "lrmsinputExcel_checkCashParameter.action?uuid="+abc,
			success:function(data){
				var result=eval("(" + data + ")");
				if(result==1){
					$.messager.confirm('系统提示','数据存在,是否替换',function(btn){
						if(btn){
					messager.progress(obj);
					$.ajaxFileUpload({  
						url: "lrmsinputExcel_inputExcelCashParameter.action?uuid="+abc+"&modelName="+"CashParameter",
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
		}});								
				}else{
					messager.progress(obj);
					$.ajaxFileUpload({  
						url: "lrmsinputExcel_inputExcelCashParameter.action?uuid="+abc+"&modelName="+"CashParameter",
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
				}
			}
		});
	}else{
		 $.messager.alert('系统提示','请选择导入文件！！！','warning');
	}									        
}else
		{
			$.messager.alert('系统提示','请选择一个场景导入文件！！！','warning');
		}
}
function stress()
{
	var messager = new Messager();
	var obj = new Object();
	obj.title = "系统提示";
	obj.msg = "正在运行";
	obj.text;
	obj.interval = 400; 
	
	 var changes = lrmsCash.getChanges();
	 var selected = lrmsCash.getAllSelected();
	 if(selected.length==0)
		 $.messager.alert('系统提示','请选择场景!!!','warning');
	 else{
		 messager.progress(obj);
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
			        			messager.close();
			        			$.messager.alert('系统提示','运行成功','warning');
			     				window.open("http://172.16.251.137:8080/bi");
				     		} else{
				     			messager.close();
					     		$.messager.alert('系统提示',data,'warning');
					     	} 
			}
		});
	 }

	
	//messager.close();
}
function getTemplate(){
	window.location.href="${pageContext.request.contextPath}/lrmsdownloadTemplate.action?modelName="+"CashParameter";
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
	var selected = lrmsCash.getAllSelected();
	if(selected.length!=0)
	{
		var abc=$('#selectProcessId1').val();
		window.location.href="${pageContext.request.contextPath}/lrmsexportExcel.action?uuid="+abc+"&modelName="+"CashParameter";		
	}else
	{
		$.messager.alert('系统提示','请选择一个场景!','warning');	
	}
	
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


function queryTaskType(selectedTypeId){
	
	$("#currTaskTypeId").empty();
	$("#preTaskTypeId").empty();
	$.ajax({
		   type: "POST",
		   url: "taskRelation_findAllTaskType.action",
		   data: {},
		   success: function(msg){
			   	var data=$.parseJSON(msg);								
				$("#currTaskTypeId").empty();
				var taskType_null=$("<option style='height:60px' value=''></option>");
				var taskType_null_copy=$("<option style='height:60px' value=''></option>");
		   		$("#currTaskTypeId").append(taskType_null);
		   		$("#preTaskTypeId").append(taskType_null_copy);
			   	for(var i=0;i<data.length;i++){
			   		if(!selectedTypeId){
			   			var taskType_info=$("<option style='height:60px' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
			   		}else{
				   		if(selectedTypeId==data[i].taskTypeId){
			   				var taskType_info=$("<option style='height:60px' selected='selected' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
					   	}else{
					   		var taskType_info=$("<option style='height:60px' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
						}
				   	}
			   		var taskType_info_copy=$("<option style='height:60px' value='"+data[i].taskTypeId+"'>"+data[i].taskTypeName+"</option>");
			   		$("#currTaskTypeId").append(taskType_info);
			   		$("#preTaskTypeId").append(taskType_info_copy);
			   		
			   	}
		   }
	});//end ajax
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
				lrmsCash.removeEditor(['settingName']);
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
				lrmsTaskRelation.removeEditor(['paramName']);
				lrmsTaskRelation.removeEditor(['limitTime']);
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
function cancelProcess(){
	lrmsCash.endEdit(lrmsCash_index);
	lrmsCash_index = null;
	lrmsCash.rejectChanges();
	$('#editRowProcess').removeAttr("disabled");
	$('#addRowProcess').removeAttr("disabled");
	
}
function cancelProcess1(){
	lrmsTaskRelation.endEdit(lrmsTaskRelation_index);
	lrmsTaskRelation_index = null;
	lrmsTaskRelation.rejectChanges();
	$('#editRowProcess1').removeAttr("disabled");
	$('#addRowProcess1').removeAttr("disabled");
	
}

function rese(){
	$('#setting').val('');
}

function submi(){
	var jsonData = {
			uuid:$('#setting').val(),
			newpage:1,page:1
			};
	lrmsCash.load(jsonData);
	
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
function getCashList(){
	var s =window.screen.width;
	if(s<=1270)
	{
		$("#gridDiv1 .datagrid-toolbar").css("height","57px");
	}
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
	$(function(){
		$("#addRowProcess1").splitbutton({
			menu:'#mm'
		});
	});
	
}									
</script>
</head>
<body class="easyui-layout" border="false" onload="getCashList()">
<div id="mm" style="width:200px; display:none;" >
    <div iconCls="icon-exportTemplate"  onClick="getTemplate();" >导出模版</div> 
     <div iconCls="icon-export"  onClick="getTaskRelationByData();">导出数据</div>
	<div iconCls="icon-import"  onClick="intrExcel();">导入</div>  
</div> 
	<div region="west" style="width:370px;border-left: none;" border="true" title="现金流压力测试场景管理" style="overflow: hidden;">
		<form name="formSearch" id="formSearch" method="post" style="padding: 9px 0 10px 30px;">
		<INPUT name="pageNo" id="pageNo" type="hidden" value="${param.pageNo}">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">场景：</td>
				<td height="40px">
					<select name="setting"   id="setting" style="width:100px">
					    <option value="">---请选择---</option>
					</select>
				</td>
				<td>
				<input id="filter_submit" class="inputd" type="button" onclick="submi()" value="查 询" /> 
				<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置" />
				</td>
			</tr>
		</table>
		</form>
<div class="gridDiv0" style="overflow: hidden;">
	<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" editable="true"   singleEdit="true" url="cash_findAllCashs.action" striped="true" fit="true" height="100%"  id="lrmsCash" onSelect="testOn(a,b);" onBeforeLoad="testabc();" rownumbers="false" singleSelect="true">
		<r:toolbar id="addRowProcess" text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>
		<r:toolbar text="删除" iconCls="icon-remove" onClick="del();"></r:toolbar>
		<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
		<r:toolbar id="editRowProcess" text="编辑" iconCls="icon-edit" onClick="editProcess();"></r:toolbar>
		<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelProcess();"></r:toolbar>
		<r:toolbar text="压力测试" iconCls="icon-redo" onClick="stress();"></r:toolbar>
		<r:col field="uuid" checkbox="true" editable="true"   width="100" rowspan="2"></r:col>
		<r:col field="settingName" title="场景名称" sortable="true"  width="80" editable="false" rowspan="2">
		<r:editorText required="true" missingMessage="不能为空"></r:editorText>
		</r:col>
		<r:col field="dataDate" title="数据日期" sortable="true"  width="100" rowspan="2">
		<r:editorDate required="true" editable="false" missingMessage="不能为空" format="yyyy-MM-dd"/>
		</r:col>
	   <r:col field="orgId" title="机构"   sortable="true"   width="200" rowspan="2" dictId="lrms.org" >
		<r:editorDictSelect required="true" missingMessage="不能为空"></r:editorDictSelect>
		</r:col>
		<r:col field="currency" title="币种"   sortable="true"   width="110" rowspan="2" dictId="lrms.currency" >
		<r:editorDictSelect required="true" missingMessage="不能为空"></r:editorDictSelect>
		</r:col>
		<r:col field="lgbcRate" title="保函违约率" sortable="true"  width="80" rowspan="2">
		<r:editorText required="true" missingMessage="必须为百分数"></r:editorText>
		</r:col>
		<r:col field="runFlag" title="法定存款准备金率" sortable="true"  width="100" rowspan="2">
		<r:editorText required="true" missingMessage="必须为百分数"></r:editorText>
		</r:col>
		<r:col field="settingDesc" title="场景描述"  sortable="true"  width="70" rowspan="2">
		</r:col>
		<r:col  field="editTime" editable="false"  title="创建时间"  sortable="true"  width="93" rowspan="2">
			<r:editorDate format="yyyy-MM-dd"/>
		</r:col>
		<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
	</r:grid>
</div>
</div>

<div region="center" style="width:120px;background-color:#E7F1FD;" border="true" id="taskManger" title="场景参数管理">
<form name="formtrSearch" id="formtrSearch" method="post" style="padding-left: 20px;">
		<INPUT name="pageNo" id="pageNo" type="hidden" value="${param.pageNo}">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">场景：</td>
				<td height="40px"><input type="text" name="processId" id="selectProcessId" disabled="disabled" class="input_eq" style="width: 100px" /></td>
				<td height="40px"><font color="red">注意:其他现金流不允许填写百分比！</font></td>
				</tr>
		</table>
		</form>
<div class="gridDiv1" id="gridDiv1">
	
<r:grid sortable="true" remoteSort="true"  pagination="true" idField="uuid" editable="true"  singleEdit="true" url="" striped="true" fit="true" height="100%"  onSelect="testOnRelationSelect(a,b);" id="lrmsTaskRelation" onBeforeLoad="testabc();" rownumbers="false" singleSelect="true">
		<r:toolbar  text="操作" id="addRowProcess1" ></r:toolbar>
		<r:toolbar text="增加" iconCls="icon-add" onClick="btnAdd();"></r:toolbar>
		<r:toolbar text="编辑" iconCls="icon-edit" onClick="btnEdit();"></r:toolbar>
		<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelProcess1();"></r:toolbar>
		<r:toolbar text="删除" iconCls="icon-remove" onClick="btnDel();"></r:toolbar>
		<r:toolbar text="保存" iconCls="icon-save" onClick="save1();"></r:toolbar>
		<r:toolbar text="<input style='border: 1px #c0c0c0 solid; height: 20px; width:240px; margin-top:-25px' type='text' id='txt1' name='txt1' /><input type='button' style='height: 22px; margin-top:-25px' class='inputd' value='浏览' /><input class='input_file' type='file' id='upload1' name='upload1' onchange='txt1.value=this.value'/>"></r:toolbar>
		<r:col field="uuid" checkbox="true" editable="false"   width="150" rowspan="2">	</r:col>
		<r:col field="paramName" title="参数名称" editable="false"  sortable="true"   width="160"   dictId="lrms.paramName">
     	<r:editorDictSelect required="true" missingMessage="不能为空" panelHeight="230"></r:editorDictSelect>
		</r:col>
		<r:col field="limitTime" title="期限"  editable="false"  sortable="true"  width="140" rowspan="2" dictId="lrms.limitTime" >
		<r:editorDictSelect required="true" missingMessage="不能为空"></r:editorDictSelect>
		</r:col>
		<%--<r:col field="amount" title="发生金额" sortable="true"  width="120" rowspan="2">
		</r:col>--%>
		<r:col field="expiredChurnrate" title="到期流失率" sortable="true"  width="140" rowspan="2">
		</r:col>
		<r:col field="unexpiredChurnrate" title="未到期流失率" sortable="true"  width="140" rowspan="2">
		</r:col>
		<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="10" displayMsg="共 {total}条" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();" onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
</r:grid>
 <input type="text" name="processId1"  type="hidden" id="selectProcessId1"/>
</div>	
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
			var limitTime=changes[0].limitTime;
			var settingId=$('#selectProcessId1').val();
			var settDesc=$('#selectProcessId').val();
			var amount=changes[0].amount;
			var expiredChurnrate=changes[0].expiredChurnrate;
			var unexpiredChurnrate=changes[0].unexpiredChurnrate;
	
				if(uuid!=""){
					$.ajax({
						cache:false,
						type: 'post',
						dataType : "Json",
						data:{uuid:uuid,paramName:paramName,limitTime:limitTime,settingId:settingId,amount:amount,expiredChurnrate:expiredChurnrate,unexpiredChurnrate:unexpiredChurnrate,settDesc:settDesc},
						url: "cashParameter_save.action",
						success:function(data){
							var result=eval("(" + data + ")");
							if(result==1){
								$.messager.alert('系统提示','保存成功','warning');	
								lrmsCash.reload();	
								$('#editRowProcess1').removeAttr("disabled");
								$('#addRowProcess1').removeAttr("disabled");	
							//	 batchId=batchId1;
							}
							else if(result==2){
								lrmsCash.reload();	
								$('#editRowProcess1').removeAttr("disabled");
								$('#addRowProcess1').removeAttr("disabled");
								lrmsCash.reload();
								$.messager.alert('系统提示','数据重复','warning');
								lrmsCash.deleteRow(lrmsCash_index);
								
							}
							else if(result==3){
								$.messager.alert('系统提示','修改成功','warning');
								lrmsCash.reload();
								$('#editRowProcess1').removeAttr("disabled");
								$('#addRowProcess1').removeAttr("disabled");															
							}else  if(result==4)
							{
								$.messager.alert('系统提示','其他现金流不可以填写百分比！','warning');
								lrmsCash.reload();
								$('#editRowProcess1').removeAttr("disabled");
								$('#addRowProcess1').removeAttr("disabled");
							}
						}
					});
			}else{
				lrmsCash.endEdit(lrmsCash_index);
				lrmsCash_index = null;
				lrmsCash.rejectChanges();	
				$('#editRowProcess1').removeAttr("disabled");
				$('#addRowProcess1').removeAttr("disabled");
				$.messager.alert('系统提示','保存项有空值！','warning');	
						
			     }
			   }
			}
};
	
</script>
</html>

