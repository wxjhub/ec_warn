/**
 * upload 控件
 * @author Haoliang
 */
 
function Upload() {
	this.name = null;
	this.upload = null;
	
	this.init = init;
	function init(uploadId) {
		this.id = uploadId;
	}
	
	//上传
	this.upload = upload;
	function upload(){
		$("#"+this.id).uploadify('upload','*');
	}
	
	//取消上传
	this.cancel = cancel;
	function cancel(){
		return $("#"+this.id).uploadify('cancel','*');
	}
	
	//禁用
	this.disabled = disabled;
	function disabled(){
		return $("#"+this.id).uploadify('disable',true);
	}
	
	//启用
	this.enabled = enabled;
	function enabled(){
		return $("#"+this.id).uploadify('disable',false);
	}
}