<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/loading.jsp" %>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/themes/default/easyui.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/themes/icon.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/zTreeStyle/zTreeStyle.css" rel="stylesheet"  type="text/css">

<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/md5.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.core-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.excheck-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.exedit-3.0.js"></script>
<script src="${pageContext.request.contextPath}/js/showModalCenter.js" type="text/javascript"></script>
<link rel="icon" href="favicon.ico" type="image/x-icon" />
<link REL="SHORTCUT ICON" HREF="favicon.ico" type="image/x-icon" />

<title >监控系统</title>
<style type="text/css">
	html{
		overflow: hidden;
	}
	.ztree{
	padding-left: 0px;
	padding-right: 0px;
	width: 100%;
	}
	.ztree li a.level0 {
	height: 32px; 
	display:block; 
	background: url(${pageContext.request.contextPath}/images/leftMenuClose.jpg);
	border-bottom:1px solid #99bbe8;
	border-right:1px solid #99bbe8;
	border-left-style:none;
	margin-right: 0px;
	padding-left: 40px;
	}
	.ztree li a.level0.cur {
	background-image: url(${pageContext.request.contextPath}/images/leftMenuOpen.jpg) !important;
	background-color: none;
	}
	.ztree li a.level0 span {display: block; color: #15428b; padding-top:10px; font-family:'Microsoft YaHei'; font-size:13px;word-spacing: 2px;}
	.ztree li a.level0 button {	float:right; margin-left: 10px; visibility: visible;display:none;}
	.ztree li button.switch.level0 {display:none;}
</style>
<script type="text/javascript">
//关闭浏览器或页面刷新的时候执行 
function onbeforeunload_handler(flag){ 
	$.ajax({    
		  url: "${pageContext.request.contextPath}/isLogin_closeOpen.action?flag="+flag,
		  type: "POST",
		  async: false,
		  success: function(data){  	
		  }    
	});
   } 
 //初始化加载
 $(function() {
		//----加载基础内容：时间组件、样式组件等等 begin------------
		//加载时间组件
		setInterval(showtime,1000);
		//绑定右键事件
		tabCloseEven();
		$("#minheader").css("display","none");
		var screenheight = $(window).height();
		//初始化欢迎界面tab
		$('#tabs').tabs("add", {
				title:'欢迎页面',
				closable:true,
				content:'<iframe src="${pageContext.request.contextPath}/main.jsp" class="bottomBack" allowtransparency="true" frameborder="0" style="height:100%;width:100%;" />'
		});
		tabClose();
		//----加载基础内容：时间组件、样式组件等等 end------------
		refresh();  //加载刷新事件
		topMenu();  //加载顶部样式
		resetPaswod(); //加载是否首次登陆或180天修改密码，如是，弹出修改密码窗口
		var flag = checkLogin();
		if(flag) {
			isSelectProject(); //加载是否选择工程
			var curMenu = null, zTree_Menu = null; //定义菜单手风琴
			loadMenu(); //加载左侧菜单
			//加载项目组自定义内容
		}
		onbeforeunload_handler("1"); //重新进入页面set session用户标志
	}); 
/*
 * 显示当前时间
 */
function showtime(){
	var now=new Date();
	var year=now.getFullYear();
	var month=now.getMonth()+1;
	var day=now.getDate();
	var hours=now.getHours();
	var minutes=now.getMinutes();
	if(minutes<10) {
		minutes = "0"+minutes;
	}
	var seconds=now.getSeconds();
	if(seconds<10) {
		seconds = "0"+seconds;
	}
	time='&nbsp;当前时间为：'+year+'-'+month+'-'+day +' '+hours+':'+minutes+':'+seconds;
	var div1=document.getElementById('div1');
	div1.innerHTML=time;
	var div2=document.getElementById('div2');
	div2.innerHTML=time;
}
//输入时候支持回车
function changeFocus(){
	if (event.keyCode==13)
	 event.keyCode=9;
}
/*
 * 首页顶部折叠
 */
function topClose(){
	$("#maxheader").css("display","none");
	$("#minheader").css("display","block");
	$('#north').panel('resize',{height:40});
	$('#leftMenu').panel('resize',{top:40,height:$("#leftMenu").height()+55});
	$('#center').panel('resize',{top:40,height:$("#center").height()+55});
}
/*
 * 首页顶部展开
 */
function topOpen(){
	$("#maxheader").css("display","block");
	$("#minheader").css("display","none");
	$('#north').panel('resize',{height:95});
	$('#leftMenu').panel('resize',{top:95,height:$("#leftMenu").height()-55});
	$('#center').panel('resize',{top:95,height:$("#center").height()-55});
}
function refresh(){
	if(document.all){ 
	    $("a[href='javascript:void(0)']").live("click",function (e){ 
	        e.preventDefault(); 
	    }); 
	}
	/*
	IE浏览器关闭事件
	window.onbeforeunload = function() {
		window.location.href="logout";
	};
	*/
}
function topMenu() {
	var screenWidth = document.body.clientWidth;
	if(screenWidth>1024){
		$(".apply_nav").width(760);
		$(".apply_w").width(600);
	}else{
		$(".apply_nav").width(420);
		$(".apply_w").width(260);
	}
	
	$li1 = $(".apply_nav .apply_array");
	for(var i=0;i<$li1.length;i++){
		if($("#topIcon"+i).text().length>6){
			$("#topIcon"+i).text($("#topIcon"+i).text().substring(0,6));
		}
	}
	
	$window1 = $(".apply .apply_w");
	$left1 = $(".img_l");
	$right1 = $(".img_r");
	$window1.css("width", $li1.length*85);
	var lc1 = 0;
	var rc1 = 0;
	if(screenWidth>1024){
		rc1 = $li1.length-9;
	}else{
		rc1 = $li1.length-5;
	}
	
	$left1.click(function() {
		var screenW = document.body.clientWidth;
		if(screenW>1024){
			if (lc1 < 1) {
				return;
			}
			lc1=lc1-9;
			rc1=rc1+9;
			$window1.animate({left:'+=765px'}, 600);
		}else{
			if (lc1 < 1) {
				return;
			}
			lc1=lc1-5;
			rc1=rc1+5;
			$window1.animate({left:'+=425px'}, 260);
		}
	});
	$right1.click(function() {
		var screenW = document.body.clientWidth;
		if(screenW>1024){
			if (rc1 < 1) {
				return;
			}
			lc1=lc1+9;
			rc1=rc1-9;
			$window1.animate({left:'-=765px'}, 600);
		}else{
			if (rc1 < 1) {
				return;
			}
			lc1=lc1+5;
			rc1=rc1-5;
			$window1.animate({left:'-=425px'}, 260);
		}
	});
}
//点击顶部“首页”按钮，出现tab框定位到欢迎页面
function tofirstpage(){
	if ($('#tabs').tabs('exists', '欢迎页面')){
		$('#tabs').tabs('select', '欢迎页面');
	}
	else{
		$('#tabs').tabs("add", {
			title:'欢迎页面',
			closable:true,
			content:'<iframe src="${pageContext.request.contextPath}/main.jsp" class="bottomBack" allowtransparency="true" frameborder="0" style="height:100%;width:100%;" />'
		 });
		tabClose();
	}
}
function tabCloseEven() //绑定右键菜单事件
{
    //关闭当前
    $('#mm-tabclose').click(function(){ 
    	var currtab_title = $('#mm').data("currtab");
        $('#tabs').tabs('close',currtab_title);
    });   
    //全部关闭
    $('#mm-tabcloseall').click(function(){
    	$('.tabs-inner span').each(function(i,n){
            var t = $(n).text();
            $("#tabs").tabs('close',t);
        });    
    });
    //关闭除当前之外的TAB
    $('#mm-tabcloseother').click(function(){
        var currtab_title = $('#mm').data("currtab");
        $('.tabs-inner span').each(function(i,n){
            var t = $(n).text();
            if(t!=currtab_title)
                $("#tabs").tabs('close',t);
        });    
    });
    //取消
	$("#mm-exit").click(function(){
		$('#mm').menu('hide');
	});
}
function tabClose(){
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu',function(e){
    	$('#mm').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
        var subtitle =$(this).children("span").text();
        $('#mm').data("currtab",subtitle);
        $('#tabs').tabs('select',subtitle);
        return false;
    });
}
/*
 * ---------------------------------------------------------------------------------------------------------------
 * ---------------------------------------------------------------------------------------------------------------
 * 安全框架部分
 */
 
 
 /*
 * 加载左侧菜单
 * 
 */
