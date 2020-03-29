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
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
<style type="text/css">
#formSearch .panel-body{
	border-bottom-style: none;
}
</style>
<script type="text/javascript">
	function getJsonQueryCondition(){
		return {
			orgSeq: $("#orgSeq").val(),
			orgCode: $("#orgCode").val(),
			orgName: $("#orgName").val(),
			status: $("#status").combobox("getValue")
		};
	}
	
	function searchOrgan(){
		$('#organGrid').datagrid("clearSelections");
		$('#organGrid').datagrid({
			url:'${pageContext.request.contextPath}/organ_asyFindOrgans.action',
			queryParams: getJsonQueryCondition()
		});    
	}

	function formReset(){
		$('#orgCode').val('');
		$('#orgName').val('');
		$('#status').combobox('setValue','');
		$('#orgSeq').val('');
		$('#organGrid').datagrid('options').queryParams="";
	}

//网格初始化
$(function(){
	$('#gridDiv').height($("html")[0].clientHeight - $("#formSearch").height() - 50);
	$('#organGrid').datagrid({
		width:'100%',
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'${param.url}',//'organ_asyFindOrgans.action',	//请求数据的url
		sortOrder:'desc',				//采用降序排序
		idField:'orgId',					//标识字段
		fitColumns:true,	//自动扩大或缩小列的尺寸以适应表格的宽度并且防止水平滚动。
		pagination:true,
		queryParams:getJsonQueryCondition(),
		columns:[[
			{field:'orgId', checkbox:true, width:20},
			{field:'leafFlag',hidden:true,width:40},
			{field:'childOrgans',hidden:true,width:40},
			{field:'orgCode', title:"机构代码", align:'center', width:150},
			{field:'orgName', title:"机构名称", align:'center', width:220},
			{field:'parentOrgan',title:'上级机构',align:'center',width:220,
                 	formatter:function(value, rowData, rowIndex){
                 	     if(value!=null){
                 	    	return value.orgName;
                     	 }
                        return null;
                 	}
             	},
			{field:'status', title:'机构状态', align:'center', width:200,
				formatter:function(value, rowData, rowIndex) {
					if(value == 1) {
						return '启用';
					}    
					if(value == 0) {
						return '<span style="color:red;">撤销</span>';
					}
				}
			}
		]],
		toolbar:[{							//工具栏
			id:'btnadd',
			text:'增加',
			iconCls:'icon-add',
			handler:function(){				//工具栏按所触发的函
				$("#formSearch")[0].action = "${pageContext.request.contextPath}/organ_toForm.action";
				$("#formSearch")[0].submit();
			}
		},{
			id:'btneidt',
			text:'编辑',
			iconCls:'icon-edit',
			handler:function(){
				var selected = $('#organGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要修改的机构！','warning');
					return;
				}
				if(selected.length >1) {
					$.messager.alert('系统提示','只能选择一个机构进行编辑！','warning');
					return;
				}

				$("#formSearch")[0].action = "${pageContext.request.contextPath}/organ_toForm.action?orgId="+selected[0].orgId;
				$("#formSearch")[0].submit();
			}
		},{
			id:'btncancel',
			text:'启用',
			iconCls:'icon-use',
			handler:function() {
				//判断是否已启用
				var selected = $('#organGrid').datagrid('getSelections');
				var ids = "";
				if(selected.length>0){
					for(var i=0; i<selected.length; i++) {
						if(selected[i].status==1){
							$.messager.alert('系统提示','选中的机构有启用项，请重新选择','warning');
							return false;
						}else{
							ids += selected[i].orgId+",";
						}
					}
					$.messager.confirm('系统提示','确定要启用所选机构吗?',function(btn){
						if(btn) {
					        $.ajax({
	                        	dataType:'text',
								url:'${pageContext.request.contextPath}/organ_startStatus.action',
								data:{
								      'orgIds':ids 
								},
								type:'post',
								success:function(data){
									var result=$.parseJSON(data);
									if(result[0].msg!=''){
										$.messager.alert('系统提示',result[0].msg,'warning');
									}else{
										$.messager.alert('系统提示','启用成功','info');
									}
									$('#organGrid').datagrid('reload');
									$('#organGrid').datagrid("clearSelections");
	    					    }
	                        });
						}
					});
				}else{
					$.messager.alert('系统提示','请选择要启用的机构','warning');
				}
			}
			
		}, {
			id:'btnZhuXiao',
			text:'撤销',
			iconCls:'icon-remove',
			handler:function() {
				var selected = $('#organGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要撤销的机构！','warning');
					return;
				}
				var orgId = '';
				var orgIds = '';
				var organIds = '';
				for(var i=0; i<selected.length; i++){
					orgId += selected[i].orgId + ',';
				}
				for(var i=0; i<selected.length; i++){
					if(selected[i].status==0){
						$.messager.alert('系统提示','您选择的机构下已经撤销，请重新选择！','warning');
						return;
					}
				}
				$.ajax({
                   	dataType:'text',
					url:'${pageContext.request.contextPath}/organ_isCancelStatus.action',
					data:{
					      'orgId':orgId 
					},
					type:'post',
					success:function(data){
						var result= $.parseJSON(data);//json数组
						if(result[0].msg.indexOf('用户')>-1){
							$.messager.alert('系统提示',result[0].msg,'warning');
							return ;
						}else if(result[0].msg!=''){
							$.messager.confirm('系统提示',result[0].msg,function(btn){
								if(btn){
									$.ajax({
			                        	dataType:'json',
										url:'organ_cancelStatus.action',
										data:{
										      'orgId':orgId
										},
										type:'post',
										success:function(data){
											$.messager.alert('系统提示','撤销成功','info');
											$('#organGrid').datagrid('reload');
			    					    }
			                        });
								}
							});
						}else{
							$.messager.confirm('系统提示','确定要撤销所选机构吗?',function(btn){
								if(btn){
									var organIds = '';
									for(var i=0; i<selected.length; i++) {
										organIds += selected[i].orgId + ',';
									}
									$.ajax({
			                        	dataType:'json',
										url:'organ_cancelStatus.action',
										data:{
										      'orgId':orgId
										},
										type:'post',
										success:function(data){
											$.messager.alert('系统提示','撤销成功','info');
											$('#organGrid').datagrid('reload');
			    					    }
			                        });
								}
							});
						}
						$('#organGrid').datagrid("clearSelections");
					}
					
				});	
			}
		}]
	});

	$('#status').combobox({
	 	panelHeight:'100%',
		width:70
	});
});
</script>
</head>
<body style="padding: 20px; padding-bottom: 0;">
	<div id="formDiv" style="padding-bottom: 10px;">
	<form name="formSearch" id="formSearch" method="post">
		<input name="orgSeq" id="orgSeq" type="hidden" value="${param.orgSeq}">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">机构代码：
					<input type="text" class="input_eq" style="width: 68px" name="orgCode" value="${param.orgCode}" id="orgCode"/>
				</td>
				<td height="40px" >机构名称：<input type="text" id="orgName" name="orgName" value="${param.orgName}" class="input_eq" style="width: 100px"/></td>
				
				<td height="40px" >机构状态：</td>
				<td height="40px">
					<select name="status" class="easyui-combobox" id="status">
						<option value="1">启用</option>
						<option value="0">撤销</option>
						<%-- <rmp:option dictId="sys.status" currentValue="${param.status}" prompt=""></rmp:option>--%>
					</select>
				</td>
				</tr>
				<tr>
				<td>
					<input class="inputd" type="button" value="查 询" onclick="searchOrgan();" />
					<input class="inputd" type="button" value="重 置" onclick="formReset();"/>
				</td>
			</tr>
		</table>
	</form>
	</div>
	<div id="gridDiv">
		<table id="organGrid"></table>
	</div>
</body>
</html>

