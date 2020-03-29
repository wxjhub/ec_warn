package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionTimeConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 交易时长配置service接口类
 */
public interface TransactionTimeConfigService {
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<TransactionTimeConfig> findParameterCollection(TransactionTimeConfig detail);

	boolean saveOrUpdateCash(TransactionTimeConfig pracol);

	void removeParameterCollectionByuuid(String uuid);
	
	//通过交易码  查询标准时长和预警告警笔数阀值
	List<TransactionTimeConfig> selectTransactionTimeValue(String transactionCode);

}
