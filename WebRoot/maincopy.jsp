<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>欢迎页面</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/mainportal.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.portal.js"></script>
<script src="${pageContext.request.contextPath}/js/showModalCenter.js" type="text/javascript"></script>
<script>
$(function(){
	$('#pp').portal({
		border:true,
		fit:true,
		onStateChange:function (){
			saveLayout();
		}
	});
	var data = $.ajax({
  		url: "${pageContext.request.contextPath}/portal_listPortal.action",
  		async: false
	}).responseText;
	initPortal(data);
});
function initPortal(jsonstr) {  
	var jonobj = eval("("+jsonstr+")");  
	var i=0;
	for(var column in jonobj) {
		for(var winPortal in jonobj[column]) {
			var portal = jonobj[column][winPortal];
			var img=portal.iconCls;
			var arr=new Array();
			arr=img.split(".");
			var p = $('<div/>').appendTo('body');
			p.panel({
				title:portal.title,
				content: createFrame(portal.content),
				closed:!portal.display,
				height:portal.height, 
				uuid:portal.uuid,
				collapsible:true,
				iconCls:arr[0],
				portalId:portal.portalId,
				userId:portal.userId
			});			
			$('#pp').portal('add', {
				panel:p,
				columnIndex:portal.columnIndex
			});
			$('#pp').portal('resize');
		}
	}
}

function createFrame(url) {
	if($.trim(url) != "") {
		if(url.indexOf('/') == 0){
			url = '${pageContext.request.contextPath}' + url;
		}else if(url.indexOf('http') == 0){
			url =  url;
		}else{
			url ='http://' + url;
		}
	}
	//"<iframe src='${pageContext.request.contextPath}/" + portal.content + "' allowtransparency='true' width='100%' height='100%' marginwidth='0' marginheight='0' align='top' scrolling='auto'  frameborder='0' style='background-color:none;'></iframe>";
	
	return '<iframe src="'+url+'" scrolling="auto" frameborder="0" allowtransparency="true" style="width:100%;height:100%;"></iframe>';
}

function saveLayout(){
	var portalLayot =  $('#pp').portal("getLayout");
	data = $.ajax({
  		url: "portal_saveLayout.action",
  		data:"portalLayot="+portalLayot,
  		type: "POST",
  		async: false
	}).responseText;
}
function getLayout1(){
	//$(this).panel("destroy");
	//获取布局。返回的是一个json类型的字符串。可以通过eval转换成json对象.也可以把此字符串存入数据库
	var portalLayot =  $('#pp').portal("getLayout");
	var re = /{,/g;
	portalLayot = portalLayot.replace(re, "{},");
}
//根据title获取不同的portal
function getPanelForTitle(){
	//alert($('#pp').portal("getPanelForTitle","Clock").panel("options").title);
	$('#pp').portal("getPanelForTitle","aaadd").panel("open");
}

$(document).ready(function(){
	$('.portal-panel').append('<div class="portal_body_b"><div class="botbg01" /><div class="botbg02" /></div>');
    $('.portal-panel .panel-body').addClass('portal_body_r').wrapInner('<div class="portal_body_l"/>');
	$('.portal_body_l').each(function(){
	  var p_w = $(this).parent().width();
	  var p_h = $(this).parent().height();
	  $(this).css({'width':p_w-10,'height':p_h});
	});
	
	$('.portal_body_c').each(function(){
	  var p_h = $(this).parent().height();
	  $(this).css({'height':p_h});
	});
	$('.panel-tool-max').click(function(){
	  var p_l   = $(this).parent().parent().next();//alert(p_l.attr('class'));
	  var new_h = p_l.height();
	  var l_l   = p_l.children();
	  var l_l2   = l_l.children();
	  l_l.css('height',new_h);//alert(p_l.height()+l_l.attr('class'));
	  l_l2.css('height',new_h);
	});

});

function btnOnclick(){
	var opt = $('#pp').portal("options");
	//alert($('.portal-panel').length);
}

/*
//为了防止出现jquery发生脚本错误，在这里通过js来给iframe加载页面
$(function(){
    $("#workIfr").attr("src","${pageContext.request.contextPath}/worktask_list.action");
    $("#todoIfr").attr("src","${pageContext.request.contextPath}/todotask_list.action");
    $("#todoIfr2").attr("src","${pageContext.request.contextPath}/todotask_list.action");
    $("#todoIfr3").attr("src","${pageContext.request.contextPath}/todotask_list.action");
    $("#todoIfr4").attr("src","${pageContext.request.contextPath}/todotask_list.action");
});
*/
function reload(){
	window.location.reload();
}
</script>
</head>

<body style="background: #ebf4fd;background: url('images/map.png') fixed center no-repeat;" class="easyui-layout">
	<div region="center" border="false">
		<div id="pp" style="position: relative;left:3px;">
			<div style="width:20%;border: solid 1px white;"></div>
			<div style="width:40%;border: solid 1px white;"></div>
			<div style="width:40%;border: solid 1px white;"></div>
		</div>
	</div>
</body>
</html>