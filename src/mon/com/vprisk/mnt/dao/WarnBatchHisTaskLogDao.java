package com.vprisk.mnt.dao;

import java.util.Map;

import com.vprisk.mnt.entity.WarnBatchHisTaskLog;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 跑批预警任务日志
 * @author lenovo
 *
 */
public interface WarnBatchHisTaskLogDao {
    /**
     * 分页查询数据
     * @param params
     * @param pageNo
     * @param pageSize
     * @param orderBy
     * @param isAsc
     * @return
     */
	Page selectWarnBatchTaskLogByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	/**
	 * 根据数据日期删除数据
	 * @param asOfDate
	 */
	 void deleteAllData(String asOfDate);
	 /**
	  *新增或修改龙数据
	  * @param log
	  * @return
	  */
	 WarnBatchHisTaskLog insertOrUpdateLog(WarnBatchHisTaskLog log);

}
