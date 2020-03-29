package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TableAnalysis;
import com.vprisk.rmplatform.dao.support.Page;
/**
 * 表分析service接口类
 */
public interface TableAnalysisService {

	@SuppressWarnings("unchecked")
	Page findList(Map params);
	
	//通过表名，查询该表的数据量
	int selectTableSize(String tableName);

	void insertModel(TableAnalysis tableAnalysis);
	
	List<TableAnalysis> findList();

	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
 
}
