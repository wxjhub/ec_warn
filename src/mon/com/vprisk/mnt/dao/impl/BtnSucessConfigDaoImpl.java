package com.vprisk.mnt.dao.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.BtnSucessConfigDao;
import com.vprisk.mnt.entity.BtnSuccessConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class BtnSucessConfigDaoImpl extends BaseDao<BtnSuccessConfig> implements BtnSucessConfigDao{

	@Override
	public List<BtnSuccessConfig> findBtnTime() {
	   String hql = "from BtnSuccessConfig";
	   Query query = getSession().createQuery(hql);
	   return query.list();
	}

	@Override
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(BtnSuccessConfig.class);
		String systemName = (String) params.get("SystemName"); 
		if (StringUtil.isNotNullOrEmpty(systemName)) {
			c.add(Restrictions.ilike("btnName", systemName, MatchMode.ANYWHERE));
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


	@Override
	public boolean saveOrUpdateCash(BtnSuccessConfig detail) {
		boolean flag = false;
		try {
			super.insertOrUpdate(detail);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		return flag;
	}

	@Override
	public List<BtnSuccessConfig> findParameterCollectionByUpdate(
			BtnSuccessConfig detail) {
		String hql = "from BtnSuccessConfig where uuid <> ? and systemName = ? and systemCode=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,detail.getUuid())
		.setString(1, detail.getSystemName())
		.setString(2, detail.getSystemCode());
		List<BtnSuccessConfig> list = query.list();
		return list;
	}

	@Override
	public List<BtnSuccessConfig> findParameterCollectionByAdd(
			BtnSuccessConfig detail) {
		String hql = "from BtnSuccessConfig where systemName = ? and systemCode=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,detail.getSystemName())	
		.setString(1, detail.getSystemCode());
		List<BtnSuccessConfig> list = query.list();
		return list;
	}

	@Override
	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete BtnSuccessConfig where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0,uuid);
		query.executeUpdate();
	}

}
