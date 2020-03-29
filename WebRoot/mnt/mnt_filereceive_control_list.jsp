<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="zh-CN"
	xml:lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>文件发送监控</title>
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
#formSearch .panel-body {
	border-bottom-style: none;
}
</style>
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
	filter: alpha(opacity =     0);
	opacity: 0;
}
</style>

<script type="text/javascript">
	String.prototype.trim = function() {
		return this.replace(/^\s+|\s+$/g, '');
	};

	$(function() {
		var height = $('.gridDiv').parent().parent()[0].clientHeight
				- $("#formSearch").height() - 74;
		//网格最小高度
		height = height < 300 ? 300 : height;
		$('.gridDiv').height(height);

		$('#dataDate').datebox('setValue', dataDate);

		$('select.easyui-combobox').combobox({
			panelHeight : '100%'
		});
	});

	function search() {
		var fileName = $('#fileName')[0].value.trim();
		var sourseSys = $('#sourseSys').combobox('getValue');
//		var getSystem = $('#getSystem').combobox('getValue');
		var tranStat = $('#tranStat').combobox('getValue');
		var startDate = $('#startDate').datebox('getValue');
		var endDate = $('#endDate').datebox('getValue');
		var queryParams = {
				fileName : fileName,
				sourseSys : sourseSys,
	//			getSystem : getSystem,
				tranStat : tranStat,
				startDate : startDate,
				endDate:endDate
		};
		$('#lrmsMoni').datagrid('options').queryParams = queryParams;
		$('#lrmsMoni').datagrid('clearSelections');
		$('#lrmsMoni').datagrid({
			'url' : 'fileTranControl_fileTranControlList.action?tranType=1'
		});
	}

	var date = new Date();
	var y = date.getFullYear();
	var m = date.getMonth() + 1;
	var d = date.getDate();
	var dataDate = y + '-' + (m < 10 ? ('0' + m) : m) + '-'
			+ (d < 10 ? ('0' + d) : d);

	function formReset() {
		$('#fileName').val('');
		$('#sourseSys').combobox('setValue', '');
//		$('#getSystem').combobox('setValue', '');
		$('#tranStat').combobox('setValue', '');
		$('#startDate').datebox('setValue', '');
		$('#endDate').datebox('setValue', '');
		$('#lrmsMoni').datagrid('options').queryParams = "";
	}

	function checkRefresh() {
		if (document.getElementById('chk_refresh').checked) {
			reload();
			startRefresh();
		} else
			stopRefresh();
	}
	function reload() {
		$('#lrmsMoni').datagrid('reload', {
			refreshFlag : '1',
			fileName : $('#fileName').val().trim(),
			sourseSys : $('#sourseSys').combobox('getValue'),
//			getSystem : $('#getSystem').combobox('getValue'),
			tranStat : $('#tranStat').combobox('getValue'),
			startDate : $('#startDate').datebox('getValue'),
			endDate : $('#endDate').datebox('getValue')
		});
	}
	var begin = null;
	function startRefresh() {
		//var refreshTime = $('#formGrid').datagrid('getData').refreshTime;
		$.ajax({
			type:'post',
			url:'fileTranConfig_getRefreshTime.action',
			cache:false ,
			dataType:'json' ,
			async: false ,
			success:function(data){
				//var zNodes = eval(data); 
				var refreshTime = data.data + "000";
				begin = setInterval('reload()',parseInt(refreshTime));//
			},
			error:function(data){
				$.messager.show({
					title:"提示信息",
					msg:"出错了，无法刷新！",
					showType:"show"
				});
			}
		});
		
	}

	function stopRefresh() {
		clearInterval(begin);
	}

/* 	function _Play(id, url) {
		try {
			bgss.play();
		} catch (e) {
		}
	}

	function success(data) {
		if (0 != data.issoundnum) {
			_Play('bgss', data.songnum);

		}
	}
 */
	function sendSys(value, rowData, rowIndex) {
		var jsonData = $('#sourseSys').combobox('getData');
		for ( var i = 0; i < jsonData.length; i++) {
			if (value == jsonData[i].value) {
				return jsonData[i].text;
			}
		}
		return "";
	}
	function getSys(value, rowData, rowIndex) {
		var jsonData = $('#getSystem').combobox('getData');
		for ( var i = 0; i < jsonData.length; i++) {
			if (value == jsonData[i].value) {
				return jsonData[i].text;
			}
		}
		return "";
	}
	function transtat(value, rowData, rowIndex) {
		if (value == -1) {
			return '<div style="color:red">' + "传输出错" + '</div>';
		}
		if (value == 0) {
			return "传输完成";
		}
		if (value == 1) {
			return "正在传输";
		}
		if (value == 2) {
			return "未传输";
		}
		if (value == 3) {
			return "传输超时";
		}
	}
	function trantype(value, rowData, rowIndex) {
		if (value == 0) {
			return "接收";
		}
		if (value == 1) {
			return "发送";
		}
	}
	function toimport() {
		window.location.href = "fileTranConfig_toForm.action";
	}
	function checkListFile(){
		 //window.location.href="${pageContext.request.contextPath}/mon/mon_filelistchecksend_list.jsp";
			window.location.href="${pageContext.request.contextPath}/mnt/mnt_filelistcheckrec_list.jsp";

	}
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post"
		style="padding: 20px 0 20px 30px;width:100%"><INPUT name="pageNo"
	id="pageNo" type="hidden" value="${param.pageNo}">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>

				<td height="40px" >文件名称：</td>
				<td height="40px"><input type="text" id="fileName"
					name="fileName" class="input_eq"  style="width: 150px"/></td>
				<td height="40px">发送系统：</td>
				<td height="40px"><select name="sourseSys"
					class="easyui-combobox" id="sourseSys" style="width: 150px">
						<rmp:option dictId="sourseSys" currentValue="${param.sourseSys}"
							prompt=""></rmp:option>
				</select></td>
