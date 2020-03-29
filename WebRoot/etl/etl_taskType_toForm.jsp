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
<title>添加任务分类</title>
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
			$('#taskTypeFormSave input').each(function () {
			    if ($(this).attr('required') || $(this).attr('validType')) {
				    if (!$(this).validatebox('isValid')) {
				        flag = false;
				        return;
				    }
			    }
			});
			
			if (flag){
			    document.forms['taskTypeFormSave'].action="${pageContext.request.contextPath}/taskType_save.action";
				document.forms['taskTypeFormSave'].submit();
			}
			else{
			    $.messager.alert('系统提示','表单填写有误！','warning');
			}
			
		}
		function closeWin(){ 
			window.parent.ymPrompt.doHandler('close',true); 
		}

		function checkunique(){
			$.post( 
				"${pageContext.request.contextPath}/taskType_checkunique.action",
			     {
					taskTypeName:$('#taskTypeName').val()
				 },function (data){
					 var result=eval("(" + data + ")");
					 if(result.flag==0&&'${task.taskTypeName}'=="")
					 {
						// $.messager.alert('存在此id的task','warning');

						$("#warnMessage").show(4);
						$("#taskTypeName").focus();
						 }	
					 if(result.flag==1)
					 {
						// $.messager.alert('存在此id的task','warning');

						$("#warnMessage").hide(4);
						 }					 					 
				 }

					 
					
			);
			}
		function goBack(){
			window.location.href = "${pageContext.request.contextPath}/etl/etl_taskType_list.jsp";
		}
        $(function(){
        	$("#batchId").focus();
        	if('${batch.batchId}'){
        	    document.getElementById("batchId").readOnly=true;
            }
    		$("#reset").click(function(){
    			if('${task.taskTypeName}'){
                    $('#taskTypeName').val('${task.taskTypeName}');
                    $('#taskTypeDesc').val('${task.taskTypeDesc}');  
              	}else{
                    $('#taskTypeName').val('');
                    $('#taskTypeDesc').val('');         
                  }
    			$('#batchFormSave').form('validate');
    		});
        });

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
		<div title="任务分类基本信息">
		<table>
			<TR>
				<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
				<FORM name="taskTypeFormSave" id="taskTypeFormSave" method="post"
					style="padding-top: 25px">
				<input type="hidden" id="taskTypeId" name="taskTypeId" value="${task.taskTypeId}"></input>
				<div id="myTab1_Content0">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td width="80px" height="40px">任务分类名称：</td>
						<td height="40px"><input type="text" onBlur="checkunique()"
							class="easyui-validatebox input_eq" required="true"
							style="width: 150px" missingMessage="只可输入(1-16)位的英文字母、数字和下划线"
							name="taskTypeName" id="taskTypeName" value="${task.taskTypeName}" />		
						</td>
						<div id="warnMessage" width="20px;" style="margin-top:11px;position:absolute;left:300px;display: none; color: red;">&nbsp;&nbsp;存在此任务分类</div>
						
                        <td width="150px" height="40px"></td>
						<td width="80px" height="40px">任务分类描述：</td>
						<td height="40px"><input type="text"
							class="easyui-validatebox input_eq" 
							missingMessage="请输入任务名称" style="width: 150px" name="taskTypeDesc"
							id="taskTypeDesc" value="${task.taskTypeDesc}" /></td>
					</tr>

				</table>
				</div>
				</FORM>
				</TD>
			</TR>
		</table>
		<div class="zh_btn" style="margin-right: 25px;"><input
			class="zh_btnbg3" type="button" id="submit" onclick="save_task()"
			value="保存基本信息" /> <input type="reset" id="reset" class="zh_btnbg2"
			value="重置" />
			<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" style="margin-top: 10px;" />
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