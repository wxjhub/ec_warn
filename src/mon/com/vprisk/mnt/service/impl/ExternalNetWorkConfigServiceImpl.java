package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.ExternalNetWorkConfigDao;
import com.vprisk.mnt.entity.ExternalNetWorkConfig;
import com.vprisk.mnt.service.ExternalNetWorkConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class ExternalNetWorkConfigServiceImpl implements ExternalNetWorkConfigService {
	private ExternalNetWorkConfigDao externalNetWorkConfigDao;

	public ExternalNetWorkConfigDao getExternalNetWorkConfigDao() {
		return externalNetWorkConfigDao;
	}

	public void setExternalNetWorkConfigDao(
			ExternalNetWorkConfigDao externalNetWorkConfigDao) {
		this.externalNetWorkConfigDao = externalNetWorkConfigDao;
	}

	public List<ExternalNetWorkConfig> findParameterCollection(
			ExternalNetWorkConfig subject) {
		List<ExternalNetWorkConfig> list = new ArrayList<ExternalNetWorkConfig>();
		if (StringUtil.isNotNullOrEmpty(subject.getUuid())) {
			list = externalNetWorkConfigDao
					.findParameterCollectionByUpdate(subject);
		}
		if (StringUtil.isNullOrEmpty(subject.getUuid())) {
			list = externalNetWorkConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;

	}

	public void removeParameterCollectionByuuid(String uuid) {
		String[] str = uuid.split(",");
		for (int i = 0; i < str.length; i++) {
			externalNetWorkConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}

	public boolean saveOrUpdateCash(ExternalNetWorkConfig pracol) {
		return externalNetWorkConfigDao.saveOrUpdateCash(pracol);
	}

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return externalNetWorkConfigDao.selectParameterCollectiondByPage(params,
				pageNo, pageSize, orderBy, isAsc);
	}

	@Override
	public void updateExternalnetWorkByUuid(String status,String uuid) {
		externalNetWorkConfigDao.updateExternalnetWorkByUuid(status,uuid);
	}
	public List<ExternalNetWorkConfig> findNetWork() {
		// TODO Auto-generated method stub
		return externalNetWorkConfigDao.findNetWork();
	}

}
