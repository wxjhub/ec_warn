package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.TableAnalysisDao;
import com.vprisk.mnt.entity.TableAnalysis;
import com.vprisk.mnt.service.TableAnalysisService;
import com.vprisk.rmplatform.dao.support.Page;


public class TableAnalysisServiceImpl implements TableAnalysisService {
	
	private TableAnalysisDao tableAnalysisDao;
	public TableAnalysisDao getTableAnalysisDao() {
		return tableAnalysisDao;
	}

	public void setTableAnalysisDao(TableAnalysisDao tableAnalysisDao) {
		this.tableAnalysisDao = tableAnalysisDao;
	}


	public Page findList(Map params) {
		return this.tableAnalysisDao.findList(params);
	}
	
	public int selectTableSize(String tableName) {
		return this.tableAnalysisDao.selectTableSize(tableName);
	}

	@Override
	public void insertModel(TableAnalysis tableAnalysis) {
		
		tableAnalysisDao.insertModel(tableAnalysis);

	}
	
	public List<TableAnalysis> findList() {
		return this.tableAnalysisDao.findList();
	}

	@Override
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return this.tableAnalysisDao.selectParameterCollectiondByPage(params,pageNo,pageSize,orderBy,isAsc);
	}
}
