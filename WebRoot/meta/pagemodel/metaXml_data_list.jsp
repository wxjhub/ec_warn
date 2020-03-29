<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<c:set var="_primaryKey" value="${queryTrans.model.primaryKey}" />
<c:set var="_logic" value="${'1' eq queryTrans.model.logFlag}" />
<c:set var="_modelName" value="${empty param.modelName ? queryTrans.model.modelName : param.modelName}" />
<c:set var="_action" value="metaxml" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参数管理或数据补录</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.autocomplete.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/meta_icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.autocomplete.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/datagrid.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/autocomplete.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script language="javascript">
$(function(){
	var basePath 			= 		"${pageContext.request.contextPath}/${_action}" ;
	var $_formSearch 		= 		$("#formSearch");
	var formSearch			=		$_formSearch[0];
	
	/*查询定义*/
	window.query = function (pageNo) {
		if(!validatorField())
			return false;
		
		if(!pageNo) pageNo = $("#pageNo").val();
		if(!pageNo) pageNo = 1;
		var pageSize = "";
		if($("#pageSize").length != 0)
			pageSize = $("#pageSize").val();
		if(!pageSize)
			pageSize = "";
		$_formSearch.append("<input type='hidden' value='"+pageNo+"' name='pageNo'/>");
		$_formSearch.append("<input type='hidden' value='"+pageSize+"' name='pageSize'/>");
		formSearch.action = basePath + "_query.action";
		formSearch.submit();
	};

	$("#filter_submit").click(function(){
		query(1);
	});

	/* 重置表单 */
	$("#filter_reset").click(function(){
		$.each($("[clearFlg]"), function(i, data){
			var $_data = $(data);
			var clearFlg = $_data.attr("clearFlg");
			if("text" == clearFlg) {
				$_data.val("");
			}else{
				$_data.combo("clear");
			}
		});
	});

	//批量删除
	$("#delete").click(function (){
		var selected = $("input[name='${_primaryKey}']:checked");
		if(selected.length < 1) {
			$.messager.alert('系统提示','请选择要删除的项目!','warning');
			return;
		}

		var ck = checkPermission(selected);
		if(!ck) {
			$.messager.alert('系统提示', "对不起, 您没有权限删除该数据！", 'warning');
			return false;
		}

		$.messager.confirm('系统提示','确定要删除所选择的记录吗?', function(ok){
			if(!ok) return false;

			var params = $("#userListForm").serialize();
			$.ajax({    
				  url:basePath + "_removeListItem.action",    
				  type:"POST",    
				  data:params,       
				  success:function(data){  	
						if(data.message!=null){
							var msg = eval("(" + data.message + ")");
							if(msg) 
								$.messager.alert('系统提示', msg.errorMsg, 'warning');
						} else {
							query(1);
						} 
				  }    
			});
		});
	});

	function checkPermission(selected) {
		var currentUser = "${requestScope.currentUser}";
		var result = true;
		$.each(selected, function(i,data){
			var createUser = $(data).attr("createUser");
			if(createUser && createUser != currentUser) {
				result = false;
			}
		});
		return result;
	};

	//导出Excel模版
	$("#downloadExcel").click(function(){
		formSearch.action = basePath + "_downloadTemplate.action";
		formSearch.submit();
	});

	//导出Excel
	$("#export").click(function(){
		formSearch.action = basePath + "_download.action";
		formSearch.submit();
	});

	//导入Excel
	var $_importWindow = $("#importWindow");
	$("#import").click(function(){
		$_importWindow.window("open");
	});

	$_importWindow.window({
		title:"参数导入",
		iconCls:"import",
		href:basePath + "_toImportForm.action?modelName=${_modelName}",
		modal:true,
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:true,
		width:"540",
		height:"385",
		onLoad:function(){
			$("#closebt").click(function(){
				$_importWindow.window("close");
				$_importWindow.window("refresh");
			});

			$("#importbt").click(function(){
				var checkValue = true;
				if(!$("#importMode").combobox("getValue")){
					$("#importModeMsg").html("* 请选择导入方式!");
					checkValue = false;
				}else{
					$("#importModeMsg").html("");
				}

				if(!$("#importFile").val()){
					$("#fileMsg").html("* 请选择要导入的excel文件!");
					checkValue = false;
				}else{
					$("#fileMsg").html("");
				}

				if(checkValue){
					$_importWindow.isImport = true;
					$("#promptArea").css({display:"none"});
					$("#commitArea").css({display:""});
					var xform = document.getElementById("xform");
					xform.submit();
				}
			});

			$("#importMode").combobox({panelHeight:"100%"});
		},
		onClose:function(){
			if($_importWindow.isImport)
				query(1);
		}
	});

	//复核数据
	$("#audit").click(function(){
		var selected = $("input[name='${_primaryKey}']:checked");
		if(selected.length == 0) {
			$.messager.alert('系统提示','请选择要复核的项目!','warning');
			return false;
		}

		if(selected.length > 1) {
			$.messager.alert('系统提示','复核时只能选择一项!','warning');
			return false;
		}
		var id = selected.val();
		window.location = basePath + "_toForm.action?modelName=${_modelName}&transId=${param.transId}&${_primaryKey}=" + id + "&isAudit=true";
		return false;
	});

	$("#add").click(function(){
	   	var tt = "${queryTrans.transType}";
	   	tt = "";  //关闭可编辑查询
	   	if(tt=='EDIT_QUERY'){
	   		$_formSearch.append("<input type='hidden' value='toAdd' name='_pageAction'/>");
	   		query();  
	   	}else{
	   		window.location = basePath + "_toForm.action?modelName=${_modelName}&transId=${param.transId}&_pageAction=add";
	   		return false;
	   	}
	});

	$("#edit").click(function(){
		var selected = $("input[name='${_primaryKey}']:checked");
		if(selected.length == 0) {
			$.messager.alert('系统提示','请选择要修改的项目!','warning');
			return false;
		}

		if(selected.length > 1) {
			$.messager.alert('系统提示','修改时只能选择一项!','warning');
			return false;
		}

		var ck = checkPermission(selected);
		if(!ck) {
			$.messager.alert('系统提示', "对不起, 您没有权限修改该数据！", 'warning');
			return false;
		}
		
		var id = selected.val();
		toEdit2(id);
	});

	window.toEdit2 = function (id, createUser){
		
		var currentUser = "${requestScope.currentUser}";
		if(createUser && createUser != currentUser) {
			$.messager.alert('系统提示', "对不起, 您没有权限修改该数据！", 'warning');
			return false;
		}
		
		var tt = "${queryTrans.transType}";
		tt = "";  //关闭可编辑查询
		if(tt=='EDIT_QUERY' && id){
			$_formSearch.append("<input type='hidden' value='"+id+"' name='${_primaryKey}'/>");
			query();
		} else {
			window.location = basePath + "_toForm.action?modelName=${_modelName}&transId=${param.transId}&${_primaryKey}=" + id;
			return false;
		}
	};

	$("#cancelEdit").click(function(){
		query();
	});

	$("#saveListItem").click(function(){
		$("#userListForm :checked").attr("checked", false);
		var params = $("#userListForm").serialize();
		$.ajax({    
			url:basePath + "_saveListItem.action",    
			type:"post",    
			data:params, 
			dataType:"json",
			success:function(data){  
				if(data.message!=null){
					var msg = eval("(" + data.message + ")");
					if(msg)
						$.messager.alert('系统提示',msg.errorMsg,'warning');
				} else {
					query();
				} 
  			}    
		});
	});

	$("#checkrelation").click(function(){
		var modelName = document.getElementsByName("modelName")[0].value;
		$.ajax({
			url:"${pageContext.request.contextPath}/validation.action",    
			type:"post",    
			data:"modelName=" + modelName,    
			dataType:"json",    
			success:function(data){
				$.messager.alert('系统提示',data.message,'warning');
		  	},
		  	error:function(data){
		  		$.messager.alert('系统提示','获取失败','warning');
			}
		});
	});

	$.each($("#formSearch input[refModel]"), function(i, obj){
		var $_obj = $(obj);
		$_obj.combotree({
			url:"metadataJson_getTreeRootJson.action?modelName=" + $_obj.attr("refModel"),
			value:$_obj.attr("currentValue"),
			onClick:function(node){
				if($_obj.attr("refModel")=="product" && node.state){
					$_obj.combotree("clear");
					$.messager.alert('系统提示','该节点下包含叶子节点，请重新选择','warning');
					return false;
				}
			}
		});
	});
	
});

