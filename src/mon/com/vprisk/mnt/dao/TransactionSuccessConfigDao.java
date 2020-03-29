package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionSuccessConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 交易成功率dao
 */

public interface TransactionSuccessConfigDao {
	
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<TransactionSuccessConfig> findParameterCollectionByUpdate(
			TransactionSuccessConfig subject);

	List<TransactionSuccessConfig> findParameterCollectionByAdd(
			TransactionSuccessConfig subject);

	boolean saveOrUpdateCash(TransactionSuccessConfig pracol);

	void removeParameterCollectionByuuid(String uuid);
	
	//通过响应码和交易名称查询阀值
	List<TransactionSuccessConfig> selectTransactionSuccessValue(String transactionName,String code);


}