function loadMenu() {
 	var sysMenuName = "<input class='easyui-validatebox' id='searchMenuName' style='width:60px'/>&nbsp;<input class='inputd' style='width:40px;border-right:1px solid #ccc' onclick='menuSearch()' type='button' value='搜索'/>";
	var $_leftMenu = $("#leftMenu1");
	$_leftMenu.accordion("add", {  
		title: sysMenuName,    
		content: "<ul id='menuTreeMg' class='ztree'></ul>"
	});
	var setting = {
		view: {
			showLine: true,
			selectedMulti: true,
			dblClickExpand: false
		},
		data: {
			simpleData: {
				enable: true
			}
		},
		callback: {
			onNodeCreated: this.onNodeCreated,
			beforeClick: beforeClick,
			onClick: this.onClick
		}
	};
	var zNodes = eval('${menuData}');
	$.fn.zTree.init($("#menuTreeMg"),setting,zNodes);
	zTree_Menu = $.fn.zTree.getZTreeObj("menuTreeMg");
	curMenu = zTree_Menu.getNodes()[0].children[0];
	zTree_Menu.selectNode(curMenu);
	var a = $("#" + zTree_Menu.getNodes()[0].tId + "_a");
	a.addClass("cur");
 }
 //左侧菜单点击事件
function beforeClick(treeId, node) {
	if (node.isParent) {
		if (node.level === 0) {
			var pNode = curMenu;
			while (pNode && pNode.level !==0) {
				pNode = pNode.getParentNode();
			}
			if (pNode !== node) {
				var a = $("#" + pNode.tId + "_a");
				a.removeClass("cur");
				zTree_Menu.expandNode(pNode, false);
			}
			a = $("#" + node.tId + "_a");
			a.addClass("cur");
	 
			var isOpen = false;
			for (var i=0,l=node.children.length; i<l; i++) {
				if(node.children[i].open) {
					isOpen = true;
					break;
				}
			}
			if (isOpen) {
				zTree_Menu.expandNode(node, true);
				curMenu = node;
			} else {
				zTree_Menu.expandNode(node.children[0].isParent?node.children[0]:node, true);
				curMenu = node.children[0];
			}
		} 
	}else {
		clickTreeNode(node.name ,node.menuUrl);
	}
	return !node.isParent;
}
 
 function clickTreeNode(title, url) {
	if ($('#tabs').tabs('exists', title)){
		$('#tabs').tabs('select', title);//选中并刷新
		var currTab = $('#tabs').tabs('getSelected');
		//var url = $(currTab.panel('options').content).attr('src');
		if(url != undefined && currTab.panel('options').title != 'Home') {
			$('#tabs').tabs('update',{
				tab:currTab,
				options:{
					content:createFrame(url)
				}
			});
		}
	} else {
		//提供配置tab页已打开的最大个数    begin                   zhouchaoqun          2013/06/26
		if(parseInt($('#maxTabsNum').val()) > 0 && parseInt($('#tabs').tabs('tabs').length) + 1 > parseInt($('#maxTabsNum').val())) {
			$.messager.alert('系统提示','当前已打开的功能菜单数量达到系统允许上限：['+$('#maxTabsNum').val()+'个],请先 减少打开的功能菜单数量！','warning');
			return false;
		}
		//提供配置tab页已打开的最大个数    end                   zhouchaoqun          2013/06/26
		
		var content = createFrame(url);
		$('#tabs').tabs('add',{
			title:title,
			content:content,
			closable:true
		});
	}
	tabClose();
}
function createFrame(url) {
	if(url.indexOf('/')==0){
		url = '${pageContext.request.contextPath}' + url;
	}else if(url.indexOf('http')==0){
		url =  url;
	}else{
		url ='http://' + url;
	}
	var s = '<iframe src="'+url+'" scrolling="auto" frameborder="0" allowtransparency="true" style="width:100%;height:100%;"></iframe>';
	return s;
}
 /*
  *判断是否拥有特殊角色
  * 当拥有特殊角色时，登陆系统后，不用选择工程
  * 特殊角色配置在sysConfig.properties文件中：roleFtpAdmin
  */
 function hasRole(){
	var flag = "";
	$.ajax({
	     	dataType:'text',
			url:'${pageContext.request.contextPath}/project_hasRoleAction.action',
			type:'post',
			async: false,
			success:function(data){
				flag += data;
	    	}
       });
    return flag;
}
//判断用户数是否是首次登录或者是否180天内没登录
function checkLogin(){
	var flag = "${flag}";
	var userId = "${userId}";
	var oldPassword = "${oldPassword}";
	$('#userId').val(userId);
	$('#updatePassword').dialog('close');
	if(flag == "0" || flag == "2"){
		$('#updatePassword').dialog('open');
		return false;
	} else {
		return true;
	}
}
//密码修改                                            zhouchaoqun             2013/6/21
function updPassword() {
	$("#outBtnDiv").hide();
	$("#closeBtnDiv").show();
	$('#updatePassword').dialog('open');
}
//保存密码
function submitForm(){
	  var password=document.getElementById("password").value.replace(/(^\s*)|(\s*$)/g, "");
	  var passwordStr=document.getElementById("passwordStr").value.replace(/(^\s*)|(\s*$)/g, "");
	  if(password != null && password.length > 0){
		  if(hex_md5(password)=="${oldPassword}"){
            $.messager.alert('系统提示','新密码不能与原密码相同！','warning');
		  }else{
			  if(password!=passwordStr){
				  $.messager.alert('系统提示','两次输入的密码不一致！请重新输入密码！','warning');
	          }else{
				$('#formSave').form('submit', {
				     url:'${pageContext.request.contextPath}/currentUserAction_updatePassword.action',
				     onSubmit: function(){//提交前进行easyui表单验证
					 	return $(this).form('validate');
					 },
					 success:function(data){
		                 var result=data;
		 				 if("1"==result){
		 					$('#updatePassword').dialog('close');
		 					$.messager.alert('系统提示','密码修改成功，请重新登录！','info',function(){
		 						window.location.href = "logout";
			 				});
		 				 }
					 } 
				 }); 	 	
	          }
	      }  
	  } 
 }
 
