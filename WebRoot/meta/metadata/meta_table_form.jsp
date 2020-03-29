<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<jsp:include page="../../loading.jsp" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>${model.comment}-${model.tableName}-元数据信息</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
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
function checkPkGenMode() {
    var pkGenModeValue = $('#pkGenMode').combobox('getValue');
    var primaryKey = $("#primaryKey").val();
    if (!primaryKey) {
        $.messager.alert('系统提示', '元数据没有主键，不能保存!', 'warning');
        return false;
    }
    
    var primaryKeyPropertyType = $("#wordInfo").contents().find("#primaryKeyPropertyType").val();
    
    if (pkGenModeValue == "uuid") {
        if (primaryKeyPropertyType != 'java.lang.String') {
            $.messager.alert('系统提示', '主键字段属性不是string，此时主键生成策略不能选择\"uuid\"!', 'warning');
            return false;
        }
    } else if (pkGenModeValue == "sequence" || pkGenModeValue == "identity") {
        if (primaryKeyPropertyType != 'java.lang.Long') {
            $.messager.alert('系统提示', '主键生成策略为sequence和indentity时，主键字段类型必须是数值!', 'warning');
            return false;
        }
        var sequenceName = $('#sequenceName').combobox('getValue');
        if (pkGenModeValue == "sequence" && sequenceName == "") {
            $.messager.alert('系统提示', '如果主键生成策略是序列，则oracle序列必需选择!', 'warning');
            return false;
        }
    }
    return true;
}

function codeGen() {
    var xform = document.editForm;
    if (xform.deployFlag.value == '' || xform.deployFlag.value == '0') {
        $.messager.alert('系统提示', '当前表的元数据xml信息尚未发布!', 'warning');
        return false;
    }
    
    if (!validatorField() || !checkPkGenMode())
        return false;
    
    xform.action = "${pageContext.request.contextPath}/metaModelXml_codegen.action";
    xform.submit();
}

//保存并发布
function deployToXml() {
    if (!validatorField() || !checkPkGenMode())
        return false;
    
    var url = "${pageContext.request.contextPath}/metaModelXml_deployToXml.action";
    $.post(url, $("#editForm").serialize(), function(data) {
        data = eval("(" + data + ")");
        if (data != null && data.msg != null) {
            document.editForm.deployFlag.value = 1; //修改已发布标识
            $.messager.alert('系统提示', data.msg, 'warning');
        } else {
            $.messager.alert('系统提示', "发布失败,请刷新重试!", 'warning');
        }
    });
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
    fieldName: {
        validator: function(value, param) {
            var validateFlag = param[0];
            $.fn.validatebox.defaults.rules.fieldName.message = validateFlag.msg;
            
            var result = true;
            //验证状态字段和审批角色
            if (validateFlag.id) {
                var auditRoleCode = $("#auditRoleCode").combobox("getValue");
                var statusColumn = $("#statusColumn").combobox("getValue");
                if (auditRoleCode && !statusColumn)
                    result = false;
            } else if (!value || !$.trim(value) || value == "$NO_COMMENT")
                result = false;
            return result;
        },
        message: ""
    }
});

