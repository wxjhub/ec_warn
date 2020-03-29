<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String model = request.getParameter("modelName");
	String processId = request.getParameter("processId");
	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:js src="/default/date.js"></h:js>
<h:css src="/icon.css"></h:css>
<title>配置任务关系</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>

<script type="text/javascript">
var selectedIndex;
var selectedRelationIndex;
var TaskRelationData=function(){
	var uuid="";
	var processId="";
	var taskId="";
	var previousTaskId=""
	
};
function testOnSelect(rowIndex,rowData){
	selectedIndex=rowIndex;	
	processId=rowData.processId;
	etlTaskRelation.load({processId:processId});
}

function testOnRelationSelect(rowIndex,rowData){
	selectedRelationIndex=rowIndex;	
	TaskRelationData.uuid=rowData.uuid;
	TaskRelationData.processId=rowData.processId;
	TaskRelationData.taskId=rowData.taskId;
	TaskRelationData.previousTaskId=rowData.previousTaskId;
}

function save(){
	etlProcess.endEdit(lastIndex);
	var changes = etlProcess.getChanges('inserted'); 
	if(changes.length>1){
		$.messager.alert('系统提示','保存只能一个！','warning');
	}
	else{
		if(changes.length==0){
			changes = etlProcess.getChanges('updated');
		} 
		var uuid=changes[0].uuid;
		var processId=changes[0].processId;
		var processName=changes[0].processName;
		var useText=changes[0].useText;
		var createTime=changes[0].createTime;
		if(processId!=""){
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					data:{uuid:uuid,processId:processId,processName:processName,useText:useText,createTime:createTime},
					url: "process_save.action",
					success:function(data){
						var result=eval("(" + data + ")");
						if(result==1){
							$.messager.alert('系统提示','保存成功','warning');											
							goBack();
						}
						if(result==2){
							$.messager.alert('系统提示','存在此数据','warning');
						}
						else{
							$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																					
						}
					}
				});
		}
		else
		{
					$.messager.alert('系统提示','保存项有空值！','warning');	
		}
	}
}
function configRelation(){
	window.location.href = "${pageContext.request.contextPath}/process_toConfig.action?processId="
		+ processId;
}

function del(){
	var uuids = [];
	var selected = etlProcess.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    uuids.push(selected[i].uuid);
	}
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要删除的记录','warning');
		return;
	}else{
		$.ajax({
			cache:false,
			type: 'post',
			dataType : "Json",
			data:{uuid:uuids[0]},
			url: "process_remove.action",
			success:function(data){
				var result=eval("(" + data + ")");
				if(result==1){
					$.messager.alert('系统提示','删除成功','warning');
					etlProcess.reload();										
				}else{
					$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
				}
			}
		});
	}
}


function dblClickRow(rowIndex,rowData){    
	alert(rowData.realName);
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
	var newrow = {"processId":"","processName":"","useText":"","createTime":""};
	etlProcess.appendRow(newrow);
}
function selectRelationRow(rowIndex,rowData){	
	selectedRelationIndex=rowIndex;	
	processId=rowData.processId;
	etlTaskRelation.load({processId:processId});
}

function testInsertRow(){
	var rows = $('#userGrid').datagrid('getRows');
	var row = rows[1];
	row.realName = "在index为1处，插入一行";
	var param = {
			index:1,
			row:row
		};
	etlProcess.insertRow(param);
}
function testUpdateRow(){
	var rows = $('#userGrid').datagrid('getRows');
	var row = rows[1];
	row.realName = "更新首行数据";
	var param = {
			index:0,
			row:row
		};
	userGrid.updateRow(param);
}
function testDeleteRow(){
	userGrid.deleteRow(2);
}
function testValidateRow(){
	var flag = userGrid.validateRow(1);
	alert(flag);
}
function testRefreshRow(){
	userGrid.refreshRow(1);
}
function testReload(){
	userGrid.reload({a:32,abc:'abc'});
}
function testResize(){
	userGrid.resize({width:700,height:300});
}
function testOption(){
	var opt = userGrid.getOptions();      
	alert(opt.height);
}
function testGetChanges(){
	var changes = userGrid.getChanges();      
	var insertedchanges = userGrid.getChanges('inserted');      
	var deletedchanges = userGrid.getChanges('deleted');
	var updatedchanges = userGrid.getChanges('updated');
	alert('改变的数据有'+changes.length+'行，其中插入'+insertedchanges.length+'行，更新'+updatedchanges.length+'行，删除'+deletedchanges.length+'行');
}
function testAcceptChanges(){
	userGrid.acceptChanges();	      
}
function testRejectChanges(){
	userGrid.rejectChanges();      
}

