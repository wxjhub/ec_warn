<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>   
	<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<title>菜单查询</title>
	<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/gray/easyui.css">        
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/zTreeStyle/zTreeStyle.css" type="text/css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.core-3.0.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.excheck-3.0.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.exedit-3.0.js"></script>
    <script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
    <script src="${pageContext.request.contextPath}/sec/sec_menu_list.js" type="text/javascript"></script>
    
	<style type="text/css">
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
		.ztree li button.add {margin-left:2px; margin-right: -1px; background-position:-112px 0; vertical-align:top; *vertical-align:middle}
		td{margin-bottom: 10px;}
		#menuInfoForm input{border: none;background: none;}
		.easyui-panel{margin-left:20px;margin-top:20px;}
	</style>
	<script type="text/javascript">
		$(function() {
			iconDefalut();
			zTreeInit();
			menuDetailSelectInit();
			resourceForm();
		});

		function menuSearch() {
			var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
			
			treeObj.cancelSelectedNode();
			
			var value = $.trim($('#conditionName').val());
			if(value == "") {
				$("#treeDemo").show();
				$("#queryMsg").hide();
				return;
			}
			
			var nodes = treeObj.getNodesByParamFuzzy("name", value, null);
			if(nodes.length == 0) {
				$("#treeDemo").hide();
				$("#queryMsg").show();
			} else {
				$("#queryMsg").hide();
				$("#treeDemo").show();
			}
			for (var i=0; i<nodes.length; i++) {
				treeObj.selectNode(nodes[i],true);
			}
		}
		
   	</script>
	</head>
	<body class="easyui-layout" style="background-color:#EBF1FE;" border="false">
	  <!-- 左侧菜单树 -->
	  <div region="west" split="false" title="菜单树" style="width:225px;border-left: none;">
	  	<div class="easyui-layout" fit="true">
			<div region="north" border="false" style="height: 30px;">
				<div style="padding: 5px 5px 0px 10px;">
					<table cellSpacing="00" cellpadding="0" border="0" align="center" >
						<tr>
							<td><input type="text" class="input_eq" style="width: 120px" name="conditionName" id="conditionName"/>&nbsp;</td>
							<td><input class="inputd" type="button" value="搜索" onclick="menuSearch();"/></td>
						</tr>
					</table>
				</div>
			</div>
			<div region="center" border="false">
				<div id="queryMsg" style="display: none; padding-left: 10px;">
					<table><tbody><tr style="height: 30px;">
						<td><img alt="" src="${pageContext.request.contextPath}/common/menuIcon/caution_high_voltage.png"></td>
						<td>&nbsp;抱歉，没有您要查询的结果！</td>
					</tr></tbody></table>
				</div>
				<ul id="treeDemo" class="ztree"></ul>
			</div>
		</div>
     	 
      </div>
      <!-- 右侧表单 -->
      <div region="center" id="resourceList" title="菜单信息" style="background-color:#E7F1FD;">
      	<!-- 菜单详细信息-查看 -->
      	<div id="menuInfoForm" class="easyui-panel" title="菜单详细信息" noheader="true" border="false" style="height:210px;background:#E7F1FD;padding-left: 5px"  collapsible="false" closed="true" >  
        	<form id="menu_info_form" method="post" >
				<table border="0" align="left">
					<tr>
						<td width="90px" height="30px">菜单名称：</td>
						<td height="30px" class="pad_r">
							<input type="text" id="menuNameInfo" readonly="readonly"/>
						</td>
						<td width="90px" height="30px">菜单编码：</td>
						<td height="30px" class="pad_r">
							<input type="text" id="menuCodeInfo" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td width="90px" height="30px">是否叶子节点：</td>
						<td class="pad_r">
							<input type="text" id="leafFlgInfo"readonly="readonly"/>
						</td>
						<td width="90px" height="30px">菜单是否展开：</td>
						<td class="pad_r">
							<input type="text" id="openFlgInfo"readonly="readonly">
						</td>
					</tr>
					<tr>
						<td width="90px" height="30px">菜单URL：</td>
						<td class="pad_r">
							<input type='text' id='menuUrlInfo' readonly="readonly"/>
						</td>  
						<td width="90px" height="30px">菜单类型：</td>
						<td class="pad_r">
							<input type='text' id='menuTypeInfo' readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td width="90px" height="30px">菜单描述：</td>
						<td class="pad_r">
							<input type="text" id="funcdescInfo" readonly="readonly"/>
						</td>
						<td width="90px" height="30px">菜单图标：</td>
						<td class="pad_r">
							<span id="showIcon"><img id="treeImgInfo"  width="17px" height="17px"></img></span>
						</td>
					</tr>
					
					<%--
					<tr>
						<td width="90px" height="30px">设置快捷方式：</td>
						<td class="pad_r">
							<input type="text" id="field2Info" readonly="readonly"/>
						</td>
						<td width="90px" height="30px">快捷图标：</td>
						<td class="pad_r">
							<span id="showIcon"><img id="topImgInfo" src='' width="17px" height="17px"></img></span>
						</td>
					</tr>
					 --%>
				</table>
    		</form>
		</div>
		<!-- 菜单详细信息-修改-->
      	<div id="menuForm" class="easyui-panel" title="菜单详细信息" noheader="true" border="false" style="left:80px;height:178px;background:#E7F1FD;padding-left: 5px"  collapsible="false" closed="true" >  
        	<form id="add_edit_form" method="post">
		        <input type="hidden" name="menuId" id="menuId" ></input>
		        <input type="hidden"  name="pId" id="pId"></input>
				<table border="0" align="left">
					<tr>
						<td width="90px" height="30px">菜单名称：</td>
						<td height="30px" class="pad_r">
							<!-- validType="menuName"  required="true" missingMessage="请输入菜单名称" -->
							<input type="text" name="menuName" id="menuName" validType="menuName"  required="true" missingMessage="请输入菜单名称" class="easyui-validatebox input_eq" /></td>
					
						<td width="90px" height="30px">菜单编码：</td>
						<td height="30px" class="pad_r">
							<!-- validType="menuCode"  required="true" missingMessage="请输入菜单编码" -->
							<input type="text" name="menuCode" id="menuCode" validType="menuCode"  required="true" missingMessage="请输入菜单编码" class="easyui-validatebox input_eq"/></td>
					</tr>
					<tr>
						<td width="90px" height="30px">是否叶子节点：</td>
						<td class="pad_r">
						<select id="leafFlg" style="width: 143px" name="leafFlg" class="easyui-combobox">
								<rmp:option dictId="sys.menu.leafFlg" defaultValue="1"></rmp:option>
						</select>
						</td>
						<td width="90px" height="30px">菜单是否展开：</td>
						<td class="pad_r">
						<select id="openFlg" style="width: 143px" name="openFlg" class="easyui-combobox">
								<rmp:option dictId="sys.menu.openFlg" defaultValue="0"></rmp:option>
						</select>
						
					</tr>
					<tr>
						<td width="90px" height="30px">菜单URL：</td>
						<td class="pad_r">
							<!-- required="true" missingMessage="平台url以/开头，非平台url以http或者www开头" -->
							<input type='text' style='width:250px;' isSubmitValid = "no"  name='menuUrl' id='menuUrl' required="true" missingMessage="平台url以/开头，非平台url以http或者www开头" class='easyui-validatebox input_eq'/>
							</td>
						<td width="90px" height="30px">菜单类型：</td>
						<td class="pad_r">
							<select id="menuType" style="width: 143px" name="menuType" class="easyui-combobox">
								<rmp:option dictId="sys.menu.menuType" defaultValue="2"></rmp:option>
							</select>
						</td>
					</tr>
					<tr >
						<td width="90px" height="30px">菜单描述：</td>
						<td class="pad_r"><input type="text" style='width:250px;' name="funcdesc" id="funcdesc" class="easyui-validatebox input_eq"/></td>

						<td width="90px" height="30px">菜单图标：</td>
						<td class="pad_r">
							<input id="field1" name="field1" type="hidden"/>
							<span id="showIcon"><img id="treeImg"  width="17px" height="17px"></img></span>
							<input type="button" class="inputd" value="配置菜单图标" id="changeIcon"/>
						</td>
					</tr>
					
					<%-- 
					<tr >
						<td width="90px" height="30px">设置快捷方式：</td>
						<td class="pad_r">
							<select id="field2" style="width: 143px" name="field2" class="easyui-combobox">
								<rmp:option dictId="sys.menu.shortCut" defaultValue="0"></rmp:option>
							</select>
						</td>
						<td width="90px" height="30px">快捷图标：</td>
						<td class="pad_r">
							<input id="field3" name="field3" type="hidden"/>
							<span id="showIcon"><img id="topImg" src='' width="17px" height="17px"></img></span>
							<input type="button" class="inputd" value="配置快捷图标" id="changeTopIcon"/>
						</td>
					</tr>
					--%>
					<tr>
						<td colspan='2' align='right' style="padding-top: 5px;">
							<input id="submitInfo" type="button" class="inputd" value="提交"/>
						</td>
						<td colspan='2' style="padding-left: 15px;padding-top: 5px;">
							<input id="reset" type="button" class="inputd" value="重置"/>
						</td>
					</tr>
				</table>
    		</form>
		</div>
		 <!-- 菜单图标弹出框 -->
       <div id="iconResource"  closed="true" modal="true" class="easyui-window" title="配置菜单图标" 
				collapsible="false" minimizable="false" maximizable="false" style=background-color:#F1F1F1;width:410px;height:310px;">
	    	<div id="icons"></div>
	   </div>
	   <!-- 菜单快捷图标弹出框 -->
	   <div id="topIconResource"  closed="true" modal="true" class="easyui-window" title="配置快捷图标" 
				collapsible="false" minimizable="false" maximizable="false" style=background-color:#F1F1F1;width:410px;height:310px;">
	    	<div id="topIcons"></div>
	   </div>
	   
		<!-- 菜单资源列表 -->
		<div id="menuRes" class="easyui-panel" title="菜单资源列表" noheader="true" border="false" collapsible="false" closed="true" style="padding-right: 15px;">
			<div class="gridDiv" style="margin-left:5px;background:#FFFFFF;">
				<table id="tt"></table>
			</div>
			<div id="mm" class="easyui-menu" style="width:120px;">
			<div onclick="addChildRes()">增加子资源</div>
			<div onclick="edit()">修改资源</div>
			<div onclick="remove()">删除资源</div> 
			</div>
       </div> 
      
      
      <!-- 添加/修改资源Form -->
		<div id="resourceForm"  closed="true" modal="true" class="easyui-window" title="添加/修改资源" 
				collapsible="false" minimizable="false" maximizable="false" style=background-color:#F1F1F1;width:400px;height:310px;">
	    	<form id="add_edit_resourceform" method="post" style="padding-top: 20px;">
		        <input type="hidden" name="resId" id="resId" ></input>
		        <input type="hidden" name="menuId" id="resourceMenuId" ></input>
		        <input type="hidden" name="parentResId" id="parentResId" ></input>
		        <input type="hidden" name="elementTransId" id="elementTransId" ></input> 
                <input type="hidden" name="nodeTransId" id="nodeTransId" ></input> 
				<table cellSpacing="0" cellpadding="0" border="0" align="center">
					<tr id="parent_res">
						<td height="35px">隶属资源：</td>
						<td ><input type="text" name="parentRes" id="parentRes" class="easyui-validatebox input_eq" /></td>
					</tr>
					<tr>
						<td height="35px">资源类型：</td>
						<td >
							<select id="resType" style="width: 143px" name="resType" class="easyui-combobox">
								<rmp:option dictId="sys.resType" defaultValue="URL"></rmp:option>
							</select>
						</td>
					</tr>
					<tr>
						<td height="35px">交易编号：</td>
						<!--  -->
						<td ><input type="text" name="transId" id="transId" required="true" missingMessage="请输入交易编号" class="easyui-validatebox input_eq" /></td>
					</tr>
					<tr>
						<td height="35px">页面元素类型：</td>
						<td >
							<select id="pageEleType" style="width: 143px" name="pageEleType" class="easyui-combobox">
								<rmp:option dictId="sys.pageEleType"></rmp:option>
							</select>
						</td>
					</tr>
					<tr>
						<td height="35px">资源名称：</td>
						<!--required="true" missingMessage="请输入资源名称"  -->
						<td ><input type="text" name="resName" id="resName" required="true" missingMessage="请输入资源名称" class="easyui-validatebox input_eq" /></td>
					</tr>
					
					<tr>
						<td height="35px">资源路径：</td>
						<!-- required="true" missingMessage="请输入资源路径" -->
						<td ><input type="text" name="resPath" id="resPath" required="true" missingMessage="请输入资源路径" class="easyui-validatebox input_eq" /></td>
					</tr>
					<!-- add by renmeimang 13-10-10 增加是否记录日志字段 -->
					<tr>
						<td height="35px">是否自动记录日志：</td>
						<td>
							<select id="fields1" style="width: 143px" name="fields1" class="easyui-combobox" >
								<rmp:option dictId="sys.menu.logFlg"  ></rmp:option>
						    </select>
						</td>
					</tr>
					
					<tr>
						<td height="40px" colspan="2" align="center">
							<input id="submitResource" type="button" class="inputd" value="提交"/>
							<input id="cancelResource" type="button" class="inputd" value="取消"/>
						</td>
					</tr>
				</table>
    		</form>
		</div>
		</div>
    </body> 
</HTML>