<!-- 				<td height="40px">接受系统：</td> -->
<%-- 				<td height="40px"><select name="getSystem" --%>
<%-- 					class="easyui-combobox" id="getSystem" style="width: 150px"> --%>
<%-- 						<rmp:option dictId="sourseSys"  --%>
<%-- 							prompt=""></rmp:option> --%>
<%-- 				</select></td> --%>
				<td height="40px">传输状态：</td>
				<td height="40px"><select name="tranStat"
					class="easyui-combobox" id="tranStat" style="width: 150px">
						<rmp:option dictId="conveyingStatus"
							prompt=""></rmp:option>
				</select></td>
				</tr>
				<tr>

               				<td height="40px">开始时间：</td>
				<td height="40px"><input class="easyui-datebox" id="startDate"
					name="startDate" style="width: 150px; padding: 0px" /></td>
									<td height="40px">结束时间：</td>
				<td height="40px"><input class="easyui-datebox" id="endDate"
					name="endDate" style="width: 150px; padding: 0px" /></td>
					</tr>
					<tr >
				<td colspan="6"><input class="inputd" type="button" value="查 询"
					onclick="search();" /> <input class="inputd" type="button"
					value="重 置" onclick="formReset();" /></td>
			<!-- 	<td><input type="checkbox" id="chk_refresh"
					onclick="checkRefresh();" value="自动刷新" />自动刷新</td> -->
			</tr>
		</table>
	</form>
	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true"
			idField="uuid" rownumbers="false" singleSelect="false" editable="false"
			url="fileTranControl_fileTranControlList.action?tranType=1"
			striped="true" fit="true" height="100%" title="文件发送监控" id="lrmsMoni"
			>
		<%--  <r:toolbar id="editRow" text="查看关联系统LIST文件" iconCls="icon-edit" onClick="checkListFile();"></r:toolbar>   --%>
			<%-- <r:toolbar id="btnconfig" text="监控参数配置" iconCls="icon-import"
				onClick="toimport();"></r:toolbar>  --%>
			<%-- <r:col  field="uuid" title="ID"  checkbox="true"   sortable="true" width="260" editable="false" >
			</r:col> --%>
			<r:col field="fileName" title="文件名称" sortable="true" width="450"></r:col>
			<r:col field="sourseSys" title="发送系统"
				 sortable="true" width="130" dictId="sourseSys">
			</r:col> 
<%-- 			<r:col field="getSystem" title="接受系统" --%>
<%-- 				 sortable="true" width="130" dictId="sourseSys"> --%>
<%-- 			</r:col>  --%>
		<r:col field="tranStat" title="传输状态" sortable="true"
				formatter="transtat(value, rowData, rowIndex)" width="100">
			</r:col>
			<r:col field="collectDate" title="采集时间" sortable="true"
				width="130" hasTime="true" dateFormat="yyyy-MM-dd">
			</r:col>
			<r:col field="dataDate" title="数据日期" sortable="true"
				width="130"  dateFormat="yyyy-MM-dd">
			</r:col>
<%-- 			<r:col field="messageStatus" title="通知状态" sortable="true" --%>
<%-- 				width="100"> --%>
<%-- 			</r:col> --%>
			<r:col field="warningLevl" title="预警级别" sortable="true" width="100" dictId="ec.warnLvl">
			</r:col>
			<%-- <r:col field="hy" title="含义" sortable="true" width="200"  dictId="file_hanyi">
			</r:col> --%>
			<r:col field="fileType" title="文件类型" sortable="true" width="100">
			</r:col>
			<r:col field="fileSize" title="文件大小(KB)" sortable="true" width="100">
			</r:col>
			<r:col field="tranStartTime" title="开始时间" sortable="true" width="130" hasTime="true" dateFormat="yyyy-MM-dd">
			</r:col>
			<r:col field="tranEndTime" title="结束时间" sortable="true" width="130" hasTime="true" dateFormat="yyyy-MM-dd">
			</r:col>
			<r:col field="fileTime" title="文件用时" sortable="true" width="100">
			</r:col>
			<r:col field="fileZt" title="是否实时" sortable="true" width="100">
			</r:col>
			<r:col field="col1" title="预留1" sortable="true" width="200" hidden="true">
			</r:col>
			<r:col field="col2" title="预留2" sortable="true" width="200" hidden="true">
			</r:col>
			<r:col field="col3" title="预留3" sortable="true" width="200" hidden="true">
			</r:col> 
			<r:pagination id="pag"></r:pagination>
		</r:grid>
	</div>
</body>
</html>

