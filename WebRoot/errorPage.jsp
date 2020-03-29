<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<script language="javascript">
	function goBack(){
		window.history.back(-1);
	}

	function closeErrorTab(){
		//证明是action过来的链接，关闭tab  
		if(document.referrer.indexOf("secMenu_toIndex.action") >= 0 ){
			//调用父页面（index.jsp）的top.tabcloseSelected方法，关闭当前选中的tab
			top.closeTabSelected(); 
		}else {
			window.history.back(-1);
		}
	}
	
</script>   
</head>
<body background="#E7F1FD">
	<c:if test="${message == null or message == ''}">
		<c:set var="message" value="操作失败，请联系管理员 ！"></c:set>
	</c:if>
	<div align="center" style="background: url('${pageContext.request.contextPath}/images/error.png') no-repeat center; height:330px;margin-top:8%">
		<div class="text" align="center" style="padding-top:160px; width:290px; word-wrap:break-word" >
			<div style="height: 90px;">
				<font style="font-size:14px;">
					<b><p id="_exception_info"><a id="_start_exception">${message}<a id="_end_exception"></b><br />
				</font>
			</div>
			<div class="text" align="center" style="padding-left: 20px;">
				<input type="button" class="rebackBtn" name="Submit" value="返&nbsp;&nbsp;回" onclick="closeErrorTab()" />
			</div>
		</div>
	</div>	
</body>
</html>