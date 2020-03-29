<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.vprisk.com/tags/rmp" prefix="rmp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8" />
<META content="" name=Description>
<title>交易信息</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script language="javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<script language="javascript" src="${pageContext.request.contextPath}/js/metadata/copyToClipboard.js"></script>
	
<style type="text/css">
#tab2 .trOdd{background-color: #ffffff}
#tab2 .trEven{background-color: #e6f0fe}
#tab2 .selectedbg{background-color: #B7E0EA}
</style>
<script type="text/javascript">
function filterViewType(propertyType, viewType, isPk, refType){
 if(propertyType.indexOf("entity")>=0){
	  $("#"+viewType+" option[value='flag']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='text']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='textArea']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='select']").attr("disabled","");
	  $("#"+viewType+" option[value='date']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='datetime']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='autoSelect']").attr("disabled","");
	  $("#"+viewType+" option[value='comboTree']").attr("disabled","");
	  $("#"+viewType+" option[value='popSelect']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='popTree']").attr("disabled","");
	  $("#"+viewType+" option[value='popLazyTree']").attr("disabled","");
	  $("#"+viewType+" option[value='hidden']").attr("disabled","disabled").remove();
 }else if(propertyType=='java.lang.String'){ //alert("isPk:"+isPk+",refType:"+refType);
	  if(isPk=='1'){
		 $("#"+viewType+" option[value='flag']").attr("disabled","disabled").remove();
		 //$("#"+viewType+" option[value='text']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='textArea']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='select']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='date']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='datetime']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='autoSelect']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='comboTree']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='popSelect']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='popTree']").attr("disabled","disabled").remove();
		 $("#"+viewType+" option[value='popLazyTree']").attr("disabled","disabled").remove();
	  }else{
		  if(refType=='1'){ //字符串并且是状态字典
			  $("#"+viewType+" option[value='text']").remove();  
			  //$("#"+viewType+" option[value='flag']").remove();  
			  $("#"+viewType+" option[value='select']").remove();
			  $("#"+viewType+" option[value='date']").remove();
			  $("#"+viewType+" option[value='datetime']").remove();
			  $("#"+viewType+" option[value='autoSelect']").remove();
			  $("#"+viewType+" option[value='comboTree']").remove();
			  $("#"+viewType+" option[value='popSelect']").remove(); 
			  $("#"+viewType+" option[value='popTree']").remove();
			  $("#"+viewType+" option[value='popLazyTree']").remove();
		  }else{ //普通字符串
			  $("#"+viewType+" option[value='textArea']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='select']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='flag']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='date']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='datetime']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='autoSelect']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='comboTree']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='popSelect']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='popTree']").attr("disabled","disabled").remove();
			  $("#"+viewType+" option[value='popLazyTree']").attr("disabled","disabled").remove();
		  }
		
	  }
	
 }else if(propertyType.indexOf("Date")>=0){
	  $("#"+viewType+" option[value='flag']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='text']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='textArea']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='select']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='date']").attr("disabled","");
	  $("#"+viewType+" option[value='datetime']").attr("disabled","");
	  $("#"+viewType+" option[value='autoSelect']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='comboTree']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='popSelect']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='popTree']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='popLazyTree']").attr("disabled","disabled").remove();
	  $("#"+viewType+" option[value='hidden']").attr("disabled","disabled").remove();
}else if(propertyType.indexOf("BigDecimal")>=0){
	 $("#"+viewType+" option[value='flag']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='text']").attr("disabled","");
	 $("#"+viewType+" option[value='textArea']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='select']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='date']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='datetime']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='autoSelect']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='comboTree']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popSelect']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popTree']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popLazyTree']").attr("disabled","disabled").remove();
}else if(propertyType.indexOf("com.vprisk.rmplatform.components.security.model.Branch")>=0){
	 $("#"+viewType+" option[value='flag']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='text']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='textArea']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='select']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='date']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='datetime']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='autoSelect']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='comboTree']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popSelect']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popTree']").attr("disabled","");
	 $("#"+viewType+" option[value='popLazyTree']").attr("disabled","");
	 
}else if(propertyType.indexOf("Long")>=0){
	 $("#"+viewType+" option[value='flag']").attr("disabled","disabled").remove();
	 //$("#"+viewType+" option[value='text']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='textArea']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='select']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='date']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='datetime']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='autoSelect']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='comboTree']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popSelect']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popTree']").attr("disabled","disabled").remove();
	 $("#"+viewType+" option[value='popLazyTree']").attr("disabled","disabled").remove();
}  
}


	function filterQueryMode(propertyType,queryMode){
		if(propertyType.indexOf("entity")>=0){
			  $("#"+queryMode+" option[value='EXACT']").attr("disabled","");
			  $("#"+queryMode+" option[value='START']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='ANYWHERE']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='END']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='BETWEEN']").attr("disabled","disabled").remove();
		  }else if(propertyType=='java.lang.String'){
			  $("#"+queryMode+" option[value='EXACT']").attr("disabled","");
			  $("#"+queryMode+" option[value='START']").attr("disabled",""); 
			  $("#"+queryMode+" option[value='ANYWHERE']").attr("disabled","");
			  $("#"+queryMode+" option[value='END']").attr("disabled","");
			  $("#"+queryMode+" option[value='BETWEEN']").attr("disabled","disabled").remove();
		  }else if(propertyType.indexOf("Date")>=0){
			  $("#"+queryMode+" option[value='EXACT']").attr("disabled","");
			  $("#"+queryMode+" option[value='START']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='ANYWHERE']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='END']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='BETWEEN']").attr("disabled","");
		  }else if(propertyType.indexOf("BigDecimal")>=0){
			  $("#"+queryMode+" option[value='EXACT']").attr("disabled","");
			  $("#"+queryMode+" option[value='START']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='ANYWHERE']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='END']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='BETWEEN']").attr("disabled","disabled").remove();

		  }else if(propertyType.indexOf("com.vprisk.rmplatform.components.security.model.Branch")>=0){
			  $("#"+queryMode+" option[value='EXACT']").attr("disabled","");
			  $("#"+queryMode+" option[value='START']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='ANYWHERE']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='END']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='BETWEEN']").attr("disabled","disabled").remove();
		  }else if(propertyType.indexOf("Long")>=0){
			  $("#"+queryMode+" option[value='EXACT']").attr("disabled","");
			  $("#"+queryMode+" option[value='START']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='ANYWHERE']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='END']").attr("disabled","disabled").remove();
			  $("#"+queryMode+" option[value='BETWEEN']").attr("disabled","disabled").remove();

		  }

	}

	//提交交易信息
	function saveTrans(){
		var chkSelectCount =  btnDel_onClicked("queryFields");
		if(chkSelectCount<=0){
			$.messager.alert('系统提示','查询条件请至少勾选一个!','warning');
			return;
		}
		
		var chkSelectCount =  btnDel_onClicked("listFields");
		if(chkSelectCount<=0){
			$.messager.alert('系统提示','查询结果请至少勾选一个!','warning');
			return;
		}
		var flag = true;
		$(".easyui-validatebox").each(function () {
		    if (!$(this).validatebox('isValid'))
				    flag = false;
		});
		if(!flag)
			return false;
		
		var xform = document.formTrans;
		var transId = $("#transId").val();
		var transName = $("#transName").val();

		var param;
		if(xform.isEdit)
			param = {'transId':transId,'transName':transName,'isEdit':true};
		else
			param = {'transId':transId,'transName':transName,'isEdit':false};
			
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/queryTrans_xml_EstimateOnlyById.action",
			data:param,
			timeout:10000,
			success:function(data){
				if(data){
					if('error' == msg){
						$.messager.alert('系统提示',"系统异常请稍候重试!",'warning');
					}
					$.messager.alert('系统提示',data,'warning');
				} else {
					xform.action = "${pageContext.request.contextPath}/queryTrans_xml_saveQueryTransWithFields.action";
					xform.submit();
				}
			}
		});
	}
	
	function back(){
		var modelName = document.getElementById("modelName").value;
		window.location.href="${pageContext.request.contextPath}/queryTrans_xml_list.action?modelName="+modelName;
		return false;
	}
		
	function sortProperty(ischecked,propertyName,orderFlag,isUp,ObjectName){
	      var transId = document.getElementById("transId").value;
	      var movestr ;
	      if(ischecked ==null||ischecked==""){
	        return ;
	      }
  		   movestr = (isUp==true)? "上移" : "下移";
		$.ajax({
			type:"post",
			url:"${pageContext.request.contextPath}/queryTrans_xml_saveQueryTransOrderFlag.action",
			data:{'propertyName':propertyName,'transId':transId,'orderFlag':orderFlag,'isUp':isUp,'ObjectName':ObjectName},
			timeout:10000,
			success:function(response){
				//alert(response);
			    if(response == 'noUp'){
			    	$.messager.alert('系统提示','已经是第一位！','warning');
			    }else if(response == 'noDown'){
			    	$.messager.alert('系统提示','已经是最后一位！','warning');
			    }else{
			       document.formTrans.submit();
			    }
		    	
			},
			scope:this
		});
	}

    //得到勾选的checkbox
	function  btnDel_onClicked(str) {
	    var chkList = document.getElementsByName(str);
	    var chkSelectCount = 0;
	    //得到选中checkbox的个数
	    for (var index = 0; index < chkList.length; index++) {
	        var chkObj = chkList[index];
	        if (chkObj.checked) {
	            chkSelectCount++;
	        }
	    }
	    return chkSelectCount;
	}

	function codeGenConfirm(){
	  document.getElementById("codegenDiv").style.display="block";
	}

	function gendMenu(){

		if(!document.formTrans.isEdit) {
			$.messager.alert('系统提示','请先保存查询交易!','warning');
			return;
		} else {
			var transId = $("#transId").val();
			var transName = $("#transOldName").val();
			var modelName = $("#modelName").val();
			var url="/metaxml_query.action?transId="+transId+"&logic=false";
			$.ajax({
				type:"post",
				url:"${pageContext.request.contextPath}/queryTrans_xml_genMenu.action",
				data:{'modelName':modelName,'transName':transName,'transId':transId,'url':url},
				dataType : "json",
				success:function(data){
					//保存成功
					if(data!=null){
						$.messager.alert('系统提示',data.msg,'warning');
					}
				}
			});		
		}
	}
	
	function codeGen(){
	  var xform = document.formTrans;
	  xform.action = "${pageContext.request.contextPath}/queryTrans_xml_codegen.action";
	  xform.submit();
	}
	
	$().ready(function(){
		//根据有没有交易编号，判断是否新添加的交易，是则生成默认交易名
		var transId = $("#transId").val();
		if(!transId){
			var modelName=$("#modelName").val();
			$("#transId").val(modelName+"Query");//设置交易编号
			var comment=$("#comment").val();
			if(comment.indexOf('表')>=0){
				comment= comment.substring(0,comment.lastIndexOf('表'));
			}
			$("#transName").val(comment+"管理");//设置交易名称
		} else {
			document.formTrans.isEdit = true;
		}
		
		$('select').combobox({
		 	panelHeight:'100%'
		});

		//隔行变色
		 $("#tab2 tr:nth-child(even)").addClass("trOdd");
		 $("#tab2 tr:nth-child(odd)").addClass("trEven");

		var Sys = {};
		  var ua = navigator.userAgent.toLowerCase();
		  var s;
		  (s = ua.match(/msie ([\d.]+)/)) ? Sys.ie = s[1] :
		  (s = ua.match(/firefox\/([\d.]+)/)) ? Sys.firefox = s[1] :
		  (s = ua.match(/chrome\/([\d.]+)/)) ? Sys.chrome = s[1] :
		  (s = ua.match(/opera.([\d.]+)/)) ? Sys.opera = s[1] :
		  (s = ua.match(/version\/([\d.]+).*safari/)) ? Sys.safari = s[1] : 0;
		
		var pageConts = $("#tab tr").length;
		if((navigator.appName == "Microsoft Internet Explorer") && (($(".table_list").height())>($(".table_panel").height()))) 
		{ 
		     if(navigator.appVersion.match(/7./i)=='7.') 
		     { 
		      	  $("#order").width('4%');
		  	  }
		     else if(navigator.appVersion.match(/8./i)=="8.")
		     {
		   	  $("#tab").width($("#tab").width()+17);
		   	  $("#tab2").width($("#tab2").width()+17);
		     }
		     else if(navigator.appVersion.match(/9./i)=="9.")
		     {
		   	  $("#tab").width($("#tab").width()+17);
		   	  $("#tab2").width($("#tab2").width()+17);
		     }
		}
		if ((Sys.firefox || Sys.chrome) && (parseInt(pageConts)>10)) { 
			$("#tab").width($("#tab").width()+17);
			$("#tab2").width($("#tab2").width()+17);
		}
	});

