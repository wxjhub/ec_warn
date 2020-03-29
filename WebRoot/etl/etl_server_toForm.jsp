<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>服务器管理</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/vipyhd.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
</style>
<script type="text/javascript">
//输入时候支持回车
		        $(function(){
		        	$("#serverId").focus();
		        	if('${server.serverId}'){
		        	    document.getElementById("serverId").readOnly=true;
		            }
		    		$("#reset").click(function(){
		    			if('${server.serverId}'){
		                    $('#serverId').val('${server.serverId}');
		                    $('#serverName').val('${server.serverName}');  
		                    $('#serverUrl').val('${server.serverUrl}');
		                    $('#serverPort').val('${server.serverPort}');
		                    $('#serverUserName').val('${server.serverUserName}');
		                    $('#serverPassWord').val('${server.serverPassWord}');
		                    $('#serverType').val('${server.serverType}');
		              	}else{
		              	  $('#serverId').val('');
		                  $('#serverName').val('');  
		                  $('#serverUrl').val('');
		                  $('#serverPort').val('');
		                  $('#serverUserName').val('');
		                  $('#serverPassWord').val('');
		                  $('#serverType').val('');
		                  }
		    			$('#formSave').form('validate');
		    		});
		        });
			 
			function changeFocus( )
			{
				//9 is [tab]
				//13 is [Enter] 
				if (event.keyCode==13)
				 event.keyCode=9;
			}
			document.onkeydown= changeFocus;
			
			function goBack(){
				 window.location.href = "${pageContext.request.contextPath}/etl/etl_server_list.jsp";
			}
			function saveServer(){
				
				var serverId=$("#serverId").val();
				var serverName=$("#serverName").val();
				var serverUrl=$("#serverUrl").val();
				var serverPort=$("#serverPort").val();
				var serverUserName=$("#serverUserName").val();
				var serverPassWord=$("#serverPassWord").val();
				var serverType=$("#serverType").val();
				
				if(serverId!=""){
						$.ajax({
							cache:false,
							type: 'post',
							dataType : "Json",
							data:{serverId:serverId,serverName:serverName,serverUrl:serverUrl,serverPort:serverPort,serverUserName:serverUserName,serverPassWord:serverPassWord,serverType:serverType},
							url: "server_saveServer.action",
							success:function(data){
									  if(date=1){
										  				$.messager.alert('系统提示','保存成功','warning');
														
														goBack();
												  }else{
													  $.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
														
													
												 	 	}
											}
						});

				}else{
							$.messager.alert('系统提示','保存项有空值！','warning');	
					}
			}

			
						
			
			$.extend($.fn.validatebox.defaults.rules, {
				serverId: {
			        validator: function (value) {
				        var serverId=$("#serverId").val();
				        var serverIdOld=$("#serverIdOld").val();
				        if(serverId=="" || value!=serverIdOld){
					        var exist=$.ajax({
					                url:"server_checkServerId.action",
					                data:{serverId:value},
					                async:false
					            }).responseText;
					        if(exist=="false"){
					            $.fn.validatebox.defaults.rules.serverId.message ="此服务器ID可以注册！";
					            return true;
					        }else{
					        	$.fn.validatebox.defaults.rules.serverId.message ="服务器ID重复，无法使用！";
					            return false;
						    }
				        }else{
				        	$.fn.validatebox.defaults.rules.serverId.message ="";
				            return true;
					    }
			    	},
			   		 message: ''
			 	}
		 		
			});

			function isIPyhd() {
				var serverUrlv=$("#serverUrl").val();
				if (""==(serverUrlv)) {
					
					$.messager.alert('系统提示','ip地址为空','warning');
					
					return false; 
				}else{
					//alert(serverUrlv);
					re=/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/g;//匹配ip地址的正则表达式 
						if(serverUrlv.match(re)){
							var arr=serverUrlv.split(".");
							for(var i=0;i<arr.length;i++){ 
							      if(arr[i]>256){
							    	  $.messager.alert('系统提示',arr[i]+"配置不对",'warning');
							    	  
							      }
							}
						}
							
				}
				return false; 
			}

			function isProtyhd(){
				var serverPortv=$("#serverPort").val();
				if (""==(serverPortv)) {
					 $.messager.alert('系统提示',"端口号为空",'warning');
			  		
					return false; 
				}
				var reg = /^\d+$/;
				if(serverPortv.match(reg)&&serverPortv<65535&&serverPortv>2008){
					}else{
						 $.messager.alert('系统提示',serverPortv+"配置不对希望大于2008并且不要也其他的端口号重复",'warning');
						
					}
				}
			
