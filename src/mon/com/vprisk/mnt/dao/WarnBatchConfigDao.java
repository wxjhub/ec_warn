package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.WarnBatchConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 跑批配置
 * @author lenovo
 *
 */
public interface WarnBatchConfigDao {
	 /**
     * 分页查询数据
     * @param params
     * @param pageNo
     * @param pageSize
     * @param orderBy
     * @param isAsc
     * @return
     */
	Page selectWarnBatchByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	 /**
	  * 保存修改的方法
	  * @param warnModule
	  * @return
	  */
	 boolean saveOrUpdate(WarnBatchConfig warnModule);
	 /**
	  * 删除数据 
	  * @param uuid
	  */
	 void deleteByUuid(String uuid);
	/** 根据id查询数据
	 * @param uuid
	 */
	 WarnBatchConfig selectEntityById(String uuid);
	 /**
	  * 根据sql查询数据
	  * @return
	  */
    List selectBatchList();
    /**
     * 查询任务组
     * @return
     */
	List selectTaskSetList(String batchId);
	/**
	 * 查询任务
	 * @param taskSetId
	 * @return
	 */
	List selectTaskList(String taskSetId);
	/**
	 * 查询某个配置关联的批次 任务组 任务
	 * @param batchId taskSetId taskId
	 * @return
	 */
	 List selectBatchInfo(String batchId,String taskSetId,String taskId);
	 /**
	  * 查询所有批次数据
	 * @param warnNum  预警次数 01 单次 02 循环
	 * @param  warnContent  预警内容 01 时点 02 时长
	  * @return
	  */
	 List<WarnBatchConfig> queryAllBatchIdConfig(Map param);
	 /**
	  * 查询所有任务组数据
	   * @param warnNum  预警次数 01 单次 02 循环
	 * @param  warnContent  预警内容 01 时点 02 时长
	  * @return
	  */
	 List<WarnBatchConfig> queryAllTaskSetIdConfig(Map param);
	 /**
	  * 查询所有任务数据
	  * @param warnNum  预警次数 01 单次 02 循环
	  * @param  warnContent  预警内容 01 时点 02 时长
	  * @return
	  */
	 List<WarnBatchConfig> queryAllTaskIdConfig(Map param);
	 /**
	  * 分页查询任务数据
	  * @param params
	  * @param pageNo
	  * @param pageSize
	  * @param orderBy
	  * @param isAsc
	  * @return
	  */
	 Page selectTaskByPage(Map params, int pageNo, int pageSize, String orderBy,
			Boolean isAsc);
	 /**
	  * 查询任务
	  * @param taskSetId
	  * @return
	  */
	 List selectTaskNameById(String taskId);
}
