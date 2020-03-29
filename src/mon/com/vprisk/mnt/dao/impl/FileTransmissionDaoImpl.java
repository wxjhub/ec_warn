package com.vprisk.mnt.dao.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.FileTransmissionDao;
import com.vprisk.mnt.entity.FileTransmission;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 文件传输监控Dao层实现类
 * 
 */
public class FileTransmissionDaoImpl extends BaseDao<FileTransmission> implements
		FileTransmissionDao {

	
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(FileTransmission.class);
		String fileName = (String) params.get("fileName");// 文件名称
		//String sendSystem = (String) params.get("sendSystem");// 发送系统
		//String getSystem = (String) params.get("getSystem");// 接受系统
		String sourseSys = (String) params.get("sourseSys");//系统sourseSys
		String tranStat = (String) params.get("tranStat");// 传输状态
		String startDate = (String) params.get("startDate");// 开始时间
		String endDate = (String) params.get("endDate");// 结束时间
		String tranType = (String) params.get("tranType");// 传输类型
		// 判断接收到的查询条件信息是否空，并根据相关信息查询

		if (StringUtil.isNotNullOrEmpty(fileName)) {
			c.add(Restrictions.ilike("fileName", fileName, MatchMode.ANYWHERE));
		}
		if (StringUtil.isNotNullOrEmpty(sourseSys)) {
			c.add(Restrictions.eq("sourseSys", sourseSys));
		}
		/*if (StringUtil.isNotNullOrEmpty(getSystem)) {
			c.add(Restrictions.eq("getSystem", getSystem));
		}*/
		if (StringUtil.isNotNullOrEmpty(tranStat)) {
			c.add(Restrictions.eq("tranStat", tranStat));
		}
		if (StringUtil.isNotNullOrEmpty(startDate)) {
			Date startDate1 = DateUtil.convertStringToDate(startDate, "yyyy-MM-dd");
			c.add(Restrictions.ge("dataDate", startDate1));
		}
		if (StringUtil.isNotNullOrEmpty(endDate)) {
			Date endDate1 = DateUtil.convertStringToDate(endDate, "yyyy-MM-dd");
			c.add(Restrictions.le("dataDate", endDate1));
		}
		if (StringUtil.isNotNullOrEmpty(tranType)) {
			c.add(Restrictions.eq("tranType", tranType));
		}
		if(StringUtil.isNullOrEmpty(startDate)&&StringUtil.isNullOrEmpty(endDate)) {
			Date date = new Date();
			Calendar s = Calendar.getInstance();
			s.setTime(date);
			s.add(Calendar.DATE,-7);
			c.add(Restrictions.gt("dataDate", s.getTime()));
		}
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}
	
	public List<FileTransmission> findFileTransmission() {
		String hql = "from FileTransmission";
		Query query = getSession().createQuery(hql);
		List<FileTransmission> ftList = query.list();
		return ftList;
	}
	public List<FileTransmission> findFileTransmission(String tranType) {
		String hql = "from FileTransmission where tranType =? ";
		Query query = getSession().createQuery(hql).setString(0, tranType);
		List<FileTransmission> ftList = query.list();
		return ftList;
	}
	
	//发送
	@SuppressWarnings("unchecked")
	public int  findFileNumBySendSystem(String sysName, Date datedata){
		String hql = "from FileTransmission where sourseSys = ?  and dataDate = ? and tranType=1 ";
		Query query = getSession().createQuery(hql)
				.setString(0, sysName).setDate(1, datedata);
				List<String> list = query.list();
		return list.size();
	}
	
	
	//接收
	@SuppressWarnings("unchecked")
	public int  findFileNumByGetSystem(String sysName, Date datedata){
		String hql = "from FileTransmission where sourseSys = ? and dataDate = ? and tranType=0 ";
		Query query = getSession().createQuery(hql)
				.setString(0, sysName).setDate(1, datedata);
				List<String> list = query.list();
		return list.size();
	}
	
	public String findZt(String FileName,Date DataDate){
		//String hql="select Max(tranStartTime)tranStat from FileTransmission where fileName=? and dataDate=?";
		//String hql="select Max(tranStartTime)from FileTransmission where fileName=? and dataDate=? group by dataDate";
		String hql="select tranStat from FileTransmission where tranStartTime=(select Max(tranStartTime)from FileTransmission where fileName=? and dataDate=? group by dataDate)";
		Query query = getSession().createQuery(hql)
				.setString(0, FileName)
				.setDate(1, DataDate);
		List<String> list = query.list();
		return list.get(0);
	}
	
	
}
