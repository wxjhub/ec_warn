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
import com.vprisk.mnt.dao.ApplyProSoftConfigDao;
import com.vprisk.mnt.entity.ApplyProSoftConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 应用服务数配置实现类
 * @author 
 */
public class ApplyProSoftConfigDaoImpl extends BaseDao<ApplyProSoftConfig>  implements ApplyProSoftConfigDao{
	
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		 Criteria c = getCriteria(ApplyProSoftConfig.class);
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
	

	public boolean saveOrUpdateCash(ApplyProSoftConfig pracol) {
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
	public List<ApplyProSoftConfig> findParameterCollectionByAdd(ApplyProSoftConfig subject) {
		String hql = "from ApplyProSoftConfig where hostName = ? and localIp=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getHostName())	
		.setString(1, subject.getLocalIp());
		List<ApplyProSoftConfig> list = query.list();
		return list;
	}
	

	@SuppressWarnings("unchecked")
	public List<ApplyProSoftConfig> findParameterCollectionByUpdate(ApplyProSoftConfig subject) {
		String hql = "from ApplyProSoftConfig where uuid <> ? and hostName = ? and localIp=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getUuid())
		.setString(1, subject.getHostName())
		.setString(2, subject.getLocalIp());
		List<ApplyProSoftConfig> list = query.list();
		return list;
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete ApplyProSoftConfig where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0,uuid);
		query.executeUpdate();
		
	}
	
	@SuppressWarnings("unchecked")
	public List<ApplyProSoftConfig> findApplyProSoftConfig() {
		String hql = "from ApplyProSoftConfig";
		Query query = getSession().createQuery(hql);
		List<ApplyProSoftConfig> vpdm = query.list();
		return vpdm;
	}


	@Override
	public void updateApplyProSoftConfigStatus(String localIp, String userName,
			int num, String courseStatus,String hostName) {
		Date dateStr = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str = sdf.format(dateStr);
		String hql = "update ApplyProSoftConfig set courseStatus = ? , collectDate= ?,courseNum=? where localIp =? and userName = ? and hostName = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, courseStatus).setParameter(1, str)
				.setParameter(2, num).setParameter(3, localIp)
				.setParameter(4, userName).setParameter(5,hostName);
		query.executeUpdate();
	}
	


}
