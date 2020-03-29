var TANGER_OCX_bDocOpen = false;
var TANGER_OCX_filename;
var TANGER_OCX_actionURL; //For auto generate form fiields
var TANGER_OCX_OBJ; //The Control
var DocPassWord = 'vpftag2013';

//以下为V1.7新增函数示例
function TANGER_OCX_CreateDoc(doctype)
{
  TANGER_OCX_OBJ = document.all.item("TANGER_OCX");
  /**
	创建时打开文档类型：
	1：Word文件； Word.Document
	2：Excel文件； Excel.Sheet
	3：PowerPoint演示文稿；  PowerPoint.Show
	4：Visio文件； Visio.Drawing
	5：Project文件； MSProject.Project
	6：金山WPS文件；  WPSFile.4.8001/WPS.Document
	7：金山ET电子表文件  ET.Sheet.1.80.01.2001/ET.WorkBook
	11：中标字处理文件
	12：中标电子表格
	13：中标演示文稿
	*/
  	var newDoc = "Word.Document";
	if (doctype == "1") {
		newDoc = "Word.Document";
	} else if (doctype == "2") {
		newDoc = "Excel.Sheet";
	} else if (doctype == "3") {
		newDoc = "PowerPoint.Show";
	} else if (doctype == "4") {
		newDoc = "Visio.Drawing";
	} else if (doctype == "5") {
		newDoc = "MSProject.Project";
	} else if (doctype == "6") {
		newDoc = "WPS.Document";
	} else if (doctype == "7") {
		newDoc = "ET.WorkBook";
	} 
	TANGER_OCX_OBJ.CreateNew(newDoc);
}

//显示隐藏工具栏
function ShowToolbars(bShow)
{
  TANGER_OCX_OBJ.Toolbars = bShow;
}

function strtrim(value)
{
  return value.replace(/^\s+/,'').replace(/\s+$/,'');
}

function TANGER_OCX_doFormOnSubmit()
{

  var form = document.forms[0];
    if (form.onsubmit)
  {
      var retVal = form.onsubmit();
       if (typeof retVal == "boolean" && retVal == false)
         return false;
  }
  return true;
}

//允许或禁止显示修订工具栏和工具菜单（保护修订）
function TANGER_OCX_EnableReviewBar(boolvalue)
{
  TANGER_OCX_OBJ.ActiveDocument.CommandBars("Reviewing").Enabled = boolvalue;
  TANGER_OCX_OBJ.ActiveDocument.CommandBars("Track Changes").Enabled = boolvalue;
  TANGER_OCX_OBJ.IsShowToolMenu = boolvalue;	//关闭或打开工具菜单
}
//接受所有修订
function TANGER_OCX_AcceptAllRevisions()
{
  TANGER_OCX_OBJ.ActiveDocument.AcceptAllRevisions();
}

//打开或者关闭修订模式
function TANGER_OCX_SetReviewMode(boolvalue)
{
  TANGER_OCX_OBJ.ActiveDocument.TrackRevisions = boolvalue;
}

//进入或退出痕迹保留状态，调用上面的两个函数
function TANGER_OCX_SetMarkModify(boolvalue)
{
 var doctype = TANGER_OCX_OBJ.DocType;
   if(6 == doctype){
     WPSEnterRevisionMode(boolvalue);
  }else{
    TANGER_OCX_SetReviewMode(boolvalue);
    TANGER_OCX_EnableReviewBar(!boolvalue);
  }
}

//显示/不显示修订文字
function TANGER_OCX_ShowRevisions(boolvalue)
{
  //TANGER_OCX_OBJ.ActiveDocument.ShowRevisions = boolvalue;
}

//打印/不打印修订文字
function TANGER_OCX_PrintRevisions(boolvalue)
{
  TANGER_OCX_OBJ.ActiveDocument.PrintRevisions = boolvalue;
}

function TANGER_OCX_SaveToServer()
{
  if(!TANGER_OCX_bDocOpen)
  {
    alert("没有打开的文档。");
    return;
  }

  TANGER_OCX_filename = prompt("附件另存为：","新文档.doc");
  if ( (!TANGER_OCX_filename))
  {
    TANGER_OCX_filename ="";
    return;
  }
  else if (strtrim(TANGER_OCX_filename)=="")
  {
    alert("您必须输入文件名！");
    return;
  }
  TANGER_OCX_SaveDoc();
}


