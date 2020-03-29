package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.WarnBatchHisTaskLog;


/**
 *跑批监控dao
 * @author lenovo
 *
 */
public interface WarnBatchDao {
	/**
	 * 根据数据日期查询任务级别的ETL跑批数据
	 * @param asOfDate
	 * @return
	 */
     List<WarnBatchHisTaskLog> queryWarnBatchHisTaskLogFromEtl(String asOfDate);
    /**
     * 根据数据日期查询任务级别的ETL跑批数据
     * @param asOfDate
     * @return
     */
     List<Map<String,String>> queryWrongRunFlagDataFromEtl(String noQueryId);
    /**
     * 查询晚于时点的预警数据
     * @return
     */
    Map<String,List<Map<String,String>>> queryLaterDataFromEtl(String batchId,String taskSetId,String taskId,String asOfDate);
    /**
     * 查询晚于时长的预警数据
     * @return
     */
    Map<String,List<Map<String,String>>> queryMorethanDataFromEtl(String batchId,String taskSetId,String taskId);
	List<Map<String, String>> queryTask(String asOfDate,String taskId);
}
