package com.vprisk.mnt.dao.impl;

import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.WarnBatchHisTaskLogDao;
import com.vprisk.mnt.entity.WarnBatchHisTaskLog;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnBatchHisTaskLogDaoImpl extends BaseDao<WarnBatchHisTaskLog>  implements WarnBatchHisTaskLogDao {

	@Override
	public Page selectWarnBatchTaskLogByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(WarnBatchHisTaskLog.class);
		String batchId = (String) params.get("batchId");//批次id
		String processId = (String) params.get("processId");//任务组id
		String taskId = (String) params.get("taskId");// 任务id
		String runFlag = (String) params.get("runFlag");// 运行状态
		String asOfDate = (String) params.get("asOfDate");// 数据日期
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		if (StringUtil.isNotNullOrEmpty(batchId)) {
			c.add(Restrictions.eq("batchId", batchId));
		}
		if (StringUtil.isNotNullOrEmpty(processId)) {
			c.add(Restrictions.eq("processId", processId));
		}
		if (StringUtil.isNotNullOrEmpty(taskId)) {
			c.add(Restrictions.eq("taskId", taskId));
		}
		if (StringUtil.isNotNullOrEmpty(runFlag)) {
			c.add(Restrictions.eq("runFlag", runFlag));
		}
		if (StringUtil.isNotNullOrEmpty(asOfDate)) {
			c.add(Restrictions.eq("asOfDate", DateUtil.convertStringToDate(asOfDate+" 00:00:00", "yyyy-MM-dd HH:mm:ss")));
		}
		// 判断查询所选的排序方式
		c.addOrder(Order.desc("asOfDate"));
		c.addOrder(Order.asc("batchId"));
		c.addOrder(Order.asc("processId"));
		c.addOrder(Order.asc("taskId"));
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}
	/**
	 * 根据数据日期删除数据
	 * @param asOfDate
	 */
	public void deleteAllData(String asOfDate){
	    String deleteHql = "delete   WarnBatchHisTaskLog where asOfDate = ? ";
	    Query query = getSession().createQuery(deleteHql);//
		query.setParameter(0,DateUtil.convertStringToDate(asOfDate+" 00:00:00", "yyyy-MM-dd HH:mm:ss"));
		query.executeUpdate();
	 }
	@Override
	public WarnBatchHisTaskLog insertOrUpdateLog(WarnBatchHisTaskLog log) {
		return (WarnBatchHisTaskLog) super.insertOrUpdate(log);
	}
}
