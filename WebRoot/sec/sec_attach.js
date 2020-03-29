/**
 * sec_attach.js
 * @author renmeimang 2013.09.28
 * @version 1.0
 * @describe 附件管理js
 */
//将声明的普通上传控件与Uploadify插件绑定 
$(document).ready(function() {
	$('#uploadfile').uploadify({
		'swf'               : 'css/upload/uploadify.swf', //指定上传控件的主体文件
		'uploader' 			: 'attach_saveAttach.action',//指定服务器端上传处理文件
		'queueID'  		    : 'fileQueue',
		'auto'     			: true,//选定文件后是否自动上传，默认false 
        'multi'    			: true,//是否允许同时上传多文件，默认false 
        'fileObjName'       : 'uploadfile',  
        'fileSizeLimit'     : $("#sizelimit").val(),   
        'fileTypeDesc'      : '文档类型', 
        'fileTypeExts'      : $("#filetype").val(), 
        'buttonCursor'      : 'hand', 
      	'buttonText'        :"<img src='css/upload/images/winrar_upload.png' style='border:none'></img> <span style='position: relative;top: -3px;'>选择</span>",
        'removeCompleted'   : false,  //完成时是否清除队列 默认true
        'onUploadSuccess'   :function(file,data,response){
                            if(data.split(",")[0]=="ok"){    
                        //  if(eval(this.queueData.filesReplaced)<= eval(0)){ //如果大于0表示是重复文件 不进行添加
                        	//$.messager.alert('系统提示',file.name+'上传成功','warning');	
                        	var idsplit=data.split(",")[1];
                        	var ids=$("#attachids").val();
                        	ids+=idsplit+",";
                        	$("#attachids").val(ids); 	 
                       // }
                        $("#"+file.id).find("div.cancel>a").attr("href","javascript:deleteData('"+idsplit+"','"+file.id+"')");
                        	}
                      },
       'onQueueComplete': function () {    //所有队列完成后事件
                          alert("上传成功！");  
                      }
                  	
     });
//编辑页面初始化附件数据 	
$(function () {
         var attachobj= $("#attachobj").val(); 
         if(attachobj!=""){
         var jsonList=eval(attachobj);
         var tbody="";
         var ids="";
         for(var i=0;i<jsonList.length;i++){ 
           var trs = "";
            trs += "<tr id=\""+i+"\"><td width='60%'>" +jsonList[i]["sfilename"]+"</td> <td width='20%'><a href='#' onclick = 'javascript:deleterow(\""+ jsonList[i]["attachId"]+"\",\""+ i +"\")'><span style='color:red'>删除</span></a></td></tr>";
            tbody += trs; 
            ids+=jsonList[i]["attachId"]+",";       
        } 
           $("#attachids").val(ids);
           $("#attach").append(tbody);
         }
    });

});
//上传完成后 点击删除触发事件 
function deleteData(id,fileid){
	var str="uuid="+id;
	$.ajax({    
	  url: "attach_removeAttach.action",
	  type: "POST",
	  data: str,
	  success: function(data){  	
			if(data.message!=null){
				var msg = eval("(" + data.message + ")");
				if(msg) 
					$.messager.alert('系统提示', msg.errorMsg, 'warning');
			} else {
				$('#uploadfile').uploadify('cancel',fileid);  //调用uploadify取消事件 
				var s = $("#attachids").val();
				var idstr="";
				if (s.length > 1 ){
					if (s.indexOf(id) > -1){
						idstr = s.substring(0,s.indexOf(id)) 
							+ s.substring(s.indexOf(id)+(id.length+1));
					}
					//idstr = idstr.substring(0,idstr.lastIndexOf(","));
					$("#attachids").val(idstr);
				}
			} 
	  }    
}); 
}
//编辑页面删除 数据 
function deleterow(uuid,n){
	var str="uuid="+uuid;
	$.messager.confirm('系统提示','确定要删除吗?', function(ok){
		if(!ok) return false;
		var s = $("#attachids").val();
		var str="";
		if (s.length > 1 ){
			if (s.indexOf(uuid) > -1){
				str = s.substring(0,s.indexOf(uuid)) 
					+ s.substring(s.indexOf(uuid)+(uuid.length+1));
			}
			
			$("#attachids").val(str);
			$("tr[id="+n+"]").remove();
		}
	}); 
}