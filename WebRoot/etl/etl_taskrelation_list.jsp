<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String model = request.getParameter("modelName");
	String processId = request.getParameter("processId");
%>
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务关系管理</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" charset=UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js" charset=UTF-8"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js" charset=UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css" >
		body {
			font-family: "微软雅黑";
			behavior:url(${pageContext.request.contextPath}/css/csshover.htc);
		}
		.font{color:red}
		.input_file{width:260px; margin-left:-260px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>
<script type="text/javascript" charset=UTF-8">

			$(function(){
				var processIdold=$("#oldprocessId").val();
				$('#etlTaskRelation').datagrid({
					title:'任务关系管理',
					width:'100%',
					height:380,
					nowrap: false,
					striped: true,
					collapsible:false,
					fitColumns:true,
					url:'taskRelation_findAllTaskRelation.action?processoldId='+processIdold,
					idField:'uuid',
					sortOrder: 'asc',
					remoteSort: false,
					scroll:true,
					columns:[[
									{field:'uuid', checkbox:true, width:20},
						 			{field:'processId',title:'任务组编号',sortable : true,width:100},  
							        {field:'taskId',title:'任务编号',sortable : true,width:100},
							        {field:'previousTaskId',title:'前置任务编号',sortable : true,width:100}
					]],
					pagination:true,
					rownumbers:false,
					onClickRow:function(rowIndex, rowData){
						clickRow = rowIndex;
					},
					toolbar:[{
						id:'btnadd',
						text:'添加',
						iconCls:'icon-add',
						handler:function(){
							var selected = $('#etlTaskRelation').datagrid('getSelections');
							var processId=$("#oldprocessId").val();
							window.location.href="${pageContext.request.contextPath}/taskRelation_toForm.action?processId="+processId;
							return false;
						}
					},'-',{
						id:'btneidt',
						text:'编辑',
						iconCls:'icon-edit',
						handler:function(){
							var taskId=[];
							var previousTaskId=[];
							var taskType=[];
							var selected = $('#etlTaskRelation').datagrid('getSelections');
							var processId=$("#oldprocessId").val();
							
								for(var i=0; i<selected.length; i++){
								    taskId.push(selected[i].taskId);
								    previousTaskId.push(selected[i].previousTaskId);
								    taskType.push(selected[i].taskType);
								}
								if(selected.length == 0) {
									$.messager.alert('系统提示','请选择要修改的任务组','warning');
									
									
									return;
								}
								if(selected.length >1) {
									$.messager.alert('系统提示','当前选择记录大于一个，请选择一个任务进行修改','warning');
									
									return;
								}else{
										window.location.href="${pageContext.request.contextPath}/taskRelation_to_Editor.action?uuid="+selected[0].uuid+"&processId="+processId+"&taskId="+taskId+"&previousTaskId="+previousTaskId+"&taskType="+taskType;
										return false;
								}
						}
					},'-',{
						id:'btnremove',
						text:'删除',
						iconCls:'icon-remove',
						handler:function(){
						    var uuids = []; 
						    var processId=[];
						    var taskId=[];
						    var preTask=[];
							var selected = $('#etlTaskRelation').datagrid('getSelections');
							for(var i=0; i<selected.length; i++){
							    uuids.push(selected[i].uuid);
							    processId.push(selected[i].processId);
							    taskId.push(selected[i].taskId);
							    preTask.push(selected[i].previousTaskId);
							}
							//alert(preTask);
							if(selected.length == 0) {
								$.messager.alert('系统提示','请选择要删除的记录','warning');
								
								
								return;
							}else{
								window.location.href="${pageContext.request.contextPath}/taskRelation_remove.action?uuids="+uuids+"&processId="+processId+"&taskId="+taskId+"&preTask="+preTask;
								return false;
								
							}
						}
					},'-',{
						id:'btnsysmrg',
						text:'任务关系校验',
						iconCls:'icon-sysmrg',
						handler:function(){
								$.post( 
										"${pageContext.request.contextPath}/relationcheck_TaskCheck.action",
									     {
										 	processId:$('#oldprocessId').val()
										 },function (data){
											 var result=eval("(" + data + ")");
 					                        $.messager.alert('系统提示',result.message,'warning');
								});
								
						}
					}
					]
				});
				var p = $('#etlTaskRelation').datagrid('getPager');
				$(p).pagination({
					onBeforeRefresh:function(){
						
					}
				});
			
				//查询提交
				$('#filter_submit').click(function(){
					var jsonData = {
							processName:$('#processName').val(),
							newpage:1
							};
					$('#etlProcess').datagrid('options').queryParams=jsonData;
					$('#etlProcess').datagrid('load');
				});
			
				//重置查询信息
				$('#filter_reset').click(function(){
					//$('#batchName').val('');
					$('#processName').val('');
					$('#etlProcess').datagrid('options').queryParams="";
				});
			
				var pager = $('#etlTaskRelation').datagrid('getPager');
				$(pager).pagination({
					pageSize:10,
					pageList:[5,10,15,20],
					beforePageText:"第",
					afterPageText:"页  共{pages}页",
					displayMsg:"当前显示 {from} - {to} 条记录   共 {total} 条记录"
				});
			
				$('select').combobox({
					panelHeight:'100%'
				});
				//comboxselect();
			});//out
			

			function comboxselect(){
				$('#processId').combobox({   
				    url:'taskRelation_processCombobox.action',
				    textField:'processName', 
				    valueField:'processId'
				}); 
				$('#taskId').combobox({   
				    url:'taskRelation_taskCombobox.action',
				    textField:'taskName', 
				    valueField:'taskId'
				}); 
				
				$('#previousTaskId').combobox({   
				    url:'taskRelation_taskCombobox.action',
				    textField:'taskName', 
				    valueField:'taskId'
				}); 
			}

			function clearFun(){
				$('#processId').combobox('setValue','');
				$('#taskId').combobox('setValue','');
				$('#previousTaskId').combobox('setValue','');
				datagrid.datagrid('load', {});
			}

			function searchFun(){
				//var processoldId=$("#processoldId").val("");
				var processIdv=$("#processId").val();
				var taskIdv=$("#taskId").val();
				var previousTaskIdv=$("#previousTaskId").val();
			   $('#etlTaskRelation').datagrid('load',{
				   processId:processIdv,
				   taskId:taskIdv,
				   previousTaskId:previousTaskIdv
				   
				});    

			}
			function getTemplate(){
				$('#formSearch').form('submit',{
					url:"${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"TaskRelation"
				});
			}

			function getTaskByPage(){
				var pageNo = $('#deptGrid').datagrid('getPager');
				var pageSize = $(pager).pagination("options");

				//var pageNo = $('#etlTask').datagrid("pageNumber");
				//var pageSize = $('#etlTask').datagrid("pageSize");
				//alert(pageNo+"="+pageSize);
				window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"TaskRelation&pageSize="+pageSize+"&pageNo="+pageNo;
				return false;
			}

			function getTaskByData(){
				$('#formSearch').form('submit',{
					url:"${pageContext.request.contextPath}/exportExcel.action?modelName="+"TaskRelation"
				});
			}
			function inExcel(){
				 locking();
					 var updateUpdata = $('#upload').val();
					 var processId = $('#oldprocessId').val();
					// alert(updateUpdata);
					 if(updateUpdata!=null&&updateUpdata!=""){
						   $.ajaxFileUpload({  
					        	 url: "inputExcel_inputExcelTaskRelation.action?modelName="+"TaskRelation&processId="+processId,
					             secureuri:false,  
					             fileElementId: 'upload',//文件选择框的id属性  
					             dataType:'json',//服务器返回的格式，可以是json  
					             error: function(request) {      // 设置表单提交出错
					                 alert("导入失败！！");
					             },
					             success: function(data) { // 设置表单提交完成使用方法
					            	var zNodes = eval(data); 
					            	if(zNodes.length>0){
					            		var errorInfo ="";
					            		//alert(zNodes);
					                	for(var i=0;i<zNodes.length;i++){
					                		//alert(zNodes[i]);
					                		errorInfo+=zNodes[i]+"\r\r";
					                    }
					                    alert(errorInfo);     
					                }  else{
					                	  alert("导入成功！");
					                  }
					            	unlock();                  
					             }
					         });
						 }else{
							alert("请选择导入文件！！！");
						}
			        
			}
			function locking(){     
			        var sWidth,sHeight;  
			       // var imgPath = slow ? "img/waiting_slow.gif" : "img/waiting_fast.gif";  
			        sWidth  = top.document.body.clientWidth;  
			        sHeight = top.document.body.clientHeight;  
			        var bgObj=top.document.createElement("div");    
			        bgObj.setAttribute("id","divLock");  
			        bgObj.style.position="absolute";  
			        bgObj.style.top="0";  
			        bgObj.style.background="#cccccc";  
			        bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75";  
			        bgObj.style.opacity="0.6";  
			        bgObj.style.left="0";  
			        bgObj.style.width=sWidth + "px";  
			        bgObj.style.height=sHeight + "px";  
			        bgObj.style.zIndex = "100";  
			        top.document.body.appendChild(bgObj);  
			        var html = "<table border=\"0\" width=\""+sWidth+"\" height=\""+sHeight+"\"><tr><td valign=\"middle\" align=\"center\">请稍候正在导入</td></tr></table>";  
			        bgObj.innerHTML = html;  
			        // 解锁  
			        bgObj.onclick = function(){  
			             unlock(); // 应该等完成后再解锁  
			        }
				  }  
			function unlock(){  
			    var divLock = top.document.getElementById("divLock");  
			    if(divLock == null) return;  
			    top.document.body.removeChild(divLock);  
			}
			
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post" style="padding: 20px 0 20px 30px;">
		<INPUT name="pageNo" id="pageNo" type="hidden" value="${param.pageNo}"> 
		<input id="processId" name="processId" type="hidden" class="input_eq" style="width:100px"/> 
		<input type="hidden" name="oldprocessId" id="oldprocessId" value="${processId}"/>
		
		<table cellSpacing="0" cellpadding="0" border="0">
		
			<tr>
				<td height="40px">任务：</td>
				<td height="40px">
					<input id="taskId" name="taskId" value="" class="input_eq" style="width:100px"/> 
				</td>
				<td height="40px">前置任务：</td>
				<td height="40px">
					<input id="previousTaskId" name="previousTaskId" value="" class="input_eq" style="width:100px"/> 
				</td>
				<td>
					<input id="filter_submit" class="inputd" onclick="searchFun()" type="button" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset" onclick="clearFun();" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	<div class="gridDiv">
		<table id="etlTaskRelation" name="etlTaskRelation"></table>
		<br>
		<form method="post" enctype="multipart/form-data" id="excel" action="inputExcel_inputExcelTask.action?modelName=Task" style="">
		
			<input style="border: 1px #c0c0c0 solid;height: 19px;" type="text" id="txt" name="txt" />
			<input type="button" class="inputd" value="浏览" />
			<input class="input_file" id="upload" name="upload" type="file" onchange="txt.value=this.value" />
			<input type="button" class="importdate" value="数据导入" id="inputExcel" name="inputExcel" onclick="inExcel()"> 
			<input type="button" class="downloadtemplate" value="模板下载" id="loadTemplate" name="loadTemplate" onclick="getTemplate()"> 
			<!--<input type="button" class="pagedataexport" value="页面数据导出" id="exportTaskByPage" name="exportTaskByPage" onclick="getTaskByPage()">   -->
		    <input type="button" class="export2" value="服务器数据导出" id="exportTaskByData" name="exportTaskByData" onclick="getTaskByData()"> 
	    </form>
	</div>
</body>
</html>

