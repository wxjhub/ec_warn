<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统快捷图标</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.core-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.excheck-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.exedit-3.0.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/datagrid.js"></script>
<style type="text/css">
#formSearch .panel-body{
	border-bottom-style: none;
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
//设置菜单图标、快捷图标绝对路径
var imgLocation_top = "../common/shortcutIcon/";
var defaultIcon = "bricks.png";

$(function(){
	var setting = {
		data: {
			simpleData: {
				enable: true,
				idKey: "menuId",
				pIdKey: "pId"
			},
			keep: {
				parent: true,
				leaf:true
			},
			key: {
				name: "menuName"
			}
		},
		check: {
			enable: true
		},
		callback: {
			onClick: zTreeOnClick,
			onCheck: zTreeOnCheck
		}
	};
	
	function zTreeOnClick(event, treeId, treeNode) {
		var treeObj = $.fn.zTree.getZTreeObj(treeId);
		treeObj.checkNode(treeNode, null, true, true);
		return true;
	};
		

	function zTreeOnCheck(event, treeId, treeNode) {
		if(treeNode.checked){
			addShortcutIcon(treeNode);
		} else {
			$("#menuId_" + treeNode.menuId).remove();
		}
		setDatagridColor();
		setDatagridWidth();
	    return true;
	};

	function addShortcutIcon(treeNode) {
		if(treeNode.leafFlg == "0")
			return;
		var shourtcutMenuBody = $("#shourtcutMenuBody");
		
		if($.trim(treeNode.menuIcon) == "")
			treeNode.menuIcon = defaultIcon;
		
		var imgSrc = imgLocation_top + treeNode.menuIcon;

		var tr_id = "menuId_" + treeNode.menuId;
		var img_id = "img_" + treeNode.menuId; 
		var tr_str = "<tr id='" + tr_id + "'>" +
			    	 "	<td><div><input type='checkbox' name='checkboxName'></div></td>" +
			    	 "	<td><div>" + treeNode.menuName + "</div></td>" +
			    	 "	<td>" +
			    	 "		<div style='text-align: center;height: auto;'>" +
			    	 "			<img onClick='upIcon(\"" + tr_id + "\");' src='${pageContext.request.contextPath}/images/top_arrow_u2.gif'/>&nbsp;&nbsp;" +
		          	 "			<img onClick='downIcon(\"" + tr_id + "\");' src='${pageContext.request.contextPath}/images/top_arrow2.gif'/>" +
					 "		</div>" + 
					 "	</td>" +
			    	 "	<td>" + 
			    	 "		<div style='text-align: center;height: auto;'>" +
			    	 "			<img id='" + img_id + "' src='" + imgSrc + "' style='width:16px;height:16px;margin:0 auto;'></img>" + 
			    	 "			<a href='#' onClick='setMenuIcon(\"" + tr_id + "\");'>修改</a>" + 
			    	 //"			<input type='button' onClick='setMenuIcon(\"" + tr_id + "\");' style='margin-left:10px;height:18px;' class='inputd' value='配置图标'/>" + 
			    	 "		</div>" +
			    	 "	</td>" +
			    	 "</tr>";

		shourtcutMenuBody.append($(tr_str));
	};
	
	$.ajax({
		 cache:false,
		 type: 'post',
		 url: "${pageContext.request.contextPath}/shortcutIcon_loadShortcutIcon.action",
		 error: function () {
		 	$.messager.alert('系统提示','当前快捷图标数据请求失败，请联系管理员','warning');
		 },
		 success:function(data){
			var zNodes = eval(data);
			$.fn.zTree.init($("#shourtcutMenu"),setting,zNodes);

			//展开所有节点
			var treeObj = $.fn.zTree.getZTreeObj("shourtcutMenu");
			treeObj.expandAll(true);

			//禁用父节点
			var nodes = treeObj.getNodesByParam("leafFlg", "0", null);
			if(nodes != null){
				for(var i = 0, len = nodes.length; i < len; i++){
					treeObj.checkNode(nodes[i], true, false, false);
					treeObj.setChkDisabled(nodes[i], true);
				}
			}

			//获取所有选中的节点
			var checkedNodes = treeObj.getCheckedNodes(true);

			for(var i = 0, len = checkedNodes.length; i < len; i++) {
				for(var j = 0, length = checkedNodes.length - i -1; j < length; j++) {
					var orderA = checkedNodes[j].shortcutOrder;
					var orderB = checkedNodes[j + 1].shortcutOrder;
					if(orderA == undefined || orderB == undefined)
						continue;

					orderA = parseInt(orderA);  
					orderB = parseInt(orderB);  
					
					if(orderA > orderB) {
						var temp = checkedNodes[j + 1];
						checkedNodes[j + 1] = checkedNodes[j]; 
						checkedNodes[j] = temp;
					}
				}
			}
			
			for(var i = 0, len = checkedNodes.length; i < len; i++) {
				addShortcutIcon(checkedNodes[i]);
			}
			setDatagridColor();
			setDatagridWidth();
		 }
	});

	iconDefalut();
});

