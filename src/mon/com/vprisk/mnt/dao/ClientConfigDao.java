package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ClientConfig;
import com.vprisk.rmplatform.dao.support.Page;

public interface ClientConfigDao {

	/**
	 * 系统基本配置Dao层实现接口类
	 * 
	 */
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<ClientConfig> findParameterCollectionByAdd(ClientConfig subject);

	List<ClientConfig> findParameterCollectionByUpdate(ClientConfig subject);

	boolean saveOrUpdateCash(ClientConfig pracol);

	void removeParameterCollectionByuuid(String uuid);

}
