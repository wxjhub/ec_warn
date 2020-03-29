<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%@ include file="/loading.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据权限表单界面</title>
	<link href="${pageContext.request.contextPath}/css/ligerui/Aqua/css/default-all.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ligerui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/ligerFilter.js"></script>
        
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet" type="text/css" />
	<link href="${pageContext.request.contextPath}/css/css_new.css" rel="stylesheet" type="text/css"/>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/themes/default/easyui.css"></link>

	<script type="text/javascript">
        $(function () {
        
           	var fields = ${fields};
           	if(fields.toString() == null || fields.toString() == "") {
           		$("#filter").hide();
            } else {
            	var filter = $("#filter").ligerFilter({ fields: fields });
            	$("#filter").show();
            }
            var rule=${rule};
            if(rule!=""){
            	filter.setData(rule);
            }
       	 $("input").attr("disabled","disabled");
         $("select").attr("disabled","disabled");
         $(".zh_btnbg2").removeAttr("disabled");
            
        });

        function goBack(){
   		 window.location.href ="${pageContext.request.contextPath}/sec/sec_dataAcess_list.jsp";
   		}
       
         
    </script>
<style type="text/css">
.l-text-field {
	width:300px;
}
.l-text {
width:304px;
}

.l-icon-cross,.groupopsel,.addgroup,.deletegroup,.addrule,.l-trigger-icon,.l-trigger{
	display:none;
}

</style>
</head>
<body>
	<div class="table_b1 mar_30">
		<div class="table_tt" style="margin-top: 30px;"><font class="blue" id="msg">数据权限查看</font></div>
		<form name="formSave" id="formSave" method="post" style="padding: 25px 0 0 25px;">
			<input type="hidden" id="dataAcessId" name="dataAcessId" value="${dataAcessId}" /> 
			资源实体：<input type="text" id="className" value="${className}" style="width: 400px" class="easyui-validatebox input_eq2" readonly="readonly" />
			<p>数据规则： <div id="filter" style="border: 1px solid #d3d3d3;" ></div>
		</form>
		<div class="tool_btn">
		<div style="float: right;"><input type="button" onclick="goBack()" class="zh_btnbg2" value="返回" /></div>
		</div>
	</div>
</body>
</html>