package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.DayEndMonitor;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 日终service接口类
 */
public interface DayEndMonitorService {

	@SuppressWarnings("unchecked")
	List<DayEndMonitor> findList(Map params);

	Page queryWarnBatchHisLogByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	

}
