package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionSuccessModel;


public interface TransactionSuccessModelDao {
	
	void insertModel(TransactionSuccessModel model);
	
	List<TransactionSuccessModel> statistics(Map params);
	
}
