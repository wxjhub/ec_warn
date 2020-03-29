package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.BtnSuccessConfig;
import com.vprisk.mnt.entity.ClientConfig;
import com.vprisk.rmplatform.dao.support.Page;

public interface BtnSucessConfigService {

	List<BtnSuccessConfig> findBtnTime();

	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	List<BtnSuccessConfig> findParameterCollection(BtnSuccessConfig detail);

	boolean saveOrUpdateCash(BtnSuccessConfig detail);

	void removeParameterCollectionByuuid(String uuid);


}
