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
<title>添加任务组关系</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>

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
		
	
		function save_processrelation(){
		var flag = true;
		$('#processRelationFormSave input').each(function () {
		    if ($(this).attr('required') || $(this).attr('validType')) {
			    if (!$(this).validatebox('isValid')) {
			        flag = false;
			        return;
			    }
			    alert($('#processId').combobox('getValue'));
		    }
		   
		});


		if($('#processId').combobox('getValue')==""){
			 
             flag=false;
             $.messager.alert('系统提示','表单填写有误！','warning');
             return;
		}
		
		if (flag){
			document.getElementById("batchId").disabled=false;
		    document.forms['processRelationFormSave'].action="${pageContext.request.contextPath}/processRelation_save.action";
			document.forms['processRelationFormSave'].submit();
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

		$(function() {
			if($("#roleId").val()==""){
		  		$("#msg").text("任务组关系信息添加");
		  	 }else{
		  		$("#msg").text("任务组关系信息编辑");
		  	 }
			$('select').combobox({
				panelHeight:'100%'
			});
		});
        $(function(){
    		$("#reset").click(function(){
    			if('${processRelation.batchId}'){
                    $('#processId').combobox('setValue','${processRelation.processId}');  
                    $('#previousProcessId').combobox('setValue','${processRelation.previousProcessId}');
              	}else{
              		$('#processId').combobox('setValue','');  
                    $('#previousProcessId').combobox('setValue','');
                  }
    			$('#processRelationFormSave').form('validate');
    		});
        });

    	$.extend($.fn.validatebox.defaults.rules, {


    		processRelationId:{
		       validator:function(value, param){
                     value=value.replace(/(^\s*)|(\s*$)/g, "");
 	                 $.fn.validatebox.defaults.rules.processRelationId.message = '只可输入(1-16)位的英文字母、数字和下划线';
 	                 return /^[a-zA-Z0-9_]{1,16}$/.test(value);
                },
                messsge:""

		   },
    		
        	
		   processRelationCode:{
    		    validator:function(value, param){
                      value=value.replace(/(^\s*)|(\s*$)/g, "");
                    	  $.fn.validatebox.defaults.rules.processRelationCode.message = '只可输入英文字母、数字和下划线，注：必须以\"ROLE_\"开头';
                    	  return /^(ROLE_[0-9a-zA-Z_]+)$/.test(value);
		         },
		         messsge:""
    		},
    		processRelationName:{
                 validator:function(value,param){
                    value=value.replace(/(^\s*)|(\s*$)/g, "");
                    $.fn.validatebox.defaults.rules.processRelationName.message = '只可输入英文字母和中文';
                    return /^([\u4E00-\u9FA5a-zA-Z]+)$/.test(value);
                },
                message:""
	        }
    	});

		function goBack(){
			window.location.href="${pageContext.request.contextPath}/batch_toConfig.action?batchId="+'${batchId}';
		}
</script>
</head>
<body>
<div class="clearfix" >
<div class="zhenghe_l fl" style="width: 850px;"><!-- overflow: scroll; -->
<TABLE border=0 style="width: 850px;">
		<TR>
		<td noWrap height=24><h2><span class="blue" id="msg"></span></h2>
		<div id="tt" class="easyui-tabs"  style="width:850px;height: 250px">
			<div title="任务组关系信息" >
				<table>
					<TR>
					<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
					<FORM name="processRelationFormSave" id="processRelationFormSave" method="post" style="padding-top: 25px">
					<input type="hidden" id="batchId" name="uuid" value="${processRelation.uuid}"></input>
					<input type="hidden"  name="batchId" value="${batchId}" ></input>
					

					<div id="myTab1_Content0" >
						<table cellSpacing="0" cellpadding="0" border="0">
							<tr>
							    <td width="80px" height="40px">批次编号</td>
							    <td width="80px" height="40px">
							    <select style="154px;" disabled="true" id="batchId"><option>${batchId}
							    </option></select>
							    </td>
							    <td width="50px" heigth="40px"></td>
								<td width="80px" height="40px" >任务组编号：</td>
								<td height="40px">
									<select
										name="processId" class="easyui-combobox" id="processId" required="true" editable="false"
										style="width: 154px;">
										<option value='${processRelation.processId}'>${processRelation.processId}</option>
										<c:forEach items="${processlist}" var="aw">
										<c:if test="${aw.processId ne processRelation.processId}">
											<option value='${aw.processId}'>${aw.processId}</option>
										</c:if>					
										</c:forEach>
									</select>
									</td>
									<td width="50px" heigth="40px"></td>
								<td width="100px" height="40px" >前置任务组编号：</td>
								<td width="40px" height="40px">
									<select
										name="previousProcessId" class="easyui-combobox" id="previousProcessId" 
										style="width: 154px;">
										<option value='${processRelation.previousProcessId}'>${processRelation.previousProcessId}</option>
										<c:forEach items="${processlist}" var="aw">
										<c:if test="${aw.processId ne processRelation.previousProcessId}">
											<option value='${aw.processId}'>${aw.processId}</option>
										</c:if>					
										</c:forEach>
									</select>
								</td>
								
							</tr>						
						</table>
					</div>
					</FORM>
					</TD>
				</TR>
				</table>
				<div class="zh_btn" style="margin-right: 25px;margin-top:60px;">
					<input class="zh_btnbg3" type="button" id="submit" onclick="save_processrelation()" value="保存基本信息"/>
					<input type="reset" id="reset" class="zh_btnbg2" value="重置" />
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
﻿
