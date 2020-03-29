package com.vprisk.mnt.dao.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.FileConfigDao;
import com.vprisk.mnt.entity.FileConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 文件传输预警Dao层实现类
 * 
 */
public class FileConfigDaoImpl extends BaseDao<FileConfig> implements
		FileConfigDao {

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(FileConfig.class);
		String sysName = (String) params.get("sysName"); // 系统名称
		String warnLevel = (String) params.get("warnLevel");// 预警级别
		if (StringUtil.isNotNullOrEmpty(sysName)) {
			c.add(Restrictions.ilike("sysName", sysName, MatchMode.ANYWHERE));
		}
		if (StringUtil.isNotNullOrEmpty(warnLevel)) {
			Integer num = Integer.parseInt(warnLevel);
			// 判断接收到的查询条件信息是否空，并根据相关信息查询
			c.add(Restrictions.eq("warnLevel", num));
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

	public boolean saveOrUpdateCash(FileConfig pracol) {
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
		String hql = "delete FileConfig where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0, uuid);
		query.executeUpdate();

	}

	@SuppressWarnings("unchecked")
	public List<FileConfig> findParameterCollectionByAdd(FileConfig subject) {
		String hql = "from FileConfig where sysName = ? and fileName like ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getSysName()).setString(1,
				subject.getFileName());
		List<FileConfig> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<FileConfig> findParameterCollectionByUpdate(FileConfig subject) {
		String hql = "from FileConfig where uuid <> ? and sysName = ? and fileName like ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, subject.getUuid())
				.setString(1, subject.getSysName())
				.setString(2, subject.getFileName());
		List<FileConfig> list = query.list();
		return list;
	}

	@Override
	public List<FileConfig> findFile(String fileName) {
		String hql = "from FileConfig where  fileName like ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, fileName);
		List<FileConfig> list = query.list();
		return list;
	}
	
	public List<FileConfig> findAll() {
		String hql = "from FileConfig ";
		Query query = getSession().createQuery(hql);
		List<FileConfig> list = query.list();
		return list;
	}

	@Override
	public void updateState(int state,String id) {
		// TODO Auto-generated method stub
		String hql = "update FileConfig set isOrControl = ?  where  uuid = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, state).setParameter(1, id);
		query.executeUpdate();
	}

}
