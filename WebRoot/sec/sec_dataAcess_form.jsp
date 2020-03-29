<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据权限表单界面</title>
	<link href="${pageContext.request.contextPath}/css/ligerui/Aqua/css/default-all.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ligerui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ligerFilter.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
    
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
	<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>

    <script type="text/javascript">
        $(function () {
            //如果是编辑数据权限，实体类名不可改
            var dataAcessId="${dataAcessId}";
            if(dataAcessId!=""){
               $("#className").attr("readonly",true);
               $("#editDataAcess").attr("disabled",true);
            }
           	var fields = ${fields};
           	if(fields.toString() == null || fields.toString() == "") {
           		$("#filter").hide();
            } else {
            	var filter = $("#filter").ligerFilter({ fields: fields });
            	$("#filter").show();
            }
            var rule=${rule};
            if(rule!=""){
            	filter.setData(rule);
            }
            
            $("#editDataAcess").click(function(){
                var className= $("#className").val();
                if(className==""){
                	$.messager.alert('系统提示','请输入资源实体类！','warning');
                }else{
                	//异步检查：捕获反射错误
                	$.ajax({
                        dataType:'text',
                        url:'dataAcess_checkClassName.action',
                        type:'post',
                        data:{'className':className},
                        success:function(data){
                             if(data=="0"){
                            	 window.location.href ="${pageContext.request.contextPath}/dataAcess_toForm.action?className=" + className;
                              }else if(data=="1"){
                            	 $.messager.alert('系统提示','输入的资源实体类已拥有数据权限请重新输入！','warning');
                              }else if(data=="2"){
                            	 $.messager.alert('系统提示','输入的资源实体类不存在请重新输入！','warning'); 
                              }
                        }
                     });
                }
            });

            $("#submit").click(function () {
                if(filter==undefined){
                    $.messager.alert('系统提示','请先配置数据权限实体类！','warning');
                }else{
                	var group = filter.getData();
                    var rule=$.ligerui.toJSON(group);
                    var dataAcessId=$("#dataAcessId").val();
                    var className=$("#className").val();
                    if(rule=='{"op":"and"}'){
                    	$.messager.alert('系统提示','请增加条件！','warning');
                    }else{
                        $.ajax({
                           dataType:'text',
                           url:'dataAcess_save.action',
                           type:'post',
                           data:{"rule":rule,"dataAcessId":dataAcessId,"className":className},
                           success:function(data){
                        	   window.location.href ="${pageContext.request.contextPath}/sec/sec_dataAcess_list.jsp";
                           }
                        });
                    }
                }
            });
            $("#userName").click(function(){
            	$("#"+textId+"").val("\${UserInfo.userName}");
            });

            $("#userId").click(function(){
            	$("#"+textId+"").val("\${UserInfo.userId}");
            });

            $("#userOrganName").click(function(){
           		$("#"+textId+"").val("\${UserInfo.userOrganName}");		
            });

            $("#userOrganId").click(function(){
            	$("#"+textId+"").val("\${UserInfo.userOrganId}");
            });

            $("#directChildOrgIds").click(function(){
            	$("#"+textId+"").val("\${UserInfo.directChildOrg.orgIds}");
            });

            $("#directChildOrgNames").click(function(){
            	$("#"+textId+"").val("\${UserInfo.directChildOrg.orgNames}");
            });

            $("#inDirectChildOrgIds").click(function(){
            	$("#"+textId+"").val("\${UserInfo.inDirectChildOrg.orgIds}");
            });

            $("#inDirectChildOrgNames").click(function(){
            	$("#"+textId+"").val("\${UserInfo.inDirectChildOrg.orgNames}");
            });
        });
     
        var textId="";   
   		function getId(id){
   			textId=id;
   		}

        function getUserName(){
        	$("#"+textId+"").val("\${UserInfo.userName}");
        }
    
        function goBack(){
   		 window.location.href ="${pageContext.request.contextPath}/sec/sec_dataAcess_list.jsp";
   		}
         
    </script> 
    <style type="text/css">
        #txtGroup
        {
            height: 100px;
            width: 1103px;
        }
        .groupopsel{
			display:none;
		}
		#formSave .inputd{
			padding: 0 5px 0 5px;
			margin: 5px 0 5px 0;
		}
</style>
</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><font class="blue" id="msg">数据权限配置</font></div>
	<form name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;">
	    <input type="hidden" id="dataAcessId" name="dataAcessId" value="${dataAcessId}" />
		资源实体：<input type="text" id="className" value="${className}" style="width:400px" class="easyui-validatebox input_eq2"/>
		<input class="zh_btnbg2" type="button" id="editDataAcess" value="配置" /><p>
    	数据规则：<div id="filter" style="border:1px solid #d3d3d3;"></div><p>
    	<input class="inputd" type="button" id="userName" value="当前用户name"/>
		<input class="inputd" type="button" id="userId" value="当前用户id" />
		<input class="inputd" type="button" id="userOrganName" value="当前机构name" />
		<input class="inputd" type="button" id="userOrganId" value="当前机构id" />
		<input class="inputd" type="button" id="directChildOrgIds" value="直接下级机构id" />
		<input class="inputd" type="button" id="directChildOrgNames" value="直接下级机构name" />
		<input class="inputd" type="button" id="inDirectChildOrgIds" value="间接下级机构id" />
		<input class="inputd" type="button" id="inDirectChildOrgNames" value="间接下级机构name" />
	</form>
	<div class="tool_btn">
		<div style="float: right;">
			<input class="inputd" type="button" id="submit" value="保存" />
			<input type="button" onclick="goBack()" class="inputd" value="返回" />
		</div>
	</div>
</div>
</body>
</html>