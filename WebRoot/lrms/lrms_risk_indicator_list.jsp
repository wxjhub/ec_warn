<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="http://www.vprisk.com/tags/rmp"  prefix="rmp" %>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流动性指标</title>
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
function success(data)
{
	$("#dataDate").datebox("setValue",data.lrms);
	//$("#dataDate").Value = "#" & data.lrms & "#";
	//$("#dataDate").datebox(data.lrms);
	if(0==data.total)
	{
		 $.messager.alert('系统提示',data.lrms+'号日期,没有数据！！！','warning');
	}
}
$(function(){
    $('#dataDate').datebox({   
     }); 
    	        
   
});
$(function(){
	$('.gridDiv').height($('.gridDiv').parent().parent()[0].clientHeight - 63);
});

								function getTemplate(){
									
									window.location.href="${pageContext.request.contextPath}/lrmsdownloadTemplate.action?modelName="+"Monitor";
								}
							
								function getTaskByPage(){
									var pageNo = $('#deptGrid').datagrid('getPager');
									var pageSize = $(pager).pagination("options");
									window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"SchedulerParam&pageSize="+pageSize+"&pageNo="+pageNo;
								}
							
								function getTaskByData(){
									var date=$("#dataDate").datebox('getValue');
									window.location.href="${pageContext.request.contextPath}/lrmsexportExcel.action?modelName="+"indicator&dataDate="+date;
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
										        	 url: "lrmsinputExcel_inputExcelMonitor.action?modelName="+"Monitor",
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
										                }  else{
										                	 messager.close();  
										                	 $.messager.alert('系统提示','导入成功！','warning');
										                	 lrmsMonitor.reload();
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
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">监测数据日期：<input id="dataDate" type="text"></td>
							<%-- <td height="40px">机构名称：</td>
			
				<td height="40px">
				
					<select name="paraName"   id="paraName" >
					    <rmp:option dictId="lrms.org"></rmp:option>    
					</select>
				</td>--%>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" />
					<input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	
		<div class="gridDiv">
			<r:grid sortable="true" remoteSort="true" pagination="true" idField="uuid" rownumbers="false" singleSelect="true" editable="false" url="risk_findAllRiskIndicator.action" striped="true" fit="true" height="100%" onLoadSuccess="success(data)" title="流动性指标" id="lrmsMonitor">
			<r:toolbar text="导出" iconCls="icon-export" onClick="getTaskByData();"></r:toolbar>
			<r:col  field="uuid" checkbox="true" editable="false"></r:col>   
			<r:col  field="targetId" title="指标名称"   editable="false"  sortable="true" width="170"  dictId="lrms.target.name">
			</r:col>
			<r:col field="asOfDate" sortable="true" title="数据日期"  editable="false" width="141">
				<r:editorDate required="true" editable="false"  format="yyyy-MM-dd"/>
			</r:col>
			<r:col field="orgId" title="机构名称" sortable="true" editable="false" width="150"  dictId="lrms.org">
			</r:col>    
			<r:col field="targetType" title="指标类型" sortable="true" editable="false" width="150"  dictId="lrms.target.type">
			</r:col>
			<r:col field="cny" title="人民币" sortable="true"  editable="false" width="158">
			</r:col>    
			<r:col field="foreignCurrency" title="外币" sortable="true"  width="150">
			</r:col> 
			<r:col field="foreignCurrencyAmout" title="本外币合计" sortable="true"  width="150">
			</r:col> 
		<r:pagination id="pag" pageList="5,10,15,20" pageSize="20"></r:pagination>
	</r:grid>
		
	</div>

</body>
<script>

function editParam(){
	  var changes = lrmsMonitor.getChanges();
	  if(!lrmsMonitor_index){
		  if(!(changes &&changes.length > 0)){
			var selected = lrmsMonitor.getAllSelected();
			if(selected.length==0){
				$.messager.alert('系统提示','请选择一个要编辑的！','warning');
			}else if(selected.length>1){
				$.messager.alert('系统提示','同时只能编辑一个！','warning');
			}else{
				var rownum = lrmsMonitor.getRowIndex(selected[0]);
				lrmsMonitor_index = rownum;
				lrmsMonitor.removeEditor(['uuid']);
				lrmsMonitor.beginEdit(rownum);
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
//$.extend($.fn.validatebox.defaults.rules, {
	//targetValidator: {
      //  validator: function (value) {
		//		  if(value){
			//	        var exist=$.ajax({
				//                url:"monitor_checkunique.action?targetName="+value,
				  //              data:{},
				    //            async:false
				      //      }).responseText;
				        //if(exist=="0"){
							// $.fn.validatebox.defaults.rules.targetValidator.message ="";
				            //return true;
				        //}else{
				        	//$.fn.validatebox.defaults.rules.targetValidator.message ="参数名称重复，无法使用！";
				            //return false;
					    //}
			        //}else{
			        	//$.fn.validatebox.defaults.rules.targetValidator.message ="";
			            //return true;
				    //}
	      
    	//},
   	//	 message: ''
 	//}
//});
function cancelEdit(){
	lrmsMonitor.endEdit(lrmsMonitor_index);
	lrmsMonitor_index = null;
	lrmsMonitor.rejectChanges();
	$('#editRow').removeAttr("disabled");
	$('#addRow').removeAttr("disabled");
}

//重置查询信息
function rese(){
	$('#paraName').val('');
	$('#scriptType').val('');
	$("#dataDate").datebox('setValue');
}

function submi(){
	var jsonData = {
			paraName:'0000',
			dataDate:$("#dataDate").datebox('getValue'),
			newpage:1,page:1
			};
	lrmsMonitor.load(jsonData);
	
}
function save(){
			lrmsMonitor.endEdit(lrmsMonitor_index);
			var vali = lrmsMonitor.validateRow(lrmsMonitor_index);
			if(vali){
				var selected = lrmsMonitor.getChanges('inserted');
				
				if(selected.length>1){
					$.messager.alert('系统提示','保存只能一个！','warning');
				}else{
					if(selected.length==0){
						selected = lrmsMonitor.getChanges('updated');
					}
					//if(selected.length==0){
						//$.messager.alert('系统提示','请选择编辑后再保存!','warning');
						//return;
					//}
					var uuid = selected[0].uuid;
					var targetName=selected[0].targetName;
					var dataDate=selected[0].dataDate;
					var currency=selected[0].currency;
					var monFlag=selected[0].monFlag;
					var monValue=selected[0].monValue;
					var warnValue=selected[0].warnValue;
					var resValue =selected[0].resValue;
					var reguValue=selected[0].reguValue;
					if(targetName!=""){
							$.ajax({
								cache:false,
								type: 'post',
								dataType : "Json",
								data:{uuid:uuid,targetName:targetName,dataDate:dataDate,currency:currency,monFlag:monFlag,warnValue:warnValue,resValue:resValue,reguValue:reguValue,monValue:monValue},
								url: "monitor_save.action",
								error:function(data){
											$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
									},
								success:function(data){
									
										  if(data=="1"){
											  
											  	$.messager.alert('系统提示','保存成功','warning');
											  	lrmsMonitor.reload();
											  	$('#editRow').removeAttr("disabled");
												$('#addRow').removeAttr("disabled");
												lrmsMonitor_index = null;
										}else if(data=="2"){
											$.messager.alert('系统提示','存在此数据','warning');
										  	lrmsMonitor.reload();
										  	$('#editRow').removeAttr("disabled");
											$('#addRow').removeAttr("disabled");
											lrmsMonitor_index = null;
											}
										else if(data=="3"){
										  	$.messager.alert('系统提示','修改成功','warning');
										  	lrmsMonitor.reload();
										  	$('#editRow').removeAttr("disabled");
											$('#addRow').removeAttr("disabled");
											lrmsMonitor_index = null;
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
		var selected = lrmsMonitor.getAllSelected();
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
					lrmsMonitor.reload();
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
		  var changes = lrmsMonitor.getChanges();
		  if(!lrmsMonitor_index&&!(changes &&changes.length > 0)){
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled','false');
			$('#addRow').attr('disabled','false');
			var newrow = {targetName:"",dataDate:"",currency:"",monFlag:"",monValue:"",warnValue:"",resValue:"",reguValue:""};
			//var edit =  {
				//	field:"targetName", 
					//editor:{
						//type:'validatebox',
						//options:{
							//validType:"targetValidator"
						//}
					//}
			//};
			lrmsMonitor.appendRow(newrow);
			var rows = lrmsMonitor.getRows();
			lrmsMonitor_index = rows.length-1;  
			lrmsMonitor.beginEdit(rows.length-1);
		  }else{
			  $.messager.alert('系统提示','当前有正在编辑！','warning');
			  }
	}


	function vvv(record){
		if (record.id=="1") {
			var e = lrmsMonitor.getEditor(
					{
						'index' : lrmsMonitor_index,
						'field' : 'serverId'
					}).target;
					e.combobox( {required : true,width:120});
			var editor = lrmsMonitor.getEditor(
							{
								'index' : lrmsMonitor_index,
								'field' : 'forecastType'
							});
			editor.target.combobox( {
						required : true,
						width:100
					});
		} else {
			var target = lrmsMonitor.getEditor(
					{
						'index' : lrmsMonitor_index,
						'field' : 'forecastType'
					}).target;
			target.combobox( {
						required : false,
						width:100
					});
			var editor = lrmsMonitor.getEditor(
					{
						'index' : lrmsMonitor_index,
						'field' : 'serverId'
					}).target;;
					editor.combobox( {required : false,width:120});
					//editor.target.validateBox('destroy');
				}
		}
	</script>
</html>

