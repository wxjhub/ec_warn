package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionEndConfig;
import com.vprisk.rmplatform.dao.support.Page;

public interface TransactionEndConfigDao {

	/**
	 * 长时间无交易Dao层接口类
	 * 
	 */
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<TransactionEndConfig> findParameterCollectionByUpdate(
			TransactionEndConfig subject);

	List<TransactionEndConfig> findParameterCollectionByAdd(
			TransactionEndConfig subject);

	boolean saveOrUpdateCash(TransactionEndConfig pracol);

	void removeParameterCollectionByuuid(String uuid);

	//查询阀值
	List<TransactionEndConfig> selectTransactionEndValue(String code);
}
