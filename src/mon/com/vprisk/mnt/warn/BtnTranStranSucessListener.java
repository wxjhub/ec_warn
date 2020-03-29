package com.vprisk.mnt.warn;

import java.util.Date;
import java.util.Timer;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class BtnTranStranSucessListener implements ServletContextListener{

	private Timer timer = null;
	public void contextDestroyed(ServletContextEvent event) {
		timer.cancel();
		event.getServletContext().log("跑批监控定时器销毁");
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		Date taskrun = new Date();
		System.out.println("taskrun:"+taskrun);
		timer = new Timer();
		event.getServletContext().log("定时器已启动");
		timer.schedule(new BtnTranStranSucessAction(), 1000*60*2,1000*60*30);
//		timer.schedule(new BtnTranStranSucessAction(), 1000,1000);
		event.getServletContext().log("已经添加任务调度表");
	}

}
