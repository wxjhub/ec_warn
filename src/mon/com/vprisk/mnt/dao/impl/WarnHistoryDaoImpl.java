package com.vprisk.mnt.dao.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.ibm.icu.text.SimpleDateFormat;
import com.vprisk.mnt.dao.WarnHistoryDao;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 报警历史Dao层实现类
 * 
 */
public class WarnHistoryDaoImpl extends BaseDao<WarnHistory> implements
		WarnHistoryDao {
	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.vprisk.mon.dao.WarnHistoryDao#selectParameterCollectiondByPage(java
	 * .util.Map, int, int, java.lang.String, java.lang.Boolean)
	 */
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(WarnHistory.class);
		String recordDate = (String) params.get("recordDate"); // 姓名
		String warnLevel = (String) params.get("warnLevel");// 预警级别
		String state = (String) params.get("reprotState");// 处理状态
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		
		if (StringUtil.isNotNullOrEmpty(warnLevel)) {
			Integer num = Integer.parseInt(warnLevel);
			c.add(Restrictions.eq("warnLevel", num));
		}
		if (StringUtil.isNotNullOrEmpty(recordDate)) {
			c.add(Restrictions.ilike("recordDate", recordDate,
					MatchMode.ANYWHERE));
		}
		if(StringUtil.isNotNullOrEmpty(state)){
			c.add(Restrictions.eq("reprotState", state));
		}
		//c.add(Restrictions.ne("state", "2"));
		
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		} else {
		c.addOrder(Order.desc("recordDate"));
			//c.addOrder(Order.asc("uuid"));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * com.vprisk.mon.dao.WarnHistoryDao#saveOrUpdateCash(com.vprisk.mon.entity
	 * .WarnHistory)
	 */
	public boolean saveOrUpdateCash(WarnHistory pracol) {
		boolean flag = false;
		try {
			super.insertOrUpdate(pracol);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return flag;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.vprisk.mon.dao.WarnHistoryDao#handleStateById(java.lang.String)
	 */
	public void handleStateById(String id) {
		String hql = "update WarnHistory set state = 1 where uuid = ?";
		Query query = super.getSession().createQuery(hql);
		query.setParameter(0, id);
		query.executeUpdate();

	}
	/*
	 * (non-Javadoc)
	 * @see com.vprisk.mon.dao.WarnHistoryDao#insertIntoWarnHistory(com.vprisk.mon.entity.WarnHistory)
	 */
	public void insertIntoWarnHistory(WarnHistory warnhistory) {
		super.insertOrUpdate(warnhistory);
	}

	//历史报警
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage2(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(WarnHistory.class);
		String recordDate = (String) params.get("recordDate"); // 姓名
		String warnLevel = (String) params.get("warnLevel");// 预警级别
		//String state = "2";// 处理状态为正常
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		
		if (StringUtil.isNotNullOrEmpty(warnLevel)) {
			Integer num = Integer.parseInt(warnLevel);
			c.add(Restrictions.eq("warnLevel", num));
		}
		if (StringUtil.isNotNullOrEmpty(recordDate)) {
			c.add(Restrictions.ilike("recordDate", recordDate,
					MatchMode.ANYWHERE));
		}
		//	c.add(Restrictions.eq("state", state));
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		} else {
			c.addOrder(Order.desc("recordDate"));
			//c.addOrder(Order.asc("uuid"));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}
	
	
	
	
	
	public void updateWarnHistory(String id) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str =sdf.format(dateStr);
		String hql = "update WarnHistory set  endDate =? where uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, str).setParameter(1,id);
		query.executeUpdate();

	}
	
	
	
	
public List<WarnHistory> handleStateByCourseCode(String recordName,String pointName, String pointIp, String warnSort){
		
		String hql = "from WarnHistory  where warnSort=? and endDate is null ";
		if (StringUtil.isNotNullOrEmpty(recordName)) {
			hql += "and recordName='" + recordName + "'";
		}
		if (StringUtil.isNotNullOrEmpty(pointName)) {
			hql += "and pointName='" + pointName + "'";
		}
		if (StringUtil.isNotNullOrEmpty(pointIp)) {
			hql += "and pointIp='" + pointIp + "'";
		}
		Query query = getSession().createQuery(hql);
		query.setParameter(0, warnSort);
		List<WarnHistory> list = query.list();
		return list;
}

	@Override
	public void updateConfirmation(Map params,String userName, String userOrganName) {
			Date dateStr = new Date();
			SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String str =sdf.format(dateStr);
			String remark=(String) params.get("remark");
			String uuid=(String) params.get("uuid");

			String hql = "update WarnHistory set  endDate =?,remark=?,confirmationPerson=?,department=? where uuid = ?";
			Query query = getSession().createQuery(hql);
			query.setParameter(0, str)
			.setParameter(1,remark)
			.setParameter(2,userName)
			.setParameter(3,userOrganName)
			.setParameter(4,uuid);
			query.executeUpdate();

		}
	
	/**
	 * 根据参数查询数据
	 * @param param
	 * @return
	 */
	public List<WarnHistory> selectWarnHistoryByParam(Map param){
	    String warnSort = (String)param.get("warnSort");
	    String recordDate = (String)param.get("recordDate");
	    String col1 = (String)param.get("col1");
	    String endDate = (String)param.get("endDate");
		String hql = "from WarnHistory  where 1=1  ";
		if (StringUtil.isNotNullOrEmpty(recordDate)) {
			hql += "and recordDate like '" + recordDate + "%'";
		}
		if (StringUtil.isNotNullOrEmpty(col1)) {
			hql += "and col1='" + col1 +"'";
		}
		if (StringUtil.isNotNullOrEmpty(warnSort)) {
			hql += "and warnSort='" + warnSort + "'";
		}
		if (StringUtil.isNotNullOrEmpty(endDate)) {
			hql += "and endDate is not null ";
		}
		Query query = getSession().createQuery(hql);
		List<WarnHistory> list = query.list();
		return list;
	}
}
