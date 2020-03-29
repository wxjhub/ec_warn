package com.vprisk.mnt.service;

import java.util.List;

import com.vprisk.mnt.entity.TransactionNoTradeModel;


public interface TransactionNoTradeModelService {

	public void insertModel( TransactionNoTradeModel model);
	
	List<TransactionNoTradeModel> selectSeqNo( String SeqNo);

	
}
