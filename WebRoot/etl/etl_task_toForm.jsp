<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String organStr=request.getParameter("organStr");
%>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>添加任务</title>
<link href="${pageContext.request.contextPath}/css/common.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/dialog.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/prettify.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/themes/icon.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"
	type="text/javascript"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script src="${pageContext.request.contextPath}/js/all.js"
	type="text/javascript"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/dialog.js"></script>

<script type="text/javascript">

		//输入时候支持回车
		  function changeFocus( )
		 {
		 	//9 is [tab]
			//13 is [Enter] 
			if (event.keyCode==13)
	    	 event.keyCode=9;
		}
		document.onkeydown= changeFocus;
		
	//
		function save_task(){

			var flag = true;
			$('#taskFormSave input').each(function () {
			    if ($(this).attr('required') || $(this).attr('validType')) {
				    if (!$(this).validatebox('isValid')) {
				        flag = false;
				        return;
				    }
			    }
			});

			if (flag){
			    document.forms['taskFormSave'].action="${pageContext.request.contextPath}/task_save.action";
				document.forms['taskFormSave'].submit();
			}else{
			    $.messager.alert('系统提示','表单填写有误！','warning');
			}
						
			
		}
		function closeWin(){ 
			window.parent.ymPrompt.doHandler('close',true); 
		}

		function isCheck(bo){
			var isBuy=document.getElementsByName("rolesRelIds");
			for(var i=0;i<isBuy.length;i++){
				if(isBuy[i].type=="checkbox"){
					isBuy[i].checked=bo;
				}
			}
		}
		
		function autoAddEvent(){
			var taskIdValue=$('#taskId').val();
			if(taskIdValue==""){
				$('#taskId').addEventListener("onBlur",checkunique);
			}else{

			}

		}
		
		function checkunique(){
		
			$.post( 
				"${pageContext.request.contextPath}/task_checkunique.action",
			     {
				    taskId:$('#taskId').val()
				 },function (data){
					 var result=eval("(" + data + ")");
					 if(result==1)
					 {
						// $.messager.alert('存在此id的task','warning');
						if($('#taskIdOld').val()==""){
							$("#warnMessage").show(4);
						}
						
						//$("#taskId").focus();
						///$("#submit").attr("disabled", true);
						
						 }	
					 if(result==0)
					 {
						// $.messager.alert('存在此id的task','warning');
						$("#warnMessage").hide(4);
						//$("#submit").attr("disabled", false);
						 }					 					 
				 }

					 
					
			);
			}

		$(function() {
			if($("#roleId").val()==""){
		  		$("#msg").text("任务信息添加");
		  	 }else{
		  		$("#msg").text("任务信息编辑");
		  	 }
			$('select').combobox({
				panelHeight:'100%'
			});
		});
        $(function(){
        	$("#taskId").focus();
        	if('${task.taskId}'){
        	    document.getElementById("taskId").readOnly=true;
            }
    		$("#reset").click(function(){
    			if('${task.taskId}'){
                    $('#taskId').val('${task.taskId}');
                    $('#taskDesc').val('${task.taskDesc}');  
                    $('#taskType').combobox('setValue','${task.taskType.taskTypeName}');
                    $('#scriptName').val('${task.scriptName}');
                    $('#taskName').val('${task.taskName}');
                    $('#scriptType').combobox('setValue','${task.scriptType}');
                    $('#server').combobox('setValue','${task.server.serverId}');
                    $('#useText').val('${task.useText}');
              	}else{
              	  $('#taskId').val('');
                  $('#taskDesc').val('');  
                  $('#taskType').combobox('setValue','');
                  $('#scriptName').val('');
                  $('#taskName').val('');
                  $('#scriptType').combobox('setValue','');
                  $('#server').combobox('setValue','');
                  $('#useText').val('');
                  }
    			$('#taskFormSave').form('validate');
    		});
        });

    	$.extend($.fn.validatebox.defaults.rules, {
        	
    		taskId:{
    		   validator:function(value, param){
                     value=value.replace(/(^\s*)|(\s*$)/g, "");
          	             $.fn.validatebox.defaults.rules.taskId.message = '只可输入(1-40)位的英文小写字母、数字和下划线';
          	             return /^[a-zA-Z0-9_]{1,40}$/.test(value);
                },
                messsge:""
    		},

        	
    		taskCode:{
    		    validator:function(value, param){
                      value=value.replace(/(^\s*)|(\s*$)/g, "");
                    	  $.fn.validatebox.defaults.rules.taskCode.message = '只可输入英文字母、数字和下划线，注：必须以\"Task_\"开头';
                    	  return /^(Task_[0-9a-zA-Z_]+)$/.test(value);
		         },
		         messsge:""
    		},
    	    taskName:{
                 validator:function(value,param){
                    value=value.replace(/(^\s*)|(\s*$)/g, "");
                    $.fn.validatebox.defaults.rules.taskName.message = '只可输入英文字母和中文';
                    return /^([\u4E00-\u9FA5a-zA-Z]+)$/.test(value);
                },
                message:""
	        }
    	});

		function goBack(){
			window.location.href = "${pageContext.request.contextPath}/etl/etl_task_list.jsp";
		}
