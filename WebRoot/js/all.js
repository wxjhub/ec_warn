	// JavaScript Document
	
	//自定义网格表格鼠标经过变色
	$(function(){
		$('.table_list tr').mouseenter(function(){
			$(this).children('td').addClass('td_bg');
		})
		$('.table_list tr').mouseleave(function(){
			$(this).children('td').removeClass('td_bg');
		})
	})
	
	//关闭左侧内容
	var screenwidth = $(window).width();
	$(function(){
		$('.lefticons').toggle(
			function(){
				$(this).addClass('lefticons_s');
				$('#leftMenu').panel('resize',{width:5});
				$('#center').panel('resize',{
					left:5,
					width:screenwidth-5
				});
			},
			function(){
				$(this).removeClass('lefticons_s');
				$('#leftMenu').panel('resize',{width:197});
				$('#center').panel('resize',{
					left:197,
					width:screenwidth-197
				});
			}
		);
	})

	//自定义网格隔行变色
	$(function(){
		$("#tab tr:nth-child(even)").addClass("trOdd");
		$("#tab tr:nth-child(odd)").addClass("trEven");
	});
		 
	 //自定义网格全选、反选按钮,整理后封入js文件，加注释说明是咱们后加的方法
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

	
	//自定义网格单击行选择checkbox
	 function selectbox(obj) {
		 if (obj.tagName == 'TD') {
			 var tbody = obj.parentElement.parentElement;
			 for (var i=0; i<tbody.rows.length; i++)  
			 tbody.rows[i].cells[0].children[0].checked = false;
			 obj.parentElement.cells[0].children[0].checked = true;
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
