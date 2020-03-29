package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 报警历史service接口类
 * 
 */
public interface WarnHistoryService {
	
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);


	boolean saveOrUpdateCash(WarnHistory pracol);


	void handleStateById(String id);


	public void insertIntoWarnHistory(WarnHistory warnhistory);

	// 历史报警结果查询
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage2(Map params, int pageNo,int pageSize, String orderBy, Boolean isAsc);

	// 更新数据恢复时间，和状态
	public void updateWarnHistory(String id);

	List<WarnHistory> handleStateByCourseCode(String recordName,String pointName, String pointIp, String warnSort);
	
	
	public void updateConfirmation(Map params, String userName, String userOrganId);

}
