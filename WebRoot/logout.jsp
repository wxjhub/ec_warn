<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>无标题文档</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<style type="text/css">
	.loginbtn{
		background: url("images/logout_btn.png") no-repeat;
		width: 84px;
		height: 84px;
		cursor: pointer;
	}
	.loginbtn:HOVER{
		background: url("images/logout_btn_hover.png") no-repeat;
		width: 84px;
		height: 84px;
	}
</style>
<script type="text/javascript">
	function login() {
		window.location.href = "${pageContext.request.contextPath}/login.jsp";
	}
</script>
</head>

<body style="background: #ebf4fd">
	<center>
    <div class="welcome">
	    <div class="welcomebg">
	    	<div style="padding-top: 15%;position: relative;z-index: 2;margin-left: -100px;">
	    		<img alt="" src="images/logout_font.png"></img><br>
	    		<!-- <div class="loginbtn" onclick="login();"></div> -->
	    		<font color="#AFD152" size="3px" ><b>如需重新登录，请点击
	    		<a href="${pageContext.request.contextPath}/login.jsp"><font color="#AFD152" size="3px" ><b>[返回登陆界面]</b></font></a>
	    		</b></font>
	    			
	    	</div>
	    	<div style="position: absolute;bottom: 0;right: 0;margin-right: 30px;z-index: 1"><img src="images/map.png"></img></div>
	    </div>
    </div>
    </center>
</body>
</html>