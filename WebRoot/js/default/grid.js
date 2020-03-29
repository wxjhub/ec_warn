var _value_temp;
function Grid() {
	this.name = null;
	this.grid = null;
	
	//grid组件的初始化
	this.init = init;
	function init(gridName) {
		this.name = gridName;
		//this.grid = $("#" + this.name);
	}
	
	//返回options对象，通过此对象可以获取或设置grid组件的属性值
	this.getOptions = getOptions;
	function getOptions(){
		return $("#" + this.name).datagrid('options');
	}
	
	//暂不支持获取分页对象
	//this.getPager = getPager;
	//function getPager(){
	//	var pager = $("#" + this.name).datagrid('getPager');
	//	return $(pager);
	//}
	
	//调整大小和布局
	this.resize = resize;
	function resize(param){
		$("#" + this.name).datagrid('resize', param);
	}
	
	//重新加载grid组件，加载完后，显示第一页的数据，参数格式：{param1:value1, param2:value2}
	this.load = load;
	function load(param) {
		$("#" + this.name).datagrid('load', param);
	}
	
	//重新加载grid组件，并保持在当前页，参数格式：{param1:value1, param2:value2}
	this.reload = reload;
	function reload(param) {
		$("#" + this.name).datagrid('reload', param);
	}
	
	//显示grid的加载状态
	this.loading = loading;
	function loading() {
		$("#" + this.name).datagrid('loading');
	}
	
	//隐藏grid的加载状态
	this.loaded = loaded;
	function loaded() {
		$("#" + this.name).datagrid('loaded');
	}
	
	this.getData = getData;
	function getData(){
		return $("#" + this.name).datagrid('getData');
	}
	
	//返回所有选中的行，当没有选中的记录时，将返回空数组
	this.getAllSelected = getAllSelected;
	function getAllSelected(){
		return $("#" + this.name).datagrid('getSelections');
	}
	
	//选中当前页的所有行
	this.selectAll = selectAll;
	function selectAll() {
		$("#" + this.name).datagrid("selectAll");
	}
	
	//取消选中一行
	this.unselectRow = unselectRow;
	function unselectRow(index){
		$("#" + this.name).datagrid("unselectRow", index);
	}
	
	//根据行号选中某一行
	this.selectRow = selectRow;
	function selectRow(index) {
		$("#" + this.name).datagrid("selectRow", index);
	}
	//根据数据获得行号
	this.getRowIndex = getRowIndex;
	function getRowIndex(row) {
		return $("#" + this.name).datagrid("getRowIndex", row);
	}
	
	//通过 id 的值做参数选中一行
	this.selectRecord = selectRecord;
	function selectRecord(idValue){
		$("#" + this.name).datagrid("selectRecord", idValue);
	}
	
	//取消选中当前页所有的行
	this.unselectAll = unselectAll;
	function unselectAll() {
		$("#" + this.name).datagrid("unselectAll");
	}
	
	//合并单元格
	this.mergeCells = mergeCells;
	/**
	 * @param index 	要合并单元格的行索引
	 * @param field		要合并单元格的列索引
	 * @param rowspan	跨几行
	 * @param colspan	跨几列
	 * @return
	 */
	function mergeCells(index, field, rowspan, colspan) {
		$("#" + this.name).datagrid("mergeCells", {
			index:index,
			field:field,
			rowspan:rowspan,
			colspan:colspan
			});
	}
	
	//显示指定的列
	this.showColumn = showColumn;
	function showColumn(field) {
		$("#" + this.name).datagrid("showColumn", field);
	}
	
	//隐藏指定的列
	this.hideColumn = hideColumn;
	function hideColumn(field){
		$("#" + this.name).datagrid("hideColumn", field);
	}
	
	//刷新一行。
	this.refreshRow = refreshRow;
	function refreshRow(index){
		$("#" + this.name).datagrid("refreshRow", index);
	}
	
	//验证指定的行，有效时返回 true
	this.validateRow = validateRow;
	function validateRow(index){
		return $("#" + this.name).datagrid("validateRow", index);
	}
	
	//返回当前页的行
	this.getRows = getRows;
	function getRows(){
		return $("#" + this.name).datagrid("getRows");
	}
	
	//追加一个新行  param参数包括下列特性：field editor
	this.appendRow = appendRow;
	function appendRow(row, param){
		if(param != undefined) {
			$("#" + this.name).datagrid("addEditor", param);
		}
		$("#" + this.name).datagrid("appendRow", row);
	}
	
	//插入一个新行。param 参数包括下列特性：index row field editor
	this.insertRow = insertRow;
	function insertRow(param){
		if(param.field != undefined && param.editor != undefined ) {
			var fe = {field:param.field,editor:param.editor};
			$("#" + this.name).datagrid("addEditor", fe);
		}
		$("#" + this.name).datagrid("insertRow", param);
	}
	
	//更新指定的行。param 参数包括下列特性：index row
	this.updateRow = updateRow;
	function updateRow(param){
		$("#" + this.name).datagrid("updateRow", param);
	}
	
	//删除一行
	this.deleteRow = deleteRow;
	function deleteRow(index){
		$("#" + this.name).datagrid("deleteRow", index);
	}
	
	//获取最后一次提交以来更改的行。type 参数表示更改的行的类型，可能的值是：inserted、deleted、updated，等等。当 type 参数没有分配时，返回所有改变的行。
	this.getChanges = getChanges;
	function getChanges(type){
		return $("#" + this.name).datagrid("getChanges", type);
	}
	
	//提交自从被加载以来或最后一次调用acceptChanges以来所有更改的数据。
	this.acceptChanges = acceptChanges;
	function acceptChanges(){
		$("#" + this.name).datagrid("acceptChanges");
	}
	
	//回滚自从创建以来或最后一次调用acceptChanges以来所有更改的数据
	this.rejectChanges = rejectChanges;
	function rejectChanges(){
		$("#" + this.name).datagrid("rejectChanges");
	}
	//开始编辑指定的行
	this.beginEdit = beginEdit;
	function beginEdit(rowIndex){
		$("#" + this.name).datagrid("beginEdit",rowIndex);
	}
	//结束编辑指定的行
	this.endEdit = endEdit;
	function endEdit(rowIndex){
		$("#" + this.name).datagrid("endEdit",rowIndex);
	}
	
	//获取指定的编辑器， options 参数包含两个特性： index：行的索引。field：字段名。
	this.getEditor = getEditor;
	function getEditor(options){
		return $("#" + this.name).datagrid("getEditor",options);
	}
	
	//获取指定行的编辑器们。每个编辑器有下列特性：actions：编辑器能做的动作们。target：目标编辑器的 jQuery 对象。field：字段名。type：编辑器的类型。
	this.getEditors = getEditors;
	function getEditors(index){
		return $("#" + this.name).datagrid("getEditors",index);
	}
	
	//删除制定列的编辑器
	this.removeEditor = removeEditor;
	function removeEditor(fieldList){
		$("#" + this.name).datagrid("removeEditor",fieldList);
	}
	
	//为指定的列添加 编辑器。param 参数包含两个特性：field：列名。editor:编辑器
	this.addEditor = addEditor;
	function addEditor(param){
		$("#" + this.name).datagrid("removeEditor",param);
	}
	
	//获得查询表单id  add by tanghui
	this.getQueryForm = getQueryForm;
	function getQueryForm(){
		return $("#" + this.name).datagrid("getQueryForm");
	}
	
	//获得查询表单数据  add by tanghui
	this.getQueryFormParam = getQueryFormParam;
	function getQueryFormParam(){
		return $("#" + this.name).datagrid("getQueryFormParam");
	}
}

