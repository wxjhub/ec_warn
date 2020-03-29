<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<c:set var="col" value="3"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>新增参数</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.autocomplete.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.autocomplete.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/autocomplete.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<style type="text/css">
.tabs-panels{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	border: none;
	background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
}
</style>
<script type="text/javascript">
//复核
function valid(flag) {
	var $_form1 = $("#form1");
	$_form1.append("<input type='hidden' value='" + flag + "' name='valid'/>");
	$_form1.append("<input type='hidden' value='${param.transId}' name='transId'/>");
	$_form1[0].action = "${pageContext.request.contextPath}/metaxml_audit.action";
	$_form1[0].submit();
}

function saveListItem(){
	if(!validatorField())
		return false;
	
	 var params = $("#form1").serialize();
	 var result=$.ajax({
         url:"${pageContext.request.contextPath}/metaxml_checkModelDataExist.action",
         data:params,    
		 dataType:"json",
		 success:function(data){
        		if(data[0].count == 0){
        			 $.ajax({    
        				  url:"${pageContext.request.contextPath}/metaxml_saveListItem.action",    
        				  type:"post",    
        				  data:params,    
        				  dataType:"json",    
        				  success:function(data){  
        						if(data.message!=null){
        							var msg = eval("(" + data.message + ")");
        							if(msg)
        								$.messager.alert('系统提示',msg.errorMsg,'warning');
        						} else {
        							goBack();
        						}
        				  }    
        			 });
        		}else{
        			$.messager.alert('系统提示',"业务主键'" + data[0].bizFieldNames + "'数据重复，不能保存该记录",'warning');
        		} 
    	}
 	}); 	
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
			$("#"+ fieldId).val(idAndName[0]);
			$("#"+ fieldId + "Text").val(idAndName[1]);
		}
	}, "350", "500", "");
}

function goBack(){
	window.location = "${pageContext.request.contextPath}/metaxml_query.action?transId=${param.transId}"; 
	return false;
}

function setAutoText(id, value){
	$('#' + id).val(value);
}

/* 重置表单 */
function resetForm(){
	$.each($("[clearFlg]"), function(i, data){
		var $_data = $(data);
		var clearFlg = $_data.attr("clearFlg");
		if("text" == clearFlg){
			$_data.val("");
		}else{
			$_data.combobox("clear");
		}
	});
};

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
    		if(id) value = $("#" + id).val();

    		var minValue = validateFlag.minValue;
			if(minValue && validateFlag.multiple)
				minValue = minValue * validateFlag.multiple;

			var maxValue = validateFlag.maxValue;
			if(maxValue && validateFlag.multiple)
				maxValue = maxValue * validateFlag.multiple;

			var labelName = $("#td_label_" + validateFlag.propertyName).text();
			$.fn.validatebox.defaults.rules.fieldName.message = labelName.replace(/:\s*/g, "");
			
    		if(minValue && value < minValue) {
    			result = false;
    			$.fn.validatebox.defaults.rules.fieldName.message += "最小值: " + minValue;
    		} else if(maxValue && value > maxValue) {
    			result = false;
    			$.fn.validatebox.defaults.rules.fieldName.message += "最大值: " + maxValue;
    		} else if(validateFlag.dbtype == "NUMBER") {
        		var integerLenth = validateFlag.maxlength - validateFlag.scale;
				var reg = eval("/^[-]?\\d{0," + integerLenth + "}(\\.\\d{0," + validateFlag.scale + "})?$/");
				result = reg.test(value);
				if(!result) {
					$.fn.validatebox.defaults.rules.fieldName.message += "格式: 必须为数字, 整数部分0~" + integerLenth + "位";
					if(validateFlag.scale != 0)
						$.fn.validatebox.defaults.rules.fieldName.message += " ,小数部分0~" + validateFlag.scale + "位";
				}
			} else {
				result = value.length <= validateFlag.maxlength;
				if(!result) 
					$.fn.validatebox.defaults.rules.fieldName.message += "长度0~" + validateFlag.maxlength + "个字符";
			}
    		return result;
	     },
	     message:""
 	}
});
$(function(){
    var heightValue = $(document).height() - 125;
    if (heightValue > 0)
        $("#tt").tabs({height: heightValue});
});
</script>
</head>
<body>
<div class="gridDiv">
<div class="table_tt" style="margin-top: 30px;">
	<font class="blue" id="msg">${param._pageAction eq 'add' ? '新增' : '修改'}参数</font>
