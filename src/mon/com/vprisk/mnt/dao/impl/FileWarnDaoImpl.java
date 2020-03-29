package com.vprisk.mnt.dao.impl;

import com.vprisk.mnt.dao.FileWarnDao;
import com.vprisk.mnt.entity.FileWarn;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;

/**
 * 文件Dao层实现类
 * 
 */
public class FileWarnDaoImpl extends BaseDao<FileWarn> implements FileWarnDao {

	

	@Override
	public void insertModel(FileWarn fileWarn) {
		super.insertOrUpdate(fileWarn);
		
	}
}
