<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>popTree</title>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/css_new.css"/>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/themes/default/easyui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/all.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/Admin.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/metadata/showModalCenter.js"></script>
</head>
<body>

	<script type="text/javascript">
		
   		$(function(){
   			document.getElementById("sText").style.display = "block"; 
   			var modelName = "${param.modelName}";
	   		var refModelPkProp = "${param.refModelPkProp}";
	   		var refModelNameProp = "${param.refModelNameProp}";

           $('#popTree').tree({   
              	checkbox: false,   
                url: 'metadataJson_getTreeRootJson.action?method=getTreeRootJson&modelName=' + modelName + '&refModelPkProp=' + refModelPkProp + '&refModelNameProp=' + refModelNameProp,   
                state:'closed',
                onBeforeExpand:function(node,param){
             //  $('#popTree').tree('options').url = "metadataJson_getTreeRootJson?method=getTreeRootJson&modelName=${param.modelName}&currentValue="+node.id;// change the url   
               
               },               
               onClick:function(node){    
            	   var node = $('#popTree').tree('getSelected');  //
            	   //if (node.state){
           		   //		$.messager.alert('系统提示','该节点下包含叶子节点，请重新选择!','warning');
          	    	//	return false;
            	   //}        
            	   closeModalCenter(node.attributes[refModelPkProp]+","+node.text);
               }  
           });   
       }); 
   		$(function(){
			window.setTimeout(hidden,500);		
			});
		function hidden(){
			document.getElementById("sText").style.display = "none"; 
			}
 	</script>
 	<div id="sText" style="display:none;">请稍等，正在加载数据……</div> 
 	 <ul id="popTree">
     </ul>
<br></br>
	 	
</body>
</html>

