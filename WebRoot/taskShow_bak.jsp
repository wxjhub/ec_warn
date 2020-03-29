<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setDateHeader("Expires", 0); //防止代理服务器缓存页面
	String ckVoList = request.getParameter("detail");  
%>
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
   
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务提示</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>

<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
<script type="text/javascript">


	
function closePage(){
	window.close();
 }	 

function invalidData(){

/*
	var content = createFrame("${pageContext.request.contextPath}/jsp/DataCounterCheck/invalidData.jsp");
	$('#tabs').tabs('add',{
		title:"aaaa",
		content:content,
		closable:true
	});
	*/

	//window.location.href="${pageContext.request.contextPath}/jsp/DataCounterCheck/invalidData.jsp";
	showModalDialog('${pageContext.request.contextPath}/jsp/DataCounterCheck/glData.jsp','总分检核结果','dialogWidth:1600px;dialogHeight:500px;center:yes;help:no;resizable:yes');
}
//数据库连接数
function dataline(){
	//window.location.href="${pageContext.request.contextPath}/checkPara_list.action";
	showModalDialog('${pageContext.request.contextPath}/mon/mon_dbcontimeswarn_list.jsp','数据库连接数','dialogWidth:1600px;dialogHeight:500px;center:yes;help:no;resizable:yes');
}
//批次运行情况
function schedulemodel(){
	//window.location.href="${pageContext.request.contextPath}/jsp/businessParameter/ruleQueryItem.jsp";
	showModalDialog('${pageContext.request.contextPath}/jsp/businessParameter/ruleQueryItem.jsp','批次运行情况','dialogWidth:1600px;dialogHeight:500px;center:yes;help:no;resizable:yes');

}
//应用程序
function applysoft(){
	//window.open("${pageContext.request.contextPath}/mon/mon_applyprosoft_list.jsp","曲线确认", 'height=400px, width=1600px,toolbar=no,scrollbars=yes,center=yes, resizable=yes,location=no');
	showModalDialog('${pageContext.request.contextPath}/mon/mon_applyprosoft_list.jsp','应用程序','dialogWidth:1000px;dialogHeight:400px;center:yes;help:no;resizable:no;status:no');
}
//表空间/vpframe_etlvp2/WebRoot/mon/mon_tablespace_list.jsp
function tablespace(){
	//window.open("${pageContext.request.contextPath}/mon/mon_applyprosoft_list.jsp","曲线确认", 'height=400px, width=1600px,toolbar=no,scrollbars=yes,center=yes, resizable=yes,location=no');
	showModalDialog('${pageContext.request.contextPath}/mon/mon_tablespace_list.jsp','表空间','dialogWidth:1000px;dialogHeight:400px;center:yes;help:no;resizable:no;status:no');
}
//文件传输
function filetran(){
	//window.open("${pageContext.request.contextPath}/mon/mon_applyprosoft_list.jsp","曲线确认", 'height=400px, width=1600px,toolbar=no,scrollbars=yes,center=yes, resizable=yes,location=no');
	showModalDialog('${pageContext.request.contextPath}/mon/mon_applyprosoft_list.jsp','文件传输','dialogWidth:1000px;dialogHeight:400px;center:yes;help:no;resizable:no;status:no');
}
function authData(){
	var str = showModalDialog('${pageContext.request.contextPath}/sec/sec_remoteAuth_list.jsp','远程授权','dialogWidth:1600px;dialogHeight:500px;center:yes;help:no;resizable:yes');
	if(str!=undefined){
//		window.location.href = "${pageContext.request.contextPath}/taskShow_list.action";

		var text = '授权管理：共有<font style="color: red;">'+str+'</font>条待授权';
		$("#authText").html(text);
	}
}

function curveStatus(obj){
	//false=0 已经确认
	if(obj==false){
		$("#curveConfirm").attr("checked","checked");
	}else if(obj==true){
		$("#curveConfirmNO").attr("checked","checked");
	}
}

function queryIn(obj){
	if(obj=="1"){
		document.getElementById("queryOne").style.color="black";
	}else if(obj=="2"){
		document.getElementById("queryTwo").style.color="black";
	}else if(obj=="3"){
		document.getElementById("queryThree").style.color="black";
	}else if(obj=="4"){
		document.getElementById("queryFour").style.color="black";
	}else if(obj=="5"){
		document.getElementById("queryFive").style.color="black";
	}
	
}

function queryOut(obj){
	if(obj=="1"){
		document.getElementById("queryOne").style.color="blue";
	}else if(obj=="2"){
		document.getElementById("queryTwo").style.color="blue";
	}else if(obj=="3"){
		document.getElementById("queryThree").style.color="blue";
	}else if(obj=="4"){
		document.getElementById("queryFour").style.color="blue";
	}else if(obj=="4"){
		document.getElementById("queryFive").style.color="blue";
	}else if(obj=="5"){
		document.getElementById("queryFive").style.color="blue";
	}
}

