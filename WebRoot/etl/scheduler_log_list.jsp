<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>调度日志</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css" type="text/css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css" type="text/css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js" charset="utf-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js" charset="utf-8"></script>
<style type="text/css" >
		body {
			font-family: "微软雅黑";
			behavior:url(${pageContext.request.contextPath}/css/csshover.htc);
		}
</style>
<script type="text/javascript" charset="utf-8">

			$(function(){
				var lastIndex;
				$('#schedulerLogGrid').datagrid({
					title:'调度日志列表',
					iconCls:'icon-computer',
					width:'100%',
					height:355,
					nowrap:false,						//是否换行
					striped:true,						//是否隔行换色
					collapsible:false,					//是否增加收起表格组件的按钮
					url:'taskHisDetailInfoAction_findAllTaskHisDetailInfo.action',//请求数据的url
					pagination:true,
					fitColumns:true,
					pageSize:15,
					columns:[[
						{field:'batchId', title:"批次编号",sortable : true,width:100 },
						{field:'processId', title:"任务组编号",sortable : true, width:100},
						{field:'taskId', title:"任务编号",sortable : true, width:100},
						{field:'dataDate', title:"数据日期",sortable : true, width:100,
								formatter:function(value){
						    			if(value != null) {
									  		return formatDate(value);
						    			}
						    		}
						},
						{field:'runFlag', title:"运行标志",sortable : true, width:100,
							formatter:function(value) {
						    			if(value == "2"){
						    				return "已完成";
							    		}else if(value == "-1"){
						    				return "出错";
							    		}
								}
							},
						{field:'count', title:"执行次数",sortable : true, width:100},
						{field:'errorMessage', title:"错误信息",sortable : true, width:100},
						{field:'url', title:"查看详细信息",sortable : true, width:100,align:'center',
							formatter:function(value){
									return value;    
						    	}
							}
					]]
				});
			});
				//查询batchId processId taskId  dataDate  runFlag count
				function searchFun(){
					var batchId=$('#batchId').val();
					var processId=$('#processId').val();
					var taskId=$('#taskId').val();
					var dataDate=$('#dataDate').datebox('getValue');
					var runFlag=$('#runFlag').combobox('getValue');
					$('#schedulerLogGrid').datagrid('reload', {
						batchId:batchId,
						processId:processId,
						taskId:taskId,
						dataDate:dataDate,
						runFlag:runFlag
					});    
				 } 

				 
				function clearFun(){
					$("#batchId").val("");
					$("#processId").val("");
					$("#taskId").val("");
					$('#dataDate').datebox('setValue','');
					$('#runFlag').combobox('setValue','');			
					
				 }

				$(function(){
				   $('select').combobox({
				 		panelHeight:'100%'
				   });
			    });
			    
				var pager = $('#schedulerLogGrid').datagrid('getPager');
				$(pager).pagination({
					pageSize:10,
					pageList:[5,10,15],
					beforePageText:"第",
					afterPageText:"页  共{pages}页",
					displayMsg:"当前显示 {from} - {to} 条记录   共 {total} 条记录"
				});


				//datebox format 方法
					function formatDate(value) {
										var m = value.month + 1;
										var d = value.date;
										var y = value.year + 1900;
										var h = value.hours;
										var min = value.minutes;
										var s = value.seconds;
										if (m < 10)
											m = '0' + m;
										if (d < 10)
											d = '0' + d;
										//return y + '-' + m + '-' + d + ' ' + h + ':' + min + ':' + s;
										return y + '-' + m + '-' + d;
									}

				function checkRefresh(){
					if(document.getElementById('chk_refresh').checked){
						getRefresh();
						startRefresh();
						}
					else
						clearInterval(begin);
				}
				function startRefresh(){
					
				    begin = setInterval("getRefresh()",5000);
				}
				function getRefresh(){
					$('#schedulerLogGrid').datagrid('reload', {}); 
				}
				function stopRefresh(){
					clearInterval(begin);
				}
</script>
</head>
<body>
			<div class="majorword" style="padding-left: 30px">
				<FORM name="formSearch" id="formSearch" method="post">
							<INPUT name="pageNo" type="hidden" value="${param.pageNo}"> 
							<table cellSpacing="0" cellpadding="0" border="0">
									    <tr> 
											      <td height="40px" width="60px">批次编号:</td>
											      <td height="40px"><input class="input_eq" type="text" id="batchId" name="batchId" style="width:65px;height:20px"/></td>
											      <td height="40px" width="60px">任务组编号:</td>
											      <td height="40px"><input class="input_eq" type="text" id="processId" name="processId" style="width:65px;height:20px"/></td>
											      <td height="40px" width="60px">任务编号:</td>
											      <td height="40px"><input class="input_eq" type="text" id="taskId" name="taskId" style="width:65px;height:20px"/></td>
											      <td height="40px" width="60px">数据日期:</td>
											      <td height="40px"><input class="easyui-datebox" id="dataDate" name="dataDate" style="width:130px;padding:0px"/></td>
											      <td height="40px" width="60px">运行标志:</td>
											      <td height="40px">
											         <select name="runFlag" class="easyui-combobox" id="runFlag" style="width: 80px;">
												       <rmp:option dictId="etl.runflag" prompt=""></rmp:option>
											         </select>
											      </td>
											      
										      	  <td>
													<input id="filter_submit" class="inputd" onclick="searchFun();" type="button" value="查 询"/>
													<input id="filter_reset" class="inputd" type="button" onclick="clearFun();" value="重 置"/>
													
												  </td>
									    </tr>
							</table>
				</FORM>
			</div>
			
			<div class="gridDiv">
			   <table id="schedulerLogGrid" ></table>
			</div>
</body>
</html>