//设置页面布局
function TANGER_OCX_ChgLayout()
{
   try
  {
    TANGER_OCX_OBJ.showdialog(5); //设置页面布局
  }
  catch(err){
    alert("错误：" + err.number + ":" + err.description);
  }
  finally{
  }
}

//打印文档
function TANGER_OCX_PrintDoc()
{
  try
  {
    TANGER_OCX_OBJ.printout(true);
  }
  catch(err){
    alert("错误：" + err.number + ":" + err.description);
  }
  finally{
  }
}

function TANGER_OCX_SaveEditToServer()
{
  if(!TANGER_OCX_bDocOpen)
  {
    alert("没有打开的文档。");
    return;
  }

  TANGER_OCX_filename = document.all.item("filename").value;

  if ( (!TANGER_OCX_filename))
  {
    TANGER_OCX_filename ="";
    return;
  }
  else if (strtrim(TANGER_OCX_filename)=="")
  {
    alert("您必须输入文件名！");
    return;
  } 
  TANGER_OCX_SaveDoc();
}

function TANGER_OCX_SaveTemplateToServer()
{
  if(!TANGER_OCX_bDocOpen)
  {
    alert("没有打开的文档。");
    return;
  }

  TANGER_OCX_filename = document.all.item("filename").value;
  if ( (!TANGER_OCX_filename))
  {
    TANGER_OCX_filename ="";
    return;
  }
  else if (strtrim(TANGER_OCX_filename)=="")
  {
    alert("您必须输入文件名！");
    return;
  }
  //alert(TANGER_OCX_filename);
  TANGER_OCX_SaveTemplate();
}

function TANGER_OCX_SaveAttatchEditToServer()
{
  if(!TANGER_OCX_bDocOpen)
  {
    alert("没有打开的文档。");
    return;
  }

  TANGER_OCX_filename = document.all.item("filename").value;
  if ( (!TANGER_OCX_filename))
  {
    TANGER_OCX_filename ="";
    return;
  }
  else if (strtrim(TANGER_OCX_filename)=="")
  {
    alert("您必须输入文件名！");
    return;
  }
  TANGER_OCX_SaveDoc();
}

//允许或禁止文件－>新建菜单
function TANGER_OCX_EnableFileNewMenu(boolvalue)
{
  TANGER_OCX_OBJ.FileNew = boolvalue;
}

//允许或禁止文件－>打开菜单
function TANGER_OCX_EnableFileOpenMenu(boolvalue)
{
  TANGER_OCX_OBJ.FileOpen = boolvalue;
}

//允许或禁止文件－>关闭菜单
function TANGER_OCX_EnableFileCloseMenu(boolvalue)
{
  TANGER_OCX_OBJ.FileClose = boolvalue;
}

//允许或禁止文件－>保存菜单
function TANGER_OCX_EnableFileSaveMenu(boolvalue)
{
  TANGER_OCX_OBJ.FileSave = boolvalue;
}

//允许或禁止文件－>另存为菜单
function TANGER_OCX_EnableFileSaveAsMenu(boolvalue)
{
  TANGER_OCX_OBJ.FileSaveAs = boolvalue;
}

//允许或禁止文件－>打印菜单
function TANGER_OCX_EnableFilePrintMenu(boolvalue)
{
  TANGER_OCX_OBJ.FilePrint = boolvalue;
}

//允许或禁止文件－>打印预览菜单
function TANGER_OCX_EnableFilePrintPreviewMenu(boolvalue)
{
  TANGER_OCX_OBJ.FilePrintPreview = boolvalue;
}

// 打开文档
function TANGER_OCX_OpenAttatchDoc(docUrl,type)
{	
  TANGER_OCX_OBJ = document.all.item("TANGER_OCX");
  if(docUrl != "")
  {
    if(type=="doc"||type=="wps"){    	
      TANGER_OCX_OBJ.BeginOpenFromURL(docUrl,true,false,'Word.Document');
    }else if(type=="xls" || type=="xlsx" || type=="et"){
      TANGER_OCX_OBJ.BeginOpenFromURL(docUrl,true,false,'Excel.Sheet');
    }else{
      TANGER_OCX_OBJ.BeginOpenFromURL(docUrl,true,false,'Word.Document');
    }
  }
}