function realNameFormat(value,rowData,rowIndex){
	return '<span style="color:red">' + rowData.userName + ' : 139********</span>';
}
function merge() {
	userGrid.mergeCells(2, "userName", 2, 1);
}
function unselect() {
	userGrid.unselectAll();
}
function selectAll(){
	userGrid.selectAll();
}
function test() {
	userGrid.selectRow(3);
}
function btnAdd(){
	window.location.href="${pageContext.request.contextPath}/taskRelation_toForm.action";
}
function btnEdit(){
	var taskId=[];
	var previousTaskId=[];
	var taskType=[];
	var selected = $('#etlTaskRelation').datagrid('getSelections');
	var processId=$("#oldprocessId").val();
	
		for(var i=0; i<selected.length; i++){
		    taskId.push(selected[i].taskId);
		    previousTaskId.push(selected[i].previousTaskId);
		    taskType.push(selected[i].taskType);
		}
		if(selected.length == 0) {
			$.messager.alert('系统提示','请选择要修改的任务组','warning');
			
			
			return;
		}
		if(selected.length >1) {
			$.messager.alert('系统提示','当前选择记录大于一个，请选择一个任务进行修改','warning');
			
			return;
		}else{
				window.location.href="${pageContext.request.contextPath}/taskRelation_to_Editor.action?uuid="+TaskRelationData.uuid+"&processId="+TaskRelationData.processId+"&taskId="+TaskRelationData.taskId+"&previousTaskId="+TaskRelationData.previousTaskId;
		}
}
function btnDel(){
	var uuids = [];
	var processIds=[];
	var taskIds=[];
	var selected = etlTaskRelation.getAllSelected();
	for(var i=0; i<selected.length; i++){
	    uuids.push(selected[i].uuid);
	    processIds.push(selected[i].processId);
	    taskIds.push(selected[i].taskId);
	}
	if(selected.length== 0) {
		$.messager.alert('系统提示','请选择要删除的记录','warning');
		return;
	}else{
		$.ajax({
			cache:false,
			type: 'post',
			dataType : "Json",
			data:{uuids:uuids[0],processId:processIds[0],taskId:taskIds[0]},
			url: "taskRelation_remove.action",
			success:function(data){
				var result=eval("(" + data + ")");
				if(result==1){
					$.messager.alert('系统提示','删除成功','warning');
					etlTaskRelation.reload();										
				}else{
					$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');																
				}
			}
		});
	}
}	
			//保存
			function saveTaskSelectList(){
						var taskIdOptionValues = "";
						var selectTaskRelation = document.getElementById("selectTaskRelation");
						var selectTaskRelationOptions = selectTaskRelation.options;
						for(var i=0;i<selectTaskRelationOptions.length;i++){
										if(taskIdOptionValues==null||taskIdOptionValues==""){
											taskIdOptionValues = selectTaskRelationOptions[i].value;//后置任务
										}else{
											taskIdOptionValues+=","+selectTaskRelationOptions[i].value;//后置任务
										}
							}
						
						var processId=$('#processName').val();//当前组
						var taskType=$('#currTask').val();//当前任务的类型
						var taskNamedq=$('#currTask').val();//dq任务

						//alert(processId+"-----"+taskType+"-----"+taskNamedq+"------"+taskIdOptionValues);
							$.ajax({
									cache:false,
									type: 'post',
									dataType : "Json",
									url: "taskRelation_saveRealtionTask.action?taskIdOptionValues="+taskIdOptionValues+"&taskType="+taskType+"&processId="+processId+"&taskNamedq="+taskNamedq,
									success:function(data){
											  if(date=1){
												  				$.messager.alert('系统提示','保存成功','warning');
																
																goBack();
														  }else{
															  $.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
																
															
														 	 	}
													}
								});

						
			}
			//返回
			function goBack(){
				window.location.href = "${pageContext.request.contextPath}/taskRelation_goBack.action?processId="+'${processId}';
			}
			
			$(function(){
				//初始化的时候光标停留的地方
				 //双击从左到右 
		        document.getElementById("taskRelationLeft").ondblclick=function(){
					var optionElements=this.getElementsByTagName("option");
					var selectElement=document.getElementById("selectTaskRelation");
					selectElement.appendChild(optionElements[this.selectedIndex]);
				};
				//双击从右到左
				document.getElementById("selectTaskRelation").ondblclick=function(){
		            var optionElements=this.getElementsByTagName("option");
		            var leftElement=document.getElementById("taskRelationLeft");
		            leftElement.appendChild(optionElements[this.selectedIndex]);
		 	    };
		 	   
		 				 	  
			changeOption();
			changeOption1();
			yhd();
		 });

		function yhd(){
			$('#preTaskTypeId').combobox({
				onSelect: function(record){
		 		changeOption1();
	 			}
	 		});
			$('#currTaskTypeId').combobox({
				onSelect: function(record){
		 		changeOption();
	 			}
	 		});
			
		}
		function changeOption(){
			//d
			var taskTypeId=$("#currTaskTypeId").combobox('getValue');
			$("#currTask").empty();
			$.ajax( {
				url : 'task_findTaskByTaskType.action',
				type : "POST",
				data : {taskTypeId:taskTypeId},
				dataType : "json",
				success : function(data) {
					var zNodes = eval(data);
					var sele = $("#currTask");
					for(var i=0;i<zNodes.length;i++){
						var v_taskName=zNodes[i].taskName;
						var v_taskId=zNodes[i].taskId;
						var v_taskType=zNodes[i].taskType;
						sele.append("<option value="+v_taskId+">"+ v_taskId+"</option>");
					}
				},
				error : function(data) {
					 $.messager.alert('系统提示','批次信息取值出错,请重试!','warning');
						
				}
			});
			}

		function changeOption1(){
			//q
			var taskType=$("#preTaskTypeId").combobox('getValue');
			//alert(taskType);
			$.ajax( {
				url : 'task_findTaskByTaskType.action?taskTypeId='+taskType,
				type : "POST",
				dataType : "json",
				success : function(data) {
					var zNodes = eval(data);
					var sele = $("#taskRelationLeft");
					sele.html("");
					for(var i=0;i<zNodes.length;i++){
						var v_taskName=zNodes[i].taskName;
						var v_taskId=zNodes[i].taskId;
						sele.append("<option value="+v_taskId+">"+ v_taskId+"</option>");
					}
					
				},
				error : function(data) {
					 $.messager.alert('系统提示','批次信息取值出错,请重试!','warning');
						
				}
			});
			
			}

		function clearSelectAndInput() {
			
				$("select[name='preTaskTypeId'] option").remove();
				$("select[name='taskRelationLeft'] option").remove();
				$("#taskRelationLeft").empty();
				$("#selectTaskRelation").empty();
				$("#taskText").val('','');
		} 

		$.extend($.fn.validatebox.defaults.rules, {
			
			processName: {
		        validator: function (value) {
			        var processName=$("#processName").val();
			      
			        if(!""==processName||!processName==null){
				            $.fn.validatebox.defaults.rules.processName.message ="请选择任务组！";
				            return true;
			        }else{
			        	$.fn.validatebox.defaults.rules.processName.message ="";
			            return true;
				    }
		    	},
		   		 message: ''
		 	}
		});

		function show4(){
			var win = $.messager.progress({
				title:'正在保存    请稍等......',
				msg:'正在加载  数据...'
			});
			setTimeout(function(){
				$.messager.progress('close');
			},5000);
		}
		 function queryTaskRelation(){
			 //查询框按钮
			 var taskId=$("#taskText").val();
				$.ajax({
					   type: "POST",
					   url: "taskRelation_findTaskByText.action",
					   data: {taskId:taskId},
					   success: function(msg){
						   	var data=$.parseJSON(msg);
							$("#taskRelationLeft").empty();
						   	for(var i=0;i<data.length;i++){
						   		var input_info=$("<option style='height:60px' value='"+data[i].taskId+"'>"+data[i].taskId+"</option>");
						   		$("#taskRelationLeft").append(input_info);
						   	}
					   }
				});//end ajax
         }
		 function checkPreTask(){
			 var taskIdOptionValues = "";
				var selectTaskRelation = document.getElementById("selectTaskRelation");
				var selectTaskRelationOptions = selectTaskRelation.options;
				for(var i=0;i<selectTaskRelationOptions.length;i++){
							if(taskIdOptionValues==null||taskIdOptionValues==""){
								taskIdOptionValues = selectTaskRelationOptions[i].value;//后置任务
							}else{
								taskIdOptionValues+=","+selectTaskRelationOptions[i].value;//后置任务
							}
				}
				
				var processId=$('#processName').val();
				var taskNamedq=$('#currTask').val();
				$.ajax({
					cache:false,
					type: 'post',
					dataType : "Json",
					url: "taskRelation_checkPreTask.action?taskIdOptionValues="+taskIdOptionValues+"&processId="+processId+"&taskNamedq="+taskNamedq,
					success:function(data){
							 if(data==1){
								 $.messager.confirm('检查框','数据配置无误.确定提交吗？',function(r){   
									     if (r){   
									    	 saveTaskSelectList();
									    }   
									 });  
							 }else if(data==0||data==2){
								 $.messager.confirm('检查框','数据配置有误！配置的数据中有重复的数据.',function(r){   
								 });  
							 }
						}
				});

			}

			function formatDate(value) {
				if(value!=null&&value!=""){
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
					return y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;
				}
			}
