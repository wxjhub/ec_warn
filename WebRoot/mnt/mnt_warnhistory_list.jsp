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
<title>当前报警查询</title>
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
	filter: alpha(opacity =           0);
	opacity: 0;
}
</style>

<script type="text/javascript">
	$(function() {
		setInterval("submi()",120000);
		$('.gridDiv').height(
				$('.gridDiv').parent().parent()[0].clientHeight - 63);
	});
	$(function() {
		$('#recordDate').datebox({});
		$('#lrmsMoni').datagrid({
			rowStyler: function(index ,record){
				 if(record.warnLevel ==1){
					 return "color:#ff9933";
				 }
				 if(record.warnLevel ==2){
					 return "color:red";
				 }
				 if(record.warnLevel ==3){
					 return "color:#660000";
				 }
			} ,
			pagination: true , 
			pageSize: 15 ,
			pageList:[5,10,15] 
		});
	});
	
	var snd = document.createElement("bgsound");
	snd.setAttribute('id','i_bg');
	//snd.id="i_bg";
	var audioElement = document.createElement('audio');  
	audioElement.setAttribute('src', '../music/1.wav');  
	function play(sound) {
		if (navigator.appName == "Microsoft Internet Explorer") {
			document.getElementsByTagName("body")[0].appendChild(snd);
			snd.src = sound;
		} else {
			 audioElement.load;  
			 audioElement.play();  
		}
	}

/* 	function end(){
	if (navigator.appName == "Microsoft Internet Explorer") {
			i_bg.src = "";
		} else {
			audioElement.pause();
		}

	} */
	
	function courseStatustype(value, rowData, rowIndex){
		var snd = document.createElement("bgsound");
		//snd.id="i_bg";
		snd.setAttribute('id','i_bg');
		var audioElement = document.createElement('audio');  
		audioElement.setAttribute('src', '../music/1.wav'); 
		if(value==0){
			play('../music/1.wav');
			return '未处理';
		}
		if(value==1){
			 //end();
			 return '已确认';
		}
	}
</script>
</head>
<body>
	<form name="formSearch" id="formSearch" method="post"
		style="padding: 20px 0 20px 30px;">
		<table cellSpacing="0" cellpadding="0" border="0">
			<tr>
				<td height="40px">报警日期：
				<%-- <h:date id="recordDate" name="recordDate" /> --%>
				<input  id="recordDate" name="recordDate" />
				</td>
				<td height="40px">预警级别： 
					<select name="warnLevel" id="warnLevel">
						<option value="">---请选择---</option>
						<rmp:option dictId="ec.warnLvl"></rmp:option>
					</select>
				</td>
			<%-- 	<td height="40px">处理状态： 
					<select name="state" id="state">
						<option value="">---请选择---</option>
						<rmp:option dictId="mon.deal.status"></rmp:option>
				</select>
				</td> --%>

				<td>
					<input id="filter_submit" class="inputd" type="button" value="查询" onclick="submi()" /> 
				    <input id="filter_reset" class="inputd" type="reset" onclick="rese()" value="重 置" />
				</td>
			</tr>
		</table>
	</form>

	<div class="gridDiv">
		<r:grid sortable="true" remoteSort="true" pagination="true"
			idField="uuid" rownumbers="false" singleSelect="true"
			editable="true" url="warnHistory_warnHistoryList.action"
			striped="true" fit="true" height="100%" title="当前预警" id="lrmsMoni">
			<r:toolbar id="editRow" text="批注" iconCls="icon-edit" onClick="editParam();"></r:toolbar>
			<r:toolbar text="保存" iconCls="icon-save" onClick="save();"></r:toolbar>
				<%-- <r:toolbar text="音乐" iconCls="icon-remove" onClick="play('../music/1.wav');"></r:toolbar> --%>
				<%-- <r:toolbar text="关闭音乐" iconCls="icon-remove" onClick="end();"></r:toolbar> --%>
				<%-- <r:toolbar text="播放" iconCls="icon-remove" onClick="PlayAudio();"></r:toolbar>
				<r:toolbar text="停止" iconCls="icon-remove" onClick="PauseAudio();"></r:toolbar> --%>
				
			<r:col field="uuid" title="ID" checkbox="true" sortable="true"
				width="260" editable="false" hidden="flase">
			</r:col>
			<r:col field="recordDate" title="报警日期" editable="false" sortable="true" width="150" >
				<r:editorDate format="yyyy-MM-dd" />
			</r:col>
				<r:col field="warnSort" title="报警分类" editable="false" sortable="true" width="120"
				dictId="ec.warnSort">
			</r:col>
			<r:col field="recordName" title="交易名称" editable="false" sortable="true" width="100" >
			</r:col>
			<r:col field="pointIp" title="IP地址" editable="false" sortable="true" width="100">
			</r:col>
			<r:col field="pointName" title="所属系统" editable="false" sortable="true" width="100" dictId="sourseSys">
			</r:col>
		
			<r:col field="warnLevel" title="预警级别" editable="false" sortable="true" width="60"
				dictId="ec.warnLvl">
			</r:col>
			<r:col field="recordDescription" title="日志描述" editable="false" sortable="true" width="350">
			</r:col>
			
			<r:col field="endDate" title="恢复日期" editable="false" sortable="true" width="150" >
				<r:editorDate format="yyyy-MM-dd" />
			</r:col>
			<r:col field="remark" title="批注" editable="true" sortable="true" width="300">
			</r:col>
			<%-- <r:col field="state" title="处理状态" editable="false" sortable="true" width="100"  formatter="courseStatustype(value, rowData, rowIndex)" >
			</r:col> --%>
			<r:pagination id="pag"></r:pagination>
		</r:grid>

	</div>