$(function() {
    window.changeDisplay = function(id) {
        var obj = document.getElementById(id);
        var userDocFlg = obj.style.display;
        if (userDocFlg == "none") {
            obj.style.display = "block";
        } else {
            obj.style.display = "none";
        }
    };
    
    function selectSequence(pkGenMode) {
        if (!pkGenMode)
            pkGenMode = $("#pkGenMode").combobox("getValue");
        if (pkGenMode != 'sequence') {
            //如果生成方式不是序列，后面的序列下拉列表不显示，并默认为空
            $("#sequenceName").combobox("clear");
            $("#sequenceNameTD1").hide();
            $("#sequenceNameTD2").hide();
        } else {
            //如果生成方式是序列，后面的序列下拉列表重新显现出来
            $("#sequenceNameTD1").show();
            $("#sequenceNameTD2").show();
        }
    }
    selectSequence();
    //根据数据库类型修改catalog和schema的可修改性
    var databaseName = $("#databaseName").val();
    //如果使用的数据库为oracle，模型界面的catalog设置为只读
    $("#catalog").attr("readOnly", databaseName == 'oracle');
    //当数据库类型为sqlserver，模型界面的schema设置为只读,改为也可修改
    $("#schema").attr("readOnly", databaseName == 'sqlserver');
    
    $('#pkGenMode').combobox({
    	panelHeight:80,
        onChange: function(newValue, oldValue) {
            selectSequence(newValue);
        }
    });
    
    window.goBack = function() {
        window.location = "${pageContext.request.contextPath}/meta/metadata/meta_table_list.jsp";
        return false;
    };

    //表格自适应屏幕高度
    var heightValue = $(document).height() - 95;
    if (heightValue > 0)
        $("#tt").tabs({height: heightValue});
    
    $('#uniqueNameColumn').combobox({
    	panelWidth:250
    });
    $('#auditRoleCode').combobox({
    	panelHeight:100
    });
    $('#statusColumn').combobox({
    	panelWidth:250
    });
    $('#defaultFilterProp').combobox({
    	panelWidth:250
    });
    $('#defaultFilterMode').combobox({
    	panelHeight:120
    });
    $('#sequenceName').combobox({
    	panelHeight:120,
    	panelWidth:250
    });
    $('#logFlag').combobox({
    	panelHeight:40
    });
    $('#parentColumn').combobox({
    	panelHeight:120,
    	panelWidth:250
    });
});
</script>
</head>
<body>
<div style="padding:30px;">
	<div class="table_tt"><font class="blue">元数据模型</font></div>
	<div id="tt" class="easyui-tabs" style="height:340px;border:#c0c0c0 1px solid;border-top-style: none;">
		<div title="基本信息" id="basicInfo">
			<div style="padding:25px;">
			<form name="editForm" id="editForm" action="${pageContext.request.contextPath}/metaModelXml_save.action"  method="post">
				<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
		            <tr>
					    <td width="10%" height="32px">表名(别名)</td>
					    <td width="40%">  
						    <input name="uuid"  id="uuid"   type="hidden" value="${model.uuid}">
						    <input name="primaryKey"  id="primaryKey" type="hidden" value="${model.primaryKey}">
						    <input name="databaseName"  id="databaseName" type="hidden" value="${databaseName}">
						    <input name="tableName" id="tableName"  type="text" class="input_eq2" style="width:300px;" value="${model.tableName}">
					    </td>
					    <td width="10%">表注释信息</td>
					    <td width="40%">
						    <input name="comment"  id="comment" type="text" class="input_eq2 easyui-validatebox" value="${model.comment}" required="true" validType="fieldName[{msg:'请修改表注释信息!'}]">
						    <input name="commentNameOld"  id="commentNameOld" type="hidden" value="<rmp:msg value="${model.comment}"/>">
					    </td>
				  	</tr>
					<tr height="32px">  
						<td>实体类</td>
						<td>
							<input name="className" id="className" type="text" class="input_eq2" style="width:300px;" value="${model.className}"/>
						 </td>
						 <td>唯一名称字段</td>
						 <td>
							<select name="uniqueNameColumn" id="uniqueNameColumn" class="easyui-combobox easyui-validatebox" style="width:157px;" required="true" validType="fieldName[{msg:'名称字段必须选择!'}]">
					    		<rmp:option items="${fields}" prompt=""
											optionName="propertyName,view.label" 
											nameDelimer=" "
											optionValue="propertyName" 
											currentValue="${model.uniqueNameColumn}"/>  
							</select>
						<%--主键字段
						 <select name="primaryKey" id="primaryKey" style="width:100px;" class="selectfield">
						   <option value=""></option>
						    <c:forEach var="item" items="${requestScope.fields}" varStatus="status">
						     <c:if test="${not empty item.comment}">
						      <option value="${item.dbcolumn}" ${model.primaryKey eq item.dbcolumn?' selected':''}>${item.comment}</option>
						     </c:if>
						   </c:forEach>
						</select>
						--%>
						</td>
					</tr>
					<tr height="32px">
					    <td width="10%">ModelName</td>
					    <td width="40%">
					     	<input name="modelName"  id="modelName"  class="input_eq2" type="text" value="${model.modelName}" readonly>
					    </td>
					    <td width="10%">模块关键字</td>
					    <td width="40%">
					    	<input name="module" id="module" class="input_eq2 easyui-validatebox" type="text" value="${model.module}" required="true" validType="fieldName[{msg:'请修改模块关键字!'}]">
						    <input name="moduleOld"  id="moduleOld"   type="hidden" value="${model.module}" >
						    <input name="deployFlag"  id="deployFlag"   type="hidden" value="${model.deployFlag}" >
					    </td>  
				  	</tr>  
				 	<tr height="32px" style="display:none;">  
					    <td width="10%">多表连接SQL</td>
					    <td width="40%" colspan="3">  
					     	<textarea name="multiSql" id="multiSql" cols="83" rows="2">${model.multiSql}</textarea>
					    </td>
			 		</tr>
					 <tr height="32px">
					    <td width="10%">catalog</td>
					    <td width="40%">
					     	<input name="catalog"  id="catalog" class="input_eq2" type="text" value="${model.catalog}">
					    </td>
					    <td width="10%">schema</td>
					    <td width="40%">
						    <input name="schema"  id="schema" class="input_eq2" type="text" value="${model.schema}">
					    </td>  
					  </tr>
					  <tr>    	
					  	<td width="10%">审批角色</td>
					    <td width="40%">
					        <select name="auditRoleCode" id="auditRoleCode" class="easyui-combobox" style="width:157px;">
					       		<rmp:option items="${roles}" prompt=" "
					        				optionName="roleName" 
					        				optionValue="roleCode" 
					        				currentValue="${model.auditRoleCode}"/>
						    </select>
					    </td>
					    <td width="10%">状态字段</td>
					    <td width="40%">
					     	<select name="statusColumn" id="statusColumn" class="easyui-combobox easyui-validatebox" style="width:157px;" validType="fieldName[{id:'statusColumn', msg:'审批角色选择以后, 状态字段必须选择!'}]">
					     		<rmp:option items="${fields}" prompt=" "
					        				optionName="propertyName,view.label" 
					        				nameDelimer="  "
					        				optionValue="propertyName"
					        				currentValue="${model.statusColumn}"
					        			/> 
					     	</select>
					    </td>  
					  </tr>
					  <tr height="32px">
					    <td width="10%">默认过滤属性</td>
					    <td width="40%">
					      	<select name="defaultFilterProp" id="defaultFilterProp" class="easyui-combobox" style="width:157px;">
					       		<rmp:option items="${fields}" prompt=" "
					        				optionName="propertyName,view.label" 
					        				nameDelimer="  "
					        				optionValue="propertyName" 
					        				currentValue="${model.defaultFilterProp}"/>
						    </select>
					    </td>
					    <td width="10%">默认过滤方式</td>
					    <td width="40%">
						  <select name="defaultFilterMode" id="defaultFilterMode"  class="easyui-combobox" style="width:157px;">
						      	<rmp:option dictId="meta.defaultFilterMode" 
						      				currentValue="${model.defaultFilterMode}"
											defaultValue="uuid"
											prompt=" "/>
					       </select>
					    </td>  
					  </tr>
					  <tr height="32px">
					    <td width="10%">主键生成策略</td>
					    <td width="40%">
					     	<select name="pkGenMode" id="pkGenMode" class="easyui-combobox" style="width:157px;">
						      	<rmp:option dictId="meta.pkGenMode" 
						      				currentValue="${model.pkGenMode}"
											defaultValue="uuid"/>
					       </select>
					    </td>
					    <td width="10%"><div id="sequenceNameTD1">oracle序列</div></td>
					    <td width="40%">
					    	<div id="sequenceNameTD2">
						       <select name="sequenceName" id="sequenceName" class="easyui-combobox" style="width:157px;">
							      	 <c:forEach var="item" items="${sequences}" varStatus="status">
							       		<option value="${item}" ${model.sequenceName eq item ? 'selected':''}>${item}</option>
							 	 	 </c:forEach> 
						       </select>
					       </div>
					    </td>  
					  </tr>
					  <tr height="32px">
					    <td width="10%">是否记录日志</td>
					    <td width="40%">
					     	<select name="logFlag" id="logFlag" class="easyui-combobox" style="width:157px;">
					     		<rmp:option dictId="sys.boolean" currentValue="${model.logFlag}" defaultValue="0"/>
					     	</select>
					    </td>
					    <td width="10%">上级字段</td>
					    <td width="40%">  
							<select name="parentColumn" id="parentColumn" class="easyui-combobox" style="width:157px;">
		       		           <rmp:option items="${fields}" prompt=" "
		        				optionName="propertyName,view.label" 
		        				nameDelimer="  "
		        				optionValue="propertyName" 
		        				currentValue="${model.parentColumn}"/>  
			             	</select>
			           	</td>
					  </tr>
		            </table>
		         
					<div style="margin-top:25px;border-top: #CCC dotted 1px;padding-top: 10px;">
						<a onclick="changeDisplay('userDocDiv');"><font color="red">【使用帮助】</font></a>
						<input class=inputd type="button" name="genCode" value="保存并发布" onclick="deployToXml();">&nbsp;&nbsp;
						<c:if test="${not empty fields}">
						  	<input class="inputd" type="button" name="genCode" value="生成代码" onclick="changeDisplay('codegenDiv');">&nbsp;&nbsp;
						</c:if>
						<input class=inputd type="button" value="返回" onclick="goBack();">&nbsp;&nbsp;
						    	
						<div id="codegenDiv" style="bgcolor:#EFF3FF;width:95%;margin-left:10px;display:none;"><br> 
						JAVA 实体类信息&nbsp;<input name="entityMapping" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;
						<!--DAO接口和实现&nbsp;<input name="daoImpl" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;
						
						（是否逻辑删除<input name="daoImpl_logic_delete" type="checkbox" value="1" style="width:13px;height:13px">）
						
						业务接口和实现&nbsp;<input name="serviceImpl" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;
						Action&nbsp;<input name="actionCode" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;
						jspList&nbsp;<input name="jspList" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;
						jspForm&nbsp;<input name="jspForm" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;-->
						<!--pringController&nbsp;<input name="controllerCode" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;-->
						
						 <!--
						基于元数据的查询&nbsp;<input name="metadata_query" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;
						基于元数据的可编辑查询&nbsp;<input name="metadata_EditQuery" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;<br>-->
							<br><br><input class=inputd type="button" name="genCode2" value="开始生成" onclick="codeGen();">   
						</div>
						<div id="userDocDiv" style="bgcolor:#EFF3FF;width:100%;margin-left:1px;display:none;margin-bottom: 10px;">
						    1. modelName：即模型名称，为元数据模型的唯一标志，不允许修改，默认为表名下划线分割的最后一个单词。<br>
						    2. 主键生成策略：如主键的字段类型是字符串，主键生成策略只能选择uuid，并且系统推荐使用uuid，<br>
							如主键的字段类型是数字，主键生成策略必须选择序列(oracle)或自增列(sqlserver)。<br>
							3. 模块关键字：根据sysconfig.properties中的tableModuleIndex指定的序号，从表名中自动拆分，推荐为下划线分割的第1个或第2个单词，<br>
							如因表名不规范造成模块关键字混乱，请手动修改模块关键字。<br>
							4. 每次点击【保存并发布】元数据模型时，系统自动生成元数据模型的xml文件，并自动重新生成java实体类和hibernate映射文件。<br>
							元数据模型发布之后，如修改了 "模块关键字"，类名随之修改，再次发布将生成新的java实体类和hibernate映射文件，<br>
							请手动删除旧的实体类和映射文件，避免启动发生 "实体类重复" 异常。<br>
							5. 名称字段：以用户表的隶属机构字段为例，隶属机构字段外键关联机构表。用户表的名称字段为姓名，机构表的名称字段为机构名称。<br>
							用户表excel导入和导出时，系统需要使用 "机构表的名称字段" 来自动转换数据，<br>
							例如：用户表导出时系统自动把机构编号:"10001" 转换为 机构名称:"总行"，导入时系统自动把总行转换为 10001。<br>
							6. 是否记录日志如果勾选为”是“，则每次新增、修改、删除或导入时，系统将自动记录操作日志。操作日志可在系统管理模块查询。<br>
							7. 生成代码功能与配置参数补录功能无关，仅提供给项目组手动开发功能使用。<br>
							8. 限于目前版本底层使用Hibernate实现，eclipse环境需要做如下配置：<br>
							&nbsp;&nbsp;(1)打开本地项目自动刷新功能：Window->References->General->Workspace，勾选Refresh automatically。<br>
							&nbsp;&nbsp;(2)关闭自动编译功能：Project->取消Build Automatically。第一次【保存并发布】元数据模型后，hibernate需要项目重启后才能识别<br>
							新的java实体类，这时需要手动project项目，步骤: 选中ETLVP项目的根节点，Project->点击Build Project，手动重启Tomcat或等待项目自动重启。
						</div>
						</div>
   		 	</form>
   		 	</div>
    	</div>
		<div title="字段信息" style="overflow:hidden;width:100%;">
			<iframe scrolling="auto" frameborder="0" id="wordInfo" src="${pageContext.request.contextPath}/metaModelXml_fieldList.action?modelName=${model.modelName}" style="height:100%;width:100%"></iframe>
		</div>
		<div title="查询交易" style="overflow:hidden;width: 100%;">
			<iframe scrolling="auto" frameborder="0"  src="${pageContext.request.contextPath }/queryTrans_xml_list.action?modelName=${model.modelName}" style="height:100%;width: 100%"></iframe>
		</div>
	</div>
</div>
</body>
</html>