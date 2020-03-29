package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.TransactionTimeConfigDao;
import com.vprisk.mnt.entity.TransactionTimeConfig;
import com.vprisk.mnt.service.TransactionTimeConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class TransactionTimeConfigServiceImpl implements TransactionTimeConfigService {
	
	private TransactionTimeConfigDao transactionTimeConfigDao;
	public TransactionTimeConfigDao getTransactionTimeConfigDao() {
		return transactionTimeConfigDao;
	}
	public void setTransactionTimeConfigDao(
			TransactionTimeConfigDao transactionTimeConfigDao) {
		this.transactionTimeConfigDao = transactionTimeConfigDao;
	}
	

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return transactionTimeConfigDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	public List<TransactionTimeConfig> findParameterCollection(TransactionTimeConfig subject) {
		List<TransactionTimeConfig> list = new ArrayList<TransactionTimeConfig>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = transactionTimeConfigDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = transactionTimeConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}
	
	public boolean saveOrUpdateCash(TransactionTimeConfig pracol) {
		return transactionTimeConfigDao.saveOrUpdateCash(pracol);
	}	
	
	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			transactionTimeConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}
	
	
	@Override
	public List<TransactionTimeConfig> selectTransactionTimeValue(String transactionCode) {
		List<TransactionTimeConfig> list = new ArrayList<TransactionTimeConfig>();
		list=  transactionTimeConfigDao.selectTransactionTimeValue(transactionCode);
		return list;
	}

}