function upIcon(menuId){
	var tr_ = $("#" + menuId);
	var prev_tr = tr_.prev();
	if(prev_tr.length == 0)
		return;
	prev_tr.before(tr_);
	setDatagridColor();
};

function downIcon(menuId){
	var tr_ = $("#" + menuId);
	var next_tr = tr_.next();
	if(next_tr.length == 0)
		return;
	next_tr.after(tr_);
	setDatagridColor();
};
//菜单图标、快捷图标初始化
function iconDefalut() {
	$.ajax({
		 cache:false,
		 type: 'post',
		 dataType : "text",
		 url: "${pageContext.request.contextPath}/secMenu_IconSum.action",
		 success:function(data){
			 if(data.indexOf("errorState")>0) {
				 return;
			 }
			// 将data用“,”分割,依次展示
			 var Icons = data.split("||");
			 var topIcons = Icons[1].split(",");
			 for ( var i = 0; i < topIcons.length-1; i++) {
				var array_element = topIcons[i];
				$("#topIcons").append('<span><a href="#"><img src="'+imgLocation_top+array_element+'" title="'+array_element+'" alt="" width="32px" height="32px" onclick="changeIcon(this.title)" /></a></span>');
			 }
		 }
		});
};

var currentMenuId = null;
function setMenuIcon(menuId){
	currentMenuId = menuId
	$('#iconResource').window('open');
};

//菜单图标选择
function changeIcon(icon){
	$('#iconResource').window('close');
	if(currentMenuId == null)
		return;

	var menuId = currentMenuId.substring(7, currentMenuId.length);
	var treeObj = $.fn.zTree.getZTreeObj("shourtcutMenu");
	var node = treeObj.getNodeByParam("menuId", menuId, null);
	node.menuIcon = icon;

	$("#img_" + menuId).attr({src: imgLocation_top + icon});
};

function menuSearch() {
	var treeObj = $.fn.zTree.getZTreeObj("shourtcutMenu");
	treeObj.cancelSelectedNode();
	var value = $.trim($('#shourtcutMenuSearch').val());
	if(value == "") {
		$("#shourtcutMenu").show();
		$("#queryMsg").hide();
		return;
	}
	
	var nodes = treeObj.getNodesByParamFuzzy("menuName", value, null);
	if(nodes.length == 0) {
		$("#shourtcutMenu").hide();
		$("#queryMsg").show();
	} else {
		$("#queryMsg").hide();
		$("#shourtcutMenu").show();
	}
	for (var i=0; i<nodes.length; i++) {
		treeObj.selectNode(nodes[i],true);
	}
};

