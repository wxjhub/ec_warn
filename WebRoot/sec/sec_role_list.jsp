<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色管理</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>

<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/zTreeStyle/zTreeStyle.css" type="text/css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.core-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.excheck-3.0.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.ztree.exedit-3.0.js"></script>
<script type="text/javascript">
	String.prototype.trim = function () {
		return this.replace(/^\s+|\s+$/g, '');
	};

	//条件查询、分页查询
	function searchRole(){
	    var roleCode = $('#roleCode')[0].value.trim();
	    var roleName = $('#roleName')[0].value.trim();
		var pager = $('#roleGrid').datagrid('getPager');
		$('#roleGrid').datagrid('clearSelections');
	    $('#roleGrid').datagrid('load', {
	    	roleCode:roleCode,
	    	roleName:roleName
		});    
	 }
	
	function reset(){
		document.$("#formSearch").reset();
	 }


//网格初始化
$(function() {
	//$('.gridDiv').height($('.gridDiv').parent().parent().height()-95);
	
	$('#roleGrid').datagrid({
		title:'角色',
		iconCls:'icon-computer',
		width:'100%',
		height:'100%',
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		singleSelect:false,
		url:'${pageContext.request.contextPath}/secRole_asyFindRoleAndMgrRoles.action',		//请求数据的url
		sortOrder:'desc',				//采用降序排序
		idField:'roleId',					//标识字段
		pagination:true,
		columns:[[
			{field:'roleId', checkbox:true, width:20},
			{field:'roleCode', title:"角色编号", align:'left', width:100},
			{field:'roleName', title:"角色名称", align:'left', width:150},
			{field:'roleDesc', title:'角色描述', align:'left', width:200}
			/* ,
			{field:'mgrRole', title:'可管理角色', align:'left', width:340,
				formatter:function(value){
	    			if(value == null)
		    			return null;
	
	    			var roleName = "";
	    			for(var i = 0, len = value.length; i < len; i++){
	    				roleName += value[i].roleName;
	    				if(i < len - 1)
		    				roleName += ", ";
		    		}
		    		return roleName;
				}
			} */
		]],
		toolbar:[{							//工具栏
			id:'btnadd',
			text:'增加',
			iconCls:'icon-add',
			handler:function(){			
			    //工具栏按所触发的函
				window.location.href="${pageContext.request.contextPath}/role_toForm.action";	
			}
		},{
			id:'btneidt',
			text:'编辑',
			iconCls:'icon-edit',
			handler:function(){
				var selected = $('#roleGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要修改的角色！','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个角色进行编辑！','warning','160px','200px');
					return;
				}
				window.location.href="${pageContext.request.contextPath}/role_toForm.action?id="+selected[0].roleId;
			}
		}, {
			id:'btnZhuXiao',
			text:'删除',
			iconCls:'icon-remove',
			handler:function() {
				var selected = $('#roleGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要删除的角色！','warning','160px','200px');
					return;
				}
				var roleIds = '';
				for(var i=0; i<selected.length-1; i++) {
					if(selected[i].admFlg == 0) {
						$.messager.alertSelf('系统提示','超级管理员不能被删除,请重新选择要删除的角色！','warning','160px','200px');
						return;
					}
					roleIds += selected[i].roleId + ',';
				}
				if(selected[selected.length-1].admFlg == 0) {
					$.messager.alertSelf('系统提示','超级管理员不能被删除,请重新选择要删除的角色！','warning','160px','200px');
					return;
				}
				roleIds += selected[selected.length-1].roleId;
				$.ajax({
                	dataType:'text',
					url:'role_isDelete.action',
					data:{
					      'roleIds':roleIds 
					},
					type:'post',
					success:function(data){
						 var result=data;
                         if(result=="1"){
                        	 $.messager.alertSelf('系统提示',"所选角色中包含已被用户使用的角色，请重新选择！",'info','160px','200px'); 
                         }else{
                        	 $.messager.confirmSelf('系统提示','确定要删除所选角色吗?',function(btn){
             					if (btn) {
             						  $.ajax({
             	                      		dataType:'json',
             								url:'role_removeSelectedRoles.action',
             								data:{
             								      'roleIds':roleIds 
             								},
             								type:'post',
             								success:function(data){
                 								var result1 = data;
                 								if(result1 == "1") {
                 									$.messager.alertSelf('系统提示','删除成功','info','160px','200px');
                 									$('#roleGrid').datagrid('unselectAll');
                 									$('#roleGrid').datagrid('reload');
                   								}
             	  					    }
             	                      });
             					} else {
             						$('#roleGrid').datagrid('unselectAll');
             						}
             				},'160px','200px');
                         }
					}
				});
			}
		},{
			id:'btnsysmrg',
			text:'角色授权',
			iconCls:'icon-sysmrg',
			handler:function(){
				var selected = $('#roleGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要授权的角色！','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个角色进行授权！','warning','160px','200px');
					return;
				}
				$('#roleMgrPanel').panel('close',true);
				$('#roleRightPanel').panel({
					'title': "[&nbsp;" + selected[0].roleName + "&nbsp;]&nbsp;&nbsp;角色授权&nbsp;&nbsp;&nbsp;&nbsp;<input class='save_btn' type='reset' value='保存' onclick='save()'/>"
				});
				$('#roleRightPanel').panel('open',true);
				
				zTreeInit(selected[0].roleId);
			}
		}
		
		/* ,{
			id:'btnsysmrg',
			text:'可管理角色配置',
			iconCls:'icon-sysmrg',
			handler:function(){
				var selected = $('#roleGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要配置的角色！','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个角色进行可管理角色配置！','warning','160px','200px');
					return;
				}
				$('#roleMgrPanel').panel({
					'title': "[&nbsp;" + selected[0].roleName + "&nbsp;]&nbsp;&nbsp;可管理角色&nbsp;&nbsp;&nbsp;&nbsp;<input class='save_btn' type='reset' value='保存' onclick='saveMgrRoles()'/>"
				});
				$('#roleMgrPanel').panel('open',true);
				$('#roleRightPanel').panel('close',true);
				$('#roleMutexPanel').panel('close',true);
				$('#roleMgrGrid').datagrid('unselectAll');
				$('#roleMgrGrid').datagrid({
					url: '${pageContext.request.contextPath}/secRole_asyFindRolesOutSelf.action',
					queryParams:{
						selectedRoleId: selected[0].roleId,
						selectedRoleName: selected[0].roleName
					},
					onLoadSuccess: function(){
						var mgrRole = selected[0].mgrRole;
						if(mgrRole == null)
							return;
						for(var i = 0, len = mgrRole.length; i < len; i++){
							$('#roleMgrGrid').datagrid('selectRecord', mgrRole[i].roleId);
						}
					}
				});
			}
		} */
		/* ,{
			id:'btnrolemutex',
			text:'角色互斥配置',
			iconCls:'icon-sysmrg',
			handler:function(){
				var selected = $('#roleGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要配置的角色！','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个角色进行角色互斥配置！','warning','160px','200px');
					return;
				}
				$('#roleMutexPanel').panel({
					'title': "[&nbsp;" + selected[0].roleName + "&nbsp;]&nbsp;&nbsp;角色互斥配置&nbsp;&nbsp;&nbsp;&nbsp;<input class='save_btn' type='reset' value='保存' onclick='saveMutexRoles()'/>"
				});
				$('#roleMutexPanel').panel('open',true);
				$('#roleRightPanel').panel('close',true);
				$('#roleMgrPanel').panel('close',true);
				$('#roleMutexGrid').datagrid('unselectAll');
				$('#roleMutexGrid').datagrid({
					url: '${pageContext.request.contextPath}/secRole_asyFindRolesOutSelf.action',
					queryParams:{
						selectedRoleId: selected[0].roleId,
						selectedRoleName: selected[0].roleName
					},
					onLoadSuccess: function(){
						var roleMutex = selected[0].roleMutex;
						if(roleMutex == null)
							return ;
						for(i=0;i<roleMutex.length;i++){
							$('#roleMutexGrid').datagrid('selectRecord', roleMutex[i].roleMutexCode);
						}
					}
				});
			}
		} */
		],
		onSelect:function(rowIndex, rowData) {
			
		}
	});
	$('select.easyui-combobox').combobox({
		panelHeight:'100%'
	});
	$('#roleMgrGrid').datagrid({
		title:'可管理角色',
		iconCls:'icon-computer',
		width:'100%',
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'',		//请求数据的url
		sortOrder:'desc',				//采用降序排序
		idField:'roleId',					//标识字段
		columns:[[
			{field:'roleId', checkbox:true, width:20},
			{field:'roleCode', title:"角色编号", align:'left', width:120},
			{field:'roleName', title:"角色名称", align:'left', width:150}
		]],
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		}
	});
	$('#roleMutexGrid').datagrid({
		title:'角色互斥配置',
		iconCls:'icon-computer',
		width:'100%',
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'',		//请求数据的url
		sortOrder:'desc',				//采用降序排序
		idField:'roleCode',					//标识字段
		columns:[[
			{field:'roleId', checkbox:true, width:20},
			{field:'roleCode', title:"角色编号", align:'left', width:120},
			{field:'roleName', title:"角色名称", align:'left', width:150}
		]],
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		}
	});
});
	//菜单树setting设置默认属性
	var setting = {
			check: {
				enable: true,
				chkboxType:{"Y":"ps","N":"ps"}
			},
			data: {
				simpleData: {
					enable: true
				}
			}
	};
	
	//菜单树init方法
	function zTreeInit(id) {
		$.ajax({
			 cache:false,
			 type: 'post',
			 dataType : "Json",
			 url: "role_toRight.action?roleId="+id,
			 error: function () {
			 	$.messager.alertSelf('系统提示','当前菜单数据请求失败，请联系管理员','warning','160px','200px');
			 },
			 success:function(data){
				 var zNodes = eval(data);
				 $.fn.zTree.init($("#treeDemo"),setting,zNodes);
					
			 }
			});
	}
	function save(){
		var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
		var nodes = treeObj.getCheckedNodes(true);
		var json="";
		for(var i=0;i<nodes.length;i++){
			var node = nodes[i];
			json+="{id:"+"'"+node.id+"'"+",type:"+"'"+node.type+"'"+"}==";
		}
		json = json.substring(0,json.length-2);
		var roleId = $('#roleGrid').datagrid("getSelected").roleId;
		var str="json="+json+"&roleId="+roleId;
		$.ajax({
			 cache:false,
			 type: 'post',
			 data: str,
			 dataType : "Json",
			 url: "role_saveRight.action",
			 error: function () {
			 	$.messager.alertSelf('系统提示','权限修改失败','warning','150px','850px');
			 },
			 success:function(data){
				 var zNodes = eval(data);
				 $.fn.zTree.init($("#treeDemo"),setting,zNodes);
				 $.messager.alertSelf('系统提示','权限修改成功!','info','150px','850px');
				 $('#roleRightPanel').panel('close',true);
			 }
		});
	}
	function saveMgrRoles() {
		var mgrRoles = $('#roleMgrGrid').datagrid('getSelections');
		var mgrIds = '';
		if(mgrRoles.length>0) {
			for(var i=0; i<mgrRoles.length-1; i++) {
				mgrIds += mgrRoles[i].roleId + ',';
			}
			mgrIds += mgrRoles[mgrRoles.length-1].roleId;
		}
		$.ajax({
        	dataType:'text',
			url:'role_saveMgr.action',
			data:{
			      'mgrIds':mgrIds,
			      'roleId':$('#roleGrid').datagrid('getSelected').roleId
			},
			type:'post',
			success:function(data){
				 var result=data;
                 if(result=="1"){
                	 $.messager.alertSelf('系统提示','可管理角色修改成功','info','150px','850px');
                	 $('#roleMgrPanel').panel('close',true);
                	 $('#roleGrid').datagrid('load',{});
                 }
			}
		});
	}
	function saveMutexRoles() {
		var mutexRoles = $('#roleMutexGrid').datagrid('getSelections');
		var mutexIds = '';
		var mutexCodes = '';
		var mutexNames = '';
		if(mutexRoles != null && mutexRoles.length > 0) {
			for(var i=0; i<mutexRoles.length-1; i++) {
				mutexIds += mutexRoles[i].roleId + ',';
				mutexCodes += mutexRoles[i].roleCode + ',';
				mutexNames += mutexRoles[i].roleName + ',';
			}
			mutexIds += mutexRoles[mutexRoles.length-1].roleId;
			mutexCodes += mutexRoles[mutexRoles.length-1].roleCode;
			mutexNames += mutexRoles[mutexRoles.length-1].roleName;
		}

		$.ajax({
        	dataType:'text',
			url:'role_saveMutex.action',
			data:{
				  'roleId':$('#roleGrid').datagrid('getSelected').roleId,
			      'roleCode':$('#roleGrid').datagrid('getSelected').roleCode,
				  'roleName':$('#roleGrid').datagrid('getSelected').roleName,
				  'mutexIds':mutexIds,
			      'mutexCodes':mutexCodes,
			      'mutexNames':mutexNames
			},
			type:'post',
			success:function(data){
				 var result=data;
                 if(result==""){
                	 $.messager.alertSelf('系统提示','角色互斥配置修改成功','info','150px','850px');
					 //$('#roleGrid').datagrid('getSelected').roleMutexCodes = mutexCodes;
                	 $('#roleMutexPanel').panel('close',true); 
                	 $('#roleGrid').datagrid('load',{});
                 }else{
                	 $.messager.alertSelf('系统提示',result,'info','150px','850px');
                	 /**$('#roleMutexGrid').datagrid("unselectAll");
                	 if($('#roleGrid').datagrid('getSelected').roleMutexCodes != null) {
						var codes =  $('#roleGrid').datagrid('getSelected').roleMutexCodes.split(",");
						for(i=0;i<codes.length;i++){
							$('#roleMutexGrid').datagrid('selectRecord',codes[i]);
						}
					 }*/
					
                 }
			}
		});
	}
