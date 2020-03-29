package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.SqlBlock;

/**
 * sql阻塞service接口类
 */
public interface SqlBlockService {
	
	
	//sql阻塞查询方法
	List<SqlBlock> findSqlBlock(Map params);

	void insertModel(SqlBlock sqlBlock);
	
	List<SqlBlock> findSqlBlock();


	
}
