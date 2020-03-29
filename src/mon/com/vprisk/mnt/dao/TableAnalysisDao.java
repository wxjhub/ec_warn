package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TableAnalysis;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 表分析Dao层接口类
 * 
 */
public interface TableAnalysisDao {
	
	List<TableAnalysis> findList();

	//通过表名，查询该表的数据量
	int selectTableSize(String tableName);
	
	void insertModel(TableAnalysis tableAnalysis);
	
	Page findList(Map params);

	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

}
