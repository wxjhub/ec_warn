<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户管理</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/meta_icon.css"></link>

<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>

<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<h:js src="/default/combobox.js"></h:js>
<script type="text/javascript">
//网格初始化
$(function() {
	//$('.gridDiv').height($('.gridDiv').parent().parent().height()-95);
	
	$('#userGrid').datagrid({
		title:'用户',
		iconCls:'icon-computer',
		width:'100%',
		height:'400px',
		fit:true,
		nowrap:false,						//是否换行
		fitColumns:true,
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		singleSelect:true,
		url:'',
		idField:'userId',					//标识字段
		sortOrder:'desc',				//采用降序排序
		pagination:true,
		singleSelect:false,
		columns:[[
			{field:'userId', checkbox:true, width:20},
			{field:'userName',title:'用户名', width:100},
			{field:'realName',title:'姓名', align:'left',width:100},
			{field:'orgName',title:'机构', align:'left',width:150},
			{field:'userFlg',title:'状态',align:'left',width:100,
				formatter:function(value){
	       			if(value == '1') {
		       			return "启用";
		       		} else if(value == '0'){
			       		return "锁定";
			       	}
	       			return null;
	    		},
	    		styler:function(value){
					if (value != '1'){
						return 'color:red;';
					}
				}
	    	},
			{field:'role', title:'授权角色', width:340,
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
			}
		]],
		toolbar:[{
			id:'btnadd',
			text:'添加',
			iconCls:'icon-add',
			handler:function(){
				window.location.href="${pageContext.request.contextPath}/secUser_toForm.action";
				return false;//ie6问题修改
			}
		},{
			id:'btnedit',
			text:'编辑',
			iconCls:'icon-edit',
			handler:function(){
				var selected = $('#userGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要修改的用户','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个用户进行修改','warning','160px','200px');
					return;
				}else{
					window.location.href="${pageContext.request.contextPath}/secUser_toForm.action?id="+selected[0].userId;
					return false;//ie6问题修改
				}
			}
		},{
			id:'btnuse',
			text:'解锁',
			iconCls:'icon-use',
			handler:function(){
				var rows = $('#userGrid').datagrid('getSelections');
				var str="";
				if(rows.length>0){
					for(var i=0; i<rows.length; i++) {
						if(rows[i].userFlg==1){
							$.messager.alertSelf('系统提示','选中的用户有启用项，请重新选择','warning','160px','200px');
							return false;
						}else{
							str += rows[i].userId+",";
						}
					}
					$.messager.confirmSelf('系统提示','你确定要对选中记录进行解除锁定操作吗',function(btn){
						if(btn){
							$('#userGrid').datagrid('unselectAll');
							$.ajax({
								dataType:'json',
								url:'secUser_unlockUser.action',
								data:{'rowIds':str},
								type:'post',
								success:function(data,status){
									var result=data;
									if(result=="1") {
									$.messager.alertSelf('系统提示','用户解锁成功','info','160px','200px');
									$('#userGrid').datagrid('reload');
									$('#userGrid').datagrid("clearSelections");
								}
								}
							});
						}
					},'160px','200px');
				}else{
					$.messager.alertSelf('系统提示','请选择要解锁的用户','warning','160px','200px');
				}
			}
		},{
			id:'btndel',
			text:'注销',
			iconCls:'icon-remove',
			handler:function(){
				var rows = $('#userGrid').datagrid('getSelections');
				var str="";
				if(rows.length>0){
					for(var i=0; i<rows.length; i++) {
						if(rows[i].status==0){	
							$.messager.alertSelf('系统提示','选中的用户有注销项，请重新选择','warning','160px','200px');
							return false;
						}else{
							str += rows[i].userId+",";
						}
					}
					$.ajax({
	                	dataType:'text',
						url:'secUser_isCancelUsing.action',
						data:{
						      'userIds':str 
						},
						type:'post',
						success:function(data){
							 var result=data;
	                         if(result=="1"){
	                        	 $.messager.alertSelf('系统提示',"超级管理员不能被删除，请重新选择！",'info','160px','200px'); 
	                         }else{
	                        	 $.messager.confirmSelf('系统提示','你确定要注销选中的用户吗，注销后该用户将不能使用，请慎重！',function(btn){
	         						if(btn){
	         							$('#userGrid').datagrid('unselectAll');
	         							$.ajax({
	         								dataType:'json',
	         								url:'secUser_cancelUsing.action',
	         								data:{'rowIds':str},
	         								type:'post',
	         								success:function(data){
	         									var result=data;
	         									if(result=="1") {
	         									$.messager.alertSelf('系统提示','用户注销成功','info','160px','200px');
	         									$('#userGrid').datagrid('reload');
	         								}
	         								}
	         							});
	         						} else {
	         							$('#userGrid').datagrid('unselectAll');
	         						}
	         					},'160px','200px');
	                         }
						}
					});
					
				}else{
					$.messager.alertSelf('系统提示','请选择要注销的用户','warning','160px','200px');
				}
			}
		},{
			id:'btnsysmrg',
			text:'授权',
			iconCls:'icon-sysmrg',
			handler:function(){
				$('#mgrIdOlds').val("");
				var selected = $('#userGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要授权的用户','warning','160px','200px');
					return;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个用户进行授权！','warning','160px','200px');
					return;
				}
				$('#userMgrPanel').panel({
					'noheader':false,
					'title': "[&nbsp;" + selected[0].userName + "&nbsp;]&nbsp;&nbsp;用户授权&nbsp;&nbsp;&nbsp;&nbsp;<input class='save_btn' id='savemg' name='savemg' type='reset' value='保存' onclick='saveMgrRoles()'/>"
				});
//				$('#userMgrPanel').panel('open',true);
				$('#userMgrGrid').datagrid('unselectAll');
				$('#userMgrGrid').datagrid({
					'url':'${pageContext.request.contextPath}/secUser_queryRolesByRoleName.action',
					'onLoadSuccess':function(){
						var roleList = selected[0].role;
						if(roleList == null)
							return;
						for(var i = 0, len = roleList.length; i < len; i++){
							$('#userMgrGrid').datagrid('selectRecord', roleList[i].roleId);
						}
						
						//for(i=0;i<ids.length;i++){
						//	$('#userMgrGrid').datagrid('selectRecord',ids[i]);
						//}
						
						var mgrRoleOlds = $('#userMgrGrid').datagrid('getSelections');
						var mgrIdOlds ="";
						if(mgrRoleOlds.length>0) {
							for(var i=0; i<mgrRoleOlds.length-1; i++) {
								mgrIdOlds += mgrRoleOlds[i].roleId + ',';
							}
							mgrIdOlds += mgrRoleOlds[mgrRoleOlds.length-1].roleId;
						}
						$('#mgrIdOlds').val(mgrIdOlds);
						
					}
				});
			}
		},{
			id:'btnUserImpTem',
			text:'模板',
			iconCls:'icon-export',
			handler:function(){
				downLoadUsersTemplate();
			}
		},{
			id:'btnUserImp',
			text:'导出',
			iconCls:'icon-export',
			handler:function(){
				downLoadUsers();
			}
		},{
			id:'btnUserExp',
			text:'导入',
			iconCls:'icon-import',
			handler:function(){
				uploadUsers();
			}
		},{ id:'input_file',text:"<input style='border: 1px #c0c0c0 solid; height: 19px; width:230px;position:relative;top:-2px;' type='text' id='txtUser' name='txtUser' /><input type='button' class='inputd' style='position:relative;cursor:pointer;' value='浏览' width:40px;/><input class='input_file' type='file' id='uploadUser' name='upload' onchange='txtUser.value=this.value'/>",
			handler:function(){
			}
		}],
		onSelect:function(rowIndex, rowData) {
			clickRow = rowIndex;
		}
	});
	$('#userMgrGrid').datagrid({
		title:'用户授权',
		iconCls:'icon-computer',
		width:'100%',
		fit:true,
		fitColumns:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'',		//请求数据的url
		sortOrder:'desc',				//采用降序排序
		idField:'roleId',					//标识字段
		toolbar:[{
			id:'btnexport',
			text:'模板',
			iconCls:'icon-export',
			handler:function(){
				downLoadTemplate();
			}
		},{
			id:'btnimport',
			text:'导入',
			iconCls:'icon-import',
			handler:function(){
				updataTemplate();
			}
		},{ id:'input_file',text:"<input style='border: 1px #c0c0c0 solid; height: 19px; width:200px;position:relative;top:-2px;' type='text' id='txt' name='txt' /><input type='button' class='inputd' style='position:relative;cursor:pointer;' value='浏览' /><input class='input_file2' type='file' id='upload' name='upload' onchange='txt.value=this.value'/>",
			handler:function(){
			}
		}],
		columns:[[
			{field:'roleId', checkbox:true, width:20},
			{field:'roleCode', title:"角色编号", width:120},
			{field:'roleName', title:"角色名称", width:150}
		]],
		onClickRow:function(rowIndex, rowData) {
			clickRow = rowIndex;
		}
	});
	
	$('select.easyui-combobox').combobox({
		panelHeight:'100%'
	});
	//条件查询、分页查询
	//查询提交
	$('#filter_submit').click(function(){
		var userName = $.trim($('#userName').val());
		var userFlg = $('#userFlg').combobox('getValue');
		var orgId = $('#orgId').val();
		var roleId = $('#roleId').combobox('getValue');
		if(!userName && !userFlg && !orgId && !roleId) {
			$.messager.alertSelf('系统提示','请选择查询条件','info','160px','200px');
			return;
		}
		var jsonData = {
				userName:userName,
				userFlg:userFlg,
				orgId:orgId,
				roleId:roleId,
				newpage:1
				};
 	    $('#userGrid').datagrid('getPager').pagination({
	    	pageNumber:1
		});
		$('#userGrid').datagrid('options').queryParams=jsonData;
		$('#userGrid').datagrid('clearSelections');
		$('#userGrid').datagrid({'url':'secUser_findAllUserAndMgrRoles.action'});
//		$('#userGrid').datagrid('load');
	});

	//重置查询信息
	$('#filter_reset').click(function(){
		$('#userName').val('');
		$('#userFlg').combobox('setValue','');
		$('#orgId').val('');
		$('#orgName').val('');
		$('#roleId').combobox('setValue','');
	});
});
function saveMgrRoles() {
	//点击保存按钮之后 保存按钮变为不可以编辑的
	$("#savemg").attr('disabled','disabled');
	
	var mgrRoles = $('#userMgrGrid').datagrid('getSelections');
	
	var mgrIds = '';
	var mgrCodes = '';
	var mgrNames = '';
	if(mgrRoles.length>0) {
		for(var i=0; i<mgrRoles.length-1; i++) {
			mgrIds += mgrRoles[i].roleId + ',';
			mgrCodes += mgrRoles[i].roleCode + ',';
			mgrNames += mgrRoles[i].roleName + ',';
		}
		mgrIds += mgrRoles[mgrRoles.length-1].roleId;
		mgrCodes += mgrRoles[mgrRoles.length-1].roleCode;
		mgrNames += mgrRoles[mgrRoles.length-1].roleName;
	}
	var mgrIdOlds = $('#mgrIdOlds').val();
	$('#mgrIdOlds').val("");
	$.ajax({
    	dataType:'text',
		url:'secUser_saveMgrRoles.action',
		data:{
		      'mgrIds':mgrIds,
		      'mgrCodes':mgrCodes,
		      'mgrNames':mgrNames,
		      'mgrIdOlds':mgrIdOlds,
		      'userId':$('#userGrid').datagrid('getSelected').userId
		},
		type:'post',
		success:function(data){
			 var result=data;
			 if(result==""){
            	$.messager.alertSelf('系统提示','保存成功','info','150px','850px');
//            	$('#userMgrPanel').panel('close',true);
				$('#userMgrPanel').panel({'noheader':true});
				var data = [{}];
				$('#userMgrGrid').datagrid('unselectAll');
                $('#userMgrGrid').datagrid('loadData',data);
                $('#userMgrGrid').datagrid('deleteRow',0);

            	$('#userGrid').datagrid('reload');
           	 }else {
           		$.messager.alertSelf('系统提示',result,'warning','160px','200px');
             }
		}
	});
}
	function downLoadTemplate() {
		//用户授权模板导出改为选中导入                                     zhouchaoqun         2013/06/21
		var selected = $('#userGrid').datagrid('getSelections');
		if(selected.length == 0) {
			$.messager.alertSelf('系统提示','请选择要导出的用户','warning','160px','200px');
			return;
		}
		var selectedStr = selected[0].userId;
		for(var i=1; i<selected.length; i++) {
			selectedStr = selectedStr + "," + selected[i].userId;
		}
		$('#formSearch').form('submit',{
			url:'UserMgrRole_exportExcel.action?userId=' + selectedStr,
			success:function(data){
				var result=data;
				if(result=="1") {
					$.messager.alertSelf('系统提示','数据导出成功','warning','160px','200px');
				}
			}
		});
	}
	function downLoadUsers(){
		$('#formSearch').form('submit',{
			url:'UserMgrRole_exportUserExcel.action',
			success:function(data){
				var result=data;
				if(result=="1") {
					$.messager.alertSelf('系统提示','数据导出成功','warning','160px','200px');
				}
			}
		});
	}
	function downLoadUsersTemplate(){
		$('#formSearch').form('submit',{
			url:'UserMgrRole_exportUserExcel.action?exportTemplate=1',
			success:function(data){
				var result=data;
				if(result=="1") {
					$.messager.alertSelf('系统提示','数据导出成功','warning','160px','200px');
				}
			}
		});
	}
	function updataTemplate() {
		if(!$('#txt').val()) {
			$.messager.alertSelf('系统提示','请选择要导入的数据文件','warning','160px','200px');
			return;
		}
	   $.ajaxFileUpload({
        	 url: "UserMgrRole_importExcel.action?modelName=UserMgrRole",
             secureuri:false,  
             fileElementId: 'upload',//文件选择框的id属性  
             dataType:'json',//服务器返回的格式，可以是json  
             error: function(data) {      // 设置表单提交出错
		   		$.messager.alertSelf('系统提示','数据导入失败','warning','160px','200px');
             },
             success: function(data) { // 设置表单提交完成使用方法
               	$.messager.alertSelf('系统提示','数据导入成功','warning','160px','200px');
               	$('#txt').val("");
                $('#userGrid').datagrid('load');
             }
         });
	}
	function uploadUsers(){
		if(!$('#txtUser').val()) {
			$.messager.alertSelf('系统提示','请选择要导入的数据文件','warning','160px','200px');
			return;
		}
	   $.ajaxFileUpload({
        	 url: "UserMgrRole_importUserExcel.action",
             secureuri:false,
             fileElementId: 'uploadUser',//文件选择框的id属性  
             dataType:'text',//服务器返回的格式，可以是json  
             error: function(data) {      // 设置表单提交出错
 		   		$.messager.alertSelf('系统提示','数据导入失败','warning','160px','200px');
              },
             success: function(data) { // 设置表单提交完成使用方法
             if(data=='1'){
					$.messager.alertSelf('系统提示','数据导入成功','warning','160px','200px');
					$('#txtUser').val("");
					$('#userGrid').datagrid('load');
               }else{
					hasException(data);
					$('#txtUser').val("");
					$('#userGrid').datagrid('load');
               }
             }
         });
	}

	function selectOrgan(){
		showModalCenter ("${pageContext.request.contextPath}/sec/tree/sec_organ_tree.jsp", function(data){
				$("#orgId").val(data[0].id);
				$("#orgName").val(data[0].name);
			}, "400", "88%", "机构树");
	}
