<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<%@ page import="com.vprisk.rmplatform.util.MessageUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>字典管理</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css"></link>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>

<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<script type="text/javascript">
var _defGrid_lastIndex;
var _itemGrid_lastIndex;

$.extend($.fn.datagrid.methods, {
	addEditor : function(jq, param) {
		if (param instanceof Array) {
			$.each(param, function(index, item) {
				var e = $(jq).datagrid('getColumnOption', item.field);
				e.editor = item.editor;
			});
		} else {
			var e = $(jq).datagrid('getColumnOption', param.field);
			e.editor = param.editor;
		}
	},
	removeEditor : function(jq, param) {
		if (param instanceof Array) {
			$.each(param, function(index, item) {
				var e = $(jq).datagrid('getColumnOption', item);
				e.editor = {};
			});
		} else {
			var e = $(jq).datagrid('getColumnOption', param);
			e.editor = {};
		}
	}
});
$.extend($.fn.validatebox.defaults.rules, {
	dictId: {
        validator: function (value) {
			if(!/^[a-zA-Z0-9_]+$/.test(value)){
				$.fn.validatebox.defaults.rules.dictId.message ="只可输入字母数字_！";
	            return false;
			}else{
				$.fn.validatebox.defaults.rules.dictId.message ="";
			}
			$('#defGrid').datagrid('unselectAll');
			$('#defGrid').datagrid('selectRow',_defGrid_lastIndex);
			var row = $('#defGrid').datagrid('getSelected');
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
 	},
	dictKey: {
        validator: function (value) {
			if(!/^[a-zA-Z0-9_-]+$/.test(value)){
				$.fn.validatebox.defaults.rules.dictKey.message ="只可输入字母数字_！";
	            return false;
			}else{
				$.fn.validatebox.defaults.rules.dictKey.message ="";
			}
			$('#itemGrid').datagrid('unselectAll');
			$('#itemGrid').datagrid('selectRow',_itemGrid_lastIndex);
			var itemRow = $('#itemGrid').datagrid('getSelected');
			var uuid = itemRow.uuid;
			var dictDefUuid = $('#currentDictUuid').val();
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
				return false;
			}
	    },
   		 message: ''
 	}
});

function defQuery(){
	var dictId=$('#dictId').val();
	var dictName=$('#dictName').val();
	var sysFlag=$('#sysFlag').combobox('getValue');
	$('#defGrid').datagrid('load', {
		dictId:dictId,
		dictName:dictName,
		sysFlag:sysFlag
	});    
 } 
function defReset(){
	document.$("#defQueryForm").reset();
 }
function itemQuery(){
	var dictKey=$('#dictKey').val();
	var dictValue=$('#dictValue').val();
	var status=$('#status').combobox('getValue');
	$('#itemGrid').datagrid('load', {
		dictKey:dictKey,
		dictValue:dictValue,
		status:status
	});     
 } 
function itemReset(){
	document.$("#itemQueryForm").reset();
 }

