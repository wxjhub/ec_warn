<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>元数据模型-详细信息</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/metaFieldRef.js"></script>
<script type="text/javascript">
var basePath = "${pageContext.request.contextPath}" ;
function saveColumn(){
    var xform = document.editForm;
    var propertyType=document.getElementById("propertyType").value;
    var refType=$("#refType").combobox('getValue');//alert("refType:"+ refType);
    var isEntity = (propertyType.indexOf("entity")>0)||(propertyType.indexOf("com.vprisk.rmplatform.components")>=0);
    if(!isEntity){
		if(refType=="2") {
			$.messager.alert('系统提示','属性类型非实体，不能选择关联其他元数据模型!','warning');
			return false;
		}
	}else if(isEntity){
		if(refType=="1"||refType=="3"||refType=="4") {
			$.messager.alert('系统提示','属性类型实体，只能选择关联其他元数据模型!','warning');
			return false;
		}
	}
  
    if(refType!=""){
        //关联类型选中的情况
		var refModel=$("#refModel").combobox('getValue'); //alert("refModel:"+ refModel);
		if(refModel==""){
			$.messager.alert('系统提示','关联类型选中后，关联模型必须选择!','warning');
			return false;
	    }
	    if(refType=='2'){
		    //如果关联类型为元数据模型，则关联主键字段、显示字段必不为空
		    var refModelPkProp=$("#refModelPkProp").combobox('getValue');
		    if(refModelPkProp==""){
		    	$.messager.alert('系统提示','关联类型为元数据模型，则关联主键字段必须选择!','warning');
				return false;
		    }	  
		    var refModelNameProp=$("#refModelNameProp").combobox('getValue');
		    var refModelNameProp1=$("#refModelNameProp1").combobox('getValue');
		    if(refModelNameProp=="" && refModelNameProp==""){
		    	$.messager.alert('系统提示','关联类型为元数据模型，关联显示字段必须选择一个!','warning');
				return false;
		    }

		    //如果关联排序字段已选择，则关联排序方式也必须选择
		    var refModelOrderProp=$("#refModelOrderProp").combobox('getValue');
		    if(refModelOrderProp!=""){
		  		var refModelOrderMode=$("#refModelOrderMode").combobox('getValue');
		  		if(refModelOrderMode==""){
		  			$.messager.alert('系统提示','关联排序字段选中后，关联排序方式必须选择!','warning');
					return false;
			  	}
		    } 
	    }
    }
    var orderMode=$("#orderMode").combobox('getValue');
    var orderSort=$("#orderSort").val();
    if((!orderMode ||orderMode=="")&&orderSort!=""){
    	$.messager.alert('系统提示','当前排序模式未选择，则排序顺序无意义!','warning');
		return false;
    }
    var orderSortNum=Number(orderSort);
	if(isNaN(orderSortNum)||orderSort.indexOf(".")>=0){
		$.messager.alert('系统提示','排序顺序为非法数字，请重新输入正确整数!','warning');
		return false;
	}
    xform.submit();
}

function returnTableDetail(){
    window.location.href= basePath + "/metaModelXml_fieldList.action?modelName=${detail.model.modelName}";
    return false;
} 

$(function(){
	metaField.init(basePath);
});

