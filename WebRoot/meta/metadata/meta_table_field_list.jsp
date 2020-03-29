<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${model.comment}-${model.tableName}-元数据信息</title>
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
function loadMetaModelField(){
	var xform = window.parent.document.editForm;
	xform.action = "${pageContext.request.contextPath}/metaModelXml_loadField.action";
	xform.submit();
}

function toEdit(){
	var checkedArr = $("input[name='propertyNames']:checked");
	var counts = checkedArr.length; 
	if(counts==1){
	 	window.location.href='${pageContext.request.contextPath}/metaModelFieldXml_toForm.action?&modelName='+$('#modelName').val()+'&propertyName=' + checkedArr.val();
	 	return false;
	}else if(counts>1){
	 	$.messager.alert('系统提示','您当前要修改的元数据表过多，请选择一张表进行修改！','warning');
	}else{
	 	$.messager.alert('系统提示','请选择要修改的元数据表！','warning');
	}
}
function removeFields(){
	var checkedArr = $("input[name='propertyNames']:checked");
	var counts = checkedArr.length; 
	if(counts < 1){
 		$.messager.alert('系统提示','请至少选择一个字段进行删除！','warning');
	 	return false;
	 }

	$.messager.confirm('系统提示','确信要删除所选字段吗?',function(ok){
		if(!ok) return false;
		var xform = document.getElementById("formDel");
   		xform.action="${pageContext.request.contextPath}/metaModelFieldXml_removeFields.action";
   		xform.submit(); 
	});
}
</script>
</head>
<body>
	<div class="panel datagrid">
		<div class="datagrid-wrap panel-body">
			<div class="datagrid-toolbar">
				<a style="float: left; " class="l-btn l-btn-plain" onclick="loadMetaModelField();">
					<span class="l-btn-left"><span class="icon-add">加载新字段</span></span>
				</a>
				<a style="float: left; " class="l-btn l-btn-plain" onclick="toEdit()">
					<span class="l-btn-left"><span class="icon-edit">编辑字段</span></span>
				</a>
				<a style="float: left; " class="l-btn l-btn-plain" onclick="removeFields();">
					<span class="l-btn-left"><span class="icon-remove">删除选中字段</span></span>
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
										<td><div class="datagrid-cell" style="width:10%; text-align: left;"><span>属性</span></div></td>
										<td><div class="datagrid-cell" style="width:26%; text-align: left;"><span>属性类型</span></div></td>
										<td><div class="datagrid-cell" style="width:12%; text-align: left;"><span>字段</span></div></td>
										<td><div class="datagrid-cell" style="width:12%; text-align: left;"><span>视图label</span></div></td>
										<td><div class="datagrid-cell" style="width:8%; text-align: left;"><span>表单View</span></div></td>
										<td><div class="datagrid-cell" style="width:8%; text-align: left;"><span>字段类型</span></div></td>
										<td><div class="datagrid-cell" style="width:5%; text-align: left;"><span>关联类型</span></div></td>
										<td><div class="datagrid-cell" style="width:5%; text-align: left;"><span>关联模型</span></div></td>
										<td><div class="datagrid-cell" style="width:5%; text-align: left;"><span>标志位</span></div></td>
										<td><div class="datagrid-cell" style="width:5%; text-align: left;"><span>启用</span></div></td>
										<td><div class="datagrid-cell" style="width:4%; text-align: left;"><span>排序</span></div></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
				 	<form name="formDel" id="formDel" method="post">
				 	
			    	<input name="modelName" id="modelName" type="hidden" value="${model.modelName}">
			        <input type="hidden" name="methodCall" value="remove"/>
			        <input type="hidden" name="pageNo" value="${param.pageNo}"/>
			        <input type="hidden" name="smtId" value="${model.uuid}"/> 
			        <input type="hidden" id="pageConts" name="pageConts" value="${pageConts}"/>
					
					<div class="datagrid-body" style="width:100%; height: 261px;">
						<table cellspacing="0" cellpadding="0" border="0">
							<tbody>
							    <c:forEach  var="item" items="${requestScope.fields}" varStatus="status">
							    	<tr class="datagrid-row">
							    		<td><div class="datagrid-cell-check"><input type="checkbox" name="propertyNames" value="${item.propertyName}"></div></td>
							    		<td>
											<div class="datagrid-cell" style="width:10%;text-align:left;height:auto;white-space:normal;">
										        <a href="${pageContext.request.contextPath}/metaModelFieldXml_toForm.action?uuid=${item.uuid}&modelName=${item.model.modelName}&propertyName=${item.propertyName}"> 
										        	<c:out value="${item.propertyName}"/>
										        </a>
										        <c:if test="${item.isPrimaryKey eq '1'}">
										        	 <input type="hidden" id="primaryKeyPropertyType" value="${item.propertyType}">
										        </c:if>
								        	</div>
							    		</td>
							    		<td><div class="datagrid-cell" style="width:26%;text-align:left;height:auto;white-space:normal;">${item.propertyTypeShow}</div></td>
							    		<td><div class="datagrid-cell" style="width:12%;text-align:left;height:auto;white-space:normal;">${item.dbcolumn}</div></td>
							    		<td><div class="datagrid-cell" style="width:12%;text-align:left;height:auto;white-space:normal;">
								    		<c:if test="${i18n == '0'}">
									      	 	<c:out value="${item.view.label}"/>
									       	</c:if>
									       	<c:if test="${i18n != '0'}">
									       		<rmp:msg value="${item.view.label}"/>
									       	</c:if>
								       	</div></td>
							    		<td><div class="datagrid-cell" style="width:8%;text-align:left;height:auto;white-space:normal;"><rmp:dict dictId="meta.field.viewType" value="${item.view.type}"/></div></td>
							    		<td><div class="datagrid-cell" style="width:8%;text-align:left;height:auto;white-space:normal;"><c:out value="${item.dbtype}"/></div></td>
							    		<td><div class="datagrid-cell" style="width:5%;text-align:left;height:auto;white-space:normal;"><c:out value="${item.pkOrFk}&nbsp;${item.isBizKey eq '1'?'业务键':''}" escapeXml="false"/></div></td>
							    		<td><div class="datagrid-cell" style="width:5%;text-align:left;height:auto;white-space:normal;">
											<c:if test="${item.pkOrFk eq 'FK'}">
												<a href="${pageContext.request.contextPath}/metaModelXml_toForm.action?modelName=${item.refModel}" target="mainFrame">
													 <c:out value="${item.refModel}"/>
												</a> 
											</c:if>
											<c:if test="${item.pkOrFk eq 'DICT'}"><c:out value="${item.refModel}"/></c:if>
										</div></td>
							    		<td><div class="datagrid-cell" style="width:5%;text-align:left;height:auto;white-space:normal;"><rmp:dict dictId="sys.boolean" value="${item.isFlag}"/></div></td>
							    		<td><div class="datagrid-cell" style="width:5%;text-align:left;height:auto;white-space:normal;"><c:out value="${item.useFlag eq '0'?'禁用':'启用'}"/></div></td>
							    		<td>
							    			<div class="datagrid-cell" style="width:4%;text-align:left;height:auto;white-space:normal;">
							    				<c:out value="${item.orderSort}"/>
											</div>
										</td>
							    	</tr>
							    </c:forEach>
							</tbody>
						</table>
					</div>
					
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>