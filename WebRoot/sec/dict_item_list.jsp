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
	var dictKey=$('#dictKey').val();
	var dictValue=$('#dictValue').val();
	var status=$('#status').val();
	var def=$('#def').combobox('getValue');
	$('#dictGrid').datagrid('load', {
		dictDef:def,
		dictKey:dictKey,
		dictValue:dictValue,
		status:status
	});    
 } 
function reset(){
	document.$("#formSearch").reset();
 }

$(function(){
	
	var lastIndex;
	$.extend($.fn.validatebox.defaults.rules, {
		dictKey: {
	        validator: function (value) {
				if(!/^[a-zA-Z0-9_]+$/.test(value)){
					$.fn.validatebox.defaults.rules.dictKey.message ="只可输入字母数字_！";
		            return false;
				}else{
					$.fn.validatebox.defaults.rules.dictKey.message ="";
				}
				$('#dictGrid').datagrid('unselectAll');
				$('#dictGrid').datagrid('selectRow',lastIndex);
				var row = $('#dictGrid').datagrid('getSelected');
				var uuid = row.uuid;
				var target = $('#dictGrid').datagrid('getEditor',{
					'index' : lastIndex,
					'field' : 'dictDef'
				}).target;
				var dictDefUuid = target.combobox('getValue');
				if(dictDefUuid){
					var exist=$.ajax({
			                url:"${pageContext.request.contextPath}/dictItem_checkDictKey.action",
			                data:{uuid:uuid,dictDefUuid:dictDefUuid,dictKey:value},
			                async:false
			        }).responseText;
					if(exist=="false"){
				            $.fn.validatebox.defaults.rules.dictKey.message ="";
				            return true;
				    }else{
				        	$.fn.validatebox.defaults.rules.dictKey.message ="该类型下的字典编号已存在，无法使用！";
				            return false;
					}
				}else{
					$.fn.validatebox.defaults.rules.dictKey.message ="请先先选择字典类型";
				}
		    },
	   		 message: ''
	 	}
	});
	
	$('#def').combobox({
		url:'dictDef_getDictDefAll.action',
		valueField:'uuid',
		textField:'dictName'
	});

	var height = $('.gridDiv').parent().parent()[0].clientHeight - $("#formSearch").height() - 74;
	$('.gridDiv').height(height);
	
	var temp;
	$('#dictGrid').datagrid({
		title:'业务字典管理',
		width:'100%',
		height:385,
		fit: true,
		nowrap:false,						//是否换行
		striped:true,						//是否隔行换色
		collapsible:false,					//是否增加收起表格组件的按钮
		url:'${pageContext.request.contextPath}/dictItem_asyFindDictItems.action',//请求数据的url
		sortName: 'dictDef',
		sortOrder: 'asc',
		pagination:true,
		queryParams:{status:'1'},
		columns:[[
			{field:'uuid', checkbox:true, width:20},
			{field:'dictDef', title:"字典类型", align:'center', width:210,
				editor:{
					type:'combobox',
					options:{
						url:'dictDef_getDictDefAll.action',
						valueField:'uuid',
						textField:'dictName',
						required:true,
						missingMessage:'必输项',
						onSelect:function(record){
				 			temp = record;
						}
					}
				},
				formatter:function(value,rowData, rowIndex){
					if(rowData.dictDef &&(!rowData.dictDef.uuid)){
						rowData.dictDef = temp;
					}
					if(rowData.dictDef != null) {
						return rowData.dictDef.dictName;
					}
				}
			},
			{field:'dictKey', title:"字典编号", align:'center', width:210,
				editor:{
					type:'validatebox',
					options:{
						validType:'dictKey',
						required:true,
						missingMessage:'必输项'
					}
				}
			},
			{field:'dictValue', title:"字典名称", align:'center', width:210,
				editor:{
					type:'validatebox',
					options:{
						required:true,
						missingMessage:'必输项'
					}
				}
			},
			{field:'status', title:"是否启用", align:'center', width:210,editor:'text',
				editor:{
					type:'combobox',
					options:{
						data:[{"id":"1","text":"启用"},{"id":"0","text":"撤销"}],
						valueField:'id',
						textField:'text'
					}
				},
				formatter:function(value){
	       			if(value == '1') {
		       			return "启用";
		       		} else if(value == "0") {
			       		return "撤销";
			       	}
	    		},
	    		styler:function(value){
					if (value != '1'){
						return 'color:red;';
					}
				}
			},
			{field:'sortNo', title:"显示顺序", align:'center', width:209,editor:'text',sortable:true}
		]],
		toolbar:[{
			text:'添加',
			iconCls:'icon-add',
			handler:function(){
				$('#dictGrid').datagrid('endEdit', lastIndex);
				$('#dictGrid').datagrid('appendRow',{
					uuid:'',
					dictDef:'',
					dictKey:'',
					dictValue:'',
					status:'',
					sortNo:''
				});
				lastIndex = $('#dictGrid').datagrid('getRows').length-1;
				$('#dictGrid').datagrid('selectRow', lastIndex);
				var def = $('#dictGrid').datagrid('getSelected');
				temp = {
						uuid:'',
						dictId:'',
						dictName:''
						};
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
					var dictItemDelUuid='';
					if(deletedRows.length==0){
						$.messager.alert('系统提示','请选择要删除的字典！','warning');
				    }else if(insertedRows.length!=0||updatedRows.length!=0){
				    	$.messager.alert('系统提示','尚有修改未作保存，请先保存！','warning');
	                 return
	             }else{
	             	$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
	                 	if(btn){
			                	for(var k=0;k<deletedRows.length;k++){
			    					dictItemDelUuid+=deletedRows[k].uuid+',';
			    			    }
			                	 $.ajax({
			                      	dataType:'json',
										url:'dictItem_removeDictItem.action',
										data:{
										      'dictItemUuid':dictItemDelUuid
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
				var allRows = $('#dictGrid').datagrid('getRows');
				var flag = true;
				for(var i=0;i<allRows.length;i++){
					if(!$('#dictGrid').datagrid('validateRow',i)){
						flag = false;
					}
				}
				if(!flag){
					$.messager.alert('系统提示','尚有数据未通过校验，不能保存！','warning');
					lastIndex = '';
		             return
				}
				var changeRows = $('#dictGrid').datagrid('getChanges');
				var dictItemUuid='';
				var dictDefUuid='';
				var dictKey='';
				var dictValue='';
				var status='';
				var sortNo='';
				var json='[';
	            if(changeRows.length==0){
	                $.messager.alert('系统提示','数据字典未作修改！','warning');
	                lastIndex = '';
	                return
	            }else{
			    for(var i=0;i<changeRows.length;i++){
					dictItemUuid+=changeRows[i].uuid+',';
					dictDefUuid+=changeRows[i].dictDef+',';
					dictKey+=changeRows[i].dictKey+',';
					dictValue+=changeRows[i].dictValue+',';
					status+=changeRows[i].status+',';
					sortNo+=changeRows[i].sortNo+',';
					json+='{"uuid":"'+changeRows[i].uuid+'","dictDefUuid":"'+changeRows[i].dictDef.uuid+'","dictKey":"'+changeRows[i].dictKey+'","dictValue":"'+changeRows[i].dictValue+'","status":"'+changeRows[i].status+'","sortNo":"'+changeRows[i].sortNo+'"}';
					if(i<changeRows.length-1){
						json+=',';
					}
				}
				json+=']';
			    $.messager.confirm('系统提示','确定要保存修改的记录吗',function(btn){
			         $('#dictGrid').datagrid('unselectAll');
                     if(btn&&dictDefUuid!=null&&dictDefUuid!=''&&dictKey!=null&&dictKey!=''){
                        $.ajax({
                        	dataType:'json',
							url:'dictItem_saveDictItem.action',
							data: {
								params:json
							},
							type:'post',
							success:function(data){
								if(data){
									$.messager.alert('系统提示',data[0].errorMessage,'error');
								}else{
    								$.messager.alert('系统提示','保存成功','warning');
    								$('#dictGrid').datagrid('load');
								}
    					    }
                        });
                     }   
				});
	            }
	            lastIndex = '';
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
		onBeforeEdit:function(rowIndex, rowData){
			temp = rowData.dictDef;
			if(rowData.dictDef && rowData.dictDef.uuid){
				rowData.dictDef = rowData.dictDef.uuid;
			}else{
				rowData.dictDef = '';
			}
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
	字典类型：
	<select class="easyui-combobox" name="def" id="def"></select>
	字典编号：
	<input class="input_eq" type="text" id="dictKey" name="dictKey" value="${param.dictKey}"/>
	字典名称：
	<input class="input_eq" type="text" id="dictValue" name="dictValue" value="${param.dictValue}"/>
	状态：
	<select name="status" id="status" class="select2">
		<rmp:option dictId="sys.status" defaultValue="1" currentValue="${param.status}"  prompt="--请选择--"></rmp:option>
	</select>
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