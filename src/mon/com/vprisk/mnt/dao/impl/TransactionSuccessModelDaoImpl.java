package com.vprisk.mnt.dao.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;

import com.vprisk.mnt.dao.TransactionSuccessModelDao;
import com.vprisk.mnt.entity.TransactionSuccessModel;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.util.StringUtil;


public class TransactionSuccessModelDaoImpl extends BaseDao<TransactionSuccessModel>  implements TransactionSuccessModelDao{

	@Override
	public void insertModel(TransactionSuccessModel model) {
		super.insertOrUpdate(model);
	}

	@Override
	public List<TransactionSuccessModel> statistics(Map params) {
		
		String transactionName = (String) params.get("transactionName"); 
		String startDate = (String) params.get("startDate");
		String endDate = (String) params.get("endDate");
		
		String hql = " select t.execute_date,t.transaction_name,t.code,t.code_name, t.execute_type,t.transaction_num,t.transaction_sum_num,t.ratio"
				+ " from MNT_TRANSACTION_SUCCESS_MODEL t where 1=1 ";
		if(StringUtil.isNotNullOrEmpty(transactionName)){
			hql=hql+"and t.transaction_Name='"+transactionName+"'";
		}
		if(StringUtil.isNotNullOrEmpty(startDate) && StringUtil.isNotNullOrEmpty(endDate)){
			hql=hql+"and t.execute_date between '"+startDate+"' and '"+endDate+"'";
		}else if(StringUtil.isNotNullOrEmpty(startDate)&& (endDate ==null||endDate =="") ){
			hql=hql+"and t.execute_date >= '"+startDate+"'";
		}
		Query query = super.getSession().createSQLQuery(hql);
		List<Object[]> list = query.list();
		List<TransactionSuccessModel> TransactionSuccessList = new ArrayList<TransactionSuccessModel>();
		for (Object[] tr : list) {
			TransactionSuccessModel trans = new TransactionSuccessModel();
			trans.setExecuteDate((String) tr[0]);
			trans.setTransactionName((String) tr[1]);
			trans.setCode((String) tr[2]);
			trans.setCodeName((String) tr[3]);
			trans.setExecuteType((String) tr[4]);
			trans.setTransactionNum((String) tr[5]);
			trans.setTransactionSumNum((String) tr[6]);
			trans.setRatio((String) tr[7]);

			TransactionSuccessList.add(trans);
		}
		return TransactionSuccessList;
	}
	
}



