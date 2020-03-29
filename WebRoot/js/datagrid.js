$(function() {
	/*查询定义*/
	window.$_formSearch = $("#formSearch");
	
	window.query = function (pageNo) {
		if(!pageNo) pageNo = $("#pageNo").val();
		if(!pageNo) pageNo = 1;
		var pageSize = "";
		if($("#pageSize").length != 0) 
			pageSize = $("#pageSize").val();
		if(!pageSize) pageSize = "";
		$_formSearch.append("<input type='hidden' value='"+pageNo+"' name='pageNo'/>");
		$_formSearch.append("<input type='hidden' value='"+pageSize+"' name='pageSize'/>");
		
		if($_formSearch.length > 0) {
			$_formSearch[0].action = queryPath;
			$_formSearch[0].submit();
		}
	};
	
	
    var $_datagrid_header_inner = $(".datagrid-header-inner");
    if ($_datagrid_header_inner.length == 0) 
    	return false;
    
    var $_datagrid_body 		= $(".datagrid-body");
    var $_datagrid_view 		= $(".datagrid-view");
    var $_table_body 			= $_datagrid_body.children("table:first");
    var $_body_checkbox 		= $_table_body.find(":checkbox");
    var $_head_checkbox 		= $(".datagrid-header-check").children("input:first");
    var singleSelect			= $_head_checkbox.attr("singleSelect"); 
    
    
    //表头随水平滚动条移动 
    $_datagrid_body.scroll(function() {
        $_datagrid_header_inner.css("margin-left", -this.scrollLeft);
    });

    //隔行变色 
    window.setDatagridColor = function(){
	    $_table_body.find("tr").each(function(i){
	    	if(i % 2 == 0)
	    		$(this).removeClass("datagrid-row-alt");
	    	else
	    		$(this).addClass("datagrid-row-alt");
	    		
	    });
    };
    setDatagridColor();

    //鼠标滑过变色 
    var $_table_body_tr = $_table_body.find("tr");
    $_table_body_tr.unbind("mouseenter");
    $_table_body_tr.unbind("mouseleave");
    $_table_body_tr.bind({
        mouseenter: function() {
            $(this).addClass("datagrid-row-over");
        },
        mouseleave: function() {
            $(this).removeClass("datagrid-row-over");
        }
    });

    //全选所有行
    $_head_checkbox.unbind("click");
    $_head_checkbox.bind("click", function() {
    	if(singleSelect) return false;		//单选
        $_body_checkbox.attr("checked", this.checked);
        if (this.checked)
            $_table_body.find("tr").addClass("datagrid-row-selected");
        else
            $_table_body.find("tr").removeClass("datagrid-row-selected");
    });

    //单击选中该行
    var $_table_body_td = $_table_body.find("td");
    $_table_body_td.unbind("click");
    $_table_body_td.bind("click", (function() {
    		/*
	        var $_tr = $(this).parent();
	        var $_ck = $_tr.children("td:first").find(":checkbox");
	        var ckValue = $_ck.attr("checked");
	    	
	    	if(singleSelect) {
	    		$_body_checkbox.attr("checked", false);
	    		$_body_checkbox.parent().parent().parent().removeClass("datagrid-row-selected");
	    	}
	        $_ck.attr("checked", !ckValue);
	        if (!ckValue)
	            $_tr.addClass("datagrid-row-selected");
	        else
	            $_tr.removeClass("datagrid-row-selected");
	        //是否选中全选按钮
	        $_head_checkbox.attr("checked", $_table_body.find(":checked").length == $_body_checkbox.length);
	        */
    	
	    	var $_tr = $(this).parent();
	        var $_ck = $_tr.children("td:first").find(":checkbox");
	        var ckValue = $_ck.attr("checked");
	        
	        var autoSelect = $("#autoSelect").attr("checked");
	        
	        if(ckValue != "checked" && autoSelect == "checked") {
	        	
	        	$_body_checkbox.attr("checked", null);
	            $_table_body.find("tr").removeClass("datagrid-row-selected");
	        	
		        var currentRow = eval("(" + $_ck.val() + ")");
		        var rows = $("input[name='checkboxName'][flowId='" + currentRow.flowId + "'][nodeId='" + currentRow.nodeId + "']");
		        $.each(rows, function(i, data){
		        	$(this).attr("checked", !ckValue);
			        if (!ckValue)
			        	$(this).parent().parent().parent().addClass("datagrid-row-selected");
			        else
			        	$(this).parent().parent().parent().removeClass("datagrid-row-selected");	        	
		        });
	        } else {
	        	if(singleSelect) {
		    		$_body_checkbox.attr("checked", false);
		    		$_body_checkbox.parent().parent().parent().removeClass("datagrid-row-selected");
		    	}
	        	$_ck.attr("checked", !ckValue);
	 	        if (!ckValue)
	 	            $_tr.addClass("datagrid-row-selected");
	 	        else
	 	            $_tr.removeClass("datagrid-row-selected");
	        }
	        
	        //是否选中全选按钮
	        $_head_checkbox.attr("checked", $_table_body.find(":checked").length == $_body_checkbox.length);
	    })
    );
    
    //单击checkbox
    $_body_checkbox.unbind("click");
    $_body_checkbox.bind("click", function(event) {
        $(this).attr("checked", !this.checked);
    });

    //页码输入框检查
    $("#pageNo").change(function() {
        if (!/^[1-9]\d*$/.test(this.value)) {
            this.value = '1';
        }
    });

    //查询
    $("#pageSize").change(function() {
        query(1);
    });

    //分页按钮设置
    (function() {
        var totalPageCount = $("#totalPageCount").val();
        var pageNo = $("#pageNo").val();
        if (pageNo == 1) {disableBtn(["firstpage", "prevpage"]);}
        if (pageNo == totalPageCount) {disableBtn(["nextpage", "lastpage"]);}
        if (totalPageCount == 1) {disableBtn(["goPage"]);}
        
        function disableBtn(idArr) {
            $.each(idArr, function(i, id) {
                var $_obj = $("#" + id);
                $_obj.addClass("l-btn-disabled");
                $_obj.attr("href", "javascript:void(0)");
            });
        }
    })();

    //表格高度自适应屏幕高度
    (function() {
        var domHeight = $(document).height();
        var bodyHeight = document.body.clientHeight;
        var heightValue = domHeight - bodyHeight;
        
        if (heightValue <= 0 && document.body.scrollHeight <= 0) {
            heightValue = $(window.parent.document.body).height() - 153;
            $_datagrid_view.css({height: heightValue});
            $_datagrid_body.css({height: heightValue - 27});
            return;
        }
        
        if (heightValue > 0) {
            $_datagrid_view.css({
                height: function(index, value) {
                    return parseInt(value) + heightValue;
                }
            });
            $_datagrid_body.css({
                height: function(index, value) {
                    return parseInt(value) + heightValue;
                }
            });
        }
    })();

    //处理表格宽度为百分比的情况
    window.setDatagridWidth = function(){
        var tHead_Alltd = $_datagrid_header_inner.find("td");
        var tBody_Alltd = $_table_body.find("td");
        var tBody_Alltr = $_table_body.find("tr");
        
        var perCount = 0;
        var widthCount = 0;
        var tHtDArr = new Array();
        
        $.each(tHead_Alltd, function(i, td) {
            if (i == 0)
            	return;
            var $_div = $(td).find("div:first");
            $_div.addClass("datagrid-cell");
            var style = $_div.attr("style");
            if(!style || style.indexOf("text-align") < 0)
            	$_div.css({"text-align": "left"});
            var widthValue = getWidth($_div.attr("style"));
            if (widthValue && widthValue.match(/%/)) {
                if (perCount != null)
                    perCount += parseInt(widthValue);
            } else {
                perCount = null;
            }
        });
        
        $.each(tBody_Alltd, function(i, td) {
        	var $_div = $(td).find("div:first");
            if (i % tHead_Alltd.length == 0) {
            	$_div.addClass("datagrid-cell-check");
            } else {
            	$_div.addClass("datagrid-cell");
            	var style = $_div.attr("style");
                if(!style || style.indexOf("text-align") < 0)
                	$_div.css({"text-align": "left"});
                if(!style || style.indexOf("height") < 0)
                	$_div.css({"height": "auto"});
                if(!style || style.indexOf("white-space") < 0)
                	$_div.css({"white-space": "normal"});
            }
        });
        
        var baseWidth = parseInt($_datagrid_body.width()) - 26; //减去checkbox的宽度
        if (baseWidth < 100)
            baseWidth = $(window.parent.document.body).width() - 62 - 26; //减去左右两边的外补白和checkbox的宽度
        if (baseWidth < 100)
            return;
        
        if (perCount == 100) {
            //根据表格内容，隐藏不必要的滚动条
            if (parseInt($_datagrid_body.css("height")) > tBody_Alltr.length * 20 /*$_datagrid_body.find("table").height() - 1*/)
                $_datagrid_body.css("overflow", "hidden");
            else
                baseWidth -= 17;
        }
        
        $.each(tHead_Alltd, function(i, td) {
            if (i == 0)
                return;
            var tdTemp = new Object();
            var $_div = $(td).find("div:first");
            var widthValue = getWidth($_div.attr("style"));
            if (widthValue && widthValue.match(/%/)) {
                tdTemp.percent = parseInt(widthValue);
                tdTemp.width = parseInt(tdTemp.percent * baseWidth / 100);
            } else {
                tdTemp.percent = null;
                tdTemp.width = parseInt(widthValue);
            }
            widthCount += tdTemp.width;
            tHtDArr.push(tdTemp);
        });
        
        if (perCount == 100)
            tHtDArr[tHtDArr.length - 1].width += baseWidth - widthCount;
        
        $.each(tHead_Alltd, function(i, td) {
            changeTDWidth(i, td, tHtDArr);
        });
        
        $.each(tBody_Alltd, function(i, td) {
            changeTDWidth(i, td, tHtDArr);
        });
        
        function getWidth(style) {
            if (style) {
                var attrArr = style.split(";");
                for (var attr in attrArr) {
                    if (attrArr[attr].match(/width/)) {
                        return $.trim(attrArr[attr].split(":")[1]);
                    }
                }
            }
        }
        
        function changeTDWidth(i, td, arr) {
            i = i % (arr.length + 1) - 1;
            if (i < 0)
                return;
            var $_div = $(td).find("div:first");
            if (arr[i].percent != null)
                $_div.css("width", arr[i].width - 9); //减去左右各4像素的内补白和边框1像素
            else
            	$_div.css("width", arr[i].width);
        }
    };
    
    setDatagridWidth();
    
});