//打开本地文件
function TANGER_OCX_OpenLocalFile(localFilePath){
	TANGER_OCX_OBJ = document.all.item("TANGER_OCX");
	TANGER_OCX_OBJ.OpenlocalFile(localFilePath);
}

function TANGER_OCX_OnDocumentOpened(str, obj, flag)
{
  TANGER_OCX_bDocOpen = true;
  TANGER_OCX_SetReadOnly(true);
  TANGER_OCX_EnableMenu(false);
  TANGER_OCX_OBJ.FileSave=false;
  TANGER_OCX_OBJ.FileSaveAs =false;
  //隐藏痕迹
  //TANGER_OCX_ShowRevisions(true);
  if (flag == 1 || flag == 2){
    // 清除留痕
    TANGER_OCX_AcceptAllRevisions();
  }
  //控制工具栏
  ShowToolbars(false);
  //控制显示比例
  TANGER_OCX_OBJ.ActiveDocument.ActiveWindow.ActivePane.View.Zoom.PageFit = 2;
}

function TANGER_OCX_OnDocumentOpened(str, obj)
{
  TANGER_OCX_bDocOpen = true;
  TANGER_OCX_SetReadOnly(true);
  TANGER_OCX_EnableMenu(true);
  TANGER_OCX_OBJ.FileSave=false;
  TANGER_OCX_OBJ.FileSaveAs =false;

  //控制工具栏
  ShowToolbars(true);
  //控制显示比例
  TANGER_OCX_OBJ.ActiveDocument.ActiveWindow.ActivePane.View.Zoom.PageFit = 2;
}

function TANGER_OCX_OnDocumentOpenedTem(str, obj)
{
  TANGER_OCX_bDocOpen = true;
  TANGER_OCX_OBJ.ActiveDocument.ActiveWindow.ActivePane.View.Zoom.PageFit = 2;
}

function TANGER_OCX_OnDocumentClosed()
{
   TANGER_OCX_bDocOpen = false;
}

function TANGER_OCX_SaveDoc()
{
  var newwin,newdoc;

  if(!TANGER_OCX_bDocOpen)
  {
    alert("没有打开的文档。");
    return;
  }

  try
  {
     if(!TANGER_OCX_doFormOnSubmit()) return;//如果存在，则执行表单的onsubmit函数。
     //调用控件的SaveToURL函数
     //alert(document.forms[0].action);
     //alert(document.forms[0].filename.value);
    var retHTML = TANGER_OCX_OBJ.SaveAsOtherFormatToURL
    (
      5,
      document.forms[0].action,  //此处为uploadedit.asp
      "EDITFILE",	//文件输入域名称,可任选,不与其他<input type=file name=..>的name部分重复即可
      "", //可选的其他自定义数据－值对，以&分隔。如：myname=tanger&hisname=tom,一般为空
      document.forms[0].filename.value, //文件名,此处从表单输入获取，也可自定义
      "myForm" //控件的智能提交功能可以允许同时提交选定的表单的所有数据.此处可使用id或者序号
    ); //此函数会读取从服务器上返回的信息并保存到返回值中。
    //刷新一下文档窗口
    //window.location.reload();

    // 提交下一页面，在下一页面关闭当前窗口并修改夫页面内容
    //document.forms[0].action = document.getElementById("close_attachcontrol_url").value;
    //document.forms[0].submit();

    //打开一个新窗口显示返回数据
    /*newwin = window.open("","_blank","left=200,top=200,width=400,height=300,status=0,toolbar=0,menubar=0,location=0,scrollbars=1,resizable=1",false);
    newdoc = newwin.document;
    newdoc.open();
    newdoc.write("<html><head><title>返回的数据</title></head><body><center><hr>")
    newdoc.write(retHTML+"<hr>");
    newdoc.write("<input type=button VALUE='关闭窗口' onclick='window.close()'>");
    newdoc.write('</center></body></html>');
    newdoc.close();
    if(window.opener) //如果父窗口存在，刷新并关闭当前窗口
    {

      window.opener.location.reload();
    }
    //window.close();
    */
  }
  catch(err){
    alert("不能保存到URL：" + err.number + ":" + err.description);
  }
  finally{
  }
}

