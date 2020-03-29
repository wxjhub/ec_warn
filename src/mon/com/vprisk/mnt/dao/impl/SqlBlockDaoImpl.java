package com.vprisk.mnt.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;

import com.ibm.icu.text.SimpleDateFormat;
import com.vprisk.mnt.dao.SqlBlockDao;
import com.vprisk.mnt.entity.SqlBlock;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.util.StringUtil;


/**
 *  sql阻塞Dao层实现类
 */
public class SqlBlockDaoImpl extends BaseDao<SqlBlock>  implements  SqlBlockDao{
	@SuppressWarnings("unchecked")
	public List<SqlBlock> findSqlBlock(Map params) {
		String username = (String) params.get("username"); 
		
		String sql = "select username,sid,event,sql_id,command,blocking_instance,blocking_session,last_call_et,status,wait_class from v$session "
				//+ "where status=? and wait_class <> ?";
				+ "where status='ACTIVE' and wait_class <> 'Idle'";
			if(StringUtil.isNotNullOrEmpty(username)){
			sql=sql+"and   username='"+username+"'";
		}
		Query query = super.getSession().createSQLQuery(sql);
		//query.setParameter(0,"'ACTIVE'").setParameter(1, "'Idle'");
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str =sdf.format(dateStr);
		List<Object[]> vpdmList= query.list();
		List<SqlBlock> SqlBlockList=new ArrayList <SqlBlock>();
		for (Object[] vpdm : vpdmList) {
			SqlBlock sqlB=new  SqlBlock();
			sqlB.setUsername((String) vpdm[0]);
			sqlB.setSid(vpdm[1].toString());
			sqlB.setEvent((String) vpdm[2]);
			sqlB.setSqlId((String) vpdm[3]);
			sqlB.setCommand( vpdm[4].toString());
			sqlB.setBlockingInstance((String) vpdm[5]);
			sqlB.setBlockingSession((String) vpdm[6]);
			sqlB.setLastCallEt(vpdm[7].toString());
			sqlB.setStatus((String) vpdm[8]);
			sqlB.setWaitClass((String) vpdm[9]);
			sqlB.setCollectDate(str);
			SqlBlockList.add(sqlB);
		}
		return SqlBlockList;
	}
	
	


	public void insertModel(SqlBlock sqlBlock) {
		super.insertOrUpdate(sqlBlock);
		
	}
	
	
	
	public List<SqlBlock> findSqlBlock() {
		
		String sql = "select username,sid,event,sql_id,command,blocking_instance,blocking_session,last_call_et,status,wait_class from v$session "
				//+ "where status=? and wait_class <> ?";
				+ "where status='ACTIVE' and wait_class <> 'Idle'";
		Query query = super.getSession().createSQLQuery(sql);
		//query.setParameter(0,"'ACTIVE'").setParameter(1, "'Idle'");
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String str =sdf.format(dateStr);
		List<Object[]> vpdmList= query.list();
		List<SqlBlock> SqlBlockList=new ArrayList <SqlBlock>();
		for (Object[] vpdm : vpdmList) {
			SqlBlock sqlB=new  SqlBlock();
			sqlB.setUsername((String) vpdm[0]);
			sqlB.setSid(vpdm[1].toString());
			sqlB.setEvent((String) vpdm[2]);
			sqlB.setSqlId((String) vpdm[3]);
			sqlB.setCommand( vpdm[4].toString());
			sqlB.setBlockingInstance((String) vpdm[5]);
			sqlB.setBlockingSession((String) vpdm[6]);
			sqlB.setLastCallEt(vpdm[7].toString());
			sqlB.setStatus((String) vpdm[8]);
			sqlB.setWaitClass((String) vpdm[9]);
			sqlB.setCollectDate(str);
			SqlBlockList.add(sqlB);
		}
		return SqlBlockList;
	}
}
