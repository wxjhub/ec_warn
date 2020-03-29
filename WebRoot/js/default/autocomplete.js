function Autocomplete() {
	this.id = null;
	this.autocomplete = null;
	
	//对组件进行初始化
	this.init = init;
	function init(autocompleteId) {
		this.id = autocompleteId;
	}
	
	//重设参数用法.autocomplete.setOptions({})；	参数描述：多个参数以”,”分割，每个参数以键值对的方式成对出现。如：options = 	{ valueField ：‘orgId’,textField:’orgName’}
	this.setOptions = setOptions;
	function setOptions(options){
		$("#" + this.id).setOptions(options);
	}
	
	//禁用自动完成组件
	this.unautocomplete = unautocomplete;
	function unautocomplete(){
		$("#" + this.id).unautocomplete();
	}
	
	//刷出缓存
	this.flushCache = flushCache;
	function flushCache(){
		$("#" + this.id).flushCache();
	}

	//添加在用户选中某一项后触发的function
	this.search = search;
	function search(handler){
		return $("#" + this.id).search(handler);
	}
	
	//添加在用户查询时触发的function
	this.result = result;
	function result(handler){
		return $("#" + this.id).result(handler);
	}
}


