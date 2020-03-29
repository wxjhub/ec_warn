package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.DayEndConfigDao;
import com.vprisk.mnt.entity.DayEndConfig;
import com.vprisk.mnt.service.DayEndConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class DayEndConfigServiceImpl implements DayEndConfigService {

	private DayEndConfigDao dayEndConfigDao;

	public DayEndConfigDao getDayEndConfigDao() {
		return dayEndConfigDao;
	}

	public void setDayEndConfigDao(DayEndConfigDao dayEndConfigDao) {
		this.dayEndConfigDao = dayEndConfigDao;
	}

	public List<DayEndConfig> findParameterCollection(DayEndConfig subject) {
		List<DayEndConfig> list = new ArrayList<DayEndConfig>();
		if (StringUtil.isNotNullOrEmpty(subject.getUuid())) {
			list = dayEndConfigDao.findParameterCollectionByUpdate(subject);
		}
		if (StringUtil.isNullOrEmpty(subject.getUuid())) {
			list = dayEndConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;

	}

	public void removeParameterCollectionByuuid(String uuid) {
		String[] str = uuid.split(",");
		for (int i = 0; i < str.length; i++) {
			dayEndConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}

	public boolean saveOrUpdateCash(DayEndConfig pracol) {
		return dayEndConfigDao.saveOrUpdateCash(pracol);
	}

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return dayEndConfigDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}

	@Override
	public List<DayEndConfig> findAll() {
		return dayEndConfigDao.findAll();
	}

}
