package com.vprisk.mnt.dao.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.dao.WarnBatchDao;
import com.vprisk.mnt.entity.WarnBatchHisTaskLog;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnBatchDaoImpl extends BaseDao<WarnBatchHisTaskLog> implements WarnBatchDao {
	private static Log log = LogFactory.getLog(WarnBatchDaoImpl.class);
	/**
	 * 根据数据日期查询任务级别的ETL跑批数据
	 * @param asOfDate
	 * @return
	 */
    public List<WarnBatchHisTaskLog> queryWarnBatchHisTaskLogFromEtl(String asOfDate){
    	List<WarnBatchHisTaskLog> rData = new ArrayList<WarnBatchHisTaskLog>();
    	StringBuilder sql = new StringBuilder();
    	sql.append("SELECT UUID,  BATCH_ID  , PROCESS_ID ,   TASK_ID   , RUN_FLAG   , RUN_TIME  ,   STD_TIME  , END_TIME  , AS_OF_DATE   ,");
    	sql.append(" CREATE_DATE  , ERROR_MESSAGE , SUMCOUNT,  COUNT    ,  JOB_ID  ,TASK_RUNID   ");
//    	sql.append(" FROM ETL_HIS_TASKDETAILINFO where as_of_date = '"+asOfDate+" 00:00:00'");
        sql.append(" FROM ETL_HIS_TASKDETAILINFO where to_char(as_of_date,'yyyy-MM-dd') = '"+asOfDate+"'");
    	Connection conn = CommonUtils.getConnection("etl.jdbc","Oracle");
    	Statement stmt = null;
    	ResultSet data  = null;
		try {
			stmt = conn.createStatement();
			data  = stmt.executeQuery(sql.toString());
			while(data.next()){
				WarnBatchHisTaskLog log = new WarnBatchHisTaskLog();
				log.setAsOfDate(data.getTimestamp("AS_OF_DATE"));
				log.setBatchId(data.getString("BATCH_ID"));
				log.setCount(data.getDouble("COUNT"));
				log.setCreateDate(data.getTimestamp("CREATE_DATE"));
				log.setEndTime(data.getTimestamp("END_TIME"));
				log.setErrorMessage(data.getString("ERROR_MESSAGE"));
				log.setJobId(data.getString("JOB_ID"));
				log.setProcessId(data.getString("PROCESS_ID"));
				log.setRunFlag(data.getString("RUN_FLAG"));
				log.setRunTime(data.getString("RUN_TIME"));
				log.setStdTime(data.getTimestamp("STD_TIME"));
				log.setSumcount(data.getDouble("SUMCOUNT"));
				log.setTaskId(data.getString("TASK_ID"));
				log.setTaskRunid(data.getString("TASK_RUNID"));
				rData.add(log);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally{
			CommonUtils.closeConn(data, stmt, conn);
		}
		return rData;
    }
    /**
     * 根据数据日期查询任务级别的ETL跑批数据
     * @param asOfDate
     * noQueryId 不在报警的跑批
     * @return
     */
    public List<Map<String,String>> queryWrongRunFlagDataFromEtl(String noQueryId){
    	 List<Map<String,String>> rData = new ArrayList<Map<String,String>>();
    	StringBuilder sql = new StringBuilder();
    	sql.append("SELECT B.BATCH_ID,BATCH_NAME,P.PROCESS_ID,PROCESS_NAME,TASK_ID,TASK_NAME,ERROR_MESSAGE FROM ETL_SCHEDULE_BATCHSTATUS  B ");
    	sql.append(" INNER JOIN ETL_SCHEDULE_PROCESSSTATUS P ON B.BATCH_ID = P.BATCH_ID   ");
    	sql.append(" INNER JOIN ETL_SCHEDULE_TASKSTATUS T ON P.PROCESS_ID = T.PROCESS_ID and T.BATCH_ID = B.BATCH_ID");
    	sql.append(" WHERE T.RUN_FLAG = '-1' ");
    	log.info("根据数据日期查询任务级别的ETL跑批数据未添加任务id条件"+sql);
    	log.info("TASK_ID任务id"+noQueryId);
    	if(StringUtil.isNotNullOrEmpty(noQueryId)){
    		sql.append(" AND  T.TASK_ID NOT IN "+noQueryId);
    	}
    	log.info("添加了任务id条件"+sql);
    	Connection conn = CommonUtils.getConnection("etl.jdbc","Oracle");
    	Statement stmt = null;
    	ResultSet data  = null;
    	try {
    		stmt = conn.createStatement();
    		data  = stmt.executeQuery(sql.toString());
    		while(data.next()){
    			Map<String,String> error = new HashMap<String,String>();
    			error.put("batchId", data.getString("BATCH_ID"));
    			error.put("batchName", data.getString("BATCH_NAME"));
    			error.put("taskId", data.getString("TASK_ID"));
    			error.put("taskName", data.getString("TASK_NAME"));
    			error.put("errorMessage", data.getString("ERROR_MESSAGE"));
    			error.put("processId", data.getString("PROCESS_ID"));
    			error.put("processName", data.getString("PROCESS_NAME"));
    			rData.add(error);
    		}
    	} catch (SQLException e) {
    		e.printStackTrace();
    	} finally{
    		CommonUtils.closeConn(data, stmt, conn);
    	}
    	return rData;
    }
    /**
     * 查询晚于时点的预警数据
     * @return
     */
    public Map<String,List<Map<String,String>>> queryLaterDataFromEtl(String batchId,String taskSetId,String taskId
    		,String asOfDate){
    	Map<String,List<Map<String,String>>> dataReturn = new HashMap<String,List<Map<String,String>>>();
    	List<Map<String,String>> batchData  = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> taskSetData  = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> taskData  = new ArrayList<Map<String,String>>();
    	Connection conn = CommonUtils.getConnection("etl.jdbc","Oracle");
    	Statement stmt = null;
    	ResultSet data  = null;
    	try {
    		stmt = conn.createStatement();
    		if(StringUtil.isNotNullOrEmpty(batchId)){
        		StringBuilder batchSql = new StringBuilder();
            	batchSql.append("SELECT * FROM ETL_SCHEDULE_BATCHSTATUS B WHERE B.BATCH_ID IN  "+batchId+"  AND RUN_FLAG != '-1' "
            			+ "and AS_OF_DATE = '"+asOfDate+" 00:00:00'");
            	data  = stmt.executeQuery(batchSql.toString());
        		while(data.next()){
        			Map<String,String> tmp = new HashMap<String,String>();
        			tmp.put("batchId", data.getString("BATCH_ID"));
        			tmp.put("batchName", data.getString("BATCH_NAME"));
        			tmp.put("stdTime", StringUtil.isNotNullOrEmpty(data.getString("STD_TIME"))
        					?DateUtil.convertDateToString(data.getTimestamp("STD_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
        			tmp.put("run_flag", data.getString("RUN_FLAG"));
        			batchData.add(tmp);
        		}
        		
        	}
        	if(StringUtil.isNotNullOrEmpty(taskSetId)){
        		StringBuilder taskSetSql = new StringBuilder();
        		taskSetSql.append("SELECT * FROM ETL_SCHEDULE_PROCESSSTATUS B WHERE B.PROCESS_ID IN "+taskSetId+"  AND RUN_FLAG != '-1' "
        				+ "and AS_OF_DATE = '"+asOfDate+" 00:00:00'");
        		data  = stmt.executeQuery(taskSetSql.toString());
        		while(data.next()){
        			Map<String,String> tmp = new HashMap<String,String>();
        			tmp.put("batchId", data.getString("BATCH_ID"));
        			tmp.put("processId", data.getString("PROCESS_ID"));
        			tmp.put("processName", data.getString("PROCESS_NAME"));
        			tmp.put("stdTime", StringUtil.isNotNullOrEmpty(data.getString("STD_TIME"))
        					?DateUtil.convertDateToString(data.getTimestamp("STD_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
        			tmp.put("run_flag", data.getString("RUN_FLAG"));
        			taskSetData.add(tmp);
        		}
        	}
        	if(StringUtil.isNotNullOrEmpty(taskId)){
        		StringBuilder taskSql = new StringBuilder();
        		taskSql.append("SELECT * FROM ETL_SCHEDULE_TASKSTATUS B WHERE B.TASK_ID IN "+taskId+"  AND RUN_FLAG != '-1' "
        				+ "and AS_OF_DATE = '"+asOfDate+" 00:00:00'");
        		data  = stmt.executeQuery(taskSql.toString());
        		while(data.next()){
        			Map<String,String> tmp = new HashMap<String,String>();
        			tmp.put("batchId", data.getString("BATCH_ID"));
        			tmp.put("processId", data.getString("PROCESS_ID"));
        			tmp.put("taskId", data.getString("TASK_ID"));
        			tmp.put("taskName", data.getString("TASK_NAME"));
        			tmp.put("stdTime", StringUtil.isNotNullOrEmpty(data.getString("STD_TIME"))
        					?DateUtil.convertDateToString(data.getTimestamp("STD_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
        			tmp.put("run_flag", data.getString("RUN_FLAG"));
        			taskData.add(tmp);
        		}
        		
        	}
        	dataReturn.put("batchData", batchData);
        	dataReturn.put("taskSetData", taskSetData);
        	dataReturn.put("taskData", taskData);
    	} catch (SQLException e) {
    		e.printStackTrace();
    	} finally{
    		CommonUtils.closeConn(data, stmt, conn);
    	}
    	return dataReturn;
    }
    /**
     * 查询晚于时长的预警数据
     * @return
     */
    public Map<String,List<Map<String,String>>> queryMorethanDataFromEtl(String batchId,String taskSetId,String taskId){
    	Map<String,List<Map<String,String>>> dataReturn = new HashMap<String,List<Map<String,String>>>();
    	List<Map<String,String>> batchData  = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> taskSetData  = new ArrayList<Map<String,String>>();
    	List<Map<String,String>> taskData  = new ArrayList<Map<String,String>>();
    	Connection conn = CommonUtils.getConnection("etl.jdbc","Oracle");
    	Statement stmt = null;
    	ResultSet data  = null;
    	try {
    		stmt = conn.createStatement();
    		if(StringUtil.isNotNullOrEmpty(batchId)){
    			StringBuilder batchSql = new StringBuilder();
    			batchSql.append("SELECT * FROM ETL_SCHEDULE_BATCHSTATUS B WHERE B.BATCH_ID IN  "+batchId+"  AND RUN_FLAG = '1'");
    			data  = stmt.executeQuery(batchSql.toString());
    			while(data.next()){
    				Map<String,String> tmp = new HashMap<String,String>();
    				tmp.put("batchId", data.getString("BATCH_ID"));
    				tmp.put("batchName", data.getString("BATCH_NAME"));
    				tmp.put("stdTime", StringUtil.isNotNullOrEmpty(data.getString("STD_TIME"))
    						?DateUtil.convertDateToString(data.getTimestamp("STD_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
    				batchData.add(tmp);
    			}
    			
    		}
    		if(StringUtil.isNotNullOrEmpty(taskSetId)){
    			StringBuilder taskSetSql = new StringBuilder();
    			taskSetSql.append("SELECT * FROM ETL_SCHEDULE_PROCESSSTATUS B WHERE B.PROCESS_ID IN "+taskSetId+"  AND RUN_FLAG = '1' ");
    			data  = stmt.executeQuery(taskSetSql.toString());
    			while(data.next()){
    				Map<String,String> tmp = new HashMap<String,String>();
    				tmp.put("batchId", data.getString("BATCH_ID"));
    				tmp.put("processId", data.getString("PROCESS_ID"));
    				tmp.put("processName", data.getString("PROCESS_NAME"));
    				tmp.put("stdTime", StringUtil.isNotNullOrEmpty(data.getString("STD_TIME"))
    						?DateUtil.convertDateToString(data.getTimestamp("STD_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
    				taskSetData.add(tmp);
    			}
    		}
    		if(StringUtil.isNotNullOrEmpty(taskId)){
    			StringBuilder taskSql = new StringBuilder();
    			taskSql.append("SELECT * FROM ETL_SCHEDULE_TASKSTATUS B WHERE B.TASK_ID IN "+taskId+"  AND RUN_FLAG = '1' ");
    			data  = stmt.executeQuery(taskSql.toString());
    			while(data.next()){
    				Map<String,String> tmp = new HashMap<String,String>();
    				tmp.put("batchId", data.getString("BATCH_ID"));
    				tmp.put("processId", data.getString("PROCESS_ID"));
    				tmp.put("taskId", data.getString("TASK_ID"));
    				tmp.put("taskName", data.getString("TASK_NAME"));
    				tmp.put("stdTime", StringUtil.isNotNullOrEmpty(data.getString("STD_TIME"))
    						?DateUtil.convertDateToString(data.getTimestamp("STD_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
    				taskData.add(tmp);
    			}
    			
    		}
    		dataReturn.put("batchData", batchData);
    		dataReturn.put("taskSetData", taskSetData);
    		dataReturn.put("taskData", taskData);
    	} catch (SQLException e) {
    		e.printStackTrace();
    	} finally{
    		CommonUtils.closeConn(data, stmt, conn);
    	}
    	return dataReturn;
    }
	@Override
	public List<Map<String, String>> queryTask(String asOfDate,String taskId) {
		 List<Map<String,String>> rData = new ArrayList<Map<String,String>>();
	    	StringBuilder sql = new StringBuilder();
	    	sql.append("SELECT T.TASK_ID,B.AS_OF_DATE,B.STD_TIME,B.END_TIME FROM ETL_SCHEDULE_BATCHSTATUS  B ");
	    	sql.append(" INNER JOIN ETL_SCHEDULE_PROCESSSTATUS P ON B.BATCH_ID = P.BATCH_ID   ");
	    	sql.append(" INNER JOIN ETL_SCHEDULE_TASKSTATUS T ON P.PROCESS_ID = T.PROCESS_ID and T.BATCH_ID = B.BATCH_ID");
	    	sql.append(" WHERE T.RUN_FLAG = '0' ");
	    	log.info("根据数据日期查询任务级别的ETL跑批数据未添加任务id条件"+sql);
	    	log.info("TASK_ID任务id"+asOfDate);
	    	if(StringUtil.isNotNullOrEmpty(asOfDate)){
	    		sql.append(" AND  to_char(B.as_of_date,'yyyy-MM-dd') IN "+"("+asOfDate+")");
	    	}
	    	if(StringUtil.isNotNullOrEmpty(taskId)){
	    		sql.append(" AND  T.TASK_ID ='"+taskId+"'");
	    	}
	    	log.info("添加了任务id条件"+sql);
	    	Connection conn = CommonUtils.getConnection("etl.jdbc","Oracle");
	    	Statement stmt = null;
	    	ResultSet data  = null;
	    	try {
	    		stmt = conn.createStatement();
	    		data  = stmt.executeQuery(sql.toString());
	    		while(data.next()){
	    			Map<String,String> result = new HashMap<String,String>();
	    			result.put("taskId", data.getString("TASK_ID"));
	    			result.put("asOfDate", StringUtil.isNotNullOrEmpty(data.getString("AS_OF_DATE"))
    						?DateUtil.convertDateToString(data.getTimestamp("AS_OF_DATE"), "yyyy-MM-dd"):"");
	    			result.put("stdTime", StringUtil.isNotNullOrEmpty(data.getString("STD_TIME"))
    						?DateUtil.convertDateToString(data.getTimestamp("STD_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
	    			result.put("endTime", StringUtil.isNotNullOrEmpty(data.getString("END_TIME"))
    						?DateUtil.convertDateToString(data.getTimestamp("END_TIME"), "yyyy-MM-dd HH:mm:ss"):"");
	    			rData.add(result);
	    		}
	    	} catch (SQLException e) {
	    		e.printStackTrace();
	    	} finally{
	    		CommonUtils.closeConn(data, stmt, conn);
	    	}
	    	return rData;
	}
}