</script>
</head>
<body >
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
				<INPUT name="pageNo" id="pageNo" type="hidden" value="${param.pageNo}">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td height="40px">任务组编号：</td>
						<td height="40px">
								<input type="text" name="processId" id="processId" class="input_eq" style="width: 100px" /></td>
						<td height="40px">任务组名称：</td>
						<td height="40px">
								<input type="text" name="processName" id="processName" class="input_eq" style="width: 100px" /></td>
						<td>
								<input id="filter_submit" class="inputd" type="button" value="查 询" />
							    <input id="filter_reset" class="inputd" type="reset" value="重 置" />
						 </td>
					</tr>
				</table>
		</form>
		<div class="gridDiv" style="float:left;">
		<div class="clearfix" >
		<div class="processGrid" style="float:left;width:550px;">
					<r:grid pagination="true" idField="uuid" editable="true" url="process_findAllProcess.action" striped="true" height="300"  title="任务组管理" id="etlProcess"  onSelect="testOnSelect(a,b);" onBeforeLoad="testabc();" onDblClickRow="dblClickRow(ee,rr);">
						<r:toolbar text="增加" iconCls="icon-save" onClick="appendRow();"  ></r:toolbar>    
						<r:toolbar text="删除" iconCls="icon-save" onClick="del();"  ></r:toolbar>     			
						<r:toolbar text="保存" iconCls="icon-save" onClick="save();" ></r:toolbar>
						<r:col field="uuid" checkbox="true" editable="false" align="center" width="100" rowspan="2"></r:col>						  
						<r:col field="processId" title="任务组编号" align="center" width="100" rowspan="2"></r:col>
						<r:col field="processName" title="任务组名称" align="center" width="100" rowspan="2">
						</r:col>   
						<r:col field="useText" title="作用描述" align="center" width="150" rowspan="2" >   
						</r:col>    
						<r:col formatter="formatDate(value);" field="createTime" title="任务创建时间" align="center" width="150" rowspan="2">   				                 
						</r:col>
						<r:pagination id="pag" afterPageText="页" beforePageText="第" pageNO="2" total="99" pageSize="12" onBeforeRefresh="testBeforeLoad();" onRefresh="testBeforeLoad();"
				 		onSelectPage="testBeforeLoad();" showRefresh="testBeforeLoad();"></r:pagination>
					</r:grid>
		</div>
	<div class="zhenghe_l fl" style="width: 500px;float:left;position:relative;top:-30px;">
					<div title="任务关系信息"  class="easyui-tabs"  style="width:500px;height: 277px">
								<table>
									<TR>
										<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
											<form id="TaskRelationSearch" name="TaskRelationSearch" method="post">
													<table style="width: 470px;">
														<tr>
															<td width="100" align="center"><b>任务组编号:</b></td>
															<td style="" height="30px;" >
																<input type="text" name="processName" id="processName" value="${processId}" class="input_eq" style="width: 130px;" />
															</td >
														</tr>
														<tr>
															<td width="100" align="center"><b>任务分类:</b></td>
															<td height="30px;">	
																<select editable="false" name="currTaskTypeId" class="easyui-combobox"
						            								 id="currTaskTypeId"  style="width: 130px;" >
																	<c:forEach items="${taskTypes}" var="aw">
																		<option value='${aw.taskTypeId}'>${aw.taskTypeName}</option>
																	</c:forEach>
																</select>
															</td >
															<td width="100"><b>当前任务:</b></td>
															<td  style="">
																<SELECT editable="false"  name="currTask" id="currTask"  required="true" missingMessage="该输入项为必输项" style="width: 100px;"></SELECT>			
															</td>
														</tr>
														<tr>
															<td width="100" align="center"><b>前置任务分类:</b></td>				
															<td>
																<select editable="false" name="preTaskTypeId" class="easyui-combobox"
						            								 id="preTaskTypeId"  style="width:130px;">
																	<c:forEach items="${taskTypes}" var="aw">
																		<option value='${aw.taskTypeId}'>${aw.taskTypeName}</option>
																	</c:forEach>
																</select>
															</td>
															
															<td style="">
																<input name="taskText" id="taskText" class="input_eq" style="width: 120px;"/>
																&nbsp;
															</td>
															<td>
																<input class="inputd" type="button" value="查  询" onclick="queryTaskRelation()" />
															</td>
															
															
														</tr>
													</table>
													<div class="zh_btn" style="margin-right: 25px;position:relative;top:-30px;">
															<div style="float:left;background:#00ccff;">
																<select editable="false" size="10" id="taskRelationLeft" name="trtaskRelationLeft" class="input" style="width:150px;height:150px;" multiple="multiple" >
																</select>  
															</div>
															<div style="float:left;padding:5px 20px 0 20px;">
																<input type="button" value="" id="PutRightOne" class="add1" onclick="move('taskRelationLeft','selectTaskRelation')" /><br />
																<br /><br /><br /><br />
																<input type="button" value="" id="PutLeftOne" class="add3"  onclick="move('selectTaskRelation','taskRelationLeft')" /><br />
															</div>
															<div>
																<select editable="false" size="10" id="selectTaskRelation" name="selectTaskRelation" class="input" style="width:150px;height:150px;" multiple="multiple" >
																</select>
															</div>
													</div>
											</form>
										</TD>
									</TR>
								</table>
							</div>
						</div>

	</div>
	</div>
		<div class="zh_btn" style="margin-left:500px;">
						<input class="zh_btnbg2" type="button"  value="保存" onclick="checkPreTask();" />
						<input class="zh_btnbg2" type="button"  value="重置" onclick="clearSelectAndInput();" />
						<input class="zh_btnbg2" type="button"  value="返回" onclick="goBack();" />
		</div>
	
</body>
</html>