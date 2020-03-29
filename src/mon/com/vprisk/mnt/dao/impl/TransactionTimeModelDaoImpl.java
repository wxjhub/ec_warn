package com.vprisk.mnt.dao.impl;

import java.util.List;

import org.hibernate.Query;

import com.vprisk.mnt.dao.TransactionTimeModelDao;
import com.vprisk.mnt.entity.TransactionTimeModel;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;


public class TransactionTimeModelDaoImpl extends BaseDao<TransactionTimeModel>  implements TransactionTimeModelDao{

	@Override
	public void insertModel(TransactionTimeModel model) {
		super.insertOrUpdate(model);
	}

	@Override
	public List<TransactionTimeModel> selectSeqNo(String seqNo) {
		String hql = "from TransactionTimeModel where seqNo = ? ";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,seqNo)	;
		List<TransactionTimeModel> list = query.list();
		return list;
	}
	
	
}



