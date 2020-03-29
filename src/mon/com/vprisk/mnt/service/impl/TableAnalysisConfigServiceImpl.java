package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.TableAnalysisConfigDao;
import com.vprisk.mnt.entity.TableAnalysisConfig;
import com.vprisk.mnt.service.TableAnalysisConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class TableAnalysisConfigServiceImpl implements TableAnalysisConfigService {

	private TableAnalysisConfigDao tableAnalysisConfigDao;

	public TableAnalysisConfigDao getTableAnalysisConfigDao() {
		return tableAnalysisConfigDao;
	}

	public void setTableAnalysisConfigDao(
			TableAnalysisConfigDao tableAnalysisConfigDao) {
		this.tableAnalysisConfigDao = tableAnalysisConfigDao;
	}

	public List<TableAnalysisConfig> findParameterCollection(TableAnalysisConfig subject) {
		List<TableAnalysisConfig> list = new ArrayList<TableAnalysisConfig>();
		if (StringUtil.isNotNullOrEmpty(subject.getUuid())) {
			list = tableAnalysisConfigDao.findParameterCollectionByUpdate(subject);
		}
		if (StringUtil.isNullOrEmpty(subject.getUuid())) {
			list = tableAnalysisConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;

	}

	public void removeParameterCollectionByuuid(String uuid) {
		String[] str = uuid.split(",");
		for (int i = 0; i < str.length; i++) {
			tableAnalysisConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}

	public boolean saveOrUpdateCash(TableAnalysisConfig pracol) {
		return tableAnalysisConfigDao.saveOrUpdateCash(pracol);
	}

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return tableAnalysisConfigDao.selectParameterCollectiondByPage(params,
				pageNo, pageSize, orderBy, isAsc);
	}
	
	public List<TableAnalysisConfig> findTableAnalysisConfig() {
		return tableAnalysisConfigDao.findTableAnalysisConfig();
	}
	

}
