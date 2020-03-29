<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@page import="com.vprisk.rmplatform.context.ContextHolder"%>
<%@ page import="org.springframework.security.AuthenticationException"%>
<%@ page import="org.springframework.security.userdetails.UsernameNotFoundException"%>
<%@ page import="org.springframework.security.BadCredentialsException"%>
<%@ page import="org.springframework.security.concurrent.ConcurrentLoginException"%>
<%@ page import="org.springframework.security.DisabledException"%>
<%@ page import="com.vprisk.rmplatform.util.StringUtil" %>

<%@page import="com.vprisk.rmplatform.components.log.service.OperationLogService"%>
<%@page import="com.vprisk.rmplatform.context.UserContext"%>
<%@page import="org.springframework.security.Authentication"%>
<%@page import="com.vprisk.rmplatform.components.security.userdetails.UserInfo"%>
<%@page import="org.springframework.security.context.SecurityContextHolder"%><html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>监控系统</title>
<link href="css/login.css" rel="stylesheet" type="text/css" />
<link href="css/themes/default/easyui.css" rel="stylesheet" type="text/css" />
<script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<link rel="icon" href="favicon.ico" type="image/x-icon" />
<link REL="SHORTCUT ICON" HREF="favicon.ico" type="image/x-icon" />
<style type="text/css">
html{
	overflow: hidden;
}
</style>
<script type="text/javascript">

   $(function(){
	//回车监听
	$("body").keyup(function(){
	    if(event.keyCode == 13){
	    	isLoginRepeat();
	    }
	});
	if (self != top)
	{
	   window.top.location = window.location;
	}
   });
   
	var messager = new Messager();
	var obj = new Object();
	function init(){
		document.getElementById("userName").focus();
		if (self != top)
		{
		   window.top.location = window.location;
		}
		obj.showType = "slide";
		obj.msg = "<div style=\"background:url(${pageContext.request.contextPath}/images/welcome_icon.png) no-repeat;height:100px;\">"+
		"<h1 style=\"color:#15428B;padding:15px 0 0 70px;\">中国邮政储蓄银行监控系统</h1></div>";
		obj.title = "欢迎进入";
		obj.timeout = 3000;
		obj.height = 150;
		obj.width = 300;
		<%
		try{
			ContextHolder.getBean("projectFirstBean");
		%>
			messager.show(obj);
		<%
			} catch(Exception e) {}
		%>
	}

	function validateVerifyCode(){
		var aa = document.getElementById("aa");
		var currCode = document.getElementById("verifyCode").value;
		aa.href ="validateCode.jsp?usecheckcode=true&verifyCode=" + currCode;
	}

	function resetInfo(){
		$("#login").form("clear");
	}

	function isLoginRepeat() {
		var username = $('#userName').val();
		$('#loginrepeat').datagrid({
			width:'100%',
			height:'100%',
			fit: true,
			nowrap: false,
			striped: true,
			collapsible:false,
			url:'${pageContext.request.contextPath}/isLogin_isLoginRepeat.action?username='+username,
			idField:'id',
			fitColumns:true,
			scroll:true,
			pagination:false,
			onLoadSuccess: function() { 
				var data=$('#loginrepeat').datagrid('getData');
			      if(data.rows.length == 0){  
			        //没有登录的相同用户直接登录 
			    	  $("#login").submit(); 	 
			       }else{//如果有登录的相同用户 弹出提示框
			    	  $("#relogin").window('open');   
			       }  
	        },
			columns:[[
				{field:'id', checkbox:true, width:20},
				{field:'username',title:'用户名', width:80},
				{field:'realname',title:'真实姓名', width:80},
				{field:'userIp',title:'IP地址', align:'center',width:100},
				{field:'createTime',title:'登录时间', width:150}
			]]
		
		});	
	} 
//取消按钮
function cancleInfo(){
	$("#relogin").window('close'); 
}
//登录不踢出其他用户
function loginonly(){
	$("#login").submit();	
}
//登录并踢出选择用户
function loginkick(){
	var selected = $('#loginrepeat').datagrid('getSelections');
	if(selected.length == 0) {
		$.messager.alertSelf('系统提示','请选择要踢出的用户','warning','160px','200px');
		return;
	}else{
		var str = "";
		for(var i=0; i<selected.length; i++) {
			str += "id=" + selected[i].id + "&";
		}
		$.ajax({
			url:'${pageContext.request.contextPath}/isLogin_loginkick.action',
			data:str,
	 	  	dataType:'text',
			type:'post',
			success:function(data){
							$("#login").submit();
						}
					});
				}
			}
