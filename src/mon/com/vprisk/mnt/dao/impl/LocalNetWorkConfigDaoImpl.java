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
import com.vprisk.mnt.dao.LocalNetWorkConfigDao;
import com.vprisk.mnt.entity.LocalNetWorkConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 网络监控参数Dao层实现类
 */

public class LocalNetWorkConfigDaoImpl extends BaseDao<LocalNetWorkConfig>
		implements LocalNetWorkConfigDao {

	@SuppressWarnings("unchecked")
	public List<LocalNetWorkConfig> findParameterCollectionByUpdate(
			LocalNetWorkConfig subject) {
		String hql = "from LocalNetWorkConfig where uuid <> ? and hostName = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getUuid()).setString(1,subject.getHostName());
		List<LocalNetWorkConfig> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<LocalNetWorkConfig> findParameterCollectionByAdd(
			LocalNetWorkConfig subject) {
		String hql = "from LocalNetWorkConfig where hostName = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getHostName());
		List<LocalNetWorkConfig> list = query.list();
		return list;
	}

	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete LocalNetWorkConfig where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0, uuid);
		query.executeUpdate();

	}

	public boolean saveOrUpdateCash(LocalNetWorkConfig pracol) {
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
	public Page selectParameterCollectiondByPage(Map params, int pageNo,int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(LocalNetWorkConfig.class);
		String hostName = (String) params.get("hostName"); // 对端名称
		if (StringUtil.isNotNullOrEmpty(hostName)) {
			c.add(Restrictions.ilike("hostName", hostName, MatchMode.ANYWHERE));
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
	public void updatelocalNetWorkByUuid(String status,String uuid) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str =sdf.format(dateStr);
		String hql ="update LocalNetWorkConfig set status = ? , collectDate= ? where uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,status)
		.setParameter(1, str)
		.setParameter(2, uuid);
		query.executeUpdate();

	}
	
	public List<LocalNetWorkConfig> findNetWork() {
		String hql = "from LocalNetWorkConfig";
		Query query = getSession().createQuery(hql);
		List<LocalNetWorkConfig> vpdm= (List<LocalNetWorkConfig>)query.list();
		return vpdm;
	}

}
