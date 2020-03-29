package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ApplyProSoftConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 应用程序Dao层实现接口类
 * 
 */
public interface ApplyProSoftConfigDao {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(ApplyProSoftConfig pracol);

	List<ApplyProSoftConfig> findParameterCollectionByAdd(
			ApplyProSoftConfig subject);

	List<ApplyProSoftConfig> findParameterCollectionByUpdate(
			ApplyProSoftConfig subject);

	void removeParameterCollectionByuuid(String uuid);

	List<ApplyProSoftConfig> findApplyProSoftConfig();

	void updateApplyProSoftConfigStatus(String localIp, String userName,
			int num, String courseStatus,String hostName);

}
