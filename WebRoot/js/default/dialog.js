function Dialog() {
	this.id = null;
	this.dialog = null;
	
	
	this.init = init;
	function init(dialogId) {
		this.id = dialogId;
	}
	
	this.getOptions = getOptions;
	function getOptions() {
		return $("#" + this.id).dialog("options");
	}
	
	this.dialog = dialog;
	function dialog() {
		return $("#" + this.id).dialog("dialog");
	}

	this.header = header;
	function header() {
		return $("#" + this.id).dialog("header");
	}
	
	this.body = body;
	function body() {
		return $("#" + this.id).dialog("body");
	}
	
	this.setTitle = setTitle;
	function setTitle(title) {
		$("#" + this.id).dialog("setTitle",title);
	}
	//参数值为true/false
	this.open = open;
	function open(forceOpen) {
		$("#" + this.id).dialog("open",forceOpen);
	}
	//参数值为true/false
	this.close = close;
	function close(forceClose) {
		$("#" + this.id).dialog("close",forceClose);
	}

	this.refresh = refresh;
	function refresh(href) {
		$("#" + this.id).dialog("refresh",href);
	}
	
	this.resize = resize;
	function resize(options) {
		var width;
		var height;
		var left;
		var top;
		if(options.width != undefined) {
			width = options.width;
		}
		if(options.height != undefined) {
			height = options.height;
		}
		if(options.left != undefined) {
			left = options.left;
		}
		if(options.top != undefined) {
			top = options.top;
		}
		$("#" + this.id).dialog("resize",{
			width:width,
			height:height,
			left:left,
			top:top
		});
	}
	
	this.newDialog = newDialog;
	function newDialog(options) {
		var width;
		var height;
		var left;
		var top;
		var href;
		var cache;
		var title;
		var iconCls;
		var border;
		var collapsible;
		var minimizable;
		var maximizable;
		var closable;
		var draggable;
		var resizable;
		var collapsed;
		var minimized;
		var maximized;
		var fit;
		var doSize;
		var shadow;
		var noheader;
		var zIndex;
		var modal;
		var inline;
		var loadingMessage;
		var content;
		if(options.width != undefined) {
			width = options.width;
		}
		if(options.height != undefined) {
			height = options.height;
		}
		if(options.left != undefined) {
			left = options.left;
		}
		if(options.top != undefined) {
			top = options.top;
		}
		if(options.href != undefined) {
			href = options.href;
		}
		if(options.cache != undefined) {
			cache = options.cache;
		}
		if(options.title != undefined) {
			title = options.title;
		}
		if(options.iconCls != undefined) {
			iconCls = options.iconCls;
		}
		if(options.border != undefined) {
			border = options.border;
		}
		if(options.collapsible != undefined) {
			collapsible = options.collapsible;
		}
		if(options.minimizable != undefined) {
			minimizable = options.minimizable;
		}
		if(options.maximizable != undefined) {
			maximizable = options.maximizable;
		}
		if(options.closable != undefined) {
			closable = options.closable;
		}
		if(options.draggable != undefined) {
			draggable = options.draggable;
		}
		if(options.resizable != undefined) {
			resizable = options.resizable;
		}
		if(options.collapsed != undefined) {
			collapsed = options.collapsed;
		}
		if(options.minimized != undefined) {
			minimized = options.minimized;
		}
		if(options.maximized != undefined) {
			maximized = options.maximized;
		}
		if(options.fit != undefined) {
			fit = options.fit;
		}
		if(options.doSize != undefined) {
			doSize = options.doSize;
		}
		if(options.shadow != undefined) {
			shadow = options.shadow;
		}
		if(options.noheader != undefined) {
			noheader = options.noheader;
		}
		if(options.zIndex != undefined) {
			zIndex = options.zIndex;
		}
		if(options.modal != undefined) {
			modal = options.modal;
		}
		if(options.inline != undefined) {
			inline = options.inline;
		}
		if(options.loadingMessage != undefined) {
			loadingMessage = options.loadingMessage;
		}
		if(options.content != undefined) {
			content = options.content;
		}
		$("#" + this.id).dialog({
			width:width,
			height:height,
			left:left,
			top:top,
			href:href,
			cache:cache,
			title:title,
			iconCls:iconCls,
			border:border,
			collapsible:collapsible,
			minimizable:minimizable,
			maximizable:maximizable,
			closable:closable,
			draggable:draggable,
			resizable:resizable,
			collapsed:collapsed,
			minimized:minimized,
			maximized:maximized,
			fit:fit,
			doSize:doSize,
			shadow:shadow,
			noheader:noheader,
			zIndex:zIndex,
			modal:modal,
			inline:inline,
			loadingMessage:loadingMessage,
			content:content
		});
	}
	
	this.move = move;
	function move(options) {
		var left;
		var top;
		if(options.left != undefined) {
			left = options.left;
		}
		if(options.top != undefined) {
			top = options.top;
		}
		$("#" + this.id).dialog("move",{
			left:left,
			top:top
		});
	}
	
	this.maximize = maximize;
	function maximize() {
		$("#" + this.id).dialog("maximize");
	}
	
	this.minimize = minimize;
	function minimize() {
		$("#" + this.id).dialog("minimize");
	}
	
	this.restore = restore;
	function restore() {
		$("#" + this.id).dialog("restore");
	}
	
	this.collapse = collapse;
	function collapse(animate) {
		$("#" + this.id).dialog("collapse",animate);
	}
	
	this.expand = expand;
	function expand(animate) {
		$("#" + this.id).dialog("expand",animate);
	}
}