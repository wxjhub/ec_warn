<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>新增机构</title>
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
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/form-util.js"></script>
<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
#formSave{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	border:1px solid #c0c0c0;
	border-top-style:none;
	background:#fff url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
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
	/*background:url(${pageContext.request.contextPath}/images/select_bg.png) repeat-x;*/
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
</style>

<script type="text/javascript">

	//输入时候支持回车
	  function changeFocus( )
	 {
	 	//9 is [tab]
		//13 is [Enter] 
		if (event.keyCode==13)
    	 event.keyCode=9;
	}
	document.onkeydown= changeFocus;

	function saveOrgan(){
		var orgId = $("#orgId").val();
		$('#formSave').form('submit', {
			url:"${pageContext.request.contextPath}/organ_saveForm.action?orgId="+ orgId,
			onSubmit: function(){
				var flag = true;
				$('#formSave input').each(function () {
				    if ($(this).attr('required') || $(this).attr('validType')) {
					    if (!$(this).validatebox('isValid')) {
						    flag = false;
					        return 
					    }
				    }
				});
				return flag;
			},
			success:function(data){
					var result=data;
					hasException(result);
					if(1==result) {
					if($("#orgId").val()==""){
						$.messager.alert('系统提示','机构添加成功','warning');
					}else{
						$.messager.alert('系统提示','机构修改成功','warning');
					}
					goBack();
				}}
		});
	};
	$(function(){
		 if($("#orgId").val()==""){
	  		$("#msg").text("机构信息添加");
	  	 }else{
	  		$("#msg").text("机构信息编辑");
	  	 }

		$('#reset').click(function(){
			  if('${detail.orgId}'){
				  $('#orgName').val('${detail.orgName}');
	              $('#orgCode').val('${detail.orgCode}');
				  $("#parentOrganId").val($("#parentOrganIdOld").val());
				  $("#parentOrganName").val($("#parentOrganNameOld").val());
	              $('#linkman').val('${detail.linkman}');
	              $('#linktel').val('${detail.linktel}');
	              $('#weburl').val('${detail.weburl}');
	              $('#email').val('${detail.email}');
	              $('#zipCode').val('${detail.zipCode}');
	              $('#orgAddr').val('${detail.orgAddr}');
			  }else{
				  $('#orgName').val('');
	              $('#orgCode').val('');
	              $("#parentOrganId").val('');
				  $("#parentOrganName").val('');
	              $('#linkman').val('');
	              $('#linktel').val('');
	              $('#weburl').val('');
	              $('#email').val('');
	              $('#zipCode').val('');
	              $('#orgAddr').val('');
			  }
			  $('#formSave').form('validate');
			  
		});
	});
	
	function goBack(orgSeq){
		if(orgSeq == undefined)
			orgSeq = "${param.orgSeq}";
		var orgCode = "${param.orgCode}";
		var orgName = "${param.orgName}";
		var status = "${param.status}";
		var _form = createForm({
								url: "${pageContext.request.contextPath}/sec/sec_organ_list.jsp",
								condition: [
								            {name:"orgSeq", value: orgSeq},
								            {name:"orgCode", value: orgCode},
								            {name:"orgName", value: orgName},
								            {name:"status", value: status},
								            {name:"url", value: "${pageContext.request.contextPath}/organ_asyFindOrgans.action"}
								    		]
							});
		_form.submit();
	}
	$.extend($.fn.validatebox.defaults.rules, {
		orgName:{
			validator: function (value) {
				if(/^[a-zA-Z0-9_\u4e00-\u9fa5]{3,16}$/.test(value)){
					 $.fn.validatebox.defaults.rules.orgName.message ="";
					return true;
				}else{
					 $.fn.validatebox.defaults.rules.orgName.message ="只可输入3-16位英文数字汉字和_";
					return false;
				}
			},
			 message: ''
		},
		linkman:{
             validator:function(value){
				if(!/^[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(value)){
					$.fn.validatebox.defaults.rules.linkman.message ="只可输入字母汉字数字_！";
					return false;
				}
				var len = value.replace(/[^\x00-\xff]/g,"aa").length;
					if(len>30){
					$.fn.validatebox.defaults.rules.linkman.message = '输入长度超过最大限度值';
				    return false;
				}
				$.fn.validatebox.defaults.rules.linkman.message ="";
				return true;
            }
	    },
		orgCode: {
	        validator: function (value) {
				if(value.length>32){
				      $.fn.validatebox.defaults.rules.orgCode.message ="输入长度超过最大限度值！";
				    return false;
				}
		        var orgId=$("#orgId").val();
		        var orgCodeOld=$("#orgCodeOld").val();
		        if(orgId=="" || value!=orgCodeOld){
			        var exist=$.ajax({
			                url:"organ_checkOrgCode.action",
			                data:{orgCode:value},
			                async:false
			            }).responseText;
			        if(exist=="0"){
			            $.fn.validatebox.defaults.rules.orgCode.message ="此机构ID可以注册！";
			            return true;
			        }else{
			        	$.fn.validatebox.defaults.rules.orgCode.message ="机构ID重复，无法使用！";
			            return false;
				    }
		        }else{
		        	$.fn.validatebox.defaults.rules.orgCode.message ="";
		            return true;
			    }
	    	},
	   		 message: ''
	 	},
	 	orgAddr :{
	 		validator: function (value) {
		 		var len = value.replace(/[^\x00-\xff]/g,"aa").length;
				if(len>256){
					$.fn.validatebox.defaults.rules.orgAddr.message = '输入长度超过最大限度值';
				    return false;
				}else{
		        	$.fn.validatebox.defaults.rules.orgCode.message ="";
		            return true;
			    }
	 		}
	 	}
	});

	function selectParentOrgan(){
		showModalCenter ("${pageContext.request.contextPath}/sec/tree/sec_organ_tree.jsp", function(data){
				$("#parentOrganId").val(data[0].id);
				$("#parentOrganName").val(data[0].name);
			}, "400", "88%", "机构树");
	}

	$(function(){
	    //表格自适应屏幕高度
	    var heightValue = $(document).height() - 95 - 55;
	    if (heightValue > 300)
	        $("#formSave").height(heightValue);
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
	<form name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;height: 315px">
		<div id="myTab1_Content0" >
			<input type="hidden" id="orgId" name="orgId" value="${detail.orgId}"></input>
			<table cellSpacing="0" cellpadding="0" border="0">
				<tr>
					<td width="80px" height="40px">机构代码:</td>
					<td width="260px" height="40px">
						<input type="hidden" id="orgCodeOld" name="orgCodeOld" value="${detail.orgCode}"></input>
						<input type="text" class="easyui-validatebox input_eq2" required="true" 
						name="orgCode" validType="orgCode" id="orgCode" value="${detail.orgCode}"/>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">机&nbsp;构&nbsp;名&nbsp;:</td>
					<td height="40px" width="260px"><input type="text" id="orgName" name="orgName" 
						class="easyui-validatebox input_eq2" required="true" validType="orgName"
						missingMessage="该输入项为必输项" value="${detail.orgName}"/>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px">机构层级:</td>
					<td height="40px">
						<input type="hidden" id="orgLevelOld" name="orgLevelOld" value="${detail.orgLevel}"></input>
						<select name="orgLevel" style="width: 156px" class="easyui-combobox" missingMessage="此项为必输项" required="true"  id="orgLevel">
				 			<rmp:option dictId="sys.org.orgLevel" currentValue="${detail.orgLevel}"></rmp:option>
						</select>
						<span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">上级机构:</td>
					<td height="40px">
						<input type="hidden" id="parentOrganIdOld" name="parentOrganIdOld" value="${detail.parentOrgan.orgId}"/>
						<input type="hidden" id="parentOrganNameOld" name="parentOrganNameOld" value="${detail.parentOrgan.orgName}"/>
						<input type="hidden" id="parentOrganId" name="parentOrganId" value="${detail.parentOrgan.orgId}">
						<input type="text" class="input_eq2" id="parentOrganName" name="parentOrganName" value="${detail.parentOrgan.orgName}" readonly="readonly">
						<input type="button" class="inputd" value="选择" onclick="selectParentOrgan();">
						<%--
						<input id="parentOrgan" class="easyui-combotree tree-node-hover tree-node" name="parentOrgan"  style="width: 157px;">
						--%>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px">联&nbsp;系&nbsp;人&nbsp;:</td>
					<td height="40px" >
						<input type="text" class="easyui-validatebox input_eq2" id="linkman" name="linkman" validType="linkman" value="${detail.linkman}">
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">联系电话:</td>
					<td height="40px" >
						<input type="text" class="easyui-validatebox input_eq2" id="linktel" name="linktel" value="${detail.linktel}"  validType="telePhone">
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px" >机构网址:</td>
					<td height="40px" ><input type="text"
						name="weburl" id="weburl" value="${detail.weburl}" class="easyui-validatebox input_eq2" validType="url"/>
						<span id="weburlTxt"></span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">机构邮箱:</td>
					<td height="40px" ><input type="text" 
						name="email" id="email" value="${detail.email}"class="easyui-validatebox input_eq2" validType="email"/>
						<span id="emailTxt"></span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px" >邮政编码:</td>
					<td width="40px" height="40px" ><input type="text"
						name="zipCode" id="zipCode" value="${detail.zipCode}" class="easyui-validatebox input_eq2" validType="zipCode"/>
						<span id="weburlTxt"></span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">机构地址:</td>
					<td height="40px" ><input type="text"
						name="orgAddr" id="orgAddr" value="${detail.orgAddr}" class="easyui-validatebox input_eq2" validType="orgAddr"/>
						<span id="weburlTxt"></span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px">机构状态:</td>
					<td height="40px" name="status" value="${detail.status}">
						<c:if test="${empty detail.orgId or detail.status eq '1'}">
						生效
						</c:if>
						<c:if test="${detail.status eq '0'}">
						撤销
						</c:if>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">机构内部层级:</td>
					<td height="40px" >
						<input type="hidden" id="orgDegreeOld" value="${detail.orgDegree}"/>
						<h:dictSelect nullText="" dictId="sys.orgDegree" id="orgDegree" name="orgDegree" styleClass= "easyui-combobox" defaultValue="${detail.orgDegree}" style="width:156px" />
						<span id="weburlTxt"></span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px" >是否部门:</td>
					<td width="40px" height="40px" >
						<input type="hidden" id="orgDeptFlgOld" value="${detail.orgDeptFlg}"/>
						<h:dictSelect nullText="" dictId="sys.orgDeptFlg" id="orgDeptFlg" name="orgDeptFlg" styleClass= "easyui-combobox" defaultValue="${detail.orgDeptFlg}" style="width:156px" />
						<span id="weburlTxt"></span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">部门类型:</td>
					<td height="40px" >
						<input type="hidden" id="orgTypeOld" value="${detail.orgType}"/>
						<h:dictSelect nullText="" dictId="sys.orgType" id="orgType" name="orgType" styleClass= "easyui-combobox" defaultValue="${detail.orgType}" style="width:156px" />
						<span id="weburlTxt"></span>
					</td>
				</tr>
				<tr>
					<td colspan="4" height="50" style="color: red">提示:带（*）为必填项</td>
				</tr>
			</table>
			<input type="hidden" id="startDate" name="startDate" value="${detail.startDate}">
			<input type="hidden" id="endDate" name="endDate" value="${detail.endDate}">
			<input type="hidden" id="orgSeq" name="orgSeq" value="${detail.orgSeq}">
			<input type="hidden" id="status" name="status" value="${detail.status}">
			<input type="hidden" id="createTime" name="createTime" value="${detail.createTime}">
			<input type="hidden" id="createUser" name="createUser" value="${detail.createUser}">
			<input type="hidden" id="lastupTime" name="lastupTime" value="${detail.lastupTime}">
			<input type="hidden" id="updator" name="updator" value="${detail.updator}">
			<input type="hidden" id="sortNo" name="sortNo" value="${detail.sortNo}">
			<input type="hidden" id="leafFlag" name="leafFlag" value="${detail.leafFlag}">
			<input type="hidden" id="remark" name="remark" value="${detail.remark}">
			<input type="hidden" id="field1" name="field1" value="${detail.field1}">
			<input type="hidden" id="field2" name="field2" value="${detail.field2}">
			<input type="hidden" id="field3" name="field3" value="${detail.field3}">
			<input type="hidden" id="field4" name="field4" value="${detail.field4}">
			<input type="hidden" id="field5" name="field5" value="${detail.field5}">
		</div>
	</form>
	<div class="tool_btn">
		<div style="float: right;">
			<input class="zh_btnbg2" type="submit" id="submit" value="保存" onclick="saveOrgan();" />
			<input type="button" id="reset" class="zh_btnbg2" value="重置" />
			<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" />
		</div>
	</div>
</div>
</body>
</html>