$(function(){
	$('.gridDiv0').height($('.gridDiv0').parent().parent().height() - 78);
	$('.gridDiv1').height($('.gridDiv1').parent().parent().height() - 78);
});
	$(function(){
		$('#defGrid').datagrid({
			width:'100%',
			height:'100%',
			fit:true,
			nowrap:false,						//是否换行
			striped:true,						//是否隔行换色
			collapsible:false,					//是否增加收起表格组件的按钮
			url:'${pageContext.request.contextPath}/dictDef_asyFindDictDefs.action',	
			pagination:true,
			sortName:'dictId',
			sortOrder:'asc',
			pageSize:15,
			columns:[[
				{field:'uuid', checkbox:true, width:20},
				{field:'dictId', title:"类型编号", align:'left', width:200,
					editor:{
						type:'validatebox',
						options:{
							validType:'dictId',
							required:true,
							missingMessage:'必输项'
						}
					}
				},
				{field:'dictName', title:"类型名称", align:'left', width:200,editor:'text'},
				{field:'sysFlag', title:"字典种类", align:'left', width:120,
					formatter:function(value){
		       			if(value == '1') {
			       			return "系统字典";
			       		} else if(value != '1') {
				       		return "业务字典";
				       	}
		    		},
		    		styler:function(value){
						if (value == '1'){
							return 'color:red;';
						}
					}
				}
			]],
			toolbar:[{//工具栏
				id:'defAddButton',
				text:'增加',
				iconCls:'icon-add',
				handler:function(){
				if($.trim(_defGrid_lastIndex)!=''){
					$('#defGrid').datagrid('endEdit', _defGrid_lastIndex);				
				}else{
					$('#defSaveButton').linkbutton({disabled:false});
					$('#defUndoButton').linkbutton({disabled:false});
					$('#defRemoveButton').linkbutton({disabled:true});
					$('#defSysmrgButton').linkbutton({disabled:true});
				}
				$('#defGrid').datagrid('addEditor',{
					field:'sysFlag',
					editor:{
						type:'combobox',
						options:{
							data:[{'id':'0','text':'业务字典'},{'id':'1','text':'系统字典'}],
							textField:'text',
							valueField:'id',
							panelHeight:40
						}
					}
				});
				$('#defGrid').datagrid('appendRow',{
					uuid:'',
					dictId:'',
					dictName:'',
					sysFlag:'0'
				});
				_defGrid_lastIndex = $('#defGrid').datagrid('getRows').length-1;
				$('#defGrid').datagrid('selectRow', _defGrid_lastIndex);
				$('#defGrid').datagrid('beginEdit', _defGrid_lastIndex);	
				}
			}, {
				id:'defRemoveButton',
				text:'删除',
				iconCls:'icon-remove',
				handler:function() {
				if($.trim(_defGrid_lastIndex)!=''){
					$('#defGrid').datagrid('endEdit', _defGrid_lastIndex);
				}
				var insertedRows = $('#defGrid').datagrid('getChanges','inserted');
				var updatedRows=$('#defGrid').datagrid('getChanges','updated');
				var deletedRows=$('#defGrid').datagrid('getSelections'); 
				if(deletedRows.length==0){
					$.messager.alert('系统提示','请选择要删除的字典项！','warning');
					return false;
			    }else if(insertedRows.length!=0||updatedRows.length!=0){
			    	$.messager.alert('系统提示','尚有修改的字典项未作保存，请先保存！','warning');
	                return false;
	            }else{
					var dictDefDelUuid='';
					var isHaveSysflag=false;
                	for(var k=0;k<deletedRows.length;k++){
    					dictDefDelUuid+=deletedRows[k].uuid+',';
    					if(deletedRows[k].sysFlag == '1'){
    						isHaveSysflag = true;
    					}
    			    }
                	if(isHaveSysflag){
                		$.messager.alert('系统提示','要删除的字典项中包含系统字典，不允许删除！','warning');
    	                return false;
                	}else{
		            	$.messager.confirm('系统提示','确定要删除选中的记录吗',function(btn){
		                	if(btn){
			                	 $.ajax({
			                      	dataType:'json',
										url:'dictDef_removeDictDef.action',
										data:{
										      'dictDefUuid':dictDefDelUuid
										},
									    type:'post',
										success:function(data){
											_defGrid_lastIndex='';
											$.messager.alert('系统提示','删除成功','warning');
											$('#defGrid').datagrid('reload');
				  					    }
				                     });
			                	}
			            	});
                		}
		            }
				}
			},{
				id:'defSaveButton',
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					if($.trim(_defGrid_lastIndex)!=''){
						$('#defGrid').datagrid('endEdit', _defGrid_lastIndex);
					}
					var allRows = $('#defGrid').datagrid('getRows');
					var flag = true;
					for(var i=0;i<allRows.length;i++){
						if(!$('#defGrid').datagrid('validateRow',i)){
							flag = false;
						}
					}
					if(!flag){
						$.messager.alert('系统提示','尚有数据未通过校验，不能保存！','warning');
			             return false;
					}
					var insertedRows = $('#defGrid').datagrid('getChanges','inserted');
					var updatedRows=$('#defGrid').datagrid('getChanges','updated');
					var dictDefUuid='';
					var dictId='';
					var dictName='';
					var sysFlag='';				
	                if(insertedRows.length==0&&updatedRows.length==0){
	                    _defGrid_lastIndex = '';
	                    $('#defRemoveButton').linkbutton({disabled:false});
						$('#defSysmrgButton').linkbutton({disabled:false});
						$('#defSaveButton').linkbutton({disabled:true});
						$('#defUndoButton').linkbutton({disabled:true});
	                    return false;
	                }else{
	    		    for(var i=0;i<insertedRows.length;i++){
	    				dictDefUuid+=insertedRows[i].uuid+',';
	    				dictId+=insertedRows[i].dictId+',';
	    				dictName+=insertedRows[i].dictName+',';
	    				sysFlag+=insertedRows[i].sysFlag+',';
	    			}
					for(var j=0;j<updatedRows.length;j++){
						dictDefUuid+=updatedRows[j].uuid+',';
						dictId+=updatedRows[j].dictId+',';
						dictName+=updatedRows[j].dictName+',';
						sysFlag+=updatedRows[j].sysFlag+',';
				    }
				    $.messager.confirm('系统提示','确定要保存修改的记录吗',function(btn){
					         $('#defGrid').datagrid('unselectAll');
	                         if(btn&&dictId!=null&&dictId!=''){
	                            $.ajax({
	                            	dataType:'json',
	    							url:'dictDef_saveDictDef.action',
	    							data:{
	    							      'dictDefUuid':dictDefUuid,
	                                      'dictId':dictId,
	                                      'dictName':dictName,
	                                      'sysFlag':sysFlag
	    							},
	    							type:'post',
	    							success:function(data){
	    									_defGrid_lastIndex = '';
	        								$.messager.alert('系统提示','保存成功','warning');
	        								$('#defGrid').datagrid('reload');
	        								 $('#defRemoveButton').linkbutton({disabled:false});
	        									$('#defSysmrgButton').linkbutton({disabled:false});
	        									$('#defSaveButton').linkbutton({disabled:true});
	        									$('#defUndoButton').linkbutton({disabled:true});
	        					    }
	                            });
	                         }   
					});
	                }
				}
			},{
				id:'defUndoButton',
				text:'取消',
				iconCls:'icon-undo',
				handler:function(){
					$('#defGrid').datagrid('rejectChanges');
					_defGrid_lastIndex = '';
					$('#defRemoveButton').linkbutton({disabled:false});
					$('#defSysmrgButton').linkbutton({disabled:false});
					$('#defSaveButton').linkbutton({disabled:true});
					$('#defUndoButton').linkbutton({disabled:true});
				} 
			},{
				id:'defSysmrgButton',
				text:'查看业务字典',
				iconCls:'icon-sysmrg',
				handler:function(){
				var changeRows=$('#defGrid').datagrid('getChanges');
				if(changeRows.length>0){
					$.messager.alert('系统提示','尚有未保存的修改，请先进行保存操作','warning');
					return false;
			    }
				var selected=$('#defGrid').datagrid('getSelections');
				if(selected.length == 0) {
					$.messager.alertSelf('系统提示','请选择要查看的字典项！','warning','160px','200px');
					return false;
				}
				if(selected.length >1) {
					$.messager.alertSelf('系统提示','只能选择一个字典项进行查看！','warning','160px','200px');
					return false;
				}
				$('#itemGrid').datagrid('unselectAll');
				
				$('#currentDictUuid').val(selected[0].uuid);		
				$('#currentDictName').val(selected[0].dictName);
				var defSysflag = selected[0].sysFlag;
				$('#currentDictSysflag').val(defSysflag);
				
				
				
				$('#itemGrid').datagrid({
					'url':'${pageContext.request.contextPath}/dictItem_asyFindDictItems.action?dictDef='+selected[0].uuid,
					'queryParams':{status:'1'},
					'onLoadSuccess':function(){
						$('#itemAddButton').linkbutton({disabled:false});
						if(defSysflag && defSysflag =='1'){
							$('#itemRemoveButton').linkbutton({disabled:true});	
						}else{
							$('#itemRemoveButton').linkbutton({disabled:false});	
						}
						$('#itemSaveButton').linkbutton({disabled:true});
						$('#itemUndoButton').linkbutton({disabled:true});
					}
					});
				//$('#dictItemPanel').panel('open',true);
				$('#dictItemPanel').show();
			}
				}],
			onBeforeLoad:function(){
			$(this).datagrid('rejectChanges');
		},
			onDblClickRow:function(rowIndex,rowData){
			if ($.trim(_defGrid_lastIndex)!='' && _defGrid_lastIndex != rowIndex){
				$('#defGrid').datagrid('endEdit', _defGrid_lastIndex);
			}
				$('#defGrid').datagrid('unselectAll');
				$('#defGrid').datagrid('selectRow',rowIndex);
				var row = $('#defGrid').datagrid('getSelected');
				if(row.sysFlag == '1'){
					$.messager.alert('系统提示','系统字典项，不允许进行修改操作','warning');
					return false;
				}
				
				$('#defSaveButton').linkbutton({disabled:false});
				$('#defUndoButton').linkbutton({disabled:false});
				$('#defRemoveButton').linkbutton({disabled:true});
				$('#defSysmrgButton').linkbutton({disabled:true});
				
				_defGrid_lastIndex = rowIndex;
				$('#defGrid').datagrid('removeEditor','sysFlag');
				$('#defGrid').datagrid('beginEdit', _defGrid_lastIndex);
		}
		});
		$('#defSaveButton').linkbutton({disabled:true});
		$('#defUndoButton').linkbutton({disabled:true});
		
		$('#itemGrid').datagrid({
			width:'100%',
			height:'100%',
			fit: true,
			nowrap:false,						//是否换行
			striped:true,						//是否隔行换色
			collapsible:false,					//是否增加收起表格组件的按钮
			url:'',//请求数据的url
			sortName: 'sortNo',
			sortOrder: 'asc',
			pagination:true,
			queryParams:{status:'1'},
			columns:[[
				{field:'uuid', checkbox:true, width:20},
				{field:'sysFlag', title:"字典种类", align:'left', width:90,
					formatter:function(value){
		       			if(value == '1') {
			       			return "系统字典";
			       		} else if(value != '1') {
				       		return "业务字典";
				       	}
		    		},
		    		styler:function(value){
						if (value == '1'){
							return 'color:red;';
						}
					}
				},
				{field:'filter1', title:"字典类型", align:'left', width:120,
					formatter:function(value,rowData, rowIndex){
						return $('#currentDictName').val();
					}
				},
				{field:'dictKey', title:"字典编号", align:'left', width:90,
					editor:{
						type:'validatebox',
						options:{
							validType:'dictKey',
							required:true,
							missingMessage:'必输项'
						}
					}
				},
				{field:'dictValue', title:"字典名称", align:'left', width:90,
					editor:{
						type:'validatebox',
						options:{
							required:true,
							missingMessage:'必输项'
						}
					}
				},
				{field:'status', title:"是否启用", align:'left', width:90,editor:'text',
					editor:{
						type:'combobox',
						options:{
							data:[{"id":"1","text":"启用"},{"id":"0","text":"撤销"}],
							valueField:'id',
							textField:'text',
							editable:false,
							panelHeight:40
						}
					},
					formatter:function(value){
		       			if(value == '1') {
				       		return "启用";
			       		} else{
			       			return "撤销";
				       	}
		    		},
		    		styler:function(value){
						if (value != '1'){
							return 'color:red;';
						}
					}
				},
				{field:'sortNo', title:"显示顺序", align:'left', width:90,editor:'text',sortable:true}
			]],
			toolbar:[{
				id:'itemAddButton',
				text:'添加',
				iconCls:'icon-add',
				handler:function(){
					if($.trim(_itemGrid_lastIndex)!=''){
						$('#itemGrid').datagrid('endEdit', _itemGrid_lastIndex);
					}else{
						$('#itemRemoveButton').linkbutton({disabled:true});
						$('#itemSaveButton').linkbutton({disabled:false});
						$('#itemUndoButton').linkbutton({disabled:false});
					}
					var defSysFalg=$('#currentDictSysflag').val();
					_itemGrid_lastIndex = $('#itemGrid').datagrid('getRows').length;
					$('#itemGrid').datagrid('appendRow',{
						uuid:'',
						filter1:'',
						dictKey:'',
						dictValue:'',
						status:'1',
						sortNo:_itemGrid_lastIndex+1,
						sysFlag:defSysFalg
					});
					
					$('#itemGrid').datagrid('selectRow', _itemGrid_lastIndex);
					$('#itemGrid').datagrid('beginEdit', _itemGrid_lastIndex);
				}
			},{
				id:'itemRemoveButton',
				text:'删除',
				iconCls:'icon-remove',
				handler:function(){
					if($.trim(_itemGrid_lastIndex)!=''){
						$('#itemGrid').datagrid('endEdit', _itemGrid_lastIndex);
					}
						var insertedRows = $('#itemGrid').datagrid('getChanges','inserted');
						var updatedRows=$('#itemGrid').datagrid('getChanges','updated');
						var deletedRows=$('#itemGrid').datagrid('getSelections'); 
						var dictItemDelUuid='';
						if(deletedRows.length==0){
							$.messager.alert('系统提示','请选择要删除的字典！','warning');
							return false;
					    }else if(insertedRows.length!=0||updatedRows.length!=0){
					    	$.messager.alert('系统提示','尚有修改未作保存，请先保存！','warning');
		                	return false;
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
											$('#itemGrid').datagrid('reload');
				  					    }
				                     });
		                 	}
		             	});
		             }
				}
			},{
				id:'itemSaveButton',
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					var dictDefUuid=$('#currentDictUuid').val();
					var defSysflag=$('#currentDictSysflag').val();
					if($.trim(_itemGrid_lastIndex)!=''){
						$('#itemGrid').datagrid('endEdit', _itemGrid_lastIndex);
					}
					var allRows = $('#itemGrid').datagrid('getRows');
					var flag = true;
					for(var i=0;i<allRows.length;i++){
						if(!$('#itemGrid').datagrid('validateRow',i)){
							flag = false;
						}
					}
					if(!flag){
						$.messager.alert('系统提示','尚有数据未通过校验，不能保存！','warning');
			             return false;
					}
					$('#itemAddButton').linkbutton({disabled:false});
					if(defSysflag && defSysflag =='1'){
						$('#itemRemoveButton').linkbutton({disabled:true});	
					}else{
						$('#itemRemoveButton').linkbutton({disabled:false});	
					}
					$('#itemSaveButton').linkbutton({disabled:true});
					$('#itemUndoButton').linkbutton({disabled:true});
					var changeRows = $('#itemGrid').datagrid('getChanges');
					var dictItemUuid='';
					var dictKey='';
					var dictValue='';
					var status='';
					var sortNo='';
					var json='[';
		            if(changeRows.length==0){
		                $.messager.alert('系统提示','数据字典未作修改！','warning');
		                _itemGrid_lastIndex = '';
		                return false;
		            }else{
					    for(var i=0;i<changeRows.length;i++){
							dictItemUuid+=changeRows[i].uuid+',';
							dictKey+=changeRows[i].dictKey+',';
							dictValue+=changeRows[i].dictValue+',';
							status+=changeRows[i].status+',';
							sortNo+=changeRows[i].sortNo+',';
							json+='{"uuid":"'+changeRows[i].uuid+'","dictKey":"'+changeRows[i].dictKey+'","dictValue":"'+changeRows[i].dictValue+'","status":"'+changeRows[i].status+'","sortNo":"'+changeRows[i].sortNo+'","sysFlag":"'+defSysflag+'"}';
							if(i<changeRows.length-1){
								json+=',';
							}
						}
						json+=']';
					    $.messager.confirm('系统提示','确定要保存修改的记录吗',function(btn){
					         $('#itemGrid').datagrid('unselectAll');
		                     if(btn&&dictDefUuid&&dictDefUuid!=null&&dictDefUuid!=''&&dictKey!=null&&dictKey!=''){
		                        $.ajax({
		                        	dataType:'json',
									url:'dictItem_saveDictItem.action?dictDefUuid='+dictDefUuid,
									data: {
										params:json
									},
									type:'post',
									success:function(data){
		     					       _itemGrid_lastIndex = '';
										if(data){
											$.messager.alert('系统提示',data[0].errorMessage,'error');
										}else{
		    								$.messager.alert('系统提示','保存成功','warning');
		    								$('#itemGrid').datagrid('load');
										}
		    								if(defSysflag && defSysflag =='1'){
		    									$('#itemRemoveButton').linkbutton({disabled:true});	
		    								}else{
		    									$('#itemRemoveButton').linkbutton({disabled:false});	
		    								}
		    								$('#itemSaveButton').linkbutton({disabled:true});
		    								$('#itemUndoButton').linkbutton({disabled:true});
		    					    }
		                        });
		                     }   
						});
		            }
				}
			},{
				id:'itemUndoButton',
				text:'取消',
				iconCls:'icon-undo',
				handler:function(){
					$('#itemGrid').datagrid('rejectChanges');
					_itemGrid_lastIndex = '';
					var defSysflag=$('#currentDictSysflag').val();
					if(defSysflag && defSysflag =='1'){
						$('#itemRemoveButton').linkbutton({disabled:true});	
					}else{
						$('#itemRemoveButton').linkbutton({disabled:false});	
					}
					$('#itemSaveButton').linkbutton({disabled:true});
					$('#itemUndoButton').linkbutton({disabled:true});
				} 
			}],
			onBeforeLoad:function(){
				$(this).datagrid('rejectChanges');
			},
			onDblClickRow:function(rowIndex,rowData){
				if ($.trim(_itemGrid_lastIndex)!='' &&_itemGrid_lastIndex != rowIndex){
					$('#itemGrid').datagrid('endEdit', _itemGrid_lastIndex);
				}
				var defSysflag=$('#currentDictSysflag').val();
				if(defSysflag == '1'){
					$.messager.alert('系统提示','系统字典项，不允许进行修改操作','warning');
					return false;
				}
				$('#itemRemoveButton').linkbutton({disabled:true});
				$('#itemSaveButton').linkbutton({disabled:false});
				$('#itemUndoButton').linkbutton({disabled:false});
				
					_itemGrid_lastIndex = rowIndex;
					$('#itemGrid').datagrid('beginEdit', rowIndex);
			}
		});
		$('#itemAddButton').linkbutton({disabled:true});
		$('#itemRemoveButton').linkbutton({disabled:true});
		$('#itemSaveButton').linkbutton({disabled:true});
		$('#itemUndoButton').linkbutton({disabled:true});
	});

	/////////////////////////////////////////////////////////////////////////////////////////////
	
