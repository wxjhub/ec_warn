	 // JavaScript Document

	 //自定义网格隔行变色
	 $(function(){
		 $("#tab tr:nth-child(even)").addClass("trOdd");
		 $("#tab tr:nth-child(odd)").addClass("trEven");
	 });
	 
	//自定义网格表格鼠标经过变色
	$(function(){
		$('.table_list tr').mouseenter(function(){
			$(this).children('td').addClass('td_bg');
		})
		$('.table_list tr').mouseleave(function(){
			$(this).children('td').removeClass('td_bg');
		})
	})
	 
	//自定义网格全选、反选,
	function isCheck(obj){
		var isBuy=document.getElementsByName("_idcb");
	 	//var countNum=$("input");
	 	if(obj){
	 		for(var i=0;i<isBuy.length;i++)
			{
				if(isBuy[i].type=="checkbox")
				{
					
					isBuy[i].checked=true;
					$("#"+(i)).addClass("selectedbg");
				}
			}
	 	}
	 	else
	 	{
	 		for(var i=0;i<isBuy.length;i++)
			{
				if(isBuy[i].type=="checkbox")
				{
					isBuy[i].checked=false;
					$("#"+(i)).removeClass("selectedbg");
				}
			}
	 	}
	}

	
	//自定义网格单击行选择当前行
	 function selectRow(obj) {
	 	 if(obj.tagName == 'INPUT'){
	 	 	var tbody = obj.parentElement.parentElement;
	 	 	if(tbody.cells[0].children[0].checked){
	 	 		tbody.cells[0].children[0].checked = true;
		 		$("#"+tbody.id).addClass("selectedbg");
	 	 		
		 	}else{
		 		$("#"+tbody.id).removeClass("selectedbg");
		 		tbody.cells[0].children[0].checked = false;
		 	}
	 	 }
	 	 if (obj.tagName == 'TD') {
	 	 	var tbody = obj.parentElement;
		 	if(tbody.cells[0].children[0].checked){
		 		$("#"+tbody.id).removeClass("selectedbg");
		 		tbody.cells[0].children[0].checked = false;
		 	}else{
		 		//alert($("#"+obj.id).html());
		 		$("#"+tbody.id).addClass("selectedbg");
		 		tbody.cells[0].children[0].checked = true;
	//	 		for(var i = 1; i < obj.cells.length; i++) 
	//			{ 
	//				alert($("#"+obj.cells(i).id).text());
	//			}
		 	}
	 	 }
		 //var tbody = obj.parentElement;
		 //alert(tbody.rows.length-1);
		/** if (obj.tagName == 'TD') {
			 var tbody = obj.parentElement.parentElement;
			 alert($('#'+obj.parentElement.id).html());
			 alert($('#userName').text());
	 	 } */
	 }

	 
  /**
   *移动全部，配置用户角色
  */
   function moveAll(moveto){
        //取得两个对象
       var sel0=document.getElementById("roleLeft");
       var sel2=document.getElementById("selectRole");
        //如果要把右侧数据全移到左侧则调换两个对象
       if(moveto=='left'){
            sel0=document.getElementById("selectRole");
       		sel2=document.getElementById("roleLeft");

     }
      var length=sel0.options.length;
         for(var i=0;i<length;i++){
         	var tem=sel0.options[0];
         	sel2.appendChild(tem);
      }
    }

    /**
   *移动部分，配置用户角色
   *roleLeft被移动的对象
  *selectRole目标对象
    */
   function move(roleLeft,selectRole){
       var sel0=document.getElementById(roleLeft);
       var sel2=document.getElementById(selectRole);
       var length=sel0.options.length;
       for(var i=length-1;i>=0;i--){
           var tem=sel0.options[i];
           if(tem.selected){
               sel2.appendChild(tem);
           }
       }
   }
   
   //自定义网格分页按钮样式
    $(function(){
   		if(parseInt($("#maxPageNo").val())==1){
   			document.getElementById('firstpages').className="firstpages2"; 
   			document.getElementById('lastpage').className="lastpage2"; 
   			document.getElementById('prevpage').className="prevpage2"; 
   			document.getElementById('nextpage').className="nextpage2";
   			document.getElementById('goPage').className="goPage2"; 
   			
   			document.getElementById('firstpages').href = 'javascript:CopyUrl()';
   			document.getElementById('lastpage').href = 'javascript:CopyUrl()';
   			document.getElementById('prevpage').href = 'javascript:CopyUrl()';
   			document.getElementById('nextpage').href = 'javascript:CopyUrl()';
   			document.getElementById('goPage').href = 'javascript:CopyUrl()';
   		}
   		else if((parseInt($("#pageNo").val())==1) && (parseInt($("#maxPageNo").val())>1)){
			document.getElementById('firstpages').className="firstpages2";
			document.getElementById('prevpage').className="prevpage2"; 
			
			document.getElementById('firstpages').href = 'javascript:CopyUrl()';
			document.getElementById('prevpage').href = 'javascript:CopyUrl()';
		}
		if((parseInt($("#pageNo").val())>1) && ($("#pageNo").val()==$("#maxPageNo").val())){
			document.getElementById('lastpage').className="lastpage2";
			document.getElementById('nextpage').className="nextpage2";
			//document.getElementById('goPage').className="goPage2"; 
			
			document.getElementById('lastpage').href = 'javascript:CopyUrl()';
			document.getElementById('nextpage').href = 'javascript:CopyUrl()';
			//document.getElementById('goPage').href = 'javascript:CopyUrl()';
		}
		if((parseInt($("#maxPageNo").val())>1) && (parseInt($("#pageNo").val())==1)){
			document.getElementById('firstpages').className="firstpages2"; 
			document.getElementById('prevpage').className="prevpage2"; 
			
			document.getElementById('firstpages').href = 'javascript:CopyUrl()';
			document.getElementById('prevpage').href = 'javascript:CopyUrl()';
		}
    });

    //回车跳转
	//    function SubmitKeyClick(obj, evt) {
	//        evt = (evt) ? evt : ((window.event) ? window.event : "");
	//        keyCode = evt.keyCode ? evt.keyCode : (evt.which ? evt.which : evt.charCode);
	//        if (keyCode == 13) {
	//            getPage();
	//   		}
	//	}
	
	//自定义网格跳转页面
	function getPage(){
        var pageNo = $("#goPageNo").val();
        var tempPageNo=parseInt(pageNo);
        if(parseInt(pageNo)>parseInt($("#maxPageNo").val())){
        	$.messager.alert('系统提示','您输入的页码超出总页数，请重新输入！','warning');
        	$("#goPageNo").val("1");
			return false;
        }
        if(tempPageNo<1){
        	pageNo=1;
        }else{
        	pageNo=tempPageNo;
        }
        query(pageNo);
	};
	
	//	日期格式化 应郝亮和刘浩要求，注释掉。
	//	以后其他页面有影响你可以把这段放在当前页面上。或者引用easyui-lang-zh_CN.js
	//	$.fn.datebox.defaults.formatter = function(date){
	//		var y = date.getFullYear();
	//	  	var m = date.getMonth()+1;
	//		var d = date.getDate();  
	//		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);  
	//	};

	
	//文本框获取焦点、失去焦点改变边框样式
	$(function(){
		$(".input_eq2").focus(function(){
			$(this).css("border-color","#8DB2E3");
		});
		$(".input_eq2").blur(function(){
			$(this).css("border-color","#CCC");
		});
	}); 
	
	//吕新亮 添加 解决Easyui表单提交 后台抛出异常，页面不能正常跳转的问题 2013/5/6
	function hasException(data){
		var startFlag = "_start_exception";
		var endFlag = "_end_exception";
		var start = data.indexOf(startFlag)+startFlag.length+1;
		var end = data.indexOf(endFlag)-6;
		if(start>0){
			$.messager.alert('系统异常提示',data.substring(start,end),'warning');
		}
	}
	
	//得到异步提交后返回的异常信息
	function getAjaxException(data){
		var result=eval("(" + data + ")");
		var errorState = result.errorState;
		if(errorState == 0){
			$.messager.alert('系统异常提示',result.errorMessage,'warning');
		}
	}
	
	//处理AJAX的session过期问题  及异步错误提示 
	$.ajaxSetup({   
	    contentType:"application/x-www-form-urlencoded;charset=utf-8",   
	    cache:false ,   
	    complete:function(XHR,TS){   
		   var resText=XHR.responseText;
		   if(resText.indexOf("sessionState")>0) {
			   var result = $.parseJSON(resText); 
			   if(result != null) {
				   if(result[0]!=null && result[0].sessionState=="0"){   
			           window.location.href = result[0].url+'/login.jsp';
			       }
			   }   
		   } 
		   if(resText.indexOf("loginState")>0) {
			   var result = $.parseJSON(resText); 
			   if(result != null) {
				   if(result[0]!=null && result[0].loginState=="0"){
					   window.location.href = result[0].url + '/logout';
				   }
			   }   
		   } 
		   if(resText.indexOf("errorState")>0) {
			   var result = $.parseJSON(resText); 
			   if(result != null) {
		    	   for(var i =0;i<result.length;i++) {
		    		   if(result[i]!=null && result[i].errorState=="0") {
		    			   $.messager.alert('系统异常提示',result[i].errorMessage,'warning');
		    		   }
		    	   }
			   }   
		   }
	 	}
	});
	
	