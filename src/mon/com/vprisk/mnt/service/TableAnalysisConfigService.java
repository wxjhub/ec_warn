package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TableAnalysisConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 表分析配置service接口类
 */
public interface TableAnalysisConfigService {
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(TableAnalysisConfig pracol);

	List<TableAnalysisConfig> findParameterCollection(TableAnalysisConfig detail);

	void removeParameterCollectionByuuid(String uuid);
	
	List<TableAnalysisConfig> findTableAnalysisConfig();

}
