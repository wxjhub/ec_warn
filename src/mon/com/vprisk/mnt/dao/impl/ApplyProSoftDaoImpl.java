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
import com.vprisk.mnt.dao.ApplyProSoftDao;
import com.vprisk.mnt.entity.ApplyProSoft;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 应用服务数Dao层实现类
 * 
 */
public class ApplyProSoftDaoImpl extends BaseDao<ApplyProSoft> implements ApplyProSoftDao {

	@SuppressWarnings("unchecked")
	public List<ApplyProSoft> findParameterCollectionByUpdate(ApplyProSoft subject) {
		String hql = "from ApplyProSoft where uuid <> ? and courseCode = ? and localIP=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getUuid())
				.setString(1, subject.getCourseCode())
				.setString(2, subject.getLocalIp());
		List<ApplyProSoft> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<ApplyProSoft> findParameterCollectionByAdd(ApplyProSoft subject) {
		String hql = "from ApplyProSoft where courseCode = ? and localIP=?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getCourseCode()).setString(1,
				subject.getLocalIp());
		List<ApplyProSoft> list = query.list();
		return list;
	}

	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete ApplyProSoft where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0, uuid);
		query.executeUpdate();

	}

	public boolean saveOrUpdateCash(ApplyProSoft pracol) {
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
		Criteria c = getCriteria(ApplyProSoft.class);
		String courseName = (String) params.get("courseName"); 
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		if (StringUtil.isNotNullOrEmpty(courseName)) {
			c.add(Restrictions.ilike("courseName", courseName,MatchMode.ANYWHERE));
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
	public List<ApplyProSoft> findApplyProSoft() {
		String hql = "from ApplyProSoft";
		Query query = getSession().createQuery(hql);
		List<ApplyProSoft> vpdm = query.list();
		return vpdm;
	}

	public void updateApplyProSoftByIP(String ip) {
		String hql = "update ApplyProSoft set localIP = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, ip);
		query.executeUpdate();
	}

	public void updateApplyProSoftByCourseCode(int num, String courseStatus,
			String courseCode, String localIp) {
		Date dateStr = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str = sdf.format(dateStr);
		String hql = "update ApplyProSoft set courseStatus = ? , collectDate= ?,courseNum=? where courseCode =? and localIP = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, courseStatus).setParameter(1, str)
				.setParameter(2, num).setParameter(3, courseCode)
				.setParameter(4, localIp);
		query.executeUpdate();

	}

	@Override
	public void insertModel(ApplyProSoft applyProSoft) {
		super.insertOrUpdate(applyProSoft);
		
	}
}