function changelist(val){
	 var modelName = document.getElementsByName("modelName")[0].value;
	 if(modelName == "taskRelation"){
		 $.ajax({    
			  url:"${pageContext.request.contextPath}/findTaskByProcess.action",    
			  type:"post",    
			  data:'processId='+val.value,    
			  dataType:"json",    
			  success:function(data){
				  //alert(data.taskList.String[0]);
				  var arr = data.taskList;
				  var obj = document.getElementsByName("task")[1];
				  for(var i=obj.options.length;i>0;i--){
					  obj.options.remove(i);   
				  }

				  for(var i=0;i<arr.length;i++){
					  obj.options.add(new Option(arr[i][1],arr[i][0]));  
				  }
				  obj = document.getElementsByName("nextTask")[1];
				  for(var i=obj.options.length;i>0;i--){
					  obj.options.remove(i);   
				  }

				  for(var i=0;i<arr.length;i++){
					  obj.options.add(new Option(arr[i][1],arr[i][0]));  
				  }
			  },error:function(data){
				  $.messager.alert('系统提示','获取失败','warning');
 		 	} 
		}); 
	}
}

function popTree(fieldId, refModel, refModelPkProp, refModelNameProp){
	loadTree("${pageContext.request.contextPath}/meta/pagemodel/popTree.jsp", fieldId, refModel, refModelPkProp, refModelNameProp);
}

function popLazyTree(fieldId, refModel, refModelPkProp, refModelNameProp){
	loadTree("${pageContext.request.contextPath}/meta/pagemodel/popLazyTreeWithRoot.jsp", fieldId, refModel, refModelPkProp, refModelNameProp);
}

function loadTree(url, fieldId, refModel, refModelPkProp, refModelNameProp){
	var page= url + "?modelName="+refModel+"&refModelPkProp=" + refModelPkProp + "&refModelNameProp=" + refModelNameProp;

	showModalCenter (encodeURI(page), function(ret){
		if(ret != null && ret != '0'){
			var idAndName=ret.split(",");
			$("#"+ fieldId + "QueryField").val(idAndName[0]);
			$("#"+ fieldId + "QueryFieldText").val(idAndName[1]);
		}
	}, "350", "500", "");
	
	//var ret=window.showModalDialog(encodeURI(page),window,"dialogWidth:350px;center:yes;help:no;scroll:yes;status:no;dialogHeight:500px");
	
}

function popLazyTree2(fieldId, refModel){
	var page="${pageContext.request.contextPath}/meta/pagemodel/popLazyTreeWithRoot.jsp?modelName="+refModel;
	var ret=window.showModalDialog(encodeURI(page),window,"dialogWidth:350px;center:yes;help:no;scroll:yes;status:no;dialogHeight:500px");
	if(ret != null && ret != '0'){
		var idAndName=ret.split(",");
		$("#"+ fieldId + "ListField").val(idAndName[0]);
		$("#"+ fieldId + "ListFieldText").val(idAndName[1]);
	}else if(ret == '0'){
		$.messager.alert('系统提示','加载树结构数据出现异常，请重新选择!','warning');
	}
}

function validatorField(){
	var flag = true;
	$("[validType]").each(function () {
		var $_temp = $(this);
		if($_temp.attr("class").indexOf("easyui-combo") > -1) {
			if(!$_temp.combobox("isValid"))
				flag = false;
		} else if($_temp.attr("class").indexOf("easyui-date") > -1){
			if(!$_temp.datebox("isValid"))
				flag = false;
		} else if (!$_temp.validatebox('isValid')) {
			    flag = false;
		}
	});
	return flag;
}

