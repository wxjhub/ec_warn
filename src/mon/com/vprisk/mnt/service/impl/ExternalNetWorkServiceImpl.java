package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.ExternalNetWorkDao;
import com.vprisk.mnt.entity.ExternalNetWork;
import com.vprisk.mnt.service.ExternalNetWorkService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class ExternalNetWorkServiceImpl implements ExternalNetWorkService {
	private ExternalNetWorkDao externalnetWorkDao;
	
	public ExternalNetWorkDao getExternalNetWorkDao() {
		return externalnetWorkDao;
	}
	public void setExternalNetWorkDao(ExternalNetWorkDao externalnetWorkDao) {
		this.externalnetWorkDao = externalnetWorkDao;
	}
	

	public List<ExternalNetWork> findParameterCollection(ExternalNetWork subject) {
		List<ExternalNetWork> list = new ArrayList<ExternalNetWork>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = externalnetWorkDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = externalnetWorkDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			externalnetWorkDao.removeParameterCollectionByuuid(str[i]);
		}
	}


	public boolean saveOrUpdateCash(ExternalNetWork pracol) {
		return externalnetWorkDao.saveOrUpdateCash(pracol);
	}


	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return externalnetWorkDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	
	public void updateExternalnetWorkByUuid(String status,String uuid) {
		externalnetWorkDao.updateExternalnetWorkByUuid(status,uuid);
	}
	public List<ExternalNetWork> findNetWork() {
		return externalnetWorkDao.findNetWork();
	}
	
	public void insertModel(ExternalNetWork externalNetWork) {
		externalnetWorkDao.insertModel(externalNetWork);
		
	}
}