//验证两次输入的密码是否一致
function checkPasswordStr() {
	var password=document.getElementById("password").value.replace(/(^\s*)|(\s*$)/g, "");
	var passwordStr=document.getElementById("passwordStr").value.replace(/(^\s*)|(\s*$)/g, "");
	if (passwordStr!=password) {
		$.messager.alert('系统提示','两次输入的密码不一致！请重新输入密码！','warning');
	}
}

function isSelectProject() {
	if("${projectStatus}" != "1") {
		var skip = hasRole();
		if(skip=='false'){		//非管理员
			selectActiveProject();
		}	
	}
}

//选择一个激活的工程
function selectActiveProject(){
	$('#activeProject').dialog('open');
	$('#userProjectGrid').datagrid({
		title:'选择一个要激活的工程',
		iconCls:'icon-computer',
		width:'100%',
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'${pageContext.request.contextPath}/project_showProjects.action',		//请求数据的url
		idField:'projectId',					//标识字段
		sortName: 'projectId',
		sortOrder:'desc',				//采用降序排序
		singleSelect:true,
		columns:[[
			{field:'projectId', checkbox:true, width:20},
			{field:'projectId123', title:"工程编号", align:'center', width:100 ,
              	formatter:function(value, rowData, rowIndex){
	       	    	return rowData.projectId;
         	}},
			{field:'projectName', title:"工程名称", align:'center', width:100},
			{field:'lockFlg', title:"锁定状态", align:'center', width:100,
				formatter:function(value, rowData, rowIndex){
       				 if("0" == rowData.lockFlg) {
       					 return "<font color='red'>锁定</font>";
       				 } else {
       					 return "正常";
       				 }
       	    	}
			}
		]],
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
			if(rowData.lockFlg=="0") {
				$('#userProjectGrid').datagrid("unselectAll");
				$.messager.alert('系统提示','当前工程已锁定,无法使用','info');
			}
		}
	
	});
}
function resetPaswod() {
	$('#reset').click(function(){
           $('#password').val('${user.password}');
           $('#passwordStr').val('${user.password}');
        });
}
//进行选中的工程激活
function activeProject(){
	var selected = $('#userProjectGrid').datagrid('getSelections');
	if(selected.length == 0) {
		$.messager.alert('系统提示','请选择要激活的工程！','warning');
		return;
	}
	if(selected.length >1) {
		$.messager.alert('系统提示','只能选择一个工程进行激活！','warning');
		$('#userProjectGrid').datagrid('unselectAll');
		return;
	}
	var projectId = selected[0].projectId;
	$.ajax({
		  url: "${pageContext.request.contextPath}/project_activeProject.action",
		  dataType:"text",
		  data:{
		      'projectId':projectId
		  },
		  async: false,
		  success: function(info){
			  //激活成功
			  if("1"==info){
				$('#activeProject').dialog('close');
				showModalDialog('${pageContext.request.contextPath}/taskShow_list.action','任务提示','dialogWidth:550px;dialogHeight:350px;center:yes;help:no;resizable:no;status:no');
			  }
		  }
	});
}

