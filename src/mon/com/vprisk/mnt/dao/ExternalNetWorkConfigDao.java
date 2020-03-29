package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ExternalNetWorkConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 网络监控参数Dao层实现接口类
 */

public interface ExternalNetWorkConfigDao {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(ExternalNetWorkConfig pracol);

	List<ExternalNetWorkConfig> findParameterCollectionByAdd(
			ExternalNetWorkConfig subject);

	List<ExternalNetWorkConfig> findParameterCollectionByUpdate(
			ExternalNetWorkConfig subject);

	void removeParameterCollectionByuuid(String uuid);

	
	//更新状态
	void updateExternalnetWorkByUuid(String status,String uuid);
	
	 List<ExternalNetWorkConfig> findNetWork();
}