function checkedAllCheckBox(checkedName, checked){
	$("input[name="+checkedName+"]").attr("checked", checked);
};

</script>
</head>
<body>
<div class="mar_30 majorword"> 
<form name="formTrans" id="formTrans" method="post" >
<table style="width:100%;" >
<tr>
	<td>
		<table border="0" width="100%" style="border-collapse:separate;border-spacing:5px;">
			<!-- 
			<tr>
			     <td colspan="4" bgcolor=#8db5e9>
			     	<font color=#ffffff><strong>查询交易信息</strong></font> 
			     	<font color="red">${transError}</font>
			     </td>
		 	</tr>
		 	 --> 
			<tr>
			  	<td width="10%" align="left">交易编号</td>
			  	<td width="40%">
			   	<input type="text" id="transId" name="transId"
			   			id="transId" style="WIDTH:130px;font-size:12px;" class="easyui-validatebox input_eq"
			   			value="${trans.transId}" ${empty trans.transId ? 'required=true':'readonly'}/>
			 		(必须为英文)
				</td>
				<td width="10%" align="left">交易名称</td>
				<td width="40%" >
					<input type="hidden" id="transOldName" value="${trans.transName}" />
					<input type="text" id="transName" name="transName" class="easyui-validatebox input_eq" 
							style="WIDTH:150px;font-size:12px;" 
							value="${trans.transName}" required=true/>（必须为有意义的中文）
			  	</td>
			</tr>  
			<tr>
			  <td width="10%" align="left">交易类型</td>
			  <td width="40%">
			   	<select name="transType" id="type" class="easyui-combobox" style="WIDTH:130px;">
			     			<rmp:option dictId="meta.queryTrans.Types" currentValue="${trans.transType}" defaultValue="QUERY"/>
			    </select>
				</td>
				<td width="10%" align="left">ModelName</td>
				<td width="40%">
					<input type="hidden" name="modelName" id="modelName" value="${trans.model.modelName}">
					<input type="hidden" name="comment" id="comment" value="${trans.model.comment}">
					${trans.model.modelName}
			  	</td>
			</tr>
		  	<tr>
			    <td width="10%" align="left">包含功能选项</td>
			    <td  colspan="3">
			    	新增&nbsp;<input name="addFlag"    type="checkbox" value="1" ${trans.addFlag eq '1' or empty trans.transId ? 'checked':''}>&nbsp;&nbsp;
			    	修改&nbsp;<input name="editFlag"   type="checkbox" value="1" ${trans.editFlag eq '1' or empty trans.transId ? 'checked':''}>&nbsp;&nbsp;
			    	删除&nbsp;<input name="removeFlag" type="checkbox" value="1" ${trans.removeFlag eq '1' or empty trans.transId ? 'checked':''}>&nbsp;&nbsp;
			    	导出&nbsp;<input name="exportFlag" type="checkbox" value="1" ${trans.exportFlag eq '1' or empty trans.transId ? 'checked':''}>&nbsp;&nbsp;
			    	导入&nbsp;<input name="importFlag" type="checkbox" value="1" ${trans.importFlag eq '1' or empty trans.transId ? 'checked':''}>&nbsp;&nbsp;
			    </td>  
 			</tr>
		  
			<tr align="center">
				<td colspan="5">
			    	<div class="zh_btn" style="margin-top:10px;">
				   		<input class="inputd" type="button" value="保存查询交易" onclick="saveTrans()">&nbsp;&nbsp;
				   		<input class="inputd" type="button" value="自动生成菜单" onclick="gendMenu()">&nbsp;&nbsp;
				   		<input class="inputd" type="button" value="查看菜单链接" onclick="codeGenConfirm()">&nbsp;&nbsp;
				   		<input class="inputd" type="button" value="返  回" onclick="back()">&nbsp;&nbsp;
				    	<div id="codegenDiv" style="bgcolor:#EFF3FF;width:95%;margin-left:10px;display:none;"><br>
					    	 /metaxml_query.action?transId=${trans.transId}&nbsp;&logic=false
					    	 <input class="inputd" type="button" value="复制" 
					    	 		onclick="copyToClipboard('/metaxml_query.action?transId=${trans.transId}&logic=false')">
					    	 <br>
									    	 备注：拷贝链接后用于新增菜单时使用，其中logic表示是否逻辑操作。<br> 
									    	 系统权限管理->菜单管理->勾选参数补录，点击添加菜单按钮来新建菜单，其中菜单URL即为拷贝的链接。<br>
									    	 系统权限管理->角色管理，选择使用该功能的角色，点击配置菜单，勾选新添加的菜单即可。
					    	
								&nbsp;<!--<input name="metadata_query" type="checkbox" value="1" style="width:13px;height:13px">&nbsp;&nbsp;基于元数据的查询&nbsp;&nbsp; 
									 <input type="checkbox" name="jspquery" value="1" style="width:13px;height:13px">JSP查询页面
									<br><input class=button type="button" name="genCode2" value="确认开始生成" onclick="codeGen();">-->
						</div>
					</div>
				</td> 
			</tr> 
		</table>
	</td>
