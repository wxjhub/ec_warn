package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.DayEndConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 日终service接口类
 * 
 */
public interface DayEndConfigService {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(DayEndConfig pracol);

	List<DayEndConfig> findParameterCollection(DayEndConfig detail);

	void removeParameterCollectionByuuid(String uuid);

	List<DayEndConfig> findAll();

}
