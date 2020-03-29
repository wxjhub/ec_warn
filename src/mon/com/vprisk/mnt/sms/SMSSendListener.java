package com.vprisk.mnt.sms;

import java.text.SimpleDateFormat;
import java.util.TimerTask;

import com.ibm.icu.util.Calendar;
import com.vprisk.mnt.sms.action.SMSSendAction;

public class SMSSendListener extends TimerTask{
	
	private static boolean isrunning = false;
	public void run() {
		if(!isrunning){
			isrunning = true;
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String datedata = sdf.format(cal.getTime());
			//查询
			SMSSendAction app = new SMSSendAction();
			app.serviceServerAuto();//发送短信
			isrunning = false;
		}
	}
}