$.extend($.fn.validatebox.defaults.rules, {
	fieldName:{
	    validator:function(value, param){
    		var result = true;
			var validateFlag = param[0];
    		
    		var id = validateFlag.id;
    		if(!id) return true;

    		var $_begin = $("#" + id + "Begin");
    		var $_end = $("#" + id + "End")
    		var beginValue;
    		var endValue;
    		if($_begin.attr("class").indexOf("date") > -1) {
    			beginValue = Date.parse($_begin.datebox("getValue"));
    			endValue = Date.parse($_end.datebox("getValue"));
    		} else {
    			beginValue = $_begin.val();
    			endValue = $_end.val();
        	}

    		if (!isNaN(beginValue) && !isNaN(endValue)) {
        		result = beginValue <= endValue;
    		}
    		return result;
	     },
	     message:"结束值不能小于开始值!"
 	}
});

function setAutoText(id, value){
	$('#' + id).val(value);
}
</script>
</head>

<body>  
<!--**********************************************************************-->
<!-- 查询字段 -->
<c:set var="isDisplayButton" value="${queryTrans.displayQueryButtonAndReset}"/>
<div style="padding:30px;">
<form name="formSearch" id="formSearch" method="post">
	<input name="modelName" type="hidden" value="${_modelName}">
	<input name="logic" type="hidden" value="${_logic}">
	<input name="transId" type="hidden" value="${param.transId}">
	<c:if test="${isDisplayButton}">
	<div style="margin-top: -10px; padding-bottom: 20px;">
		<c:out value="<table cellSpacing='0' cellpadding='0' border='0' style='table-layout:fixed;width:100%'><tr><td>" escapeXml="false"/>
		<c:forEach var="item" items="${queryTrans.queryFields}" varStatus="status">
			<c:set var="queryPropName" value="${item.field.propertyName}"/>
			<c:if test="${_primaryKey ne queryPropName}">
				<c:set var="paramValue" value="${param[queryPropName]}"/>
				<c:set var="queryParamValue" value="${empty item.defaultValue ? paramValue : (item.defaultValue)}" />
				<c:set var="widthStyle" value="width: ${empty item.viewWidth ? '130px':(item.viewWidth)};height:20px;"/>
				<c:if test="${item.viewType eq 'hidden'}" var="isHidden">
					<input name="${queryPropName}" type="hidden" value="${queryParamValue}">
				</c:if>
				<c:if test="${!isHidden && isDisplayButton}">
					<span>
					<span style="margin:2px 5px 2px 0;white-space:nowrap;">
					<rmp:msg value="${item.viewLabel}"/>:&nbsp;
					<c:choose>
						<c:when test="${item.viewType eq 'text' || fn:contains(item.viewType,'date')}">
							<c:set var="classValue" value="${item.viewType eq 'text' ? 'input_eq':(item.viewType eq 'date' ? 'easyui-datebox':'easyui-datetimebox')}"/>
							<c:if test="${item.queryMode ne 'BETWEEN'}">
								<input name="${queryPropName}" type="text" value="${queryParamValue}" class="${classValue}" style="${widthStyle}" clearFlg="${item.viewType}"/>
							</c:if>
							<c:if test="${item.queryMode eq 'BETWEEN'}">
								<c:set var="propBegin" value="${queryPropName}Begin" />
								<c:set var="propEnd" value="${queryPropName}End" />
								<input name="${queryPropName}Begin" id="${queryPropName}Begin" type="text" value="${param[propBegin]}" class="${classValue}" style="${widthStyle}" clearFlg="${item.viewType}"/>到
								<input name="${queryPropName}End" id="${queryPropName}End" validType='fieldName[{id:&quot;${queryPropName}&quot;}]' type="text" value="${param[propEnd]}"  class="${classValue}" style="${widthStyle}" clearFlg="${item.viewType}"/>
							</c:if>
						</c:when>

						<c:when test="${item.viewType eq 'flag'}">
							<c:set var="listFieldEditValue" value="${item.field.refModel}" />
							<select name="${queryPropName}" id="${queryPropName}" class="easyui-combobox" style="${widthStyle}" clearFlg="combobox" >
				           		<c:if test="${not empty listFieldEditValue and listFieldEditValue ne ''}">     
						           	<rmp:option dictId="${item.field.refModel}" currentValue="${paramValue}" prompt=""/>
					           	</c:if>
							</select>
							<!-- <br>flag:<r:dictCombobox id="${queryPropName}" name="${queryPropName}" style="${widthStyle}"
							 dictId="${item.field.refModel}"  value="${listFieldEditValue}"></r:dictCombobox> clearFlg="combobox" nullText=""
							-->
						</c:when>
						
						<c:when test="${item.viewType eq 'select' and item.field.refType eq '1'}">
							<select name="${queryPropName}" id="${queryPropName}" class="easyui-combobox" style="${widthStyle}" clearFlg="combobox" >
								<rmp:option dictId="${item.field.refModel}" currentValue="${paramValue}" prompt=""/>
							</select>
							<!-- <br>r:dictCombobox:<r:dictCombobox id="${queryPropName}" name="${queryPropName}" style="${widthStyle}"
							 dictId="${item.field.refModel}"  value="${paramValue}" ></r:dictCombobox> clearFlg="combobox"
					 		-->
					 	</c:when>
					 	
						<c:when test="${item.viewType eq 'select' and item.field.refType eq '2'}">
						<c:forEach var="refObj" items="${item.refModelData}">
						</c:forEach>
							<select name="${queryPropName}" id="${queryPropName}" class="easyui-combobox" style="${widthStyle}" clearFlg="combobox">
								<option value=""></option> 
								<c:forEach var="refObj" items="${item.refModelData}">
									<c:set var="propValue" value="${refObj[item.refModelNameProp]}${not empty item.refModelNameProp1 ? '-':''}${refObj[item.refModelNameProp1]}"/>
									<option value="${refObj[item.refModelPkProp]}" ${refObj[item.refModelPkProp] eq paramValue ? 'selected':''}>${propValue}</option>
								</c:forEach>
							</select>
							<!-- <br>select:
							<c:set var="fieldValue" value="${item.field.refModelPkProp}" />
							<c:set var="fieldText" value="${item.field.refModelNameProp}" />
							<c:set var="fieldText1" value="${item.field.refModelNameProp1}" />
							<r:combobox name="${queryPropName}" id="${queryPropName}" style="${widthStyle}"
							url="metadataJson_getSelectJson.action?modelName=${item.field.refModel}&queryMode=${item.field.queryMode}&refModelNameProp=${fieldText}&refModelNameProp1=${fieldText1}&refModelPkProp=${item.field.refModelPkProp}" 
							textField="${fieldText},${fieldText1}" valueField="${fieldValue}" 
							></r:combobox>clearFlg="combobox"  -->
						</c:when>
						
						<c:when test="${item.viewType eq 'autoSelect' and item.field.refType eq '2'}">
							<%--
							<select name="${queryPropName}" id="${queryPropName}" class="easyui-combobox" style="${widthStyle}" clearFlg="combobox">
								<option value=""></option> 
								<c:forEach var="refObj" items="${item.refModelData}">
									<c:set var="propValue" value="${refObj[item.refModelNameProp]}${not empty item.refModelNameProp1 ? '-':''}${refObj[item.refModelNameProp1]}"/>
									<option value="${refObj[item.refModelPkProp]}" ${refObj[item.refModelPkProp] eq paramValue ? 'selected':''}>${propValue}</option>
								</c:forEach>
							</select>
							 --%>
							<c:set var="fieldValue" value="${item.field.refModelPkProp}" />
							<c:set var="fieldText" value="${item.field.refModelNameProp}" />
							<c:set var="fieldText1" value="${item.field.refModelNameProp1}" />
							<r:autocomplete id="${queryPropName}" url="${pageContext.request.contextPath}/metadataJson_getAutoSelectJson.action?modelName=${item.field.refModel}&queryMode=${item.field.queryMode}&refModelNameProp=${fieldText}&refModelNameProp1=${fieldText1}&refModelPkProp=${item.field.refModelPkProp}"
							 name="${queryPropName}" value="${paramValue}" clearFlg="text" textField="${fieldText},${fieldText1}" valueField="${fieldValue}" style="${widthStyle}"></r:autocomplete>
						</c:when>
						
						<c:when test="${item.viewType eq 'comboTree' and item.field.refType eq '2'}">
				  			<input name="${queryPropName}" currentValue="${paramValue}" refModel="${item.field.refModel}" style="${widthStyle}" clearFlg="combotree"/>
						</c:when>
						
						<c:when test="${fn:contains(item.viewType,'pop')}">
							<c:set var="functionName" value="${item.viewType eq 'popTree' ? 'popTree':'popLazyTree'}"/>	
							<c:set var="queryPropTextName" value="${queryPropName}Text" />
							<c:set var="fieldText" value="${param[queryPropTextName]}" />
							<input id="${queryPropName}QueryField" name="${queryPropName}" type="hidden" value="${paramValue}" clearFlg="text"/>
							<input id="${queryPropName}QueryFieldText" name="${queryPropName}Text" type="text" value="${fieldText}" clearFlg="text" class="input_eq" style="${widthStyle}" readonly/>
							<input type="button" value="选择" onclick="${functionName}('${queryPropName}','${item.field.refModel}','${item.field.refModelPkProp}','${item.field.refModelNameProp}');" class="inputd"/>
						</c:when>   
						<c:otherwise>
							<span style="color: red">${queryPropName}属性的视图类型${item.viewType}目前尚不支持，请选择其他视图类型!</span>
						</c:otherwise>
					</c:choose> 
					</span>
					</span>
					<c:if test="${item.viewSingleFlag eq '1'}">
						<br><br>
					</c:if>
				</c:if>
			</c:if>
		</c:forEach>
		
		<span>
		<span style="white-space:nowrap;margin:2px 5px 2px 0;" >
			<input type="button" class="inputd" value="查询" id="filter_submit"/>&nbsp;
			<input type="button" class="inputd" value="重置" id="filter_reset"/>
		</span>
		</span>
		<c:out value="</td></tr></table>" escapeXml="false"/>
	</div>
	</c:if>
