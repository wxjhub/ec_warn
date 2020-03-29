package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.LocalNetWorkConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 网络监控维护service接口类
 */

public interface LocalNetWorkConfigService {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(LocalNetWorkConfig pracol);

	List<LocalNetWorkConfig> findParameterCollection(LocalNetWorkConfig detail);

	void removeParameterCollectionByuuid(String uuid);
	
	//更新状态
	void updatelocalNetWorkByUuid(String status,String uuid);
		
	public List<LocalNetWorkConfig> findNetWork();

	
}