/**
*   Usage:  number_format(123456.789, 2, '.', ',');
*   result: 123,456.79
**/
function _number_format(number, format) {
	if(format.indexOf(".")==-1){
		format = format+"."
	}
	var decimals = 0;
	var dec_point = '.';
	var thousands_sep = ',';
	var pre = ''; //格式前缀，如￥/$等
	if(!(/([0-9#])/.test(format.charAt(0)))){
		pre = format.charAt(0);
		format = format.substring(1, format.length);
	}
	var index1 = format.indexOf("."); //小数点的坐标
	if(format.indexOf(".")>-1){
		decimals = format.length - 1 - index1;
		format = format.split('.');
	}
    number = (number + '').replace(/[^0-9+-Ee.]/g, '');
    var n = !isFinite(+number) ? 0 : +number,
        prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
        sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
        dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
        s = '',
        toFixedFix = function (n, prec) {
            var k = Math.pow(10, prec);
            return '' + Math.round(n * k) / k;
        };
    // Fix for IE parseFloat(0.55).toFixed(0) = 0;
    s = (prec ? toFixedFix(n, prec) : '' + Math.round(n)).split('.');
    if (s[0].length > 3) {
        s[0] = s[0].replace(/B(?=(?:d{3})+(?!d))/g, sep);
        var intf = format[0];
        if(intf.indexOf(',') > -1){
        	var forml = format[0].replace(',', '');
        	var s1 = '';
        	intf = intf.split(',').reverse( );
        	if(forml.length > s[0].length){
            	for(var i = 0; i < intf.length; i++){
            		var length = intf[i].length;
            		if(s[0].length >= length){
            			s1 = s[0].substring(s[0].length - length,s[0].length) + s1;
            			s[0] = s[0].substring(0, s[0].length - length);
            		}else{
            			s1 = s[0] + s1;
            			s[0]='';
            		}
            		if(i < intf.length - 1){
            			s1 = ',' + s1;
            		}
            	}
        	}else{
        		while (s[0].length > 0){
        			var length = intf[0].length;
        			if(s[0].length >= length){
            			s1 =',' + s[0].substring(s[0].length - length,s[0].length) + s1;
            			s[0] = s[0].substring(0, s[0].length - length);
            		}else{
            			s1 =',' + s[0] + s1;
            			s[0]='';
            		}
        		}
        		if(s1.length > 0){
        			s1 = s1.substring(1, s1.length);
        		}
        	}
        	
        	s[0] = s1;
        }
    }
    if ((s[1] || '').length < prec) {
        s[1] = s[1] || '';
        s[1] += new Array(prec - s[1].length + 1).join('0');
    }
    return pre + s.join(dec);
}

function _date_format(value,format,hasTime){
	var year = value.year + 1900;
	var month = value.month + 1;
	var date = value.date;
	if(isNaN(year)|| isNaN(month) || isNaN(date)){
		return value;
	}
	if(/(y+)/.test(format)) { 
		format = format.replace(RegExp.$1, (year+"").substr(4 - RegExp.$1.length)); 
	} 
	if(/(M+)/.test(format)){ 
		format = format.replace(RegExp.$1, ((month<10?('0'+month):month)+"").substr(2 - RegExp.$1.length)); 
	} 
	if(/(d+)/.test(format)){ 
		format = format.replace(RegExp.$1, ((date<10?('0'+date):date)+"").substr(2 - RegExp.$1.length)); 
	} 
	if(hasTime){
		var hours = value.hours;
		var minutes = value.minutes;
		var seconds = value.seconds;
		if(!isNaN(hours) || !isNaN(minutes) || !isNaN(seconds)){
			format = format + ' ' +  ((hours<10?('0'+hours):hours));
			format = format + ':' +  ((minutes<10?('0'+minutes):minutes));
			format = format + ':' +  ((seconds<10?('0'+seconds):seconds));	
		}	
	}
	return format; 
};

$.extend($.fn.datagrid.methods, {
	addEditor : function(jq, param) {
		if (param instanceof Array) {
			$.each(param, function(index, item) {
				var e = $(jq).datagrid('getColumnOption', item.field);
				e.editor = item.editor;
			});
		} else {
			var e = $(jq).datagrid('getColumnOption', param.field);
			e.editor = param.editor;
		}
	},
	removeEditor : function(jq, param) {
		if (param instanceof Array) {
			$.each(param, function(index, item) {
				var e = $(jq).datagrid('getColumnOption', item);
				e.editor = {};
			});
		} else {
			var e = $(jq).datagrid('getColumnOption', param);
			e.editor = {};
		}
	}
});

/**
 * @requires jQuery,EasyUI
 * 
 * 扩展datagrid的editor
 * 
 * 增加带复选框的下拉树
 * 
 * 增加日期时间组件editor
 * 
 * 增加多选combobox组件
 */
var treeOpt =null;
$.extend($.fn.datagrid.defaults.editors, {
	multiplecombotree : {
		init : function(container, options) {
			var editor = $('<input />').appendTo(container);
			options.multiple = true;
			editor.combotree(options);
			return editor;
		},
		destroy : function(target) {
			$(target).combotree('destroy');
		},
		getValue : function(target) {
			return $(target).combotree('getValues').join(',');
		},
		setValue : function(target, value) {
			$(target).combotree('setValues', sy.getList(value));
		},
		resize : function(target, width) {
			$(target).combotree('resize', width);
		}
	},
	datetimebox : {
		init : function(container, options) {
			var editor = $('<input />').appendTo(container);
			editor.datetimebox(options);
			return editor;
		},
		destroy : function(target) {
			$(target).datetimebox('destroy');
		},
		getValue : function(target) {
			return $(target).datetimebox('getValue');
		},
		setValue : function(target, value) {
			$(target).datetimebox('setValue', value);
		},
		resize : function(target, width) {
			$(target).datetimebox('resize', width);
		}
	},
	/**
	 * editor的工作流程：
	 * 在非编辑状态，隐藏不显示
	 * 当进入编辑状态时，方法调用的先后顺序为：
	 * init
	 * resize
	 * setValue 
	 * 当结束编辑状态时，方法调用的先后顺序为：
	 * getValue 
	 */
	popTree: {  
        init: function(container, opt){ 
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
            var input = $(
            		"<span class='datagrid-editable-popTree'>" +
            		"<input type='hidden' class='popTree-value'/>"+
            		"<input type='text' class='popTree-text' readonly='readonly'>" +
            		"<span class='popTree-btn'/></span></span>" 
            ).appendTo(container);  
            /**
             * 在getValue用到了opt，所以在外面定义treeOpt提升其作用域
             * treeOpt中保存了，该对象的idField名称、pIdField名称、textField名称等
             */
            treeOpt = opt;
           if(opt.required){
        	   $('.popTree-text').validatebox({  
				    required: true
				});
           }			            
           return input; 
        },  
        /**
         * @param target span.datagrid-editable-input 定义的编辑器
         * @returns
         */
        getValue: function(target){
        	/**
        	 * $(target).val()-->可以获取到整个对象，该对象是没有编辑之前的值。
        	 */
        	var val = $(target).val();
        	var getVal;
        	if(_value_temp!=null){
        		getVal = _value_temp;
        		getVal.children = null;
        		_value_temp = null;
        	}
        	/**
        	 * 使用一下两步，深度复制一个没有编辑之前的值对象
        	 */
        	var s = JSON.stringify( val ); 
        	var result = eval("("+ s+")" );
        	/**
        	 * 根据编辑器中保存的值，将之前的值修改为现在编辑之后的值
        	 * $(".popTree-value").val()从编辑器中取出的值，修改之后的id值
        	 * $(".popTree-text").val()从编辑器中取出的值，修改之后的text值
        	 */
        	result[treeOpt.idField] =$(".popTree-value").val();
        	result[treeOpt.textField] =$(".popTree-text").val();
        	/**
        	 * 返回编辑之后的值，这样就可以正常的回显编辑之后的字了
        	 */
        	 if(val!=null){
        	 //	 alert("getValue="+s);
        	 }
        	if(getVal!=null){
        		return getVal;
        	}else{
        		return result;
        	}
        },  
        /**
         * @param target -->span.datagrid-editable-input 定义的编辑器
         * @param value	 -->Object 该字段对应的对象，例如：org对象
         */
        setValue: function(target, value){
        	
        	/**
        	 * 设置隐藏域保存对象的id值
        	 */
        	$(".popTree-value").val(value[treeOpt.idField]);
        	/**
        	 * 设置文本框回显对象的text值
        	 */
            $(".popTree-text").val(value[treeOpt.textField]);  
            /**
             * 绑定点击span弹出窗口按钮时执行的事件方法
             * 在该阶段绑定的原因是：该阶段能获取到当前column中已经选中的值
             * 这样通过get传递到弹出的窗口，用于默认选中值
             * 在url中get提交了，构建zTree所需的所用参数
             * **因为使用get提交该部分一定要注意乱码现象
             */
        	$('.popTree-btn').bind('click',function(){
        		var winUrl = "../../node_tree.jsp?url="+treeOpt.url;
        		winUrl = winUrl +"&idField="+treeOpt.idField;
        		winUrl = winUrl +"&pIdField="+treeOpt.pIdField;
        		winUrl = winUrl +"&textField="+treeOpt.textField;
//        		winUrl = winUrl +"&onLoadSuccess="+treeOpt.onLoadSuccess;
//        		winUrl = winUrl +"&onLoadError="+treeOpt.onLoadError;
        		winUrl = winUrl +"&currNodeId="+value[treeOpt.idField];
        		/**
        		 * 调用封装好的弹出窗口方法，并将回调方法传入
        		 */
        		showModalCenter (winUrl,treeOpt.callBackFun,treeOpt.winWidth,treeOpt.winHeight,treeOpt.winTitle);
        	});
        	 //alert("setValue="+$(".popTree-text").val());
        	 if(_value_temp!=null){
        	 	$(target).val(_value_temp);
        	 }else{
        	 	$(target).val(value);
        	 }
            
        }, 
        resize: function(target, width){  
            var input = $(target);  
            if ($.boxModel == true){  
                input.width(width - (input.outerWidth() - input.width()));  
            } else {  
                input.width(width);  
            }  
        }  
    },
    numberZoom:{
		init : function(container, opt) {
			var editor = $('<input id="'+opt.fieldId+'_textId" class="datagrid-editable-input"/><span style="display:none">'+opt.zoom+'</span>').appendTo(container);
			if(opt.required){
				if(opt.missingMessage){
					$('#'+opt.fieldId+'_textId').validatebox({  
					  	required: true,
					  	missingMessage:opt.missingMessage
					});
				}else{
					$('#'+opt.fieldId+'_textId').validatebox({  
				  		required: true
					});
				}
          	}
			return editor;
		},
		getValue : function(target) {
			var result = $(target).val();
			var zoom = $("#"+target[0].id+"+span").text();
			var t1=0,t2=0,r1,r2;
    		try{t1=result.toString().split(".")[1].length}catch(e){}
   			try{t2=zoom.toString().split(".")[1].length}catch(e){}
   			with(Math){
		        r1=Number(result.toString().replace(".",""))
		        r2=Number(zoom.toString().replace(".",""))
		        var resultNumber =  (r1/r2)*pow(10,t2-t1);
			}
		 	return Number(resultNumber.toFixed(6));
		},
		setValue : function(target, value) {
			var zoom = $("#"+target[0].id+"+span").text();
			if(value != undefined || value != null){
				var m=0,s1=value.toString(),s2=zoom.toString();
         		try{m+=s1.split(".")[1].length;}catch(e){}
         		try{m+=s2.split(".")[1].length;}catch(e){}
				$(target).val(Number(s1.replace(".",""))*Number(s2.replace(".",""))/Math.pow(10,m));
			}
		}
	},
	multiplecombobox : {
		init : function(container, options) {
			var editor = $('<input />').appendTo(container);
			options.multiple = true;
			editor.combobox(options);
			return editor;
		},
		destroy : function(target) {
			$(target).combobox('destroy');
		},
		getValue : function(target) {
			return $(target).combobox('getValues').join(',');
		},
		setValue : function(target, value) {
			$(target).combobox('setValues', sy.getList(value));
		},
		resize : function(target, width) {
			$(target).combobox('resize', width);
		}
	}
	
});


/**
 * 扩展两个方法
 */
$.extend($.fn.datagrid.methods, {
    /**
     * 开打提示功能
     * @param {} jq
     * @param {} params 提示消息框的样式
     * @return {}
     */
    doCellTip: function(jq, params){
        function showTip(data, td, e){
            if ($(td).text() == "") 
                return;
            data.tooltip.text($(td).text()).css({
                top: (e.pageY + 10) + 'px',
                left: (e.pageX + 20) + 'px',
                'z-index': $.fn.window.defaults.zIndex,
                display: 'block'
            });
        };
        return jq.each(function(){
            var grid = $(this);
            var options = $(this).data('datagrid');
            if (!options.tooltip) {
                var panel = grid.datagrid('getPanel').panel('panel');
                var defaultCls = {
                    'border': '1px solid #CC9933',   
                    'padding': '2px',
                    'color': '#333',
                    'background': '#ffffcc',
                    'position': 'absolute',
                    'max-width': '200px',
					'border-radius' : '4px',
					'-moz-border-radius' : '4px',
					'-webkit-border-radius' : '4px',
                    'display': 'none',
                    'font-family':'Microsoft YaHei',
                    'font-size':'12px'
                }
                var tooltip = $("<div id='celltip'></div>").appendTo('body');
                tooltip.css($.extend({}, defaultCls, params.cls));
                options.tooltip = tooltip;
                panel.find('.datagrid-body').each(function(){
                    var delegateEle = $(this).find('> div.datagrid-body-inner').length ? $(this).find('> div.datagrid-body-inner')[0] : this;
                    $(delegateEle).undelegate('td', 'mouseover').undelegate('td', 'mouseout').undelegate('td', 'mousemove').delegate('td', {
                        'mouseover': function(e){
                            if (params.delay) {
                                if (options.tipDelayTime) 
                                    clearTimeout(options.tipDelayTime);
                                var that = this;
                                options.tipDelayTime = setTimeout(function(){
                                    showTip(options, that, e);
                                }, params.delay);
                            }
                            else {
                                showTip(options, this, e);
                            }
                            
                        },
                        'mouseout': function(e){
                            if (options.tipDelayTime) 
                                clearTimeout(options.tipDelayTime);
                            options.tooltip.css({
                                'display': 'none'
                            });
                        },
                        'mousemove': function(e){
							var that = this;
                            if (options.tipDelayTime) 
                                clearTimeout(options.tipDelayTime);
                            //showTip(options, this, e);
							options.tipDelayTime = setTimeout(function(){
                                    showTip(options, that, e);
                                }, params.delay);
                        }
                    });
                });
                
            }
            
        });
    },
    /**
     * 关闭消息提示功能
     *
     * @param {}
     *            jq
     * @return {}
     */
    cancelCellTip: function(jq){
        return jq.each(function(){
            var data = $(this).data('datagrid');
            if (data.tooltip) {
                data.tooltip.remove();
                data.tooltip = null;
                var panel = $(this).datagrid('getPanel').panel('panel');
                panel.find('.datagrid-body').undelegate('td', 'mouseover').undelegate('td', 'mouseout').undelegate('td', 'mousemove')
            }
            if (data.tipDelayTime) {
                clearTimeout(data.tipDelayTime);
                data.tipDelayTime = null;
            }
        });
    }
});