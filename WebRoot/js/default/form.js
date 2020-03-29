function Form() {
	this.id = null;
	this.form = null;
	
	
	this.init = init;
	function init(fromId) {
		this.id = fromId;
	}
	
	this.load = load;
	function load(data){
		$("#" + this.id).form("load",data);
	}
	
	this.clear = clear;
	function clear() {
		$("#" + this.id).form("clear");
	}
	
	this.validate = validate;
	function validate(){
		return $("#" + this.id).form("validate");
	}
	
	this.submit = submit;
	function submit(){
		$("#" + this.id).submit();
	}
}