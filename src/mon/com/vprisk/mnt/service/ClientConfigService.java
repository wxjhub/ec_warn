package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ClientConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 系统基本配置service接口类
 */

public interface ClientConfigService {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<ClientConfig> findParameterCollection(ClientConfig detail);

	boolean saveOrUpdateCash(ClientConfig pracol);

	void removeParameterCollectionByuuid(String uuid);

}
