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
<title>添加批次</title>
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
		
	
		function save_batch(){
			var flag = true;
			$('#batchFormSave input').each(function () {
			    if ($(this).attr('required') || $(this).attr('validType')) {
				    if (!$(this).validatebox('isValid')) {
				        flag = false;
				        disabled="true";
				        return;
				    }
			    }
			});

		
			if (flag){
				document.getElementById("batchId").disabled=false;
				document.getElementById("startTime1").disabled=false;
				document.getElementById("endTime1").disabled=false;
			    document.forms['batchFormSave'].action="${pageContext.request.contextPath}/batch_save.action?flag="+$('#flag').val();
				document.forms['batchFormSave'].submit();
			}else{
			    $.messager.alert('系统提示','表单填写有误！','warning');
			}
			
		}
		function closeWin(){ 
			window.parent.ymPrompt.doHandler('close',true); 
		}

		var ff=document.getElementById("ff");
		
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
				"${pageContext.request.contextPath}/batch_checkunique.action",
			     {
				    batchId:$('#batchId').val()
				 },function (data){
					 var result=eval("(" + data + ")");
					 if(result==1)
					 {

						// $.messager.alert('存在此id的batch','warning');
						if($('#batchIdOld').val()==""){
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

		$(function() {
			if($("#roleId").val()==""){
		  		$("#msg").text("批次信息添加");
		  	 }else{
		  		$("#msg").text("批次信息编辑");
		  	 }
			$('select').combobox({
				panelHeight:'100%'
			});
		});
        $(function(){
        	$("#batchId").focus();
        	if('${batch.batchId}'){
        	    document.getElementById("batchId").disabled=true;
            }
    		$("#reset").click(function(){
    			if('${batch.batchId}'){
                    $('#batchId').val('${batch.batchId}');
                    $('#batchName').val('${batch.batchName}');  
                    $('#startTime1').val('${batch.startTime}');
                    $('#endTime1').val('${batch.endTime}');
                    $('#endDate').datebox('setValue','${batch.endDate}'); 
                    $('#dataDate').datebox('setValue','${batch.dataDate}');
                    $('#runFlag').combobox('setValue','${batch.runFlag}');
                    $('#useText').val('${batch.useText}');  
                    
              	}else{
                    $('#batchId').val('');
                    $('#batchName').val('');  
                    $('#startTime1').val('');
                    $('#endTime1').val('');
                    $('#endDate').datebox('setValue','');  
                    $('#dataDate').datebox('setValue','');
                    $('#runFlag').combobox('setValue','');
                    $('#useText').val(''); 
                  }
    			$('#batchFormSave').form('validate');
    		});
        });

    	$.extend($.fn.validatebox.defaults.rules, {
    		batchId:{
		       validator:function(value, param){
                  value=value.replace(/(^\s*)|(\s*$)/g, "");
    	                 $.fn.validatebox.defaults.rules.batchId.message = '只可输入(1-40)位的英文字母、数字和下划线';
    	                 return /^[a-zA-Z0-9_]{1,40}$/.test(value);
          },
          messsge:""

		},
        	
    		batchCode:{
    		    validator:function(value, param){
                      value=value.replace(/(^\s*)|(\s*$)/g, "");
                    	  $.fn.validatebox.defaults.rules.batchCode.message = '只可输入英文字母、数字和下划线';
                    	  return /^([0-9a-zA-Z_]+)$/.test(value);
		         },
		         messsge:""
    		},
    	    batchName:{
                 validator:function(value,param){
                    value=value.replace(/(^\s*)|(\s*$)/g, "");
                    $.fn.validatebox.defaults.rules.roleName.message = '只可输入英文字母和中文';
                    return /^([\u4E00-\u9FA5a-zA-Z]+)$/.test(value);
                },
                message:""
	        }
    	});

		function goBack(){
			window.location.href = "${pageContext.request.contextPath}/etl/etl_batch_list.jsp";
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
			<div title="批次基本信息" >
				<table>
					<TR>
					<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
					<FORM name="batchFormSave" id="batchFormSave" method="post" style="padding-top: 25px">
					<input type="hidden" id="uuid" name="uuid" value="${batch.uuid}"></input>
					<input type="hidden" id="flag" name="flag" value="${flag}"></input>
					<input type="hidden" id="createTime" name="createTime" value="${batch.createTime}"></input>
					
					<div id="myTab1_Content0" >
						<table cellSpacing="0" cellpadding="0" border="0">
							<tr>
								<td width="100px" height="40px" >批次编号：</td>
								<td height="40px">
								<input type="hidden" id="batchIdOld" name="batchIdOld" value="${batch.batchId}"></input>
									<input type="text" onBlur="checkunique()"
									class="easyui-validatebox input_eq" required="true" validType="batchId" style="width: 150px" 
									missingMessage="只可输入(1-40)位的英文字母、数字和下划线"
									name="batchId" id="batchId" value="${batch.batchId}" />
									</td>
									<td width="150px"></td>
                                <div id="warnMessage" width="20px;" style="margin-top:11px;position:absolute;left:300px;display: none; color: red;">&nbsp;&nbsp;存在此ID</div>
								<td width="100px" height="40px" >批次名称：</td>
								<td height="40px">
								<input type="text" class="easyui-validatebox input_eq" required="true"
									missingMessage="请输入批次名称" style="width: 150px" 
									name="batchName"  id="batchName" value="${batch.batchName}"/>
									
								</td>
							</tr>
							
							<tr>
								<td width="100px" height="40px" >任务开始时间：</td>
								<td height="40px">
								<input  type="text"  name="startTime1" disabled="true"
								 id="startTime1" value="<fmt:formatDate value='${batch.startTime}' pattern='yyyy-MM-dd HH:mm:ss'/>"/>								
								</td>
								<td width="150px"></td>
								<td width="100px" height="40px" >任务结束时间：</td>
								<td height="40px">
								<input  type="text" id="endTime1"  disabled="true" 
									name="endTime1"  value="<fmt:formatDate value='${batch.endTime}' pattern='yyyy-MM-dd HH:mm:ss'/>"/>
									
								</td>
							</tr>
								<tr>
								<td width="100px" height="40px" >数据日期：</td>
								<td width="40px" height="40px">
									<input type="text" id="dataDate" type="text" class="easyui-datebox" style="width: 150px"   missingMessage="请选择数据日期"
									name="dataDate"  value="<fmt:formatDate value='${batch.dataDate}' pattern='yyyy-MM-dd'/>"/>
								</td>
								<td width="150px"></td>
								<td width="100px" height="40px" >结束日期：</td>
								<td height="40px">
								<input type="text" class="easyui-datebox" style="width: 150px"
									name="endDate"  id="endDate" value="<fmt:formatDate value='${batch.endDate}' pattern='yyyy-MM-dd'/>"/>
								</td>
							</tr>
							<tr>
								<td width="100px" height="40px" >运行状态：</td>
								<td width="40px" height="40px">
									<select id="runFlag" required="true" editable="false" missingMessage="请选择运行状态"
										name="runFlag" class="easyui-combobox"  style="width: 150px;">
			                            <rmp:option dictId="etl.task.runflag"  currentValue="${batch.runFlag}"></rmp:option>
									</select>
								</td>
								
						
								<td width="150px"></td>
							    <td width="100px" height="40px" >作用描述：</td>
								<td height="40px"><input type="text"
									style="width: 150px" class="input_eq" name="useText" id="useText"
									value="${batch.useText}" /><span id="empNoTxt"></span></td>
							</tr>							
						</table>
					</div>
					</FORM>
					</TD>
				</TR>
				</table>
				<div class="zh_btn" style="margin-right: 25px;">
					<input class="zh_btnbg3" type="button" id="submit" onclick="save_batch()" value="保存基本信息"/>
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