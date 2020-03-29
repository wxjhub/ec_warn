package com.vprisk.mnt.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.TransactionEndConfigDao;
import com.vprisk.mnt.entity.TransactionEndConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 长时间无交易配置Dao层实现类
 * 
 */
public class TransactionEndConfigDaoImpl extends BaseDao<TransactionEndConfig>
		implements TransactionEndConfigDao {

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(TransactionEndConfig.class);
		String sysCode = (String) params.get("sysCode"); // 系统
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		if (StringUtil.isNotNullOrEmpty(sysCode)) {
			c.add(Restrictions.ilike("sysCode", sysCode, MatchMode.ANYWHERE));
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

	@SuppressWarnings("unchecked")
	public List<TransactionEndConfig> findParameterCollectionByUpdate(
			TransactionEndConfig subject) {
		String hql = "from TransactionEndConfig where uuid <> ? and sysCode = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getUuid()).setString(1,
				subject.getSysCode());
		List<TransactionEndConfig> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<TransactionEndConfig> findParameterCollectionByAdd(
			TransactionEndConfig subject) {
		String hql = "from TransactionEndConfig where sysCode = ? ";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getSysCode());
		List<TransactionEndConfig> list = query.list();
		return list;
	}

	public boolean saveOrUpdateCash(TransactionEndConfig pracol) {
		boolean flag = false;
		try {
			super.insertOrUpdate(pracol);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}

		return flag;
	}

	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete TransactionEndConfig where uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, uuid);
		query.executeUpdate();

	}
	
	@SuppressWarnings("unchecked")
	public List<TransactionEndConfig> selectTransactionEndValue(String code) {

		String hql = "select uuid,noTransactionTimeValuesY,noTransactionTimeValuesG,warningLevl from TransactionEndConfig where sysCode=? ";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, code);
		List<Object[]> vpdmList = query.list();
		List<TransactionEndConfig> SqlBlockList = new ArrayList<TransactionEndConfig>();
		for (Object[] vpdm : vpdmList) {
			TransactionEndConfig sqlB = new TransactionEndConfig();
			sqlB.setUuid((String) vpdm[0]);
			sqlB.setNoTransactionTimeValuesY((Integer) vpdm[1]);
			sqlB.setNoTransactionTimeValuesG((Integer) vpdm[2]);
			sqlB.setWarningLevl((Integer) vpdm[3]);
			SqlBlockList.add(sqlB);
		}
		return SqlBlockList;
	}

}
