<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>机构管理</title>
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
<style type="text/css">
#formSearch .panel-body{
	border-bottom-style: none;
}
</style>
<script type="text/javascript">
		
/* 左侧机构树 */
$(function(){
	var setting = {
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
			beforeClick:beforeClick
		}
	};
	
	function beforeClick(treeId, treeNode){
		if(organList.window.searchOrgan != undefined) {
			organList.window.document.getElementById("orgSeq").value = treeNode.orgSeq;
			organList.window.searchOrgan();
		} else {
			organList.window.goBack(treeNode.orgSeq);
		}
		return true;
	}
	
	$.ajax({
		 cache:false,
		 type: "post",
		 dataType: "text",
		 url: "${pageContext.request.contextPath}/organ_ogranTree.action",
		 error: function () {
		 	$.messager.alert("系统提示","当前机构数据请求失败，请联系管理员","warning");
		 },
		 success:function(data){
			 var zNodes = eval(data);
			 $.fn.zTree.init($("#organTreeMg"),setting,zNodes);
		 }
	});
	
	var organListIframe = $("#organListIframe");
	organListIframe.attr("src", organListIframe.attr("url"));
});

//机构树增加搜索功能  zhouchaoqun   2013/06/27
function menuSearch() {
	var treeObj = $.fn.zTree.getZTreeObj("organTreeMg");
	
	treeObj.cancelSelectedNode();
	
	var value = $.trim($("#orgNameSearch").val());
	if(value == "") {
		$("#organTreeMg").show();
		$("#queryMsg").hide();
		return;
	}
	
	var nodes = treeObj.getNodesByParamFuzzy("orgName", value, null);
	if(nodes.length == 0) {
		$("#organTreeMg").hide();
		$("#queryMsg").show();
	} else {
		$("#queryMsg").hide();
		$("#organTreeMg").show();
	}
	for (var i=0; i<nodes.length; i++) {
		treeObj.selectNode(nodes[i],true);
	}
}
</script>
</head>
<body class="easyui-layout">
	<div region="west" split="true" title="上级机构" border="true" style="width:220px;">
		<div class="easyui-layout" fit="true">
			<div region="north" border="false" style="height: 30px;">
				<div style="padding: 5px 5px 0px 10px;">
					<table cellSpacing="00" cellpadding="0" border="0" align="center" >
						<tr>
							<td><input type="text" class="input_eq" style="width: 120px" name="orgNameSearch" id="orgNameSearch"/>&nbsp;</td>
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
				<ul id="organTreeMg" class="ztree"></ul>
			</div>
		</div>
	</div>
	<div region="center" title="机构管理">
		<iframe id="organListIframe" name="organList" src="" url="${pageContext.request.contextPath}/sec/sec_organ_list.jsp" class="bottomBack" allowtransparency="true" frameborder="0" style="height:99%;width:100%; overflow: hidden;" ></iframe>
	</div>
</body>
</html>

