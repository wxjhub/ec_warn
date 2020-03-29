<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/richweb" prefix="r"%>
<%@ taglib uri="http://www.vprisk.com/tags/html" prefix="h"%>
<%@ taglib uri="/WEB-INF/tld/rmp.tld" prefix="rmp"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN"
	xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>交易成功率监控配置</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/js/all.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css"
	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css"
	rel="stylesheet" type="text/css" />
<style type="text/css">
body {
	font-family: "微软雅黑";
}

.font {
	color: red
}

.input_file {
	width: 140px;
	margin-left: -140px;
	height: 21px;
	filter: alpha(opacity = 0);
	opacity: 0;
}
</style>

<script type="text/javascript">
	$(function() {
		$('.gridDiv').height(
				$('.gridDiv').parent().parent()[0].clientHeight - 63);
	});
	
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post"
		style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">预警模块：</td>
				<td height="40px">
				     <r:dictCombobox id="warnModuleCode" panelHeight="150px" name="warnModuleCode" dictId="warn_module_type" style="width:156px;" nullText=""></r:dictCombobox>
			     </td>
				<td height="40px">预警级别：</td>
				<td height="40px">
				     <r:dictCombobox id="warnLevl" name="warnLevl" dictId="ec.warnLvl" style="width:156px;" nullText=""></r:dictCombobox>
			     </td>
				<td height="40px">预警次数：</td>
				<td height="40px">
				     <r:dictCombobox id="warnNum" name="warnNum" dictId="warn_module_num" style="width:156px;" nullText=""></r:dictCombobox>
			     </td>
				<td height="40px">
				    <input id="filter_submit" class="inputd" type="button" value="查询" onclick="submitBtn()" /> 
					<input id="filter_reset" class="inputd" type="reset" onclick="resetBtn()" value="重 置" />
				</td>
			</tr>
		</table>
	</form>

	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true" 
			idField="uuid" rownumbers="false" singleSelect="false" editable="true" url="warnModuleConfig_query.action?sort=warnModuleCode"
			striped="true" fit="true" height="100%" title="预警告警配置" id="warnModuleGrid">
			<r:toolbar id="addRow" text="增加" iconCls="icon-add" onClick="appendRow();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit" onClick="editParam();"></r:toolbar>
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
			<r:toolbar text="删除" iconCls="icon-remove" onClick="remove();"></r:toolbar>
			<r:col field="uuid" title="ID" checkbox="true" sortable="true" width="260" editable="false">
			</r:col>
			<r:col  field="warnModuleCode" title="预警模块" sortable="true"  width="200" dictId="warn_module_type">
			<r:editorDictSelect missingMessage="预警模块不能为空" required="true" panelHeight="150px"></r:editorDictSelect>
			</r:col>
			<r:col  field="warnLevl" title="预警级别" sortable="true"  width="100" dictId="ec.warnLvl" hidden="true">
			<r:editorDictSelect missingMessage="预警级别不能为空" required="true"></r:editorDictSelect>
			</r:col>
			<r:col  field="warnNum" title="预警次数" sortable="true"  width="100" dictId="warn_module_num">
			<r:editorDictSelect missingMessage="预警次数不能为空" required="true"></r:editorDictSelect>
			</r:col>
			<r:col field="warnRoundTimeS" title="轮循时间（秒）"  sortable="true" width="100">
				<r:editorText required="true"  validType="number[1,10]"></r:editorText>
			</r:col>
			<r:col field="warnDatadateScope" title="监控数据日期范围(T-天)"  sortable="true" width="200">
				<r:editorText required="true" validType="number[1,10]"></r:editorText>
			</r:col>
			<r:pagination id="pag"></r:pagination>
		</r:grid>
	</div>
