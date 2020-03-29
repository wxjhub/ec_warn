<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>机构树</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.core-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.excheck-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.exedit-3.0.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/showModalCenter.js" type="text/javascript"></script>
<style type="text/css">
.tool_btn{
	background:url(../../css/images/toolbg.png) repeat-x;
	height:31px;
	border:#c0c0c0 solid 1px;
	border-right-style:none;
	border-left-style:none;
}
</style>
<script type="text/javascript">
var onlyLeaf = "${param.onlyLeaf}";			//是否只选择叶子节点
var organFilter = "${param.organFilter}";	//机构树过滤
var orgId = "${param.orgId}";				//机构ID
var chkStyle = "${empty param.chkStyle ? 'checkbox' : param.chkStyle}";		//勾选框样式
var enable = "${empty param.enable ? false : param.enable}";				//是否显示选择框
var url = "${empty param.url ? 'organ_ogranTree.action' : param.url}";
if(enable == "true")
	enable = true;
else
	enable = false;

$(function(){

	//机构树setting设置默认属性
	var setting = {
		view: {
			selectedMulti: true
		},
		check: {
			enable: enable,
			chkStyle: chkStyle
		},
		data: {
			simpleData: {
				enable: true,
				idKey: "orgId",
				pIdKey: "parentId"
			},
			keep: {
				parent: true,
				leaf:true
			},
			key: {
				name: "orgName"
			}
		},
		callback: {
			
		}
	};

	
	$.ajax({
		cache:false,
		type: 'post',
		url: url,
		data: {
			"organFilter": organFilter, 
			"orgId": orgId
		},
		error: function(){
			$.messager.alert('系统提示','当前机构数据请求失败，请联系管理员','warning');
		},
		success:function(data){
			var zNodes = eval(data);
			$.fn.zTree.init($("#organ_Tree_"), setting, zNodes);
		}
	});
	
});

function getSelectNodes(){
	var orgTree = $.fn.zTree.getZTreeObj("organ_Tree_");
	var nodes = "";
	if(enable)
		nodes = orgTree.getCheckedNodes(true);
	else
		nodes = orgTree.getSelectedNodes();
	
	var temp = new Array();
	for(var i = 0, len = nodes.length; i < len; i++){
		var node = nodes[i];
		if(onlyLeaf == "true" && node.isParent)
			continue;
				
		temp.push({
				id: node.orgId,
				name: node.orgName,
				pId: node.parentId,
				orgSeq: node.orgSeq
			});
	}
	return temp;
}

function getSelectOrgans(){
	var nodes = getSelectNodes();
	
	if (nodes.length == 0) {
		$.messager.alert('系统提示','您还未选择机构!','warning');
	} else if (!enable && nodes.length > 1) {
		$.messager.alert('系统提示','只允许选择一个机构!','warning');
	} else {
		closeModalCenter(nodes);
	}
}

function clearSelections(){
	var orgTree = $.fn.zTree.getZTreeObj("organ_Tree_");
	orgTree.checkAllNodes(false);
}

//机构树增加搜索功能  zhouchaoqun   2013/06/27
function organSearch() {
	var treeObj = $.fn.zTree.getZTreeObj("organ_Tree_");
	
	treeObj.cancelSelectedNode();
	
	var value = $.trim($('#orgNameSearch').val());
	if(value == "") {
		$("#organ_Tree_").show();
		$("#queryMsg").hide();
		return;
	}
	
	var nodes = treeObj.getNodesByParamFuzzy("orgName", value, null);
	if(nodes.length == 0) {
		$("#organ_Tree_").hide();
		$("#queryMsg").show();
	} else {
		$("#queryMsg").hide();
		$("#organ_Tree_").show();
	}
		
	for (var i=0; i<nodes.length; i++) {
		treeObj.selectNode(nodes[i],true);
	}
}
</script>
</head>
<body class="easyui-layout">
	<div region="center" border="false">
		<div class="easyui-layout" fit="true">
			<div region="north" border="false" style="height: 30px;background:#fff;">
				<div style="padding: 5px 5px 0px 10px;">
					<table cellSpacing="00" cellpadding="0" border="0" align="center" >
						<tr>
							<td><input type="text" class="input_eq" style="width: 120px" name="orgNameSearch" id="orgNameSearch"/>&nbsp;</td>
							<td><input class="inputd" type="button" value="搜索" onclick="organSearch();"/></td>
						</tr>
					</table>
				</div>
			</div>
			<div region="center" border="false" style="background:#fff;">
				<div id="queryMsg" style="display: none; padding-left: 10px;">
					<table><tbody><tr style="height: 30px;">
						<td><img alt="" src="${pageContext.request.contextPath}/common/menuIcon/caution_high_voltage.png"></td>
						<td>&nbsp;抱歉，没有您要查询的结果！</td>
					</tr></tbody></table>
				</div>
				<ul id="organ_Tree_" class="ztree"></ul>
			</div>
		</div>
	</div>
	<c:if test="${param.displayButton ne 'false'}">
	<div region="south" border="false" style="text-align:center;padding:5px 0;">
	  <input id="ok" class="inputd" iconCls="icon-ok" type="button" value="确定" onclick="getSelectOrgans()" />
	  <input id="cancel" class="inputd" iconCls="icon-cancel" type="button" value="取消" onclick="closeModalCenter()" />
	</div>
	</c:if>
</body>
</html>

