package com.vprisk.mnt.dao;

import java.util.List;

import com.vprisk.mnt.entity.TransactionTimeModel;


public interface TransactionTimeModelDao {
	
	void insertModel(TransactionTimeModel model);

	List<TransactionTimeModel> selectSeqNo(String seqNo);
	
}
