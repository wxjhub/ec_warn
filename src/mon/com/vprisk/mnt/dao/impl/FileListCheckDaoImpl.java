package com.vprisk.mnt.dao.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.dao.DataAccessResourceFailureException;

import com.vprisk.mnt.dao.FileListCheckDao;
import com.vprisk.mnt.entity.FileListCheck;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 关联系统List文件Dao层实现类
 */

public class FileListCheckDaoImpl extends BaseDao<FileListCheck>  implements FileListCheckDao{

	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		 Criteria c = getCriteria(FileListCheck.class);
			String soursesysName = (String) params.get("soursesysName"); //系统号
			String asOfDate = (String) params.get("asOfDate");//日期
			//判断接收到的查询条件信息是否空，并根据相关信息查询
			if(StringUtil.isNotNullOrEmpty(soursesysName)){
//				c.add(Restrictions.ilike("soursesysName", soursesysName, MatchMode.ANYWHERE));
				c.add(Restrictions.eq("soursesysName", soursesysName));
			}
			if(StringUtil.isNotNullOrEmpty(asOfDate))
			{
				Date dataDate = DateUtil.convertStringToDate(asOfDate,"yyyy-MM-dd");
//				c.add(Restrictions.eq("asOfDate", dataDate, MatchMode.ANYWHERE));
				c.add(Restrictions.eq("asOfDate", dataDate));
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
	public List<FileListCheck> selectFileListCheck() {
		String hql = "from FileListCheck";
		Query query = getSession().createQuery(hql);
		List<FileListCheck> list = query.list();
		return list;
	}


	public boolean updateFileListCheckByListNum(String string, int num, Date asOfDate) {
		boolean flag = false;
		String hql = "update FileListCheck set listNum = ?,asOfDate = ? where soursesysName = ?";
		try {
			Query query = getSession().createQuery(hql)
			.setInteger(0, num)
			.setDate(1, asOfDate)
			.setString(2, string);
			query.executeUpdate();
			flag = true;
		} catch (DataAccessResourceFailureException e) {
			e.printStackTrace();
		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (IllegalStateException e) {
			e.printStackTrace();
		}
		return flag;
	}


	public void updateFileListCheckByListSendNum2(String soursesysName, int num,int factNum, Date asOfDate) {
		String hql = "update FileListCheck set listSendNum = ?,factFileRecNum = ?,asOfDate = ? where soursesysName = ?";
		Query query = getSession().createQuery(hql)
		.setInteger(0, num)
		.setInteger(1, factNum)
		.setDate(2, asOfDate)
		.setString(3, soursesysName);
		query.executeUpdate();
	}
	
	public void updateFileListCheckByListSendNum(String soursesysName, int num,int factNum) {
		String hql = "update FileListCheck set listSendNum = ?,factFileRecNum = ? where soursesysName = ?";
		Query query = getSession().createQuery(hql)
		.setInteger(0, num)
		.setInteger(1, factNum)
		.setString(2, soursesysName);
		query.executeUpdate();
	}
	
	@SuppressWarnings("unchecked")
	public int  selectListNum(String soursesysName){
		String hql = "select listNum from FileListCheck where soursesysName=?";
		Query query = getSession().createQuery(hql).setString(0, soursesysName);
		List list = query.list();
		int count=0;
		if(!list.isEmpty()){
			  count = Integer.parseInt(list.get(0).toString());
		}else{
			count=0;
		}
		
		return count;
	}
	
	@SuppressWarnings("unchecked")
	public int  selectListNumSend(String soursesysName){
		String hql = "select listNumSend from FileListCheck where soursesysName=?";
		Query query = getSession().createQuery(hql).setString(0, soursesysName);
		List list = query.list();
		int count=0;
		if(!list.isEmpty()){
			count = Integer.parseInt(list.get(0).toString());
		}else{
			count=0;
		}
		
		return count;
	}
	
	@SuppressWarnings("unchecked")
	public int  selectListSendNum(String soursesysName){
		String hql = "select listSendNum from FileListCheck where soursesysName=?";
		Query query = getSession().createQuery(hql).setString(0, soursesysName);
		List list = query.list();
		int count=0;
		if(!list.isEmpty()){
			count = Integer.parseInt(list.get(0).toString());
		}else{
			count=0;
		}
		
		return count;
	}
	
	@SuppressWarnings("unchecked")
	public int  selectFactFileRecNum(String soursesysName){
		String hql = "select factFileRecNum from FileListCheck where soursesysName=?";
		Query query = getSession().createQuery(hql).setString(0, soursesysName);
		List list = query.list();
		int count=0;
		if(!list.isEmpty()){
			count = Integer.parseInt(list.get(0).toString());
		}else{
			count=0;
		}
		
		return count;
	}
	
}
