<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
<title>新增机构</title>
<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/dialog.css" rel="stylesheet" type="text/css"/>
<link href="${pageContext.request.contextPath}/css/prettify.css" rel="stylesheet" type="text/css"/>
<script src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src="${pageContext.request.contextPath}/js/all_new.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/icon.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/dialog.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showModalCenter.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/form-util.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/messager.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/default/form.js"></script>
<script type="text/javascript"src="${pageContext.request.contextPath}/js/default/combobox.js"></script>
<script type="text/javascript"src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>

<style type="text/css">
.bg_img{background: url(${pageContext.request.contextPath}/common/imgs/user_add.gif) no-repeat right;}
#formSave{
	margin:0px;
	padding:0px;
	border-top:0px;
	overflow:hidden;
	border:1px solid #c0c0c0;
	border-top-style:none;
	background:#fff url(${pageContext.request.contextPath}/images/form_bg.png) right bottom repeat-x;
}
.combo{
	display:inline-block;
	white-space:nowrap;
	font-size:12px;
	margin:0;
	padding:0;
	border-radius:5px;
	-moz-border-radius:5px;
	border:1px solid #d8d8d8;
	background:#fff;
}
.combo-text{
	font-size:12px;
	border:0px;
	line-height:20px;
	height:20px;
	padding:0px;
	*height:18px;
	*line-height:18px;
	_height:18px;
	_line-height:18px;
	/*background:url(${pageContext.request.contextPath}/images/select_bg.png) repeat-x;*/
	border-radius:5px;
	-moz-border-radius:5px;
	-webkit-border-radius: 5px;
	border-top-right-radius:0px;
	-moz-border-radius-topright:0px;
	-webkit-border-bottom-right-radius:0px;
	border-bottom-right-radius:0px;
	-moz-border-radius-bottomright:0px;
	-webkit-border-bottom-right-radius:0px;
}
</style>

<script type="text/javascript">
	function save(){
		var uuid = $("#uuid").val();
		$('#formSave').form('submit', {
			url:"${pageContext.request.contextPath}/warnBatchConfig_save.action?uuid="+ uuid,
			onSubmit: function(){
				var flag = true;
				if(!$('#formSave').form('validate')){
					return false;
				} 
				if($('#warnContent').combobox('getValue') == '01'){
					var regTime = /^([0-2][0-9]):([0-5][0-9])$/;
				    var result = false;
				    var testValue = $('#warnContentValue2').val();
				    if (regTime.test(testValue)) {
				        if ((parseInt(RegExp.$1) < 24) && (parseInt(RegExp.$2) < 60)) {
				            result = true;
				            setWCV($('#warnContentValue2'));
				        }
				    }
				    if(!result){
				    	$.messager.alert('系统提示','时点格式有误,请输入格式如HH:MM','warning');
				    }
					return result;
				} else {
					setWCV($('#warnContentValue1'));
				}
				return flag;
			},
			success:function(data){
					var result=data;
					hasException(result);
					if(1==result) {
					if($("#uuid").val()==""){
						$.messager.alert('系统提示','数据新增成功','warning');
					}else{
						$.messager.alert('系统提示','数据修改成功','warning');
					}
					goBack();
				}}
		});
	};
	$(function(){
		 if($("#uuid").val()==""){
	  		$("#msg").text("跑批配置新增");
	  	 }else{
	  		$("#msg").text("跑批配置编辑");
	  	 }
	});
	
	function goBack(orgSeq){
		var _form = createForm({
								url: "${pageContext.request.contextPath}/mnt/mnt_warn_batch_config.jsp",
								condition: []
							});
		_form.submit();
	}
	//改变任务组下拉框数据
	function changeTaskSet(newValue,oldValue){
		$('#taskSetId').combobox('setValue','');
		$('#taskSetId').combobox('reload','${pageContext.request.contextPath}/warnBatchConfig_queryTaskSetId.action?batchId='+newValue); 
		
	}
	//改变任务组下拉框数据
	function taskSetChange(taskSet,batchId){
		$('#taskId').val(''); 
		$('#taskName').val(''); 
	}
	//预警内容值
	function warnContentChange(newV,oldV){
		if(newV == '01'){
			$('#contentDict').css('display','');
			$('#contentNum').css('display','none');
			$('#warnContentValue1').numberbox({
				required:false
			});
			$('#warnContentValue2').validatebox({
				required:true
			});
		} else {
			$('#contentDict').css('display','none');
			$('#contentNum').css('display','');
			$('#warnContentValue1').numberbox({
				required:true
			});
			$('#warnContentValue2').validatebox({
				required:false
			});
		}
	}
	
	
