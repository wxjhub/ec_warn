package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TableAnalysisConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 表分析Dao层实现接口类
 * 
 */
public interface TableAnalysisConfigDao {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(TableAnalysisConfig pracol);

	List<TableAnalysisConfig> findParameterCollectionByAdd(
			TableAnalysisConfig subject);

	List<TableAnalysisConfig> findParameterCollectionByUpdate(
			TableAnalysisConfig subject);

	void removeParameterCollectionByuuid(String uuid);
	
	List<TableAnalysisConfig> findTableAnalysisConfig();
	

}
