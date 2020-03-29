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
<title>调度参数配置</title>
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
		
	
		function save_schedulerParam(){
			var flag = true;
			$('#schedulerParamFormSave input').each(function () {
			    if ($(this).attr('required') || $(this).attr('validType')) {
				    if (!$(this).validatebox('isValid')) {
				        flag = false;
				        disabled="true";
				        return;
				    }
			    }
			});

		
			if (flag){
			    document.forms['schedulerParamFormSave'].action="${pageContext.request.contextPath}/schedulerParam_save.action?flag="+$('#flag').val();
				document.forms['schedulerParamFormSave'].submit();
			}else{
			    $.messager.alert('系统提示','表单填写有误！','warning');
			}
			
		}
		function closeWin(){ 
			window.parent.ymPrompt.doHandler('close',true); 
		}

		var ff=document.getElementById("ff");
		

		function checkunique(){
			$.post( 
				"${pageContext.request.contextPath}/schedulerParam_checkunique.action",
			     {
				    paramId:$('#paramId').val()
				 },function (data){
					 var result=eval("(" + data + ")");
					 if(result==1)
					 {

						// $.messager.alert('存在此id的batch','warning');
						if($('#paramIdOld').val()==""){
							$("#warnMessage").show(4);
							
						}
						//$("#batchId").focus();

						

						
						 }	
					 if(result==0)
					 {
						// $.messager.alert('存在此id的batch','warning');

						$("#warnMessage").hide(4);

						
					 }					 					 
				 }

					 
					
			);
			}

	
        $(function(){
        	$("#paramId").focus();
        	if('${schedulerParam.paramId}'){
        	    document.getElementById("paramId").disabled=true;
            }
    		$("#reset").click(function(){
    			if('${schedulerParam.paramId}'){
                    $('#paramId').val('${schedulerParam.paramId}');
                    $('#paramName').val('${schedulerParam.paramName}'); 
                    $('#paramType').val('${schedulerParam.paramType}');  
                    $('#paramValue').val('${schedulerParam.paramValue}');   
                    $('#remark').val('${schedulerParam.remark}');  
                    
              	}else{
                    $('#paramId').val('');
                    $('#paramName').val('');  
                    $('#paramType').val('');  
                    $('#paramValue').val('');   
                    $('#remark').val(''); 
                  }
    			$('#schedulerParamFormSave').form('validate');
    		});
        });

    	$.extend($.fn.validatebox.defaults.rules, {
    		paramId:{
		       validator:function(value, param){
                  value=value.replace(/(^\s*)|(\s*$)/g, "");
    	                 $.fn.validatebox.defaults.rules.paramId.message = '只可输入(1-40)位的英文字母、数字和下划线';
    	                 return /^[a-zA-Z0-9_]{1,40}$/.test(value);
          },
          messsge:""

		},
    		paramName:{
                 validator:function(value,param){
                    value=value.replace(/(^\s*)|(\s*$)/g, "");
                    $.fn.validatebox.defaults.rules.paramName.message = '只可输入英文字母和中文';
                    return /^([\u4E00-\u9FA5a-zA-Z]+)$/.test(value);
                },
                message:""
	        }
    	});

		function goBack(){
			window.location.href = "${pageContext.request.contextPath}/etl/etl_schedulerParam_list.jsp";
		}
</script>
</head>
<body>
<div class="clearfix" >
<div class="zhenghe_l fl" style="width: 800px;"><!-- overflow: scroll; -->
<TABLE border=0 style="width: 800px;">
		<TR>
		<td noWrap height=24><h2><span class="blue" id="msg"></span></h2>
		<div id="tt" class="easyui-tabs"  style="width:800px;height: 350px">
			<div title="调度参数信息" >
				<table>
					<TR>
					<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
					<FORM name="schedulerParamFormSave" id="schedulerParamFormSave" method="post" style="padding-top: 25px">
					<input type="hidden" id="uuid" name="uuid" value="${schedulerParam.uuid}"></input>
					<input type="hidden" id="flag" name="flag" value="${flag}"></input>
					
					<div id="myTab1_Content0" >
						<table cellSpacing="0" cellpadding="0" border="0">
							<tr>
								<td width="100px" height="40px" >参数编号：</td>
								<td height="40px">
								<input type="hidden" id="paramIdOld" name="paramIdOld" value="${schedulerParam.paramId}"></input>
									<input type="text" onBlur="checkunique()"
									class="easyui-validatebox input_eq" required="true" validType="paramId" style="width: 150px" 
									missingMessage="只可输入(1-40)位的英文字母、数字和下划线"
									name="paramId" id="paramId" value="${schedulerParam.paramId}" />
									</td>
									<td width="150px"></td>
                                <div id="warnMessage" width="20px;" style="margin-top:11px;position:absolute;left:300px;display: none; color: red;">&nbsp;&nbsp;存在此ID</div>
								<td width="100px" height="40px" >参数名称：</td>
								<td height="40px">
								<input type="text" class="easyui-validatebox input_eq" required="true"
									missingMessage="请输入批次名称" style="width: 150px" 
									name="paramName"  id="paramName" value="${schedulerParam.paramName}"/>
									
								</td>
							</tr>
							<tr>
								<td width="100px" height="40px" >参数类型：</td>
								<td width="40px" height="40px">
									<select id="paramType" required="true" editable="false" missingMessage="请选择参数类型"
										name="paramType" class="easyui-combobox"  style="width: 150px;">
			                            <rmp:option dictId="etl.paramType"  currentValue="${schedulerParam.paramType}"></rmp:option>
									</select>
								</td>
								
						
								<td width="150px"></td>
							    <td width="100px" height="40px" >参数值：</td>
								<td height="40px"><input type="text"
									style="width: 150px" class="input_eq" name="paramValue" id="paramValue"
									value="${schedulerParam.paramValue}" /><span id="empNoTxt"></span></td>
							</tr>		
							<tr>
							    <td width="100px" height="40px" >作用描述：</td>
								<td height="40px"><input type="text"
									style="width: 150px" class="input_eq" name="remark" id="remark"
									value="${schedulerParam.remark}" /><span id="empNoTxt"></span></td>
							</tr>							
						</table>
					</div>
					</FORM>
					</TD>
				</TR>
				</table>
				<div class="zh_btn" style="margin-right: 25px;">
					<input class="zh_btnbg3" type="button" id="submit" onclick="save_schedulerParam()" value="保存基本信息"/>
					<input type="reset" id="reset" class="zh_btnbg2" value="重置" />
					<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" />
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