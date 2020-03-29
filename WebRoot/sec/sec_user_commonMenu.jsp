<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>   
	<head>
	<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
	<title>菜单查询</title>
	<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
	<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/gray/easyui.css">      
	<link rel="stylesheet" href="${pageContext.request.contextPath}/css/zTreeStyle/zTreeStyle.css" type="text/css">  
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.core-3.0.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.excheck-3.0.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.exedit-3.0.js"></script>
    <script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
    
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/themes/default/jquery-ui.css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-ui.js"></script>
	<style type="text/css">
	.ztree li button.remove {margin-right:2px; background-position:-112px 0px; vertical-align:top; *vertical-align:middle}
		html{background: #e7f1fd;}
		#sortable { list-style-type: none; margin: 0; padding: 0; width: 850px; }
		#sortable li { margin: 3px 3px 3px 0; padding: 5px; float: left; width: 75px; height: 75px; font-size: 4em; text-align: center;cursor: pointer;background: none;border: none}
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
	//菜单树设置
	//----------------------------------------------------------------------------------------------------------------
	//菜单树setting设置默认属性
		var setting = {
			view: {
				selectedMulti: false
			},
			data: {
				simpleData: {
					enable: true
				},
				keep: {
					parent: true,
					leaf:true
				}
			},
			edit: {
				enable: true,
				showRemoveBtn: true,
				showRenameBtn: false
			},
			callback: {
				beforeRemove: addToShortCutMenu
			}
		};
		function addToShortCutMenu(treeId, treeNode) {
			if(treeNode.leafFlg == 0) {
				$.messager.alert('系统提示','当前菜单为非叶子菜单，不能添加为常用菜单','warning');
			} else {
				var div = 
						"<div class='apply_array' title='"+ treeNode.name +"' id='"+treeNode.id+"'><div class='btn'><img src='${pageContext.request.contextPath}/common/shortcutIcon/" +treeNode.field3+ "' border='0' /><br>"+ treeNode.name+"</div>"
						+"<img src='${pageContext.request.contextPath}/css/themes/icons/no.png' alt='"+treeNode.id+"' style='position:relative;top:-75px;left:53px;' onclick='removeFromShortCutMenu(this)'/>"
						+"</div>";
				var flag = true;
				$('#sortable').children(".apply_array").each(function() {
			          if(treeNode.name == this.title) {
			        	  $.messager.alert('系统提示','当前菜单已设置为常用菜单','warning');
			        	  flag = false;
			          }
			        });
		        if(flag) {
					$( "#sortable" ).append(div);
					getShortCutMenu();
		        }
			}
			return false;
		}
		function removeFromShortCutMenu(obj) {
			$("#"+obj.alt).empty();
			getShortCutMenu();
		}
		//菜单树init方法
		function zTreeInit() {
			$.ajax({
				 cache:false,
				 type: 'post',
				 dataType : "text",
				 url: "secMenu_findAllMenus.action",
				 success:function(data){
				 if(data.indexOf("errorState")>0) {
					 return;
				 }
				 var zNodes = eval(data);
				 $.fn.zTree.init($("#treeDemo"),setting,zNodes);
				 }
	 		});
		}
		function iconInit() {
			getShortCutMenu();
			$('#oldOrder').val($('#newOrder').val());
			$( "#sortable" ).sortable({
				opacity: 0.6,
				revert: true,
				cursor: 'move',
				update: function(){
					getShortCutMenu();
				}
			});
			$( "#sortable" ).disableSelection();
		}
		function getShortCutMenu() {
			var new_order = [];
	        $('#sortable').children(".apply_array").each(function() {
	           new_order.push(this.id);
	        });
			$('#newOrder').val(new_order.join(','));
		}
		function submitForm(){
			$.ajax({
				dataType:'json',
		        type: "post",
		        url: "secMenu_saveTopMenuOrder.action",
		        data: {
		        	menuIds: $('#newOrder').val()
		        },
		        success: function(data) {
		            if(data=="1"){
		            	alert("保存成功");
		            }
		       	},
		       	error: function(){
		           	
		       	}
		     });
	}
	$(function() {
		zTreeInit();
		iconInit();
	});
   	</script>
	</head>
	<body class="easyui-layout" style="background-color:#EBF1FE;" border="false">
	  <!-- 左侧菜单树 -->
	  <div region="west" split="false" title="菜单树" style="width:225px;border-left: none;">
     	 <ul id="treeDemo" class="ztree"></ul>
      </div>
      <!-- 右侧表单 -->
      <div region="center" id="resourceList" title="常用菜单" style="background-color:#E7F1FD;">
     	<input type="hidden" id="oldOrder" value=""/>
		<input type="hidden" id="newOrder" value=""/>
		<div id="sortable" style="position: absolute;top:40px;left:15px;bottom: 60px">
		</div>
		<div style="position:absolute;bottom:200px;right:400px">
			<input class="zh_btnbg2" type="button" onclick="submitForm();" id="submit" value="保存"/>
		</div>
	</div>
    </body> 
</HTML>


