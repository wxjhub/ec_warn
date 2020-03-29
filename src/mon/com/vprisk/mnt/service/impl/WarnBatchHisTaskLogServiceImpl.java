package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.WarnBatchConfigDao;
import com.vprisk.mnt.dao.WarnBatchHisTaskLogDao;
import com.vprisk.mnt.entity.WarnBatchHisTaskLog;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnBatchHisTaskLogServiceImpl implements
		WarnBatchHisTaskLogService {
	
	WarnBatchHisTaskLogDao warnBatchHisTaskLogDao;
	WarnBatchConfigDao warnBatchConfigDao;

	public WarnBatchHisTaskLogDao getWarnBatchHisTaskLogDao() {
		return warnBatchHisTaskLogDao;
	}

	public void setWarnBatchHisTaskLogDao(
			WarnBatchHisTaskLogDao warnBatchHisTaskLogDao) {
		this.warnBatchHisTaskLogDao = warnBatchHisTaskLogDao;
	}
    
	public WarnBatchConfigDao getWarnBatchConfigDao() {
		return warnBatchConfigDao;
	}

	public void setWarnBatchConfigDao(WarnBatchConfigDao warnBatchConfigDao) {
		this.warnBatchConfigDao = warnBatchConfigDao;
	}

	@Override
	public Page queryWarnBatchHisLogByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Page page = this.warnBatchHisTaskLogDao.selectWarnBatchTaskLogByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	 List<WarnBatchHisTaskLog> data = page.getData();
	 for(WarnBatchHisTaskLog config:data){
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