$(document).ready(function(){
	$('#p').panel({   

		   width:1160,   
			height:500,

		   title: '系统状态'
	}); 
	$.ajax({
		type: 'post',
		dataType : "Json",
		url: "${pageContext.request.contextPath}/applyprosoft_runStatus.action",
		success:function(data){
			debugger;
			var a = eval("("+data+")");
			if(a.mess!=0){
				$('#applysoftstatus').html("<span style='color:#0F0;'>正常</span>");
			}else{
				$('#applysoftstatus').html("<span style='color:red;'>异常</span>");
			}
			
		}
	});
	$.ajax({
		type: 'post',
		dataType : "Json",
		url: "${pageContext.request.contextPath}/dbConTimesWarn_databaseNum.action",
		success:function(data){
			debugger;
			var a = eval("("+data+")");
				$('#datalinenum').html(a.mess);
				
		}
	});
	$.ajax({
		type: 'post',
		dataType : "Json",
		url: "${pageContext.request.contextPath}/tablespace_tablenum.action",
		success:function(data){
			debugger;
			var a = eval("("+data+")");
			$('#ftptotalnum').html(a.ftptotalnum+"GB");
			$('#ftpremainnum').html(a.ftpremainnum+"GB");
			$('#cogtotalnum').html(a.cogtotalnum+"GB");
			$('#cogremainnum').html(a.cogremainnum+"GB");
		}
	});
});
function schedulestatus(){
	$.ajax({
		type: 'post',
		dataType : "Json",
		url: "${pageContext.request.contextPath}/schedulewarn_scheduleRunStatus.action",
		success:function(data){
			debugger;
			var a = eval("("+data+")");
			$('#schedulerunstatus').html(a.mess);
		}
	});
}
</script>
<style type="text/css">
	a:link{color:blue;}/*未访问链接*/
	a:visited{color:#F00;}/*已访问链接*/
	a:hover{color:#0F0;}/*鼠标在链接上*/
	a{text-decoration: none}
</style>
</head>
<body onload="schedulestatus()">
	<div style=" position: relative; ">
		<div id="p" class="easyui-panel"  style="padding:10px;background:#fafafa;" collapsible="true" >  
			<div style="margin-left: 20px">
				<!--<table >
					<tr >
						<td id="memoryspace">
							应用程序监控:<br/>20.0.4.12内存情况:参数;&nbsp;&nbsp;20.0.4.12内存情况:参数
						</td>
					</tr>
				</table>
				<br/>--><br/>
				<table  style="font-size: 13px;">
				<B>表空间：</B>
					<tr>
						<td>RPMDB实例：</td>
						<td id="tablespaceftp">
							总空间：<span id="ftptotalnum"></span>;
							剩余空间：<span id="ftpremainnum"></span>&nbsp;&nbsp;
						</td>
					</tr>
					<tr>
						<td>DMDB实例：</td>
						<td id="tablespacecog">
							总空间：<span id="cogtotalnum"></span>;
							剩余空间：<span id="cogremainnum" ></span>&nbsp;&nbsp;
							<a href="#" onclick="tablespace()">查看</a>
						</td>
					</tr>
					
				</table>
				<br/>
				<table>
				<B>应用进程：</B>
					<tr style="font-size: 13px;">
						<td id="applysoft">
							ETL进程状态：<span id="applysoftstatus"></span>&nbsp;&nbsp;
							<a href="#" onclick="applysoft()">查看</a>
						</td>
					</tr>
				</table>
				<br/>
				
				<!--<table>
					<tr>
						<td id="filetran">
							文件传输：<span style="color:red">状态</span>&nbsp;&nbsp;
							<a href="#" ONCLICK="filetran()">查看</a>
						</td>
					</tr>
				</table>
				<br/>
				--><table>
					<tr style="font-size: 13px;">
						<td id="dataline">
							DATABASE连接数：<span id="datalinenum">数量</span>&nbsp;&nbsp;<a href="#" onclick="dataline()">查看</a>
						</td>
					</tr>
				</table>
				<br/>
				<table>
					<tr>
						<td>
						当前批次运行状态：
						</td>
						<td>
							<span id="schedulerunstatus" style="font-size: 13px;"></span>
						</td>
					</tr>
					<tr>
						<td></td>
				</table>
			</div>
		</div>
	</div>
				 
				<!--<br><br><br>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				 <a  onclick="closePage();" href="#"><font style="font-size: 13px;color: red;">关闭</font></a>-->
</body>
</html>