</form>
<%-- 	
<!--**********************************************************************-->				
<!-- listField查询结果的内容 -->
	<div class="table_panel">
		<table width="100%" class="table_list" border="0" cellspacing="0" cellpadding="0" id="tab">
		<c:forEach var="item" items="${requestScope.page.data}" varStatus="status"> 
<!--**********************************************************************-->				 
<!-- 修改 -->	
			<c:if test="${not empty param[_primaryKey] and param[_primaryKey] eq item[_primaryKey] and empty param._pageAction}">
	 		<tr style="CURSOR:pointer">
				<td width="3%" style="text-align: center;padding-left: 0px">
					<input type="checkbox" name="${_primaryKey}" value="${item[_primaryKey]}"/>
					<input type="hidden" name="${_primaryKey}" value="${item[_primaryKey]}"/>
				</td>
				<c:set var="inputWidthStyle" value="width: 90%;"/>
	    		<c:forEach var="lf" items="${queryTrans.listFields}" varStatus="status">
   				<c:set var="widthStyle" value="width: ${empty lf.viewWidth? '80px':lf.viewWidth};"/>
   				<c:set var="listFieldEditValue" value="${item[lf.field.propertyName]}" />
    			<c:if test="${not empty lf.field.multiple}">
    				<c:set var="listFieldEditValue" value="${item[lf.field.propertyName]* lf.field.multiple}" />
    			</c:if>
    			<c:set var="listFieldEditText" value="${item[lf.field.propertyName]}" />
    			
    			<td nowrap style="${widthStyle}">
					<c:if test="${lf.editFlag eq '1'}" var="editable">
					<c:choose>
					<c:when test="${lf.field.propertyName eq _primaryKey}">
						<c:out value="${listFieldEditValue}" escapeXml="true"/>
					</c:when>
		           	<c:when test="${lf.viewType eq 'text'}">
						<input name="${lf.field.propertyName}" type="text" class="input_eq" style="${inputWidthStyle}"
		           			value="<c:out value="${listFieldEditValue}" escapeXml="true"/>">
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'hidden'}">
		           		<c:out value="${listFieldEditValue}" escapeXml="true"/>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'flag'}">
		        		<select name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-combobox" style="${inputWidthStyle}">
		           			<rmp:option dictId="${lf.field.refModel}" currentValue="${listFieldEditValue}" prompt=""/>
				    	</select>&nbsp;
					</c:when>
		           	<c:when test="${lf.viewType eq 'date'}">
						<input name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-datebox" style="${inputWidthStyle}"
							   value='<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd" value="${listFieldEditValue}"/>'/>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'datetime'}">  
		           		<input name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-datetimebox" style="${inputWidthStyle}"
			           		   value='<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd hh:mm:ss" value="${listFieldEditValue}"/>'>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '1'}">
		           		<select name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-combobox" style="${inputWidthStyle}">
		           			<rmp:option dictId="${lf.field.refModel}" currentValue="${listFieldEditValue}" prompt=""/>
				    	</select>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '2'}">
		           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName][lf.refModelPkProp]}"/>
		           		<select name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-combobox" style="${inputWidthStyle}">
		           		  	<option value=""></option> 
					    	<c:forEach var="lf_rfm" items="${lf.refModelData}">
				        	 	<option value="${lf_rfm[lf.refModelPkProp]}" ${listFieldEditValue eq lf_rfm[lf.refModelPkProp] ? 'selected':''}
				        	 		>${lf_rfm[lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${lf_rfm[lf.refModelNameProp1]}</c:if></option>
					 		</c:forEach>
				    	</select>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'flag'}">
			           <rmp:dict dictId="${lf.field.refModel}" value="${item[lf.field.propertyName]}"/><!-- 限制状态位的修改 -->
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'popLazyTree' or lf.viewType eq 'popTree'}">	
		           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName][lf.refModelPkProp]}"/>
			          	<c:set var="listFieldEditText" value="${item[lf.field.propertyName][lf.refModelNameProp]}" />
		          		<input id="${lf.field.propertyName}ListField" name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
		          		<input id="${lf.field.propertyName}ListFieldText" name="${lf.field.propertyName}Text" style="width:50%;"
		          			   type="text" value="${listFieldEditText}" class="input_eq" readonly/>
	          			<input type="button" value="选择" onclick="popLazyTree2('${lf.field.propertyName}','${lf.field.refModel}');" 
							   name="${lf.field.propertyName}" class="inputd"/>
					</c:when>	
		           	<c:otherwise>
		           		${lf.field.propertyName}字段视图类型未设置
		           	</c:otherwise>
					</c:choose>  
					</c:if>
							
					<c:if test="${not editable}">
			           	<c:choose>    
			           	<c:when test="${lf.viewType eq 'text'}">
			           		<c:out value="${listFieldEditValue}" escapeXml="true"/>
				        	<input name="${lf.field.propertyName}" type="hidden" value="<c:out value="${listFieldEditValue}" escapeXml="true"/>">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'hidden'}">
			           		${listFieldEditValue}
			           		<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'date'}">
			           		<fmt:formatDate type="date" pattern="yyyy-MM-dd" value="${listFieldEditValue}"/>
							<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'datetime'}">
			           		<fmt:formatDate type="date" pattern="yyyy-MM-dd hh:mm:ss" value="${listFieldEditValue}"/>
							<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '1'}">
			           		<rmp:dict dictId="${lf.field.refModel}" value="${listFieldEditValue}"/>
			           		<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '2'}">
			           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName][lf.refModelPkProp]}" />
							<c:set var="listFieldEditText" value="${item[lf.field.propertyName]}" />
							${listFieldEditText}
							<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'comboTree'}">
			           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName][lf.refModelPkProp]}" />
							<c:set var="listFieldEditText" value="${item[lf.field.propertyName]}" />
							${listFieldEditText}
							<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'popLazyTree'}">
			           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName][lf.refModelPkProp]}" />
							<c:set var="listFieldEditText" value="${item[lf.field.propertyName]}" />
							${listFieldEditText}
							<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			           	<c:when test="${lf.viewType eq 'popTree'}">
			           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName][lf.refModelPkProp]}" />
							<c:set var="listFieldEditText" value="${item[lf.field.propertyName]}" />
							${listFieldEditText}
							<input name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
			           	</c:when>
			            <c:when test="${lf.viewType eq 'flag'}">
							<rmp:dict dictId="${lf.field.refModel}" value="${item[lf.field.propertyName]}"/><!-- 限制状态位的修改 -->
		           		</c:when>
			           	<c:otherwise>
			           		${lf.field.propertyName}字段视图类型未设置
			           	</c:otherwise>
			           </c:choose>
					</c:if>
					&nbsp;
				</td>
	 		</c:forEach>  
	    	</tr>
			</c:if>
		</c:forEach>

