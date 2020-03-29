
//创建动态表单
function createForm(data){
	var _form = document.createElement("form");
    document.body.appendChild(_form);
	_form.action = data.url;
	_form.method = "post";
	
	for(var i = 0, len = data.condition.length; i < len; i++){
		var c = data.condition[i];
	 	var newElement = document.createElement("input");
	    newElement.setAttribute("name", c.name);
	    newElement.setAttribute("type", "hidden");
	    newElement.setAttribute("value", c.value);
	    _form.appendChild(newElement);
	}
	return _form;
}