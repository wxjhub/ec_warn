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
<title>任务组状态管理</title>
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
		
	
		function save_task(){
		var flag = true;
		/*$('#taskFormSave input').each(function () {
		    if ($(this).attr('required') || $(this).attr('validType')) {
			    if (!$(this).validatebox('isValid')) {
			        flag = false;
			        return;
			    }
		    }
		});*/
		
		if (flag){
		    document.forms['taskFormSave'].action="${pageContext.request.contextPath}/processStatus_save.action";
			document.forms['taskFormSave'].submit();
		}
		else{
		    $.messager.alert('系统提示','表单填写有误！','warning');
		}
			
		}



		$(function() {
			if($("#roleId").val()==""){
		  		$("#msg").text("任务组运行状态信息添加");
		  	 }else{
		  		$("#msg").text("任务组运行状态信息编辑");
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
    			if('${processStatus.batchId}'){
        			
                    $('#batchId').val('${processStatus.batchId}');
              
                    $('#processId').val('${processStatus.processId}');  
                    $('#runFlag').combobox('setValue','${processStatus.runFlag}');
                    $('#runTime').val('${processStatus.runTime}');
                    $('#startTime').val('${processStatus.startTime}');
                    $('#endTime').val('${processStatus.endTime}');
              	}
    			$('#taskFormSave').form('validate');
    		});
        });

    	$.extend($.fn.validatebox.defaults.rules, {


    		taskId:{
    		   validator:function(value, param){
                     value=value.replace(/(^\s*)|(\s*$)/g, "");
          	             $.fn.validatebox.defaults.rules.taskId.message = '只可输入(1-16)位的英文字母、数字和下划线';
          	             return /^[a-zA-Z0-9_]{1,16}$/.test(value);
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
			window.location.href="${pageContext.request.contextPath}/batch_toStatusConfig.action?batchId="+$("#batchId").val();
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
		<div title="任务组运行状态基本信息">
		<table>
			<TR>
				<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
				<FORM name="taskFormSave" id="taskFormSave" method="post"
					style="padding-top: 25px">
				<input type="hidden" id="uuid" name="uuid" value="${processStatus.uuid}"></input>
				<div id="myTab1_Content0">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td width="100px" height="40px">批次编号：</td>
						<td height="40px"><input type="text" onBlur="checkunique()"
							class="easyui-validatebox input_eq" style="width: 150px" readonly="readonly"
							name="batchId" id="batchId" value="${processStatus.batchId}" />		
						</td>
						<td width="150px" height="40px"></td>
						<td width="100px" height="40px">任务组编号：</td>
						<td height="40px"><input type="text" onBlur="checkunique()"
							class="easyui-validatebox input_eq" style="width: 150px" readonly="readonly"
							name="processId" id="processId" value="${processStatus.processId}" />		
						</td>
						
					</tr>

					<tr>
					
                       
						<td width="100px" height="40px">运行状态：</td>
						<td height="40px">
						<select id="runFlag" required="true"  missingMessage="请选择运行状态"
						name="runFlag" class="easyui-combobox"  style="width: 150px;">
			                 <rmp:option dictId="etl.task.runflag"  currentValue="${processStatus.runFlag}"></rmp:option>
						</select></td>
						<td width="150px" height="40px"></td>
						<td width="100px" height="40px">运行时间：</td>
						<td height="40px"><input type="text"
							class="easyui-validatebox input_eq" 
							missingMessage="请输入程序名称" style="width: 150px" name="runTime"
							id="runTime" value="<fmt:formatDate value='${processStatus.runTime}' pattern='yyyy-MM-dd HH:mm:ss'/>" /></td>
					</tr>
					<tr>
						<td width="100px" height="40px">运行开始时间：</td>
						<td height="40px">
						<input type="text"
							class="easyui-validatebox input_eq" 
							missingMessage="请输入任务名称" style="width: 150px" name="startTime"
							id="startTime" value="<fmt:formatDate value='${processStatus.startTime}' pattern='yyyy-MM-dd HH:mm:ss'/>" />
						</td>
						<td width="150px" height="40px"></td>
						<td width="100px" height="40px">运行结束时间：</td>
						<td height="40px"><input type="text" 
							class="easyui-validatebox input_eq" 
							missingMessage="请输入任务脚本名称" style="width: 150px" name="endTime"
							id="endTime" value="<fmt:formatDate value='${processStatus.endTime}' pattern='yyyy-MM-dd HH:mm:ss'/>" /></td>
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