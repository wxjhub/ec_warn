package com.vprisk.mnt.warn;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Timer;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.vprisk.mnt.entity.WarnModuleConfig;
import com.vprisk.mnt.service.WarnModuleConfigService;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.util.StringUtil;
/**
 * 跑批监控监听处理类
 * @author lenovo
 *
 */
public class BatchWarnSysListener  implements ServletContextListener{
	private Timer timer = null;
	public void contextDestroyed(ServletContextEvent event) {
		timer.cancel();
		event.getServletContext().log("跑批监控定时器销毁");
	}
    /**
     * 定时器启动调用的方法 该定时器被调用的配置在web.xml中
     */
	public void contextInitialized(ServletContextEvent event) {
		timer = new Timer();
		event.getServletContext().log("跑批监控定时器已启动");
		WarnModuleConfigService warnModuleConfigService = (WarnModuleConfigService) ContextHolder.getBean("warnModuleConfigService");
		//查询配置的执行时间的间隔信息
		WarnModuleConfig config = warnModuleConfigService.queryWarnModuleByModuleCode("01"); //跑批监控的code是01
		if(StringUtil.isNotNullOrEmpty(config.getWarnRoundTimeS())){
			BigDecimal roundSeconds = new BigDecimal(config.getWarnRoundTimeS());
			String intervalT = roundSeconds.divide(new BigDecimal(60), RoundingMode.HALF_DOWN).toString();
			timer.schedule(new BatchWarnAction(), 1000*60*2,1000*60*Long.valueOf(intervalT)); //两分钟之后执行 每隔设置的时间执行一次
//			timer.schedule(new BatchWarnAction(), 1000,1000); //两分钟之后执行 每隔设置的时间执行一次
		} else {
			timer.schedule(new BatchWarnAction(), 1000*60*1,1000*60*30); //两分钟之后执行 每个30分钟执行一次
		}
		event.getServletContext().log("跑批监控定时器已经添加任务调度表");
	}
}
