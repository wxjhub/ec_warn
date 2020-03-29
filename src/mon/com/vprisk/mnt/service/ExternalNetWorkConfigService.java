package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ExternalNetWorkConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 网络监控维护service接口类
 */

public interface ExternalNetWorkConfigService {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(ExternalNetWorkConfig pracol);

	List<ExternalNetWorkConfig> findParameterCollection(ExternalNetWorkConfig detail);

	void removeParameterCollectionByuuid(String uuid);

	//更新状态
	void updateExternalnetWorkByUuid(String status,String uuid);
	
	 List<ExternalNetWorkConfig> findNetWork();
}
