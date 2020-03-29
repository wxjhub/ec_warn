<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	response.setHeader("Cache-Control", "no-cache"); //HTTP 1.1
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setDateHeader("Expires", 0); //防止代理服务器缓存页面
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>业务字典管理</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script src="${pageContext.request.contextPath}/js/all.js" type="text/javascript"></script>
<script type="text/javascript">
function query(){
	var dictId=$('#dictId').val();
	var dictName=$('#dictName').val();
	$('#dictGrid').datagrid('load', {
		dictId:dictId,
		dictName:dictName
	});    
 } 
function reset(){
	document.$("#formSearch").reset();
 }
$(function(){
	var lastIndex;
	$.extend($.fn.validatebox.defaults.rules, {
		dictId: {
	        validator: function (value) {
				if(!/^[a-zA-Z0-9_]+$/.test(value)){
					$.fn.validatebox.defaults.rules.dictId.message ="只可输入字母数字_！";
		            return false;
				}else{
					$.fn.validatebox.defaults.rules.dictId.message ="";
				}
				$('#dictGrid').datagrid('unselectAll');
				$('#dictGrid').datagrid('selectRow',lastIndex);
				var row = $('#dictGrid').datagrid('getSelected');
				var uuid = row.uuid;
				var exist=$.ajax({
		                url:"${pageContext.request.contextPath}/dictDef_checkDictId.action",
		                data:{uuid:uuid,dictId:value},
		                async:false
		        }).responseText;
				if(exist=="false"){
			            $.fn.validatebox.defaults.rules.dictId.message ="";
			            return true;
			    }else{
			        	$.fn.validatebox.defaults.rules.dictId.message ="该类型编号已存在，无法使用！";
			            return false;
				}
		    },
	   		 message: ''
	 	}
	});

	var height = $('.gridDiv').parent().parent()[0].clientHeight - $("#formSearch").height() - 74;
	$('.gridDiv').height(height);
	
	$('#dictGrid').datagrid({
		title:'业务字典类型管理',
		width:'100%',
		height:385,
		fit:true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'${pageContext.request.contextPath}/dictDef_asyFindDictDefs.action',//请求数据的url
		pagination:true,
		pageSize:15,
		columns:[[
			{field:'uuid', checkbox:true, width:20},
			{field:'dictId', title:"类型编号", align:'center', width:500,
				editor:{
					type:'validatebox',
					options:{
						validType:'dictId',
						required:true,
						missingMessage:'必输项'
					}
				}
			},
			{field:'dictName', title:"类型名称", align:'center', width:550,editor:'text'}
		]],
		toolbar:[{
			text:'添加',
			iconCls:'icon-add',
			handler:function(){
				$('#dictGrid').datagrid('endEdit', lastIndex);
				$('#dictGrid').datagrid('appendRow',{
					uuid:'',
					dictId:'',
					dictName:''
				});
				lastIndex = $('#dictGrid').datagrid('getRows').length-1;
				$('#dictGrid').datagrid('selectRow', lastIndex);
				$('#dictGrid').datagrid('beginEdit', lastIndex);
			}
		},{
			text:'删除',
			iconCls:'icon-remove',
			handler:function(){ 
			    $('#dictGrid').datagrid('endEdit', lastIndex);
				var insertedRows = $('#dictGrid').datagrid('getChanges','inserted');
				var updatedRows=$('#dictGrid').datagrid('getChanges','updated');
				var deletedRows=$('#dictGrid').datagrid('getSelections'); 
				var dictDefDelUuid='';
				if(deletedRows.length==0){
					$.messager.alert('系统提示','请选择要删除的字典！','warning');
			    }else if(insertedRows.length!=0||updatedRows.length!=0){
			    	$.messager.alert('系统提示','尚有修改未作保存，请先保存！','warning');
                    return
                }else{
                	$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
                    	if(btn){
		                	for(var k=0;k<deletedRows.length;k++){
		    					dictDefDelUuid+=deletedRows[k].uuid+',';
		    			    }
		                	 $.ajax({
		                      	dataType:'json',
									url:'dictDef_removeDictDef.action',
									data:{
									      'dictDefUuid':dictDefDelUuid
									},
								    type:'post',
									success:function(data){
									$.messager.alert('系统提示','删除成功','warning');
									$('#dictGrid').datagrid('reload');
		  					    }
		                     });
                    	}
                	});
                }
			}
		},{
			text:'保存',
			iconCls:'icon-save',
			handler:function(){
				$('#dictGrid').datagrid('endEdit', lastIndex);
				var insertedRows = $('#dictGrid').datagrid('getChanges','inserted');
				var updatedRows=$('#dictGrid').datagrid('getChanges','updated');
				var dictDefUuid='';
				var dictId='';
				var dictName='';
                if(insertedRows.length==0&&updatedRows.length==0){
                    alert("数据字典未作修改！");
                    lastIndex = '';
                    return
                }else{
    		    for(var i=0;i<insertedRows.length;i++){
    				dictDefUuid+=insertedRows[i].uuid+',';
    				dictId+=insertedRows[i].dictId+',';
    				dictName+=insertedRows[i].dictName+',';
    			}
				for(var j=0;j<updatedRows.length;j++){
					dictDefUuid+=updatedRows[j].uuid+',';
					dictId+=updatedRows[j].dictId+',';
					dictName+=updatedRows[j].dictName+',';
			    }
			    $.messager.confirm('系统提示','确定要保存修改的记录吗',function(btn){
				         $('#dictGrid').datagrid('unselectAll');
                         if(btn&&dictId!=null&&dictId!=''){
                            $.ajax({
                            	dataType:'json',
    							url:'dictDef_saveDictDef.action',
    							data:{
    							      'dictDefUuid':dictDefUuid,
                                      'dictId':dictId,
                                      'dictName':dictName  
    							},
    							type:'post',
    							success:function(data){
    									lastIndex = '';
        								$.messager.alert('系统提示','保存成功','warning');
        								$('#dictGrid').datagrid('reload');
        					    }
                            });
                         }   
				});
                }
			}
		},{
			text:'取消',
			iconCls:'icon-undo',
			handler:function(){
				$('#dictGrid').datagrid('rejectChanges');
				lastIndex = '';
			} 
		}],
		onBeforeLoad:function(){
			$(this).datagrid('rejectChanges');
		},
		onDblClickRow:function(rowIndex,rowData){
			if (lastIndex != rowIndex){
				$('#dictGrid').datagrid('endEdit', lastIndex);
				lastIndex = rowIndex;
				$('#dictGrid').datagrid('beginEdit', rowIndex);
			}
		}
	});
	var pager = $('#dictGrid').datagrid('getPager');
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
<div class="mar_30 majorword">
	<FORM name="formSearch" id="formSearch" method="post">
	<INPUT name="pageNo" type="hidden" value="${param.pageNo}"> 
	类型编号：
	<input class="input_eq" type="text" id="dictId" name="dictId"/>
	类型名称：
	<input class="input_eq" type="text" id="dictName" name="dictName"/>
	<input class="inputd" type="button" value="查  询" onclick="query()"/>
	<input class="inputd" type="button" value="重  置" onclick="reset()"/>
	</FORM>
	<div class="clear"></div>
</div>
<div class="gridDiv">
   <table id="dictGrid" ></table>
</div>
</body>
</html>