function TANGER_OCX_SaveTemplate()
{
  var newwin,newdoc;

  if(!TANGER_OCX_bDocOpen)
  {
    alert("没有打开的文档。");
    return;
  }

  try
  {

     //if(!TANGER_OCX_doFormOnSubmit())return; //如果存在，则执行表单的onsubmit函数。
     //调用控件的SaveToURL函数
    var retHTML = TANGER_OCX_OBJ.SaveAsOtherFormatToURL
    (
      5,
      document.forms[0].action,  //此处为uploadedit.asp
      "EDITFILE",	//文件输入域名称,可任选,不与其他<input type=file name=..>的name部分重复即可
      "", //可选的其他自定义数据－值对，以&分隔。如：myname=tanger&hisname=tom,一般为空
      document.forms[0].filename.value, //文件名,此处从表单输入获取，也可自定义
      "frmDocTemplate" //控件的智能提交功能可以允许同时提交选定的表单的所有数据.此处可使用id或者序号
    ); //此函数会读取从服务器上返回的信息并保存到返回值中。
    //刷新一下文档窗口
    //window.location.reload();
    //打开一个新窗口显示返回数据
    /*newwin = window.open("","_blank","left=200,top=200,width=400,height=300,status=0,toolbar=0,menubar=0,location=0,scrollbars=1,resizable=1",false);
    newdoc = newwin.document;
    newdoc.open();
    newdoc.write("<html><head><title>返回的数据</title></head><body><center><hr>")
    newdoc.write(retHTML+"<hr>");
    newdoc.write("<input type=button VALUE='关闭窗口' onclick='window.close()'>");
    newdoc.write('</center></body></html>');
    newdoc.close();
    if(window.opener) //如果父窗口存在，刷新并关闭当前窗口
    {

      window.opener.location.reload();
    }
    //window.close();
    */
  }
  catch(err){
    alert("不能保存到URL：" + err.number + ":" + err.description);
  }
  finally{
  }
}

function TANGER_OCX_SaveAsHTML()
{
  var newwin,newdoc;

  if(!TANGER_OCX_bDocOpen)
  {
    alert("没有打开的文档。");
    return;
  }
  try
  {
    //调用控件的PublishAsHTMLToURL函数
    var retHTML = TANGER_OCX_OBJ.PublishAsHTMLToURL
      (
        "uploadhtmls.jsp",
        "HTMLFILES", //文件输入域名称,可任选,所有相关文件都以此域上传
        "",
        document.forms[0].htmlfile.value
        //此处省略了第5个参数，HTML FORM得索引或者id.这样,不会提交表单数据
        //只提交所有得html文件相关得文件
      );
    newwin = window.open("","_blank","left=200,top=200,width=400,height=300,status=0,toolbar=0,menubar=0,location=0,scrollbars=1,resizable=1",false);
    newdoc = newwin.document;
    newdoc.open();
    newdoc.write("<center><hr>"+retHTML+"<hr><input type=button VALUE='关闭窗口' onclick='window.close()'></center>");
    newdoc.close();
    newwin.focus();
    if(window.opener) //如果父窗口存在，刷新并关闭当前窗口
    {
      window.opener.location.reload();
    }
  }
  catch(err){
    alert("不能保存到URL：" + err.number + ":" + err.description);
  }
  finally{
  }
}

// 文档保护
function SetReadOnly(IsReadOnly){
  TANGER_OCX_OBJ.SetReadOnly(IsReadOnly,DocPassWord);
}

