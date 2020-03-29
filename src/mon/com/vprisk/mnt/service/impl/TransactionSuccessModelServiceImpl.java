package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.TransactionSuccessModelDao;
import com.vprisk.mnt.entity.TransactionSuccessModel;
import com.vprisk.mnt.service.TransactionSuccessModelService;


public class TransactionSuccessModelServiceImpl implements TransactionSuccessModelService {
	private TransactionSuccessModelDao transactionSuccessModelDao;
	
	public TransactionSuccessModelDao getTransactionSuccessModelDao() {
		return transactionSuccessModelDao;
	}

	public void setTransactionSuccessModelDao(
			TransactionSuccessModelDao transactionSuccessModelDao) {
		this.transactionSuccessModelDao = transactionSuccessModelDao;
	}

	
	@Override
	public void insertModel(TransactionSuccessModel model) {
		transactionSuccessModelDao.insertModel(model);
	}

	@Override
	public List<TransactionSuccessModel> statistics(Map params) {
		return transactionSuccessModelDao.statistics(params);
	}

	
}
