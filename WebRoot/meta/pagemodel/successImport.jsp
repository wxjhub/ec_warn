<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="${pageContext.request.contextPath}/common/css/common.css" rel="stylesheet" type="text/css" />
</head>
<body>
		<div style="background: url('${pageContext.request.contextPath}/images/error.jpg') no-repeat center 0%; height:252px; "
			align="center">
			<div class="text" align="center" style="padding-top:120px; width:290px; word-wrap:break-word" >
				<font style="font-size:14px;">
					<b>数据导入成功！成功导入${rowCount}条数据</b>
				</font>
			</div>
		</div>
</body>
</html>