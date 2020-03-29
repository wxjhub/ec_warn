package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.BtnSuccessConfig;
import com.vprisk.mnt.entity.ClientConfig;
import com.vprisk.rmplatform.dao.support.Page;

public interface BtnSucessConfigDao {

	List<BtnSuccessConfig> findBtnTime();

	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(BtnSuccessConfig detail);

	List<BtnSuccessConfig> findParameterCollectionByUpdate(
			BtnSuccessConfig detail);

	List<BtnSuccessConfig> findParameterCollectionByAdd(BtnSuccessConfig detail);

	void removeParameterCollectionByuuid(String uuid);


}
