package com.vprisk.mnt.base;

import java.util.Date;
import java.util.List;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.reflect.MethodSignature;
import com.vprisk.mnt.dao.BtnRespTimeInfoDao;
import com.vprisk.mnt.dao.BtnRespTimeLogDao;
import com.vprisk.mnt.entity.BtnRespTimeInfo;
import com.vprisk.mnt.entity.BtnRespTimeLog;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 切面环绕通知工具类测试用
 * @author xinji_wang
 *
 */
public class ButtonResponseTimeUtil{

	public Object aroundMethodG1(ProceedingJoinPoint point) throws Throwable {
		Object obj = null;
		Object[] args = point.getArgs();

		// 获取方法
		MethodSignature signature = (MethodSignature) point.getSignature();
		String methodPath = signature.getDeclaringTypeName() + "." + signature.getName();

		// 记录时间
		long startTime = System.currentTimeMillis();
		try {
			obj = point.proceed(args);
		} catch (Throwable e) {
			// logger.error("统计某方法执行耗时环绕通知出错", e);
			System.out.println("统计某方法执行耗时环绕通知出错");
			e.printStackTrace();
		}
		long endTime = System.currentTimeMillis();
		DynamicDataSourceContext.clear();
		// 检测方法是否是需要记录的方法
		if (this.checkMethod(methodPath)) {

			// 将信息存入数据库中
			this.saveExecTime(methodPath, startTime, endTime);
		}
		return obj;
	}

    
	private void saveExecTime(String methodPath, long startTime, long endTime) {
		BtnRespTimeLogDao BtnRespTimeLogDao = (BtnRespTimeLogDao) ContextHolder.getBean("btnRespTimeLogDao");
		BtnRespTimeLog log = new BtnRespTimeLog();
		log.setStartTime(new Date(startTime));
		log.setStartMillis(Long.toString(startTime));
		log.setEndTime(new Date(endTime));
		log.setEndMillis(Long.toString(endTime));
		log.setMethodPath(methodPath);
		BtnRespTimeLogDao.saveLog(log);
	}

	private boolean checkMethod(String methodPath) {
		BtnRespTimeInfoDao btnRespTimeInfoDao = (BtnRespTimeInfoDao) ContextHolder.getBean("btnRespTimeInfoDao");
		System.out.println("-----------methodPath:" + methodPath);
		List<BtnRespTimeInfo> info = btnRespTimeInfoDao.queryByMethodPath(methodPath);
		for(BtnRespTimeInfo btn:info) {
			if (StringUtil.isNotNullOrEmpty(btn.getUuid())) {
				return true;
			} else {
				return false;
			}
		}
		return false;
		
	}

}
