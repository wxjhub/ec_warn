<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String organStr=request.getParameter("organStr");
%>
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>调度日志历史数据</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript" charset=UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js" charset=UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js" charset=UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js" charset=UTF-8"></script>
				<style type="text/css">
				.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
				
				#operationLogForm{
					margin:0px;
					padding:0px;
					border-top:0px;
					overflow:hidden;
					border:1px solid #c0c0c0;
					border-top-style:none;
					background:#fff url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
				}
				
				.tabs-panels{
					margin:0px;
					padding:0px;
					border-top:0px;
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
				</style>
				<script type="text/javascript">
							function goBack(){
								window.location.href = "${pageContext.request.contextPath}/etl/scheduler_log_list.jsp";
							}		
				</script>
</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><font class="blue">调度日志历史数据</font></div>
			<FORM name="operationLogForm" id="operationLogForm" method="post" style="padding: 25px 0 0 25px; height: 315px;">
				<div id="myTab1_Content0" >
					<table cellSpacing="0" cellpadding="0" border="0">
						<tr>
							<td width="80px" height="32px"> 批次号：</td>
							<td width="260px" height="32px">
								<input type="text" name="batchId" class="easyui-validatebox input_eq2"  id="batchId" value="${taskHisDetailInfo.batchId}" readonly="readonly"/>
							</td>
							<td width="80px" height="32px" style="padding-left: 20px">任务组号：</td>
							<td width="260px" height="32px">
								<input type="text" name="processId" class="easyui-validatebox input_eq2" id="processId" value="${taskHisDetailInfo.processId}" readonly="readonly"/>
							</td>
							
							<td width="80px" height="32px" style="padding-left: 20px">任务号：</td>
							<td width="260px" height="32px">
								<input type="text" name="taskId" class="easyui-validatebox input_eq2" id="taskId" value="${taskHisDetailInfo.taskId}" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td width="80px" height="32px">启动时间：</td>
							<td width="260px" height="32px">
								<input  name="startTime"  id="startTime" value="${taskHisDetailInfo.startTime}" readonly="readonly"/>
							</td>
							<td width="80px" height="32px">结束时间：</td>
							<td width="260px" height="32px">
								<input type="text" name="endTime" id="endTime" value="${taskHisDetailInfo.endTime}" readonly="readonly"/>
							</td>
							<td width="80px" height="32px">数据日期：</td>
							<td width="260px" height="32px">
								<input type="text" name="dataDate" id="dataDate"  value="${taskHisDetailInfo.dataDate}" readonly="readonly"/>
							</td>
						</tr>
						<tr>
							<td width="80px" height="32px">运行时长：</td>
							<td width="260px" height="32px">
								<input type="text" name="runTime" id="runTime" value="${taskHisDetailInfo.runTime}" readonly="readonly"/>
							</td>
							<td width="80px" height="32px">运行标示：</td>
							<td width="260px" height="32px" >
								<c:if test="${taskHisDetailInfo.runFlag == '2'}">
										<input type="text" name="runFlag" class="easyui-validatebox input_eq2" id="runFlag" value="完成" readonly="readonly"/>
								</c:if>
								<c:if test="${taskHisDetailInfo.runFlag == '-1'}">
										<input type="text" name="runFlag" class="easyui-validatebox input_eq2" id="runFlag" value="错误" readonly="readonly"/>
								</c:if>
							</td>
							<td width="80px" height="32px">运行次数：</td>
							<td width="260px" height="32px">
								<input type="text" name="count" class="easyui-validatebox input_eq2" id="count" value="${taskHisDetailInfo.count}" readonly="readonly"/>
							</td>
						</tr>
						<tr>
						    <td width="80px" height="32px">创建日期：</td>
							<td width="260px" height="32px">
								<input type="text" name="createDate" id="createDate" value="${taskHisDetailInfo.createDate}" readonly="readonly"/>
							</td> 
							<td width="80px" height="32px">错误原因：</td>
							<td width="260px" height="32px">
								<select name="errorMessage" class="input" style="width:150px;height:100px;" id="errorMessage" value="${taskHisDetailInfo.errorMessage}" multiple="multiple"/>
							</td> 
							
						
							
						</tr>
						
					</table>
				</div>
				<input class="zh_btnbg2" type="button"  value="返回" onclick="goBack();" />
			</FORM>
</div>
			
</body>
</html>
﻿
