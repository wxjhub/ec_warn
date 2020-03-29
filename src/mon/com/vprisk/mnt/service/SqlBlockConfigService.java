package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.SqlBlockConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * sql service接口类
 */
public interface SqlBlockConfigService {
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(SqlBlockConfig pracol);

	List<SqlBlockConfig> findParameterCollection(SqlBlockConfig detail);

	void removeParameterCollectionByuuid(String uuid);

	//查询sql阻塞参数（无参数）
	List<SqlBlockConfig> findSqlBlockConfig();
	


}
