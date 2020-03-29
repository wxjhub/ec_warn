package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionTimeConfig;
import com.vprisk.rmplatform.dao.support.Page;


/**
 * 交易时长DAO
 */

public interface TransactionTimeConfigDao {
	
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<TransactionTimeConfig> findParameterCollectionByUpdate(
			TransactionTimeConfig subject);

	List<TransactionTimeConfig> findParameterCollectionByAdd(
			TransactionTimeConfig subject);

	boolean saveOrUpdateCash(TransactionTimeConfig pracol);

	void removeParameterCollectionByuuid(String uuid);
	
	
	List<TransactionTimeConfig> selectTransactionTimeValue(String  transactionCode);

}
