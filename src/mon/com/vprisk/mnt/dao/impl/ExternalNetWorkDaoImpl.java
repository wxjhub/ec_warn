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
import com.vprisk.mnt.dao.ExternalNetWorkDao;
import com.vprisk.mnt.entity.ExternalNetWork;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 网络监控参数Dao层实现类
 */
public class ExternalNetWorkDaoImpl extends BaseDao<ExternalNetWork>  implements ExternalNetWorkDao{


	@SuppressWarnings("unchecked")
	public List<ExternalNetWork> findParameterCollectionByUpdate(ExternalNetWork subject) {
		String hql = "from ExternalNetWork where uuid <> ? and OppositeHostIP = ? and OppositeHostPort=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getUuid())
		.setString(1, subject.getOppositeHostIP())
		.setString(2, subject.getOppositeHostPort());
		List<ExternalNetWork> list = query.list();
		return list;
	}


	@SuppressWarnings("unchecked")
	public List<ExternalNetWork> findParameterCollectionByAdd(ExternalNetWork subject) {
		String hql = "from ExternalNetWork where OppositeHostIP = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getOppositeHostIP());
		List<ExternalNetWork> list = query.list();
		return list;
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete ExternalNetWork where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0,uuid);
		query.executeUpdate();
		
	}


	public boolean saveOrUpdateCash(ExternalNetWork pracol) {
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
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		 Criteria c = getCriteria(ExternalNetWork.class);
			String portName = (String) params.get("portName"); //对端名称
			if(StringUtil.isNotNullOrEmpty(portName)){
				c.add(Restrictions.ilike("portName", portName, MatchMode.ANYWHERE));
			}
			//判断查询所选的排序方式
			if(orderBy!=null&& isAsc!=null){
				if (isAsc)
					c.addOrder(Order.asc(orderBy)); 
				else
					c.addOrder(Order.desc(orderBy));
			}else
			{
				c.addOrder(Order.asc("uuid"));
			}
			//执行查询返回结果信息
			return pagedQuery(c, pageNo, pageSize);
	}
	
	@SuppressWarnings("unchecked")
	public List<ExternalNetWork> findNetWork() {
		String hql = "from ExternalNetWork";
		Query query = getSession().createQuery(hql);
		List<ExternalNetWork> vpdm= (List<ExternalNetWork>)query.list();
		return vpdm;
	}
	
	
	public void updateExternalnetWorkByUuid(String status,String uuid) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str =sdf.format(dateStr);
		String hql ="update ExternalNetWork set status = ? , collectDate= ? where uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,status)
		.setParameter(1, str)
		.setParameter(2, uuid);
		query.executeUpdate();

	}
	
	@Override
	public void insertModel(ExternalNetWork externalNetWork) {
		super.insertOrUpdate(externalNetWork);
		
	}
	
	
}