</script>
<style type="text/css">
.input_file{width:260px; margin-left:-260px;height:21px; filter:alpha(opacity=0); opacity:0;}
.save_btn{border:0px; width:56px;height:21px;background:url(../images/save_btn.jpg);
	font-family:'Microsoft YaHei';
	font-size:12px;
	padding-left:10px;
	padding-top:0px;
}
.inputd
{
  width:50px;
}
.save_btn:hover{border:0px; width:56px;height:21px;background:url(../images/save_btn_hover.jpg)}

</style>
</head>
<body class="easyui-layout" border="false" >
	<div region="west" style="width:530px; border-left: none; padding-bottom:63px;overflow: hidden;"  border="true" title=
	"字典项管理">	
		<FORM name="defQueryForm" id="defQueryForm" method="post" style="padding: 10px 0px 10px 10px;">
			<INPUT name="pageNo" type="hidden" value="${param.pageNo}"> 
			类型编号：
				<input type="text" name="dictId" id="dictId" class="input_eq" style="width:60px"/>
			类型名称：
				<input type="text" name="dictName" id="dictName" class="input_eq" style="width:60px"/>
			字典种类：
				<select name="sysFlag" id="sysFlag" class="easyui-combobox"  style="width:80px;" value="${param.status}">
					<option value="">--请选择--</option>
					<option value="0">业务字典</option>
					<option value="1">系统字典</option>
				</select>
				<input class="inputd" type="button" value="查 询" onclick="defQuery()" />
				<input class="inputd" type="reset" value="重 置" onclick="defReset()"/>
		</FORM>
		<div class="gridDiv0">
			<table id="defGrid"></table>
		</div>
	</div>
	<div region="center"style="width:450px; border-left: none;overflow: hidden;" border="true" title="业务字典管理 "  id="aaaa">
		<FORM name="itemQueryForm" id="itemQueryForm" method="post" style="padding: 10px 0px 10px 10px;">
			<input type="hidden" id="currentDictUuid"/>
			<input type="hidden" id="currentDictName"/>
			<input type="hidden" id="currentDictSysflag"/>
			
			字典编号：
			<input class="input_eq" type="text" id="dictKey" name="dictKey" value="${param.dictKey}" style="width:80px"/>
			
			字典名称：
			<input class="input_eq" type="text" id="dictValue" name="dictValue" value="${param.dictValue}" style="width:80px"/>
			状态：
			<select name="status" id="status" class="easyui-combobox"  style="width:80px;">
				<option value="">--请选择--</option>
				<option value="1" selected="selected">启用</option>
				<option value="0">撤销</option>
			</select>

			<input id="itemQueryButton" class="inputd" type="button" value="查  询" onclick="itemQuery()"/>
			<input id="itemResetButton" class="inputd" type="button" value="重  置" onclick="itemReset()"/>     
		</FORM>
		<div class="gridDiv1">
	  		<table id="itemGrid"></table>
		</div>
	</div> 
</body>
</html>