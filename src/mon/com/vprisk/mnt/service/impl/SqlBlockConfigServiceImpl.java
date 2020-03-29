package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.SqlBlockConfigDao;
import com.vprisk.mnt.entity.SqlBlockConfig;
import com.vprisk.mnt.service.SqlBlockConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class SqlBlockConfigServiceImpl implements SqlBlockConfigService {

	private SqlBlockConfigDao sqlBlockConfigDao;

	public SqlBlockConfigDao getSqlBlockConfigDao() {
		return sqlBlockConfigDao;
	}

	public void setSqlBlockConfigDao(SqlBlockConfigDao sqlBlockConfigDao) {
		this.sqlBlockConfigDao = sqlBlockConfigDao;
	}

	
	public List<SqlBlockConfig> findParameterCollection(SqlBlockConfig subject) {
		List<SqlBlockConfig> list = new ArrayList<SqlBlockConfig>();
		if (StringUtil.isNotNullOrEmpty(subject.getUuid())) {
			list = sqlBlockConfigDao.findParameterCollectionByUpdate(subject);
		}
		if (StringUtil.isNullOrEmpty(subject.getUuid())) {
			list = sqlBlockConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;

	}

	public void removeParameterCollectionByuuid(String uuid) {
		String[] str = uuid.split(",");
		for (int i = 0; i < str.length; i++) {
			sqlBlockConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}

	public boolean saveOrUpdateCash(SqlBlockConfig pracol) {
		return sqlBlockConfigDao.saveOrUpdateCash(pracol);
	}

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return sqlBlockConfigDao.selectParameterCollectiondByPage(params,
				pageNo, pageSize, orderBy, isAsc);
	}

	public List<SqlBlockConfig> findSqlBlockConfig() {
		return sqlBlockConfigDao.findSqlBlockConfig();
	}
}
