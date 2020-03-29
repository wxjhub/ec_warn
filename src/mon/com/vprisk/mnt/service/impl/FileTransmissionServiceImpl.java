package com.vprisk.mnt.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.FileTransmissionDao;
import com.vprisk.mnt.entity.FileTransmission;
import com.vprisk.mnt.service.FileTransmissionService;
import com.vprisk.rmplatform.dao.support.Page;

public class FileTransmissionServiceImpl implements FileTransmissionService {
    private FileTransmissionDao fileTransmissionDao;
	public FileTransmissionDao getFileTransmissionDao() {
		return fileTransmissionDao;
	}
	public void setFileTransmissionDao(FileTransmissionDao fileTransmissionDao) {
		this.fileTransmissionDao = fileTransmissionDao;
	}
	
	
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		// TODO Auto-generated method stub
		return fileTransmissionDao.selectParameterCollectiondByPage(params, pageNo, pageSize, orderBy, isAsc);
	}
	
	public List<FileTransmission> findFileTransmission() {
		// TODO Auto-generated method stub
		return fileTransmissionDao.findFileTransmission();
	}
	
	public List<FileTransmission> findFileTransmission(String tranType) {
		// TODO Auto-generated method stub
		return fileTransmissionDao.findFileTransmission( tranType);
	}

	public int findFileNumBySendSystem(String sysName, Date datedata) {
		return fileTransmissionDao.findFileNumBySendSystem(sysName,datedata);
	}
	public int findFileNumByGetSystem(String sysName, Date datedata) {
		return fileTransmissionDao.findFileNumByGetSystem(sysName,datedata);
	}
	
	public String findZt(String FileName,Date DataDate){
		return fileTransmissionDao.findZt(FileName,DataDate);
	}

}
