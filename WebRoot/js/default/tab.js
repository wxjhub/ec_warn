function Tab() {
	
	this.name = null;
	this.tab = null;
	
	this.init = init;
	function init(tabName) {
		this.name = tabName;
	}	
	
	//返回options对象，通过此对象可以获取或设置tab组件的属性值
	this.getOptions = getOptions;
	function getOptions() {
		return $("#" + this.name).tabs("options");
	}
	
	//通过使用options改变高宽度后，调用resize函数后方可生效
	this.resize = resize;
	function resize() {
		$("#" + this.name).tabs("resize");
	}
	
	//增加选项卡  参数为object，参数对象只应该包括增加选项卡的相关内容
	this.add = add;
	function add(obj) {
		var title = "";
		var cache = false;
		var iconCls = "";
		var closable=false;
		var selected=false;
		if(obj.title != undefined) {
			title = obj.title;
		} 
		if(obj.cache == true) {
			cache = obj.cache;
		}
		if(obj.iconCls != undefined) {
			iconCls = obj.iconCls;
		}
		if(obj.closable == true) {
			closable = true;
		}
		if(obj.selected == true) {
			selected = true;
		}
			
		$("#" + this.name).tabs("add", {
			title:title,
			cache:cache,
			iconCls:iconCls,
			closable:closable,
			selected:selected
		});
	}
	
	//根据title关闭相应的选项卡页（card）
	this.close = close;
	function close(title) {
		$("#" + this.name).tabs("close", title);
	}
	
	//根据title获取相应的选项卡页（card）
	this.getTab = getTab;
	function getTab(title) {
		return $("#" + this.name).tabs("getTab", title);
	}
	
	//获取选中的选项卡
	this.getSelected = getSelected;
	function getSelected() {
		return $("#" + this.name).tabs("getSelected");
	}
	
	//根据标题 选项一个tab选项卡    参数：要选择的选项卡的标题
	this.select = select;
	function select(title) {
		$("#" + this.name).tabs("select",title);
	}
	
	//返回boolean，判断是否存在以参数title为标题的选项卡card
	this.exists = exists;
	function exists(title) {
		return $("#" + this.name).tabs("exists", title);
	}
	
	//根据标题更新选项卡			参数一tabTitle：被更新选项卡的标题    参数二obj：指定更新后的参数
	this.updateByTitle = updateByTitle;
	function updateByTitle(tabTitle, obj) {
		if(!$("#" + this.name).tabs("exists", tabTitle)) {
			alert("要更新的选项卡并不存在！");
			return;
		}
		var title = "";
		var cache = false;
		var iconCls = "";
		var closable=false;
		if(obj.title != undefined) {
			title = obj.title;
		} 
		if(obj.cache == true) {
			cache = true;
		}
		if(obj.iconCls != undefined) {
			iconCls = obj.iconCls;
		}
		if(obj.closable == true) {
			closable = true;
		}
		var tab = $("#" + this.name).tabs('getTab', tabTitle);
		$('#' + this.name).tabs('update',{
			tab: tab,
			options:{
				title:title,
				cache:cache,
				iconCls:iconCls,
				closable:closable
			}
		});
	}
	
	//更新指定的选项卡			参数一：要更新的选项卡对象 		参数二：指定更新后的参数
	this.updateByTab = updateByTab;
	function updateByTab(tab, obj) {
		var title = "";
		var cache = false;
		var iconCls = "";
		var closable=false;
		if(obj.title != undefined) {
			title = obj.title;
		} 
		if(obj.cache == true) {
			cache = true;
		}
		if(obj.iconCls != undefined) {
			iconCls = obj.iconCls;
		}
		if(obj.closable == true) {
			closable = true;
		}
		$('#' + this.name).tabs('update',{
			tab: tab,
			options:{
				title:title,
				cache:cache,
				iconCls:iconCls,
				closable:closable
			}
		});
	}
}