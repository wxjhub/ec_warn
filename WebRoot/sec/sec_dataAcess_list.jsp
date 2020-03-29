<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%> 
<%@ taglib prefix="s" uri="/struts-tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"  dir="ltr" lang="zh-CN" xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据权限列表页面</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>

<script type="text/javascript">
		//网格初始化
		$(function() {
			var height = $('.gridDiv').parent().parent()[0].clientHeight - 60;
			$('.gridDiv').height(height);
			$('#dataAcess').datagrid({
				title:'数据权限管理',
				iconCls:'icon-computer',
				width:'100%',
				height:385,
				fit:true,
				nowrap:false,						//是否换行
				striped:true,						//是否隔行换色
				collapsible:false,					//是否增加收起表格组件的按钮
				url:'dataAcess_asyFindDataAcess.action',	//请求数据的url
				sortOrder:'',				//采用降序排序
				idField:'',					//标识字段
				pagination:true,
				columns:[[
					{field:'id',checkbox:true,width:20},
					{field:'className', title:"资源实体", align:'center', width:500},
					{field:'dataAcessId', title:"数据规则", align:'center', width:300,
						formatter:function(value) {
						if(value != null) {
							return "<a href='${pageContext.request.contextPath}/${pageContext.request.contextPath}/dataAcess_toViewForm.action?dataAcessId="+value+"'> <font color='blue'>查看</font> </a>"
						}
						}
					}
				]],
				pagination:true,
				rownumbers:false,
				onClickRow:function(rowIndex, rowData) {
					clickRow = rowIndex;
				},
				toolbar:[{							//工具栏
					id:'btnadd',
					text:'增加',
					iconCls:'icon-add',
					handler:function(){				//工具栏按所触发的函
						window.location.href="${pageContext.request.contextPath}/dataAcess_toForm.action";
					}
				},{
					id:'btneidt',
					text:'编辑',
					iconCls:'icon-edit',
					handler:function(){
						var selected = $('#dataAcess').datagrid('getSelections');
						if(selected.length == 0) {
							$.messager.alert('系统提示','请选择要修改的数据权限！','warning');
							return;
						}
						if(selected.length >1) {
							$.messager.alert('系统提示','只能选择一个数据权限进行编辑！','warning');
							return;
						}
						window.location.href="${pageContext.request.contextPath}/dataAcess_toForm.action?dataAcessId="+selected[0].dataAcessId;
					}
				},  {
					id:'btnZhuXiao',
					text:'删除',
					iconCls:'icon-remove',
					handler:function() {
						var selected = $('#dataAcess').datagrid('getSelections');
						var dataAcessIds="";
						if(selected.length == 0) {
							$.messager.alert('系统提示','请选择要删除的数据权限！','warning');
							return;
						}
						$.messager.confirm('系统提示','你确定要删除选中的数据权限吗，删除后该数据权限将不能使用，请慎重！',function(btn){
                            if(btn){
                            	for(var i=0;i<selected.length;i++){
        							if(dataAcessIds==""){
                                        dataAcessIds+=selected[i].dataAcessId;
        							}else{
        								dataAcessIds+=","+selected[i].dataAcessId;
        						    }
        				        }
                            	$('#dataAcess').datagrid('unselectAll');
        				        $.ajax({
                                    dataType:'text',
                                    url:'dataAcess_delete.action',
                                    data:{'dataAcessIds':dataAcessIds},
                                    type:'post',
                                    success:function(){
                                         $.messager.alert('系统提示','数据权限删除成功！','info',function(){
                                        	 $('#dataAcess').datagrid('reload');
                                         });
                                    }
        					    });
                            }else{
                            	$('#dataAcess').datagrid('unselectAll');
                            }
					    });
						
					}
				}]
			});
			var pager = $('#dataAcess').datagrid('getPager');
			$(pager).pagination({
				pageSize:10,
				pageList:[5,10,15],
				beforePageText:"第",
				afterPageText:"页  共{pages}页",
				displayMsg:"当前显示 {from} - {to} 条记录   共 {total} 条记录"
			});
		});
	</script>
</head>
<body>
	<div class="gridDiv" style="margin-top: 30px;">
		<table id="dataAcess"></table>
	</div>
</body>
</html>

