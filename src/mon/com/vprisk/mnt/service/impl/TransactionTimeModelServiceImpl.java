package com.vprisk.mnt.service.impl;

import java.util.List;

import com.vprisk.mnt.dao.TransactionTimeModelDao;
import com.vprisk.mnt.entity.TransactionTimeModel;
import com.vprisk.mnt.service.TransactionTimeModelService;


public class TransactionTimeModelServiceImpl implements TransactionTimeModelService {
	private TransactionTimeModelDao transactionTimeModelDao;
	
	public TransactionTimeModelDao getTransactionTimeModelDao() {
		return transactionTimeModelDao;
	}

	public void setTransactionTimeModelDao(
			TransactionTimeModelDao transactionTimeModelDao) {
		this.transactionTimeModelDao = transactionTimeModelDao;
	}

	
	@Override
	public void insertModel(TransactionTimeModel model) {
		transactionTimeModelDao.insertModel(model);
	}

	@Override
	public List<TransactionTimeModel> selectSeqNo(String SeqNo) {
		// TODO Auto-generated method stub
		return transactionTimeModelDao.selectSeqNo(SeqNo);
	}

	
}
