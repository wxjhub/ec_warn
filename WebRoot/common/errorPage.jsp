<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="${pageContext.request.contextPath}/common/css/common.css" rel="stylesheet" type="text/css" />
<!--<link rel="shortcut icon" href="${pageContext.request.contextPath}/common/imgs/favicon.ico">-->
<script language="javascript">
	function goBack(){
		window.history.back(-1);
	}
</script>  
</head>
<body bgcolor="#EFF3FF">
		<c:if test="${message == null or message == ''}">
			<c:set var="message" value="操作失败，请联系管理员 ！"></c:set>
		</c:if>
		<div align="center" style="background: url('${pageContext.request.contextPath}/common/imgs/error.jpg') no-repeat center 0%; height:260px; ">
			<div class="text" align="center" style="padding-top:120px; width:290px; word-wrap:break-word" >
				<font style="font-size:14px;">
					<b>${message}</b><br />
				</font>
				<div class="text" align="center" style="padding-top:50px;">
					<input type="button" name="Submit" value="返回" style="width: 100px;"
						onclick="goBack()" />
				</div>
			</div>
		</div>
		
</body>
</html>