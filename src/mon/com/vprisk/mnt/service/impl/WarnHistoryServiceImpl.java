package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.WarnHistoryDao;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 预警历史查询service实现类
 * 
 */
public class WarnHistoryServiceImpl implements WarnHistoryService {
	private WarnHistoryDao warnHistoryDao;

	public WarnHistoryDao getWarnHistoryDao() {
		return warnHistoryDao;
	}

	public void setWarnHistoryDao(WarnHistoryDao warnHistoryDao) {
		this.warnHistoryDao = warnHistoryDao;
	}



	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return warnHistoryDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage2(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return warnHistoryDao.selectParameterCollectiondByPage2(params, pageNo,
				pageSize, orderBy, isAsc);
	}



	public boolean saveOrUpdateCash(WarnHistory pracol) {
		return warnHistoryDao.saveOrUpdateCash(pracol);
	}



	public void handleStateById(String id) {
		warnHistoryDao.handleStateById(id);

	}


	public void insertIntoWarnHistory(WarnHistory warnhistory) {
		warnHistoryDao.insertIntoWarnHistory(warnhistory);
	}
	
	
	
	public void updateWarnHistory(String id ) {
		warnHistoryDao.updateWarnHistory(id);
	}
	
	
	
	public List<WarnHistory> handleStateByCourseCode(String recordName,String pointName, String pointIp, String warnSort) {
		List<WarnHistory> list = new ArrayList<WarnHistory>();
		list=warnHistoryDao.handleStateByCourseCode( recordName, pointName,  pointIp,  warnSort);
		return list;
	}

	@Override
	public void updateConfirmation(Map params, String userName, String userOrganName ) {
		warnHistoryDao.updateConfirmation(params,userName,userOrganName);
		
	}
	
}