</script>
<style type="text/css">
	.tree-node-hover{
		background:#D0E5F5;
	}
	.tree-node{
		height:20px;
		white-space:nowrap;
		cursor:pointer;
	}
</style>
</head>
<body>
<div class="table_b1 mar_30">
<div class="table_tt" style="margin-top: 30px;"><font class="blue" id="msg"></font></div>
	<form name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;height: 315px">
		<input type="hidden" id="uuid" name="uuid" value="${detail.uuid}">
		<input type="hidden" id="warnContentValue" name="warnContentValue" value="${detail.warnContentValue}">
		<div id="myTab1_Content0" >
			<table cellSpacing="0" cellpadding="0" border="0">
				<tr>
					<td width="80px" height="40px">批次:</td>
					<td width="260px" height="40px">
						<r:combobox url="${pageContext.request.contextPath}/warnBatchConfig_queryBatchId.action" 
				  			 valueField="batchId" textField="batchName" id="batchId" style="width:156px" required="true"
				       name="batchId"  onChange="changeTaskSet(newValue,oldValue)" value="${detail.batchId}" missingMessage="必输"></r:combobox>
				       <span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">任务组：</td>
					<td height="40px" width="260px">
					     <r:combobox url="" valueField="taskSetId" textField="taskSetName" id="taskSetId" style="width:156px" 
				       name="taskSetId"   value="${detail.taskSetId}" onChange="taskSetChange(taskSet,batchId)"></r:combobox>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px">任务：</td>
					<td height="40px">
				        <input type="hidden" id="taskId" name="taskId" value="${detail.taskId}">
				        <input type="text" class="input_eq2" id="taskName" name="taskName" value="${detail.taskName}" readonly="readonly">
						<input type="button" class="inputd" value="选择" onclick="selectTask()">
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">预警级别:</td>
					<td height="40px">
						<r:dictCombobox id="warnLevl" name="warnLevl" dictId="ec.warnLvl" style="width:156px;" 
						   value="${detail.warnLevl}" required="true" missingMessage="必输"></r:dictCombobox>
						   <span style="color: red;font-size: 15px;"> *</span>
					</td>
				</tr>
				<tr>
					<td width="80px" height="40px">预警内容:</td>
					<td height="40px" >
				          <r:dictCombobox id="warnContent" name="warnContent" dictId="warn_batch_content" style="width:156px;"
				           value="${detail.warnContent}" onChange="warnContentChange(newValue,oldValue)" required="true" missingMessage="必输"></r:dictCombobox>
				           <span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td width="80px" height="40px" style="padding-left: 20px">预警内容数值:</td>
					<td height="40px" id="contentNum">
						<input type="text" class="easyui-numberbox input_eq2" id="warnContentValue1" name="warnContentValue1" 
						     value="${detail.warnContentValue}" required="true" missingMessage="必输">
						     <span style="color: red;font-size: 15px;"> *</span>
					</td>
					<td height="40px" id="contentDict" style="display:none;">
						<input type="text" class="easyui-validatebox input_eq2" id="warnContentValue2" name="warnContentValue2" 
						     value="${detail.warnContentValue}" required="true" missingMessage="必输格式形如：08:30">
				           <span style="color: red;font-size: 15px;"> *</span>
						     
					</td>
				</tr>
			</table>
		</div>
	</form>
	<div class="tool_btn">
		<div style="float: right;">
			<input class="zh_btnbg2" type="submit" id="submit" value="保存" onclick="save();" />
			<input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" />
		</div>
	</div>
</div>
<script type="text/javascript">
$(function(){
    //表格自适应屏幕高度
    var heightValue = $(document).height() - 95 - 55;
    if (heightValue > 300)
        $("#formSave").height(heightValue);
    //设置combobox可编辑
    $('#batchId').combobox({
    	editable:true
    });
    $('#taskSetId').combobox({
    	editable:true
    });
});
function setWCV(t){
	$('#warnContentValue').val($(t).val());
}
//选择任务
function selectTask(){
	var taskSetId = $('#taskSetId').combobox('getValue');
	if(taskSetId && taskSetId != "" && taskSetId != null){
		showModalCenter ("${pageContext.request.contextPath}/mnt/mnt_warn_batch_sel_task.jsp?taskSetId="+taskSetId, function(data){
			$("#taskId").val(data[0].id);
			$("#taskName").val(data[0].name);
		}, "70%", "60%", "选择任务");
	} else {
		$.messager.alert('系统提示','请先选择任务组！','warning');
		return;
	}
	
}
</script>
</body>
</html>