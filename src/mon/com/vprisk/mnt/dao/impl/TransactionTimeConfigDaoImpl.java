package com.vprisk.mnt.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.ibm.icu.text.SimpleDateFormat;
import com.vprisk.mnt.dao.TransactionTimeConfigDao;
import com.vprisk.mnt.entity.TransactionTimeConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 交易时长配置Dao层实现类
 */
public class TransactionTimeConfigDaoImpl extends
		BaseDao<TransactionTimeConfig> implements TransactionTimeConfigDao {

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(TransactionTimeConfig.class);
		String transactionName = (String) params.get("transactionName"); // 系统
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		if (StringUtil.isNotNullOrEmpty(transactionName)) {
			c.add(Restrictions.ilike("transactionName", transactionName,
					MatchMode.ANYWHERE));
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
	public List<TransactionTimeConfig> findParameterCollectionByUpdate(
			TransactionTimeConfig subject) {
		String hql = "from TransactionTimeConfig where uuid <> ? and transactionCode = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getUuid()).setString(1,
				subject.getTransactionCode());
		List<TransactionTimeConfig> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<TransactionTimeConfig> findParameterCollectionByAdd(
			TransactionTimeConfig subject) {
		String hql = "from TransactionTimeConfig where transactionCode = ? ";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getTransactionCode());
		List<TransactionTimeConfig> list = query.list();
		return list;
	}

	public boolean saveOrUpdateCash(TransactionTimeConfig pracol) {
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
		String hql = "delete TransactionTimeConfig where uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, uuid);
		query.executeUpdate();

	}
	
	
	@SuppressWarnings("unchecked")
	public List<TransactionTimeConfig> selectTransactionTimeValue(String transactionCode) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("HH");
		String str =sdf.format(dateStr);
		int number=Integer.parseInt(str);
	//	String hql = "select uuid,transactionTimeValue,warningLevl from TransactionTimeConfig where sysCode=? ";
		String hql = "select uuid,transactionTime,transactionTimeValueY,transactionTimeValueG,warningLevl,countCycle from TransactionTimeConfig where transactionCode=? ";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,transactionCode); 
		List<Object[]> vpdmList= query.list();
		List<TransactionTimeConfig> SqlBlockList=new ArrayList <TransactionTimeConfig>();
		for (Object[] vpdm : vpdmList) {
			TransactionTimeConfig sqlB=new  TransactionTimeConfig();
			sqlB.setUuid((String) vpdm[0]);
			sqlB.setTransactionTime((Integer)vpdm[1]);
			sqlB.setTransactionTimeValueY((Integer)vpdm[2]);
			sqlB.setTransactionTimeValueG((Integer)vpdm[3]);
			sqlB.setWarningLevl( (Integer) vpdm[4]);
			sqlB.setCountCycle( (Integer) vpdm[5]);
		//	sqlB.setStartDate( (Integer) vpdm[3]);
		//	sqlB.setEndDate( (Integer) vpdm[4]);
			SqlBlockList.add(sqlB);
		}
		return SqlBlockList;
	}

}
