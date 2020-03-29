package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.BtnSuccess;
import com.vprisk.rmplatform.dao.support.Page;

public interface BtnTranStranSucessService {
	/**
	 * 查询rpm按钮信息
	 * @param resultdate 
	 * @param minit 
	 * @return
	 */
	List<Map<String,String>> queryBtnSuccess(String minit, String resultdate);

	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	
	boolean saveOrUpdateCash(BtnSuccess btnsucc);
}