</script>
</head>
<body>
<div class="clearfix">
<form action="${pageContext.request.contextPath}/metaModelFieldXml_save.action" method="post" name="editForm" id="editForm" style="margin-right: 25px;">
	
	<input name="uuid"  id="uuid"   type="hidden" value="${detail.uuid}">
	<input name="model"  id="model"   type="hidden" value="${detail.model.uuid}"> <!-- 给field获取参数时自动后去model的uuid时用的 -->
	<input name="modelName"  id="modelName" type="hidden" value="${detail.model.modelName}"> <!-- 给URL重新返回带回modelname用的 -->     
	<input name="className"  id="className" type="hidden" value="${detail.model.className}">
	<input name="tableName"  id="tableName" type="hidden" value="${detail.model.tableName}">
	<input name="orderFlag"  id="orderFlag" type="hidden" value="${detail.view.orderFlag}">
	
	<div id="myTab1_Content0" style="padding: 25px 0 0 25px;">
	<table width="100%" align="center" border="0" cellpadding="3" cellspacing="1">
		<tr height="27px">    
			<td width="10%">字段名称</td>
			<td width="40%">
				${detail.dbcolumn}
				<input name="dbcolumn" id="dbcolumn"  type="hidden" value="${detail.dbcolumn}">
			</td>
			<td>中文名称</td>
			<td width="40%">
				${detail.comment}
				<input name="comment" id="comment" type="hidden" value="${detail.comment}">
			</td>
		</tr>
		<tr height="27px">
			<td>字段类型</td>   
			<td>${detail.dbtype}
				<c:if test="${not empty detail.maxlength}">
					(${detail.maxlength}<c:if test="${not empty detail.scale}">, ${detail.scale}</c:if>)
				</c:if>
				<input name="maxlength" id="maxlength" type="hidden" value="${detail.maxlength}">  
				<input name="scale" id="scale" type="hidden" value="${detail.scale}">
				<input name="dbtype" id="dbtype" type="hidden" value="${detail.dbtype}">
			</td>
			<td>是否主键</td>
			<td width="40%">
				<select name="isPrimaryKey" id="isPrimaryKey" style="width:100px;" class="easyui-combobox">
					<rmp:option dictId="sys.boolean" currentValue="${detail.isPrimaryKey}" defaultValue="0"/>
	     	 	</select>
	     	 		(目前不支持复合主键)
	     	 	<input name="isPrimaryKeyOld" id="isPrimaryKeyOld" type="hidden" value="${detail.isPrimaryKey}">
			</td>  
		</tr>  
	</table>
	
	<hr id="refHr" style="border-top: 1px #ccc dotted;border-bottom: none;color: #fff"/>
	
	<table id="refTable" width="100%" align="center" border="0" cellpadding="3" cellspacing="1">
		<tr id="refTR" height="27px">
			<td width="10%">关联类型</td>
			<td width="40%"> 
				<select name="refType" id="refType" class="easyui-combobox" style="width:120px;">
					<rmp:option dictId="meta.refType" currentValue="${detail.refType}" prompt=""/>
				</select>
				<input name="refTypeOld" id="refTypeOld" type="hidden" value="${detail.refType}">
			</td> 
			<td width="10%">关联模型</td>
			<td width="40%">
				<select name="refModel" id="refModel" class="easyui-combobox" style="width:250px;">
	  			</select>
	  			<input name="refModelOld" id="refModelOld" type="hidden" value="${detail.refModel}">
			</td> 
		</tr>
		<!-- <tr height="27px">
			<td width="10%">被联动字段</td>
			<td width="40%"> 
				<select name="linkedProperty" id="linkedProperty" class="easyui-combobox" style="width:120px;">
					<option value="value1">address</option>
					<option value="value2">年龄</option>
					<option value="value2">姓名</option>
				</select>
				<input name="linkPropertyOld" id="linkPropertyOld" type="hidden">
			</td> 
			<td width="10%">联动判等字段</td>
			<td width="40%">
				<select name="linkModelEqProp" id="linkModelEqProp" class="easyui-combobox" style="width:120px;">
					<option value="city">city</option>
					<option value="value2">name</option>
				</select>
			</td> 
		</tr>
		<tr height="27px">
			<td width="10%">联动匹配模式</td>
			<td width="40%"> 
				<select name="linkMode" id="linkMode" class="easyui-combobox" style="width:120px;">
					<option value="eq">eq</option>
					<option value="ilike">ilke</option>
					<option value="ilike">...</option>
				</select>
				<input name="linkModeOld" id="linkModeOld" type="hidden">
			</td> 
			<td width="10%">联动额外参数</td>
			<td width="40%">
			<input name="linkParam" id="linkParam" type="text" value="status:1">
			</td> 
		</tr>
	 -->
		<tr id="refModelPkTR" height="27px">
			<td width="10%">关联主键字段</td>
			<td width="40%">
				<select name="refModelPkProp" id="refModelPkProp" class="easyui-combobox" style="width:120px;">
				</select>
				<input name="refModelPkPropOld" id="refModelPkPropOld" type="hidden" value="${detail.refModelPkProp}">
			</td>
			<td width="10%">关联显示字段</td>
			<td width="40%">
	 			<select name="refModelNameProp" id="refModelNameProp" class="easyui-combobox" style="width:120px;">
	 			</select>
	  			<select name="refModelNameProp1" id="refModelNameProp1" class="easyui-combobox" style="width:120px;" >
	  			</select>
				<input name="refModelNamePropOld" id="refModelNamePropOld"  type="hidden" value="${detail.refModelNameProp}">
				<input name="refModelNameProp1Old" id="refModelNameProp1Old"  type="hidden" value="${detail.refModelNameProp1}">
			</td>		     
		</tr>
		
		<tr id="refModelOrderTR" height="27px">
			<td width="10%">关联排序字段</td>
	 		<td width="40%">
				<select name="refModelOrderProp" id="refModelOrderProp" class="easyui-combobox" style="width:120px;" >
					<option value=""></option>
				</select>
	  			<input name="refModelOrderPropOld" id="refModelOrderPropOld"  type="hidden" value="${detail.refModelOrderProp}">
			</td>
			<td width="10%">关联排序方式</td>
			<td width="40%">
				<select name="refModelOrderMode" id="refModelOrderMode" class="easyui-combobox">
					<rmp:option dictId="meta.refModelOrderProp" currentValue="${detail.refModelOrderMode}" prompt=""/>
	      		</select>
				<input name="refModelOrderModeOld" id="refModelOrderModeOld"  type="hidden" value="${detail.refModelOrderMode}">
	  		</td>
	   	</tr> 	   
	</table>
	
	<hr style="border-top: 1px #ccc dotted;border-bottom: none;color: #fff"/>
	<table width="100%" align="center" border="0" cellpadding="3" cellspacing="1">
		<tr height="27px">
	   		<td width="10%">属性名称*</td>
  	 		<td width="40%">
				<input name="propertyName" id="propertyName"  type="text" class="input_eq2"  value="${detail.propertyName}" readonly="readonly"> (只读)
   				<input name="propertyNameOld" type="hidden" value="${detail.propertyName}">
			</td>
			<td width="10%">属性类型*</td> 
			<td width="40%">
	 			<input name="propertyType"  id="propertyType" type="text" class="input_eq2" value="${detail.propertyType}" style="WIDTH:300px;">
				<input name="propertyTypeOld" id="propertyTypeOld" type="hidden" value="${detail.propertyType}">
			</td> 
		</tr> 
	
		<tr height="27px">
			<td>是否必输*</td>    
			<td>
	 			<select name="isNotNull" id="isNotNull" style="width:100px;" class="easyui-combobox">
		  			<rmp:option dictId="sys.boolean" currentValue="${detail.isNotNull}" defaultValue="0"/>
		 		</select>
			</td>    
			<td>是否标志位</td>
			<td>
				<select name="isFlag" id="isFlag" style="width:100px;" class="easyui-combobox">
					<rmp:option dictId="meta.autoFlag" currentValue="${detail.isFlag}" defaultValue="0"/>
	  			</select> (新增时自动生成,修改时只读,如生效标志位)  
			</td> 
		</tr>
	
		<tr height="27px">  
			<td>是否业务主键</td>
			<td>  
	  	 		<select name="isBizKey" id="isBizKey" style="width:100px;" class="easyui-combobox">
		  			<rmp:option dictId="meta.bizKey" currentValue="${detail.isBizKey}" defaultValue="0"/>
	  	 		</select>
				<input name="isBizKeyOld" id="isBizKeyOld" type="hidden" value="${detail.isBizKey}">
			</td>    
			<td>是否可维护</td>
			<td>
				<select name="updateFlag" id="updateFlag" style="width:100px;" class="easyui-combobox">
	 				<rmp:option dictId="meta.updateFlag" currentValue="${detail.updateFlag}" defaultValue="1"/>  
	  			</select> (是：新增和修改均可操作，否：只读)
	  			<input name="updateFlagOld" id="updateFlagOld" type="hidden" value="${detail.updateFlag}">
			</td>
		</tr>
		
		<tr height="27px">   
			<td>默认值</td>
			<td>
				<select name="autogenType" id="autogenType" class="easyui-combobox" style="width:100px;">
	 			</select>
	 			<input name="autogenTypeOld" id="autogenTypeOld" type="hidden" value="${detail.autogenType}">
			</td> 
			<td><div style="display:none;">是否系统生成</div></td>   
			<td>
			<div style="display:none;">
				<select name="autogenFlag" id="autogenFlag" style="width:100px;" class="easyui-combobox">
					<rmp:option dictId="meta.autoFlag" currentValue="${detail.autogenFlag}" defaultValue="0"/>
	  			</select>
   	 		</div>
	   		</td>
 		</tr>
	</table>
	
	<hr style="border-top: 1px #ccc dotted;border-bottom: none;color: #fff"/>
	<table width="100%" align="center" border="0" cellpadding="3" cellspacing="1">
		<tr height="27px">
     		<td width="10%">视图类型*</td>
     		<td width="40%">
					<!-- <rmp:option dictId="meta.field.viewType" currentValue="${detail.view.type}" prompt=""/> -->
				<select name="type" id="type" class="easyui-combobox" style="width:100px;">    
				</select>
     			<input name="typeOld" id="typeOld" type=hidden value="${detail.view.type}">
				<input name="view" id="view" type="hidden" value="${detail.view.uuid}"><!-- 给field的view属性自动赋值 -->
				<input name="field" id="field" type="hidden" value="${detail.uuid}"><!-- 给view的field属性自动赋值 -->
			</td>
			<td width="10%">视图字段名称*</td>   
			<td width="40%">
				<input name="labelOld" id="labelOld" type="hidden" value="${detail.view.label}">
				<input name="label" id="label" type="hidden" value="${detail.view.label}">
				<c:if test="${i18n == '0'}">
					<input name="labelName"  id="labelName" type="text" class="input_eq2" style="WIDTH:120px;"
				     		value="${detail.view.label}">
				</c:if>
				<c:if test="${i18n != '0'}">
				<input name="labelName" id="labelName" type="text" class="input_eq2" style="WIDTH:120px;"
				     		value="<rmp:msg value='${detail.view.label}'/>">
				</c:if>
				<input name="labelNameOld"  id="labelNameOld" type="hidden" 
				    value="<rmp:msg value="${detail.view.label}"/>">(资源key：${detail.view.label})
	 		</td>
		</tr>   
		<tr height="27px">
	 		<td width="10%">默认查询模式</td>
	 		<td width="40%">
	 	 		<select name="queryMode" id="queryMode" style="width:100px;" class="easyui-combobox">
		    		<c:forEach var="item" items="${queryMode}" varStatus="status">
						<option value="${item.dictKey}" ${detail.queryMode eq item.dictKey ? 'selected':''}>${item.dictValue}</option>
					</c:forEach>
				</select>
			</td>
			<td width="10%">验证格式<!--是否必输-->  </td> 
			<td width="40%">
				<select name="validator" id="validator" style="width:100px;" class="easyui-combobox">
			 		<option value=""></option>
		  		<c:forEach var="item" items="${validator}" varStatus="status">
					<option value="${item.dictKey}" ${detail.view.validator eq item.dictKey?' selected':''}>${item.dictValue}</option>
				</c:forEach>
				</select>
				<input name="required" type="hidden" value="${detail.view.required}"> 
				<!--<select name="required" id="required" style="width:100px;" class="textfield">
				   		<c:forEach var="item" items="${sysBoolean}" varStatus="status">
				  		<option value="${item.dictKey}" ${detail.view.required eq item.dictKey?' selected':''}>${item.dictValue}</option>
				</c:forEach>
						</select>
				-->
			</td>  
		</tr>    
	   	<tr height="27px">
    		<td width="10%">是否可导出</td>
    		<td width="40%">
	   			<select name="exportFlag" id="exportFlag" style="width:100px;" class="easyui-combobox">
	  				<rmp:option dictId="sys.boolean" currentValue="${detail.exportFlag}" defaultValue="1" />
				</select>
			</td>
			<td width="10%">是否启用</td>
			<td width="40%">
				<select name="useFlag" id="useFlag" style="width:100px;" class="easyui-combobox">
					<rmp:option dictId="sys.boolean" currentValue="${detail.useFlag}"/>
				</select> 
			</td>
		</tr> 
		<tr height="27px">  
			<td width="10%">排序模式</td>
			<td>
				<select name="orderMode" id="orderMode" style="width:100px;" class="easyui-combobox">
		 			<option value=""></option>    
	  				<rmp:option dictId="meta.viewOrderFlag" currentValue="${detail.orderMode}" />
	  			</select>
				<input name="viewwidthsOld" id="viewwidthsOld" type="hidden" value="${detail.orderMode}">
			</td> 
			<td width="10%">排序顺序</td> 
			<td width="40%">
				<input name="orderSort"  id="orderSort" type="text" class="input_eq2" value="${detail.orderSort}">
				<input name="orderSortOld" id="orderSortOld" type="hidden" value="${detail.orderSort}">&nbsp;(小数字优先排序)
			</td>
		</tr>
	<!--<tr height="27px">
	    <td width="10%" bgcolor="#EFF3FF">验证格式</td>
	    <td width="40%" bgcolor="#EFF3FF">
	 <select name="validator" id="validator" class="textfield">
	       <option value=""></option>
	        <c:forEach var="item" items="${validator}" varStatus="status">
	       	<option value="${item.dictKey}" ${detail.view.validator eq item.dictKey?' selected':''}>${item.dictValue}</option>
	 	</c:forEach>
	</select>
	    </td>
	    <td width="10%" bgcolor="#EFF3FF">是否只读</td>
	    <td width="40%" bgcolor="#EFF3FF">
	     <select name="isReadonly" id="isReadonly" style="width:100px;" class="textfield">
	          <c:forEach var="item" items="${sysBoolean}" varStatus="status">
	       	<option value="${item.dictKey}" ${detail.view.isReadonly eq item.dictKey?' selected':''}>${item.dictValue}</option>
	 	 </c:forEach>
	     </select>
	    </td>
	  </tr>   
	  <tr height="27px">
	    <td width="10%" bgcolor="#EFF3FF">视图CSS样式</td>
	    <td width="40%" bgcolor="#EFF3FF">
	   <input name="cssclass" id="cssclass"  type="text" class="textfield" style="WIDTH:200px;" value="${detail.view.cssclass}">
	    </td>
	    <td width="10%" bgcolor="#EFF3FF">视图描述信息</td>
	    <td width="40%" bgcolor="#EFF3FF">
	    	 	<input name="descn" id="descn"  type="text" class="textfield" style="WIDTH:200px;" value="${detail.view.descn}">
	 </td>
	  </tr>-->
	
		<c:if test="${detail.floatNumberPropertyType eq true}">
		<tr height="27px">
			<td width="10%">最大值</td>
		    		<td width="40%">
		 		<input name="maxValue" id="maxValue"  type="text" class="input_eq2" style="WIDTH:100px;" value="${detail.maxValue}">
			</td>
			<td width="10%">最小值</td>
			<td width="40%">
				<input name="minValue" id="minValue"  type="text" class="input_eq2" style="WIDTH:100px;" value="${detail.minValue}">
	 		</td>
		</tr> 		    
		<tr height="27px">
			<td width="10%">放大系数</td>
			<td width="40%">
				<input name="multiple" id="multiple"  type="text" class="input_eq2" style="WIDTH:50px;" value="${detail.multiple}">(显示时自动放大：率放大，万元缩小)
	 		</td>
	 		<td width="10%">显示货币分隔符</td>  
	 		<td width="40%">  
				<select name="currDelimFlag" id="currDelimFlag" style="width:100px;"  class="easyui-combobox">
	 				<rmp:option dictId="sys.boolean" currentValue="${detail.currDelimFlag}" defaultValue="0"/>
				</select>    
			</td>
		</tr> 	   
		<tr height="27px">
	 		<td width="10%">小数位数</td>
	 		<td width="40%">
				<input name="fractDigits" id="fractDigits" type="text" value="${detail.view.fractDigits}" style="width:100px;" class="input_eq2" >
	 		</td>
	 		<td width="10%"></td>
	 		<td width="40%"></td>
		</tr> 
		</c:if>
	</table>
	<br>
	</div>	    
	<div class="zh_btn" style="margin:0 0 25px 25px;">
		<input class="zh_btnbg2" type="button" onclick="saveColumn();"  value="保存"/>
		<input class="zh_btnbg2" type="button" onclick="returnTableDetail();" value="返回"/>
	</div>
</form>
</div>
</body>
</html>