package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.DayEndConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 日终实现接口类
 * 
 */
public interface DayEndConfigDao {
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(DayEndConfig pracol);

	List<DayEndConfig> findParameterCollectionByAdd(DayEndConfig subject);

	List<DayEndConfig> findParameterCollectionByUpdate(DayEndConfig subject);

	void removeParameterCollectionByuuid(String uuid);

	List<DayEndConfig> findAll();

}
