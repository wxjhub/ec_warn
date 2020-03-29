package com.vprisk.mnt.dao.impl;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.DayEndMonitorDao;
import com.vprisk.mnt.entity.DayEndMonitor;
import com.vprisk.mnt.entity.WarnBatchHisTaskLog;
import com.vprisk.mnt.service.impl.DayEndMonitorServiceImpl;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.DateUtil;

/**
 * 日终 记录 dao实现类
 * 
 */

public class DayEndMonitorDaoImpl extends BaseDao<DayEndMonitor> implements DayEndMonitorDao {
	private static Log log = LogFactory.getLog(DayEndMonitorDaoImpl.class);
	@SuppressWarnings("unchecked")
	public List<DayEndMonitor> findList(Map params) {
		String asOfDate = (String) params.get("asOfDate"); // 数据日期
		//String hql = "select batch_Id,job_Id,process_Id,task_Id,run_flag,run_time,count,error_message,as_of_date,std_time,end_time from etl_his_taskdetailinfo  where 1=1";
		String hql = "select batch_Id,job_Id,process_Id,task_Id,run_flag,run_time,count,error_message,cast(as_of_date as date) as_of_date,std_time,end_time from etl_his_taskdetailinfo  where 1=1";
		if (asOfDate != null && asOfDate != "") {
			/*
			 * String array[]=asOfDate.split("-"); String
			 * M=array[1].substring(0,1)=="0"?array[1].substring(1,2):array[1];
			 * asOfDate=array[2]+'-'+M+'月'+'-'+array[0].substring(2,4);
			 */
			String array[] = asOfDate.split(",");
			if (array.length >= 1) {
				asOfDate = array[array.length - 1];
			}
			if (asOfDate != null && asOfDate != "") {
				hql += " and  as_of_date = date'" + asOfDate + "'";
			}
		}
		Query query = super.getSession().createSQLQuery(hql);
		List<DayEndMonitor> List = new ArrayList<DayEndMonitor>();
		List<Object[]> vpdmList = query.list();
		for (Object[] vpdm : vpdmList) {
			DayEndMonitor dayMon = new DayEndMonitor();
			dayMon.setBatchId((String) vpdm[0]);
			dayMon.setJobId((String) vpdm[1]);
			dayMon.setProcessId((String) vpdm[2]);
			dayMon.setTaskId((String) vpdm[3]);
			dayMon.setRunFlag((String) vpdm[4]);
			dayMon.setRunTime((String) vpdm[5]);
			dayMon.setCount((BigDecimal) vpdm[6]);
			dayMon.setErrorMessage((String) vpdm[7]);
			dayMon.setAsOfDate((Date) vpdm[8]);
			dayMon.setStdTime((Timestamp) vpdm[9]);
			dayMon.setEndTime((Timestamp) vpdm[10]);
			List.add(dayMon);
		}
		return List;
	}

	@Override
	public Page queryWarnBatchHisLogByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(DayEndMonitor.class);
		String asOfDate = (String) params.get("asOfDate");// 数据日期
		log.info("日期"+asOfDate);
		if(asOfDate.indexOf(",")!=-1) {
			String[] s = asOfDate.split(",");
			asOfDate = s[1];
		}
		if (asOfDate != null && asOfDate != "") {
			c.add(Restrictions.eq("asOfDate", DateUtil.convertStringToDate(asOfDate)));
		}
		c.addOrder(Order.desc("asOfDate"));
		return pagedQuery(c, pageNo, pageSize);
	}
}
