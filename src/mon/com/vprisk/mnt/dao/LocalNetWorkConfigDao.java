package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.LocalNetWorkConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 网络监控参数Dao层实现接口类
 */

public interface LocalNetWorkConfigDao {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(LocalNetWorkConfig pracol);

	List<LocalNetWorkConfig> findParameterCollectionByAdd(
			LocalNetWorkConfig subject);

	List<LocalNetWorkConfig> findParameterCollectionByUpdate(
			LocalNetWorkConfig subject);

	void removeParameterCollectionByuuid(String uuid);
	
	//更新状态
		void updatelocalNetWorkByUuid(String status,String uuid);
		
		public List<LocalNetWorkConfig> findNetWork();

}
