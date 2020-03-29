package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionEndConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 长时间无交易配置service接口类
 */
public interface TransactionEndConfigService {
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<TransactionEndConfig> findParameterCollection(TransactionEndConfig detail);

	boolean saveOrUpdateCash(TransactionEndConfig pracol);

	void removeParameterCollectionByuuid(String uuid);
	//通过系统查询相应阀值
	List<TransactionEndConfig> selectTransactionEndValue( String code);


}
