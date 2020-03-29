package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.TransactionEndConfigDao;
import com.vprisk.mnt.entity.TransactionEndConfig;
import com.vprisk.mnt.service.TransactionEndConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class TransactionEndConfigServiceImpl implements TransactionEndConfigService {
	
	private TransactionEndConfigDao transactionEndConfigDao;
	public TransactionEndConfigDao getTransactionEndConfigDao() {
		return transactionEndConfigDao;
	}
	public void setTransactionEndConfigDao(
			TransactionEndConfigDao transactionEndConfigDao) {
		this.transactionEndConfigDao = transactionEndConfigDao;
	}
	

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return transactionEndConfigDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	public List<TransactionEndConfig> findParameterCollection(TransactionEndConfig subject) {
		List<TransactionEndConfig> list = new ArrayList<TransactionEndConfig>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = transactionEndConfigDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = transactionEndConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}
	
	public boolean saveOrUpdateCash(TransactionEndConfig pracol) {
		return transactionEndConfigDao.saveOrUpdateCash(pracol);
	}	
	
	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			transactionEndConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}
	
	
	public List<TransactionEndConfig> selectTransactionEndValue(String code) {
		List<TransactionEndConfig> list = new ArrayList<TransactionEndConfig>();
		list=  transactionEndConfigDao.selectTransactionEndValue(code);
		return list;
	}
}
