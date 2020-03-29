package com.vprisk.mnt.warn;

import java.util.Date;
import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * sql程序监控定时器调用
 *
 */

public class SqlBlockSysListener implements ServletContextListener{

	private java.util.Timer timer = null;
	public void contextDestroyed(ServletContextEvent event) {
		timer.cancel();
		event.getServletContext().log("定时器销毁");
	}

	public void contextInitialized(ServletContextEvent event) {
		Date taskrun = new Date();
		System.out.println("taskrun:"+taskrun);
		timer = new Timer();
		event.getServletContext().log("定时器已启动");
		/*---------------设置指定任务的执行时间----------------------------*/
		//Get the Date corresponding to 11:01:00 pm today.  
//		Calendar calendar = Calendar.getInstance();  
//		calendar.set(Calendar.HOUR_OF_DAY, 23);  
//		calendar.set(Calendar.MINUTE, 59);  
//		calendar.set(Calendar.SECOND, 59);  
//		Date time = calendar.getTime();  
//		timer = new Timer();  
		
		
		
		timer.schedule(new SqlBlockWarnAction(), 1000*60*2,1000*60*10); //在1000*60*2之后执行 每隔1000*60*30执行一次
		//timer.schedule(new SqlBlockWarnAction(), 1000*60*2,1000);
		event.getServletContext().log("已经添加任务调度表");
	}
}
