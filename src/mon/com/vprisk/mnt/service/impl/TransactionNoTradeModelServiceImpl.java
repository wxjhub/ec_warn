package com.vprisk.mnt.service.impl;

import java.util.List;

import com.vprisk.mnt.dao.TransactionNoTradeModelDao;
import com.vprisk.mnt.entity.TransactionNoTradeModel;
import com.vprisk.mnt.service.TransactionNoTradeModelService;



public class TransactionNoTradeModelServiceImpl implements TransactionNoTradeModelService {
	private TransactionNoTradeModelDao transactionNoTradeModelDao;
	
	public TransactionNoTradeModelDao getTransactionNoTradeModelDao() {
		return transactionNoTradeModelDao;
	}

	public void setTransactionNoTradeModelDao(
			TransactionNoTradeModelDao transactionNoTradeModelDao) {
		this.transactionNoTradeModelDao = transactionNoTradeModelDao;
	}

	
	@Override
	public void insertModel(TransactionNoTradeModel model) {
		transactionNoTradeModelDao.insertModel(model);
	}

	@Override
	public List<TransactionNoTradeModel> selectSeqNo(String SeqNo) {
		// TODO Auto-generated method stub
		return transactionNoTradeModelDao.selectSeqNo(SeqNo);
	}

	
}
