package com.vprisk.mnt.service.impl;

import java.util.Map;

import com.vprisk.rmplatform.dao.support.Page;

/**
 * 跑批预警任务日志
 *  * @author lenovo
 *
 */
public interface WarnBatchHisTaskLogService {
    /**
     * 分页查询数据
     * @param params
     * @param pageNo
     * @param pageSize
     * @param orderBy
     * @param isAsc
     * @return
     */
	Page queryWarnBatchHisLogByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

}
