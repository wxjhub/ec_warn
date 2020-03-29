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
import com.vprisk.mnt.dao.LocalNetWorkDao;
import com.vprisk.mnt.entity.LocalNetWork;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 网络监控参数Dao层实现类
 */
public class LocalNetWorkDaoImpl extends BaseDao<LocalNetWork>  implements LocalNetWorkDao{


	@SuppressWarnings("unchecked")
	public List<LocalNetWork> findParameterCollectionByUpdate(LocalNetWork subject) {
		String hql = "from LocalNetWork where uuid <> ? and hostName = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getUuid())
		.setString(1, subject.getHostName());
		List<LocalNetWork> list = query.list();
		return list;
	}


	@SuppressWarnings("unchecked")
	public List<LocalNetWork> findParameterCollectionByAdd(LocalNetWork subject) {
		String hql = "from LocalNetWork where hostName = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getHostName());
		List<LocalNetWork> list = query.list();
		return list;
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete LocalNetWork where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0,uuid);
		query.executeUpdate();
		
	}


	public boolean saveOrUpdateCash(LocalNetWork pracol) {
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
		 Criteria c = getCriteria(LocalNetWork.class);
			String pointName = (String) params.get("pointName"); //对端名称
			if(StringUtil.isNotNullOrEmpty(pointName)){
				c.add(Restrictions.ilike("pointName", pointName, MatchMode.ANYWHERE));
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
	public List<LocalNetWork> findNetWork() {
		String hql = "from LocalNetWork";
		Query query = getSession().createQuery(hql);
		List<LocalNetWork> vpdm= (List<LocalNetWork>)query.list();
		return vpdm;
	}
	
	public void updatelocalNetWorkByUuid(String status,String uuid) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str =sdf.format(dateStr);
		String hql ="update LocalNetWork set status = ? , collectDate= ? where uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,status)
		.setParameter(1, str)
		.setParameter(2, uuid);
		query.executeUpdate();

	}
	
	@SuppressWarnings("unchecked")
	public List<LocalNetWork> findLocalNetWork() {
		String hql = "from LocalNetWork";
		Query query = getSession().createQuery(hql);
		List<LocalNetWork> vpdm= query.list();
		return vpdm;
	}
	
	
	@Override
	public void insertModel(LocalNetWork localNetWork) {
		super.insertOrUpdate(localNetWork);
		
	}
	

}