<!--**********************************************************************-->
<!-- 新增 -->
		<c:if test="${param._pageAction eq 'toAdd'}">      
	  		<tr style="CURSOR:pointer">
				<td width="3%" style="text-align: center;padding-left: 0px">
					<input type="checkbox" name="${_primaryKey}" value="${item[_primaryKey]}"/>
				</td>
				<c:set var="inputWidthStyle" value="width: 90%;"/>
	    		<c:forEach var="lf" items="${queryTrans.listFields}" varStatus="status">  
	    		<c:set var="widthStyle" value="width: ${empty lf.viewWidth? '80px':lf.viewWidth};"/>
	    		<td nowrap style="${widthStyle}">
 			 	<c:choose>    
	           		<c:when test="${lf.viewType eq 'text'}">
		           		<c:if test="${queryTrans.model.pkGenMode eq 'assign' || lf.field.propertyName ne _primaryKey}" var="nopk" >
							<input name="${lf.field.propertyName}" type="text" class="input_eq" style="${inputWidthStyle}">
			       		</c:if>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'hidden'}">
		           		<input name="${lf.field.propertyName}" type="hidden">${item[lf.field.propertyName]}
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'flag'}">
			           	<select name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-combobox" style="${inputWidthStyle}">
		           		    <rmp:option dictId="${lf.field.refModel}" currentValue="" prompt=""/>
		    	 		</select>&nbsp;
					</c:when>
		           	<c:when test="${lf.viewType eq 'date'}">
						<input name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-datebox"	style="${inputWidthStyle}"/>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'datetime'}">
						<input name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-datetimebox" style="${inputWidthStyle}"/>
		           	</c:when>
		           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '1'}">
		           		<select name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-combobox" style="${inputWidthStyle}">
		           			<rmp:option dictId="${lf.field.refModel}" currentValue="" prompt=""/>
				    	</select>
		           	</c:when>
					<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '2'}">
           		 		<c:if test="${lf.field.propertyName eq 'process'}">
	           				<c:set var="changelist" value="changelist(${lf.field.propertyName});"/>
           		 		</c:if>
	           			<select name="${lf.field.propertyName}" id="${lf.field.propertyName}" class="easyui-combobox" onchange="${changelist}" style="${inputWidthStyle}">
           		  		<option value=""></option> 
				      	<c:forEach var="lf_rfm" items="${lf.refModelData}">
				        	 <option value="${lf_rfm[lf.refModelPkProp]}"
				        	 >${lf_rfm[lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${lf_rfm[lf.refModelNameProp1]}</c:if></option>
				 	 	</c:forEach>
				    	</select>
		           	</c:when>
		           	
			        <c:when test="${lf.viewType eq 'popLazyTree' or lf.viewType eq 'popTree'}">	
		           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName][lf.refModelPkProp]}"/>
			          	<c:set var="listFieldEditText" value="${item[lf.field.propertyName][lf.refModelNameProp]}" />
		          		<input id="${lf.field.propertyName}ListField" name="${lf.field.propertyName}" type="hidden" value="${listFieldEditValue}">
		          		<input id="${lf.field.propertyName}ListFieldText" name="${lf.field.propertyName}Text" type="text" class="input_eq" value="${listFieldEditText}" readonly style="width:50%;"/>
		          		<input type="button" value="选择" onclick="popLazyTree2('${lf.field.propertyName}','${lf.field.refModel}');" 
							   name="${lf.field.propertyName}" class="inputd"/>
					</c:when>	
		           	<c:when test="${lf.viewType eq 'flag'}">
						<rmp:dict dictId="${lf.field.refModel}" value="${item[lf.field.propertyName]}"/><!-- 限制状态位的修改 -->
	           		</c:when>
		           	<c:otherwise>
		           		${lf.field.propertyName}字段视图类型未设置
		           	</c:otherwise>
		           </c:choose>
				</td>
	 		</c:forEach>  
	    	</tr>
	  	</c:if>
	</table>
	</div>
	</form>
