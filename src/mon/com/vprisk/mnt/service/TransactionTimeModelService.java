package com.vprisk.mnt.service;

import java.util.List;

import com.vprisk.mnt.entity.TransactionTimeModel;


public interface TransactionTimeModelService {

	public void insertModel( TransactionTimeModel model);
	
	List<TransactionTimeModel> selectSeqNo( String SeqNo);

	
}
