<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>工程管理</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>

<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<script type="text/javascript">
var basePath = "${pageContext.request.contextPath}";
//网格初始化
$(function() {
	$('#projectGrid').datagrid({
		width:'100%',
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url: basePath + '/project_findAllAndUserNames.action',	//请求数据的url
		idField:'projectId',				//标识字段
		sortName: 'maintainDate',
		sortOrder:'desc',				//采用降序排序
		singleSelect:false,
		pagination:true,
		columns:[[
			{field:'projectId', checkbox:true, width:20},
			{field:'projectName', title:"工程名称", width:100},
	    	{field:'projectType', title:"工程类型", width:100,
				formatter:function(value) {
					if(value == '0') {
						return 'Master';
					}
					if(value == '1') {
						return 'product';
					}  
			}}, 
			{field:'dbUserName', title:'数据库用户', width:100},
			{field:'lockFlg', title:'锁定状态', width:60,
				formatter:function(value) {
					 if("0" == value) {
						 return "<font color='red'>锁定</font>";
					 } else {
						 return "正常";
					 }
				}
			},
			{field:'useFlg', title:'使用状态', width:60,
				formatter:function(value) {
					 if("0" == value) {
						 return "<font color='red'>使用中</font>";
					 } else {
						 return "空闲";
					 }
				}
			},
			{field:'userNames', title:'授权用户',width:340}
		]],toolbar:[{							//工具栏
			id:'btnadd',
			text:'增加',
			iconCls:'icon-add',
			handler:function(){				//工具栏按所触发的函
				window.location.href="${pageContext.request.contextPath}/project_toForm.action";
				return false;//ie6问题修改
			}
		},{
			id:'btneidt',
			text:'编辑',
			iconCls:'icon-edit',
			handler:function(){
				var selected = $('#projectGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要编辑的工程！','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个工程进行编辑！','warning','160px','200px');
					return;
				}
				if(selected[0].lockFlg == "0") {
					$.messager.alertSelf('系统提示','当前工程已锁定，请解锁后编辑！','warning','160px','200px');
					return;
				}
				if(selected[0].useFlg == "0") {
					$.messager.alertSelf('系统提示','当前工程正在被用户使用中，无法进行编辑！','warning','160px','200px');
					return;
				}
				window.location.href="${pageContext.request.contextPath}/project_toForm.action?projectId="+selected[0].projectId;
				return false;//ie6问题修改
			}
		}, {
			id:'btnlock',
			text:'锁定',
			iconCls:'icon-remove',
			handler:function(){
				var selected = $('#projectGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要锁定的工程！','warning','160px','200px');
					return;
				}
				var projectIds = '';
				for(var i=0; i<selected.length; i++) {
					/**界面优化:使用中的工程 允许手工锁定，让后续登录的人无法使用                                                               zhouchaoqun    2013/06/20
					
					if(selected[i].useFlg == "0") {
						$.messager.alertSelf('系统提示',"[" + selected[i].projectName + "]工程正在使用中，无法进行锁定",'warning','160px','200px');
						return;
					}*/
					if(selected[i].lockFlg == "0") {
						$.messager.alertSelf('系统提示',"[" + selected[i].projectName + "]工程已经锁定，请重新选择工程",'warning','160px','200px');
						return; 
					}
					projectIds += selected[i].projectId + ',';
				}
                $.messager.confirmSelf('系统提示','确定要锁定所选工程吗?',function(btn){
     					if (btn) {
     						  $.ajax({
     	                      	dataType:'json',
   								url:'${pageContext.request.contextPath}/project_lockProjects.action',
   								data:{
   							 		'projectIds':projectIds  
   								},
   								type:'post',
   								success:function(data){
   									var result=data;
   									if(result=="1") {
   										$.messager.alertSelf('系统提示','锁定成功','info','160px','200px');
         									$('#projectGrid').datagrid('unselectAll');
         									$('#projectGrid').datagrid('reload');
     									}
   	  					    	}
     	                      });
     					} else {
     						$('#projectGrid').datagrid('unselectAll');
     					}
     				},'160px','200px');
                }
		}, {
			id:'btnuse',
			text:'解锁',
			iconCls:'icon-use',
			handler:function(){
				var selected = $('#projectGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要解锁的工程！','warning','160px','200px');
					return;
				}
				var projectIds = '';
				for(var i=0; i<selected.length; i++) {
					if(selected[i].lockFlg == "1") {
						$.messager.alertSelf('系统提示',"[" + selected[i].projectName + "]工程已经解锁，请重新选择工程",'warning','160px','200px');
						return; 
					}
					projectIds += selected[i].projectId + ',';
				}
	            $.messager.confirmSelf('系统提示','确定要解锁所选工程吗?',function(btn){
	 					if (btn) {
	 						  $.ajax({
	 	                      	dataType:'json',
									url:'${pageContext.request.contextPath}/project_unLockProjects.action',
									data:{
								 		'projectIds':projectIds  
									},
									type:'post',
									success:function(data){
										var result=data;
										if(result=="1") {
											$.messager.alertSelf('系统提示','解锁成功','info','160px','200px');
	     									$('#projectGrid').datagrid('unselectAll');
	     									$('#projectGrid').datagrid('reload');
	 									}
		  					    	}
	 	                      });
	 					} else {
	 						$('#projectGrid').datagrid('unselectAll');
	 					}
	 				},'160px','200px');
	            }
		}, {
			id:'btndelete',
			text:'删除',
			iconCls:'icon-remove',
			handler:function() {
				var selected = $('#projectGrid').datagrid('getSelections');			//?????//
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要删除的工程！','warning','160px','200px');
					return;
				}
				var projectIds = '';
				for(var i=0; i<selected.length; i++) {
					if(selected[i].useFlg == "0") {
						$.messager.alertSelf('系统提示',"[" + selected[i].projectName + "]工程正在使用中，无法进行删除",'warning','160px','200px');
						return;
					}
					projectIds += selected[i].projectId + ',';
				}
				$.ajax({
                	dataType:'text',  
					url:'${pageContext.request.contextPath}/project_isDelete.action',
					data:{
					      'projectIds':projectIds 
					},
					type:'post',
					success:function(data){
						 var result=data;
                         if(result=="1"){
                        	$.messager.alertSelf('系统提示',"所选工程拥有子工程,不能删除，请重新选择！",'info','160px','200px'); 
     						$('#projectGrid').datagrid('unselectAll');
                         }else{
                        	 $.messager.confirmSelf('系统提示','确定要删除所选工程吗?',function(btn){
             					if (btn) {
             						  $.ajax({
             	                      	dataType:'json',
             								url:'${pageContext.request.contextPath}/project_removeSelectedProjects.action',
             								data:{
             							 		'projectIds':projectIds  
             								},
             								type:'post',
             								success:function(data){
             									var result=data;
             									if(result=="1") {
             										$.messager.alertSelf('系统提示','删除成功','info','160px','200px');
                   									$('#projectGrid').datagrid('unselectAll');
                   									$('#projectGrid').datagrid('reload');
               									}
             	  					    }
             	                      });
             					} else {
             						$('#projectGrid').datagrid('unselectAll');
             					}
             				},'160px','200px');
                         }
					}
				});
			}
		},{id:'btnsysmrg',
			text:'工程授权',
			iconCls:'icon-sysmrg',
			handler:function(){
				var selected = $('#projectGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要授权的工程！','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个工程进行授权！','warning','160px','200px');
					return;
				}
				
				$('#proMgrPanel').panel({
					'title':"[&nbsp;" + selected[0].projectName + "&nbsp;]&nbsp;&nbsp;工程授权&nbsp;&nbsp;&nbsp;&nbsp;<input class='save_btn' type='button' value='保存' onclick='saveMgrUsers()'/>"
				});
				$('#organTree').combotree('setValue','');
           		var data = [{}];
           		$('#userListGrid').datagrid('loadData',data);
           		$('#userListGrid').datagrid('deleteRow',0);
				$('#proMgrPanel').panel('open',true);
				//$.messager.alertSelf('系统提示','请选择用户所在机构,点击查询进行工程赋权！','warning','150px','850px');
			}
		},{id:'btnsysmrg1',
			text:'工程同步',
			iconCls:'icon-down',
			handler:function(){
				var selected = $('#projectGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要同步的工程！','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个工程进行同步！','warning','160px','200px');
					return;
				}
				if(selected[0].syncCompleteFlag == "Y") {
					$.messager.alertSelf('系统提示','当前选择工程已经完成同步,无法再次同步','warning','160px','200px');
					return;
				}
				 $.ajax({
                   	dataType:'json',
						url:'${pageContext.request.contextPath}/project_syncProjectBaseData.action',
						data:{
					 		'projectId':selected[0].projectId
						},
						type:'post',
						success:function(data){
							var result=data;
							if(result=="1") {
								$.messager.alertSelf('系统提示','同步成功','info','160px','200px');
								$('#projectGrid').datagrid('unselectAll');
								$('#projectGrid').datagrid('reload');	
							}
				    	}
                   });
			}
		}],
		onSelect:function(rowIndex, rowData) {
			
			clickRow = rowIndex;
		}
	});
	//初始化下拉树
	$('#organTree').combotree({
		url:"${pageContext.request.contextPath}/organ_ogranTree.action",
		idField:"orgId",
		textField:"orgName",
		parentField:"parentId",
		panelWidth:190,
		width:130
	});

	$('#userListGrid').datagrid({
		width:'100%',
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url: basePath + "/secUser_findAllUsersForProjectMgr.action",		//请求数据的url
		sortOrder:'desc',				//采用降序排序
		idField:'userId',					//标识字段
		pagination:true,
		fitColumns: true,
		columns:[[
			{field:'userId', checkbox:true, width:20},
			{field:'userName', title:"用户名", align:'left', width:150},
			{field:'org', title:"所属机构", align:'left', width:150, 
				formatter : function(value) {
					if(value == null)
						return null;
					return value.orgName;
				}
			}
		]],
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		},
		onLoadSuccess: function(){
			$('#userListGrid').datagrid('unselectAll');
			var selected = $('#projectGrid').datagrid('getSelections');
			if(selected.length == 0)
				return;
			var ids = selected[0].userIds.split(",");
			for(i=0;i<ids.length;i++){
				$('#userListGrid').datagrid('selectRecord',ids[i]);
			} 
			var mgrUserOlds = $('#userListGrid').datagrid('getSelections');
			var mgrIdOlds ="";
			if(mgrUserOlds.length>0) {
				for(var i=0; i<mgrUserOlds.length-1; i++) {
					mgrIdOlds += mgrUserOlds[i].userId + ',';
				}
				mgrIdOlds += mgrUserOlds[mgrUserOlds.length-1].userId;
			}
			$('#mgrIdOlds').val(mgrIdOlds);
			$('#ifOk').val('1');
		}
	});
	
	
	$('select.easyui-combobox').combobox({
		panelHeight:'100%'
	});
	$('#projectTree').combobox({
		panelHeight:'100%'
	});
	$('#filter_submit').click(function(){
	 	var projectName = $('#projectName')[0].value.trim();
	    var projectType = $('#projectType').combobox('getValue');  
	    var parentProjectId = $('#projectTree').combobox('getValue');
	    $('#projectGrid').datagrid('getPager').pagination({
			pageNumber:1
		});
	    $('#projectGrid').datagrid('clearSelections');
	    $('#projectGrid').datagrid('load', {
		   	projectName:projectName,
		   	parentProject:parentProjectId,
		   	projectType:projectType
		});    
	});
	//重置查询信息
	$('#filter_reset').click(function(){
		$('#projectName').val('');
		$('#projectType').combobox('setValue','');
		$('#projectTree').combobox('setValue','');
	});
	$('#filter_reset1').click(function(){
		$('#organTree').combotree('setValue','');
	});
	//初始化上级工程树
	$('#projectTree').combobox({
		url:"${pageContext.request.contextPath}/project_projectTree.action",
		valueField:"projectId",
		textField:"projectName"
	});  
	$('#filter_submit1').click(function(){
		var orgId = $('#organTree').combobox('getValue');
		if(!orgId) {
			$.messager.alertSelf('系统提示','请选择查询条件','info','150px','850px');
			return;
		}
		$('#userListGrid').datagrid({
			pageNumber: 1,
			queryParams: {orgId: orgId}
			
		});
	});
});
	function saveMgrUsers() {
		var ifOk = $('#ifOk').val();
		if(ifOk=="0") {
			$.messager.alertSelf('系统提示','请点击工程赋权后选择用户所在机构,点击查询进行工程赋权！','warning','150px','850px');
			return;
		}
		$('#ifOk').val("0");
		var mgrUsers = $('#userListGrid').datagrid('getSelections');
		var mgrIdOlds = $('#mgrIdOlds').val();
		$('#mgrIdOlds').val(" ");
		var mgrIds = '';
		if(mgrUsers.length>0) {
			for(var i=0; i<mgrUsers.length-1; i++) {
				mgrIds += mgrUsers[i].userId + ',';
			}
			mgrIds += mgrUsers[mgrUsers.length-1].userId;
		}
		$.ajax({
        	dataType:'text',
			url:'project_saveMgrUsers.action',
			data:{
			      'mgrIds':mgrIds,
			      'projectId':$('#projectGrid').datagrid('getSelected').projectId,
			      'mgrIdOlds':mgrIdOlds
			},
			type:'post',
			success:function(data){
				 var result=data;
                 if(result=="1"){
                	 $.messager.alertSelf('系统提示','保存成功','info','150px','850px');
                	 $('#projectGrid').datagrid('reload');
                	 //$('#proMgrPanel').panel('close',true);
//                	 var jsonData = {
//							orgId:'00000000',
//							newpage:1
//					 };
                	 $('#proMgrPanel').panel('close',true);
//                	 $('#userListGrid').datagrid('options').queryParams=jsonData;
//                	 $('#userListGrid').datagrid({'url':'${pageContext.request.contextPath}/secUser_findAllUsersForProjectMgr.action'});
//             		 $('#userListGrid').datagrid('load');
            		 $('#userListGrid').datagrid('unselectAll');
            		 $('#organTree').combotree('setValue','');
					 var data = [{}];
                	 $('#userListGrid').datagrid('loadData',data);
                	 $('#userListGrid').datagrid('deleteRow',0);
                 }else{
                	 $('#organTree').combotree('setValue','');
                	 $('#projectGrid').datagrid('reload');
                	 var data = [{}];
					 $('#proMgrPanel').panel('close',true);
                	 $('#userListGrid').datagrid('loadData',data);
                	 $('#userListGrid').datagrid('deleteRow',0);
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
<body class="easyui-layout">
	<div region="west" style="width:830px;border-left: none;padding-bottom:60px" title="工程管理">
		<form name="formSearch1" id="formSearch1" method="post" style="padding: 10px">
			<table cellSpacing="0" cellpadding="0" border="0">
				<tr>
					<td height="40px">工程名称：</td>
					<td height="40px"><input type="text" id="projectName" name="projectName" class="input_eq" style="width: 100px"/>
					</td>
					<td height="40px">工程类型：</td>
					<td height="40px">
						<select name="projectType" class="easyui-combobox" id="projectType">
								<rmp:option dictId="sys.project.projectType" currentValue="${param.projectType}" prompt="--请选择--"></rmp:option>
						</select>
					</td>
					<td height="40px">上级工程：</td>
					<td height="40px">
						<input id="projectTree" style="width:90px" name="parentProjectId" class="easyui-combobox"></input>
					</td>
					<td>
						<input id="filter_submit" class="inputd" type="button" value="查 询" />
						<input id="filter_reset" class="inputd" type="button" value="重 置"  />
					</td>  
				</tr>
			</table>
		</form>
		<table id="projectGrid"></table>
	</div>
	
     <div region="center" id="resourceList" title="高级功能" style="padding-bottom:0px">
     	<div class="easyui-panel" id="proMgrPanel" fit="true" closed="true" border="false" style="padding-bottom: 60px;">
			<form name="formSearch2" id="formSearch2" method="post" style="padding: 10px 0 10px 10px;">
				<table cellSpacing="0" cellpadding="0" border="0">
					<tr>
						<td height="40px">所属机构：</td>
						<td height="40px">
							<input id="organTree" name="orgId" class="easyui-combotree"></input>
						</td>
						<td>
							<input id="filter_submit1" class="inputd" type="button" value="查 询"/>
							<input id="filter_reset1" class="inputd" type="button" value="重 置" />
						</td>
					</tr>
				</table>
			</form>
	    	<table id="userListGrid"></table>
	    	<input type="hidden" id="mgrIdOlds">
	    	<input type="hidden" id="ifOk" value="0">
		</div>
	 </div> 
</body>
</html>