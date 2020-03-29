package com.vprisk.mnt.dao.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.BookParamDao;
import com.vprisk.mnt.entity.BookParam;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 通讯录参数Dao层实现类
 */
public class BookParamDaoImpl extends BaseDao<BookParam>  implements BookParamDao{
	@SuppressWarnings("unchecked")
	public List<BookParam> findParameterCollectionByUpdate(BookParam subject) {
		String hql = "from BookParam where uuid <> ? and bookTele = ? and warnSort =?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getUuid())
		.setString(1, subject.getBookTele()).setString(2, subject.getWarnSort());
		List<BookParam> list = query.list();
		return list;
	}


	@SuppressWarnings("unchecked")
	public List<BookParam> findParameterCollectionByAdd(BookParam subject) {
		String hql = "from BookParam where bookTele = ? and warnSort =?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,subject.getBookTele()).setString(1, subject.getWarnSort());
		List<BookParam> list = query.list();
		return list;
	}


	public void removeParameterCollectionByuuid(String uuid) {
		String hql = "delete BookParam where uuid = ?";
		Query query = getSession().createQuery(hql);//
		query.setParameter(0,uuid);
		query.executeUpdate();
		
	}


	public boolean saveOrUpdateCash(BookParam pracol) {
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
		 Criteria c = getCriteria(BookParam.class);
			String bookName = (String) params.get("bookName"); //姓名
			String bookWarnLvl = (String) params.get("bookWarnLvl") ;//预警级别
			if(StringUtil.isNotNullOrEmpty(bookWarnLvl)){
				Integer num = Integer.parseInt(bookWarnLvl);
				//判断接收到的查询条件信息是否空，并根据相关信息查询
				c.add(Restrictions.eq("bookWarnLvl", num));
			}
			if(StringUtil.isNotNullOrEmpty(bookName)){
				c.add(Restrictions.ilike("bookName", bookName, MatchMode.ANYWHERE));
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
	public List<BookParam> findBookParam() {
		String hql = "from BookParam";
		Query query = getSession().createQuery(hql);
		List<BookParam> vpdm= (List<BookParam>)query.list();
		return vpdm;
	}


	@SuppressWarnings("unchecked")
	public List<BookParam> selectBookParamByWarnLvl(int warningLevl) {
//		String hql = "from BookParam where bookWarnLvl=?";
//		Query query = getSession().createQuery(hql);
//		query.setInteger(0,warningLevl);
////		.setString(1, detail.getSrccodeval());
//		List<BookParam> list= query.list();
//		return list;
		String hql = "";
		if(warningLevl==1) {
			hql = "from BookParam where bookWarnLvl=?";
		}
		if(warningLevl==2) {
			hql = "from BookParam where bookWarnLvl in (1,2) ";
		}
		if(warningLevl==3) {
			hql = "from BookParam where bookWarnLvl in (1,2,3) ";
		}
		Query query = getSession().createQuery(hql);
//		query.setInteger(0,warningLevl).setString(1, warnSort);
		if(warningLevl==1) {
			query.setInteger(0,warningLevl);
		}
		List<BookParam> list= query.list();
		return list;
	}

	// 根据应用进程预警级别和预警分类，查询相关联的预警人员
	public List<BookParam> selectBookParam(int warningLevl,String warnSort) {
		String hql = "";
		if(warningLevl==1) {
			hql = "from BookParam where bookWarnLvl=? and warnSort=? ";
		}
		if(warningLevl==2) {
			hql = "from BookParam where bookWarnLvl in (1,2) and warnSort=? ";
		}
		if(warningLevl==3) {
			hql = "from BookParam where bookWarnLvl in (1,2,3) and warnSort=? ";
		}
		Query query = getSession().createQuery(hql);
//		query.setInteger(0,warningLevl).setString(1, warnSort);
		if(warningLevl==1) {
			query.setInteger(0,warningLevl).setString(1, warnSort);
		} else {
			query.setString(0, warnSort);
		}
		List<BookParam> list= query.list();
		return list;
	}
	
	
	@SuppressWarnings("unchecked")
	public List<BookParam> findBookParamByNote(String note) {
		String hql = "from BookParam where bookName=?";
		Query query = getSession().createQuery(hql);
		query.setString(0,note);
//		.setString(1, detail.getSrccodeval());
		List<BookParam> list= query.list();
		return list;
	}

}