</script>
</head>
<body onload="init()">
<div id="index_all" >
<div class="index_login width1000">
	<center style="padding-top: 19%;">
	<FORM name="login" action="login" method="post" id="login">
		<table border="0">
			<tr>
				<td valign="top" align="right" width="260px" style="padding-right: 30px;padding-top: 10px;">
					<table border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<img src="${pageContext.request.contextPath}/images/psbc_logo.png" style="float:right;"></img>
								</td>
						</tr>
						<tr>
							<td>
								<h1 style="font-size: 21px;color: #003A8F;padding-top:30px;text-align:center;">监控系统v1.0</h1>
							</td>
						</tr>
					</table>
				</td>
				<td width="260px" style="padding-left: 30px;padding-top: 15px;">
					<span>用户名：</span><input id="userName" class="inptxt" type="text" name="j_username" value="sysadmin"/><br><br>
					<span>密　码：</span><input id="password" class="inptxt1" type="password" name="j_password" value="000000"/>
					
					<!-- <span>用户名：</span><input id="userName" class="inptxt" type="text" name="j_username" value="sysadmin"/><br><br> 
					<span>密　码：</span><input id="password" class="inptxt1" type="password" name="j_password" value="111111"/>-->
					<br><br>
					<input class="index_btn" type="button" onclick="isLoginRepeat()" value="&gt; 登 录" style="height: 26px;margin-left: 62px"/>
					<input class="index_btn" type="button" value="&gt; 清 除" style="height: 26px;margin-left: 27px" onclick="resetInfo()"/>
					<br>
					
				</td>
			</tr>
			<tr>
				<td></td>
				<td align="left" style="padding-left: 100px;position: relative;top: -12px;">
					<%
					AuthenticationException ae = (AuthenticationException)request.getSession().getAttribute("SPRING_SECURITY_LAST_EXCEPTION");
					if(ae instanceof UsernameNotFoundException){  					
				        if(ae.getMessage().contains("No authentication")) {
				    		request.setAttribute("errMsg","<br>登录失败,用户无权限！");  
				    	} else if(ae.getMessage().contains("Connect refuse")) {
				    		request.setAttribute("errMsg","<br>登录失败,系统无法获取数据库连接！");
				    	} else if(ae.getMessage().contains("Not exist")) {
				    		
				    		request.setAttribute("errMsg","<br>登录失败,用户名不能为空！");
				    	} else { 
				    		request.setAttribute("errMsg","<br>登录失败,用户不存在！"); 
				    	}
				    }else if(ae instanceof BadCredentialsException){  
			    		request.setAttribute("errMsg","<br>登录失败,用户名/密码不正确！"); 
				    }else if(ae instanceof DisabledException){ 
				    	request.setAttribute("errMsg","<br>密码输入连续错误超过6次,用户已锁定！");   
				    }else if(ae instanceof ConcurrentLoginException) {
				    	request.setAttribute("errMsg","<br>登录失败,该用户已登录！");
				    } else {
				    	//request.setAttribute("errMsg","系统错误,请与管理员联系！"); 
				    }
					%>
					<span style="color: #000;font-size: 12px;">
					<% 
						if(StringUtil.isNotNullOrEmpty(request.getAttribute("errMsg"))) {
							out.print(request.getAttribute("errMsg"));

							//OperationLogService operationLogService = (OperationLogService)ContextHolder.getBean("operationLogService");
							//String ip = operationLogService.findLastLoginUserIp("sysadmin");
							//out.print(ip);
						} %>
					</span>
				</td>
			</tr>
		</table>
	</FORM>
	</center>
</div>
</div>
<div id="pagebottom" style="width:100%;background-image: url('${pageContext.request.contextPath}/images/bottombg.png');">
  	<center>
  	<!-- <div style="width: 310px;line-height: 27px;">
  		Copyright@2008-2012泛鹏天地科技有限公司版权所有
  	</div> -->
  	</center>
</div>
<!-- 登录提示弹出框 -->
<div id="relogin"  closed="true" modal="true" class="easyui-window" title="登录提示" 
				collapsible="false" minimizable="false" maximizable="false" style="background-color:#F1F1F1;width:430px;height:300px;">
<div style="background-color:#F1F1F1;width:430px;height:200px;" >
<table id="loginrepeat"></table>
</div>
<br/>
<div class="tool_btn" style="background-color:#F1F1F1;width:430px;height:50px;">
&nbsp;&nbsp;&nbsp;<input class="zh_btnbg3" type="button" id="loginkick" value="登录踢出选择用户" onclick="loginkick()"  />
<input type="button" id="loginonly" class="zh_btnbg3" value="登录不踢出" onclick="loginonly()"/>
<input type="button" class="zh_btnbg2" onclick="cancleInfo()" value="取消" />
</div>
</div>
</body>
</html>
