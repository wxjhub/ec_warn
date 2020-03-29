package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.WarnIntervalDao;
import com.vprisk.mnt.entity.WarnInterval;
import com.vprisk.mnt.service.WarnIntervalService;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 预警时间间隔service实现类
 * 
 */
public class WarnIntervalServiceImpl implements WarnIntervalService {
	private WarnIntervalDao warnIntervalDao;



	public List<WarnInterval> findItemsByName(String warnName) {

		return warnIntervalDao.findItemsByName(warnName);
	}

	public WarnIntervalDao getWarnIntervalDao() {
		return warnIntervalDao;
	}

	public void setWarnIntervalDao(WarnIntervalDao warnIntervalDao) {
		this.warnIntervalDao = warnIntervalDao;
	}



	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return warnIntervalDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}



	public boolean saveOrUpdateCash(WarnInterval pracol) {
		return warnIntervalDao.saveOrUpdateCash(pracol);
	}


	public WarnInterval findWarnIntervalByWarnCode(String warnCode) {
		return warnIntervalDao.selectWarnIntervalByWarnCode(warnCode);
	}


	public void updateWarnIntervalByWarnCode(String warnCode,String datedata) {
		warnIntervalDao.updateWarnIntervalByWarnCode(warnCode,datedata);
	}
	
	//删除
	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			warnIntervalDao.removeParameterCollectionByuuid(str[i]);
		}
	}

}
