<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
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
<title>添加工程</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>
<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
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
	border-radius:5px;
	-moz-border-radius:5px;
	-webkit-border-radius: 5px;
	border-top-right-radius:0px;
	-moz-border-radius-topright:0px;
	-webkit-border-bottom-right-radius:0px;
	border-bottom-right-radius:0px;
	-moz-border-radius-bottomright:0px;
	-webkit-border-bottom-right-radius:0px;
}
.tabs-panels{
	margin:0px;
	padding:0px;
	border:0px;
	overflow:hidden;
	background:url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
}
</style>

<script type="text/javascript">
	function moveAll(moveto){
	   //取得两个对象
	   var sel0=document.getElementById("userLeft");
	   var sel2=document.getElementById("selectUser");
	    //如果要把右侧数据全移到左侧则调换两个对象
	   if(moveto=='left'){
	        sel0=document.getElementById("selectUser");
	   		sel2=document.getElementById("userLeft");
	
		 }
		var length=sel0.options.length;
	    for(var i=0;i<length;i++){
	     	var tem=sel0.options[0];
	     	sel2.appendChild(tem);
		}
	}

	
	/**
	*移动部分
	*UserLeft被移动的对象
	*selectUser目标对象
	*/
	function move(UserLeft,selectUser){
	   var sel0=document.getElementById(UserLeft);
	   var sel2=document.getElementById(selectUser);
	   var length=sel0.options.length;
	   for(var i=length-1;i>=0;i--){
	       var tem=sel0.options[i];
	       if(tem.selected){
	           sel2.appendChild(tem);
	       }
	   }
	}
	function checkPassword(){
		var password = $("#dbUserPwd").val();
		var password1=document.getElementById("dbUserPwd1").value;
		if (password1!=''&&password1!=password) {
			$.messager.alert('系统提示','两次输入的密码不一致！请重新输入密码！','warning');
			return ;
		}
	}

	//输入时候支持回车
	function changeFocus(){
	 	//9 is [tab]
		//13 is [Enter] 
		if (event.keyCode==13)
    	 event.keyCode=9;
	}
	document.onkeydown= changeFocus;

	//当提交表单时执行
	function saveProject(){
		//var selectUser = document.getElementById("selectUser").options;				//获取已经选择的工程
		var projectId = $("#projectId").val();										//获得projectId
		//var userIds="";																//寄存了所有被授权的用户
		//for(var i = 0;i < selectUser.length;i++){
		//	if(i>0){
		//		userIds+=",";
		//	}
		//	userIds+=selectUser[i].value;
		//}
		if($("#dbtype").val()=="ora"){ //如果是oracle数据才需要判断密码 
		//保证两次输入密码一致
		var password=document.getElementById("dbUserPwd").value;						
		var password1=document.getElementById("dbUserPwd1").value;
		if(password!=password1){
            $.messager.alert('系统提示','两次输入的密码不一致！请重新输入密码！','warning');
            return ;
		}
		}
		//不能选择当前工程为自己的上级工程
		var currProjectId = $('#projectId').val();
		var selectProjectId = $('#parentProject').combotree('getValue');
		if(currProjectId == selectProjectId && currProjectId != ""){
            $.messager.alert('系统提示','不能选择该工程为上级工程！','warning');
            return ;
		}
		//不能选择当工程的子工程为上级工程
		var flag = true;
		if(selectProjectId != ""){
			$.ajax({
			   type: "POST",
			   url: "${pageContext.request.contextPath}/project_canBeSelect.action?currProjectId="+currProjectId+"&selectProjectId="+selectProjectId,
//			   data: {currProjectId:currProjectId,selectProjectId:selectProjectId},
			   dataType: "text",
			   async:false,
			   success: function(msg){
			     if(msg=="false"){
			    	 flag = false;
			     }
			   }
			});
		}
		if(!flag){
	    	 $.messager.alert('系统提示','不能选择该工程的子孙工程为上级工程！','warning');
			return;
		}
		//表单提交
		var obj = new Object();
				obj.title = "系统提示";
				obj.text = "正在提交数据";
				obj.interval = 300;
		$('#formSave').form('submit', {
			url:"${pageContext.request.contextPath}/project_saveForm.action?projectId="+ projectId,
			onSubmit: function(){
				var projectType = $('#projectType').combobox('getValue');
				if($('#projectType').combobox('getText') == "") {
					$.messager.alert('系统提示','请选择工程类型！','warning');
					return false;
				}
				var flag = true;
				// 将表单中的所有必须项进行验证，也将标记为validType的控件进行验证
				$('#formSave input').each(function () {
				    if ($(this).attr('required') || $(this).attr('validType')) {
				    	if($("#dbtype").val()=="db2" && ($(this).attr("id")=="dbUserPwd" || $(this).attr("id")=="dbUserPwd1" )){ //如果是db2数据库 不需要进行密码的判断  
				    	
				    	}else if($(this).attr("id")=="asOfDate" ){
				    		 if (!$(this).combo('isValid')) {
								    flag = false;
							        return ;
							    }	
				    	}else{
				    	    if (!$(this).validatebox('isValid')) {
							    flag = false;
						        return ;
						    }	
				    	}					
				    }
				});
				if(flag) {
				
					$.messager.progress(obj);
				}
				return flag;
			},
			success:function(data){		
				var result = data;
				var startFlag = "_start_exception";
				var endFlag = "_end_exception";
				var start = data.indexOf(startFlag)+startFlag.length+1;
				var end = data.indexOf(endFlag)-6;
				if(start>0){
					$.messager.progress('close');
					$.messager.alert('系统异常提示',data.substring(start,end),'warning');
				}
				
				if(result == "1") {
				//设置提交成功后跳转的页面
				$.messager.alert('系统提示','工程保存成功','warning');
				window.location.href = "${pageContext.request.contextPath}/sec/sec_project_list.jsp";
			}}
		});
	};
	//页面初始化时加载...
	$(function(){     
		
		$('#projectType').combobox({  
		    panelHeight:"100%",
		    editable:false
		}); 
		$('#parentProject').combobox({  
		    panelHeight:"100%",
		    editable:false
		});
		$('#syncFlag').combobox({  
		    panelHeight:"100%",
		    editable:false
		}); 
		
		//初始化上级工程
		$('#parentProject').combobox({
			url:"${pageContext.request.contextPath}/project_projectTree.action",
			valueField:"projectId",
			textField:"projectName"
		});  
					

		if($("#dbtype").val()=="db2"){  //设置db2数据库类型 数据库密码和确认密码不可编辑 
	  		$('#dbUserPwd').attr("disabled",true);
	  		$('#dbUserPwd1').attr("disabled",true);
	  		$('#spwd').text(""); //去掉输入框后面的必填标记 *
	  		$('#spwd1').text("");
	  		}
		 if($("#projectId").val()!=""){
	  		$("#msg").text("工程信息编辑");
	  		$("#parentProject").combobox({'disabled':true});
	  		$('#dbUserName').attr("disabled",true);
	  	 }else{
	  		$("#msg").text("工程信息添加");		//设置表格标题
	  	 }

	  	 
		$('#reset').click(function(){
			  if('${detail.projectId}'){		//如果是编辑页面那么就恢复显示
				  $('#projectName').val('${detail.projectName}');
	              $('#projectType').combobox('setValue',$('#projectTypeOld').val());
	              $('#parentProject').combobox('setValue',$('#parentProjectOld').val());
	              $('#dbUserName').val('${detail.dbUserName}');
	              $('#dbUserPwd').val('${detail.dbUserPwd}');
	              $('#dbUserPwd1').val('${detail.dbUserPwd}');
	              $('#createUser').val('${detail.createUser}');
	              $('#projectRemark').val('${detail.projectRemark}');
	              $('#syncFlag').combobox('setValue',$('#syncFlagOld').val());
			  }else{							//添加页面重置
				  $('#projectName').val('');
	              $('#projectType').combobox('setValue','1');
	              $('#parentProject').combobox('setValue','');
	              $('#dbUserName').val('');
	              $('#dbUserPwd').val('');
	              $('#dbUserPwd1').val('');
	              $('#projectRemark').val('');
	              $("#selectUser").text("");		//清空右边的选项
                  $('#formSave').form('validate');
                  $('#syncFlag').combobox('setValue','Y');
			  }
	 			var selectElement=document.getElementById("selectUser");
	 			var leftElement=document.getElementById("userLeft");
	 			var removeLeftOptions = $("#selectUser > option[lang='left']");
	 			for( var i = 0; i< removeLeftOptions.length; i++){
	 				leftElement.appendChild(removeLeftOptions[i]);
	 			}
	 			var removeRightOptions = $("#userLeft > option[lang='right']");
	 			for( var i = 0; i< removeRightOptions.length; i++){
	 				selectElement.appendChild(removeRightOptions[i]);
	 			}
				$("#keyWord").val("");
	            $("#userLeft").text("");			//清空左边的选项
		});

	});
	function goBack(){
		 window.location.href = "${pageContext.request.contextPath}/sec/sec_project_list.jsp";
	}
	$.extend($.fn.validatebox.defaults.rules, {
		projectName:{
			validator: function (value) {
				if(/^[a-zA-Z0-9_\u4e00-\u9fa5]{3,16}$/.test(value)){
					 $.fn.validatebox.defaults.rules.projectName.message ="";
					return true;
				}else{
					 $.fn.validatebox.defaults.rules.projectName.message ="只可输入3-16位英文数字汉字和_";
					return false;
				}
			},
			 message: ''
		},projectType:{
			validator: function (value) {
				if(/^[0-1]{1}$/.test(value)){
					 $.fn.validatebox.defaults.rules.projectType.message ="";
					return true;
				}else{
					 $.fn.validatebox.defaults.rules.projectType.message ="选择工程类型";
					return false;
				}
			},
			 message: ''
		},dbUserName:{
			validator: function (value) {
				if(!/^[a-zA-Z0-9_\u4e00-\u9fa5]{3,16}$/.test(value)){
					$.fn.validatebox.defaults.rules.dbUserName.message ="只可输入3-16位英文数字汉字和_";
					return false;
				}
				var projectId=document.getElementById("projectId").value;
				if(!projectId){
					 var exist=$.ajax({
			                url:"${pageContext.request.contextPath}/project_checkDbUserName.action",
			                data:{dbUserName:value},
			                async:false
			            }).responseText;
					 if(exist=="0"){
				            $.fn.validatebox.defaults.rules.dbUserName.message ="此数据库用户名可以使用！";
				            return true;
				        }else if(exist=="1"){
				        	$.fn.validatebox.defaults.rules.dbUserName.message ="数据库用户名已存在，无法使用！";
				            return false;
					    }else{
					    	$.fn.validatebox.defaults.rules.dbUserName.message ="数据库用户名不能为当前数据库用户！";
				            return false;	
					    }
			        }else{
			        	$.fn.validatebox.defaults.rules.dbUserName.message ="";
			            return true;
				    }
			},
			
			 message: ''
		},dbUserPwd:{
			validator: function (value) {
				if(/^[a-zA-Z0-9_\u4e00-\u9fa5]{3,16}$/.test(value)){
					 $.fn.validatebox.defaults.rules.dbUserPwd.message ="";
					return true;
				}else{
					 $.fn.validatebox.defaults.rules.dbUserPwd.message ="只可输入3-16位英文数字汉字和_";
					return false;
				}
			},
			 message: ''
		},projectRemark:{
			validator: function (value) {
				if(/^.{0,500}$/.test(value)){
					 $.fn.validatebox.defaults.rules.projectRemark.message ="";
					return true;
				}else{
					 $.fn.validatebox.defaults.rules.projectRemark.message ="只可输入0-500个字符";
					return false;
				}
			},
			 message: ''
		},keyWord:{
			validator: function (value) {
			if(/^.{0,40}$/.test(value)){
				 $.fn.validatebox.defaults.rules.keyWord.message ="";
				return true;
			}else{
				 $.fn.validatebox.defaults.rules.keyWord.message ="只可输入0-40个字符";
				return false;
			}
		},
		 message: ''
		}
	});


