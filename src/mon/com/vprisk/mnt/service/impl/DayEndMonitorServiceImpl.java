package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.vprisk.mnt.base.SMSSendForApiAction;
import com.vprisk.mnt.dao.DayEndMonitorDao;
import com.vprisk.mnt.dao.WarnBatchConfigDao;
import com.vprisk.mnt.entity.DayEndMonitor;
import com.vprisk.mnt.entity.WarnBatchHisTaskLog;
import com.vprisk.mnt.service.DayEndMonitorService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

public class DayEndMonitorServiceImpl implements DayEndMonitorService {
	private static Log log = LogFactory.getLog(DayEndMonitorServiceImpl.class);
	private DayEndMonitorDao dayEndMonitorDao;
	
	private WarnBatchConfigDao warnBatchConfigDao;
	
	
	public WarnBatchConfigDao getWarnBatchConfigDao() {
		return warnBatchConfigDao;
	}


	public void setWarnBatchConfigDao(WarnBatchConfigDao warnBatchConfigDao) {
		this.warnBatchConfigDao = warnBatchConfigDao;
	}


	public DayEndMonitorDao getDayEndMonitorDao() {
		return dayEndMonitorDao;
	}


	public void setDayEndMonitorDao(DayEndMonitorDao dayEndMonitorDao) {
		this.dayEndMonitorDao = dayEndMonitorDao;
	}


	

	public List<DayEndMonitor> findList(Map params) {
		return this.dayEndMonitorDao.findList(params);
	}


	@Override
	public Page queryWarnBatchHisLogByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		log.info("日期"+params.get("asOfDate"));
		log.info("日期"+DateUtil.convertStringToDate((String) params.get("asOfDate")));
		Page page = dayEndMonitorDao.queryWarnBatchHisLogByPage(params, pageNo,pageSize,orderBy,isAsc);
		List<DayEndMonitor> data = page.getData();
		log.info("日期查询的结果个数"+data.size());
			 for(DayEndMonitor config:data){
				 List<Map<String,String>> bttdata = this.warnBatchConfigDao.selectBatchInfo(config.getBatchId(), config.getProcessId(), config.getTaskId());
			 if(bttdata.size() > 0){
				 Map<String, String> map = bttdata.get(0);
				 config.setBatchName(StringUtil.isNotNullOrEmpty(map.get("batchName"))?map.get("batchName").toString():"该批次不存在");
				 config.setProcessName(StringUtil.isNotNullOrEmpty(map.get("taskSetName"))?map.get("taskSetName").toString():"该任务组存在");
				 config.setTaskName(StringUtil.isNotNullOrEmpty(map.get("taskName"))?map.get("taskName").toString():"该任务不存在");
			 } 
		 }
		page.setData(data);
		return page;
	}
	
}
