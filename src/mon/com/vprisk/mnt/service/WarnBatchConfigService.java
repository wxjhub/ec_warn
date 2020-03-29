package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.WarnBatchConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 跑批配置service
 * @author lenovo
 *
 */
public interface WarnBatchConfigService {
    /**
     * 分页查询跑批配置
     * @param params
     * @param pageNo
     * @param pageSize
     * @param orderBy
     * @param isAsc
     * @return
     */
	Page queryWarnBatchByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
    /**
     * 保存跑批配置
     * @param detail
     * @return
     */
	boolean saveOrUpdateWarnBatchConfig(WarnBatchConfig detail);
	/**
	 * 删除跑批配置
	 * @param uuid
	 */
	void removeByUuid(String uuid);
	/**
	 * 根据id查询数据
	 * @param uuid
	 * @return
	 */
	WarnBatchConfig queryById(String uuid);
	/**
	 * 根据sql查询数据 批次
	 * @return
	 */
	List<Map<String,String>> queryBatchList();
	/**
	 * 根据sql查询数据 任务组
	 * @return
	 */
	List<Map<String,String>> queryTaskSetList(String batchId);
	/**
	 * 根据sql查询数据 任务
	 * @return
	 */
	List<Map<String,String>> queryTaskList(String taskSetId);
	/**
	 * 分页查询任务数据
	 * @param params
	 * @param pageNo
	 * @param pageSize
	 * @param orderBy
	 * @param isAsc
	 * @return
	 */
	Page queryTaskByPage(Map params, int pageNo, int pageSize, String orderBy,
			Boolean isAsc);
	
	/**
	 * 根据taskId查询taskName
	 * @param taskId
	 * @return
	 */
	String queryTaskNameByTaskId(String taskId);

}
