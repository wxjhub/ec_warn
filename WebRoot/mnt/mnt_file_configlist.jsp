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
<title>文件参数配置</title>
<h:js src="jquery-1.7.2.min.js"></h:js>
<h:js src="jquery.easyui.min.js"></h:js>
<h:js src="default/grid.js"></h:js>
<h:js src="json2.js"></h:js>
<h:js src="default/pagination.js"></h:js>
<h:css src="/default/easyui.css"></h:css>
<h:css src="/icon.css"></h:css>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/dialog.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css.css" rel="stylesheet" type="text/css" />
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
	filter: alpha(opacity =      0);
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
				<td height="40px">系统名称： <select name="sysName" id="sysName">
						<option value="">---请选择---</option>
						<rmp:option dictId="sourseSys"></rmp:option>
				</select>
				</td>
				<td height="40px">预警级别： <select name="warnLevel" id="warnLevel">
						<option value="">---请选择---</option>
						<rmp:option dictId="ec.warnLvl"></rmp:option>
				</select>
				</td>

				<td><input id="filter_submit" class="inputd" type="button"
					value="查询" onclick="submi()" /> <input id="filter_reset"
					class="inputd" type="reset" onclick="rese()" value="重 置" /></td>
			</tr>
		</table>
	</form>

	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true"
			idField="uuid" rownumbers="false" singleSelect="false"
			editable="true" url="fileConfig_fileTranWarnList.action"
			striped="true" fit="true" height="100%" title="文件传输预警配置" id="lrmsMoni">
			<r:toolbar id="addRow" text="增加" iconCls="icon-add"
				onClick="appendRow();"></r:toolbar>
			<r:toolbar id="editRow" text="编辑" iconCls="icon-edit"
				onClick="editParam();"></r:toolbar>
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
			<r:toolbar text="取消" iconCls="icon-redo" onClick="cancelEdit();"></r:toolbar>
			<r:toolbar text="删除" iconCls="icon-remove" onClick="remove();"></r:toolbar>
			<r:col field="uuid" title="ID" checkbox="true" sortable="true"
				width="260" editable="false" hidden="flase">
			</r:col>
			<r:col field="sysName" title="系统名称" sortable="true" width="150" dictId="sourseSys">
				<r:editorDictSelect missingMessage="不能为空" required="true"> </r:editorDictSelect>
			</r:col>
			<r:col field="sysCode" title="系统号" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="fileName" title="文件名（系统号与日期中间名）" sortable="true" width="200">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="fileType" title="文件类型" sortable="true" width="100" dictId="filesys">
				<r:editorDictSelect missingMessage="文件类型不能为空" required="true" panelHeight="150px"></r:editorDictSelect>
			</r:col>
			<r:col field="fileSize" title="文件大小(最小值KB)" sortable="true" width="100">
				<r:editorText></r:editorText>
			</r:col>
			 <r:col field="fileRecTime" title="文件最晚到达时间" sortable="true"
				width="100" dictId="mon.time.hour">
				<r:editorDictSelect missingMessage="不能为空"  required="true"></r:editorDictSelect>
			</r:col> 
			<r:col field="fileNumber" title="文件个数" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="style" title="处理类型" sortable="true" width="150" dictId="file_style">
				<r:editorDictSelect required="false" panelHeight="150px"></r:editorDictSelect>
			</r:col>
			<r:col field="datePrice" title="日期差" editable="true" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="theOtherDay" title="前几天" editable="true" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="fixedDate" title="固定日期" sortable="true" width="150">
				<r:editorDate format="yyyy-MM-dd" />
			</r:col>
			<r:col field="dealTimeValuesY" title="处理时长预警阀值" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="dealTimeValuesG" title="处理时长告警阀值" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="dealFailTimeValues" title="处理失败告警阀值" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="rate" title="批量文件处理失败比率阀值" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			<r:col field="dealTime" title="文件预计处理的时长" sortable="true" width="150">
				<r:editorText></r:editorText>
			</r:col>
			
			<r:col field="warnLevel" title="预警级别" sortable="true" width="100"
				dictId="ec.warnLvl">
				<r:editorDictSelect missingMessage="不能为空"  required="true"></r:editorDictSelect>
			</r:col>
			<r:col field="remark" title="备注" sortable="true" width="400">
				<r:editorText></r:editorText>
			</r:col>
			
			<r:pagination id="pag"></r:pagination>
		</r:grid>

	</div>
