package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionSuccessConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 交易成功率配置service接口类
 */
public interface TransactionSuccessConfigService {
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<TransactionSuccessConfig> findParameterCollection(
			TransactionSuccessConfig detail);

	boolean saveOrUpdateCash(TransactionSuccessConfig pracol);

	void removeParameterCollectionByuuid(String uuid);
	
	//通过 交易名称和 响应码 查询 交易成功率值
	List<TransactionSuccessConfig> selectTransactionSuccessValue( String transactionName ,String code);

}
