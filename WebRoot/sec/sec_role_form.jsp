<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setDateHeader("Expires", 0); //防止代理服务器缓存页面
	String organStr=request.getParameter("organStr");
%>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>创建角色</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>
<h:js src="default/combobox.js"></h:js>
<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
.tabs-panels{
	margin:0px;
	padding:0px;
	border:0px;
	overflow:hidden;
	background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
}
.combo{
	display:inline-block;
	white-space:nowrap;
	font-size:12px;
	margin:0;
	padding:0;
	border-radius:5px;
	-moz-border-radius:5px;
	border:1px solid #d8d8d8;
	background:#fff;
}
.combo-text{
	font-size:12px;
	border:0px;
	line-height:20px;
	height:20px;
	padding:0px;
	*height:18px;
	*line-height:18px;
	_height:18px;
	_line-height:18px;
	background:url(${pageContext.request.contextPath}/images/select_bg.png) repeat-x;
}
</style>
<script type="text/javascript">
		//输入时候支持回车
		function changeFocus()
		{
			//9 is [tab]
			//13 is [Enter] 
			if (event.keyCode==13)
			event.keyCode=9;
		}
		document.onkeydown= changeFocus;
		
        $(function(){
        	if($("#roleId").val()==""){
		  		$("#msg").text("角色信息添加");
		  	 }else{
		  		$("#msg").text("角色信息编辑");
		  	 }
			$('select').combobox({
				panelHeight:'100%'
			});

			$("#reset").click(function(){
    			if('${role.roleId}'){
                    $('#roleName').val('${role.roleName}');
                    $('#roleCode').val('${role.roleCode}');  
                    $('#admFlg').combobox('setValue','${role.admFlg}');
                    $('#roleType').combobox('setValue','${role.roleType}');
                    $('#roleDesc').val('${role.roleDesc}');
              	}else{
              		$('#roleName').val('');
                      $('#roleCode').val('');  
                      $('#admFlg').combobox('setValue','');
                      $('#roleType').combobox('setValue','');
                      $('#roleDesc').val('');
                      $('#mgrRoleId').combobox('setValue','');
                  }
    			$('#roleFormSave').form('validate');
    		});

    		
        });

        function add() {
			var flag = true;
			$('#roleFormSave input').each(function () {
			    if ($(this).attr('required') || $(this).attr('validType')) {
				    if(this.id != 'mgrRoleId'){
					    if (!$(this).validatebox('isValid')) {
						    flag = false;
					    }
					}
			    }
			});

			if($("#roleId").val()==""){
			    if (!$("#mgrRoleId").combobox('isValid')) {
				    flag = false;
			    }
			}
			if(flag) {
				$("#roleFormSave").submit();
			}
		}

        //设置默认选中第一项
        function select() {
            var data = $("#mgrRoleId").combobox("getData");
            $("#mgrRoleId").combobox("select", data[0].roleId);
        }

    	$.extend($.fn.validatebox.defaults.rules, {
    		roleCode:{
		    validator:function(value, param){
	              if(!/^(ROLE_[0-9a-zA-Z_]+)$/.test(value.replace(/(^\s*)|(\s*$)/g, ""))){
	            	  $.fn.validatebox.defaults.rules.roleCode.message = '只可输入英文字母、数字和下划线，注：必须以\"ROLE_\"开头';
	            	  return false;
		          }
		          if(!/^(ROLE_[0-9a-zA-Z_]{1,35})$/.test(value.replace(/(^\s*)|(\s*$)/g, ""))){
	            	  $.fn.validatebox.defaults.rules.roleCode.message = '输入长度超过最大限度值';
	            	  return false;
		          }
		          var roleId=$('#roleId').val();
		          if(!roleId){
                      var exist=$.ajax({
                    	url:"${pageContext.request.contextPath}/role_checkRoleCode.action",
			                data:{roleCode:value},
			                async:false
                      }).responseText;
                      if(exist=="0"){
				            $.fn.validatebox.defaults.rules.roleCode.message ="此角色编码可以使用！";
				            return true;
				          }else{
				        	$.fn.validatebox.defaults.rules.roleCode.message ="角色编码已存在，无法使用！";
				            return false;
					      }
			      }else{
			        	$.fn.validatebox.defaults.rules.roleCode.message ="";
			            return true;
				  }
	         },
	         messsge:""
		 },
    	    roleName:{
                 validator:function(value,param){
                    value=value.replace(/(^\s*)|(\s*$)/g, "");
                    if(!/^([\u4E00-\u9FA5a-zA-Z]+)$/.test(value)){
                    	$.fn.validatebox.defaults.rules.roleName.message = '只可输入英文字母和中文';
                    	return false;
                    }
                    var len = value.replace(/[^\x00-\xff]/g,"aa").length;
                    if(len>64){
                    	$.fn.validatebox.defaults.rules.roleName.message = '输入长度超过最大限度值';
                    	return false;
                    }
                    $.fn.validatebox.defaults.rules.roleName.message ="";
		            return true;
                },
                message:""
	        }
    	});

		function goBack(){
			window.location.href = "${pageContext.request.contextPath}/sec/sec_role_list.jsp";
		}
