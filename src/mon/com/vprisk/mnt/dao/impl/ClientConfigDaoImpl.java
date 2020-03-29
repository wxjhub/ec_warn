package com.vprisk.mnt.dao.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.ClientConfigDao;
import com.vprisk.mnt.entity.ClientConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


/**
 * 系统基本配置dao实现类
 */

public class ClientConfigDaoImpl extends BaseDao<ClientConfig>  implements ClientConfigDao{
	

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
			Criteria c = getCriteria(ClientConfig.class);
			String systemName = (String) params.get("systemName"); //系统名称
			//判断接收到的查询条件信息是否空，并根据相关信息查询
			if(StringUtil.isNotNullOrEmpty(systemName)){
				c.add(Restrictions.ilike("systemName", systemName, MatchMode.ANYWHERE));
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
	public List<ClientConfig> findParameterCollectionByAdd(ClientConfig subject) {
		String hql = "from ClientConfig where subsystemName = ? and ipAddress=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getSubsystemName())	
		.setString(1, subject.getIpAddress());
		List<ClientConfig> list = query.list();
		return list;
	}
	
	@SuppressWarnings("unchecked")
	public List<ClientConfig> findParameterCollectionByUpdate(ClientConfig subject) {
		String hql = "from ClientConfig where uuid <> ? and subsystemName = ? and ipAddress=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getUuid())
		.setString(1, subject.getSubsystemName())
		.setString(2, subject.getIpAddress());
		List<ClientConfig> list = query.list();
		return list;
	}
	
	public boolean saveOrUpdateCash(ClientConfig pracol) {
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
		String hql = "delete ClientConfig where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0,uuid);
		query.executeUpdate();
		
	}
	
}
