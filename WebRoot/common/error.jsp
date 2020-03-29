<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/rmp"  prefix="rmp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8"/>
		 <link rel="shortcut icon" href="${pageContext.request.contextPath}/images/favicon.ico">

		<script language="javascript">
			function goBack(){
				window.close();
			}
		</script>  
	<body >
		<c:choose>
			<c:when test="${errorMessage == null or errorMessage == ''}">
				<c:set var="message" value="${errorMsg}"></c:set>
			</c:when>
			<c:otherwise>
				<c:set var="message" value="${errorMessage}"></c:set>
			</c:otherwise>
		</c:choose>

		<c:if test="${message == null or message == ''}">
			<c:set var="message" value="操作失败，请联系管理员 ！"></c:set>
		</c:if>
		<div
			style="background: url(${pageContext.request.contextPath}/images/error.jpg) no-repeat center center; height:260px; "
			align="center">
			<div class="text" align="center" style="padding-top:120px;">
				<font style="font-size:14px;">
					${message}
				</font>
				<div class="text" align="center" style="padding-top:50px;">
					<input type="button" name="Submit" value="返回" style="width: 100px;"
						onclick="goBack()" />
				</div>
			</div>
		</div>
	</body>
</html>