//返回登录页面
function toLoginPage(){
	window.location.href = "logout";
}
function menuSearch() {
	var treeObj = $.fn.zTree.getZTreeObj("menuTreeMg");
	
	treeObj.cancelSelectedNode();
	
	var value = $.trim($('#searchMenuName').val());
	if(value == "") {
		return;
	}
	
	var nodes = treeObj.getNodesByParamFuzzy("name", value, null);
	for (var i=0; i<nodes.length; i++) {
		treeObj.selectNode(nodes[i],true);
		//if(!nodes[i].isParent) {
		//	clickTreeNode(nodes[i].menuName, nodes[i].menuUrl);
		//}
	}
}

/*
 * -------------------------------------------------------------------------------------------------------------------------------------
 * 项目组自定义
 */
function taskShow(){
	showModalDialog('${pageContext.request.contextPath}/taskShow_list.action','任务提示','dialogWidth:550px;dialogHeight:350px;center:yes;help:no;resizable:no;status:no');
}

function myConsole(){
	showModalCenter ("${pageContext.request.contextPath}/portal_toConsole.action", function(data){
		clickTreeNode('欢迎页面','/main.jsp');
	}, "650", "360", "我的工作台");
}

function closePwdDialog() {
	document.getElementById("password").value = "";
	document.getElementById("passwordStr").value = "";
	$('#updatePassword').dialog('close');
}
</script>
</head>
<body  onbeforeunload="onbeforeunload_handler('0');" class="easyui-layout" style="overflow: hidden;">
<div>
	<%-- 打开tab页最大数 --%>
	<input id="maxTabsNum" type="hidden" value="${requestScope.maxTabsNum}">
