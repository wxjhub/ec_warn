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
<title>添加任务组</title>
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

		function checkunique(){
			$.post( 
				"${pageContext.request.contextPath}/process_checkunique.action",
			     {
				    processId:$('#processId').val()
				 },function (data){
					 var result=eval("(" + data + ")");
					 if(result==1)
					 {
						// $.messager.alert('存在此id的task','warning');

						$("#warnMessage").show(4);
						$("#processId").focus();
						//$("#submit").attr("disabled", true);
						
						 }	
					 if(result==0)
					 {
						// $.messager.alert('存在此id的task','warning');
						$("#warnMessage").hide(4);
						$("#submit").attr("disabled", false);
						 }					 					 
				 }

					 
					
			);
			}

		$(function() {
			if($("#roleId").val()==""){
		  		$("#msg").text("任务组信息添加");
		  	 }else{
		  		$("#msg").text("任务组信息编辑");
		  	 }
			$('select').combobox({
				panelHeight:'100%'
			});
		});
        $(function(){
        	$("#processId").focus();
        	if('${process.processId}'){
        	    document.getElementById("processId").disabled=true;
            }
    		$("#reset").click(function(){
    			if('${process.processId}'){
                    $('#processId').val('${process.processId}');
                    $('#processName').val('${process.processName}');  
                    $('#useText').val('${process.useText}');  
                    $('#endDate').datebox('setValue','${process.endDate}');
              	}else{
              		$('#processId').val('');
                    $('#processName').val('');  
                    $('#useText').val('');  
                    $('#endDate').datebox('setValue','');
                  }
    			$('#processFormSave').form('validate');
    		});
        });

    	$.extend($.fn.validatebox.defaults.rules, {

    		processId:{
 		       validator:function(value, param){
                     value=value.replace(/(^\s*)|(\s*$)/g, "");
       	                 $.fn.validatebox.defaults.rules.processId.message = '只可输入(1-40)位的英文字母、数字和下划线';
       	                 return /^[a-zA-Z0-9_]{1,40}$/.test(value);
             },
             messsge:""

 		},
        	
    		processName:{
    		    validator:function(value, param){
                      value=value.replace(/(^\s*)|(\s*$)/g, "");
                    	  $.fn.validatebox.defaults.rules.processName.message = '只可输入英文字母、数字和下划线，注：必须以\"Process_\"开头';
                    	  return /^(Process_[0-9a-zA-Z_]+)$/.test(value);
		         },
		         messsge:""
    		},
                message:""
	    });

		function goBack(){
			window.location.href = "${pageContext.request.contextPath}/etl/etl_process_list.jsp";
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
		<div title="任务组基本信息">
		<table>
			<TR>
				<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
				<FORM name="processFormSave" id="processFormSave" method="post"
					style="padding-top: 25px"><input type="hidden" id="uuid"
					name="uuid" value="${process.uuid}"></input>
				<div id="myTab1_Content0">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td width="80px" height="40px">任务组编号：</td>
						<td height="40px"><input type="text" onBlur="checkunique()"
							class="easyui-validatebox input_eq" required="true"
							validType="processId" style="width: 150px"
							missingMessage="只可输入(1-40)位的英文字母、数字和下划线" name="processId"
							id="processId" value="${process.processId}" /></td>
						<div id="warnMessage" width="20px;" style="margin-top:11px;position:absolute;left:300px;display: none; color: red;">&nbsp;&nbsp;存在此ID</div>
					</tr>
					<tr>
						<td width="80px" height="40px">任务组名称：</td>
						<td height="40px"><input type="text"
							class="easyui-validatebox input_eq" style="width: 150px"
							missingMessage="请输入任务名称" name="processName" id="processName"
							value="${process.processName}" /></td>
					</tr>
					<tr>
						<td width="80px" height="40px">作用描述：</td>
						<td height="40px"><input type="text"
							class="easyui-validatebox input_eq" missingMessage="请输入任务脚本名称"
							style="width: 150px" name="useText" id="useText"
							value="${process.useText}" /></td>
					</tr>

					<tr>
						<td width="80px" height="40px">结束日期：</td>
						<td width="40px" height="40px"><input type="text"
							class="easyui-datebox" id="endDate" style="width: 150px"
							name="endDate" value="<fmt:formatDate value='${process.endDate}' pattern='yyyy-MM-dd'/>"/>
							</td>

					</tr>

				</table>
				</div>
				</FORM>
				</TD>
			</TR>
		</table>

		<div class="zh_btn" style="margin-right: 25px;"><input
			class="zh_btnbg3" type="button" id="submit" onclick="save_process()"
			value="保存基本信息" /> <input type="reset" id="reset" class="zh_btnbg2"
			value="重置" />
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