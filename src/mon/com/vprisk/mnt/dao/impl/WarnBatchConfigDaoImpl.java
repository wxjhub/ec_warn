package com.vprisk.mnt.dao.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.dao.WarnBatchConfigDao;
import com.vprisk.mnt.entity.WarnBatchConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnBatchConfigDaoImpl extends BaseDao<WarnBatchConfig>  implements WarnBatchConfigDao {
	@SuppressWarnings("rawtypes")
	@Override
	public Page selectWarnBatchByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(WarnBatchConfig.class);
		String batchId = (String) params.get("batchId");//批次id
		String taskSetId = (String) params.get("taskSetId");//任务组id
		String taskId = (String) params.get("taskId");// 任务id
		String warnLevl = (String) params.get("warnLevl");// 预警级别
		String warnContent = (String) params.get("warnContent");// 预警级别
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		if (StringUtil.isNotNullOrEmpty(batchId)) {
			c.add(Restrictions.eq("batchId", batchId));
		}
		if (StringUtil.isNotNullOrEmpty(warnLevl)) {
			c.add(Restrictions.eq("warnLevl", Integer.valueOf(warnLevl)));
		}
		if (StringUtil.isNotNullOrEmpty(taskSetId)) {
			c.add(Restrictions.eq("taskSetId", taskSetId));
		}
		if (StringUtil.isNotNullOrEmpty(taskId)) {
			c.add(Restrictions.eq("taskId", taskId));
		}
		if (StringUtil.isNotNullOrEmpty(warnContent)) {
			c.add(Restrictions.eq("warnContent", warnContent));
		}
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}
	/**
	  * 分页查询任务数据
	  * @param params
	  * @param pageNo
	  * @param pageSize
	  * @param orderBy
	  * @param isAsc
	  * @return
	  */
	public Page selectTaskByPage(Map params, int pageNo, int pageSize, String orderBy,
			Boolean isAsc){
		String taskSetId = (String)params.get("taskSetId");
		String taskId = (String)params.get("taskId");
		String sql = "SELECT T.TASK_ID,T.TASK_NAME FROM ETL_SCHEDULE_TASK T INNER JOIN ETL_SCHEDULE_TASKRELATION TR "
				+ "ON T.TASK_ID = TR.TASK_ID AND TR.PROCESS_ID = '"+taskSetId+"'";
		if(StringUtil.isNotNullOrEmpty(taskId)){
			sql += " and t.task_id like '%"+taskId+"%'";
		}
		return super.pagedSqlQueryByCount(super.getSession().createSQLQuery(sql), 
				super.getSession().createSQLQuery(sql).list().size(), pageNo, pageSize);
	 }
	 /**
	  * 保存修改的方法
	  * @param warnModule
	  * @return
	  */
	 public boolean saveOrUpdate(WarnBatchConfig warnBatch) {
			boolean flag = false;
			try {
				super.insertOrUpdate(warnBatch);
				flag = true;
			} catch (Exception e) {
				e.printStackTrace();
			}
			return flag;
		}
	 /**
	  * 删除数据
	  */
	@Override
	public void deleteByUuid(String uuid) {
		super.removeById(uuid);
	}
	/**
	 * 根据id查询数据
	 * @param uuid
	 */
	public WarnBatchConfig selectEntityById(String uuid){
		return this.get(uuid);
	}
	/**
	 * 根据sql查询数据
	 * @return
	 */
	public List selectBatchList(){
		String sql = "SELECT BATCH_ID,BATCH_NAME FROM ETL_SCHEDULE_BATCH";
		return getSession().createSQLQuery(sql).list();
	}
	/**
     * 查询任务组
     * @return
     */
	public List selectTaskSetList(String batchId){
		String sql = "SELECT P.PROCESS_ID AS TASK_SET_ID, P.PROCESS_NAME AS TASK_SET_NAME FROM ETL_SCHEDULE_PROCESS P INNER JOIN ETL_SCHEDULE_PROCESSRELATION PR "+
             "ON P.PROCESS_ID = PR.PROCESS_ID AND PR.BATCH_ID = '"+batchId+"'";
		return getSession().createSQLQuery(sql).list();
	}
	/**
	 * 查询任务
	 * @param taskSetId
	 * @return
	 */
	public List selectTaskList(String taskSetId){
		String sql = "SELECT T.TASK_ID,T.TASK_NAME FROM ETL_SCHEDULE_TASK T INNER JOIN ETL_SCHEDULE_TASKRELATION TR "
				+ "ON T.TASK_ID = TR.TASK_ID AND TR.PROCESS_ID = '"+taskSetId+"'";
		return getSession().createSQLQuery(sql).list();
	}
	/**
	 * 查询某个配置关联的批次 任务组 任务
	 * @param batchId taskSetId taskId
	 * @return
	 */
	public List<Map<String,String>> selectBatchInfo(String batchId,String taskSetId,String taskId){
		List<Map<String,String>> rData = new ArrayList<Map<String,String>>();
		String sql = "SELECT "+
						"(SELECT BATCH_NAME FROM ETL_SCHEDULE_BATCH WHERE BATCH_ID = '"+batchId+"') AS BATCH_NAME, "+
						"(SELECT PROCESS_NAME  FROM ETL_SCHEDULE_PROCESS WHERE PROCESS_ID = '"+taskSetId+"') AS TASK_SET_NAME, "+
						"(SELECT TASK_NAME FROM ETL_SCHEDULE_TASK WHERE TASK_ID = '"+taskId+"') AS TASK_NAME "+
						"FROM DUAL";
		Connection conn = CommonUtils.getConnection("etl.jdbc","Oracle");
    	Statement stmt = null;
    	ResultSet data  = null;
    	try {
    		stmt = conn.createStatement();
    		data  = stmt.executeQuery(sql.toString());
    		System.out.print("查询sql"+sql.toString());
    		while(data.next()){
    			Map<String,String> error = new HashMap<String,String>();
    			error.put("batchName", data.getString("BATCH_NAME"));
    			error.put("taskSetName", data.getString("TASK_SET_NAME"));
    			error.put("taskName", data.getString("TASK_NAME"));
    			rData.add(error);
    		}
    	} catch (SQLException e) {
    		e.printStackTrace();
    	} finally{
    		CommonUtils.closeConn(data, stmt, conn);
    	}
    	return rData;
//		return getSession().createSQLQuery(sql).list();
	}
	/**
	 * 查询所有批次数据
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<WarnBatchConfig> queryAllBatchIdConfig(Map param){
		String warnContent = (String)param.get("warnContent");
		String hql = "from WarnBatchConfig where taskSetId is null and taskId is null and warnContent = '"+warnContent+"'";
		String warnNum = (String)param.get("warnNum");
		String recordDate = (String)param.get("recordDate");
		String warnSort = (String)param.get("warnSort");
		hql += " and batchId not in (select recordName from WarnHistory where recordDate like '"+recordDate+"%'  and warnSort='"+warnSort+"'";
		if("02".equals(warnNum)){ //循环
			hql += " and endDate is not null )";
		} else{
			hql += " )";
		} 
		return super.createQuery(hql, null).list();
	}
	/**
	 * 查询所有批次数据
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<WarnBatchConfig> queryAllTaskSetIdConfig(Map param){
		String warnContent = (String)param.get("warnContent");
		String hql = "from WarnBatchConfig where taskSetId is not null and taskId is null  and warnContent = '"+warnContent+"'";
		String warnNum = (String)param.get("warnNum");
		String recordDate = (String)param.get("recordDate");
		String warnSort = (String)param.get("warnSort");
		hql += " and batchId ||'-'|| taskSetId not in (select recordName from WarnHistory where recordDate like '"+recordDate+"%' and warnSort='"+warnSort+"'";
		if("02".equals(warnNum)){ //循环
			hql += " and endDate is not null )";
		} else{
			hql += " )";
		} 
		return super.createQuery(hql, null).list();
	}
	/**
	 * 查询所有批次数据
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<WarnBatchConfig> queryAllTaskIdConfig(Map param){
		String warnContent = (String)param.get("warnContent");
		String warnNum = (String)param.get("warnNum");
		String recordDate = (String)param.get("recordDate");
		String warnSort = (String)param.get("warnSort");
		String hql = "from WarnBatchConfig where taskId is not null  and warnContent = '"+warnContent+"'";
		hql += " and batchId ||'-'|| taskSetId || '-' ||taskId not in (select recordName from WarnHistory where recordDate like '"+recordDate+"%'  and warnSort='"+warnSort+"'";
		if("02".equals(warnNum)){ //循环
			hql += " and endDate is not null )";
		} else{
			hql += " )";
		}
		return super.createQuery(hql, null).list();
	}
	/**
	 * 查询任务
	 * @param taskSetId
	 * @return
	 */
	public List selectTaskNameById(String taskId){
		String sql = "SELECT T.TASK_ID,T.TASK_NAME FROM ETL_SCHEDULE_TASK T WHERE T.TASK_ID = '"+taskId+"' ";
		return getSession().createSQLQuery(sql).list();
	}
}