//切换文档的只读状态（文档保护状态）
function TANGER_OCX_SetReadOnly(boolvalue)
{
  var i;
  try
  {
    if (boolvalue) TANGER_OCX_OBJ.IsShowToolMenu = false;
    with(TANGER_OCX_OBJ.ActiveDocument)
    {
      if (TANGER_OCX_OBJ.DocType == 1) //word
      {
        if ( (ProtectionType != -1) &&  !boolvalue)
        {
          Unprotect();
        }
        if ( (ProtectionType == -1) &&  boolvalue)
        {
          Protect(2,true,"");
        }
      }else if(TANGER_OCX_OBJ.DocType == 6)//wps word
      {
        if ( (ProtectionType != -1) &&  !boolvalue)
        {
          Unprotect();
        }
        if ( (ProtectionType == -1) &&  boolvalue)
        {
          Protect(2,true,"");
        }
      }
      else if(TANGER_OCX_OBJ.DocType == 2)//excel
      {
        for(i=1;i<=Application.Sheets.Count;i++)
        {
          if(boolvalue)
          {
            Application.Sheets(i).Protect("",true,true,true);
          }
          else
          {
            Application.Sheets(i).Unprotect("");
          }
        }
        if(boolvalue)
        {
          Application.ActiveWorkbook.Protect("",true);
        }
        else
        {
          Application.ActiveWorkbook.Unprotect("");
        }
      }else if(TANGER_OCX_OBJ.DocType == 7)//kingsoft sheet
      {
        for(i=1;i<=Application.Sheets.Count;i++)
        {
          if(boolvalue)
          {
            Application.Sheets(i).Protect("",true,true,true);
          }
          else
          {
            Application.Sheets(i).Unprotect("");
          }
        }
        if(boolvalue)
        {
          Application.ActiveWorkbook.Protect("",true);
        }
        else
        {
          Application.ActiveWorkbook.Unprotect("");
        }
      }
    }
  }
  catch(err){
    //alert("错误：" + err.number + ":" + err.description);
  }
  finally{}

}

//设置用户名
function TANGER_OCX_SetDocUser(cuser)
{
  with(TANGER_OCX_OBJ.ActiveDocument.Application)
  {
    UserName = cuser;
  }
}
//屏蔽菜单
function TANGER_OCX_EnableMenu(boolvalue){
    //新建
  TANGER_OCX_EnableFileNewMenu((boolvalue));
  //打开
  TANGER_OCX_EnableFileOpenMenu(boolvalue);
  //关闭
  TANGER_OCX_EnableFileCloseMenu(boolvalue);
  //保存
  TANGER_OCX_EnableFileSaveMenu(boolvalue);
  //另存为
  TANGER_OCX_EnableFileSaveAsMenu(boolvalue);

}

