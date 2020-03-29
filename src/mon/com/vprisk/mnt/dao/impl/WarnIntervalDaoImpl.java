package com.vprisk.mnt.dao.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.WarnIntervalDao;
import com.vprisk.mnt.entity.WarnInterval;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnIntervalDaoImpl extends BaseDao<WarnInterval> implements
		WarnIntervalDao {


	@SuppressWarnings("unchecked")
	public List<WarnInterval> findItemsByName(String warnName) {
		Criteria c = getCriteria(WarnInterval.class);
		if (StringUtil.isNotNullOrEmpty(warnName)) {
			c.add(Restrictions.ilike("warnName", warnName, MatchMode.ANYWHERE));
		}
		List<WarnInterval> wList = c.list();
		return wList;
	}



	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(WarnInterval.class);
		String warnName = (String) params.get("warnName"); // 姓名
		// String bookWarnLvl = (String) params.get("bookWarnLvl");//预警级别
		// //判断接收到的查询条件信息是否空，并根据相关信息查询
		// if(StringUtil.isNotNullOrEmpty(bookWarnLvl)){
		// c.add(Restrictions.eq("bookWarnLvl", bookWarnLvl));
		// }
		if (StringUtil.isNotNullOrEmpty(warnName)) {
			c.add(Restrictions.ilike("warnName", warnName, MatchMode.ANYWHERE));
		}
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		} else {
			c.addOrder(Order.asc("warnIntervalId"));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}



	public boolean saveOrUpdateCash(WarnInterval pracol) {
		boolean flag = false;
		try {
			super.insertOrUpdate(pracol);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return flag;
	}


	public WarnInterval selectWarnIntervalByWarnCode(String warnCode) {
		String hql = "from WarnInterval where warnCode = ?";
		Query query = getSession().createQuery(hql)
		.setString(0, warnCode);
		WarnInterval wi = (WarnInterval) query.uniqueResult();
		return wi;
	}


	public void updateWarnIntervalByWarnCode(String warnCode,String datedata) {
		String hql = "update WarnInterval set onceTime = ? where warnCode = ?";
		Query query = getSession().createQuery(hql)
		.setString(0, datedata)
		.setString(1, warnCode);
		query.executeUpdate();
	}
	
	//删除
	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete WarnInterval where warnIntervalId = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,uuid);
		query.executeUpdate();
		
	}

}
