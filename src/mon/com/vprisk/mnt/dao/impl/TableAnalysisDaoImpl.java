package com.vprisk.mnt.dao.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.TableAnalysisDao;
import com.vprisk.mnt.entity.TableAnalysis;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class TableAnalysisDaoImpl extends BaseDao<TableAnalysis> implements TableAnalysisDao {
	
	@SuppressWarnings("unchecked")
	public Page findList(Map params) {
		String tableName = (String) params.get("tableName");
		int pageSize = Integer.parseInt((String) params.get("rows")); 
		int pageNo =  Integer.parseInt((String) params.get("page")); 
		//String hql = "select a.tablespace_name,a.table_name,a.last_analyzed,a.sample_size from user_tables a order by a.last_analyzed desc";
		String hql = "select a.tablespace_name,a.table_name,to_char(a.last_analyzed,'yyyy-mm-dd hh24:mi:ss'),a.sample_size"
				+ " from user_tables a ";
		if(StringUtil.isNotNullOrEmpty(tableName)){
			hql+= " where a.table_name= '"+tableName+"'";
		}	
		hql+= " order by a.last_analyzed desc";
		
		Query query = super.getSession().createSQLQuery(hql);
		List<Object[]> totalvpdmList = query.list();
		List<TableAnalysis> SqlBlockList = new ArrayList<TableAnalysis>();
		query.setFirstResult(pageSize*(pageNo - 1));
		query.setMaxResults(pageSize);
		List<Object[]> vpdmList = query.list();
		for (Object[] vpdm : vpdmList) {
			TableAnalysis sqlB = new TableAnalysis();
			sqlB.setTablespaceName((String) vpdm[0]);
			sqlB.setTableName((String) vpdm[1]);
			sqlB.setLastAnalyzed((String) vpdm[2]);
			sqlB.setSampleSize(  (BigDecimal)vpdm[3]);
			SqlBlockList.add(sqlB);
		}
		Page page = new Page();
		page.setData(SqlBlockList);
		page.setPageNo(pageNo);
		page.setPageSize(pageSize);
		page.setTotalCount(totalvpdmList.size());
		return page;
	}

	
	public int selectTableSize(String tableName) {
		String hql = "select count(1) from  "+tableName;
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}


	@Override
	public void insertModel(TableAnalysis tableAnalysis) {
		super.insertOrUpdate(tableAnalysis);
		
	}
	
	
	public List<TableAnalysis> findList() {
		String hql = "select a.tablespace_name,a.table_name,to_char(a.last_analyzed,'yyyy-mm-dd hh24:mi:ss'),a.sample_size"
				+ " from user_tables a ";
		hql+= " order by a.last_analyzed desc";
		
		Query query = super.getSession().createSQLQuery(hql);
		List<TableAnalysis> SqlBlockList = new ArrayList<TableAnalysis>();
		List<Object[]> vpdmList = query.list();
		for (Object[] vpdm : vpdmList) {
			TableAnalysis sqlB = new TableAnalysis();
			sqlB.setTablespaceName((String) vpdm[0]);
			sqlB.setTableName((String) vpdm[1]);
			sqlB.setLastAnalyzed((String) vpdm[2]);
			sqlB.setSampleSize(  (BigDecimal)vpdm[3]);
			SqlBlockList.add(sqlB);
		}
		return SqlBlockList;
	}


	@Override
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		String tableName = (String) params.get("tableName");
		Criteria c = getCriteria(TableAnalysis.class);
		if(StringUtil.isNotNullOrEmpty(tableName)){
			c.add(Restrictions.eq("tableName", tableName));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}

}
