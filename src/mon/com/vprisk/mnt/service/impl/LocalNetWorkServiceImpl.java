package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.LocalNetWorkDao;
import com.vprisk.mnt.entity.LocalNetWork;
import com.vprisk.mnt.service.LocalNetWorkService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class LocalNetWorkServiceImpl implements LocalNetWorkService {
	private LocalNetWorkDao localNetWorkDao;

	public LocalNetWorkDao getLocalNetWorkDao() {
		return localNetWorkDao;
	}
	public void setLocalNetWorkDao(LocalNetWorkDao netWorkDao) {
		this.localNetWorkDao = netWorkDao;
	}

	public List<LocalNetWork> findParameterCollection(LocalNetWork subject) {
		List<LocalNetWork> list = new ArrayList<LocalNetWork>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = localNetWorkDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = localNetWorkDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			localNetWorkDao.removeParameterCollectionByuuid(str[i]);
		}
	}


	public boolean saveOrUpdateCash(LocalNetWork pracol) {
		return localNetWorkDao.saveOrUpdateCash(pracol);
	}


	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return localNetWorkDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}

	
	public void updatelocalNetWorkByUuid(String status,String uuid) {
		localNetWorkDao.updatelocalNetWorkByUuid(status,uuid);
	}
	public List<LocalNetWork> findNetWork() {
		return localNetWorkDao.findNetWork();
	}
	@Override
	public void insertModel(LocalNetWork localNetWork) {
		localNetWorkDao.insertModel(localNetWork);
		
	}
}
