package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.SqlBlockConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 应用程序Dao层实现接口类
 * 
 */
public interface SqlBlockConfigDao {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(SqlBlockConfig pracol);

	List<SqlBlockConfig> findParameterCollectionByAdd(
			SqlBlockConfig subject);

	List<SqlBlockConfig> findParameterCollectionByUpdate(
			SqlBlockConfig subject);

	void removeParameterCollectionByuuid(String uuid);
	
	List<SqlBlockConfig> findSqlBlockConfig();

}
