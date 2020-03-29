<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>元数据模型-主表信息</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<script type="text/javascript">
$.fn.combobox.defaults.panelHeight = "100%";
//条件查询、分页查询
function searchMetaModel(){
    var modelName = $('#modelName').val();
    var tableName = $('#tableName').val();
    var comment = $('#comment').val();
    var deployFlag = $('#deployFlag').val();
    $('#metaModel').datagrid('reload', {
    	modelName:modelName,
    	tableName:tableName,
    	comment:comment,
    	deployFlag:deployFlag
	});    
 }


$(function(){
	var heightValue = $(document).height() - 95;
	if(heightValue < 400)
		heightValue = 400;
	$('#metaModel').datagrid({
		title:'元数据模型表',
		width:'100%',
		height:heightValue,
		nowrap: false,
		striped: true,
		collapsible:false,
		url:'${pageContext.request.contextPath}/metaModelXml_findAllMetaModelDeployed.action',
		idField:'modelName',					//标识字段
		scroll:true,
		columns:[[
			{field:'modelName,tableName', checkbox:true, width:20},
			{field:'modelName',title:'元数据名',checkbox:false, width:160},
			{field:'tableName',title:'表名',width:238},
			{field:'comment',title:'表中文名',width:120},
			{field:'className',title:'持久化类',width:360},
			{field:'deployFlag',title:'是否发布',width:90,align:'center',
				formatter:function(value){
	       			if(value == '1') {
		       			return "已发布";
		       		} else {
			       		return "未发布";
			       	}
	    		},
	    		styler:function(value){
					if (value != '1'){
						return 'color:red;';
					}
				}
	    	}
		]],
		pagination:false,
		rownumbers:false,
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		},
		onDblClickRow:function(rowIndex, rowData){
			window.location.href="${pageContext.request.contextPath}/metaModelXml_toForm.action?modelName="+rowData.modelName;
			return false;
		},
		toolbar:[{
			id:'btneidt',
			text:'编辑',
			iconCls:'icon-edit',
			handler:function(){
				var selected = $('#metaModel').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要修改的元数据模型','warning');
					return;
				}
				if(selected.length >1) {
					$.messager.alert('系统提示','当前选择元数据模型大于一个，请选择一个进行修改','warning');
					return;
				}else{
					window.location.href="${pageContext.request.contextPath}/metaModelXml_toForm.action?modelName="+selected[0].modelName;
					return false;
				}
			}
		},{
			id:'btnsave',
			text:'发布',
			iconCls:'icon-save',
			handler:function(){
				var selected = $('#metaModel').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要发布的元数据模型！','warning');
					return;
				}
				var modelName2deploy = '';
				for(var i=0; i<selected.length-1; i++) {
					modelName2deploy += selected[i].modelName + ',';
				}
				modelName2deploy += selected[selected.length-1].modelName;
				
				$.messager.confirm('系统提示','你确定要发布所选表的元数据xml信息吗?',function(btn){
					if(btn){
						$('#metaModel').datagrid('unselectAll');
						$.ajax({
							dataType:'json',
							url:'${pageContext.request.contextPath}/metadataxml/metaModelXml_deployAll.action',
							data:{'modelName2deploy':modelName2deploy},
							type:'post',
							success:function(data){
								$.messager.alert('系统提示','元数据发布成功','info');
								$('#metaModel').datagrid('reload');
							}
						});
					}
				});
			}
		},{
			id:'btndel',
			text:'删除',
			iconCls:'icon-remove',
			handler:function(){
				var selected = $('#metaModel').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alert('系统提示','请选择要删除的元数据模型！','warning');
					return;
				}
				var modelNames = '';
				for(var i=0; i<selected.length-1; i++) {
					modelNames += selected[i].modelName + ',';
				}
				modelNames += selected[selected.length-1].modelName;
				$.messager.confirm('系统提示','你你确定要删除所选表的元数据xml信息吗?',function(btn){
					if(btn){
						$('#metaModel').datagrid('unselectAll');
						$.ajax({
							dataType:'json',
							url:'${pageContext.request.contextPath}/metadataxml/metaModelXml_remove.action',
							data:{'modelNames':modelNames},
							type:'post',
							success:function(data){
								//$.messager.alert('系统提示','元数据删除成功','info');
								$('#metaModel').datagrid('reload');
							}
						});
					}
				});
			}
		}]
	});
	//查询提交
	$('#filter_submit').click(function(){
		var jsonData = {
				modelName:$('#modelName').val(),
				tableName:$('#tableName').val(),
				comment:$('#comment').val(),
				deployFlag:$('#deployFlag').combobox('getValue'),
				newpage:1
				};
		$('#metaModel').datagrid('options').queryParams=jsonData;
		$('#metaModel').datagrid('load');
	});

	//重置查询信息
	$('#filter_reset').click(function(){
		$('#modelName').val('');
		$('#tableName').val('');
		$('#comment').val('');
		$('#deployFlag').combobox('setValue','');
		$('#metaModel').datagrid('options').queryParams="";
		$('#metaModel').datagrid('reload');
	});
});

</script>
</head>
<body>
<div class="mar_30 majorword">
	<form name="formSearch" id="formSearch" action="${pageContext.request.contextPath}/metaModelXml_list.action" method="post">
		<INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}"> 
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
			    <td>元数据名:
			          <input name="modelName" id="modelName" type="text" value="${param.modelName}" class="input_eq" style="width: 100px;height: 20px"/>  
			    </td>
			    <td>表名称:
			          <input name="tableName" id="tableName" type="text" value="${param.tableName}" class="input_eq" style="width: 120px;height: 20px"/>
			    </td>
			    <td>表中文名:
			          <input name="comment" id="comment" type="text" value="${param.comment}" class="input_eq" style="width: 120px;height: 20px"/>
				<td>发布标识:
				   <select name="deployFlag" id="deployFlag" class="easyui-combobox" style="width: 120px;" >
				     <rmp:option dictId="sys.deployFlag" currentValue="${param.deployFlag}" prompt="" />
				   </select> 
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查 询"/>
					<input id="filter_reset" class="inputd" type="button" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>	
</div>
<div class="gridDiv">
	<table id="metaModel"></table>
</div>
</body>
</html>