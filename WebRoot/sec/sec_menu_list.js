/**
 * sec_menu_list.js
 * @author liuhao 2013.05.28
 * @version 1.0
 * @describe 菜单管理界面js
 */


//设置菜单图标、快捷图标绝对路径
	var imgLocation_tree = "../common/menuIcon/";
	var imgLocation_top = "../common/shortcutIcon/";
//----------------------------------------------------------------------------------------------------------------
	//菜单树设置
	//----------------------------------------------------------------------------------------------------------------
	//菜单树setting设置默认属性
		var setting = {
			view: {
				addHoverDom: addHoverDom,
				removeHoverDom: removeHoverDom
				//selectedMulti: false
			},
			data: {
				simpleData: {
					enable: true
				},
				keep: {
					parent: true,
					leaf:true
				}
			},
			edit: {
				enable: true
			},
			callback: {
				beforeDrag: beforeDrag,
				beforeEditName: beforeEditName,
				beforeRemove: beforeRemove,
				beforeDrop: beforeDrop,
				beforeClick:beforeClick,
				onClick: zTreeOnClick
			}
		};
		
		function zTreeOnClick(event, treeId, treeNode) {
			var treeObj = $.fn.zTree.getZTreeObj(treeId);
			treeObj.expandNode(treeNode, null, null, null);
			return true;
		};
		
		//菜单树init方法
		function zTreeInit() {
			$.ajax({
				 cache:false,
				 type: 'post',
				 dataType : "text",
				 url: "secMenu_findAllMenus.action",
				 success:function(data){
				 if(data.indexOf("errorState")>0) {
					 return;
				 }
				 var zNodes = eval(data);
				 $.fn.zTree.init($("#treeDemo"),setting,zNodes);
				 }
	 		});
		}
		//菜单树删除
		function beforeRemove(treeId, treeNode) {
			if("new node" == treeNode.name) {
				return true;
			}
			if(treeNode.children != null && treeNode.children != '') {
				$.messager.alert('系统提示','该菜单存在子菜单，不能执行删除操作','warning');
			} else {
				$.messager.confirm('系统提示','你确定要删除'+treeNode.name+'菜单吗',function(btn){
					if(btn){
						$.ajax({
							dataType:'json',
							url:'secMenu_removeMenuById.action',
							data:{'menuId': treeNode.id},
							type:'post',
							success:function(data,status){
								zTreeInit();
								$.messager.alert('系统提示','菜单删除成功','warning');
								$('#menuRes').panel('close');
								$('#menuForm').panel('close');
							},
							error:function(data,status) {
								$.messager.alert('系统提示','菜单删除失败，请联系管理员','warning');
							}
						});
					}
				});
			}
			return false;
		}
		//菜单树是否拖拽
		function beforeDrag(treeId, treeNodes) {
			return true;
		}
		//菜单树拖拽前处理
		function beforeDrop(treeId, treeNodes, targetNode, moveType) {
			var type = '';
			if(moveType == 'prev') {
				type = '之上';
			}
			if(moveType == 'next') {
				type = '之下';
			}
			if(moveType == 'inner') {
				type = '之中';
			}
			if(treeNodes[0].pId == null || targetNode.pId == null) {
				var message = "";
				if(treeNodes[0].pId==null) {
					message = treeNodes[0].name + "】 不允许被拖拽";
				} else {
					message = targetNode.name + "】 不允许作为目标菜单拖拽";
				}
				$.messager.alert('系统提示','根菜单【' + message ,'warning');
			} else {
				$.messager.confirm('系统提示','你确定要将菜单【' + treeNodes[0].name + '】  移动到菜单   【' + targetNode.name + '】 ' +type + '吗?',function(btn){
					if(btn){
						$.ajax({
							dataType:'json',
							url:'secMenu_moveMenu.action',
							data:{'cId': treeNodes[0].id,'toId':targetNode.id,'type':moveType},
							type:'post',
							success:function(data,status){
								zTreeInit();
								//当菜单级别或父节点发生改变时,提示需要重新保存相关角色的菜单授权                    zhouchaoqun  2013/06/20
								if(moveType == 'inner' || treeNodes[0].pId != targetNode.pId) {
									$.messager.alert('系统提示','菜单移动成功，因父节点发生改变，请重新保存相关角色的菜单授权','warning');
								}else {
									$.messager.alert('系统提示','菜单移动成功','warning');
								}
							},
							error:function(data,status) {
								$.messager.alert('系统提示','菜单移动失败，请联系管理员','warning');
							}
						});
					}
				});
			}
			return false;
		}
		//菜单增加节点
		function addHoverDom(treeId, treeNode) {
			var sObj = $("#" + treeNode.tId + "_span");
			if (treeNode.editNameFlag || $("#addBtn_"+treeNode.id).length>0) return;
			var addStr = "<button type='button' class='add' id='addBtn_" + treeNode.id
				+ "' title='add node' onfocus='this.blur();'></button>";
			sObj.append(addStr);
			var btn = $("#addBtn_"+treeNode.id);
			if (btn) btn.bind("click", function(){
				if(treeNode.leafFlg == 1) {
					$.messager.alert('系统提示','当前节点为叶子菜单，不能添加子菜单','warning');
				} else {
					var zTree = $.fn.zTree.getZTreeObj(treeId);
					zTree.addNodes(treeNode, {id:'', pId:treeNode.id,leafFlg:1, name:"new node",menuType:2});
				}
				return false;
			});
		}
		//菜单增加节点未保存至直接删除
		function removeHoverDom(treeId, treeNode) {
			$("#addBtn_"+treeNode.id).unbind().remove();
		}
		
		//单击节点显示详细信息，不可编辑状态
		function beforeClick(treeId, treeNode){
			$('#menuForm').panel('close');
			$('#menuRes').panel('close');
			//初始化
			$('#menu_info_form').form('clear');
			
			//赋值
			$('#menuNameInfo').val(treeNode.name);
			$('#menuCodeInfo').val(treeNode.menuCode);
			$('#openFlgInfo').val(trans(treeNode.openFlg));
			$('#leafFlgInfo').val(trans(treeNode.leafFlg));
			$('#menuUrlInfo').val(treeNode.url);
			$('#menuTypeInfo').val(transMenuType(treeNode.menuType));
			$('#funcdescInfo').val(treeNode.funcdesc);
			$('#field2Info').val(trans(treeNode.field2));
			if(treeNode.field1) {
				$("#treeImgInfo").attr({ src: imgLocation_tree+treeNode.field1});
			} else {
				if("1" == treeNode.leafFlg) {
					$("#treeImgInfo").attr({ src: imgLocation_tree+'default_icon.png'});
				} else {
					$("#treeImgInfo").attr({ src: imgLocation_tree+'cumputer_sys.png'});
				}
			}
			if(treeNode.field3) {
				$("#topImgInfo").attr({ src: imgLocation_top+treeNode.field3});
			} else {
				$("#topImgInfo").attr({ src: imgLocation_top+'monitor.png'});
			}
			$('#menuInfoForm').panel('open');
			return true;
		}
		// id 和text转化 仅针对（ 0 否 1 是 ）
		function trans(id) {
			if("1" == id) {
				return "是";
			} else {
				return "否";
			}
		}
		function transMenuType(id) {
			if("0" == id) {
				return "系统菜单";
			} else if("1" == id) {
				return "公共菜单";
			} else {
				return "普通菜单";
			}
		}
		//菜单详细信息Form初始化清空
		function menuFormToEmpty() {
			$('#menuRes').panel('close');
			$('#menuInfoForm').panel('close');
			
			$("#menuCode").removeAttr("disabled");
			$("#menuUrl").removeAttr("disabled");
			$('#leafFlg').combobox('enable');
			$('#openFlg').combobox('enable');
			$('#menuType').combobox('enable');
			$("#field2").combobox('enable');
			
			textRemove("menuName","menuCode","menuUrl");
			validRemove("menuName","menuCode","menuUrl");
		}
		//菜单详细信息--清空验证
		function validRemove(ids) {
			var n = arguments.length;
            for (var i = 0; i < arguments.length; i++) {
                $("#" + arguments[i]).removeClass('validatebox-invalid');
            }
            $(".validatebox-tip").html(' ');
		}
		//菜单信息 --清空text框信息
		function textRemove(ids) {
			var n = arguments.length;
            for (var i = 0; i < arguments.length; i++) {
                $("#" + arguments[i]).val("");
            }
			
		}
		//菜单树点击修改事件
		function beforeEditName(treeId, treeNode) {
			menuFormToEmpty();
			//赋值
			$('#menuId').val(treeNode.id);
			$('#pId').val(treeNode.pId);
			$('#menuName').val(treeNode.name);
			$('#menuCode').val(treeNode.menuCode);
			$('#funcdesc').val(treeNode.funcdesc);
			$("#menuUrl").val(treeNode.url);
			$('#menuType').combobox('setValue',treeNode.menuType);
			$('#leafFlg').combobox('setValue',treeNode.leafFlg);
			

			if("1" == treeNode.leafFlg) {
	    		//当前菜单是叶子菜单
				$('#openFlg').combobox('disable');
				$("#field2").combobox("enable");
				$("#menuUrl").removeAttr("disabled");
		    } else if ("0" == treeNode.leafFlg) {
	    		//当前菜单是非叶子菜单
		    	$('#openFlg').combobox('enable');
		    	$('#openFlg').combobox('setValue',treeNode.openFlg);
		    	textRemove("menuUrl");
				validRemove("menuUrl");
		    	$('#field2').combobox('setValue','0');
		    	$("#field2").combobox('disable');
				$("#menuUrl").attr('disabled','disabled');
		    }
			
			if(treeNode.field1) {
				$('#field1').val(treeNode.field1);
				$("#treeImg").attr({ src: imgLocation_tree+treeNode.field1});
			} else {
				if("0" == treeNode.leafFlg) {
					$('#field1').val('cumputer_sys.png');
					$("#treeImg").attr({ src: imgLocation_tree+'cumputer_sys.png'});
				} else {
					$('#field1').val('default_icon.png');
					$("#treeImg").attr({ src: imgLocation_tree+'default_icon.png'});
				}
			}
			if(treeNode.field2) {
				$('#field2').combobox('setValue',treeNode.field2);
			} else {
				$('#field2').combobox('setValue',"0");
			}
			
			if(treeNode.field3) {
				$('#field3').val(treeNode.field3);
				$("#topImg").attr({ src: imgLocation_top+treeNode.field3});
			} else {
				$('#field3').val('monitor.png');
				$("#topImg").attr({ src: imgLocation_top+'monitor.png'});
			}
			//如果id不为空，证明为修改，则“是否为叶子/菜单类型/菜单编号”等不允许修改
			if(treeNode.id != '') {
				if("1" == treeNode.leafFlg) {
					treegrid(treeNode.id);
					$('#menuRes').panel('open');
				} else {
					$('#menuRes').panel('close');
				}
				$('#leafFlg').combobox('disable');
				$('#menuType').combobox('disable');
				$("#menuCode").attr("disabled","disabled");
			}
			//打开详细信息面板
			$('#menuForm').panel('open');
			return true;
		}
		
		//菜单详细信息中对下拉框赋值选项option 及点击提交初始化--------------------
		function menuDetailSelectInit() {
			$('#menuType').combobox({
				editable:false,
			 	panelHeight:'100%'
			});
			$('#field2').combobox({
				editable:false,
			 	panelHeight:'100%'
			});
			$('#openFlg').combobox({
				editable:false,
			 	panelHeight:'100%'
			});
			//是否叶子菜单选项赋值及修改对应操作
			$('#leafFlg').combobox({ 
				editable:false,
			 	panelHeight:'100%',
			    onChange:function(newValue,oldValue) {
			    	if("1" == newValue) {
			    		//当前菜单是叶子菜单
						$('#openFlg').combobox('disable');
						$("#field2").combobox("enable");
						$("#menuUrl").removeAttr("disabled");
						
						$('#field1').val('default_icon.png');
						$("#treeImg").attr({ src: imgLocation_tree+'default_icon.png'});
				    } else if ("0" == newValue) {
			    		//当前菜单是非叶子菜单
				    	$('#openFlg').combobox('enable');
				    	
				    	$('#openFlg').combobox('setValue','0');
				    	textRemove("menuUrl");
						validRemove("menuUrl");
				    	$('#field2').combobox('setValue','0');
				    	
				    	$("#field2").combobox('disable');
						$("#menuUrl").attr('disabled','disabled');
						
						$('#field1').val('cumputer_sys.png');
						$("#treeImg").attr({ src: imgLocation_tree+'cumputer_sys.png'});
				    }
			    }
			});
			//menuForm 提交
			$('#submitInfo').click(function() {
				$('#add_edit_form').form('submit', {
			    	url:'${pageContext.request.contextPath}/secMenu_save.action',   
			        onSubmit: function(){
			        	if($('#leafFlg').combobox('getValue') == '1'){
							if($('#menuUrl').val() == "") {
								$.messager.alert('系统提示','叶子菜单请填写菜单URL!','warning');
								return false;
							}
						}
						var flag = true;
						$('#add_edit_form input').each(function () {
						    if (($(this).attr('required') || $(this).attr('validType')) && $(this).attr('isSubmitValid')!="no") {
							    if (!$(this).validatebox('isValid')) {
								    flag = false;
							        return;
							    }
						    }
						});
						return flag;
			        },   
			        success : function(data,status){
			        	zTreeInit();
						$.messager.alert('系统提示','菜单操作成功','warning');
						$('#menuRes').panel('close');
						$('#menuForm').panel('close');
					},
					error:function(data,status) {
						$.messager.alert('系统提示','菜单修改失败，请联系管理员','warning');
					}
				 }); 
			});
			$('#reset').click(
				function() {
					var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
					var nodes = treeObj.getSelectedNodes();
					beforeEditName(treeDemo, nodes[0]);
			});
		}
		
		//菜单图标、快捷图标初始化
		function iconDefalut() {
			$.ajax({
				 cache:false,
				 type: 'post',
				 dataType : "text",
				 url: "secMenu_IconSum.action",
				 success:function(data){
					 if(data.indexOf("errorState")>0) {
						 return;
					 }
					// 将data用“,”分割,依次展示
					 var Icons = data.split("||");
					 var treeIcons = Icons[0].split(",");
					 var topIcons = Icons[1].split(",");
					 for ( var i = 0; i < treeIcons.length-1; i++) {
						var array_element = treeIcons[i];
						$("#icons").append('<span><a href="#"><img src="'+imgLocation_tree+array_element+'" title="'+array_element+'" alt="" width="16px" height="16px" onclick="changeIcon(this.title)" /></a></span>');
					 }
					 for ( var i = 0; i < topIcons.length-1; i++) {
						var array_element = topIcons[i];
						$("#topIcons").append('<span><a href="#"><img src="'+imgLocation_top+array_element+'" title="'+array_element+'" alt="" width="32px" height="32px" onclick="changeTopIcon(this.title)" /></a></span>');
					 }
				 }
	 		});
			
			$("#changeIcon").click(function(){
				$('#iconResource').window('open');
			});
			$("#changeTopIcon").click(function(){
				$('#topIconResource').window('open');
			});
		}
		
		//菜单图标选择
		function changeIcon(icon){
			$('#iconResource').window('close');
			$("#treeImg").attr({ src: imgLocation_tree+icon});
			$('#field1').val(icon);
		}
		//快捷图标选择
		function changeTopIcon(icon){
			$('#topIconResource').window('close');
			$("#topImg").attr({ src: imgLocation_top+icon});
			$('#field3').val(icon);
		}
		
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		//----------------------资源treeGrid------------------------------------------------------------------------
		function treegrid(menuId) {
			$('#tt').treegrid({
				title:'菜单资源列表',
				height:230,
				nowrap: false,
				striped:true,
				rownumbers: true,
				url:'resource_listByMenu.action?menuId=' + menuId,
				idField:'resId',
				treeField:'resName',
				frozenColumns:[[
	                {title:'资源名称',field:'resName',width:150,
		                formatter:function(value){
		                if(value != null) {
		                	return '<span style="color:red">'+value+'</span>';
			                }
		                }
	                }
				]],
				columns:[[
					{field:'menuId',title:'隶属菜单',width:250,hidden:true},
					{field:'_parentId',title:'隶属资源',width:170,hidden:true},
					{field:'resType',title:'资源类型',width:100},
					{field:'transId',title:'交易编号',width:100},
					{field:'resPath',title:'资源链接',width:320},
					{field:'pageEleType',title:'页面元素类型',width:148},
					{field:'fields1',title:'是否自动记录日志',width:100,
						formatter:function(value){
			       			if(value == '1') {
				       			return "是";
				       		} else if(value == '0'){
					       		return "否";
					       	}
			       			return null;
			    		}
					}
				]],
				onContextMenu: function(e,row){
					e.preventDefault();
					$("#tt").treegrid('unselectAll');
					$("#tt").treegrid('select', row.resId);
					$('#mm').menu('show', {
						left: e.pageX,
						top: e.pageY
					});
				}
			});
		}
		//资源删除
		function remove(){
			var node = $('#tt').treegrid('getSelected');
			var childNodes = $('#tt').treegrid('getChildren',node.resId);
			if(childNodes != null && childNodes != "") {
				$.messager.alert('系统提示','该资源下存在子资源，不能执行删除操作！','warning');
				return;
			}
			if(node._parentId == "") {
				$.messager.alert('系统提示','该资源为菜单直接资源，不能执行删除操作','warning');
			} else {
				$.messager.confirm('系统提示','你确定要删除'+node.resName+'资源吗',function(btn){
					if(btn){
						$.ajax({
							dataType:'json',
							url:'resource_remove.action',
							data:{'resId': node.resId},
							type:'post',
							success:function(data,status){
								treegrid(node.menuId);
								$.messager.alert('系统提示','资源删除成功','warning');
							},
							error:function(data,status) {
								$.messager.alert('系统提示','资源删除失败，请联系管理员','warning');
							}
						});
					}
				});
			}
		}
		
		//资源Form清空
		function resourceFormToEmpty() {
			validRemove("transId","resName","resPath");
			textRemove("elementTransId","parentResId","parentRes","resourceMenuId","transId","resName","resPath");
			$('#resType').combobox('setValue', 'URL');
			$('#pageEleType').combobox('setValue','');
			
			$('#resType').combobox('enable');
			$('#pageEleType').combobox('enable');
    		$("#transId").removeAttr("disabled");
    		$("#resName").removeAttr("disabled");
    		$("#resUrl").removeAttr("disabled");
		}
		//增加子资源
		function addChildRes() {
			var node = $('#tt').treegrid('getSelected');
			if(node.resType == "pageElement") {
				$.messager.alert('系统提示','该资源为页面资源，不能执行添加子资源操作！','warning');
				return;
			}
			resourceFormToEmpty();
			$('#elementTransId').val(node.transId);
			$('#parentResId').val(node.resId);
			$('#parentRes').val(node.resName);
			$('#resourceMenuId').val(node.menuId);
			
			$("#parentRes").attr("disabled", "disabled");
			
			$('#pageEleType').combobox('disable');
			$('#resourceForm').window('open');
		}
		//右键方法--修改
		function edit() {
			var node = $('#tt').treegrid('getSelected');
			var parentNode = $('#tt').treegrid('getParent',node.resId);
			//comment by renmeimang 13-10-15 菜单直接资源允许修改 修改后 菜单相关信息也要修改
			/*if(parentNode == null) {
				$.messager.alert('系统提示','该资源为菜单直接资源，不能执行修改操作！','warning');
				return;
			}*/
			resourceFormToEmpty();

			$('#resId').val(node.resId);
			if(parentNode != null) {
			$('#parentResId').val(parentNode.resId);
			$('#parentRes').val(parentNode.resName);
			$('#parentRes').attr("disabled", "disabled");
			$('#resourceMenuId').val(node.menuId);
			$("#parent_res").show();
			}else{ //如果是菜单直接资源 交易编码不可修改
			$("#parent_res").hide();
			}
			
			$('#resName').val(node.resName);
			$('#resourceMenuId').val(node.menuId);
			$('#resType').combobox('setValue',node.resType);
			$('#resType').combobox('disable');
			$("#transId").val(node.transId);
			if(node.resType == "URL") {
	    		$('#resPath').val(node.resPath);
				$('#pageEleType').combobox('setValue','');
				if(parentNode != null){
				$("#transId").removeAttr("disabled");		
				}else{
				$('#transId').attr("disabled","disabled");
				}	
	    		$("#resPath").removeAttr("disabled");
	    		
	    		$('#pageEleType').combobox('disable');
	    		 var str=$('#resPath').val();
				 if(str.indexOf(".action")!=-1){
					 $('#fields1').combobox('setValue',node.fields1);
				 }else{
					//如果资源路径不是以.action结尾   是否记录日志设为 否 不可编辑
				    $('#fields1').combobox('setValue','0');
					$('#fields1').combobox('disable');
				 }
			} else {  
				$("#transId").val(node.transId);
				$('#resPath').val(node.resPath);
				$('#resName').val(node.resName);
		    	$('#pageEleType').combobox('setValue',node.pageEleType);
		    	
		    	$('#pageEleType').combobox('enable');
		    	$('#transId').attr("disabled","disabled");
		    	$('#resPath').attr("disabled","disabled");
		    	$('#fields1').combobox('setValue','0');
		    	$("#fields1").combobox('disable');
			}

			$('#resourceForm').window('open');
			
		}
	
		//资源 Form 初始化-------------------------------------------------------------------------------------------------------------
		function resourceForm() {
			$('#resType').combobox({   
				editable:false,
				panelHeight:"auto",
			    onChange:function(newValue,oldValue) {
			    	if("URL" == newValue) {
			    		$("#transId").removeAttr("disabled");
			    		$("#resName").removeAttr("disabled");
			    		$("#resPath").removeAttr("disabled");
			    		
			    		$('#pageEleType').combobox('disable');
			    		
			    		textRemove("transId","resPath","resName");
			    		validRemove("transId","resPath","resName");
						$('#pageEleType').combobox('select','');
						//$("#fields1").combobox('enable');
				    } else {
				    	validRemove("transId");
				    	$('#fields1').combobox('setValue','0');
				    	$("#fields1").combobox('disable'); //如果是页面元素  是否记录日志设为 否 不可编辑
				    	
				    	$('#transId').val($('#elementTransId').val());
				    	$('#transId').attr("disabled","disabled");
				    	
				    	$('#pageEleType').combobox('enable');
				    	$('#pageEleType').combobox('select','add'); //setValue赋值，不会出发onSelect事件
				    }
			    }
			}); 
			$('#pageEleType').combobox({   
				editable:false,
				panelHeight:"auto",
			    onSelect:function(record) {
			    	if("other" == record.value) {
			    		textRemove("resName","resPath");
			    		$("#resName").removeAttr("disabled");
			    		$("#resPath").removeAttr("disabled");
			    	} else {
			    		validRemove("resPath","resName");
			    		$('#resName').val(record.text);
		    			$('#resPath').val(record.value);
			    		$('#resPath').attr("disabled","disabled");
			    		$('#resName').attr("disabled","disabled");
			    	}
			    }
			}); 
			$("#resPath").change(function(){
				 var str=$('#resPath').val();
				 if(str.indexOf(".action")!=-1){
					 $("#fields1").combobox('enable');
				 }else{
					//如果资源路径不是以.action结尾   是否记录日志设为 否 不可编辑
				    $('#fields1').combobox('setValue','0');
					$('#fields1').combobox('disable');
				 }
			});
			//表单提交
//			$('#submitResource').click(function() {
//				var resId=document.getElementById("resId").value;
//				var pageEleType=$("#pageEleType").combobox('getValue');
//				var parentResId=document.getElementById("parentResId").value;
//				if(!resId){
//	    			$.ajax({
//	   			     type: "POST",
//	   			     url: "${pageContext.request.contextPath}/resource_checkPageEleType.action",
//	   			     data:{
//	   			    	 pageEleType:pageEleType,
//	   			    	 parentResId:parentResId
//		             },
//	   			     dataType:"text",
//	   			     success: function(json){//$.parseJSON(json); 
//	           			var result =json;  //使用这个方法解析json
//	   						if(result=="1"){
//	   							$.messager.alert('warning',"该页面元素类型已存在，请重新选择！");
//	   	                        return false;
//	   						}else{
//	   							$('#add_edit_resourceform').form('submit', {
//	   						      url:'${pageContext.request.contextPath}/resource_save.action',   
//	   						      onSubmit: function(){
//	   							        if($('#resName').attr('value') == "") {
//	   							        	$.messager.alert('系统提示','请输入资源名称!','warning');
//	   										return false;
//	   								    }
//	   							  return true;
//	   						      },
//	   						      success:function(data){   
//	   						    	  $.messager.alert('系统提示','操作成功','warning');
//	   						    	  $('#resourceForm').window('close');
//	   						    	  var node = $('#tt').treegrid('getSelected');
//	   						    	  treegrid(node.menuId);
//	   						      } 
//	   						 });	
//	   						}
//	   					}
//	   			  });
//			    }else{
//			    	$('#add_edit_resourceform').form('submit', {
//						      url:'${pageContext.request.contextPath}/resource_save.action',   
//						      onSubmit: function(){
//							        if($('#resName').attr('value') == "") {
//							        	$.messager.alert('系统提示','请输入资源名称!','warning');
//										return false;
//								    }
//							  return true;
//						      },
//						      success:function(data){   
//						    	  $.messager.alert('系统提示','操作成功','warning');
//						    	  $('#resourceForm').window('close');
//						    	  var node = $('#tt').treegrid('getSelected');
//						    	  treegrid(node.menuId);
//						      } 
//						 });	
//				}
//			});	
			$('#submitResource').click(function() {
				$('#add_edit_resourceform').form('submit', {
				     url:'${pageContext.request.contextPath}/resource_save.action',   
				     onSubmit: function(){
				     	//将disabled字段打开，保存到后台。
				     	$("#transId").removeAttr("disabled");
				     	$("#resName").removeAttr("disabled");
				     	$("#resPath").removeAttr("disabled");
			    		$('#resType').combobox('enable');
						$('#pageEleType').combobox('enable');
						$('#fields1').combobox('enable');
						
				      	 var flag = true;
						 $('#add_edit_resourceform input').each(function () {
						    if (($(this).attr('required') || $(this).attr('validType')) && $(this).attr('isSubmitValid')!="no") {
							    if (!$(this).validatebox('isValid')) {
								    flag = false;
							        return;
							    }
						    }
						});
						return flag;
				     },
				     success:function(data){   
				    	 $.messager.alert('系统提示','操作成功','warning');
				    	 $('#resourceForm').window('close');
				    	 var node = $('#tt').treegrid('getSelected');
				    	 treegrid(node.menuId);
				     } 
				 });	
   			  });
			$('#cancelResource').click(function() {
				resourceFormToEmpty();
				$('#resourceForm').window('close');
			});
		}
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//表单扩展验证
		$.extend($.fn.validatebox.defaults.rules, {
			nemuUrl: {
		        validator: function (value) {
			           $.fn.validatebox.defaults.rules.nemuUrl.message ="平台url以/开头，非平台url以http或者www开头";
		               return false;    
		    	}
    	        
		 	},
		 	menuName:{
				validator:function(value, param){
					if(!/^[a-zA-Z0-9_\u4e00-\u9fa5]+$/.test(value)){
						$.fn.validatebox.defaults.rules.menuName.message ="只可输入字母汉字数字_！";
			            return false;
					}else{
						$.fn.validatebox.defaults.rules.menuName.message ="";
			            return true;
					}
				}, 
				message:""
			},
			menuCode:{
                validator:function(value,param){
                    if(!/^[a-zA-Z_]+$/.test(value)){
                       $.fn.validatebox.defaults.rules.menuCode.message="只可输入字母和_！"; 
                       return false;
                    }
                    var menuId=$('#menuId').val();
                    if(!menuId){
                        var exist=$.ajax({
                            url:"${pageContext.request.contextPath}/secMenu_checkMuneCode.action",
                            data:{menuCode:value},
       			            async:false
                        }).responseText;
                        if(exist=="1"){
                           $.fn.validatebox.defaults.rules.menuCode.message="菜单编码已存在，无法使用！";
                           return false;
                        }else{
                        	$.fn.validatebox.defaults.rules.menuCode.message="此菜单编码可以使用！";
                           return true;
                        }
                    }else{
                    	  $.fn.validatebox.defaults.rules.menuCode.message="";
                          return true;   
                    }
                },
			    message:""
			}
		});
