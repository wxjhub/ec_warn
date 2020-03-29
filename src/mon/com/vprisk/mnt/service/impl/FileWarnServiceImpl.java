package com.vprisk.mnt.service.impl;

import com.vprisk.mnt.dao.FileWarnDao;
import com.vprisk.mnt.entity.FileWarn;
import com.vprisk.mnt.service.FileWarnService;

public class FileWarnServiceImpl implements FileWarnService {
	private FileWarnDao fileWarnDao;

	public FileWarnDao getfileWarnDao() {
		return fileWarnDao;
	}

	public void setfileWarnDao(FileWarnDao fileWarnDao) {
		this.fileWarnDao = fileWarnDao;
	}

	
	@Override
	public void insertModel(FileWarn fileWarn) {
		fileWarnDao.insertModel(fileWarn);

		
	}

}