</script>
<style type="text/css">
	.tree-node-hover{
		background:#D0E5F5;
	}
	.tree-node{
		height:20px;
		white-space:nowrap;
		cursor:pointer;
	}
</style>
</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><font class="blue" id="msg"></font></div>
<div id="tt" class="easyui-tabs" tools="#tab-tools" style="height:322px;border:#c0c0c0 1px solid;border-top-style: none;">
	<div title="工程基本信息">
	<form name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;height: 265px;border-style: none">
		<div id="myTab1_Content0" >
			<input type="hidden" id="projectId" name="projectId" value="${detail.projectId}"></input>
			<input type="hidden" name="syncCompleteFlag" value="${detail.syncCompleteFlag}"></input>
			<input type="hidden" name="lockFlg" value="${detail.lockFlg}"></input>
			<input type="hidden" name="useFlg" value="${detail.useFlg}"></input>
			<input type="hidden" name="useSum" value="${detail.useSum}"></input>
			<!-- 数据库 类型-->
			<input type="hidden" name="dbtype" id="dbtype"  value="${dbtype}"></input>
			
			
			<table cellSpacing="0" cellpadding="0" border="0">
				<tr>
					<td width="80px" height="40px" style="padding-left: 20px">项&nbsp;目&nbsp;名：</td>
					<td height="40px" width="170px"><input type="text" id="projectName" name="projectName" 
						class="easyui-validatebox input_eq2" required="true" validType="projectName"
						missingMessage="此项为必输项" value="${detail.projectName}"/>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">工程类型：</td>
					<td height="40px">
						<input type="hidden" id="projectTypeOld" name="projectTypeOld" value="${detail.projectType}"></input>
						<select name="projectType" class="easyui-combobox"   id="projectType">
				 			<rmp:option dictId="sys.project.projectType" defaultValue="1" currentValue="${detail.projectType}" ></rmp:option>
						</select>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px" style="padding-left: 20px">上级工程：</td>
					<td height="40px">
						<input type="hidden" id="parentProjectOld" value="${detail.parentProject.projectId}"/>
						<input id="parentProject" value="${detail.parentProject.projectId}" class="easyui-combobox" name="parentProject"  style="width: 157px;">
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">数据库用户：</td>
					<td height="40px" >
						<input type="text" class="easyui-validatebox input_eq2" id="dbUserName" name="dbUserName" validType="dbUserName" value="${detail.dbUserName}"  missingMessage="此项为必输项" required="true" >
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px" style="padding-left: 20px">数据库密码：</td>
					<td height="40px" >
						<input type="password" class="easyui-validatebox input_eq2" id="dbUserPwd"  name="dbUserPwd" value="${detail.dbUserPwd}" validType="dbUserPwd"  missingMessage="此项为必输项" required="true" >
						<span id="spwd" style="color: red;font-size: 15px;"> *</span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">确认密码：</td>
					<td height="40px" >
						<input type="password"  onblur="checkPassword()" class="easyui-validatebox input_eq2" id="dbUserPwd1" name="dbUserPwd1" value="${detail.dbUserPwd}"  validType="dbUserPwd"  missingMessage="此项为必输项" required="true" >
						<span id="spwd1"  style="color: red;font-size: 15px;"> *</span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px" style="padding-left: 20px">创&nbsp;建&nbsp;者：</td>
					<td height="40px" >
						<input readonly="readonly" type="text" name="createUser" id="createUser" value="${detail.createUser}"class="easyui-validatebox input_eq2" validType="createUser"  missingMessage="此项为必输项" required="true" disabled="disabled"/>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px" >开启同步：</td>
					<td height="40px" >
						<input type="hidden" id="syncFlagOld" name="syncFlagOld" value="${detail.syncFlag}"></input>
						<select name="syncFlag" class="easyui-combobox"   id="syncFlag">
				 			<rmp:option dictId="sys.project.syncFlag" defaultValue="Y" currentValue="${detail.syncFlag}" ></rmp:option>
						</select>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px" style="padding-left: 20px" >备&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
					<td height="40px" >
						<input type="text" name="projectRemark" id="projectRemark" value="${detail.projectRemark}" class="easyui-validatebox input_eq2" validType="projectRemark"/>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px" >数据日期：</td>
					<td height="40px" >
				    <input type="text" id="asOfDate" name="asOfDate" value="${detail.asOfDate}" class="easyui-datebox"  required="true"
						missingMessage="此项为必输项"> 
						 <%-- <h:date name="asOfDate" value="${detail.asOfDate}"id="asOfDate" required="true"/>  --%>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
				</tr>
				<tr>        
					<td colspan="4" height="50" style="color: red" style="padding-left: 20px">提示：带（*）为必填项</td>
				</tr>
			</table>
		</div>
	</form>
	</div>
	
	</div>
	<div class="tool_btn">
		<div style="float: right;">
			<input class="zh_btnbg2" type="submit" id="submit" value="保存" onclick="saveProject();" />
			<input type="button" id="reset" class="zh_btnbg2" value="重置" />
			<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" />
		</div>
	</div>
</div>
</body>
</html>