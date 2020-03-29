package com.vprisk.etl.dao.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.etl.dao.BatchDao;
import com.vprisk.etl.model.Batch;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class BatchDaoImpl extends BaseDao<Batch> implements BatchDao {

	public Page selectBatchByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc) {
        Criteria c = getCriteria(Batch.class);
		
		String batchName = (String) params.get("batchName");
		String batchId = (String) params.get("batchId");
		
		if(StringUtil.isNotNullOrEmpty(batchName))
		{
			c.add(Restrictions.ilike("batchName", batchName, MatchMode.ANYWHERE));
		}
		if(StringUtil.isNotNullOrEmpty(batchId))
		{
			c.add(Restrictions.ilike("batchId", batchId, MatchMode.ANYWHERE));
		}
		if(orderBy!=null&& isAsc!=null){
			if (isAsc)
				c.addOrder(Order.asc(orderBy)); 
			else
				c.addOrder(Order.desc(orderBy));
		}else{
			c.addOrder(Order.asc("batchId"));
		}
		return pagedQuery(c, pageNo, pageSize);
	}
	
	public Batch selectBatchByBatchId(String batchId) {
		String hql = "from Batch t where t.batchId = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, batchId);
		Batch batch = (Batch) query.uniqueResult();
		return batch;
	}
	public Batch insertOrUpdateBatch(Batch batch) {
		super.insertOrUpdate(batch);
		return batch;
	}
	
	public void deleteBatchById(String uuid) {
		super.removeById(uuid);

	}
	public void deleteBatchByIds(String[] uuids) {
		super.bulkDelete("delete from Batchinfo t where t.uuid = ?", uuids);

	}


	public List<Batch> selectAllBatch() {
		String hql = "from Batch b order by b.uuid ";
		Query query = getSession().createQuery(hql);
		return query.list();
	}

	public Batch selectBatchById(String uuid) {
		/*String hql = "from Batch t where t.batchId = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0, batchId);
		Batch batch = (Batch) query.uniqueResult();
		return batch;*/
		 return selectBatchByUuid(uuid);
	}
	
	public Batch selectBatchByUuid(String uuid) {
		return super.get(uuid);
	}

	public List<Batch> selectRuningBatch() {
		String hql = "from Batch b where b.runFlag = '1' order by b.uuid ";
		Query query = getSession().createQuery(hql);
		List<Batch> list = query.list();
		return list;
	}

	@SuppressWarnings("unchecked")
	public List<Batch> selectTaskByTaskId() {
		String hql = "from Batch b";
		Query query = getSession().createQuery(hql);
		List<Batch> batchList = query.list();
		return batchList;
	}

	public void updateBatchRunStatus(String batchId, String runStatus) {

		String hql = "update Batch bs set bs.runFlag = ?  where bs.batchId = ?";
		Query query = getSession().createQuery(hql);
		query.setString(0, runStatus);
		query.setString(1, batchId);
		query.executeUpdate();
	}

	public void updateBatchendDate(String batchId, Date endDate) {
		String hql = "update Batch bs set endDate = ?,dataDate=? where bs.batchId = ?";
		Query query = getSession().createQuery(hql);
		query.setDate(0, endDate);
		query.setDate(1, endDate);
		query.setString(2, batchId);
		query.executeUpdate();
		/*String hql = "update ETL_SCHEDULE_batch bs set END_DATE = ? ,bs.AS_OF_DATE=?  where bs.batchId = ?";
		Query query = getSession().createSQLQuery(hql);
		query.setDate(0, endDate);
		query.setDate(1, endDate);
		query.setString(2, batchId);
		query.executeUpdate();*/
		
	}
	
	

}
