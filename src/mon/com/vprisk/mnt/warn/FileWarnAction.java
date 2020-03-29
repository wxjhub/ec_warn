package com.vprisk.mnt.warn;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.TimerTask;

import com.ibm.icu.util.Calendar;
import com.vprisk.mnt.action.FileTranControlAction;
import com.vprisk.mnt.action.WarnIntervalAction;
import com.vprisk.mnt.entity.WarnInterval;
import com.vprisk.rmplatform.util.StringUtil;

public class FileWarnAction extends TimerTask{
	private static boolean isrunning = false;
	public void run() {
		try{
			apply();
		}catch(Exception e){
			e.printStackTrace();
		}
	}

	private  synchronized void apply(){
		if(!isrunning){
			isrunning = true;
			//context.log("文件传输应用程序开始执行任务");
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String datedata = sdf.format(cal.getTime());
		   /*
		    * 业务实现区
		    */
		   WarnIntervalAction wia = new WarnIntervalAction();
		   //根据预警代码查询关联的预警时间间隔对象
		   WarnInterval wi = wia.WarnIntervalByWarnCode("FILE_TRAN_WARN_INTEVAL","find",null);
			  if(StringUtil.isNotNullOrEmpty(wi.getOnceTime())){//判断上次预警时间是否为空
				  long nowtime = cal.getTimeInMillis();//系统当前时间
				  long oncetime = 0;
				  try {
				   oncetime = sdf.parse(wi.getOnceTime()).getTime();
				  } catch (ParseException e) {
					e.printStackTrace();
				  }//上次预警时间
				  long intertime = wi.getWarnInterval()*60*1000;//时间间隔，单位：毫秒
				  long longnum = nowtime-oncetime;
				if(longnum>=intertime){
					//调用应用程序预警的方法
					FileTranControlAction app = new FileTranControlAction();
					app.fileTranWarn();
					//更新预警时间
					wia.WarnIntervalByWarnCode("FILE_TRAN_WARN_INTEVAL","update",datedata);
				}
			}else{
				FileTranControlAction app = new FileTranControlAction();
				app.fileTranWarn();
				//更新预警时间
				wia.WarnIntervalByWarnCode("FILE_TRAN_WARN_INTEVAL","update",datedata);
			}
			isrunning = false;
			//context.log("文件传输应用程序执行任务结束");
		}else{
		 // context.log("文件传输应用程序执行任务还未结束");
		}
	
 }
}