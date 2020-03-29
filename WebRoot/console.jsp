<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<c:set var="col" value="3"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>我的工作台</title>
<style type="text/css">
.top_title{
	text-align:center;
	margin-top:3px;
	width: 100%;
}
.top_title table{
	border:1px solid #9CC2DA;
	height:29px;
	width:100%;
	line-height:26px;
	background:#fff url(../images/awp_titlebg.gif) repeat-x bottom;
	border-collapse:collapse;
}
.top_title td { 
	width:auto; 
}
.top_cus{ 
	float:left; 
	clear:both;
  	background: transparent url(images/Edit.png) no-repeat left center;
  	color:#00557D; 
  	margin-left:5px; 
  	padding:3px 0 0 20px;
}
.tableClass tr td{
    height : 28px;
    padding-right:10px;
}
</style>
<script type="text/javascript">
$(function(){
	var result = "${param.result}";
	if(result == "ok")
		$.messager.alert('系统提示','保存成功!','warning');
});

function portalTitleClick(e){
	$(e).removeAttr('readonly');
}
function savePortalEdit(){
	var portal = new Array();
	$.each($("input[portalId]"), function(i,data){
		var d = $(data);
		var name = d.attr("name");
		var portalId = d.attr("portalId");
		var temp = portal['_' + portalId];
		if(temp == undefined) {
			temp = new Object();
			portal['_' + portalId] = temp;
			temp.portalId = portalId;
		}
		if(name == 'display'){
			temp[name] = d.attr('checked') == undefined ? false : true;
		}else{
			temp[name] = d.val();
		}
	});
	
	var json = "[";
	var flag = false;
	for(var i in portal){
		if(flag){
			json += ",";
		}
		flag = true;
		json += "{";
		json += "'uuid':'" + portal[i].uuid + "',";
		json += "'userId':'" + portal[i].userId + "',";
		json += "'title':'" + portal[i].title + "',";
		json += "'display':'" + portal[i].display + "',";
		json += "'portalId':'" + portal[i].portalId + "',";
		json += "'columnIndex':'" + portal[i].columnIndex + "',";
		json += "'rowIndex':'" + portal[i].rowIndex + "'";
		json += "}";
	}
	json += "]";
	$("#json").attr('value',json);
	$("#portalEdit")[0].submit();
	
}
</script>
</head>


<body class="easyui-layout">
	<div region="north" border="true" style="background:#fff; height: 34px;">
		<div class='top_title' style="font-size: 13px;line-height: 22px;"><span class="top_cus"><strong>工作台设置</strong></span></div>
	</div>
	<div region="center" border="false" style="padding:10px;background:#fff;">
		<form id="portalEdit" action="${pageContext.request.contextPath}/portal_savePortalEdit.action" method="post">
			<input type="hidden" id="json" name="json">
		</form>
		
		<table class="tableClass">
			<tbody>
				<c:forEach var="portal" items="${portals}">
			
					<input class="portal_uuid" name="uuid" portalId="${portal.portalId}" type="hidden" value="${portal.uuid}"/>
					<input class="portal_userId" name="userId" portalId="${portal.portalId}" type="hidden" value="${portal.userId}"/>
					<input class="portal_rowIndex" name="rowIndex" portalId="${portal.portalId}" type="hidden" value="${portal.rowIndex}"/>
					<input class="portal_columnIndex" name="columnIndex" portalId="${portal.portalId}" type="hidden" value="${portal.columnIndex}"/>
				
					<c:set var="index" value="${index+1}" />
					<c:out value="${index%col eq 1 ? '<tr>':''}" escapeXml="false"/>
						
						<td>
							<input type="checkbox" name="display" portalId="${portal.portalId}" value="${portal.uuid}" <c:if test='${portal.display}'>checked='checked'</c:if>></input>
						</td>
						<td> 
							<input class="input_eq" type="text" name="title" portalId="${portal.portalId}" readonly="readonly" onclick="portalTitleClick(this);" value="${portal.title}"/>
						</td>
						<td></td>
					<c:out value="${index%col eq 0 || status.last ? '</tr>':''}" escapeXml="false"/>
				</c:forEach>
			</tbody>
		</table>
		<%-- 
		<c:forEach var="portal" items="${portals}">
			<input class="portal_display" type="checkbox" name="display" uuid="${portal.uuid}" value="${portal.uuid}" <c:if test='${portal.display}'>checked='checked'</c:if>></input> 
			<input class="portal_title" name="title" uuid="${portal.uuid}" readonly="readonly" onclick="portalTitleClick(this);" value="${portal.title}"/>
		</c:forEach>
		--%>
	</div>
	<div region="south" border="false" style="text-align:center;padding:5px 0;">
		<a class="easyui-linkbutton" iconCls="icon-ok" href="#" onclick="savePortalEdit();">保存</a><!--IE6-->
		<a class="easyui-linkbutton" iconCls="icon-cancel" href="#" onclick="closeModalCenter(true);">关闭</a>
	</div>
</body>
</html>

