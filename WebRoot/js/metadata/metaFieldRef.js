$(function() {
    window.metaField = {
        fieldID: ["refType", "refModel", "refModelPkProp", "propertyType", "autogenType", "type", "isPrimaryKey", "isBizKey", "updateFlag"],
        init: function(basePath) {
            for (i in this.fieldID) {
                var id = this.fieldID[i];
                this.initField.call(this[id], id);
            }
            this.basePath = basePath;
            this.checkDbcolumn();
            
            this.autogenType.bindEvent();
            this.propertyType.bindEvent();
            
            this.isBizKey.bindEvent();
            this.isPrimaryKey.bindEvent();
            
            this.refType.update();
            this.isBizKey.update();
        },
        initField: function(id) {
            metaField.fieldParent.call(this, id);
        },
        fieldParent: function(id) {
            this.id = id;
            this.self = $("#" + id);
            this.oldValue = $("#" + id + "Old").val();
            this.tagName = this.self[0].tagName;
            this.getValue = function() {
                if (this.tagName == "SELECT")
                    return this.self.combobox("getValue");
                else
                    return this.self.val();
            };
            if (!this.resetValue)
                this.resetValue = function() {
                    if (this.tagName == "SELECT")
                        this.self.combobox("setValue", this.oldValue);
                    else
                        this.self.val(this.oldValue);
                }, 
            this.checkReset = function() {
                return this.getValue() == this.oldValue;
            };
        },
        //关联类型
        refType: {
            update: function() {
                this.self.combobox({
                    onChange: function() {
                        metaField.refModel.update(metaField.refType.checkReset());
                    }
                });
                metaField.refModel.update(metaField.refType.checkReset());
            },
            clear: function() {
                this.self.combobox("clear");
                metaField.refModel.clear();
            }
        },

        //关联模型
        refModel: {
            update: function(requiredReset) {
                var refType = metaField.refType.getValue();
                
                metaField.clearRefValue({"refType": refType});
                metaField.disPlayRefField({"refType": refType});
                
                if (!refType) {
                    this.self.combobox("loadData", []);
                    this.self.combobox("clear");
                    //设置属性类型
                    metaField.propertyType.update(requiredReset);
                } else {
                    this.self.combobox({
                        url: metaField.basePath + "/metaModelFieldXml_getAllrefModelByrefType.action?refType=" + refType,
                        textField: 'text',
                        valueField: 'id',
                        panelHeight: 195,
                        onChange: function(data) {
                            //设置主键字段
                            metaField.refModelPkProp.update(metaField.refModel.checkReset());
                            //设置属性类型
                            metaField.propertyType.update(metaField.refModel.checkReset());
                        },
                        onLoadSuccess: function() {
                            if (requiredReset) {
                                metaField.refModel.resetValue();
                            }
                            //设置主键字段
                            metaField.refModelPkProp.update(requiredReset);
                            //设置属性类型
                            metaField.propertyType.update(requiredReset);
                        },
                        onLoadError: function() {
                            $.messager.alert('系统提示', '加载关联模型错误!', 'warning');
                        }
                    });
                }
            },
            clear: function() {
                this.self.combobox("clear");
                metaField.refModelPkProp.clear();
            }
        },

        //关联主键字段、	关联显示字段、关联排序字段、关联排序方式
        refModelPkProp: {
            update: function(requiredReset) {
                var refType = metaField.refType.getValue();
                var refModel = metaField.refModel.getValue();
                if (refType == "2" && refModel) {
                    this.self.combobox({
                        url: metaField.basePath + "/metaModelFieldXml_getRefModelProps.action?refModel=" + refModel,
                        textField: 'text',
                        valueField: 'id',
                        onLoadSuccess: function() {
                            var refModelData = metaField.refModelPkProp.self.combobox('getData');
                            var param = {data: refModelData,
                                textField: 'text',
                                valueField: 'id'};
                            $('#refModelNameProp').combobox(param);
                            $('#refModelNameProp1').combobox(param);
                            $('#refModelOrderProp').combobox(param);
                            $('#refModelOrderMode').combobox("setValue", "");
                            
                            if (requiredReset) {
                                metaField.refModelPkProp.resetValue();
                            }
                        },
                        onLoadError: function() {
                            $.messager.alert('系统提示', '加载关联主键字段错误!', 'warning');
                        }
                    });
                }
            },
            clear: function() {
                this.self.combobox("clear"); 				//关联主键字段
                $("#refModelNameProp").combobox("clear"); 	//关联显示字段0
                $("#refModelNameProp1").combobox("clear"); 	//关联显示字段1
                $("#refModelOrderProp").combobox("clear"); 	//关联排序字段
                $("#refModelOrderMode").combobox("clear"); 	//关联排序方式
            },
            resetValue: function() {
                metaField.resetValue(this.id);
                metaField.resetValue("refModelNameProp");
                metaField.resetValue("refModelNameProp1");
                metaField.resetValue("refModelOrderProp");
                metaField.resetValue("refModelOrderMode");
            }
        },

        //属性类型
        propertyType: {
            update: function(requiredReset) {
                var refType = metaField.refType.getValue();
                var refModel = metaField.refModel.getValue();
                if (requiredReset) {
                    this.resetValue();
                } else if (refType == '2' && refModel) {
                    $.ajax({
                        url: metaField.basePath + "/metaModelFieldXml_getPropertyTypeByModeName.action",
                        type: "post",
                        data: {'refModel': refModel},
                        dataType: "text",
                        success: function(data) {
                            metaField.propertyType.self.val(data);
                            //设置自动生成类型
                            metaField.autogenType.update();
                            //设置视图类型
                            metaField.type.update();
                        },
                        error: function(data) {
                            $.messager.alert('系统提示', '加载属性类型错误!', 'warning');
                        }
                    });
                    return;
                } else {
                    this.self.val("java.lang.String");
                }
                //设置自动生成类型
                metaField.autogenType.update(requiredReset);
                //设置视图类型
                metaField.type.update(requiredReset);
            },
            bindEvent: function() {
                this.self.bind("input propertychange", function() {
                    //设置自动生成类型
                    metaField.autogenType.update(metaField.propertyType.checkReset());
                    //设置视图类型
                    metaField.type.update(metaField.propertyType.checkReset());
                });
            }
        },

        //自动生成类型	
        autogenType: {
            data: [{"row": 0,"value": "","text": "请选择"}, 
                   {"row": 1,"value": "1","text": "生效标识"}, 
	               {"row": 2,"value": "2","text": "创建日期"}, 
	               {"row": 3,"value": "3","text": "创建时间"}, 
	               {"row": 4,"value": "4","text": "创建人"}, 
	               {"row": 5,"value": "5","text": "最后修改日期"}, 
	               {"row": 6,"value": "6","text": "最后修改时间"}, 
	               {"row": 7,"value": "7","text": "最后修改人"}, 
	               {"row": 8,"value": "8","text": "复核人"}, 
	               {"row": 9,"value": "9","text": "复核时间"}],
            update: function(requiredReset) {
                var propertyType = $("#propertyType").val();
                var temp = [];
                if (propertyType == "java.lang.String") {
                    temp = [this.data[0], this.data[1], this.data[4], this.data[7], this.data[8]];
                } else if (propertyType.indexOf("entity") >= 0) {
                    temp = [this.data[0], this.data[4], this.data[7], this.data[8]];
                } else if (propertyType.indexOf("Date") >= 0) {
                    temp = [this.data[0], this.data[2], this.data[3], this.data[5], this.data[6], this.data[9]];
                }
                
                this.self.combobox("loadData", temp);
                this.self.combobox("setValue", "");
                if (requiredReset)
                    this.resetValue();
            
            },
            bindEvent: function() {
                this.self.combobox({
                    onChange: function() {
                        metaField.autogenType.checkValue();
                    }
                });
            },
            checkValue: function() {
                $("#autogenFlag").combobox("setValue", !this.getValue() ? "0" : "1");
            }
        },

        //视图类型
        type: {
            data: [{"row": 0,"value": "","text": "请选择"}, 
	               {"row": 1,"value": "hidden","text": "隐藏域"}, 
	               {"row": 2,"value": "text","text": "文本框"}, 
	               {"row": 3,"value": "select","text": "下拉列表"}, 
	               {"row": 4,"value": "popTree","text": "弹出树"}, 
	               {"row": 5,"value": "popLazyTree","text": "弹出延迟树"}, 
	               {"row": 6,"value": "flag","text": "状态字典"}, 
	               {"row": 7,"value": "textArea","text": "文本域"}, 
	               {"row": 8,"value": "date","text": "日期选择"}, 
	               {"row": 9,"value": "datetime","text": "日期时间"},
	               {"row": 10,"value": "autoSelect","text": "自动完成列表"}
	               ],
            update: function(requiredReset) {
                var propertyType = $('#propertyType').val(); //属性类型
                var refType = $('#refType').combobox('getValue'); //关联类型
                var dbcolumn = $('#dbcolumn').val(); //字段名称
                
                var temp = [];
                var currentValue = 1;
                if (dbcolumn == "UUID" || dbcolumn == "uuid") {
                    temp = [this.data[1], this.data[2]];
                    currentValue = 2;
                } else if (refType == "2") {
                    temp = [this.data[1], this.data[3], this.data[10], this.data[4], this.data[5]];
                } else if (propertyType == "java.lang.String") {
                    if (refType == "1")
                        currentValue = 2;
                    temp = [this.data[1], this.data[2], this.data[6], this.data[7]];
                } else if (propertyType.indexOf("Date") >= 0) {
                    temp = [this.data[1], this.data[8], this.data[9]];
                } else if (propertyType.match(/(BigDecimal)|(Long)|(Integer)/)) {
                    temp = [this.data[1], this.data[2]];
                }
                
                this.self.combobox("loadData", temp);
                
                if (requiredReset)
                    this.resetValue();
                else if (temp.length != 0)
                    this.self.combobox("setValue", temp[currentValue].value);
                else
                    this.self.combobox("clear");
            }
        },

        //是否主键
        isPrimaryKey: {
            bindEvent: function() {
                this.self.combobox({
                    onChange: function() {
                        metaField.isPrimaryKey.checkValue();
                    }
                });
            },
            checkValue: function() {
                if (this.getValue() == "1" && this.oldValue != "1") {
                    $.ajax({
                        url: metaField.basePath + "/metaModelFieldXml_ifOnlyNotPrimaryKey.action",
                        type: "post",
                        data: {"modelName": $("#modelName").val()},
                        dataType: "json",
                        success: function(data) {
                            if (data == "1") {
                                //如果该元数据已有主键并且当前字段不是主键字段，则不能设置当前字段为主键 
                                metaField.isPrimaryKey.self.combobox('setValue', '0');
                                //metaField.isPrimaryKey.self.combobox("disable");
                                $.messager.alert('warning', "该数据原型中已有主键，不可重复设置主键！");
                            }
                            metaField.isBizKey.update();
                        }
                    });
                } else {
                    metaField.isBizKey.update();
                }
            }
        },

        //是否业务主键
        isBizKey: {
            update: function() {
                if (metaField.isPrimaryKey.getValue() == "1") {
                    this.self.combobox("setValue", "0");
                    //this.self.combobox("disable");
                } else {
                	//this.self.combobox("enable");
                }
                metaField.updateFlag.update();
            },
            bindEvent: function() {
                this.self.combobox({
                    onChange: function() {
                        metaField.updateFlag.update();
                    }
                });
            }
        },

        //是否可维护
        updateFlag: {
            update: function() {
                if (metaField.isPrimaryKey.getValue() == "1" || metaField.isBizKey.getValue() == "1") {
                    this.self.combobox("setValue", "0");
                    //this.self.combobox("disable");
                } else {
                	//this.self.combobox("enable");
                }
            }
        },
        
        clearRefValue: function(param) {
            if (param.refType != undefined) {
                if (!param.refType || param.refType == "1")
                    metaField.refModel.clear();
                else if (param.refType == "2")
                    metaField.refModelPkProp.clear();
            } else if (param.isUUID != undefined) {
                if (param.isUUID)
                    metaField.refType.clear();
            }
        },
        
        disPlayRefField: function(param) {
            if (param.refType != undefined) {
                if (!param.refType || param.refType == "1") {
                    $("#refModelPkTR").css({display: 'none'});
                    $("#refModelOrderTR").css({display: 'none'});
                } else if (param.refType == "2") {
                    $("#refModelPkTR").css({display: ''});
                    $("#refModelOrderTR").css({display: ''});
                }
            } else if (param.isUUID != undefined) {
                if (param.isUUID) {
                    $("#refTable").css({display: 'none'});
                    $("#refHr").css({display: 'none'});
                } else {
                    $("#refTable").css({display: ''});
                    $("#refHr").css({display: ''});
                }
            }
        },
        
        resetValue: function(id) {
            var $_oldObj = $("#" + id + "Old");
            var oldValue;
            if ($_oldObj[0].tagName == "SELECT")
                oldValue = $_oldObj.combobox("getValue");
            else
                oldValue = $_oldObj.val();
            
            var $_obj = $("#" + id);
            if ($_obj[0].tagName == "SELECT")
                $_obj.combobox("setValue", oldValue);
            else
                $_obj.val(oldValue);
        },

        //如果字段名称为UUID，则关联等字段隐藏
        checkDbcolumn: function() {
            var dbcolumn = $('#dbcolumn').val();
            if (dbcolumn == 'UUID' || dbcolumn == 'uuid') {
                metaField.clearRefValue({isUUID: true});
                metaField.disPlayRefField({isUUID: true});
            }
        }
    };
});