</body>
<script>
	//重置查询信息
	function rese() {
		$("#sysName").val('');
		$("#warnLevel").val('');
	}

	function submi() {
		var jsonData = {
			sysName : $("#sysName").val(),
			warnLevel : $("#warnLevel").val(),
			newpage : 1,
			page : 1
		};
		lrmsMoni.load(jsonData);

	}
	function editParam() {
		var changes = lrmsMoni.getChanges();
		if (!lrmsMoni_index) {
			if (!(changes && changes.length > 0)) {
				var selected = lrmsMoni.getAllSelected();
				if (selected.length == 0) {
					$.messager.alert('系统提示', '请选择一个要编辑的！', 'warning');
				} else if (selected.length > 1) {
					$.messager.alert('系统提示', '同时只能编辑一个！', 'warning');
				} else {
					var rownum = lrmsMoni.getRowIndex(selected[0]);
					lrmsMoni_index = rownum;
					//lrmsMoni.removeEditor(['subjectId']);
					lrmsMoni.beginEdit(rownum);
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

	function cancelEdit() {
		lrmsMoni.endEdit(lrmsMoni_index);
		lrmsMoni_index = null;
		lrmsMoni.rejectChanges();
		$('#editRow').removeAttr("disabled");
		$('#addRow').removeAttr("disabled");
	}

	function save() {
		lrmsMoni.endEdit(lrmsMoni_index);
		var vali = lrmsMoni.validateRow(lrmsMoni_index);
		if (vali) {
			var selected = lrmsMoni.getChanges('inserted');

			if (selected.length > 1) {
				$.messager.alert('系统提示', '保存只能一个！', 'warning');
			} else {
				if (selected.length == 0) {
					selected = lrmsMoni.getChanges('updated');
				}
				var uuid = selected[0].uuid;
				var sysName = selected[0].sysName;
				var sysCode = selected[0].sysCode;
				var fileName = selected[0].fileName;
				var fileType = selected[0].fileType;
				var fileSize = selected[0].fileSize;
				var fileNumber= selected[0].fileNumber;
				var dealTimeValuesY = selected[0].dealTimeValuesY;
				var dealTimeValuesG = selected[0].dealTimeValuesG;
				var dealFailTimeValues = selected[0].dealFailTimeValues;
				var rate = selected[0].rate;
				var dealTime = selected[0].dealTime;
				var fileRecTime= selected[0].fileRecTime;
				var warnLevel = selected[0].warnLevel;
				var remark = selected[0].remark;
				var style = selected[0].style;
				var datePrice = selected[0].datePrice;
				var theOtherDay = selected[0].theOtherDay;
				var fixedDate = selected[0].fixedDate;
				$.ajax({
							cache : false,
							type : 'post',
							dataType : "Json",
							data : {
								uuid : uuid,
								sysName : sysName,
								sysCode : sysCode,
								fileName : fileName,
								fileType : fileType,
								fileSize : fileSize,
								fileNumber : fileNumber,
								dealTimeValuesY : dealTimeValuesY,
								dealTimeValuesG : dealTimeValuesG,
								dealFailTimeValues : dealFailTimeValues,
								rate : rate,
								dealTime : dealTime,
								fileRecTime : fileRecTime,
								warnLevel : warnLevel,
								remark : remark,
								style : style,
								datePrice : datePrice,
								theOtherDay : theOtherDay,
								fixedDate : fixedDate
							},
							url : "fileConfig_save.action",
							error : function(data) {
								$.messager.alert('系统提示', '当前数据请求失败，请联系管理员!',
										'warning');
							},
							success : function(data) {
								if (data == "1") {
									$.messager.alert('系统提示', '保存成功', 'warning');
									lrmsMoni.reload();
									$('#editRow').removeAttr("disabled");
									$('#addRow').removeAttr("disabled");
									lrmsMoni_index = null;
									lrmsMoni.unselectAll();
								}else if(data=="2"){
									$.messager.alert('系统提示','存在此数据','warning');
								 	lrmsMoni.reload();
								 	$('#editRow').removeAttr("disabled");
									$('#addRow').removeAttr("disabled");
									lrmsMoni_index = null;
									lrmsMoni.unselectAll();
								}
								else if (data == "3") {
									$.messager.alert('系统提示', '保存失败', 'warning');
									lrmsMoni.reload();
									$('#editRow').removeAttr("disabled");
									$('#addRow').removeAttr("disabled");
									lrmsMoni_index = null;
									lrmsMoni.unselectAll();
								} else {
									$.messager.alert('系统提示','当前数据请求失败，请联系管理员!', 'warning');
									lrmsMoni.unselectAll();
								}
							}
						});
			}
		} else {
			$.messager.alert('系统提示', '输入项有错误！', 'warning');
			
		}
	}
	function remove() {
		$.messager.confirm('系统提示', '确定要删除选中的记录吗', function(btn) {
			if (btn) {
				var uuids = [];
				var selected = lrmsMoni.getAllSelected();
				for ( var i = 0; i < selected.length; i++) {
					uuids.push(selected[i].uuid);
				}
				if (selected.length == 0) {
					$.messager.alert('系统提示', '请选择要删除的记录', 'warning');
					return;
				} else {

					$.ajax({

						type : 'post',
						dataType : "json",
						url : "fileConfig_remove.action?uuids=" + uuids,
						success : function(data) {
							$.messager.alert('系统提示', '删除成功', 'warning');
							lrmsMoni.reload();

							$('#editRow').removeAttr("disabled");
							$('#addRow').removeAttr("disabled");
							//window.location.href="${pageContext.request.contextPath}/lrms/lrms_quotamonitor_list.jsp"; 	 
						}
					});

				}
			}
		});
	}
	function appendRow() {
		$('#lrmsMoni').datagrid('unselectAll');
		var changes = lrmsMoni.getChanges();
		if (!lrmsMoni_index && !(changes && changes.length > 0)) {
			$('#editRow').removeAttr("disabled");
			$('#addRow').removeAttr("disabled");
			$('#editRow').attr('disabled', 'false');
			$('#addRow').attr('disabled', 'false');
			var newrow = {
				sysName : "",
				fileRecTime : "",
				warnLevel : "",
				remark : ""
			};
			lrmsMoni.appendRow(newrow);
			var rows = lrmsMoni.getRows();
			lrmsMoni_index = rows.length - 1;
			$('#lrmsMoni').datagrid('selectRecord', null);
			lrmsMoni.beginEdit(rows.length - 1);

		} else {
			$.messager.alert('系统提示', '当前有正在编辑！', 'warning');
		}
	}
</script>
</html>

