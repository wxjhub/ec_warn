package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.ApplyProSoftConfigDao;
import com.vprisk.mnt.entity.ApplyProSoftConfig;
import com.vprisk.mnt.service.ApplyProSoftConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class ApplyProSoftConfigServiceImpl implements ApplyProSoftConfigService {
	
	private ApplyProSoftConfigDao applyProSoftConfigDao;
	
	public ApplyProSoftConfigDao getApplyProSoftConfigDao() {
		return applyProSoftConfigDao;
	}
	public void setApplyProSoftConfigDao(ApplyProSoftConfigDao applyProSoftConfigDao) {
		this.applyProSoftConfigDao = applyProSoftConfigDao;
	}


	public List<ApplyProSoftConfig> findParameterCollection(ApplyProSoftConfig subject) {
		List<ApplyProSoftConfig> list = new ArrayList<ApplyProSoftConfig>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = applyProSoftConfigDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = applyProSoftConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}
/*
 * (non-Javadoc)
 * @see com.vprisk.mon.service.ApplyProSoftService#removeParameterCollectionByuuid(java.lang.String)
 */
	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			applyProSoftConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}
/*
 * (non-Javadoc)
 * @see com.vprisk.mon.service.ApplyProSoftService#saveOrUpdateCash(com.vprisk.mon.entity.ApplyProSoft)
 */
	public boolean saveOrUpdateCash(ApplyProSoftConfig pracol) {
		return applyProSoftConfigDao.saveOrUpdateCash(pracol);
	}
/*
 * (non-Javadoc)
 * @see com.vprisk.mon.service.ApplyProSoftService#selectParameterCollectiondByPage(java.util.Map, int, int, java.lang.String, java.lang.Boolean)
 */
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return applyProSoftConfigDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	
	public List<ApplyProSoftConfig> findApplyProSoftConfig() {
		return applyProSoftConfigDao.findApplyProSoftConfig();
	}
	
	@Override
	public void updateApplyProSoftConfigStatus(String localIp, String userName,int num, String courseStatus,String hostName) {
		applyProSoftConfigDao.updateApplyProSoftConfigStatus(localIp, userName,num, courseStatus,hostName);
		
	}
	
	
}
