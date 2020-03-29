package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.BookParamDao;
import com.vprisk.mnt.entity.BookParam;
import com.vprisk.mnt.service.BookParamService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class BookParamServiceImpl implements BookParamService {
	private BookParamDao bookParamDao;

	public BookParamDao getBookParamDao() {
		return bookParamDao;
	}
	public void setBookParamDao(BookParamDao bookParamDao) {
		this.bookParamDao = bookParamDao;
	}

	public List<BookParam> findParameterCollection(BookParam subject) {
		List<BookParam> list = new ArrayList<BookParam>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = bookParamDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = bookParamDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			bookParamDao.removeParameterCollectionByuuid(str[i]);
		}
	}


	public boolean saveOrUpdateCash(BookParam pracol) {
		return bookParamDao.saveOrUpdateCash(pracol);
	}


	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return bookParamDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}


	public List<BookParam> findBookParamByWarnLvl(int warningLevl) {
		return bookParamDao.selectBookParamByWarnLvl(warningLevl);
	}

	
	// 根据应用进程预警级别和预警分类，在这个时间段查询相关联的预警人员
	public List<BookParam> findBookParam(int warningLevl,String warnSort) {
		return bookParamDao.selectBookParam( warningLevl, warnSort);
	}
	
	//通过姓名查询通讯录信息
	public List<BookParam> findBookParamByNote(String note) {
		return bookParamDao.findBookParamByNote(note);
	}
}
