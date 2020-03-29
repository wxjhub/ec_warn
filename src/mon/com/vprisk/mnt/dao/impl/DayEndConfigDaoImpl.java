package com.vprisk.mnt.dao.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.DayEndConfigDao;
import com.vprisk.mnt.entity.DayEndConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 日终 dao实现类
 * 
 */
public class DayEndConfigDaoImpl extends BaseDao<DayEndConfig> implements
		DayEndConfigDao {

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(DayEndConfig.class);
		String dataDate = (String) params.get("dataDate"); 
	
		if(StringUtil.isNotNullOrEmpty(dataDate))
		{
			Date dataDateTime = DateUtil.convertStringToDate(dataDate,"yyyy-MM-dd");
			c.add(Restrictions.eq("dayendDate", dataDateTime));
		}
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		} else {
			c.addOrder(Order.asc("uuid"));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}

	public boolean saveOrUpdateCash(DayEndConfig pracol) {
		boolean flag = false;
		try {
			super.insertOrUpdate(pracol);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return flag;
	}

	@SuppressWarnings("unchecked")
	public List<DayEndConfig> findParameterCollectionByAdd(DayEndConfig subject) {
		String hql = "from DayEndConfig where dayendName = ? and dayendDate=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getDayendName()).setDate(1,
				subject.getDayendDate());
		List<DayEndConfig> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<DayEndConfig> findParameterCollectionByUpdate(
			DayEndConfig subject) {
		String hql = "from DayEndConfig where uuid <> ? and dayendName = ? and dayendDate=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getUuid())
				.setString(1, subject.getDayendName())
				.setDate(2, subject.getDayendDate());
		List<DayEndConfig> list = query.list();
		return list;
	}

	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete DayEndConfig where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0, uuid);
		query.executeUpdate();

	}

	@Override
	public List<DayEndConfig> findAll() {
		String hql = "from DayEndConfig";
		Query query = getSession().createQuery(hql);
		return query.list();
	}

}