</script>
<style type="text/css">
.input_file{width:120px; margin-left:-110px;height:21px; position: absolute;z-index: 10000;margin-top: 2px; filter:alpha(opacity=0); opacity:0;}
.input_file2{width:120px; margin-left:-117px;height:21px; position: absolute;z-index: 10000;margin-top: 2px; filter:alpha(opacity=0); opacity:0;}
.save_btn{border:0px; width:56px;height:21px;background:url(../images/save_btn.jpg);
	font-family:'Microsoft YaHei';
	font-size:12px;
	padding-left:10px;
	padding-top:0px;
}
.save_btn:hover{border:0px; width:56px;height:21px;background:url(../images/save_btn_hover.jpg)}
</style>
</head>
<body class="easyui-layout"  style="background-color:#EBF1FE;" border="false" onload="page_top()">
	<div region="west" style="width:560px; border-left: none;padding-bottom:63px"  border="true" title=
	"用户管理" id="bbcc">
	
	<form name="formSearch" id="formSearch" method="post" style="padding: 10px 0px 10px 10px;">
		<%-- <INPUT name="pageNo" id="pageNo"type="hidden" value="${param.pageNo}">  --%>
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr style="width: 400px">
				<td height="60px">用户名：</td>
				<td height="40px">
					<input type="text" name="userName" id="userName" class="input_eq" style="width:100px"/>
				</td>
				<td height="40px">所属机构：</td>
				<td height="40px">
					<input type="hidden" id="orgId" name="orgId">
					<input type="text" class="input_eq" id="orgName" style="width: 140px" name="orgName"  readonly="readonly">
				</td>
				<td height="40px">
					<input type="button" class="inputd" value="选择" onclick="selectOrgan();">
				</td>
				</tr>
				<tr>
				<td height="40px">状态：</td>
				<td height="40px">
					<select name="userFlg" class="easyui-combobox" id="userFlg" style="width:102px">
						<rmp:option dictId="sys.userFlg" prompt="--请选择--" defaultValue="1"></rmp:option>
					</select>
				</td>
				<td height="40px">角色：</td>
				<td height="40px">
					<r:combobox id="roleId" name="roleId" style="width:142px"  panelHeight="200px" valueField="roleId" textField="roleName" url="${pageContext.request.contextPath}/secUser_initRoleTree.action"></r:combobox>
				</td>
				<td>
					<input id="filter_submit" class="inputd" type="button" value="查 询"/>
					<input id="filter_reset" class="inputd" type="button" value="重 置"/>
				</td>
			</tr>
		</table>
	</form>
	<table id="userGrid" noheader="true" style="" ></table>
	</div>
	
     <div region="center" id="resourceList" style="background-color:#E7F1FD;" border="true" 
     	title="高级功能">
     	<div class="easyui-panel" id="userMgrPanel" fit="true" closed="false">
    	<table id="userMgrGrid" noheader="true" ></table>
    	<input type="hidden" id="mgrIdOlds">
    	</div>
	 </div> 

</body>
<script type="text/javascript">
function page_top(){
	//$("#taskRelationInfo .pagination").addClass("top");
	var s =window.screen.width;
	$("#bbcc .datagrid-toolbar").css("height","55px");
	if(s<=1270)
	{
		$("#resourceList .datagrid-toolbar").css("height","55px");
	}
   
}
</script>
</html>