function saveShortCutIcon(){
	var shourtcutMenuBody = $("#shourtcutMenuBody");
	var trArr = shourtcutMenuBody.find("tr");
	var treeObj = $.fn.zTree.getZTreeObj("shourtcutMenu");
	if(trArr.length != 0) {
		trArr.each(function(i){
			var menuId = $(this).attr("id");
			menuId = menuId.substring(7, menuId.length);
			var node = treeObj.getNodeByParam("menuId", menuId, null);
			node.shortcutOrder = i;
		});
	}

	var nodes = treeObj.getCheckedNodes(true);
	var fields = ["uuid", "menuId", "menuIcon", "shortcutOrder"];
		
	var str = "[";
	for (var i = 0, len = nodes.length; i < len; i++) {
		var s = "{";
		for (var j = 0, leng = fields.length; j < leng; j++) {
			if ($.trim(nodes[i][fields[j]]) == "")
		        continue;
		    s += fields[j] + ":\"" + nodes[i][fields[j]] + "\"";
		    if(j < leng - 1)
			    s += ",";
		}
		s += "}";
		str += s;
		if(i < len - 1)
			str += ",";
	}

	str += "]";
	
	$.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/shortcutIcon_saveShortcutIcon.action",
        data: {
        	shortcutIcon: str
        },
        success: function(data) {
            $.messager.alert('系统提示', '保存成功!', 'warning');
		    var treeObj = $.fn.zTree.getZTreeObj("shourtcutMenu");
			if(str == "" || str == "[]") {
				var allNodes = treeObj.getNodes();
				for(var i = 0, len = allNodes.length; i < len; i++) {
					delete allNodes[i].uuid;
				}
				return;
			}
            
            if(data == null)
                return;

            var menuJson = eval("(" + data + ")");
			for(var i in menuJson){
				var menu = menuJson[i];
				var node = treeObj.getNodeByParam("menuId", menu.menuId, null);
				node.uuid = menu.uuid;
			}
        },
        error: function(data) {
            $.messager.alert('系统提示', '保存失败!', 'warning');
        }
    });
};
</script>
</head>
<body class="easyui-layout">
	<div region="west" split="true" border="true" style="width:250px;">
		<div class="easyui-layout" fit="true">
			<div region="north" border="false" style="height: 30px;">
				<div style="padding: 5px 5px 0px 10px;">
					<table cellSpacing="00" cellpadding="0" border="0" align="center" >
						<tr>
							<td><input type="text" class="input_eq" style="width: 120px" name="shourtcutMenuSearch" id="shourtcutMenuSearch"/>&nbsp;</td>
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
				<ul id="shourtcutMenu" class="ztree"></ul>
			</div>
		</div>
	</div>
	<div region="center">
		<div style="padding: 30px 30px 15px 30px;">
		<div style="margin-top: -10px; padding-bottom: 20px;">
			<form name="formSearch" id="formSearch" method="post">
			</form>
		</div>
		<div class="panel datagrid">
			<div class="panel-header"><div>快捷图标管理</div></div>
			<div class="datagrid-wrap panel-body">
				<div class="datagrid-view" style="width:100%; height: 288px;">
					<div class="datagrid-view2" style="width:100%; left: 0px; ">
						<div class="datagrid-header" style="width:100%; height: 26px;">
							<div class="datagrid-header-inner" style="display: block; ">
								<table border="0" cellspacing="0" cellpadding="0" style="height:27px;">
									<tbody>
										<tr>
											<td><div class="datagrid-header-check"><input type="checkbox" disabled="disabled"/></div></td>
											<td><div style="width: 20%;"><span>菜单名称</span></div></td>
											<td><div style="width: 20%; text-align: center;"><span>排序</span></div></td>
											<td><div style="width: 20%; text-align: center;"><span>图标</span></div></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="datagrid-body" style="width:100%; height: 261px;">
							<table cellspacing="0" cellpadding="0" border="0">
								<tbody id="shourtcutMenuBody">
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		</div>
		
		<table style="width: 100%; text-align: center;">
		<tbody>
		<tr>
			<td>
			<input type="button" class="inputd" value=" 提 交 " onClick="saveShortCutIcon();"/>
			</td>
		</tr>
		</tbody>
		</table>
		
		<div id="iconResource" closed="true" modal="true" class="easyui-window" title="配置快捷图标" 
				collapsible="false" minimizable="false" maximizable="false" style=background-color:#F1F1F1;width:410px;height:310px;">
	    	<div id="topIcons"></div>
		</div>
		
	</div>
</body>
</html>

