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
import com.vprisk.mnt.dao.TransactionSuccessConfigDao;
import com.vprisk.mnt.entity.TransactionSuccessConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 交易成功率配置Dao层实现类
 */
public class TransactionSuccessConfigDaoImpl extends
		BaseDao<TransactionSuccessConfig> implements
		TransactionSuccessConfigDao {

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(TransactionSuccessConfig.class);
		String transactionName = (String) params.get("transactionName"); // 交易名称
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
	public List<TransactionSuccessConfig> findParameterCollectionByUpdate(
			TransactionSuccessConfig subject) {
		String hql = "from TransactionSuccessConfig where uuid <> ? and transactionCode = ? and responseCode=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getUuid())
				.setString(1, subject.getTransactionCode())
				.setString(2, subject.getResponseCode());
		List<TransactionSuccessConfig> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<TransactionSuccessConfig> findParameterCollectionByAdd(
			TransactionSuccessConfig subject) {
		String hql = "from TransactionSuccessConfig where  transactionCode = ? and responseCode=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getTransactionCode()).setString(1,
				subject.getResponseCode());
		List<TransactionSuccessConfig> list = query.list();
		return list;
	}

	public boolean saveOrUpdateCash(TransactionSuccessConfig pracol) {
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
		String hql = "delete TransactionSuccessConfig where uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, uuid);
		query.executeUpdate();

	}
	
	@SuppressWarnings("unchecked")
	public List<TransactionSuccessConfig> selectTransactionSuccessValue(String transactionName,String code) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("HH");
		String str =sdf.format(dateStr);
		int number=Integer.parseInt(str);
	//	String hql = "select uuid,countCycle,transactionSuccessValue,transactionSuccessValues,warningLevl from TransactionSuccessConfig where responseCode=? and transactionName=? and startDate  <=? and endDate >= ?";
		String hql = "select uuid,countCycle,transactionSuccessValue,transactionSuccessValues,warningLevl from TransactionSuccessConfig where responseCode=? and transactionName=? ";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,code).setParameter(1,transactionName);
		//.setLong(2, number)
		//.setLong(3, number); 
		List<Object[]> vpdmList= query.list();
		List<TransactionSuccessConfig> TSConfigList=new ArrayList <TransactionSuccessConfig>();
		for (Object[] vpdm : vpdmList) {
			TransactionSuccessConfig TSConfig=new  TransactionSuccessConfig();
			TSConfig.setUuid((String) vpdm[0]);
			TSConfig.setCountCycle((Integer) vpdm[1]);
			TSConfig.setTransactionSuccessValue( (Integer) vpdm[2]);
			TSConfig.setTransactionSuccessValues( (Integer) vpdm[3]);
			TSConfig.setWarningLevl( (Integer) vpdm[4]);
		//	TSConfig.setStartDate( (Integer) vpdm[3]);
		//	TSConfig.setEndDate( (Integer) vpdm[4]);
			TSConfigList.add(TSConfig);
		}
		return TSConfigList;
	}

}