</tr>
<tr><td><br></td></tr>
<!-- 查询条件标题 -->
<tr>
<td>
	<div class="table_tt" style="padding-left:5px;">编辑查询条件</div>
	<div class="tb_tt">
		<a style="CURSOR: pointer" onclick="saveTrans()"><span class="filesave">保存查询条件</span></a>
	</div>
	<div style="border:#c0c0c0 solid 1px;">
	<div style="width: 100%">  
	<table width="100%" class="thead" border="0" cellspacing="0" cellpadding="0">
      	<tr>
			<td width="3%" align="center">
				<input type="checkbox" name="checkbox" id="checkbox" onclick="checkedAllCheckBox('queryFields', this.checked)" title="全选/反选" />
			</td>
			<td width="15%">属性名称</td>
			<td width="15%">视图名称 </td>
			<td width="7%">排序</td>
			<td width="12%">视图类型</td>
			<td width="12%">查询模式</td>
			<td width="12%">查询默认值</td> 
			<td width="12%">宽度(%或px)</td>
		 	<td width="12%">是否换行</td> 
      	</tr>
    </table>
	</div>
	<div class="table_panel">
	<table width="100%" class="table_list" border="0" cellspacing="0" cellpadding="0" id="tab">
    <c:forEach items="${requestScope.queryFields}" var="item" varStatus="s">
		<tr style="CURSOR: pointer">
			<td width="3%" align="center">
	      		<input type="checkbox" name="queryFields" value="${item.propertyName}" ${item.ischecked eq 1 ? 'checked':'' }/>
			</td>
			<td width="15%">
				<input type="hidden" name="propertyName" value="${item.propertyName}">${item.propertyName}
			</td>
			<td width="15%">
				<input type="hidden" name="viewLabel${item.propertyName}" value="${item.viewLabel}"/>
				<input type="hidden" name="comment" value="${item.fieldComment}"/>
						${item.fieldComment}${item.field.pkOrFk}
			</td>
			<td width="7%">
				<input name="viewOrderFlag${item.propertyName}" style="width:30px;" type="hidden">
				<img src="${pageContext.request.contextPath}/images/up.gif" height="18" width="15" 
					onclick="sortProperty('${item.ischecked }','${item.propertyName}','${item.viewOrderFlag}',true,'QueryField');" />&nbsp;&nbsp;
				<img src="${pageContext.request.contextPath}/images/down.gif" height="18" width="15" 
					onclick="sortProperty('${item.ischecked }','${item.propertyName}','${item.viewOrderFlag}',false,'QueryField');" />
			</td>
			<td width="12%">
				<select name="viewType${item.propertyName}" id="viewType${item.propertyName}" class="easyui-combobox" style="width:100%;">
	   	    		<rmp:option dictId="meta.queryField.viewType" currentValue="${item.queryFieldView}" />
	   	    	</select>
	   	    	<script>
	  				filterViewType('${item.field.propertyType}', 'viewType${item.propertyName}', '${item.field.isPrimaryKey}','${item.field.refType}');		 			
	   			</script>
			</td>
	      	<td width="12%">
		      	<select name="queryMode${item.propertyName}" id="queryMode${item.propertyName}" class="easyui-combobox" style="width:100%;">    
      				<rmp:option dictId="meta.field.queryMode" currentValue="${item.queryMode}"/>
	          	</select>
	         	<script>
			  		filterQueryMode('${item.field.propertyType}', 'queryMode${item.propertyName}');		   			
			   	</script>
	      	</td>
	      	<td width="12%">
	      		<input name="defaultValue${item.propertyName}" class="input_eq" type="text" value="${item.defaultValue }" style="width:80px;">
	      	</td> 
	      	<td width="12%">
				<input name="viewwidth${item.propertyName}" class="input_eq" type="text" value="${item.viewWidth}" style="width:80px;">
			</td>
        	<td width="12%" id="order">
	        	<select name="viewSingleFlag${item.propertyName}" id="type" class="easyui-combobox">    
	       			<rmp:option dictId="sys.boolean" currentValue="${item.viewSingleFlag}"/>
	       		</select>
			</td> 
		</tr>      
	</c:forEach>
	</table>
	</div>
	</div>
