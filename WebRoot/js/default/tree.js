function Tree() {
	this.id = null;
	this.tree = null;
	
	//对tree组件进行初始化
	this.init = init;
	function init(treeId) {
		this.id = treeId;
	}
	
	//返回树的 options。
	this.getOptions = getOptions;
	function getOptions(){
		return $("#" + this.id).tree("options");
	}

	//加载树的数据。参数data为标准json格式的数组。
	this.loadData = loadData;
	function loadData(data){
		$("#" + this.id).tree("loadData", data);
	}
	
	//获取指定的节点数据，包括它的子节点。
	this.getData = getData;
	function getData(node) {
		return $("#" + this.id).tree("getData",node.target);
	}
	
	//根据节点的dom对象获得节点
	this.getNode = getNode;
	function getNode(target) {
		return $("#" + this.id).tree("getNode",target);
	}
	
	//重新加载树节点的数据
	this.reload = reload;
	function reload(node) {
		$("#" + this.id).tree("reload",node.target);
	}
	
	//获取根节点，返回节点对象
	this.getRoot = getRoot;
	function getRoot() {
		return $("#" + this.id).tree("getRoot");
	}
	
	//获取根节点们，返回节点数组。
	this.getRoots = getRoots;
	function getRoots() {
		return $("#" + this.id).tree("getRoots");
	}
	
	//获取父节点，在事件中使用。
	this.getParent = getParent;
	function getParent(node) {
		return $("#" + this.id).tree("getParent", node.target);
	}
	
	//获取子节点
	this.getChildren = getChildren;
	function getChildren(node) {
		return $("#" + this.id).tree("getChildren", node.target);
	}
	
	//获取所有勾选的节点。
	this.getChecked = getChecked;
	function getChecked() {
		return $("#" + this.id).tree("getChecked");
	}
	
	//获取选中的节点并返回它，如果没有选中节点，就返回 null。
	this.getSelected = getSelected;
	function getSelected() {
		return $("#" + this.id).tree("getSelected");
	}
	
	//把指定的节点定义成叶节点，在事件中使用。
	this.isLeaf = isLeaf;
	function isLeaf(node) {
		return $("#" + this.id).tree("isLeaf", node.target);
	}
	
	//找到指定的节点并返回此节点对象。
	this.find = find;
	function find(id) {
		return $("#" + this.id).tree("find", id);
	}
	
	//选中一个节点。
	this.select = select;
	function select(node) {
		return $("#" + this.id).tree("select", node.target);
	}
	
	//把指定节点设置为勾选。
	this.check = check;
	function check(node) {
		return $("#" + this.id).tree("check", node.target);
	}
	
	//把指定节点设置为未勾选。
	this.uncheck = uncheck;
	function uncheck(node) {
		return $("#" + this.id).tree("uncheck", node.target);
	}
	
	//折叠一个节点
	this.collapse = collapse;
	function collapse(node) {
		return $("#" + this.id).tree("collapse", node.target);
	}
	
	//展开一个节点。
	this.expand = expand;
	function expand(node) {
		return $("#" + this.id).tree("expand", node.target);
	}
	
	//折叠所有节点以下所有的节点们
	this.collapseAll = collapseAll;
	function collapseAll(node) {
		return $("#" + this.id).tree("collapseAll", node.target);
	}
	
	//展开节点以下所有的节点们。
	this.expandAll = expandAll;
	function expandAll(node) {
		return $("#" + this.id).tree("expandAll", node.target);
	}
	
	//从指定节点的根部展开
	this.expandTo = expandTo;
	function expandTo(node) {
		return $("#" + this.id).tree("expandTo", node.target);
	}
	
	//追加一些子节点们到一个父节点. 参数有两个特性：	parent：DOM 对象，追加到的父节点，如果没有分配，则追加为根节点。	data：数组，节点们的数据。
	this.append = append;
	function append(param) {
		return $("#" + this.id).tree("append", param);
	}
	
	//在指定节点的前边或后边插入一个节点， param 参数包含下列特性：	before：DOM 对象，前边插入的节点。	after：DOM 对象，后边插入的节点。	data：对象，节点数据。
	this.insert = insert;
	function insert(param) {
		return $("#" + this.id).tree("insert", param);
	}
	
	//更新跟心指定的节点， param 参数有下列特性：	target（DOM 对象，被更新的节点）、id、text、iconCls、checked、等等。
	this.update = update;
	function update(param) {
		return $("#" + this.id).tree("update", param);
	}
	
	//移除一个节点和它的子节点们
	this.remove = remove;
	function remove(node) {
		return $("#" + this.id).tree("remove", node.target);
	}
	
	//切换节点的展开/折叠状态， 参数node:节点对象。
	this.toggle = toggle;
	function toggle(node) {
		return $("#" + this.id).tree("toggle", node.target);
	}
	
	//弹出一个节点和它的子节点们，此方法和 remove 一样，但是返回了移除的节点数据
	this.pop = pop;
	function pop(node) {
		return $("#" + this.id).tree("pop", node.target);
	}
	
	//启用拖放功能。
	this.enableDnd = enableDnd;
	function enableDnd() {
		return $("#" + this.id).tree("toggle");
	}
	
	//禁用拖放功能。
	this.disableDnd = disableDnd;
	function disableDnd() {
		return $("#" + this.id).tree("disableDnd");
	}
	
	//开始编辑节点。	参数nodeId：指节点的值，可通过node.id获取。
	this.beginEdit = beginEdit;
	function beginEdit(nodeId) {
		var nodeElement = $('#' + nodeId);
		return $("#" + this.id).tree("beginEdit", nodeElement);
	}
	
	//结束编辑节点。	参数nodeId：指节点的值，可通过node.id获取。
	this.endEdit = endEdit;
	function endEdit(nodeId) {
		var nodeElement = $('#' + nodeId);
		$("#" + this.id).tree("endEdit", nodeElement);
	}
	
	//取消编辑节点。	参数nodeId：指节点的值，可通过node.id获取。
	this.cancelEdit = cancelEdit;
	function cancelEdit(nodeId) {
		var nodeElement = $('#' + nodeId);
		$("#" + this.id).tree("cancelEdit", nodeElement);
	}
	
}