function Text() {
	this.id = null;
	this.text = null;
	this.zoom = null;
	
	//初始化
	this.init = init;
	function init(textId,zoom) {
		this.id = textId;
		this.zoom = zoom;
	}
	
	//赋值
	this.setValue = setValue;
	function setValue(value){
		$("#" + this.id).val(value/this.zoom);
		$("#" + this.id+"_showValueId").val(value);
	}
	
	//取值
	this.getValue = getValue;
	function getValue(){
		return $("#" + this.id).val();
	}
}

//当标签配置放大缩小时属性时，需要引用的js插件，为隐藏域赋值
function _number_parser(number,zoom,opt) {
	if(number!=""){
		var resultNumber = accDiv(number,zoom);
		if(opt != undefined){
			$('#'+opt.id).val(Number(resultNumber.toFixed(6)));
		}else{
			return (Number(resultNumber.toFixed(6)));//对浮点数的小数点进行控制
		}
	}else{
		$('#'+opt.id).val("");
	}
}

//说明：javascript的除法结果会有误差，在两个浮点数相除的时候会比较明显。这个函数返回较为精确的除法结果。
//调用：accDiv(arg1,arg2)
//返回值：arg1除以arg2的精确结果
function accDiv(arg1,arg2){ 
	var t1=0,t2=0,r1,r2; 
	try{t1=arg1.toString().split(".")[1].length}catch(e){} 
	try{t2=arg2.toString().split(".")[1].length}catch(e){} 
	with(Math){ 
		r1=Number(arg1.toString().replace(".","")) 
		r2=Number(arg2.toString().replace(".","")) 
		return (r1/r2)*pow(10,t2-t1); 
	} 
} 