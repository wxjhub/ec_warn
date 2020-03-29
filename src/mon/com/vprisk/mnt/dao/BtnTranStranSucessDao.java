package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.BtnSuccess;
import com.vprisk.rmplatform.dao.support.Page;

public interface BtnTranStranSucessDao {

	List<Map<String, String>> queryBtnSuccess(String minit, String resultdate);

	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	boolean saveOrUpdateCash(BtnSuccess btnsucc);

}
