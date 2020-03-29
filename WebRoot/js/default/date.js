function DateTime() {
	this.id = null;
	this.dateTime = null;
	this.type = "date";
	
	
	this.init = init;
	function init(dateId,type) {
		this.id = dateId;
		this.type = type;
	}
	
	this.setValue = setValue;
	function setValue(value,dateFormat){
		if(dateFormat==undefined){
			if(value.getHours()==0 && value.getMinutes()==0 && value.getSeconds()==0){
				$("#" + this.id).datebox("setValue",value.format("yyyy-MM-dd"));
			}else{
				$("#" + this.id).datebox("setValue",value.format("yyyy-MM-dd hh:mm:ss"));
			}
		}else{
			$("#" + this.id).datebox("setValue",value.format(dateFormat));
		}
	}
	
	
	this.getValue = getValue;
	function getValue(){
		return $("#" + this.id).datebox("getValue");
	}
	
	this.getOptions = getOptions;
	function getOptions(){
		return $("#" + this.id).datebox("options");
	}
	
	this.calendar = calendar;
	function calendar(){
		return $("#" + this.id).datebox("calendar");
	}
	
	this.spinner = spinner;
	function spinner(){
		if(this.type == "datetime"){
			return $("#" + this.id).datetimebox("spinner");
		}else{
			return ;
		}
	}
	
	this.disable = disable;
	function disable() {
		$("#" + this.id).datebox("disable");
	}
	
	this.enable = enable;
	function enable() {
		$("#" + this.id).datebox("enable");
	}
	
	this.clear = clear;
	function clear() {
		return $("#" + this.id).datebox("clear");
	}
	
	this.panel = panel;
	function panel() {
		return $("#" + this.id).datebox("panel");
	}
}

//日期格式化方法
Date.prototype.format = function(format){
	var o = {
		"M+" : this.getMonth()+1, //month
		"d+" : this.getDate(), //day
		"h+" : this.getHours(), //hour
		"m+" : this.getMinutes(), //minute
		"s+" : this.getSeconds(), //second
		"q+" : Math.floor((this.getMonth()+3)/3), //quarter
		"S" : this.getMilliseconds() //millisecond
	};
	if(/(y+)/.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
	}
	
	for(var k in o) {
		if(new RegExp("("+ k +")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length==1 ? o[k] : ("00"+ o[k]).substr((""+ o[k]).length));
		}
	}
	return format;
};