</script>
<style type="text/css">
.input_file{width:260px; margin-left:-260px;height:21px; filter:alpha(opacity=0); opacity:0;}
.save_btn{border:0px; width:56px;height:21px;background:url(../images/save_btn.jpg);
	font-family:'Microsoft YaHei';
	font-size:12px;
	padding-left:10px;
	padding-top:0px;
}
.save_btn:hover{border:0px; width:56px;height:21px;background:url(../images/save_btn_hover.jpg)}
</style>
</head>
<body class="easyui-layout" style="background-color:#EBF1FE;" border="false">
	<div region="west" style="width:530px;border-left: none; padding-bottom:43px"  border="true" title="角色管理"> 
		<form name="formSearch" id="formSearch" method="post" style="padding: 10px 0 10px 10px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">角色编号：</td>
				<td height="40px">
					<input type="text" name="roleCode" id="roleCode" class="input_eq" style="width:100px"/>
				</td>
				<td height="40px">角色名称：</td>
				<td height="40px">
					<input type="text" name="roleName" id="roleName" class="input_eq" style="width:100px"/>
				</td>
				<td>
					<input class="inputd" type="button" value="查 询" onclick="searchRole()" />
					<input class="inputd" type="reset" value="重 置" onclick="reset()"/>
				</td>
			</tr>
		</table>
		</form>
	<table id="roleGrid" noheader="true" ></table>
	</div>
	
     <div region="center" id="resourceList" style="background-color:#E7F1FD;" border="true" 
     	title="高级功能 " >
     	<div class="easyui-panel" id="roleRightPanel" 
     	fit="true" closed="true">
     	<ul id="treeDemo" class="ztree"></ul>
     	</div>
		<div class="easyui-panel" id="roleMgrPanel" 
		fit="true" closed="true">
		<table id="roleMgrGrid" noheader="true" ></table>
		</div>
		<div class="easyui-panel" id="roleMutexPanel" 
		fit="true" closed="true">
		<table id="roleMutexGrid" noheader="true" ></table>
		</div>	
	 </div> 
</body>
</html>