</script>
</head>
<body>
<div class="zhenghe_l" style="width: 800px;"><!-- overflow: scroll; -->
<TABLE border=0 style="width: 800px;">
	<TR>
		<TD noWrap height=24><h2><span class="blue" id="msg"></span></h2>
			<div id="tt" class="easyui-tabs" tools="#tab-tools" style="width:800px; height: 300px">
				<div title="服务器基本信息">
					<form name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;">
						<div id="myTab1_Content0" >
							<input type="hidden" id="uuid" name="uuid" value="${server.uuid}"></input>
							<table cellSpacing="0" cellpadding="0" border="0">
								<tr>
									<td width="80px" height="40px">服务器ID：</td>
									<td height="40px">
										<input type="hidden" id="serverIdOld" name="serverIdOld" value="${server.serverId}"></input>
										<input type="text" class="easyui-validatebox input_eq" required="true" missingMessage="该输入项为必输项" 
										style="width: 150px" 
										name="serverId" validType="serverId" id="serverId" value="${server.serverId}" onBlur="checkunique()"/>
										<font color="red"><span id="msg"></span></font>
									</td>
									<td width="80px" height="40px" style="padding-left: 20px">服务器名称：</td>
									<td height="40px"><input type="text" id="serverName" name="serverName" 
										class="easyui-validatebox input_eq" required="true" validType="serverName" style="width: 150px" 
										missingMessage="该输入项为必输项" value="${server.serverName}" onblur="vlidatioonFunction();"/>
									</td>
								</tr>
								
								<tr>
									<td width="80px" height="40px">服务器地址：</td>
									<td width="40px" height="40px" >
										<input onblur="isIPyhd();"  type="text" style="width: 150px" class="easyui-validatebox input_eq" required="true" missingMessage="该输入项为必输项"   id="serverUrl" name="serverUrl" validType="serverUrl" value="${server.serverUrl}">
									</td>
									<td width="80px" height="40px" style="padding-left: 20px">服务器端口：</td>
									<td width="40px" height="40px" >
										<input onblur="isProtyhd();" required="true" missingMessage="该输入项为必输项"  type="text" style="width: 150px" class="easyui-validatebox input_eq" id="serverPort"   name="serverPort" value="${server.serverPort}" >
									</td>
								</tr>
								<tr>
									<td width="80px" height="40px" >用户名：</td>
									<td width="40px" height="40px" ><input onblur="vlidatioonFunction();"   type="text" style="width: 150px"
										name="serverUserName" id="serverUserName"   value="${server.serverUserName}" class="easyui-validatebox input_eq"/>
									</td>
									<td width="80px" height="40px" style="padding-left: 20px">密码：</td>
									<td width="40px" height="40px" ><input onblur="vlidatioonFunction()3;"   type="password" style="width: 150px"
										name="serverPassWord" id="serverPassWord"   value="${server.serverPassWord}"class="easyui-validatebox input_eq" />
									</td>
								</tr>
								<tr>
									<td width="80px" height="40px">服务器类型：</td>
									<td width="40px" height="40px">
										<select name="serverType" class="easyui-combobox" missingMessage="此项为必输项" required="true" editable="false" id="serverType">
								 			<rmp:option dictId="etl.serverType" currentValue="${server.serverType}"></rmp:option>
										</select>
									</td>
									
								</tr>
							</table>
						</div>
					</form>
				</div>
			</div>
		</TD>
	</TR>
</TABLE>
	<div class="zh_btn" style="margin-right: 25px;">
	<input class="zh_btnbg2" type="button" id="submit" value="保存" onclick="saveServer();" />
	<input type="reset" id="reset" class="zh_btnbg2"
			value="重置" />
	<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" />
</div>				
</div>

</body>
</html>

