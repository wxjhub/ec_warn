package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.FileConfigDao;
import com.vprisk.mnt.entity.FileConfig;
import com.vprisk.mnt.service.FileConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class FileConfigServiceImpl implements FileConfigService {

	private FileConfigDao fileConfigDao;

	public FileConfigDao getFileConfigDao() {
		return fileConfigDao;
	}

	public void setFileConfigDao(FileConfigDao fileConfigDao) {
		this.fileConfigDao = fileConfigDao;
	}

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return this.fileConfigDao.selectParameterCollectiondByPage(params,
				pageNo, pageSize, orderBy, isAsc);
	}

	public void removeParameterCollectionByuuid(String uuid) {
		String[] str = uuid.split(",");
		for (int i = 0; i < str.length; i++) {
			fileConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}

	public List<FileConfig> findParameterCollection(FileConfig subject) {
		List<FileConfig> list = new ArrayList<FileConfig>();
		if (StringUtil.isNotNullOrEmpty(subject.getUuid())) {
			list = fileConfigDao.findParameterCollectionByUpdate(subject);
		}
		if (StringUtil.isNullOrEmpty(subject.getUuid())) {
			list = fileConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;

	}

	public boolean saveOrUpdateCash(FileConfig pracol) {
		return this.fileConfigDao.saveOrUpdateCash(pracol);
	}

	@Override
	public List<FileConfig> findFile(String fileName) {
		// TODO Auto-generated method stub
		return this.fileConfigDao.findFile(fileName);
	}


	/*
	 * public List<FileConfig> findFileTranWarn() { return
	 * fileConfigDao.selectFileTranWarn(); }
	 * 
	 * public int findFileTranWarnByCheck(FileConfig fileTranWarn) {
	 * List<FileConfig> list =
	 * fileConfigDao.selectFileTranWarnByCheck(fileTranWarn); return
	 * list.size(); } public int findWarnLevel(String sysName) { return
	 * fileConfigDao.findWarnLevel(sysName);
	 * 
	 * }
	 */
	
	
	public List<FileConfig> findAll() {
		// TODO Auto-generated method stub
		return this.fileConfigDao.findAll();
	}

	@Override
	public void updateState(int state,String id) {
		// TODO Auto-generated method stub
		this.fileConfigDao.updateState(state,id);
	}

}
