/**
 * Easyui样式的弹开窗口方法
 * 
 * [功能]
 * 1. 窗口中显示内容为其他界面的引用，即URL的页面展现；
 * 2. 在多层嵌套的iframe中，里层页面可将窗口打开到最外层框架外面；
 * 3. 窗口位置自动计算，居中显示；
 * 
 * [依赖]
 * jquery-1.7.2.min.js	jquery.easyui.min.js
 * 
 * [更改日志]
 * 2013-02-28 gigi 原创
 * 2013-03-01 gigi 修改打开窗口点击头部关闭后，再打开定位错误的问题;
 * 				   窗口关闭由隐藏改为销毁，节省内存;
 * 				   点击ESC最上层窗口关闭；
 * 				   窗口宽高，支持百分比的形式，且可传null，打开为默认大小；
 * 2013-03-04 gigi 添加forceCallBack参数，设置是否强制关闭窗口是调用返回函数（函数存在的前提下）
 * 2013-05-09 gigi 添加宽高如果是100%的窗口，则不进行右下偏移20像素设置；禁止修改大小，全屏时禁止拖动;
 * 				   增加forceWinCfg参数，来强制设置打开窗口的属性，具体使用见参数说明中内容；
 * 2013-05-14 gigi 修改第一个参数，可以传递url也可以传递html代码，来作为窗口内容打开，具体使用看说明；
 * 
 * [使用说明]
 * --打开窗口--
 * showModalCenter (strUrl,callBack,winWidth,winHeight,title[,forceCallBack])
 * void
 * 
 * @参数strUrl
 * 需要打开的嵌套在WINDOW中的页面地址，可以是ACTION也可以使JSP，通过问号传递参数；
 * 如果传递是{html:''}此格式的对象，则窗口以对象内的html属性字符串为显示内容进行展现；
 * 
 * @参数callBack
 * 在窗口关闭时的回调函数，类型为fn，不是字符串
 * 
 * @参数winWidth
 * 打开窗口的宽度
 * 传null时，默认是按窗口大小的88%宽度打开，可设置像素值如：300或'300'，也可设置字符串型的百分比如：'50%'
 * 
 * @参数winHeight
 * 打开窗口的高度
 * 传null时，默认是按窗口大小的88%宽度打开，可设置像素值如：300或'300'，也可设置字符串型的百分比如：'50%'
 * 
 * @参数title
 * 打开窗口的标题
 * 
 * @参数forceCallBack
 * 可选参数，布尔型，
 * 如果是true，则在窗口关闭时强制调用返回函数（返回函数如果存在的话），
 * 如果是false则在返回有传值的时候才调用返回函数；
 * 默认为false;
 * 
 * @参数forceWinCfg
 * 可选参数，对象型
 * 此参数是对打开的WIN窗口属性的强制设置，
 * 即如果有此参数则会覆盖掉控件计算的同名参数例如：宽高位置等
 * 
 * --关闭窗口--
 * closeModalCenter([returnValue])
 * void
 * @参数returnValue
 * 可选参数，如果不传递参数，窗口只做关闭处理，不会调用回调函数
 * 参数类型支持所有js的类型和对象
 */


function showModalCenter (strUrl,callBack,winWidth,winHeight,title,forceCallBack,forceWinCfg){
	//strUrl = encodeURI(strUrl);
	
	//如果有父窗口存在，则在父窗口去创建并打开窗口
	if(window.parent && window.parent != window && typeof window.parent.showModalCenter == 'function'){
		window.parent.showModalCenter.apply(window.parent,arguments);
		return;
	}
	
	//初始化一个DIV的WIN窗口存储
	var winId = showModalCenterHelp.inertWinHtml(arguments);
	showModalCenterHelp.callBackFunc = callBack;
	
	//1. 定义_contentHTML
	var _contentHTML = '';
	if (typeof strUrl == 'object') {
		_contentHTML = '<div style="width:100%;height:100%;">'+strUrl.html+'</div>';
	} else {
		_contentHTML = '<iframe style="width:100%;height:100%;" frameborder="0" '
				+ 'scrolling="auto" src="' + (strUrl || '') + '"></iframe> ';
	}
	
	//2. 初始化窗口对象
	var _config = {
		modal		: true,
		collapsible : false,
		minimizable : false,
		maximizable : false,
		resizable   : false,
		content		: _contentHTML,
		title 		: title || '窗口'
	};
	$.extend(_config,showModalCenterHelp.windowSize(winWidth, winHeight));
	$.extend(_config,showModalCenterHelp.centerPosition(_config.width,_config.height));
	
	if(winWidth == '100%' || winHeight == '100%'){
		_config.top = 0;
		_config.left = 0;
		_config.draggable = false;
	}
	
	//如果有强制参数设置，则在此设置覆盖控件的计算值
	if(typeof forceWinCfg == 'object'){
		$.extend(_config,forceWinCfg);
	}
	
	
	$('#'+winId).window(_config);
	
	//打开窗口
	$('#'+winId).window('open');
};

