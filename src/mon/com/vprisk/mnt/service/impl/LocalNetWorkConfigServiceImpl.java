package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.LocalNetWorkConfigDao;
import com.vprisk.mnt.entity.LocalNetWorkConfig;
import com.vprisk.mnt.service.LocalNetWorkConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class LocalNetWorkConfigServiceImpl implements LocalNetWorkConfigService {
	private LocalNetWorkConfigDao localNetWorkConfigDao;

	public LocalNetWorkConfigDao getLocalNetWorkConfigDao() {
		return localNetWorkConfigDao;
	}

	public void setLocalNetWorkConfigDao(
			LocalNetWorkConfigDao localNetWorkConfigDao) {
		this.localNetWorkConfigDao = localNetWorkConfigDao;
	}

	public List<LocalNetWorkConfig> findParameterCollection(
			LocalNetWorkConfig subject) {
		List<LocalNetWorkConfig> list = new ArrayList<LocalNetWorkConfig>();
		if (StringUtil.isNotNullOrEmpty(subject.getUuid())) {
			list = localNetWorkConfigDao
					.findParameterCollectionByUpdate(subject);
		}
		if (StringUtil.isNullOrEmpty(subject.getUuid())) {
			list = localNetWorkConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;

	}

	public void removeParameterCollectionByuuid(String uuid) {
		String[] str = uuid.split(",");
		for (int i = 0; i < str.length; i++) {
			localNetWorkConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}

	public boolean saveOrUpdateCash(LocalNetWorkConfig pracol) {
		return localNetWorkConfigDao.saveOrUpdateCash(pracol);
	}

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return localNetWorkConfigDao.selectParameterCollectiondByPage(params,
				pageNo, pageSize, orderBy, isAsc);
	}

	
	
	public void updatelocalNetWorkByUuid(String status,String uuid) {
		localNetWorkConfigDao.updatelocalNetWorkByUuid(status,uuid);
	}
	
	public List<LocalNetWorkConfig> findNetWork() {
		// TODO Auto-generated method stub
		return localNetWorkConfigDao.findNetWork();
	}
}