</script>
</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><font class="blue" id="msg"></font></div>
<div id="tt" class="easyui-tabs" tools="#tab-tools" style="height:340px;border:#c0c0c0 1px solid;border-top-style: none;">
		<div title="角色基本信息" >
			<table>
				<TR>
				<TD noWrap height=40px valign="middle" style="padding-left: 25px;">
				<FORM name="roleFormSave" id="roleFormSave" method="post" action="${pageContext.request.contextPath}/role_save.action" style="padding-top: 25px;border-style: none">
				<input type="hidden" id="roleId" name="roleId" value="${role.roleId}"></input>
				<input type="hidden" id="msg" name="msg" value="${msg}"></input>
				<div id="myTab1_Content0" >
					<table cellSpacing="0" cellpadding="0" border="0">
						<tr>
							<td width="80px" height="40px" >角色名称：</td>
							<td height="40px">
								<input type="text" class="easyui-validatebox input_eq2" required="true" validType="roleName"
								missingMessage="只可输入英文名或者中文名"
								name="roleName" id="roleName" value="${role.roleName}" />
								<span style="color: red;font-size: 15px;"> *</span>
								</td>
						</tr>
						<tr>
							<td width="80px" height="40px" >角色编码：</td>
							<td height="40px">
								<input type="text" class="easyui-validatebox input_eq2" required="true" 
									missingMessage="请输入角色编码"
									name="roleCode" validType="roleCode" id="roleCode" value="${role.roleCode}"/>
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
						</tr>
						<tr>
							
							<td width="80px" height="40px" >角色描述：</td>
							<td height="40px"><input type="text"
								class="easyui-validatebox input_eq2" validType="length[0,100]" name="roleDesc" id="roleDesc"
								value="${role.roleDesc}" /><span id="empNoTxt"></span></td>
						</tr>
						<c:if test="${role.roleId == null}">
						<tr>
							<td width="80px" height="40px" >管理角色：</td>
							<td height="40px">
								<r:combobox onLoadSuccess="select()" url="${pageContext.request.contextPath}/role_initMgrRoleTree.action" valueField="roleId" textField="roleName" id="mgrRoleId" style="width:156px" missingMessage="请选择管理角色" name="mgrRoleId" required="true" ></r:combobox>
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
						</tr>
						</c:if>
						<tr>
							<td colspan="2" height="40px" style="color: red">提示：带（*）为必填项</td>
						</tr>
						<tr>
							
							<td height="40px" colspan="2">
								<input class="zh_btnbg3" onclick="add()" type="button"  value="保存基本信息"/>
								<input type="reset" id="reset" class="zh_btnbg2" value="重置" />
							</td>
						</tr>
						
					</table>
				</div>
				<input type="hidden" name="status" value="${role.status}">
				<input type="hidden" name="field1" value="${role.field1}">
				<input type="hidden" name="field2" value="${role.field2}">
				<input type="hidden" name="field3" value="${role.field3}">
				</FORM>
				</TD>
			</TR>
			</table>
		</div>
		<!--
		<c:if test="${!empty role}">
			<div title="配置权限" closable="false" style="overflow:hidden">
				<iframe scrolling="yes" frameborder="0" src="${pageContext.request.contextPath}/role_toRightPage.action?roleId=${role.roleId}" style="width:100%;height: 300px;background: none;"></iframe>
			</div>
			 
			<div title="可管理角色" closable="false" style="overflow:hidden">
				<iframe scrolling="no" frameborder="0" src="${pageContext.request.contextPath}/role_toMgrPage.action?roleId=${role.roleId}" style="width:100%;height: 300px;background: none"></iframe>
			</div>	
		</c:if>
		-->
	</div>
	<div class="tool_btn">
		<div style="float: right;">
			<input type="button" class="zh_btnbg2" onclick="goBack()" value="返回" />
		</div>
	</div>
</div>
</body>
</html>
﻿
