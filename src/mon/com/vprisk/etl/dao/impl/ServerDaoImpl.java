package com.vprisk.etl.dao.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.vprisk.etl.dao.ServerDao;
import com.vprisk.etl.entity.ETLContext;
import com.vprisk.etl.model.Server;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**Program Name: ServerDaoImpl <br>
 * Description:  <br>
 * @author name: SUPER <br>
 * Written Date: 2012-10-18 <br>
 */
public class ServerDaoImpl extends BaseDao<Server> implements ServerDao {
	public List<Server> selectAllServers() {
		return super.getAll();
	}
	/**
	 * Methods Name: selectAllServers <br>
	 * Description: <br>
	 * @return
	 */
	@SuppressWarnings({ "unchecked", "unchecked" })
	public Page selectServerByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc) {
        Criteria c = getCriteria(Server.class);
		String serverName = (String) params.get("serverName");
		String serverType = (String) params.get("serverType");
		if(StringUtil.isNotNullOrEmpty(serverName))
		{
			c.add(Restrictions.ilike("serverName", serverName, MatchMode.ANYWHERE));
			
		}
		if(StringUtil.isNotNullOrEmpty(serverType))
		{
			c.add(Restrictions.ilike("serverType", serverType, MatchMode.ANYWHERE));
			
		}
		if(orderBy!=null&& isAsc!=null){
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		}
		return pagedQuery(c, pageNo, pageSize);
	}

	/* 
	 * @see com.vprisk.etl.dao.ServerDao#selectServerByServerId(java.lang.String)
	 */
	public Server selectServerByServerId(String serverId) {
		String hql = "from Server t where t.serverId = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, serverId);
		Server server = (Server) query.uniqueResult();
		return server;
	}

	/* 
	 * @see com.vprisk.etl.dao.ServerDao#saveServer(com.vprisk.etl.model.Server)
	 */
	public void saveServer(Server server) {
		super.insertOrUpdate(server);
		
	}

	/* 
	 * @see com.vprisk.etl.dao.ServerDao#selectServer(java.lang.String, int, int, java.lang.Object[])
	 */
	@SuppressWarnings("unchecked")
	public List<Server> selectServer(String hql, int page, int rows,
			Object... param) {
		Query q = this.getSession().createQuery(hql);
		if (param != null && param.length > 0) {
			for (int i = 0; i < param.length; i++) {
				q.setParameter(i, param[i]);
			}
		}
		return q.setFirstResult((page - 1) * rows).setMaxResults(rows).list();
		
	}
	/* 
	 * @see com.vprisk.etl.dao.ServerDao#deleteServerById(java.lang.String)
	 */
	public void deleteServerById(String uuid) {
		super.bulkDelete("delete from Server s where s.uuid = ?", uuid);
	}
	/* 
	 * @see com.vprisk.etl.dao.ServerDao#selectServerCountByServerId(java.lang.String)
	 */
	public int selectServerCountByServerId(String serverId) {
		Integer resultCount = null;
		Criteria c = super.getCriteria(Server.class);
		c.add(Restrictions.eq("serverId", serverId));
		c.setProjection(Projections.rowCount());
		resultCount = (Integer) c.uniqueResult();
		if(resultCount==null){
			resultCount=0;
		}
		return resultCount;
	}
	@SuppressWarnings("unchecked")
	public List<Server> find(String hql, List<Object> param, Integer page, Integer rows) {
		
		if (page == null || page < 1) {
			page = 1;
		}
		if (rows == null || rows < 1) {
			rows = 10;
		}
		Query q = super.getSession().createQuery(hql);
		if (param != null && param.size() > 0) {
			for (int i = 0; i < param.size(); i++) {
				q.setParameter(i, param.get(i));
			}
		}
		return q.setFirstResult((page - 1) * rows).setMaxResults(rows).list();
		
	}
	
	public Long count(String hql, List<Object> param) {
		Query q = super.getSession().createQuery(hql);
		if (param != null && param.size() > 0) {
			for (int i = 0; i < param.size(); i++) {
				q.setParameter(i, param.get(i));
			}
		}
		return (Long) q.uniqueResult();
	}
	public void startCheckServer(String[] serverIds) {
		StringBuffer hql = new StringBuffer(" update Server s set s.runflg = ? ,s.checkTime=? where s.serverId in (");
		for(String serverId :serverIds){
			hql.append("'");
			hql.append(serverId);
			hql.append("'");
			hql.append(",");
		}
		int i = hql.lastIndexOf(",");
		String sql = hql.substring(0,i);
		sql+=")";
		Query q = super.getSession().createQuery(sql);
		q.setParameter(0, ETLContext.CHECK_RUNING);
		q.setTimestamp(1, new Date());
		q.executeUpdate();
	}
	
	 public void upadteCheckServerStatus(String serverId)
	    {
	        Server server = selectServerByServerId(serverId);
	        Date date = server.getCheckTime();
	        if(date != null)
	        {
	            Date currentDate = new Date();
	            long i = date.getTime();
	            long j = currentDate.getTime();
	            long r = j - i;
	            if(r < 4000L)
	            {
	                String hql = "update Server s set s.runflg = ? where s.serverId = ?";
	                Query query = getSession().createQuery(hql);
	                query.setParameter(0, "2");
	                query.setParameter(1, serverId);
	                query.executeUpdate();
	            }
	        } else
	        {
	            String hql = "update Server s set s.runflg = ? where s.serverId = ?";
	            Query query = getSession().createQuery(hql);
	            query.setParameter(0, "-1");
	            query.setParameter(1, serverId);
	            query.executeUpdate();
	        }
	    }

	public void updateCheckServerStatus(String serverId) {
		Server server = selectServerByServerId(serverId);
		Date date = server.getCheckTime();
		Date currentDate = new Date();
		long i = date.getTime();
		long j = currentDate.getTime();
		long r = j-i;
		//System.out.println(i+"=="+j+"=="+r);
		if(r<4000){	
			String hql = "update Server s set s.runflg = ? where s.serverId = ?";
			Query query = getSession().createQuery(hql);
			query.setParameter(0, ETLContext.CHECK_SUCCESS);
			query.setParameter(1, serverId);
			query.executeUpdate();
		}

	}
	public Page findCheckServerByPage(String[] serverIds, int pageNo, int pageSize) {
		StringBuffer hql = new StringBuffer(" from Server s where s.serverId in (");
		for(String serverId :serverIds){
			hql.append("'");
			hql.append(serverId);
			hql.append("'");
			hql.append(",");
		}
		int i = hql.lastIndexOf(",");
		String sql = hql.substring(0,i);
		sql+=")";
		Page page = pagedQuery(sql, pageNo, pageSize);
		List<Server> servers = page.getData();
		for(Server server :servers){
			if(!ETLContext.CHECK_SUCCESS.equals(server.getRunflg())){
				server.setRunflg(ETLContext.CHECK_FAILURE);
				super.insertOrUpdate(server);
			}
		}
		return page;
	}
}
