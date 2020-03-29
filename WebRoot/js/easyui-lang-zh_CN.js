$.fn.pagination.defaults.beforePageText = '第';
$.fn.pagination.defaults.afterPageText = '页 ';
$.fn.pagination.defaults.displayMsg = '共 {total} 条';
$.fn.datagrid.defaults.loadMsg = '正在处理，请稍待。。。';
$.messager.defaults.ok = '确定';
$.messager.defaults.cancel = '取消';
$.fn.validatebox.defaults.missingMessage = '该输入项为必输项';
$.fn.validatebox.defaults.rules.email.message = '请输入有效的电子邮件地址';
$.fn.validatebox.defaults.rules.number.message = '请输入长度为{0}到{1}位的数字';
$.fn.validatebox.defaults.rules.zipCode.message = '请输入有效的邮编';
$.fn.validatebox.defaults.rules.url.message = '请输入有效的URL地址';
$.fn.validatebox.defaults.rules.length.message = '输入内容长度必须介于{0}和{1}之间';
$.fn.validatebox.defaults.rules.idcard.message = '请输入有效的身份证号码';
$.fn.validatebox.defaults.rules.telePhone.message = '请按正确格式输入电话号码（区号-电话号码）';
$.fn.validatebox.defaults.rules.mobilePhone.message = '请输入正确的手机号码';
$.fn.validatebox.defaults.rules.name.message = '只可输入最短不能少于3位最长不能多于16位字符的英文字母、数字和下划线';
if ($.fn.calendar){
	$.fn.calendar.defaults.weeks = ['日','一','二','三','四','五','六'];
	$.fn.calendar.defaults.months = ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'];
}
if ($.fn.datebox){
	$.fn.datebox.defaults.currentText = '今天';
	$.fn.datebox.defaults.closeText = '关闭';
	$.fn.datebox.defaults.okText = '确定';
	$.fn.datebox.defaults.missingMessage = '该输入项为必输项';
	$.fn.datebox.defaults.formatter = function(date){
		var y = date.getFullYear();
		var m = date.getMonth()+1;
		var d = date.getDate();
		return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	};
	$.fn.datebox.defaults.parser = function(s){
		if (!s) return new Date();
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
		if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
			return new Date(y,m-1,d);
		} else {
			return new Date();
		}
	};
}
if ($.fn.datetimebox && $.fn.datebox){
	$.extend($.fn.datetimebox.defaults,{
		currentText: $.fn.datebox.defaults.currentText,
		closeText: $.fn.datebox.defaults.closeText,
		okText: $.fn.datebox.defaults.okText,
		missingMessage: $.fn.datebox.defaults.missingMessage
	});
}

if ($.fn.datebox){
	$.fn.datebox.defaults.editable = false;	
}

if($.fn.combobox){
	$.fn.combobox.defaults.editable = false;	
}
if($.fn.datetimebox){
	$.fn.datetimebox.defaults.editable = false;
}
