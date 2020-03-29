package com.vprisk.mnt.sms;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class SMSListener implements ServletContextListener {
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String scheduleDate = "2016-3-1 12:00:00";

	private Timer timer = null;
	public void contextDestroyed(ServletContextEvent event) {
		timer.cancel();
		event.getServletContext().log("定时器销毁");
	}

	public void contextInitialized(ServletContextEvent event) {
		Date taskrun = new Date();
		System.out.println("taskrun:"+taskrun);
		timer = new Timer();
		event.getServletContext().log("定时器已启动");
		
		Date d;
		try {
			d = sdf.parse(scheduleDate);
//			MyTask mt = new MyTask();
//			timer.schedule(mt, d);
//			timer.schedule(new SMSSendProcedureListener(), d, 1000*60*60*24);
			timer.schedule(new SMSSendListener(), d, 1000*60); //一分钟执行一次
		} catch (ParseException e) {
			e.printStackTrace();
		}
		event.getServletContext().log("已经添加任务调度表");
	}
	
}
