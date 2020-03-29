<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://www.vprisk.com/tags/rmp"  prefix="rmp" %>
<%@ taglib uri="http://www.vprisk.com/tags/metadata"  prefix="meta" %>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>

<%
	response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setDateHeader("Expires", 0); //防止代理服务器缓
%>