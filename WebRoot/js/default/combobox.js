function Combobox() {
	this.id = null;
	this.combobox = null;
	
	// 对combobox组件进行初始化
	this.init = init;
	function init(comboboxId) {
		this.id = comboboxId;
	}
	
	//返回加载的数据
	this.getData = getData;
	function getData(){
		return $("#" + this.id).combobox("getData");
	}
	
	//返回加载的数据
	this.loadData = loadData;
	function loadData(data){
		$("#" + this.id).combobox("loadData",data);
	}
	
	//请求远程的列表数据
	this.reload = reload;
	function reload(url){
		$("#" + this.id).combobox("reload",url);
	}
	
	//参数value为要选择选项的值
	this.select = select;
	function select(value) {
		$("#" + this.id).combobox("select", value);
	}
	
	//根据选项值取消选择指定的选项。
	this.unselect = unselect;
	function unselect(value) {
		$("#" + this.id).combobox("unselect", value);
	}
	
	//以下是继承自combo的方法
	//设置组件的值
	this.setValue = setValue;
	function setValue(value){
		$("#" + this.id).combobox("setValue",value);
	}
	
	//设置组件的值的数组。
	this.setValues = setValues;
	function setValues(values){
		$("#" + this.id).combobox("setValues",values);
	}
	
	//获取组件的值。
	this.getValue = getValue;
	function getValue(){
		return $("#" + this.id).combobox("getValue");
	}
	
	//获取组件的值的数组
	this.getValues = getValues;
	function getValues(){
		return $("#" + this.id).combobox("getValues");
	}
	
	//获取输入的显示文本
	this.getText = getText;
	function getText() {
		return $("#" + this.id).combobox("getText");
	}
	
	this.setText = setText;
	function setText(text) {
		$("#" + this.id).combobox("setText",text);
	}
	
	//返回options对象，通过此对象可以获取或设置combobox组件的属性值
	this.getOptions = getOptions;
	function getOptions(){
		return $("#" + this.id).combobox("options");
	}
	
	//返回下拉面板对象
	this.panel = panel;
	function panel() {
		return $("#" + this.id).combobox("panel");
	}
	
	//返回文本框对象
	this.textbox = textbox;
	function textbox() {
		return $("#" + this.id).combobox("textbox");
	}
	
	//调整组件的宽度。
	this.resize = resize;
	function resize(width) {
		$("#" + this.id).combobox("resize", width);
	}
	
	//显示下拉面板
	this.showPanel = showPanel;
	function showPanel() {
		$("#" + this.id).combobox("showPanel");
	}
	
	//隐藏下拉面板
	this.hidePanel = hidePanel;
	function hidePanel() {
		$("#" + this.id).combobox("hidePanel");
	}
	
	//禁用组件
	this.disable = disable;
	function disable() {
		$("#" + this.id).combobox("disable");
	}
	
	//启用组件
	this.enable = enable;
	function enable() {
		$("#" + this.id).combobox("enable");
	}
	
	//清除组件的值
	this.clear = clear;
	function clear() {
		$("#" + this.id).combobox("clear");
	}	
	
	//以下是继承自validateBox的方法
	//摧毁组件
	this.destroy = destroy;
	function destroy() {
		$("#" + this.id).combobox("destroy");
	}
	
	//验证输入的值。
	this.validate = validate;
	function validate() {
		$("#" + this.id).combobox("validate");
	}
	
	//校验是否通过
	this.isValid = isValid;
	function isValid() {
		return $("#" + this.id).combobox("isValid");
	}
}
//对url中的参数进行替换：如果url中存在该属性，则进行替换,如果不存在该参数，则进行添加
function replaceUrlParam(url, paramName, paramValue){
	if(url && paramName){
		var index = url.indexOf('?');
		if(index != -1 && index != url.length - 1){
			var parameterStr = url.substring(index + 1);
			url = url.substring(0, index + 1);
			var parameters = parameterStr.split('&');
			var exist = false;
			for (var i = 0; i < parameters.length; i++) {
				var parameter = parameters[i];
				var ss = parameter.split('=');
				if(paramName== ss[0]){
					exist = true;
					if(ss.length == 1){
						url += paramName +'=';
					}else if(ss.length ==2){
						url += paramName +'=' + paramValue;
					}
				}else{
					url += parameter;
				}
				if(i != parameters.length - 1){
					url += '&';
				}
			}
			if(!exist){
				url += '&' + paramName + '=' + paramValue;
				}
		}else{
			//url不含任何参数 的情况
			url += '?' + paramName + '=' + paramValue;
		}
	}
	return url;
}

