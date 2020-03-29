package com.vprisk.mnt.dao.impl;

import java.util.List;

import org.hibernate.Query;

import com.vprisk.mnt.dao.TransactionNoTradeModelDao;
import com.vprisk.mnt.entity.TransactionNoTradeModel;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;


public class TransactionNoTradeModelDaoImpl extends BaseDao<TransactionNoTradeModel>  implements TransactionNoTradeModelDao{

	@Override
	public void insertModel(TransactionNoTradeModel model) {
		super.insertOrUpdate(model);
	}

	@Override
	public List<TransactionNoTradeModel> selectSeqNo(String seqNo) {
		String hql = "from TransactionNoTradeModel where seqNo = ? ";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,seqNo)	;
		List<TransactionNoTradeModel> list = query.list();
		return list;
	}
	
	
}