</div>
<div id="tt" class="easyui-tabs panel-body" style="height:340px;">
		<div title="${model.comment}">
			<table>
				<tr>
					<td height=40px valign="middle" style="padding-left: 25px;">
					<form id="form1" name="form1" method="post" style="padding-top: 25px;border-style: none">
						<input name="modelName" id="modelName" type="hidden" value="${model.modelName}">
						<!-- 隐藏字段 -->
						<c:forEach var="f" items="${fields}" varStatus="status"> 
							<c:if test="${f.view.type eq 'hidden'}">
								<input name="${f.propertyName}" type="hidden" value="${detail[f.propertyName]}">
							</c:if>
						</c:forEach>
					
					<div id="myTab1_Content0" >
						<table cellSpacing="0" cellpadding="0" border="0">
						
							<c:set var="style" value="height:20px;width:150px;"/>
							
							<c:forEach var="f" items="${fields}" varStatus="status">
							
								<c:set var="fieldValue" value="${detail[f.propertyName]}" />
								<c:if test="${not empty f.multiple && not empty detail}">
									<c:set var="fieldValue" value="${detail[f.propertyName] * f.multiple}" />
								</c:if>
								<c:set var="fieldText" value="${detail[f.propertyName]}" />
								
								<c:set var="required" value="${f.isNotNull eq '1' ? 'required=true': ''}"/>
								<c:set var="minValue" value="${empty f.minValue ? 'null':(f.minValue)}"/>
								<c:set var="maxValue" value="${empty f.maxValue ? 'null':(f.maxValue)}"/>
								<c:set var="multiple" value="${empty f.multiple ? 'null':(f.multiple)}"/>
								<c:set var="validateFlag" value="${required} validType='fieldName[{propertyName:&quot;${f.propertyName}&quot;,dbtype:&quot;${f.dbtype}&quot;, maxlength:${f.maxlength}, scale:${f.scale}, minValue:${minValue}, maxValue:${maxValue}, multiple:${multiple}}]'"/>
								
								<!-- 非隐藏，非自动生成的字段，新增和修改界面都显示-->
								<c:if test="${f.autogenFlag ne '1' and f.view.type ne 'hidden'}">
									<c:set var="index" value="${index+1}" />
									<c:out value="${index%col eq 1 ? '<tr>':''}" escapeXml="false"/>
									<td id="td_label_${f.propertyName}" style="height:35px">
							  		 	<rmp:msg value="${f.view.label}"/>: &nbsp;
									</td>
									<td id="td_field_${f.propertyName}">
									<c:if test="${f.updateFlag ne '0' or empty detail}" var="updateable">
										<c:choose>
										<c:when test="${f.isPrimaryKey eq 1}">
											<c:set var="isReadOnly" value="readonly"/>
											<c:if test="${param._pageAction eq 'add' && model.pkGenMode eq 'assign'}">
												<c:set var="isReadOnly" value="clearFlg='text' ${validateFlag}"/>
											</c:if>
											<input name="${f.propertyName}" type="text" value="${fieldValue}" style="${style}" class="easyui-validatebox input_eq" ${isReadOnly}/>
										</c:when>
										<c:when test="${f.view.type eq 'text'}">
							      			<input name="${f.propertyName}" type="text" value="<c:out value='${fieldValue}'/>" style="${style}" class="easyui-validatebox input_eq" clearFlg="text" ${validateFlag}/>
						     		 	</c:when>
							          	<c:when test="${f.view.type eq 'date'}">
							          		<input name="${f.propertyName}" type="text" class="easyui-validatebox easyui-datebox" clearFlg="date" ${required}
												   value='<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd" value="${fieldValue}"/>' style="${style}"/>
										</c:when>
							          	<c:when test="${f.view.type eq 'datetime'}">
							          		<input name="${f.propertyName}" type="text" class="easyui-validatebox easyui-datetimebox" clearFlg="date" ${required}
							          			   value='<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd hh:mm:ss" value="${fieldValue}"/>' style="${style}"/>
							          		
							          	</c:when>
								      	<c:when test="${f.view.type eq 'flag' and f.refType eq '1'}">
											<select name="${f.propertyName}" class="easyui-validatebox easyui-combobox" clearFlg="combobox" style="${style}" ${validateFlag}>
												<rmp:option dictId="${f.refModel}" currentValue="${fieldValue}" prompt=""/>
											</select>
											<!-- <br>flag:<r:dictCombobox id="${f.propertyName}" name="${f.propertyName}" style="${style}"  linkId="address" linkKey="city"
							 					dictId="${f.refModel}"  value="${fieldValue}"></r:dictCombobox> clearFlg="combobox" nullText=""  modelName="f.linkProperty" -->
									    </c:when>
										<c:when test="${f.view.type eq 'select' and f.refType eq '1'}">
											<select name="${f.propertyName}" class="easyui-validatebox easyui-combobox" clearFlg="combobox" style="${style}" ${validateFlag}>
												<rmp:option dictId="${f.refModel}" currentValue="${fieldValue}" prompt=""/>
											</select>
										</c:when>
										<c:when test="${f.view.type eq 'select' and f.refType eq '2'}">
											<c:set var="fieldValue" value="${detail[f.propertyName][f.refModelPkProp]}" />
											<c:set var="fieldText" value="${detail[f.propertyName][f.refModelNameProp]}" />
											<c:set var="fieldText1" value="${detail[f.propertyName][f.refModelNameProp1]}" />
											<select name="${f.propertyName}" class="easyui-validatebox easyui-combobox" clearFlg="combobox" style="${style}" ${validateFlag}>
												<option value=""></option> 
												<c:forEach var="refObj" items="${f.refModelData}">
													<option value="${refObj[f.refModelPkProp]}" ${fieldValue eq refObj[f.refModelPkProp]? 'selected' : ''}><c:out value="${refObj[f.refModelNameProp]}"/></option>
												</c:forEach>
											</select>
											<!-- <br>select:
											<r:combobox name="${f.propertyName}" id="${f.propertyName}" style="${style}"
							url="${pageContext.request.contextPath}/metadataJson_getMetadataJson.action?modelName=test3" 
							textField="name3" valueField="id3"></r:combobox>clearFlg="combobox" ,
							,${validateFlag} textField="${fieldText},${fieldText1}" valueField="${fieldValue}" -->
										</c:when> 
										<c:when test="${f.view.type eq 'autoSelect' and f.refType eq '2'}">
											<c:set var="fieldValue" value="${detail[f.propertyName][f.refModelPkProp]}" />
											<c:set var="fieldText" value="${detail[f.propertyName][f.refModelNameProp]}" />
											<r:autocomplete id="${f.propertyName}" url="${pageContext.request.contextPath}/metadataJson_getAutoSelectJson.action?modelName=${f.refModel}&queryMode=${f.queryMode}&refModelNameProp=${f.refModelNameProp}&refModelNameProp1=${f.refModelNameProp1}&refModelPkProp=${f.refModelPkProp}"
											 name="${f.propertyName}" value="${fieldValue}" clearFlg="text" textField="${f.refModelNameProp},${f.refModelNameProp1}" valueField="${f.refModelPkProp}" style="${style}"></r:autocomplete>
											<script>
								  				setAutoText('${f.propertyName}', '${fieldText}');		 			
								   			</script>
										</c:when>
										<c:when test="${f.view.type eq 'comboTree'}">
											<input url="metadataJson_getTreeRootJson.action?modelName=${f.refModel}" name="${f.propertyName}" 
												   class="easyui-validatebox easyui-combotree" value="${detail[f.propertyName][f.refModelPkProp]}" clearFlg="combobox" ${validateFlag} style="${style}"/>
										</c:when> 
										<c:when test="${fn:contains(f.view.type, 'pop')}">
											<c:set var="functionName" value="${f.view.type eq 'popTree' ? 'popTree':'popLazyTree'}"/>	
											<c:set var="fieldValue" value="${detail[f.propertyName][f.refModelPkProp]}" />
											<c:set var="fieldText" value="${detail[f.propertyName][f.refModelNameProp]}" />
											<c:set var="validateFlag" value="${required} validType='fieldName[{dbtype:&quot;${f.dbtype}&quot;, maxlength:${f.maxlength}, scale:${f.scale}, id:&quot;${f.propertyName}&quot;}]'"/>
											<input id="${f.propertyName}" name="${f.propertyName}" type="hidden" value="${fieldValue}" clearFlg="text"/>
											<input id="${f.propertyName}Text" name="${f.propertyName}Text" type="text" value="${fieldText}" clearFlg="text" style="${style}"
												   class="easyui-validatebox input_eq" ${validateFlag} readonly/>
											<input type="button" value="选择" onclick="${functionName}('${f.propertyName}','${f.refModel}', '${f.refModelPkProp}', '${f.refModelNameProp}');" name="${f.propertyName}" class="inputd"/>
										</c:when>
										<%--
										<c:when test="${f.view.type eq 'popTree'}">	
											<c:set var="fieldValue" value="${detail[f.propertyName][f.refModelPkProp]}" />
											<c:set var="fieldText" value="${detail[f.propertyName][f.refModelNameProp]}" />
											<c:set var="validateFlag" value="${required} validType='fieldName[{dbtype:&quot;${f.dbtype}&quot;, maxlength:${f.maxlength}, scale:${f.scale}, id:&quot;${f.propertyName}&quot;}]'"/>
											<input id="${f.propertyName}" name="${f.propertyName}" type="hidden" value="${fieldValue}" clearFlg="text"/>
											<input id="${f.propertyName}Text" name="${f.propertyName}Text" type="text" value='${fieldText}' clearFlg="text" style="${style}"
											 	   class="easyui-validatebox input_eq" ${validateFlag} readonly/>
											<input type="button" value="选择" onclick="popTree('${f.propertyName}','${f.refModel}');" name="${f.propertyName}" class="inputd"/>
										</c:when>
										 --%>
							          	<c:otherwise>
							          		<c:out value="${f.propertyName}字段视图类型未设置"/>
							          	</c:otherwise>
										</c:choose>
									</c:if>
									<c:if test="${not updateable}">   
										
										<c:set var="formFieldValue" value="${detail[f.propertyName]}"/>
						    			<c:if test="${not empty lf.field.multiple}">
						    				<c:set var="formFieldValue" value="${detail[f.propertyName]* f.multiple}" />
						    			</c:if>
										<c:choose>   
										<c:when test="${f.view.type eq 'text'}">
							           		<input name="${f.propertyName}" type="hidden" value="<c:out value='${formFieldValue}'/>"><c:out value="${fieldValue}"/>
							          	</c:when>
							           	<c:when test="${f.view.type eq 'date'}">
							           		<input name="${f.propertyName}" type="hidden" value="<fmt:formatDate type='date' dateStyle='full' pattern='yyyy-MM-dd' value='${formFieldValue}'/>"><c:out value="${fieldValue}"/>
							           	</c:when>
							           	<c:when test="${f.view.type eq 'datetime'}">  
							           		<input name="${f.propertyName}" type="hidden" value="<fmt:formatDate type='date' dateStyle='full' pattern='yyyy-MM-dd HH:mm:ss' value='${formFieldValue}'/>"><c:out value="${fieldValue}"/>
							           	</c:when>
							          	<c:when test="${f.refType eq '1' and f.propertyType eq 'java.lang.String'}">
							           		<input name="${f.propertyName}" type="hidden" value="${formFieldValue}">
							           		<rmp:dict dictId="${f.refModel}" value="${formFieldValue}"/>  
							           	</c:when>
							           	<c:when test="${f.refType eq '2'}">
							           		<c:if test="${f.propertyName ne 'java.lang.String'}" var="isString">
							           			<input name="${f.propertyName}" type="hidden" value="${detail[f.propertyName][f.refModelPkProp]}">
							           		</c:if>
							           		<c:if test="${not isString}">
							           			<input name="${f.propertyName}" type="hidden" value="${formFieldValue}">
							           		</c:if><c:out value="${fieldValue}"/>
							           	</c:when>
						          		<c:otherwise>
							          		<input name="${f.propertyName}" type="hidden" value="${formFieldValue}"><c:out value="${fieldValue}"/>
							          	</c:otherwise>
										</c:choose>
									</c:if>
									<c:if test="${f.isNotNull eq '1'}">
										<span style="color: red;font-size: 15px;"> *</span>
									</c:if>
						      	</td>
						      	<td style="width:50px;"></td>
						      	<c:out value="${index%col eq 0 || status.last ? '</tr>':''}" escapeXml="false"/>
							    </c:if>
							    
							    <!-- 非隐藏字段，自动生成的字段，修改界面才显示-->
							    <c:if test="${f.autogenFlag eq '1' and f.view.type ne 'hidden' and not empty detail}">
							    	<c:set var="index" value="${index+1}" />
									<c:out value="${index%col eq 1 ? '<tr>':''}" escapeXml="false"/>
									<td id="td_label_${f.propertyName}" style="height:35px">
							  		 	<rmp:msg value="${f.view.label}"/>: &nbsp;
									</td>
									<td id="td_field_${f.propertyName}">	
										<c:if test="${f.view.type eq 'flag' and f.refType eq '1'}">
											<input name="${f.propertyName}" type="hidden" value="${fieldValue}">
											<rmp:dict dictId="${f.refModel}" value="${fieldValue}"/>
										</c:if>
										<c:if test="${f.view.type eq 'date'}">
											<input name="${f.propertyName}" type="hidden" 
													value="<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd" value="${fieldValue}"/>">
											<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd" value="${fieldValue}"/></c:if>
										<c:if test="${f.view.type eq 'datetime'}">
											<input name="${f.propertyName}" type="hidden" 
													value="<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss" value="${fieldValue}"/>">
											<fmt:formatDate type="date" dateStyle="full" pattern="yyyy-MM-dd HH:mm:ss" value="${fieldValue}"/></c:if>
									</td>  
									<td style="width:50px;"></td>
						      		<c:out value="${index%col eq 0 || status.last ? '</tr>':''}" escapeXml="false"/>
								</c:if>
							    
						 	</c:forEach> 
							<tr>
								<td height="40px" colspan="${col * 3}"><br>
								</td>
							</tr>
						</table>
					</div>
					</form>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="tool_btn" style="padding-left:25px;">
		<table style="float: left;"><tbody><tr><td>
			<c:choose>
				<c:when test="${param.isAudit}">
					<input type="button" class="inputd" value="有效" onclick="valid(1);"/>&nbsp;
					<input type="button" class="inputd" value="无效" onclick="valid(0);"/>&nbsp;
				</c:when>
				<c:otherwise>
					<input type="button" class="inputd" value="保存" onclick="saveListItem();"/>&nbsp;
					<input type="button" class="inputd" value="重置" onclick="resetForm();"/>&nbsp;
				</c:otherwise>
			</c:choose>
					<input type="button" class="inputd" value="返回" onclick="goBack();"/>&nbsp;
		</td></tr></tbody></table>
		<div style="float: right;">
			<c:if test="${requestScope.devModeFlag eq '1'}">
				<input type="button" class="inputd" value="表单配置" onclick="toModelFormConfig();"/>&nbsp;
			</c:if>
		</div>
		<div style="clear:both;"></div>
	</div>
</div>
<script type="text/javascript">
function toModelFormConfig(){
	window.location.href = "${pageContext.request.contextPath}/metaModelXml_toForm.action?modelName=${model.modelName}&from=list"; 
}
</script>
</body>
</html>
