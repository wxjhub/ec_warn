function Combotree() {
	this.id = null;
	this.combotree = null;
	
	//对combotree组件进行初始化
	this.init = init;
	function init(combotreeId) {
		this.id = combotreeId;
	}
	
	//返回 options 对象
	this.getOptions = getOptions;
	function getOptions(){
		return $("#" + this.id).combotree("options");
	}
	
	//加载本地的 combotree 数据。
	this.loadData = loadData;
	function loadData(data){
		$("#" + this.id).combotree("loadData", data);
	}
	
	//再一次请求远程的 combotree 数据。
	this.reload = reload;
	function reload(url) {
		$("#" + this.id).combotree("reload",url);
	}
	
	//清除组件的值。
	this.clear = clear;
	function clear() {
		$("#" + this.id).combotree("clear");
	}
	
	//设置组件的值的数组。
	this.setValues = setValues;
	function setValues(values) {
		$("#" + this.id).combotree("setValues",values);
	}
	
	//设置组件的值。
	this.setValue = setValue;
	function setValue(value) {
		$("#" + this.id).combotree("setValue",value);
	}
	
	//获取组件的值的数组
	this.getValues = getValues;
	function getValues() {
		return $("#" + this.id).tree("getValues");
	}
	
	//获取组件的值。
	this.getValue = getValue;
	function getValue() {
		return $("#" + this.id).combotree("getValue");
	}
	
	//为组件设置显示值。
	this.setText = setText;
	function setText(value) {
		$("#" + this.id).combotree("setText",value);
	}
	
	//设置文本值
	this.getText = getText;
	function getText() {
		return $("#" + this.id).combotree("getText");
	}
	
	//调整组件的宽度。
	this.resize = resize;
	function resize(width) {
		$("#" + this.id).combotree("resize",width);
	}
	
	//禁用组件
	this.disable = disable;
	function disable() {
		$("#" + this.id).combotree("disable");
	}
	
	//启用组件
	this.enable = enable;
	function enable() {
		$("#" + this.id).combotree("enable");
	}
	
	//返回验证结果
	this.isValid = isValid;
	function isValid() {
		return $("#" + this.id).combotree("isValid");
	}
}