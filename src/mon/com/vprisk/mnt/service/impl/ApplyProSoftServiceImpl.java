package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.ApplyProSoftDao;
import com.vprisk.mnt.entity.ApplyProSoft;
import com.vprisk.mnt.service.ApplyProSoftService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;



public class ApplyProSoftServiceImpl implements ApplyProSoftService {
	private ApplyProSoftDao applyProSoftDao;

	public ApplyProSoftDao getApplyProSoftDao() {
		return applyProSoftDao;
	}

	public void setApplyProSoftDao(ApplyProSoftDao applyProSoftDao) {
		this.applyProSoftDao = applyProSoftDao;
	}

	
	public List<ApplyProSoft> findParameterCollection(ApplyProSoft subject) {
		List<ApplyProSoft> list = new ArrayList<ApplyProSoft>();
		if (StringUtil.isNotNullOrEmpty(subject.getUuid())) {
			list = applyProSoftDao.findParameterCollectionByUpdate(subject);
		}
		if (StringUtil.isNullOrEmpty(subject.getUuid())) {
			list = applyProSoftDao.findParameterCollectionByAdd(subject);
		}
		return list;

	}

	public void removeParameterCollectionByuuid(String uuid) {
		String[] str = uuid.split(",");
		for (int i = 0; i < str.length; i++) {
			applyProSoftDao.removeParameterCollectionByuuid(str[i]);
		}
	}

	public boolean saveOrUpdateCash(ApplyProSoft pracol) {
		return applyProSoftDao.saveOrUpdateCash(pracol);
	}

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return applyProSoftDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}

	public void updateApplyProSoftByIP(String ip) {
		applyProSoftDao.updateApplyProSoftByIP(ip);

	}

	public List<ApplyProSoft> findApplyProSoft() {
		return applyProSoftDao.findApplyProSoft();
	}

	public void updateApplyProSoftByCourseCode(int num, String courseStatus,
			String courseCode, String localIp) {
		applyProSoftDao.updateApplyProSoftByCourseCode(num, courseStatus,
				courseCode, localIp);
	}

	@Override
	public void insertModel(ApplyProSoft applyProSoft) {
		applyProSoftDao.insertModel(applyProSoft);

		
	}

}
