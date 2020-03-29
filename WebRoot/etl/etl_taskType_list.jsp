<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务分类管理</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
}
.font{color:red}
.input_file{width:260px; margin-left:-260px;height:21px; filter:alpha(opacity=0); opacity:0;}
</style>
<script type="text/javascript">
//条件查询、分页查询
function searchUser(){
    var taskTypeName = $('#taskTypeName')[0].value;
    $('#etlTaskType').datagrid('reload', {
    	taskTypeName:taskTypeName
 
	});    
 }
function checkAndDel(x){
	$.post( 
		"${pageContext.request.contextPath}/taskType_check.action?uuids="+x
		,function (data){
			 var result=eval("(" + data + ")");
			 if(result.unique==0)
			 {

				 $.messager.alert('warning','存在关联任务，不能删除，请修改任务分类后重试！');
			 }	
			 else{
				 window.location.href="${pageContext.request.contextPath}/taskType_remove.action?uuids="+x;	
			 }	
		}		 					 
	);
}
$(function(){
	$('#etlTaskType').datagrid({
		title:'任务分类管理',
		width:'100%',
		height:380,
		nowrap: false,
		striped: true,
		collapsible:false,
		url:'taskType_findAllTaskTypes.action',
		idField:'taskTypeId',					//标识字段
		sortName: 'createTime',
		sortOrder: 'asc',
		remoteSort: false,
		fitColumns:true,
		scroll:true,
		columns:[[
			{field:'taskTypeId', checkbox:true, width:160},
			{field:'taskTypeName',title:'任务分类名称', width:180},
			{field:'taskTypeDesc',title:'任务分类描述',width:180},
			{field:'createTime',title:'任务分类创建时间',width:240,
				formatter:function(value) {
    			if(value != null) {
			  		return formatDate(value);
    			}
			}}
		]],
		pagination:true,
		rownumbers:false,
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		},
		toolbar:[{
			id:'btnadd',
			text:'添加',
			iconCls:'icon-add',
			handler:function(){
				//$('#btnsave').linkbutton('enable');
				window.location.href="${pageContext.request.contextPath}/taskType_toForm.action";
			}
		},{
			id:'btneidt',
			text:'编辑',
			iconCls:'icon-edit',
			handler:function(){
				var selected = $('#etlTaskType').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要修改的用户','warning');
					return;
				}
				if(selected.length >1) {
					$.messager.alert('系统提示','当前选择的条目大于一个，请选择一个任务进行修改','warning');
					return;
				}else{
					 window.location.href="${pageContext.request.contextPath}/taskType_toForm.action?taskTypeId="+selected[0].taskTypeId;
				}
			}
		},{
			id:'btnremove',
			text:'删除',
			iconCls:'icon-remove',
			handler:function(){
			    var uuids = [];
				var selected = $('#etlTaskType').datagrid('getSelections');
				for(var i=0; i<selected.length; i++){
				    uuids.push(selected[i].taskTypeId);
				}
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要删除的用户','warning');
					return;
				}else{
					checkAndDel(uuids);
				}
			}
		}
		]
	});
	var p = $('#etlTaskType').datagrid('getPager');
	$(p).pagination({
		onBeforeRefresh:function(){
			//alert('before refresh');
		}
	});

	//查询提交
	$('#filter_submit').click(function(){
		var jsonData = {
				taskTypeName:$('#taskTypeName').val(),
				newpage:1,page:1
				};
		$('#etlTaskType').datagrid('options').queryParams=jsonData;
		$('#etlTaskType').datagrid('load');
	});

	//重置查询信息
	$('#filter_reset').click(function(){
		$('#taskTypeName').val('');
		$('#etlTaskType').datagrid('options').queryParams="";
	});

	var pager = $('#etlTaskType').datagrid('getPager');
	$(pager).pagination({
		pageSize:10,
		pageList:[5,10,15],
		beforePageText:"第",
		afterPageText:"页  共{pages}页",
		displayMsg:"当前显示 {from} - {to} 条记录   共 {total} 条记录"
	});

	$('select').combobox({
		panelHeight:'100%'
	});
});

//datebox format 方法
function formatDate(value) {
	var m = value.month + 1;
	var d = value.date;
	var y = value.year + 1900;
	var h = value.hours;
	var min = value.minutes;
	var s = value.seconds;
	if(m<10) m = '0' + m;
	if(d<10) d = '0' + d;
	if(h<10) h = '0' + h;
	if(min<10) min = '0' + min;
	if(s<10) s = '0' + s;
	return y + '-' + m + '-' + d  + ' '+ h+':'+min+':'+s;
}

function getTemplate(){
	window.location.href="${pageContext.request.contextPath}/downloadTemplate.action?modelName="+"TaskType";
}

function getTaskByPage(){
	var pageNo = $('#deptGrid').datagrid('getPager');
	var pageSize = $(pager).pagination("options");

	//var pageNo = $('#etlTask').datagrid("pageNumber");
	//var pageSize = $('#etlTask').datagrid("pageSize");
	//alert(pageNo+"="+pageSize);
	window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"TaskType&pageSize="+pageSize+"&pageNo="+pageNo;
}

function getTaskByData(){
	window.location.href="${pageContext.request.contextPath}/exportExcel.action?modelName="+"TaskType";
}

function inExcel(){
	 locking();
		 var updateUpdata = $('#upload').val();
		// alert(updateUpdata);
		 if(updateUpdata!=null&&updateUpdata!=""){
			   $.ajaxFileUpload({  
		        	 url: "inputExcel_inputExcelTaskType.action?modelName="+"TaskType",
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
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">任务分类名称：</td>
				<td height="40px">
					<input type="text" name="taskTypeName" id="taskTypeName" class="input_eq" style="width:100px"/>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查 询"/>
					<input id="filter_reset" class="inputd" type="reset" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	<div class="gridDiv">
		<table id="etlTaskType" name="etlTaskType"></table>
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

