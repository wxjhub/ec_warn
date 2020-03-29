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
<title>创建用户</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>

<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
.tabs-panels{
	margin:0px;
	padding:0px;
	border-top:0px;
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
.tabs-panels{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	border: none;
}
</style>

<script type="text/javascript">
     $(document).ready(function(){//修改时用户账户不可编辑
         	 if($("#userId").val()==""){
         		$("#msg").text("用户信息添加");
         	 }else{
         		$("#msg").text("用户信息编辑");
         		document.getElementById("userName").readOnly=true;
         		//$('#userName').attr('disabled','disabled');
         	 }
             //双击从左到右 
            //document.getElementById("roleLeft").ondblclick=function(){
 				
 			//	var optionElements=this.getElementsByTagName("option");
 				
 			//	var selectElement=document.getElementById("selectRole");
 			//	selectElement.appendChild(optionElements[this.selectedIndex]);
 			//};
 			//双击从右到左
 			//document.getElementById("selectRole").ondblclick=function(){
             //    var optionElements=this.getElementsByTagName("option");
             //    var leftElement=document.getElementById("roleLeft");
              //   leftElement.appendChild(optionElements[this.selectedIndex]);
 	 	   // };
 	 	    $('#userFlg').combobox({
 	 		  panelHeight:'100%'
 	 	    });
 	 	  	//$('#roleType').combobox({
 	 		//  panelHeight:'100%'
 	 	   // });
 	 	    $('#isLDAP').combobox({
 	 	  	  panelHeight:'100%'
 	 	    });
     });
     
    
	function checkPasswordStr() {
		var password=document.getElementById("password").value;
		var passwordStr=document.getElementById("passwordStr").value;
		if (passwordStr!=""&&passwordStr!=password) {
			$.messager.alert('系统提示','两次输入的密码不一致！请重新输入密码！','warning');
		}
	}

	//输入时候支持回车
	  function changeFocus( )
	 { 
		if (event.keyCode==13)
    	 event.keyCode=9;
	 }
	document.onkeydown= changeFocus;
	//保存用户
	$(function(){
		$("#save").click(function() {
			//var role = document.getElementById("selectRole").options;
			var password=document.getElementById("password").value;
			var passwordStr=document.getElementById("passwordStr").value;
			var userId = $("#userId").val();
			//var roleId="";
			//for(var i = 0;i < role.length;i++){
			    //roleId+=role[i].value+",";
			//}
			if(password!=passwordStr){
                $.messager.alert('系统提示','两次输入的密码不一致！请重新输入密码！','warning');
			}else{
				$('#formSave').form('submit', {
			     	url:'secUser_save.action',
			    	onSubmit: function(){
			    	$('#userName').removeAttr('disabled');
				  	return $(this).form('validate');
				    },
				    success:function(data){
						var result=data;
						hasException(result);
						if(1==result) {
							 if($("#userId").val()==""){
								$.messager.alert('系统提示','用户添加成功','warning');
					         }else{
				         		$.messager.alert('系统提示','用户修改成功','warning');
				         	 }
							window.location.href = "${pageContext.request.contextPath}/sec/sec_user_list.jsp?pageNo=1&status=0";
						}
					} 
				 });
			}
		});
		$("#reset").click(function(){//用户基本信息重置按钮
			if('${user.userId}'){
				$('#realName').val('${user.realName}');
				$('#password').val('${user.password}');
				$('#passwordStr').val('${user.password}');
				$('#orgId').val('${user.org.orgId}');
				$('#orgName').val('${user.org.orgName}');
				$('#empNo').val('${user.empNo}');
				$('#idcard').val('${user.idcard}');
				$('#officePhone').val('${user.officePhone}');
	            $('#mobilePhone').val('${user.mobilePhone}');
	            $('#famliyPhone').val('${user.famliyPhone}');
	            $('#email').val('${user.email}');
	            $('#userFlg').combobox('setValue','${user.userFlg}');
            }else{
                $('#userName').val('');
    			$('#realName').val('');
				$('#password').val('');
				$('#passwordStr').val('');
				$('#orgId').val('');
				$('#orgName').val('');
				$('#empNo').val('');
				$('#idcard').val('');
				$('#officePhone').val('');
	            $('#mobilePhone').val('');
	            $('#famliyPhone').val('');
	            $('#email').val('');
            	$('#isLDAP').combobox('setValue','1');
            	$('#userFlg').combobox('setValue','1');
				$('#formSave').form('validate');
             }
			var selectElement=document.getElementById("selectRole");
			var leftElement=document.getElementById("roleLeft");
			var removeLeftOptions = $("#selectRole > option[lang='left']");
			for( var i = 0; i< removeLeftOptions.length; i++){
				leftElement.appendChild(removeLeftOptions[i]);
			}
			var removeRightOptions = $("#roleLeft > option[lang='right']");
			for( var i = 0; i< removeRightOptions.length; i++){
				selectElement.appendChild(removeRightOptions[i]);
			}
		});
	});


	function queryRole(){
		var searchName = $("#searchName").val();
		var selectRole = document.getElementById("selectRole").options;
		var roleType = $("#roleType").combobox("getValue");
		 $.ajax({
		     type: "POST",
		     url: "${pageContext.request.contextPath}/secUser_queryRolesByRoleName.action",
		     data: {roleName:searchName,roleType:roleType},
		     dataType:"text",
		     success: function(json){
			     var result = $.parseJSON(json);  //使用这个方法解析json
		         $("#roleLeft").text("");
			         for(var i=0;i<result.length;i++){
			        	 var bool = true;
				         for(var j=0;j<selectRole.length;j++){
					         if(result[i].roleId==selectRole[j].value){
						         bool=false;
						       }
					   		}
					 if(bool){
		             	var input_tr=$("<option value='"+result[i].roleId+"'>"+result[i].roleName+"</option>");
		             	$("#roleLeft").append(input_tr);
					  }
		         	}
		     }
		  });
	}
	
	
	$.extend($.fn.validatebox.defaults.rules, {
		userName: {
			validator:function(value, param){
				value=value.replace(/(^\s*)|(\s*$)/g, "");
				if(!/^[a-zA-Z0-9_]{3,16}$/.test(value)){
					$.fn.validatebox.defaults.rules.userName.message ="只可输入(3-16)位的英文字母、数字和下划线！";
		            return false;
				}
				var userId=document.getElementById("userId").value;
				if(!userId){
					 var exist=$.ajax({
			                url:"${pageContext.request.contextPath}/secUser_checkUserName.action",
			                data:{userName:value},
			                async:false
			            }).responseText;
					 if(exist=="0"){
				            $.fn.validatebox.defaults.rules.userName.message ="此用户账号可以注册！";
				            return true;
				        }else{
				        	$.fn.validatebox.defaults.rules.userName.message ="用户账号已存在，无法使用！";
				            return false;
					    }
			        }else{
			        	$.fn.validatebox.defaults.rules.userName.message ="";
			            return true;
				    }
		    	},
			message:""
		 },
		 realName:{
			validator:function(value, param){
				if(!/^[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(value)){
					$.fn.validatebox.defaults.rules.realName.message ="只可输入字母汉字数字_！";
		            return false;
				}else if(!/^[a-zA-Z0-9_\u4e00-\u9fa5]{1,50}$/.test(value.replace(/(^\s*)|(\s*$)/g, ""))){
					$.fn.validatebox.defaults.rules.realName.message ="输入长度超过最大限度值";
		            return false;
				}else{
					$.fn.validatebox.defaults.rules.realName.message ="";
		            return true;
				}
			},
			message:""
		}
	});
	function goBack(){
		 window.location.href = "${pageContext.request.contextPath}/sec/sec_user_list.jsp";
	}

	function selectOrgan(){
		showModalCenter ("${pageContext.request.contextPath}/sec/tree/sec_organ_tree.jsp", function(data){
				$("#orgId").val(data[0].id);
				$("#orgName").val(data[0].name);
			}, "400", "88%", "机构树");
	}
</script>
</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><font class="blue" id="msg"></font></div>
<div id="tt" class="easyui-tabs" tools="#tab-tools" style="height:340px;border:#c0c0c0 1px solid;border-top-style: none;">
		<div title="用户基本信息">
			<FORM name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;border-style: none">
				<input type="hidden" id="userId" name="userId" value="${user.userId}"></input>
				<div id="myTab1_Content0" >
					<table cellSpacing="0" cellpadding="0" border="0">
						<tr>
							<td width="80px" height="32px">用户账号：</td>
							<td width="260px" height="32px">
								<input type="text" class="easyui-validatebox input_eq2" required="true" validType="userName"
								missingMessage="请输入用户账号！"
								name="userName"  id="userName" value="${user.userName}"/><span style="color: red;font-size: 15px;"> *</span>
								<!-- <input style="margin: 0px" class="inputd" type="button" value="检查账号" onclick="checkUserName()" /> -->
							</td>
							<td width="80px" height="32px" style="padding-left: 20px">用户姓名：</td>
							<td width="170px" height="32px"><input type="text"
								class="easyui-validatebox input_eq2" required="true" 
								missingMessage="请输入用户姓名！" validType="realName"
								name="realName" id="realName" value="${user.realName}" /><span style="color: red;font-size: 15px;"> *</span>
							</td>
						</tr>
						<tr>
							<td width="80px" height="32px">用户密码：</td>
							<td width="260px" height="32px">
								<input type="password"
								class="easyui-validatebox input_eq2" required="true" missingMessage="请输入密码!" 
								validType="length[6,18]"
								name="password" id="password" value="${user.password}" />
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
							<td height="32px" style="padding-left: 20px">确认密码：</td>
							<td height="32px">
								<input type="password"
								class="easyui-validatebox input_eq2" required="true" missingMessage="请再次输入密码！" 
								validType="length[6,18]" onblur="checkPasswordStr()"
								name="passwordStr" id="passwordStr" value="${user.password}" />
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
						</tr>
						<tr>
							<td height="32px">所属机构：</td>
							<td height="32px">
								<input type="hidden" id="orgId" name="orgId" value="${user.org.orgId}">
								<input type="text" class="input_eq2" id="orgName" name="orgName" value="${user.org.orgName}" readonly="readonly">
								<input type="button" class="inputd" value="选择" onclick="selectOrgan();">
								<%--
								<input id="parentOrgan" class="easyui-combotree tree-node-hover tree-node" name="parentOrgan"  style="width: 157px;">
								--%>
							</td>
							<td height="32px" style="padding-left: 20px">用户状态：</td>
							<td width="40px" height="32px">
								<select name="userFlg" class="easyui-combobox" id="userFlg" required="true"   missingMessage="请选择用户状态"  >
									<rmp:option dictId="sys.userFlg"  currentValue="${user.userFlg}"  prompt=""  defaultValue="1"></rmp:option>
								</select>
							</td>
							  
						</tr>
						<tr>
							
							<td height="32px">员工编号：</td>
							<td height="32px"><input type="text"
								style="width: 150px" class="easyui-validatebox input_eq2" validType="length[0,50]" name="empNo" id="empNo"
								value="${user.empNo}" /><span id="empNoTxt"></span></td>
							<td height="32px" style="padding-left: 20px">身份证号：</td>
							<td height="32px"><input type="text"
								style="width: 150px" name="idcard" id="idcard"
								value="${user.idcard}" class="easyui-validatebox input_eq2" validType="idcard"/><span id="idcardTxt"></span></td>
						</tr>
						<tr>
							
							<td height="32px">办公电话：</td>
							<td height="32px"><input type="text"
								style="width: 150px" name="officePhone" id="officePhone"
								value="${user.officePhone}" class="easyui-validatebox input_eq2" validType="telePhone" /><span id="officePhoneTxt"></span></td>
							<td height="32px" style="padding-left: 20px">移动电话：</td>
							<td height="32px"><input type="text"
								style="width: 150px" name="mobilePhone" id="mobilePhone"
								value="${user.mobilePhone}" class="easyui-validatebox input_eq2" validType="mobilePhone" /><span id="mobilePhoneTxt"></span></td>
						</tr>
						<tr>
							
							<td height="32px">家庭电话：</td>
							<td height="32px"><input type="text"
								style="width: 150px" name="famliyPhone" id="famliyPhone"
								value="${user.famliyPhone}" class="easyui-validatebox input_eq2" validType="telePhone" /><span id="famliyPhoneTxt"></span>
							</td>
							<td height="32px" style="padding-left: 20px">邮件地址：</td>
							<td height="32px" colspan="4"><input type="text"
								name="email" id="email" value="${user.email}" class="easyui-validatebox input_eq2" validType="email"/><span
								id="emailTxt"></span>
							</td>
						</tr>
						<c:if test="${isLdap == '1'}">
							<tr>
								<td width="500px" height="32px" colspan="4">是否同步到LDAP：&nbsp;&nbsp;
									<select name="isLdap" class="easyui-combobox" id="isLDAP" style="width: 120px;">
										<rmp:option dictId="sys.isLDAP" defaultValue="0" currentValue="${user.isLdap}"></rmp:option>
									</select>
								</td>
							</tr>
						</c:if>
						<tr>
							<td colspan="4" height="50" style="color: red">提示：带（*）为必填项</td>
						</tr>
					</table>
				</div>
				<input type="hidden" name="deptId" value="${user.deptId}">
				<input type="hidden" name="status" value="${user.status}">
				<input type="hidden" name="createTime" value="${user.createTime}">
				<input type="hidden" name="createUser" value="${user.createUser}">
				<input type="hidden" name="updateUser" value="${user.updateUser}">
				<input type="hidden" name="updateTime" value="${user.updateTime}">
				<input type="hidden" name="lockedTime" value="${user.lockedTime}">
				<input type="hidden" name="userFlg" value="${user.userFlg}">
				<input type="hidden" name="isFirstLogin" value="${user.isFirstLogin}">
				<input type="hidden" name="lastLoginTime" value="${user.lastLoginTime}">
				<input type="hidden" name="loginNum" value="${user.loginNum}">
				<input type="hidden" name="oldPwd" id="oldPwd" value="${user.oldPwd}">
				<input type="hidden" name="hisPwd" id="hisPwd" value="${user.hisPwd}">
				<input type="hidden" name="pwdErrorNum" value="${user.pwdErrorNum}">
				<input type="hidden" name="pwdModifyTime" value="${user.pwdModifyTime}">
				<input type="hidden" name="remark" value="${user.remark}">
				<input type="hidden" name="field1" value="${user.field1}">
				<input type="hidden" name="field2" value="${user.field2}">
				<input type="hidden" name="field3" value="${user.field3}">
				<input type="hidden" name="field4" value="${user.field4}">
			</FORM>
		</div>
		<!--<div title="用户角色配置" closable="false" style="overflow:hidden">
			<form id="roleSearch" name="roleSearch" method="post" style="padding:25px 0 0 25px;border-style: none">
				角色名：<input type="text" name="searchName" id="searchName" class="input_eq2"/>
				<input class="inputd" type="button" value="查  询" onclick="queryRole()"/><br/><br/>
			</form>
			<div style="float:left;padding-left: 25px;">
				<select id="roleLeft" name="roleLeft" style="width:250px;height:200px;" multiple="multiple">
					<c:forEach items='${listRoles}' var='item'>
						<option value='${item.roleId }'lang="left" class="item_icon">&nbsp;&nbsp;${item.roleName }</option>
					</c:forEach>
				</select>
			</div>
			<div style="float:left;padding:45px 20px 0 20px;">
				<input type="button" value="" id="PutRightOne" class="add1" onclick="move('roleLeft','selectRole')" /><br />
				<input type="button" value="" id="PutRightAll" class="add2" onclick="moveAll('right')" /><br /></br>
				<input type="button" value="" id="PutLeftOne" class="add3"  onclick="move('selectRole','roleLeft')" /><br />
				<input type="button" value="" id="PutLeftAll" class="add4" onclick="moveAll('left')" />
			</div>
			<div>
				<select id="selectRole" name="selectRole" style="width:250px;height:200px;" multiple="multiple" >
					<c:forEach var="item" items="${selectedRoles}" varStatus="status">
						<option value='${item.roleId}' selected="selected" lang="right">&nbsp;&nbsp;${item.roleName}</option>
					</c:forEach>
				</select>
			</div>
		</div>
	--></div>
	<div class="tool_btn">
		<div style="float: right;">
			<input class="zh_btnbg2" type="button" id="save" value="保存"/>
			<input type="reset" id="reset" class="zh_btnbg2" value="重置" />
			<input type="button" class="zh_btnbg2" onclick="goBack()" value="返回" />
		</div>
	</div>
</div>
</body>
</html>
﻿