</div>

<div region="north" border="false" id="north" style="height: 95px;overflow: hidden">
<div id="header">
  <div class="head minwidth" id="maxheader">
  	<div class="rightbg">
  		<table width="100%" border="0" style="border-color: red;overflow: hidden;">
  		<tr>
  		<td valign="top">
    	<div class="left">
    		<div style="background: url('images/topLogoBg.jpg');height: 95px;width:220px;">
	    		<img src="images/topLogo.png" border="0" style="z-index: 100;position: absolute;top: 10px;left: 25px;"/>
	    		<img src="images/systemName3.png" border="0" style="z-index: 100;position: absolute;top: 55px;left: 25px;"/>
    		</div>
    	</div>
    	</td>
    	<td>
    		<div class="img_l"></div>
    	</td>
    	<td width="">
	    <div class="apply">
	    	<div class="apply_nav">    	
	     		<div class="apply_w">
	     			<c:forEach items="${topMenu}" var="menu" varStatus="status">
		     			<div class="apply_array">
		       				<a href="#">
		            			<div class="btn" title="${menu.menuName}" onclick="clickTreeNode('${menu.menuName}','${menu.menuUrl}')">
		            			<img src="${pageContext.request.contextPath}/common/shortcutIcon/${menu.menuIcon}" border="0" /><br>
		            			<span id="topIcon${status.index}">${menu.menuName}</span>
		            		</div>
		        			</a>
		        		</div>
	     			</c:forEach>
				</div>
    		</div>
 		</div>
 		</td>
 		<td>
 			<div class="img_r"></div>
 		</td>
 		<td>
	    <div>
		    <table border="0" cellpadding="0" cellspacing="0" style="margin-left:30px;overflow: hidden; ">
	    		<tr>
	    			<td height="25px" nowrap="nowrap" style="padding-left: 18px;" width="5px">
	    				 <img src="images/clock.png" border="0"/>
	    			</td>
	    			<td height="25px" nowrap="nowrap">
	    				 <div id="div1"></div>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td height="25px" nowrap="nowrap" style="padding-left: 20px;" colspan="2">
	    				<div class="goclose">
	    				<table>
	    				<tr>
						   <td style="width:60px"><a class="firstpage" href="javascript:void(0)"onclick="tofirstpage();return false">首页</a></td>
						   <td><a class="tuichu" href="logout">退出</a></td>
						</tr>
						 <tr>
						 <td><a class="updPassword" href="javascript:void(0)" onclick="updPassword();"><font style="color: blue;">密码修改</font></a></td>
						   <td><a class="top_arrow" onclick="topClose()" title="折叠">&nbsp; &nbsp;</a></td>
					    </tr>
					    </table>
					    </div>
	    			</td>
	    		</tr>
	    	</table>
	    </div>
	    </td>
	    </tr>
	    </table>
    </div>
  </div>
  <div class="minwidth" id="minheader">
  <div class="">
  		<div style="float: left;padding: 6px 0 0 10px;"><h:sys type="minLogo"></h:sys></div>
	    <div style="float: right">
		    <div class="goclose" style="padding: 9px 0px 0 0px;">
		    	<div id="div2" style="float: left;padding-right: 20px;margin-top: -3px;"></div>
		    	<a class="firstpage" href="javascript:void(0)"onclick="tofirstpage();return false">首页</a>
		    	<a class="tuichu" href="logout">退出</a>
		    	<a class="top_arrow2" onclick="topOpen()" title="展开"></a>
		    </div>
	    </div>
   </div>
  </div>
