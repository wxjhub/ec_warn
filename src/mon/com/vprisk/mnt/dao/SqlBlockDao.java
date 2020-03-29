package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.SqlBlock;
/**
 * 应用程序Dao层实现接口类
 */
public interface SqlBlockDao {
	
	
	List<SqlBlock> findSqlBlock(Map params);

	void insertModel(SqlBlock sqlBlock);
	
	List<SqlBlock> findSqlBlock();
	
	
	
}
