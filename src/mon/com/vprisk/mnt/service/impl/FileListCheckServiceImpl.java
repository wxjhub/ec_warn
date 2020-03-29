package com.vprisk.mnt.service.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.FileListCheckDao;
import com.vprisk.mnt.entity.FileListCheck;
import com.vprisk.mnt.service.FileListCheckService;
import com.vprisk.rmplatform.dao.support.Page;


public class FileListCheckServiceImpl implements FileListCheckService {
	private FileListCheckDao fileListCheckDao;
	public FileListCheckDao getFileListCheckDao() {
		return fileListCheckDao;
	}
	public void setFileListCheckDao(FileListCheckDao fileListCheckDao) {
		this.fileListCheckDao = fileListCheckDao;
	}


	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return fileListCheckDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}


	public List<FileListCheck> findFileListCheck() {
		return fileListCheckDao.selectFileListCheck();
	}


	public boolean updateFileListCheckByListNum(String string, int num, Date asOfDate) {
		return fileListCheckDao.updateFileListCheckByListNum(string,num,asOfDate);
	}


	public void updateFileListCheckByListSendNum(String soursesysName, int num,int factNum) {
		fileListCheckDao.updateFileListCheckByListSendNum(soursesysName,num,factNum);
	}
	
	public void updateFileListCheckByListSendNum2(String soursesysName, int num,int factNum, Date asOfDate) {
		fileListCheckDao.updateFileListCheckByListSendNum2(soursesysName,num,factNum,asOfDate);
	}
	public int selectListNum(String soursesysName){
		return fileListCheckDao.selectListNum(soursesysName);
	}
	public int  selectListNumSend(String soursesysName){
		return fileListCheckDao.selectListNumSend(soursesysName);
	}
	
	public int  selectListSendNum(String soursesysName){
		return fileListCheckDao.selectListSendNum(soursesysName);
	}
	public int  selectFactFileRecNum(String soursesysName){
		return fileListCheckDao.selectFactFileRecNum(soursesysName);
	}
}
