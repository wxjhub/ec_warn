package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ApplyProSoftConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 应用程序service接口类
 */

public interface ApplyProSoftConfigService {
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(ApplyProSoftConfig pracol);

	List<ApplyProSoftConfig> findParameterCollection(ApplyProSoftConfig detail);

	void removeParameterCollectionByuuid(String uuid);
	
	List<ApplyProSoftConfig> findApplyProSoftConfig();

	void updateApplyProSoftConfigStatus(String localIp,String userName,int num,String courseStatus,String hostName);


}
