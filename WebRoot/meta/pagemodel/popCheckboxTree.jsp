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
</head>
<body>

	<script type="text/javascript">
	//获取选中的树结点
	
	function getSelected(){
		var nodes = $('#popTree').tree('getChecked');		
		var sid = '';
		var sname='';
		for(var i=0; i<nodes.length; i++){
			//alert(nodes[i].id);	
			sid+=nodes[i].id;
			sname+=nodes[i].text;
			if(i!=nodes.length-1){
			sid+=',';				
			sname+='**';
			}		
		}
		if(sname==''){
			$.messager.alert('系统提示','请选择抵质押担保品!','warning');
			}else{
		//alert(sid+"||"+sname);
		window.returnValue = sid+"||"+sname;
		window.close();     
		}
		   
	}
	function fun_back(){
		window.close();
	}	
   		$(function(){
   			document.getElementById("sText").style.display = "block"; 
	   		
           $('#popTree').tree({   
              	checkbox: true,   
                url: 'metadataJson_getTreeRootJson.action?method=getTreeRootJson&modelName=mortgage',   
                state:'closed',
                onBeforeExpand:function(node,param){
            //   $('#popTree').tree('options').url = "metadataJson_getTreeRootJson?method=getTreeRootJson&modelName=${param.modelName}&currentValue="+node.id;// change the url   
               
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
<hr color="blue"></hr>
	 <input type="button" class="button" value="确定" onclick="getSelected();"/>
	 <input type="button" class="button" value="取消" onclick="fun_back()"/>
</body>
</html>