</td>
</tr>
<tr><td><br></td></tr>
<!-- 查询结果listField部分 -->
<tr><td>
	<div class="table_tt" style="padding-left:5px;">编辑查询结果</div>
	<div class="tb_tt">
		<a style="CURSOR: pointer" onclick="saveTrans()"><span class="filesave">保存查询结果</span></a>
	</div>
	<div style="border:#c0c0c0 solid 1px;">
	<div style="width: 100%">        
	<table width="100%" class="thead" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="3%" align="center">
				<input type="checkbox" name="checkbox" id="checkbox" onclick="checkedAllCheckBox('listFields',this.checked)" title="全选/反选" />
		    </td>
			<td width="15%">属性名称</td>
		    <td width="15%">视图名称 </td>
		    <td width="7%">排序</td>
		    <td width="20%">宽度(%或px)</td>
		    <td width="20%">
		    	${'EDIT_QUERY' eq trans.transType ? '是否可编辑' : ''}
			</td>
			<td width="20%">
				${'EDIT_QUERY' eq trans.transType ? '编辑视图类型' : ''}
			</td> 
		</tr>
    </table>
	</div>
	<div class="table_panel">
	<table width="100%" class="table_list" border="0" cellspacing="0" cellpadding="0" id="tab2">
	<c:forEach items="${requestScope.listFields}" var="item" varStatus="s">
		<tr style="CURSOR: pointer">
	      	<td width="3%" align="center">
	      	<input type="checkbox" name="listFields" id="${item.propertyName}lf" 
         			class="textfield" value="${item.propertyName}" ${"1" eq item.ischecked ? 'checked':'' }/>
	      	</td>
			<td width="15%"><c:out value="${item.propertyName}"/></td>
	      	<td width="15%">
	      		<c:out value="${item.fieldComment}"/>
	      		<input type="hidden" name="comments${item.propertyName}" value="${item.fieldComment}"/>
			</td>
	      	<td width="7%">
				<img src="${pageContext.request.contextPath}/images/up.gif" height="18" width="15" 
     		 		 onclick="sortProperty('${item.ischecked }','${item.propertyName}','${item.viewOrderFlag}',true,'ListField');" />&nbsp;&nbsp;
          		<img src="${pageContext.request.contextPath}/images/down.gif" height="18" width="15" 
					 onclick="sortProperty('${item.ischecked }','${item.propertyName}','${item.viewOrderFlag}',false,'ListField');" />
			</td>
			<td width="20%">
				<input name="viewwidths${item.propertyName}" type="text" class="input_eq" value="${item.viewWidth}" style="width:40%;">
			</td>
			<td width="20%">
				<c:if test="${'EDIT_QUERY' eq trans.transType}" var="isedit">
					<select name="editFlags${item.propertyName }" id="type" class="easyui-combobox" style="width:70%">    
						<rmp:option dictId="sys.boolean" currentValue="${item.editFlag}"/>
					</select>
				</c:if>
			</td>
			<td width="20%">
		      	<c:if test="${'EDIT_QUERY' eq trans.transType}" var="isedit">
   					<select name="formviewType${item.propertyName }" id="viewType${item.propertyName }" class="easyui-combobox" style="width: 85px">    
	       				<rmp:option dictId="meta.listField.viewType" currentValue="${item.listFieldView}"/>
	           		</select>
	         	 	<script>
		  				filterViewType('${item.field.propertyType}', 'viewType${item.propertyName }', '${item.field.isPrimaryKey}','${item.field.refType}');		 			
		   			</script>
	        	</c:if>
			</td> 
     	</tr>      
	</c:forEach>
	</table>
	</div>
	</div>
</td></tr>
</table>
</form>
</div>
</body>
</html>