</body>
<script>
	//重置查询信息
	function rese() {
		$("#recordDate").datebox('setValue','');
		$("#warnLevel").val('');
		$("#state").val('');
	}

	function submi() {
		var jsonData = {
			recordDate : $("#recordDate").datebox('getValue'),
			warnLevel : $("#warnLevel").val(),
			state : $("#state").val(),
			newpage : 1,
			page : 1
		};
		lrmsMoni.load(jsonData);
		

	}
	
	
	function editParam(){
		  var changes = lrmsMoni.getChanges();
		  if(!lrmsMoni_index){
			  if(!(changes &&changes.length > 0)){
				var selected = lrmsMoni.getAllSelected();
				if(selected.length==0){
					$.messager.alert('系统提示','请选择一个要编辑的！','warning');
				}else if(selected.length>1){
					$.messager.alert('系统提示','同时只能编辑一个！','warning');
				}else{
					var rownum = lrmsMoni.getRowIndex(selected[0]);
					lrmsMoni_index = rownum;
					alert(rownum)
					//lrmsMoni.removeEditor(['subjectId']);
					lrmsMoni.beginEdit(rownum);
				$('#editRow').removeAttr("disabled");
				$('#addRow').removeAttr("disabled");
				$('#editRow').attr('disabled','false');
				$('#addRow').attr('disabled','false');
				}
			}
		  }else{
			  $.messager.alert('系统提示','当前有正在编辑！','warning');
			  }
	}

	function save(){
		lrmsMoni.endEdit(lrmsMoni_index);
		var vali = lrmsMoni.validateRow(lrmsMoni_index);
		if(vali){
			var selected = lrmsMoni.getChanges('inserted');
			
			if(selected.length>1){
				$.messager.alert('系统提示','保存只能一个！','warning');
			}else{
				if(selected.length==0){
					selected = lrmsMoni.getChanges('updated');
				}
				var uuid = selected[0].uuid;
				var remark = selected[0].remark;
			
				
						$.ajax({
							cache:false,
							type: 'post',
							dataType : "Json",
							data:{uuid:uuid,remark:remark},
							url: "warnHistory_handleState.action",
							error:function(data){
								$.messager.alert('系统提示','当前数据请求失败，请联系管理员!','warning');
							},
							success:function(data){
								if(data=="1"){
									$.messager.alert('系统提示','保存成功','warning');
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
								}else if(data=="3"){
								 	$.messager.alert('系统提示','保存失败','warning');
								 	lrmsMoni.reload();
								 	$('#editRow').removeAttr("disabled");
									$('#addRow').removeAttr("disabled");
									lrmsMoni_index = null;
									lrmsMoni.unselectAll();
								}else{
									$.messager.alert('系统提示','批注成功!','warning');
									lrmsMoni.unselectAll();
								}
							}
						});
				}
			}
}
	
</script>
</html>