</script>
</head>
<body>
<div class="clearfix">
<div class="zhenghe_l fl" style="width: 800px;"><!-- overflow: scroll; -->
<TABLE border=0 style="width: 800px;">
	<TR>
		<td noWrap height=24>
		<h2><span class="blue" id="msg"></span></h2>
		<div id="tt" class="easyui-tabs" style="width: 800px; height: 350px">
		<div title="任务基本信息">
		<table>
			<TR>
				<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
				<FORM name="taskFormSave" id="taskFormSave" method="post"
					style="padding-top: 25px">
				<input type="hidden" id="uuid" name="uuid" value="${task.uuid}"></input>
				<div id="myTab1_Content0">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td width="100px" height="40px">任务编号：</td>
						<td height="40px">
						<input type="hidden" id="taskIdOld" name="taskIdOld" value="${task.taskId}"></input>
						<input type="text" 
							class="easyui-validatebox input_eq" required="true" onBlur="checkunique()"
							validType="taskId" style="width: 200px" missingMessage="只可输入(1-40)位的英文字母、数字和下划线"
							name="taskId" id="taskId" value="${task.taskId}" />		
						</td>
						<div id="warnMessage" width="20px;" style="margin-top:11px;position:absolute;left:350px;display: none; color: red;">&nbsp;&nbsp;存在此ID</div>
                        <td width="100px" height="40px"></td>
						<td width="100px" height="40px">任务名称：</td>
						<td height="40px"><input type="text"
							class="easyui-validatebox input_eq" required="true"
							missingMessage="请输入任务名称" style="width: 200px" name="taskDesc"
							id="taskDesc" value="${task.taskDesc}" /></td>
					</tr>

					<tr>
						<td width="100px" height="40px">任务分类：</td>
						<td height="40px">
						<select name="taskTypeId" required="true" editable="false"
							class="easyui-combobox" id="taskType" missingMessage="请选择任务类型"
							validType="taskTypeId"  style="width: 200px;">
							    <option></option>
							<c:forEach items="${taskTypes}" var="aw">
							<c:if test="${aw.taskTypeName eq task.taskType.taskTypeName}">
								<option value='${aw.taskTypeId}' selected="selected">${aw.taskTypeName}</option>
							</c:if>
							<c:if test="${aw.taskTypeName ne task.taskType.taskTypeName}">
								<option value='${aw.taskTypeId}'>${aw.taskTypeName}</option>
							</c:if>
							</c:forEach>
							
						</select>
						</td>
						<td width="100px" height="40px"></td>
						<td width="100px" height="40px">任务脚本名称：</td>
						<td height="40px"><input type="text"
							class="easyui-validatebox input_eq" required="true" editable="false"
							missingMessage="请输入任务脚本名称" style="width: 200px" name="scriptName"
							id="scriptName" value="${task.scriptName}" /></td>
					</tr>
					<tr>
						<td width="100px" height="40px">程序名称：</td>
						<td height="40px"><input type="text"
							class="easyui-validatebox input_eq" required="true"
							missingMessage="请输入程序名称" style="width: 200px" name="taskName"
							id="taskName" value="${task.taskName}" /></td>
						<td width="100px" height="40px"></td>	
						<td width="100px" height="40px">任务脚本类型：</td>
						<td width="40px" height="40px"><select name="scriptType" editable="false"
							class="easyui-combobox" id="scriptType" style="width: 204px;">
							<rmp:option dictId="etl.script.type"
								currentValue="${task.scriptType}" prompt=""></rmp:option>
						</select></td>
					</tr>
					<tr>
						<td width="100px" height="40px">目标服务器ID：</td>
						<td width="40px" height="40px"><select name="server" required="true"
							class="easyui-combobox" id="server" missingMessage="该文本域不可为空"
							validType="serverName" style="width: 200px;">
							<option></option>
							<c:forEach items="${serverlist}" var="aw">
							<c:if test="${aw.serverId eq task.server.serverId}">
								<option value='${aw.serverId}' selected="selected">${aw.serverId}</option>
							</c:if>
							<c:if test="${aw.serverId ne task.server.serverId}">
								<option value='${aw.serverId}'>${aw.serverId}</option>
							</c:if>
							</c:forEach>
						</select></td>
                        <td width="100px" height="40px"></td>
						<td width="100px" height="40px">作用描述：</td>
						<td height="40px"><input type="text" style="width: 200px"
							class="input_eq" name="useText" id="useText"
							value="${task.useText}" /><span id="empNoTxt"></span></td>
					</tr>
				</table>
				</div>
				</FORM>
				</TD>
			</TR>
		</table>
		<div class="zh_btn" style="margin-right: 25px;"><input
			class="zh_btnbg3" type="button" id="submit" onclick="save_task()"
			value="保存基本信息" /> <input type="reset" id="reset" class="zh_btnbg2"value="重置" />
			<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回"/>
	    </div>
			
		</div>
		</div>
		</td>
	</TR>
</TABLE>
</div>
</div>

</body>
</html>