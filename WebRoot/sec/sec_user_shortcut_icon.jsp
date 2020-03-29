<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>个人快捷图标</title>
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
<script src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
<style type="text/css">
	html{background: #e7f1fd;}
	#sortableDiv { list-style-type: none; margin: 0; padding: 0; width: 765px;}
	#sortableDiv li { margin: 3px 3px 3px 0; padding: 5px; float: left; width: 75px; height: 75px; font-size: 4em; text-align: center;cursor: pointer;background: none;border: none}
	/*快捷方式样式图标样式*/
.btn{
	width:75px;
	height:72px;
	text-align: center;
	padding-top: 7px;
	color:#195393;
	font-size: 11px;
	cursor: pointer;
	background: url("${pageContext.request.contextPath}/images/light.png") no-repeat !important;
}
/*快捷方式样式图标鼠标经过添加背景图片*/
.btn:HOVER{
	width:75px;
	height:72px;
	background: url("${pageContext.request.contextPath}/images/light.png") no-repeat !important;
	_filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(enabled='true', sizingMethod='noscale',src='images/light.png'); /* IE6 */
	_background:none;
	cursor: pointer;
}
/*快捷方式图标下的字体颜色*/
.btn a{
	color:#195393;
}
/*快捷方式图标距离上下边距*/
.btn img{
	padding-bottom: 5px;
	padding-top: 3px;
}
</style>
<script type="text/javascript">
//设置菜单图标、快捷图标绝对路径
var imgLocation_top = "common/shortcutIcon/";
var icon_total = null;
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
			$("#div_" + treeNode.menuId).remove();
		}
	    return true;
	};

	function addShortcutIcon(treeNode) {
		if(treeNode.leafFlg == "0")
			return;
		var sortableDiv = $("#sortableDiv");
		
		var imgSrc = imgLocation_top + treeNode.menuIcon;
		var div_id = "div_" + treeNode.menuId; 
		var tr_str = "<div id='" + div_id + "' class='apply_array'>" +
					 "	<div class='btn'>" +
					 "		<img src='${pageContext.request.contextPath}/" + imgSrc + "'><br>" +
					 "		<span>" + treeNode.menuName + "</span>" + 
					 "	</div>" +
					 "</div>"

		sortableDiv.append($(tr_str));
	};

	$.ajax({
		 cache:false,
		 type: 'post',
		 url: "${pageContext.request.contextPath}/shortcutIcon_loadUserShortcutIcon.action",
		 error: function () {
		 	$.messager.alert('系统提示','当前快捷图标数据请求失败，请联系管理员','warning');
		 },
		 success:function(data){
			var zNodes = eval("(" + data + ")");
			$.fn.zTree.init($("#shourtcutMenu"),setting,zNodes["userShortcutIcon"]);
			icon_total = parseInt(zNodes["userShortcutIconTotal"]);
			//展开所有节点
			var treeObj = $.fn.zTree.getZTreeObj("shourtcutMenu");
			treeObj.expandAll(true);

			//禁用父节点
			var nodes = treeObj.getNodesByParam("leafFlg", "0", null);
			if(nodes != null){
				for(var i = 0, len = nodes.length; i < len; i++){
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

			$("#sortableDiv").sortable({
				opacity: 0.6,
				revert: true,
				cursor: 'move'
			});
		 }
	});
});

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

function saveUserShortCutIcon(){
	var sortedIDs = $("#sortableDiv").sortable("toArray");

	var treeObj = $.fn.zTree.getZTreeObj("shourtcutMenu");
	for(var i = 0, len = sortedIDs.length; i < len; i++){
		if($.trim(sortedIDs[i]) == "")
			continue;
		var menuId = sortedIDs[i].substring(4, sortedIDs[i].length);
		var node = treeObj.getNodeByParam("menuId", menuId, null);
		node.shortcutOrder = i;
	}
	
	var nodes = treeObj.getCheckedNodes(true);

	if(!isNaN(icon_total) && icon_total < nodes.length) {
		$.messager.alert('系统提示', '个人快捷图标数量超出' + icon_total + '个,请重新配置!', 'warning');
		return false;
	}
	
	var fields = ["uuid", "menuId", "shortcutOrder"];
		
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
        url: "${pageContext.request.contextPath}/shortcutIcon_saveUserShortcutIcon.action",
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
		<center>
		<div style="width: 765px;padding-top: 30px;color: #195393;">
			<table style="float: left;"><tbody><tr style="height: 30px;">
						<td><img alt="" src="${pageContext.request.contextPath}/images/bell.png"></td>
						<td>&nbsp;提示：鼠标拖动图标调整位置进行排序</td>
			</tr></tbody></table>
		</div>
		<div id="sortableDiv" style="padding: 40px 0 0 0;">
			<div class='apply_array' style="display: none;">
			 	<div class='btn'>
			 		<img><br>
			 		<span></span>
		 		</div>
			</div>
		</div>
		
		</center>
		
		<table style="width: 100%; text-align: center;">
			<tbody>
			<tr>
				<td>
				<input type="button" class="inputd" value=" 提 交 " onClick="saveUserShortCutIcon();"/>
				</td>
			</tr>
			</tbody>
		</table>
		
	</div>
</body>
</html>