//套红头
function TANGER_OCX_DoPaiBan(URL1,FieldArray){
   try{
       TANGER_OCX_SetReadOnly(false);
       if(TANGER_OCX_OBJ.ActiveDocument.TrackRevisions){
         TANGER_OCX_SetMarkModify(false);
       }

    //选择对象当前文档的所有内容
    var curSel = TANGER_OCX_OBJ.ActiveDocument.Application.Selection;
    //
    curSel.WholeStory();
    curSel.Cut();
    //插入模板
    TANGER_OCX_OBJ.AddTemplateFromURL(URL1);

    var BookMarkName = "正文";
    if(!TANGER_OCX_OBJ.ActiveDocument.BookMarks.Exists(BookMarkName))
    {
      alert("Word 模板中不存在名称为：\""+BookMarkName+"\"的书签！");
      return;
    }
    var bkmkObj = TANGER_OCX_OBJ.ActiveDocument.BookMarks(BookMarkName);
    var saverange = bkmkObj.Range;
    //saverange.Paste();
    saverange.Select();
        TANGER_OCX_OBJ.ActiveDocument.Application.Selection.Paste();
    TANGER_OCX_OBJ.ActiveDocument.Bookmarks.Add(BookMarkName,saverange);
    //TANGER_OCX_SetMarkModify(true);
    //替换其它书签
    TANGER_OCX_ReplaceBookMarks(FieldArray);
  }
  catch(err)
  {
    alert("错误：" + err.number + ":" + err.description);
  }
}
//wps设置留痕模式
function WPSEnterRevisionMode(BoolValue)
{
    var doc = TANGER_OCX_OBJ.ActiveDocument;
    var app = doc.Application;
    var doctype = TANGER_OCX_OBJ.DocType;
    if( 6 != doctype)
    {
      alert("此功能需要使用WPS！");
      return;
    }
    var cmdbars = app.CommandBars;
    TANGER_OCX_OBJ.IsShowToolMenu =true ;	//关闭或打开工具菜单 !BoolValue
    doc.TrackRevisions = BoolValue;
    cmdbars("Reviewing").Enabled = false;
  cmdbars("Reviewing").Visible = false;
  cmdbars(40).Enabled = false;
  cmdbars(40).Visible = false;

  //cmdbars("Reviewing").Enabled = !BoolValue;
  //cmdbars("Reviewing").Visible = !BoolValue;
  //RevisionTextPopupMenuOntbShortcutMenus 禁止右键菜单。很奇怪使用字符串不行。
  //cmdbars(40).Enabled = !BoolValue;
  //cmdbars(40).Visible = !BoolValue;
}
//循环取书签，进行套红（正文书签除外）
function TANGER_OCX_ReplaceBookMarks(FieldArray){
  var i=0;
  var k=0;
  var BookMarks = TANGER_OCX_OBJ.ActiveDocument.BookMarks;
  var BookMarkCount = BookMarks.count;
  for(i=BookMarkCount; i>0;i-- ){
    var FieldLength =FieldArray.length;
    var bookMarkname= BookMarks(i).Name ;
    //alert(bookMarkname);
    //循环替换
    for(k=0; k<FieldLength;k++){
     if(bookMarkname==FieldArray[k][k].FieldName){
        var MarkName =FieldArray[k][k].FieldName;
        var MarkValue =FieldArray[k][k].FieldValue;
        //替换
       TANGER_OCX_OBJ.SetBookmarkValue(bookMarkname,MarkValue);
       }
    }
  }
}
function saveFile(){
  SetReadOnly(true);
  TANGER_OCX_EnableFileSaveMenu(true);
  TANGER_OCX_bDocOpen = true;
  //TANGER_OCX_SaveEditToServer();
  //调用控件的SaveToURL函数
  var filename = document.getElementById("filename").value;
  var fileparam = document.getElementById("fileparam").value;
  TANGER_OCX_OBJ.SaveToURL("office_saveFile.action?fileparam=" + fileparam,"ntkoFile","",filename,0);
}
function editFile(){
	SetReadOnly(false);
}
function closeFile(){
	window.close();
}


/**
 *弹出一个指定宽度和长度的窗口
 *
 */
function demoPopUp(strUrl,jumpMode,sWidth,sHeight){
   if(!sWidth) sWidth="800";
   if(!sHeight) sHeight="600";
   if(!jumpMode) jumpMode = "1";
   var name,value,i,actUrl;
   var tmphtml = '';
   var parm = 'height='+sHeight+',width='+sWidth+',toolbar=no,scrollbars=yes, resizable=yes, location=no, status=no' ;

   var myform = document.getElementById("submit_form");
   if(myform == null){
	   myform = document.createElement("form");
	   myform.setAttribute('id','submit_form');
	   document.body.appendChild(myform);
   }
   
   var num= strUrl.indexOf("?");
	if(num > 0){
		actUrl = strUrl.substring(0,num);
		var arrtmp=strUrl.substr(num+1).split("&");
		for(i=0;i < arrtmp.length;i++){
			num=arrtmp[i].indexOf("=");
			if(num>0){
				name=arrtmp[i].substring(0,num);
				value=arrtmp[i].substr(num+1);
				tmphtml = tmphtml + ' <input type="hidden" name="'+name+'" value="'+value+'"> ';
	    	}
     	}
	}else{
		actUrl = strUrl;
	}
	myform.innerHTML = tmphtml;
	myform.action = actUrl;
	myform.method="post";
	var win_name;
	if(jumpMode && jumpMode == "0") {
		win_name = "_self";
	} else {
		win_name = randomChar(10);
	}
	myform.target = win_name;
	
	if(jumpMode && jumpMode == "1") {
		window.open('/vpftagdemo/demo/richweb/officeblank.jsp',win_name,parm);   
	}
	
	myform.submit();	
}

/**
 *随机字符串
 *
 */
function  randomChar(len)  {
  var  x="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  var  tmp="";
  for(var  i=0;i<len;i++)  {
  	tmp  +=  x.charAt(Math.ceil(Math.random()*100000000)%x.length);
  }
  return  tmp;
}
