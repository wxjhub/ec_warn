<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8" />
<title>元数据模型和域信息</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/meta_icon.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/datagrid.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<style type="text/css">
.panel-body {
	overflow: auto;
	border: none;
	border-top-width: 0px;
}
</style>
<script type="text/javascript">

function toEditTrans(){
	var cks = document.getElementsByName("transId");
	 var counts=0;
	 var transId = "";
	 for(var i=0;i<cks.length;i++){
			if(cks[i].checked==true){
				counts++;
				transId = cks[i].value;
			}
	 }
	 if(counts==1){
		 window.location.href='${pageContext.request.contextPath}/queryTrans_xml_modify.action?&modelName=${modelName}&transId='+ transId;
		 return false;
	 }else if(counts>1){
		 $.messager.alert('系统提示','您当前要修改的查询交易过多，请选择一个进行修改！','warning');
	 }else{
		 $.messager.alert('系统提示','请选择要修改的查询交易！','warning');
	 }
}
function toRemoveTrans(){
	var cks = document.getElementsByName("transId");
	 var counts=0;
	 var transId = "";
	 for(var i=0;i<cks.length;i++){
			if(cks[i].checked==true){
				counts++;
				transId = cks[i].value;
			}
	 }
	 if(counts==1){
		 window.location.href='${pageContext.request.contextPath}/queryTrans_xml_remove.action?&modelName=${modelName}&transId='+ transId;
		 return false;
	 }else if(counts>1){
		 $.messager.alert('系统提示','一次只能删除一个查询交易！','warning');
	 }else{
		 $.messager.alert('系统提示','请选择要删除的查询交易！','warning');
	 }
}

function toAddTrans(){
	window.location.href="${pageContext.request.contextPath}/queryTrans_xml_toForm.action?modelName=${modelName}";
	return false;
}
</script>
</head>
<body>
<div class="panel datagrid">
	<div class="datagrid-wrap panel-body">
		<div class="datagrid-toolbar">
			<a style="float: left; " class="l-btn l-btn-plain" onclick="toAddTrans()">
				<span class="l-btn-left"><span class="icon-add">添加查询交易</span></span>
			</a>
			<a style="float: left; " class="l-btn l-btn-plain" onclick="toEditTrans()">
				<span class="l-btn-left"><span class="icon-edit">修改查询交易</span></span>
			</a>
			<a style="float: left; " class="l-btn l-btn-plain" onclick="toRemoveTrans()">
				<span class="l-btn-left"><span class="icon-remove">删除查询交易</span></span>
			</a>
		</div>
		
		<div class="datagrid-view" style="width:100%; height: 288px;">
			<div class="datagrid-view2" style="width:100%; left: 0px; ">
				<div class="datagrid-header" style="width:100%; height: 26px;">
					<div class="datagrid-header-inner" style="display: block; ">
						<table border="0" cellspacing="0" cellpadding="0" style="height:27px;">
							<tbody>
								<tr>
									<td><div class="datagrid-header-check"><input type="checkbox"/></div></td>
									<td><div class="datagrid-cell" style="width:15%; text-align: left;"><span>交易编号</span></div></td>
									<td><div class="datagrid-cell" style="width:20%; text-align: left;"><span>交易名称</span></div></td>
									<td><div class="datagrid-cell" style="width:10%; text-align: left;"><span>交易类型</span></div></td>
									<td><div class="datagrid-cell" style="width:15%; text-align: left;"><span>ModelName</span></div></td>
									<td><div class="datagrid-cell" style="width:20%; text-align: left;"><span>表名</span></div></td>
									<td><div class="datagrid-cell" style="width:20%; text-align: left;"><span>表中文名称</span></div></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				
				<div class="datagrid-body" style="width:100%; height: 261px;">
					<table cellspacing="0" cellpadding="0" border="0">
						<tbody>
						    <c:forEach  var="item" items="${requestScope.trans}" varStatus="status">
						    	<tr class="datagrid-row">
						    		<td><div class="datagrid-cell-check"><input type="checkbox" name="transId" value="${item.transId}"></div></td>
						    		<td>
										<div class="datagrid-cell" style="width:15%;text-align:left;height:auto;white-space:normal;">
									        <a href="${pageContext.request.contextPath}/queryTrans_xml_modify.action?modelName=${modelName}&transId=${item.transId}"> 
								        		${item.transId}
								        	</a>
							        	</div>
						    		</td>
						    		<td>
										<div class="datagrid-cell" style="width:20%;text-align:left;height:auto;white-space:normal;">
									        ${item.transName}
							        	</div>
						    		</td>
						    		<td>
										<div class="datagrid-cell" style="width:10%;text-align:left;height:auto;white-space:normal;">
									        ${item.transType}
							        	</div>
						    		</td>
						    		<td>
										<div class="datagrid-cell" style="width:15%;text-align:left;height:auto;white-space:normal;">
									    	${item.model.modelName}
							        	</div>
						    		</td>
						    		<td>
										<div class="datagrid-cell" style="width:20%;text-align:left;height:auto;white-space:normal;">
									        ${item.model.tableName}
							        	</div>
						    		</td>
						    		<td>
										<div class="datagrid-cell" style="width:20%;text-align:left;height:auto;white-space:normal;">
									        ${item.model.comment}
							        	</div>
						    		</td>
						    	</tr>
						    </c:forEach>
						</tbody>
					</table>
				</div>
				
			</div>
		</div>
	</div>
</div>
</body>
</html>
