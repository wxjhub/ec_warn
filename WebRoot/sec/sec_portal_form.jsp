<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>portal表单界面</title>
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
#icons{
			margin-top: 10px;
			margin-left: 10px;
		}
		#icons img{
			padding: 10px;
		}
		#icons img:HOVER{
			padding: 9px;
			border:1px solid #fda904;
			background: #fff;
		}
		#menuRes .panel-header{
			border-top: 1px solid #ccc;
		}
		#treeImg{
			position: relative;
			top:4px;
		}
		#topIcons{
			margin-top: 10px;
			margin-left: 10px;
		}
		#topIcons img{
			padding: 10px;
		}
		#topIcons img:HOVER{
			padding: 9px;
			border:1px solid #fda904;
			background: #fff;
		}
		#topImg{
			position: relative;
			top:4px;
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
        	if($("#portalId").val()==""){
		  		$("#msg").text("portal信息添加");
		  	 }else{
		  		$("#msg").text("portal信息编辑");
		  	 }
			$('select').combobox({
				panelHeight:'100%'
			});

			$("#portalSave").submit( function () {
				var flag = true;
				$('#portalSave input').each(function () {
				    if ($(this).attr('required') || $(this).attr('validType')) {
					    if (!$(this).validatebox('isValid')) {
						    flag = false;
					        return 
					    }
				    }
				});
				return flag;
			});
			
    		$("#reset").click(function(){
    			if('${portalId}'){
                    $('#title').val('${title}');
                    $('#content').val('${content}');  
                    $('#height').val('${height}'); 
                    $('#rowIndex').val('${rowIndex}'); 
                    $('#columnIndex').val('${columnIndex}'); 
                  
                    $('#iconCls').val('${iconCls}');
              	}else{
              		 $('#title').val('');
                     $('#content').val('');  
                     $('#height').val(''); 
                     $('#rowIndex').val(''); 
                     $('#columnIndex').val(''); 
                   
                     $('#iconCls').val('');
                  }
    			$('#portalSave').form('validate');
    		});
        });

    	 

		function goBack(){
			window.location.href = "${pageContext.request.contextPath}/sec/sec_portal_list.jsp";
		}
		

		//设置菜单图标、快捷图标绝对路径
		var imgLocation_tree = "./common/menuIcon/";
	//----------------------------------------------------------------------------------------------------------------
		
		//菜单图标、快捷图标初始化
			function iconDefalut() {
				$.ajax({
					 cache:false,
					 type: 'post',
					 dataType : "text",
					 url: "secMenu_IconSum.action",
					 success:function(data){
						 if(data.indexOf("errorState")>0) {
							 return;
						 }
						// 将data用“,”分割,依次展示
						 var Icons = data.split("||");
						 var treeIcons = Icons[0].split(",");
						 var topIcons = Icons[1].split(",");
						 for ( var i = 0; i < treeIcons.length-1; i++) {
							var array_element = treeIcons[i];
							$("#icons").append('<span><a href="#"><img src="'+imgLocation_tree+array_element+'" title="'+array_element+'"  width="16px" height="16px" onclick="changeIcon(this.title)" /></a></span>');
						 }
						 
					 }
		 		});
				
				$("#changeIcon").click(function(){
					$('#iconResource').window('open');
				});
				 
			}
			
			//菜单图标选择
			function changeIcon(icon){
				$('#iconResource').window('close');
				$("#treeImg").attr({ src: imgLocation_tree+icon});
				$('#iconCls').val(icon);
			}
			 
			function c1(){
				$("#portalSave").submit();
			}
			//menu 
			$(function() {
				iconDefalut();
			});
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
			
		 
			 
</script>
</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><font class="blue" id="msg"></font></div>
<div id="tt" class="easyui-tabs" tools="#tab-tools" style="height:340px;border:#c0c0c0 1px solid;border-top-style: none;">
		<div title="portal基本信息" >
			<table>
				<TR>
				<TD noWrap height=40px valign="middle" style="padding-left: 25px;">
				<FORM name="portalSave" id="portalSave" method="post" action="${pageContext.request.contextPath}/portal_save.action" style="padding-top: 25px;border-style: none">
				<div id="myTab1_Content0" >
					<table cellSpacing="0" cellpadding="0" border="0">
						<tr>
							<td><input type="hidden" class="easyui-validatebox input_eq2" name="portalId" id="portalId" value="${portalId}" /> 
							</td>
						</tr>
						<tr>
							<td width="80px" height="40px" >标题：</td>
							<td height="40px" width="260">
								<input type="text"  
								 class="easyui-validatebox input_eq2"
								name="title" id="title" value="${por.title}" />
						 	</td>
						 	<td width="80px" height="40px" >高度：</td>
							<td height="40px" width="260"><input type="text" class="easyui-validatebox input_eq2"
								  name="height" id="height"
								value="${por.height}" /> 
							</td>
						</tr>
						<tr>
							
							<td width="80px" height="40px" >行索引：</td>
							<td height="40px" width="260"><input type="text" class="easyui-validatebox input_eq2"
								  name="rowIndex" id="rowIndex" required="true" onkeyup="this.value=this.value.replace(/\D/g,'')"
								value="${por.rowIndex}" missingMessage="只允许可输入数字" /><span style="color: red;font-size: 15px;">*</span> 
							</td>
							<td width="80px" height="40px" >列索引：</td>
							<td height="40px" width="260"><input type="text" class="easyui-validatebox input_eq2"
								  name="columnIndex" id="columnIndex" required="true" onkeyup="this.value=this.value.replace(/\D/g,'')"
								value="${por.columnIndex}" missingMessage="只允许可输入数字" /><span style="color: red;font-size: 15px;"> *</span> 
							</td>
						</tr>
						<tr>
							<td height="32px" width="80" class="searchTitle" style="vertical-align: text-top; line-height: 33px;">protalUrl：</td>
							<td height="32px">
								<input name="content" type="text" value="${por.content}" class="input_eq2 easyui-validatebox" required="true"/>
								<span style="color: red;font-size: 15px;"> *</span>
							</td>
							<td width="80px" height="40px" >图标：</td>
							<td>
							<input id="iconCls" name="iconCls" type="hidden" value="${por.iconCls}"/>
							<span id="showIcon"><img id="treeImg" src='./common/menuIcon/${por.iconCls}' width="17px" height="17px"></img></span>
							<input type="button" class="inputd" value="配置菜单图标" id="changeIcon"/>
						</tr>
					</table>
				</div>
				</FORM>
				</TD>
			</TR>
			</table>
		</div>
	</div>
	<div id="iconResource"  closed="true" modal="true" class="easyui-window" title="配置菜单图标" 
				collapsible="false" minimizable="false" maximizable="false" style=background-color:#F1F1F1;width:410px;height:310px;">
	    	<div id="icons"></div>
	</div>
	<div class="tool_btn">
	 	 
		<div style="float: left;color: red;margin-top: 8px;margin-left: 20px;">提示：带（*）为必填项 </div>
		<div style="float: left;margin-left: 280px;">
		<input class="zh_btnbg3" type="button" value="保存基本信息" onclick="c1();"/>
		
		<input type="button" class="zh_btnbg2" onclick="goBack()" value="返回" />
		</div>
		<!--<div style="float: right;">
			
		</div>
	--></div>
</div>
</body>
</html>
﻿
