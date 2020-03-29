package com.vprisk.mnt.warn;

import java.util.Date;
import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 * 交易成功率监控定时器调用
 *
 */

public class TransactionSuccessSysListener implements ServletContextListener{

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
	
		timer.schedule(new TransactionSuccessWarnAction(), 1000*60*2,1000*60*10);
		//timer.schedule(new TransactionSuccessWarnAction(), 1000,1000);
		event.getServletContext().log("已经添加任务调度表");
	}
}