/* 获取单选checkbox的值 */
function getSingleSelect(value){
	var rows = $("input[name='checkboxName']:checked");
	if (rows.length == 1) {
		var row = eval("(" + rows.val() + ")");
		if(value == "row")
			return row;
		else {
			var str = "";
			for(name in row) {
				str += name + "=" + row[name] + "&";
			}
			return str;
		}
	} else if (rows.length > 1) {
		$.messager.alert('系统提示', '只能选择单行!', 'warning');
	} else {
		$.messager.alert('系统提示', '请选择一条记录!', 'warning');
	}
	return false;
}

/* 获取多选checkbox的值 */
function getMultiSelect(key){
	var rows = $("input[name='checkboxName']:checked");
	if(rows.length > 0) {
		var str = "";
		rows.each(function(i){
			var row = eval("(" + this.value + ")");
			str += key + "=" + row[key] + "&";
		});
		return str;
	} else {
		$.messager.alert('系统提示','请选择一条记录!','warning');
	}
	return false;
}
/* 表单重置 */
function resetForm(formId){
	$("#" + formId + " input[type!='button'][type!='hidden']").each(function(i){
		var obj = $(this);
		var classValue = obj.attr("class");
		if(classValue && classValue.indexOf("easyui-combo") > -1) {
			obj.combobox("clear");
		} else if(classValue && classValue.indexOf("easyui-date") > -1) {
			obj.datebox("clear");
		} else {
			obj.val("");
		}
	});
}
