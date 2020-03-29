package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionSuccessModel;


public interface TransactionSuccessModelService {

	public void insertModel( TransactionSuccessModel model);
	
	//统计
	List<TransactionSuccessModel> statistics(Map params );
	
}
