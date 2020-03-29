package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.SqlBlockDao;
import com.vprisk.mnt.entity.SqlBlock;
import com.vprisk.mnt.service.SqlBlockService;


public class SqlBlockServiceImpl implements SqlBlockService {
	private SqlBlockDao SqlBlockDao;
	
	public SqlBlockDao getSqlBlockDao() {
		return SqlBlockDao;
	}
	public void setSqlBlockDao(SqlBlockDao SqlBlockDao) {
		this.SqlBlockDao = SqlBlockDao;
	}
	
	
	public List<SqlBlock> findSqlBlock(Map params) {
		return SqlBlockDao.findSqlBlock( params);
	}
	
	public void insertModel(SqlBlock sqlBlock) {
		SqlBlockDao.insertModel(sqlBlock);

		
	}

	public List<SqlBlock> findSqlBlock() {
		return SqlBlockDao.findSqlBlock( );
	}
	
	
}