--%>

	<div class="panel datagrid">
		<div class="panel-header">
			<div>${queryTrans.transName}</div>
		</div>
		<div class="datagrid-wrap panel-body">
			<div class="datagrid-toolbar">
				<c:if test="${empty param[_primaryKey] and param._pageAction ne 'toEdit' and param._pageAction ne 'toAdd'}">
					<c:if test="${requestScope.isAudit}"> 
						<a style="float: left; " class="l-btn l-btn-plain" id="audit">
							<span class="l-btn-left"><span class="icon-audit">复核</span></span>
						</a>
					</c:if> 
					<c:if test="${queryTrans.addFlag eq '1'}"> 
						<a style="float: left; " class="l-btn l-btn-plain" id="add">
							<span class="l-btn-left"><span class="icon-add">新增记录</span></span>
						</a>
					</c:if>
					<c:if test="${queryTrans.editFlag eq '1'}">
						<a style="float: left; " class="l-btn l-btn-plain" id="edit">
							<span class="l-btn-left"><span class="icon-edit">修改记录</span></span>
						</a>
					</c:if>
					<c:if test="${queryTrans.removeFlag eq '1'}">
						<a style="float: left; " class="l-btn l-btn-plain" id="delete">
							<span class="l-btn-left"><span class="icon-remove">删除记录</span></span>
						</a>
					</c:if>
					<c:if test="${queryTrans.exportFlag eq '1'}">
						<a style="float: left; " class="l-btn l-btn-plain" id="downloadExcel">
							<span class="l-btn-left"><span class="icon-exportTemplate">导出EXCEL模板</span></span>
						</a>
						<a style="float: left; " class="l-btn l-btn-plain" id="export">
							<span class="l-btn-left"><span class="icon-export">导出</span></span>
						</a>
					</c:if> 
					<c:if test="${queryTrans.importFlag eq '1'}">
						<a style="float: left; " class="l-btn l-btn-plain" id="import">
							<span class="l-btn-left"><span class="icon-import">导入</span></span>
						</a>
					</c:if>
				</c:if>
				<c:if test="${_modelName eq 'taskRelation'}">
					<a style="float: left; " class="l-btn l-btn-plain" id="checkrelation">
						<span class="l-btn-left"><span class="icon-add">任务关系校检</span></span>
					</a>
				</c:if>
				<c:if test="${param._pageAction eq 'toAdd' or not empty param[_primaryKey] or param._pageAction eq 'toEdit'}">
					<a style="float: left; " class="l-btn l-btn-plain" id="saveListItem">
						<span class="l-btn-left"><span class="icon-save">保存</span></span>
					</a>
					<a style="float: left; " class="l-btn l-btn-plain" id="cancelEdit">
						<span class="l-btn-left"><span class="icon-cancel">取消</span></span>
					</a>
				</c:if>
				<c:if test="${requestScope.devModeFlag eq '1'}">
					<a style="float: right; " class="l-btn l-btn-plain" href="${pageContext.request.contextPath}/queryTrans_xml_modify.action?modelName=${_modelName}&transId=${queryTrans.transId}&from=list">
						<span class="l-btn-left"><span class="icon-query">查询配置</span></span>
					</a>
					<a style="float: right; " class="l-btn l-btn-plain" href="${pageContext.request.contextPath}/metaModelXml_toForm.action?modelName=${_modelName}&from=list">
						<span class="l-btn-left"><span class="icon-form">表单配置</span></span>
					</a>
				</c:if>
			</div>
			
			<div class="datagrid-view" style="width:100%; height: 288px;">
				<div class="datagrid-view2" style="width:100%; left: 0px; ">
					<c:set var="defaultWidth" value="120px"/>
					<div class="datagrid-header" style="width:100%; height: 26px;">
						<div class="datagrid-header-inner" style="display: block; ">
							<table border="0" cellspacing="0" cellpadding="0" style="height:27px;">
								<tbody>
									<tr>
										<td><div class="datagrid-header-check"><input type="checkbox"/></div></td>
										<c:forEach var="lf" items="${queryTrans.listFields}">  
											<c:set var="theadWidth" value="width: ${empty lf.viewWidth? defaultWidth : (lf.viewWidth)};"/>
											<td><div class="datagrid-cell" style="${theadWidth}text-align: left;"><span><rmp:msg value="${lf.viewLabel}"/></span></div></td>
										</c:forEach>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					
					<form id="userListForm" name="userListForm" method="post">
					<input type="hidden" name="logic" value="${_logic}"> 
					<input name="modelName" type="hidden" value="${_modelName}">
					
					<div class="datagrid-body" style="width:100%; height: 261px;">
						<table cellspacing="0" cellpadding="0" border="0">
							<tbody>
								<c:forEach var="item" items="${requestScope.page.data}" varStatus="status"> 
								 	<c:if test="${empty param[_primaryKey] ||(not empty param[_primaryKey] and item[_primaryKey] ne param[_primaryKey])}">
							 		<tr class="datagrid-row" ondblclick="toEdit2('${item[_primaryKey]}', '${item[createUserProp]}');">
										<td>
											<div class="datagrid-cell-check">
												<input type="checkbox" name="${_primaryKey}" value="${item[_primaryKey]}" createUser="${item[createUserProp]}">
											</div>
										</td>
										<c:forEach var="lf" items="${queryTrans.listFields}">
							    			<c:set var="tbodyWidth" value="width: ${empty lf.viewWidth? defaultWidth : (lf.viewWidth)};"/> 
											<td>
											<div class="datagrid-cell" style="${tbodyWidth}text-align:left;height:auto;white-space:normal;">
											<c:if test="${lf.field.updateFlag ne '0'}">
												<c:choose> 
										           	<c:when test="${lf.viewType eq 'date'}">
										           		<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd" value="${item[lf.field.propertyName]}" />
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'datetime'}">
										           		<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss" value="${item[lf.field.propertyName]}"/>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '1'}">
										           		<rmp:dict dictId="${lf.field.refModel}" value="${item[lf.field.propertyName]}"/>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '2'}">
										           		${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'autoSelect' and lf.field.refType eq '2'}">
										           		${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'popLazyTree'}">
											        	${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when> 
										           	<c:when test="${lf.viewType eq 'popTree'}">
										           		${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'flag'}">
										           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName]}" />
										           		<c:if test="${not empty listFieldEditValue and listFieldEditValue ne ''}">
											           		<rmp:dict dictId="${lf.field.refModel}" value="${listFieldEditValue}"/>
											           	</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'hidden'}">
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'text'}">
											           	<c:set var="listFieldViewValue" value="${item[lf.field.propertyName]}" />
											           	<c:if test="${not empty lf.field.multiple}">
									    					<c:set var="listFieldViewValue" value="${item[lf.field.propertyName] * lf.field.multiple}" />
									    				</c:if>
									    				<c:if test="${lf.field.floatNumberPropertyType eq false}">
									                    	<c:if test="${lf.field.propertyType eq 'java.lang.String'}" var="isString">
									                    		<c:set var="listFieldViewValue" value="${fn:trim(listFieldViewValue)}"/> 
									                       		<c:if test="${fn:length(listFieldViewValue) le lf.viewWidthValue}">
																	<c:out value="${listFieldViewValue}"/>
										                    	</c:if>
											                    <c:if test="${fn:length(listFieldViewValue) gt lf.viewWidthValue}">
											                        <span title="<c:out value="${listFieldViewValue}" escapeXml="true"/>">
										                        		<c:out value="${fn:substring(listFieldViewValue, 0, lf.viewWidthValue)}" escapeXml="true"/>..
											                        </span>
											                    </c:if>
									                    	</c:if>
									                    	<c:if test="${not isString}">
									                    		${listFieldViewValue}
									                    	</c:if>
									    				</c:if>
									   					<c:if test="${lf.field.floatNumberPropertyType eq true}">
									   						
									   					 	<c:if test="${empty lf.field.currDelimFlag or lf.field.currDelimFlag eq '0'}">
										    					<fmt:formatNumber type="currency" maxFractionDigits="${lf.field.view.fractDigits}" groupingUsed="false"
										    									  pattern="#,##0.0000000000" value="${listFieldViewValue}"/>    
										    				</c:if>	
										    				<c:if test="${lf.field.currDelimFlag eq '1'}">
										    					<fmt:formatNumber type="currency" maxFractionDigits="${lf.field.view.fractDigits}" groupingUsed="true"
										    									  pattern="#,##0.0000000000" value="${listFieldViewValue}"/>
										    				</c:if>
									   					</c:if>
										    		</c:when>
									        	</c:choose>
									        </c:if>
									        <c:if test="${lf.field.updateFlag eq '0'}">
									        <span style="color:#c0c0c0">
									        <c:choose> 
										           	<c:when test="${lf.viewType eq 'date'}">
										           		<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd" value="${item[lf.field.propertyName]}" />
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'datetime'}">
										           		<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss" value="${item[lf.field.propertyName]}"/>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '1'}">
										           		<rmp:dict dictId="${lf.field.refModel}" value="${item[lf.field.propertyName]}"/>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'select' and lf.field.refType eq '2'}">
										           		${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'autoSelect' and lf.field.refType eq '2'}">
										           		${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'popLazyTree'}">
											        	${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when> 
										           	<c:when test="${lf.viewType eq 'popTree'}">
										           		${item[lf.field.propertyName][lf.refModelNameProp]}<c:if test="${not empty lf.refModelNameProp1}">-${item[lf.field.propertyName][lf.refModelNameProp1]}</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'flag'}">
										           		<c:set var="listFieldEditValue" value="${item[lf.field.propertyName]}" />
										           		<c:if test="${not empty listFieldEditValue and listFieldEditValue ne ''}">
											           		<rmp:dict dictId="${lf.field.refModel}" value="${listFieldEditValue}"/>
											           	</c:if>
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'hidden'}">
										           	</c:when>
										           	<c:when test="${lf.viewType eq 'text'}">
											           	<c:set var="listFieldViewValue" value="${item[lf.field.propertyName]}" />
											           	<c:if test="${not empty lf.field.multiple}">
									    					<c:set var="listFieldViewValue" value="${item[lf.field.propertyName] * lf.field.multiple}" />
									    				</c:if>
									    				<c:if test="${lf.field.floatNumberPropertyType eq false}">
									                    	<c:if test="${lf.field.propertyType eq 'java.lang.String'}" var="isString">
									                    		<c:set var="listFieldViewValue" value="${fn:trim(listFieldViewValue)}"/> 
									                       		<c:if test="${fn:length(listFieldViewValue) le lf.viewWidthValue}">
																	<c:out value="${listFieldViewValue}"/>
										                    	</c:if>
											                    <c:if test="${fn:length(listFieldViewValue) gt lf.viewWidthValue}">
											                        <span title="<c:out value="${listFieldViewValue}" escapeXml="true"/>">
										                        		<c:out value="${fn:substring(listFieldViewValue, 0, lf.viewWidthValue)}" escapeXml="true"/>..
											                        </span>
											                    </c:if>
									                    	</c:if>
									                    	<c:if test="${not isString}">
									                    		${listFieldViewValue}
									                    	</c:if>
									    				</c:if>
									   					<c:if test="${lf.field.floatNumberPropertyType eq true}">
									   						
									   					 	<c:if test="${empty lf.field.currDelimFlag or lf.field.currDelimFlag eq '0'}">
										    					<fmt:formatNumber type="currency" maxFractionDigits="${lf.field.view.fractDigits}" groupingUsed="false"
										    									  pattern="#,##0.0000000000" value="${listFieldViewValue}"/>    
										    				</c:if>	
										    				<c:if test="${lf.field.currDelimFlag eq '1'}">
										    					<fmt:formatNumber type="currency" maxFractionDigits="${lf.field.view.fractDigits}" groupingUsed="true"
										    									  pattern="#,##0.0000000000" value="${listFieldViewValue}"/>
										    				</c:if>
									   					</c:if>
										    		</c:when>
									        	</c:choose>
									        </span>
									        </c:if>
								        	</div>
								    		</td>
							 			</c:forEach> 
								    </tr>
									</c:if>    
								</c:forEach>
							</tbody>
						</table>
					</div>
					
					</form>
				</div>
			</div>
			
			<div class="datagrid-pager pagination">
				<table cellspacing="0" cellpadding="0" border="0">
					<c:set var="pageno" value="${requestScope.page.currentPageNo}" scope="page" /> 
					<c:set var="pageSize" value="${requestScope.page.pageSize}" scope="page" /> 
					<c:set var="totalPageCount" value="${requestScope.page.totalPageCount}" scope="page" /> 
					<tbody>
						<tr>
							<td><select class="pagination-page-list" id="pageSize"><rmp:option dictId="sys.pageSize" currentValue="${pageSize}"></rmp:option></select></td>
							<td><div class="pagination-btn-separator"></div></td>
							<td><a href="javascript:query(1);" class="l-btn l-btn-plain" id="firstpage"><span class="l-btn-left"><span class="l-btn-text"><span class="l-btn-empty icon-firstpage">&nbsp;</span></span></span></a></td>
							<td><a href="javascript:query(${requestScope.page.prePageNo});" class="l-btn l-btn-plain" id="prevpage"><span class="l-btn-left"><span class="l-btn-text"><span class="l-btn-empty icon-prevpage">&nbsp;</span></span></span></a></td>
							<td><div class="pagination-btn-separator"></div></td>
							<td><span style="padding-left:6px;">第</span></td>
							<td><input class="pagination-num" type="text" value="${pageno}" size="2" id="pageNo"></td>
							<td><span style="padding-right:6px;">页</span></td>
							<td><a href="javascript:query();" class="l-btn l-btn-plain" id="goPage"><span class="l-btn-left"><span class="l-btn-text"><span class="l-btn-empty icon-goPage">&nbsp;</span></span></span></a></td>
							<td><span style="padding-right:6px;">共${totalPageCount}页</span><input type="hidden" value="${totalPageCount}" id="totalPageCount"/></td>
							<td><div class="pagination-btn-separator"></div></td>
							<td><a href="javascript:query(${requestScope.page.sufPageNo});" class="l-btn l-btn-plain" id="nextpage"><span class="l-btn-left"><span class="l-btn-text"><span class="l-btn-empty icon-nextpage">&nbsp;</span></span></span></a></td>
							<td><a href="javascript:query(${totalPageCount})" class="l-btn l-btn-plain" id="lastpage"><span class="l-btn-left"><span class="l-btn-text"><span class="l-btn-empty icon-lastpage">&nbsp;</span></span></span></a></td>
							<td><div class="pagination-btn-separator"></div></td>
							<td><a href="javascript:query(${pageno});" class="l-btn l-btn-plain"><span class="l-btn-left"><span class="l-btn-text"><span class="l-btn-empty pagination-load">&nbsp;</span></span></span></a></td>
						</tr>
					</tbody>
				</table>
				<div class="pagination-info">当前显示 ${(pageno - 1)*pageSize+1} - ${(pageno - 1)*pageSize+page.dataSize} 条记录   共 ${requestScope.page.totalCount} 条记录</div>
				<div style="clear:both;"></div>
			</div>
		</div>
	</div>
</div>
<!-- 导入窗口 -->
<div id="importWindow"></div>
<rmp:perm checkType="unvisible" checkIds="create,modify,remove,import,export" transId="${queryTrans.transId}"/>
</body>
</html>