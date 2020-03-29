function Menu() {
	this.id = null;
	this.menu = null;
	
	
	this.init = init;
	function init(menuId) {
		this.id = menuId;
	}
	
	this.show = show;
	function show(pos){
		var left = "";
		var top = "";
		var zIndex = 110000;
		if(pos.left != undefined) {
			left = pos.left;
		} 
		if(pos.top != undefined) {
			top = pos.top;
		}
		if(pos.zIndex != undefined) {
			zIndex = pos.zIndex;
		}
		$("#" + this.id).menu("show",{
			left:left,
			top:top,
			zIndex:zIndex
		});
	}

	this.hide = hide;
	function hide(){
		$("#" + this.id).menu("hide");
	}
	
	this.getItem = getItem;
	function getItem(menuItemId){
		var itemEl = $('#'+menuItemId);
		return $("#" + this.id).menu('getItem', itemEl);
	}
	
	this.findItem = findItem;
	function findItem(text){
		return $("#" + this.id).menu('findItem', text);
	}
	
	this.setText = setText;
	function setText(menuItemId,text){
		var target = $('#'+menuItemId);
		$("#" + this.id).menu('setText', {
			target:target,
			text:text
		});
	}
	
	this.setIcon = setIcon;
	function setIcon(menuItemId,iconCls){
		var target = $('#'+menuItemId);
		$("#" + this.id).menu('setIcon', {
			target:target,
			iconCls:iconCls
		});
	}
	
	this.appendItem = appendItem;
	function appendItem(param){
		var parent = "";
		var text = "";
		var href = "";
		var onClick = "";
		var iconCls = "";
		if(param.parent != undefined) {
			parent = param.parent;
		} 
		if(param.text != undefined) {
			text = param.text;
		}
		if(param.href != undefined) {
			href = param.href;
		}
		if(param.onClick != undefined) {
			onClick = param.onClick;
		}
		if(param.iconCls != undefined) {
			iconCls = param.iconCls;
		} 
		$("#" + this.id).menu('appendItem', {
			parent:parent,
			text:text,
			href:href,
			onClick:onClick,
			iconCls:iconCls
		});
	}
	
	this.removeItem = removeItem;
	function removeItem(menuItemId){
		var itemEl = $('#'+menuItemId);
		$("#" + this.id).menu('removeItem', itemEl);
	}
	
	this.enableItem = enableItem;
	function enableItem(menuItemId){
		var itemEl = $('#'+menuItemId);
		$("#" + this.id).menu('enableItem', itemEl);
	}
	
	this.disableItem = disableItem;
	function disableItem(menuItemId){
		var itemEl = $('#'+menuItemId);
		$("#" + this.id).menu('disableItem', itemEl);
	}
}