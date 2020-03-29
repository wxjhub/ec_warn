package com.vprisk.mnt.dao.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.SqlBlockConfigDao;
import com.vprisk.mnt.entity.SqlBlockConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * sql配置  dao实现类
 * 
 */
public class SqlBlockConfigDaoImpl extends BaseDao<SqlBlockConfig>  implements SqlBlockConfigDao{
	
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		 Criteria c = getCriteria(SqlBlockConfig.class);
			String hostName = (String) params.get("hostName"); 
			//判断接收到的查询条件信息是否空，并根据相关信息查询
			if(StringUtil.isNotNullOrEmpty(hostName)){
				c.add(Restrictions.ilike("hostName", hostName, MatchMode.ANYWHERE));
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
	

	public boolean saveOrUpdateCash(SqlBlockConfig pracol) {
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
	public List<SqlBlockConfig> findParameterCollectionByAdd(SqlBlockConfig subject) {
		String hql = "from SqlBlockConfig";
		Query query = getSession().createQuery(hql);
		List<SqlBlockConfig> list = query.list();
		return list;
	}
	

	@SuppressWarnings("unchecked")
	public List<SqlBlockConfig> findParameterCollectionByUpdate(SqlBlockConfig subject) {
		String hql = "from SqlBlockConfig where uuid <> ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getUuid());
		List<SqlBlockConfig> list = query.list();
		return list;
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete SqlBlockConfig where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0,uuid);
		query.executeUpdate();
		
	}


	@Override
	public List<SqlBlockConfig> findSqlBlockConfig() {
		String hql = "from SqlBlockConfig";
		Query query = getSession().createQuery(hql);
		List<SqlBlockConfig> vpdm= query.list();
		return vpdm;
	}

}
