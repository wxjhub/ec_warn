function Messager() {
	
	this.show = show;
	function show(options) {
		var showType;
		var showSpeed;
		var width;
		var height;
		var msg;
		var title;
		var timeout;
		if(options.showType != undefined) {
			showType = options.showType;
		}
		if(options.showSpeed != undefined) {
			showSpeed = options.showSpeed;
		}
		if(options.width != undefined) {
			width = options.width;
		}
		if(options.height != undefined) {
			height = options.height;
		}
		if(options.msg != undefined) {
			msg = options.msg;
		}
		if(options.title != undefined) {
			title = options.title;
		}
		if(options.timeout != undefined) {
			timeout = options.timeout;
		}
		$.messager.show(options);
	}
	
	this.alert = alert;
	function alert(obj) {
		var title;
		var msg;
		var icon;
		var fn;
		if(obj.title != undefined) {
			title = obj.title;
		}
		if(obj.msg != undefined) {
			msg = obj.msg;
		}
		if(obj.icon != undefined) {
			icon = obj.icon;
		}
		if(obj.fn != undefined) {
			fn = obj.fn;
		}
		$.messager.alert(title,msg,icon,fn);
	}
	
	this.confirm = confirm;
	function confirm(obj) {
		var title;
		var msg;
		var fn;
		if(obj.title != undefined) {
			title = obj.title;
		}
		if(obj.msg != undefined) {
			msg = obj.msg;
		}
		if(obj.fn != undefined) {
			fn = obj.fn;
		}
		$.messager.confirm(title,msg,fn);
	}
	
	this.prompt = prompt;
	function prompt(obj) {
		var title;
		var msg;
		var fn;
		if(obj.title != undefined) {
			title = obj.title;
		}
		if(obj.msg != undefined) {
			msg = obj.msg;
		}
		if(obj.fn != undefined) {
			fn = obj.fn;
		}
		$.messager.prompt(title,msg,fn);
	}
	
	this.progress = progress;
	function progress(obj) {
		var title;
		var msg;
		var text;
		var interval = 300;
		if(obj.title != undefined) {
			title = obj.title;
		}
		if(obj.msg != undefined) {
			msg = obj.msg;
		}
		if(obj.text != undefined) {
			text = obj.text;
		}
		if(obj.interval != undefined) {
			interval = obj.interval;
		}
		$.messager.progress(obj);
	}
	
	this.bar = bar;
	function bar() {
		return $.messager.progress("bar");
	}
	
	this.close = close;
	function close() {
		return $.messager.progress("close");
	}
	
	this.ok = ok;
	function ok(val) {
		$.messager.defaults.ok = val;
	}
	
	this.cancle = cancel;
	function cancel(val) {
		$.messager.defaults.cancel = val;
	}
}