</body>
<script>
    //双击和单击单元格事件
	function editDbClick(rowIndex){
		var ed = $('#warnModuleGrid').datagrid('getEditor', {index:rowIndex,field:'warnNum'});
		warnNumChange($(ed.target).combobox('getValue'),'');
	}
	//预警次数改变事件
	function warnNumChange(newV,oldV){
		var ed = $('#warnModuleGrid').datagrid('getEditor', {index:warnModuleGrid_index,field:'warnRoundTimeS'});
		if(ed == null){
			return;
		}
		if(newV == '01'){
			$(ed.target).attr('disabled',true);
			$(ed.target).val('');
		} else {
			$(ed.target).removeAttr('disabled');
		}
	}
	//重置查询信息
	function resetBtn() {
			$('#warnModuleCode').combobox('setValue','');
			$('#warnLevl').combobox('setValue','');
			$('#warnNum').combobox('setValue',''); 
	}
	//查询方法
	function submitBtn() {
		var options = $('#warnModuleGrid').datagrid("options");
		options.queryForm = "formSearch";
		$('#warnModuleGrid').datagrid("load");
	}
	//编辑方法
	function editParam() {
		var changes = $('#warnModuleGrid').datagrid('getChanges');
		if (!warnModuleGrid_index) {
			if (!(changes && changes.length > 0)) {
				var selected = warnModuleGrid.getAllSelected();
				if (selected.length == 0) {
					$.messager.alert('系统提示', '请选择一个要编辑的！', 'warning');
				} else if (selected.length > 1) {
					$.messager.alert('系统提示', '同时只能编辑一个！', 'warning');
				} else {
					var rownum = warnModuleGrid.getRowIndex(selected[0]);
					warnModuleGrid_index = rownum;
					$('#warnModuleGrid').datagrid('beginEdit',rownum);
					$('#editRow').removeAttr("disabled");
					$('#addRow').removeAttr("disabled");
					$('#editRow').attr('disabled', 'false');
					$('#addRow').attr('disabled', 'false');
				}
			}
		} else {
			$.messager.alert('系统提示', '当前有正在编辑！', 'warning');
		}
	}
    //取消编辑编辑页面
	function cancelEdit() {
		warnModuleGrid.endEdit(warnModuleGrid_index);
		warnModuleGrid_index = null;
		warnModuleGrid.rejectChanges();
		warnModuleGrid.unselectAll();
		$('#editRow').removeAttr("disabled");
		$('#addRow').removeAttr("disabled");
	}
    //保存方法
	function save() {
		warnModuleGrid.endEdit(warnModuleGrid_index);
		var vali = warnModuleGrid.validateRow(warnModuleGrid_index);
		if (vali) {
			var selected = warnModuleGrid.getChanges('inserted');

			if (selected.length > 1) {
				$.messager.alert('系统提示', '保存只能一个！', 'warning');
			} else {
				if (selected.length == 0) {
					selected = warnModuleGrid.getChanges('updated');
				}
				var uuid = selected[0].uuid;
				var warnModuleCode = selected[0].warnModuleCode;
				var warnLevl = selected[0].warnLevl;
				var warnNum = selected[0].warnNum;
				var warnRoundTimeS = selected[0].warnRoundTimeS;
				var warnDatadateScope = selected[0].warnDatadateScope;
				$.ajax({
							cache : false,
							type : 'post',
							dataType : "Json",
							data : {
								uuid : uuid,
								warnModuleCode : warnModuleCode,
								warnLevl : warnLevl,
								warnNum : warnNum,
								warnRoundTimeS : warnRoundTimeS,
								warnDatadateScope : warnDatadateScope
							},
							url : "warnModuleConfig_save.action",
							error : function(data) {
								$.messager.alert('系统提示', '当前数据请求失败，请联系管理员!',
										'warning');
							},
							success : function(data) {
								if (data == "1") {
									$.messager.alert('系统提示', '保存成功', 'warning');
									warnModuleGrid.reload();
									$('#editRow').removeAttr("disabled");
									$('#addRow').removeAttr("disabled");
									warnModuleGrid_index = null;
									warnModuleGrid.unselectAll();
								} else if (data == "2") {
									$.messager
											.alert('系统提示', '存在此数据', 'warning');
									warnModuleGrid.reload();
									$('#editRow').removeAttr("disabled");
									$('#addRow').removeAttr("disabled");
									warnModuleGrid_index = null;
									warnModuleGrid.unselectAll();
								} else if (data == "3") {
									$.messager.alert('系统提示', '保存失败', 'warning');
									warnModuleGrid.reload();
									$('#editRow').removeAttr("disabled");
									$('#addRow').removeAttr("disabled");
									warnModuleGrid_index = null;
									warnModuleGrid.unselectAll();
								} else {
									$.messager.alert('系统提示',
											'当前数据请求失败，请联系管理员!', 'warning');
									warnModuleGrid.unselectAll();
								}
							}
						});
			}
		}
	}
    //删除方法
	function remove() {
		$.messager
				.confirm(
						'系统提示',
						'确定要删除选中的记录吗',
						function(btn) {
							if (btn) {
								var uuids = [];
								var selected = warnModuleGrid.getAllSelected();
								for ( var i = 0; i < selected.length; i++) {
									uuids.push(selected[i].uuid);
								}
								if (selected.length == 0) {
									$.messager.alert('系统提示', '请选择要删除的记录','warning');
									return;
								} else {
									$.ajax({
												type : 'post',
												dataType : "Json",
												url : "${pageContext.request.contextPath}/warnModuleConfig_remove.action?uuid="
														+ uuids,
												success : function(data) {
													$.messager.alert('系统提示',
															'删除成功', 'warning');
													warnModuleGrid.unselectAll();
													warnModuleGrid.reload();

													$('#editRow').removeAttr(
															"disabled");
													$('#addRow').removeAttr(
															"disabled");
												}
											});
								}
							}
						});
	}
	//新增方法
	function appendRow() {
		var warnModuleGrid = $('#warnModuleGrid');
		warnModuleGrid.datagrid('unselectAll');
		var changes = warnModuleGrid.datagrid('getChanges');
		if (!warnModuleGrid_index && !(changes && changes.length > 0)) {
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled', 'false');
			$('#addRow').attr('disabled', 'false');
			var newrow = {
					warnModuleCode : '',
					warnLevl : '',
					warnNum : '',
					warnRoundTimeS : '',
					warnDatadateScope : ''
			};
			warnModuleGrid.datagrid('appendRow',newrow);
			var rows = warnModuleGrid.datagrid('getRows');
			warnModuleGrid_index = rows.length - 1;
			$('#warnModuleGrid').datagrid('selectRecord', null);
			warnModuleGrid.datagrid('beginEdit',rows.length - 1);
		} else {
			$.messager.alert('系统提示', '当前有正在编辑！', 'warning');
		}
	}
</script>
</html>

