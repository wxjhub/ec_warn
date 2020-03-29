package com.vprisk.mnt.dao;

import java.util.List;

import com.vprisk.mnt.entity.TransactionNoTradeModel;


public interface TransactionNoTradeModelDao {
	
	void insertModel(TransactionNoTradeModel model);

	List<TransactionNoTradeModel> selectSeqNo(String seqNo);
	
}
