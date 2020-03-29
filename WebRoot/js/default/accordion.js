function Accordion() {
	this.id = null;
	this.accordion = null;
	
	
	this.init = init;
	function init(accordionId) {
		this.id = accordionId;
	}
	
	//返回 accordion 的选项
	this.getOptions = getOptions;
	function getOptions(){
		return $("#" + this.id).accordion('options');
	}
	
	//获取全部的 panel
	this.panels = panels;
	function panels(){
		return $("#" + this.id).accordion('panels');
	}
	
	//获取选中的 panel
	this.getSelected = getSelected;
	function getSelected(){
		return $("#" + this.id).accordion('getSelected');
	}
	
	//获取指定的panel
	this.getPanel = getPanel;
	function getPanel(title){
		return $("#" + this.id).accordion('getPanel',title);
	}
	
	//将指定的 panel选中
	this.select = select;
	function select(title){
		$("#" + this.id).accordion('select',title);
	}
	
	//移除指定的 panel
	this.remove = remove;
	function remove(title){
		$("#" + this.id).accordion('remove',title);
	}
	
	//增加一个新的 panel
	this.add = add;
	function add(options){
		$("#" + this.id).accordion('add',options);
	}
	
	//修改手风琴项的标题
	this.setTitle = setTitle;
	function setTitle(oldValue, newValue){
		var papel = $("#" + this.id).accordion('getPanel',oldValue);
		papel.panel('setTitle',newValue);
	}
	
}


