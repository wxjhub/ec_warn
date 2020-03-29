function Pagination() {
	this.name = null;
	var pager = null;
	
	//pagination组件的初始化
	this.init = init;
	function init(name) {
		this.name = name;
		pager = $("#" + this.name);
	}
	
	//返回options对象，通过此对象可以获取或设置pagination组件的属性值
	this.getOptions = getOptions;
	function getOptions(){
		return $("#" + this.name).pagination('options');
	}
	
	//把pagination变成正在加载（loading）状态
	this.loading = loading;
	function loading(){
		$("#" + this.name).pagination('loading');      
	}
	
	//把pagination变成加载完成（loaded）状态
	this.loaded = loaded;
	function loaded(){
		$("#" + this.name).pagination('loaded');
	}
	
}


