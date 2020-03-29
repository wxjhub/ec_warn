package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.TransactionSuccessConfigDao;
import com.vprisk.mnt.entity.TransactionSuccessConfig;
import com.vprisk.mnt.service.TransactionSuccessConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class TransactionSuccessConfigServiceImpl implements TransactionSuccessConfigService {
	
	private TransactionSuccessConfigDao transactionSuccessConfigDao;
	public TransactionSuccessConfigDao getTransactionSuccessConfigDao() {
		return transactionSuccessConfigDao;
	}
	public void setTransactionSuccessConfigDao(
			TransactionSuccessConfigDao transactionSuccessConfigDao) {
		this.transactionSuccessConfigDao = transactionSuccessConfigDao;
	}
	

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return transactionSuccessConfigDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	public List<TransactionSuccessConfig> findParameterCollection(TransactionSuccessConfig subject) {
		List<TransactionSuccessConfig> list = new ArrayList<TransactionSuccessConfig>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = transactionSuccessConfigDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = transactionSuccessConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}
	
	public boolean saveOrUpdateCash(TransactionSuccessConfig pracol) {
		return transactionSuccessConfigDao.saveOrUpdateCash(pracol);
	}	
	
	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			transactionSuccessConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}
	
	
	@Override
	public List<TransactionSuccessConfig> selectTransactionSuccessValue(String transactionName,String code) {
		List<TransactionSuccessConfig> list = new ArrayList<TransactionSuccessConfig>();
		list=  transactionSuccessConfigDao.selectTransactionSuccessValue(transactionName,code);
		return list;
	}

}