</div>
</div>
<div region="west" split="true" id="leftMenu" border="false" style="width:170px;height: 600px;">
    <div id='leftMenu1' fit="true" class='easyui-accordion'></div>
</div>
<div region="center" title="" border="false" id="center" style="height: 600px;">
  	<div id="tabs" class="easyui-tabs" fit="true" border="false" style="background:none;">
  	</div>
    <div id="mm" class="easyui-menu" style="width:150px;display: none">
        <div id="mm-tabclose">关闭</div>
        <div id="mm-tabcloseall">全部关闭</div>
        <div id="mm-tabcloseother">关闭其他</div>
	    <div id="mm-exit">取消</div>
	</div>

	<div id="updatePassword" class="easyui-dialog" title="修改用户密码" closed="true" closable="false" modal="true" collapsible="false" minimizable="false" maximizable="false" 
	   style=background-color:#F1F1F1;width:400px;height:255px;">
	   <TABLE border=0 style="width: 380px;">
		<TBODY>
			<TR>
				<TD noWrap height=40 valign="middle" style="padding-left: 25px;">
				<FORM name="formSave" id="formSave" method="post" style="padding-top: 25px">
				<input type="hidden" id="userId" name="userId"></input>
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td width="70px" height="40px" style="padding-left: 20px">新密码：</td>
						<td height="30px">
							<input type="password"
							class="easyui-validatebox input_eq" required="true" missingMessage="请输入新密码!" 
							validType="length[6,18]" style="width: 150px"
							name="password" id="password"/>
						</td>
					</tr>
					<tr>
					    <td width="70px" height="40px" style="padding-left: 20px">确认新密码：</td>
						<td height="30px">
							<input type="password"
							class="easyui-validatebox input_eq" required="true" missingMessage="请再次输入新密码!"
							validType="length[6,18]" onblur="checkPasswordStr()" style="width: 150px"
							name="passwordStr" id="passwordStr"/>
						</td>
					</tr>
				</table>
				</FORM>
	            <div class="zh_btn" style="margin-left: 25px">
		           <input class="zh_btnbg2" type="button" onclick="submitForm();" value="提交"/>
		           <input type="button" id="reset" class="zh_btnbg2" value="重置"/>
		           <input class="zh_btnbg2" type="button" onclick="toLoginPage();" id="outBtnDiv" value="退出"/>
		           <input id="closeBtnDiv" class="zh_btnbg2" style="display: none;" type="button" onclick="closePwdDialog();" value="关闭">
	            </div>
				</TD>
			</TR>
		</TBODY>
	</TABLE>
	</div>