function closeModalCenter(returnValue) {
	// 1. 找到最上层的窗口对象
	if(window.parent && window.parent != window && typeof window.parent.closeModalCenter == 'function'){
		window.parent.closeModalCenter.apply(window.parent,arguments);
		return;
	}
	
	if (showModalCenterHelp.winCach.length > 0) {
		var _winCfg = showModalCenterHelp.winCach.pop();
		if (_winCfg) {
			// 2. 调用返回函数
			if (returnValue != null || _winCfg.forceCallBack) {
				if(typeof _winCfg.bkfunck == 'function'){
					_winCfg.bkfunck.call(null, returnValue);
				}
			}

			$('#' + _winCfg.id).window('destroy');
		}
	}

};

var showModalCenterHelp = function(){
	return {
		winId 		 : 0,
		winCach		 : [],
		
		//给页面添加WIN的DIV并返回DIV的ID以便使用
		inertWinHtml : function(cfg) {
			var _id = 'iwin' + (++this.winId);
			$(document.body)
					.append('<div id="'
							+ _id
							+ '" class="easyui-window centerwindow" closed="true" style="overflow:hidden;"></div>');
			$('#'+_id).window({onClose:closeModalCenter});
					
			var _forceCbk = false;
			if(typeof cfg[5] == 'boolean'){
				_forceCbk = cfg[5];
			}
			
			this.winCach.push({id:_id,bkfunck:cfg[1],forceCallBack:_forceCbk});
			return _id;
		},
		
		//计算得出中间位置的坐标值
		centerPosition : function(w,h){
			var pl = $(window).scrollLeft();
			var pt = $(window).scrollTop();
			var ph = $(window).height();
			var pw = $(window).width();
			
			var _wincount = this.winCach.length;
			
			return {
				top  : Math.floor(Math.abs(ph - h)/2 + pt + 20 * (_wincount-1)),
				left : Math.floor(Math.abs(pw - w)/2 + pl + 20 * (_wincount-1))
			};
		},
		
		//计算窗口大小，分析如果是数值，直接赋值；如果是null则按照默认百分比设置，如果是百分比，则按照给定百分比设置
		windowSize : function (winWidth, winHeight){
			var _wType='percent',_wPercent=0.88,_hType='percent',_hPercent=0.88,_wPx=winWidth,_hPx=winHeight;
			
			//1. 根据传递宽高值判断类型
			if(winWidth != null){
				if((winWidth+'').indexOf('%') == -1){
					_wType = 'number';
				}else{
					_wPercent = parseInt(winWidth)/100;
				}
			}
			if(winHeight != null){
				if((winHeight+'').indexOf('%') == -1){
					_hType = 'number';
				}else{
					_hPercent = parseInt(winHeight)/100;
				}
			}
			
			//2. 获得页面的宽高
			var ph = $(window).height();
			var pw = $(window).width();
			
			//3. 计算窗口的宽高
			if(_wType == 'percent'){
				_wPx = pw * _wPercent;
			}
			if(_hType=='percent'){
				_hPx = ph * _hPercent;
			}
			
			//4. 返回
			return {
				width : Math.floor(parseInt(_wPx)),
				height: Math.floor(parseInt(_hPx))
			}
		}
	}
}();

$(function(){
	$(window).bind('keyup',function(e){
		if(e.which == 27){
			closeModalCenter();
		}
	});
});