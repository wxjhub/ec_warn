/**
 * popTree 控件
 * @author Haoliang
 */
 
function PopTree() {
	this.name = null;
	this.popTree = null;
	
	this.init = init;
	function init(popTreeId) {
		this.id = popTreeId;
	}
	
	//设置组件的值
	this.setValue = setValue;
	function setValue(value){
		$("#"+this.id).popTree("setValue",value);
	}
	
	//获取组件的值
	this.getValue = getValue;
	function getValue(){
		return $("#"+this.id).popTree("getValue");
	}
	
	//清空组件的值
	this.clear = clear;
	function clear(){
		return $("#"+this.id).popTree("clear");
	}	
}
(function($) {
	//根据页面配置创建组件源码
	function create(jq,target) {
		//获取popTree的options，从而得到option中的属性
		var options = $.data(jq, "popTree").options;
        var textValue = $(jq).attr("textValue");	//获取页面配置的textValue值

        /**编辑器由两个span组成
        	 * 一个是用于弹出窗口的span按钮，在右边
        	 * 一个span作为外层的包裹，在左边，里面有
        	 * hidden隐藏域		用于存放整个对象的id值，
        	 * ************
        	 * 由于隐藏域保存的不是整个对象的值，有可能导致
        	 * 对象的其他值没有修改，只修改了 id、value值。
        	 * 隐藏域没有放Object对象值得原因是，在editor修改之后，col进入非编辑状态调用
        	 * getValue的时候只能获得之前的Object对象值，
        	 * 弹出窗口的回调函数中只有，id、pid、zTreenode值，
        	 * 不能完整的替换隐藏域中的Object对象值。
        	 * ************
        	 * text输入框		用于存放对象的text值，用户在可编辑状态时，回显值，是只读属性的
        	 */
        var popTree = "<span class='easyui-popTree'>" +
            		  "<input id='"+jq.id+"' type='hidden' class='popTree-value'/>"+
            		  "<input id='"+jq.id+"_text' type='text' class='popTree-text' readonly='readonly'>" +
            		  "<span id='"+jq.id+"_popTree-btn' class='popTree-btn'/></span></span>";
        $(jq).after(popTree); //将popTree展示到页面
        $(jq).remove();		//移除原代码对象
        
        //当value不为空时，为组件赋值
        if(jq.value!=null){
        	$('#'+jq.id).attr("value",jq.value);
        	$('#'+jq.id+'_text').attr("value",textValue);
        }
        
        //当name不为空时，为组件赋值
        if(jq.name!=null){
        	$('#'+jq.id).attr("name",jq.name);
        }
        
        //当styleClass不为空时，为组件input添加样式类
        if(options.styleClass!=null){
        	$('#'+jq.id+'_text').toggleClass(options.styleClass);
        }
        
        //当style不为空时，为组件input添加style属性
        if(options.style!=null){
        	$('#'+jq.id+'_text').attr("style",options.style);
        }
        
        //当width不为空时，为组件input添加宽度样式
        if(options.width!=null){
        	$('#'+jq.id+'_text').css("width",options.width);
        }
        
        //当disabled为true时，组件不可用
        if(options.disabled){
        	$('#'+jq.id+'_popTree-btn').attr("disabled","true");
        	$('#'+jq.id+'_text').attr("disabled","true");
        }
        
        //当required为true时，为组件添加非空验证
        if(options.required){
        	if(options.missingMessage!=null){
        		$('#'+jq.id+'_text').validatebox({  
			    	required: true,
			    	missingMessage:options.missingMessage
				});
        	}else{
        		$('#'+jq.id+'_text').validatebox({  
			    	required: true
				});
        	}
        }
        
        //为组件绑定单击事件
        $('#'+jq.id+'_popTree-btn').bind('click',function(){
        	var winUrl = "../../node_tree.jsp?url="+options.url;
			winUrl = winUrl +"&idField="+options.idField;
        	winUrl = winUrl +"&pIdField="+options.pIdField;
        	winUrl = winUrl +"&textField="+options.textField;
        	if($("#"+jq.id).val()==options.idField && jq.value!=null){
        		$("#"+jq.id).val(jq.value);
       		}
        	winUrl = winUrl +"&currNodeId="+$("#"+jq.id).val();
			/**
			 * 调用封装好的弹出窗口方法，并将回调方法传入
			 */
        	showModalCenter (winUrl,options.callBackFun,options.winWidth,options.winHeight,options.winTitle);
        });
	};
	/**
	 * 实例化popTree
	 */
	$.fn.popTree = function(options, param){
		if (typeof options == "string") {
			var fn = $.fn.popTree.methods[options];
			if (fn) {
				return fn(this, param);
			} else {
				return this.popTree(options, param);
			}
		}
		options = options || {};
		return this.each(function() {
			var data = $.data(this, "popTree");
			if (data) {
				$.extend(data.options, options);
				create(this);
			} else {
				data = $.data(this, "popTree", {
					options : $.extend( {}, $.fn.popTree.defaults,
					$.fn.popTree.parseOptions(this), options)
				});
				create(this);
			}
		});
	};
	/**
	 * 方法注册
	 * @param {Object} jq
	 * @return {TypeName} 
	 */
	$.fn.popTree.methods = {
		options : function(jq) {
//			var dsadsd = $('#'+jq[0].options);
//			alert(dsadsd.idField);
		},
		getValue: function(target){
			var val = $("#"+target[0].id).val();
			return val;
        }, 
        setValue: function(target, value){
        	/**
        	 * 设置隐藏域保存对象的id值
        	 */
        	$("#"+target[0].id).val(value.id);
        	/**
        	 * 设置文本框回显对象的text值
        	 */
            $("#"+target[0].id+"_text").val(value.text);
            
        }, 
		clear : function(jq) {
			return jq.each(function() {
				$('#'+jq[0].id).val("");
				$('#'+jq[0].id+'_text').val("");
			});
		}
	};
	
	/**
	 * class声明式定义属性转化为options
	 * @param {Object} target DOM对象
	 * @return {TypeName} 
	 */
	$.fn.popTree.parseOptions = function(target) {
//		var t = $(target);
//		alert(t.attr("width"));
//		return $({
//			winWidth :  t.attr("width"),
//			winHeight :  t.attr("height"),
//			winTitle :  t.attr("title"),
//			idField : t.attr("value"),
//			textField : t.attr("text"),
//			url : t.attr("url"),
//			pIdField:t.attr("pIdField"),
//			required : t.attr("required")
//		});
	};
//	$.fn.popTree.defaults = $({
//		winWidth : 'auto',
//		winHeight : 'auto',
//		winTitle : "请选择",
//		idField : null,
//		textField : null,
//		pIdField:null,
//		url : null,
//		required : false,
//		textWidth : 'auto',
//		formatter : function(row) {
//			alert(options);
//			var options = $(this).popTree("options");
//			return row[options.text];
//		},
//		beforeClose : function() {
//		},
//		afterClose : function() {
//		}
//	});
})(jQuery);