<div id="activeProject" class="easyui-dialog" title="激活工程" closed="true" closable="false" modal="true" collapsible="false" minimizable="false" maximizable="false" 
   style=background-color:#F1F1F1;width:400px;height:250px;">
   	<div style="height: 75%;padding-left: 25px; padding-right: 25px; padding-top: 15px; padding-bottom: 10px;">
		<table id="userProjectGrid" ></table>
   	</div>
        <input class="zh_btnbg2" style="margin-left: 120px;" type="button" onclick="activeProject();" id="" value="确定"/>
        <input class="zh_btnbg2" style="margin-left: 10px;" type="button" onclick="toLoginPage();" id="" value="退出"/>
</div>

<div class="lefticons" style="z-index: 100000"></div>
</div>
<div region="south" border="false" style="height: 30px;">
 <div id="pagebottom" style="width:100%;background-image: url('${pageContext.request.contextPath}/images/bottombg.png');position: fixed">
  	<div style="line-height: 33px;position: absolute;left: 25px;">
  		<img src="images/user_footer.gif" border="0" style="float: left;margin-right: 5px;margin-top:8px;">
  		<div style="float: left;padding-right: 20px;">当前操作用户：${userName} | 机构：${userOrgName}</div>
  	</div>
  	<!-- <div style="width: 310px;float: right;line-height: 33px;margin-right: 15px;">
  		Copyright@2008-2012泛鹏天地科技有限公司版权所有
  	</div> -->
 </div>
 </div>
</body>
</html>
