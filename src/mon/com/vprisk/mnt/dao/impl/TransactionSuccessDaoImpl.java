package com.vprisk.mnt.dao.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.ibm.icu.text.SimpleDateFormat;
import com.vprisk.mnt.dao.TransactionSuccessDao;
import com.vprisk.mnt.entity.TransactionSuccess;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * 交易成功率Dao层实现类
 * 
 */
public class TransactionSuccessDaoImpl extends BaseDao<TransactionSuccess>  implements TransactionSuccessDao{
	
	//交易时长
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		 Criteria c = getCriteria(TransactionSuccess.class);
			String transactionName = (String) params.get("transactionName"); //交易名称
			//String dataDate = (String) params.get("dataDate");// 开始时间
			//判断接收到的查询条件信息是否空，并根据相关信息查询
			if(StringUtil.isNotNullOrEmpty(transactionName)){
				c.add(Restrictions.ilike("transactionName", transactionName, MatchMode.ANYWHERE));
			}
			//if (StringUtil.isNotNullOrEmpty(dataDate)) {
			//	Date dataDate1 = DateUtil.convertStringToDate(dataDate, "yyyy-MM-dd");
			//	c.add(Restrictions.ge("dataDate", dataDate1));
			//	c.add(Restrictions.ilike("dataDate", dataDate, MatchMode.ANYWHERE));
			//}
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
	public  List<TransactionSuccess> selectParameterByPage(Map params) {
			String transactionName = (String) params.get("transactionName"); //系统
			String dataDate = (String) params.get("dataDate");// 数据日期
			
			String hql = "select max(uuid)as uuid, max(code) as code,max(code_name) as code_name,max(transaction_Name)as transaction_Name  from MNT_TRANSACTION_SUCCESS where  1=1 ";
			if(StringUtil.isNotNullOrEmpty(transactionName)){
				hql=hql+"and transaction_Name='"+transactionName+"'";
			}
			if(StringUtil.isNotNullOrEmpty(dataDate)){
				hql=hql+"and data_date='"+dataDate+"'";
			}
			hql=hql+"group by code ";
			Query query = super.getSession().createSQLQuery(hql);
			List<Object[]>  list = query.list();
			List<TransactionSuccess>TransactionSuccessList=new ArrayList <TransactionSuccess>();
			for(Object[] tr :list){
				TransactionSuccess trans=new TransactionSuccess();
				trans.setUuid((String)tr[0]);
				trans.setCode((String)tr[1]);
				trans.setCodeName((String)tr[2]);
				trans.setTransactionName((String)tr[3]);
				
				TransactionSuccessList.add(trans);
			}
			return TransactionSuccessList;
			
	}
		
			

	
	//查询响应码交易量（当天）
	public int selectSum(Map params,String code) {
		//String code = (String) params.get("code"); //响应码
		String transactionName = (String) params.get("transactionName"); //交易名称
		String dataDate = (String) params.get("dataDate");// 数据日期
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String str =sdf.format(dateStr);
		
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS where  code = '"+code+"' ";
		if(StringUtil.isNotNullOrEmpty(transactionName)){
			hql=hql+"and transaction_Name='"+transactionName+"'";
		}
		if(StringUtil.isNotNullOrEmpty(dataDate)){
			hql=hql+"and data_date='"+dataDate+"'";
		}else{
			hql=hql+"and data_date='"+str+"'";
		}
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	
	
	//查询交易量（当天）
	public int selectSum2(Map params) {
		String transactionName = (String) params.get("transactionName"); 
		String dataDate = (String) params.get("dataDate");// 数据日期
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String str =sdf.format(dateStr);
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS where 1=1";
		if(StringUtil.isNotNullOrEmpty(transactionName)){
			hql=hql+"and transaction_Name='"+transactionName+"'";
		}
		if(StringUtil.isNotNullOrEmpty(dataDate)){
			hql=hql+"and data_date='"+dataDate+"'";
		}else{
			hql=hql+"and data_date='"+str+"'";
		}
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	
	//查询响应码交易量（实时）
	public int selectSumNow(Map params, String code,String time) {
		String transactionName = (String) params.get("transactionName"); //系统
		String dataDate = (String) params.get("dataDate");// 数据日期
	
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS where code = '"+code+"' ";
		if(StringUtil.isNotNullOrEmpty(transactionName)){
			hql=hql+"and transaction_Name='"+transactionName+"'";
		}
		if(StringUtil.isNotNullOrEmpty(dataDate)){
			hql=hql+"and data_date='"+dataDate+"'";
		}else{
			hql=hql+"and start_date >=(select to_char(sysdate -interval '"+time+"' minute,'yyyy-mm-dd hh24:mi:ss') from dual )";
		}
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	
	

	
	//查询交易量（实时）
	public int selectSumNow2(Map params,String time) {
		String transactionName = (String) params.get("transactionName"); 
		String dataDate = (String) params.get("dataDate");// 数据日期
		
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS where 1=1";
		if(StringUtil.isNotNullOrEmpty(transactionName)){
			hql=hql+"and transaction_Name='"+transactionName+"'";
		}
		if(StringUtil.isNotNullOrEmpty(dataDate)){
			hql=hql+"and data_date='"+dataDate+"'";
		}else{
			hql=hql+"and start_date >=(select to_char(sysdate -interval '"+time+"' minute,'yyyy-mm-dd hh24:mi:ss') from dual )";
		}
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	
	

	@SuppressWarnings("unchecked")
	public  List<TransactionSuccess> selectTimeParameterByPage(Map params) {
			String transactionName = (String) params.get("transactionName"); //系统
			String dataDate = (String) params.get("dataDate");// 数据日期
			
			String hql = "select  uuid,code,code_name,seq_no,business_id,transaction_Name,data_date,start_date,end_date,col1,col2,col3 from MNT_TRANSACTION_SUCCESS where  1=1 ";
			if(StringUtil.isNotNullOrEmpty(transactionName)){
				hql=hql+"and transaction_Name='"+transactionName+"'";
			}
			if(StringUtil.isNotNullOrEmpty(dataDate)){
				hql=hql+"and data_date='"+dataDate+"'";
			}
			Query query = super.getSession().createSQLQuery(hql);
			List<Object[]>  list = query.list();
			List<TransactionSuccess>TransactionSuccessList=new ArrayList <TransactionSuccess>();
			for(Object[] tr :list){
				TransactionSuccess trans=new TransactionSuccess();
				trans.setUuid((String)tr[0]);
				trans.setCode((String)tr[1]);
				trans.setCodeName((String)tr[2]);
				trans.setSeqNo((String)tr[3]);
				trans.setBusinessId((String)tr[4]);
				trans.setTransactionName((String)tr[5]);
				trans.setDataDate((String)tr[6]);
				trans.setStartDate((String)tr[7]);
				trans.setEndDate((String)tr[8]);
				trans.setCol1((String)tr[9]);
				trans.setCol2((String)tr[10]);
				trans.setCol3((String)tr[11]);
				TransactionSuccessList.add(trans);
			}
			return TransactionSuccessList;
	}
	
	@SuppressWarnings("unchecked")
	public  List<TransactionSuccess> selectRransactionEndList(Map params) {
			String transactionName = (String) params.get("transactionName"); //交易名称
			
			String hql = " select UUID,Transaction_Code,Transaction_Name,seq_No,start_date,sys_code "
					+ "from  MNT_TRANSACTION_SUCCESS t "
					+ "where t.start_date in (select Max(start_date)from MNT_TRANSACTION_SUCCESS t where 1=1";
			if(StringUtil.isNotNullOrEmpty(transactionName)){
				hql=hql+" and t.transaction_Name like '%"+transactionName+"%'";
			}
			hql=hql+")";
			Query query = super.getSession().createSQLQuery(hql);
			List<Object[]>  list = query.list();
			List<TransactionSuccess>TransactionSuccessList=new ArrayList <TransactionSuccess>();
			for(Object[] tr :list){
				TransactionSuccess trans=new TransactionSuccess();
				trans.setUuid((String)tr[0]);
				trans.setTransactionCode((String)tr[1]);
				trans.setTransactionName((String)tr[2]);
				trans.setSeqNo((String)tr[3]);
				trans.setStartDate((String)tr[4]);
				trans.setSysCode((String)tr[5]);
				TransactionSuccessList.add(trans);
			}
			return TransactionSuccessList;
			
	}
	
	
	public  List<TransactionSuccess> selectParameterByPage() {
		String hql = "select max(uuid)as uuid, max(code) as code,max(code_name) as code_name,max(transaction_Name)as transaction_Name "
				+ " from MNT_TRANSACTION_SUCCESS  "
				+ " group by code ";
		Query query = super.getSession().createSQLQuery(hql);
		List<Object[]>  list = query.list();
		List<TransactionSuccess>TransactionSuccessList=new ArrayList <TransactionSuccess>();
		for(Object[] tr :list){
			TransactionSuccess trans=new TransactionSuccess();
			trans.setUuid((String)tr[0]);
			trans.setCode((String)tr[1]);
			trans.setCodeName((String)tr[2]);
			trans.setTransactionName((String)tr[3]);
			
			TransactionSuccessList.add(trans);
		}
		return TransactionSuccessList;
		
}
	
	public int selectSum(String code) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String str =sdf.format(dateStr);
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS "
				+ "where  code = '"+code+"' and data_date='"+str+"'";
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	public int selectSum2() {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String str =sdf.format(dateStr);
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS "
				+ "where  data_date='"+str+"'";
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	public int selectSumNow( String code,String time) {
	
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS "
				   + " where code = '"+code+"' ";
			hql+="and start_date >=(select to_char(sysdate -interval '"+time+"' minute,'yyyy-mm-dd hh24:mi:ss') from dual )";
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	public int selectSumNow2(String time) {
		
		String hql = " select count（*）from MNT_TRANSACTION_SUCCESS";
		hql+=" where start_date >=(select to_char(sysdate -interval '"+time+"' minute,'yyyy-mm-dd hh24:mi:ss') from dual )";
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int sum = Integer.parseInt(list.get(0).toString());
		return sum;
		
	}
	
	public  List<TransactionSuccess> selectRransactionEndList() {
		
		String hql = " select UUID,Transaction_Code,Transaction_Name,seq_No,start_date,sys_code "
				+ "from  MNT_TRANSACTION_SUCCESS t "
				+ "where t.start_date in (select Max(start_date)from MNT_TRANSACTION_SUCCESS t )";
		Query query = super.getSession().createSQLQuery(hql);
		List<Object[]>  list = query.list();
		List<TransactionSuccess>TransactionSuccessList=new ArrayList <TransactionSuccess>();
		for(Object[] tr :list){
			TransactionSuccess trans=new TransactionSuccess();
			trans.setUuid((String)tr[0]);
			trans.setTransactionCode((String)tr[1]);
			trans.setTransactionName((String)tr[2]);
			trans.setSeqNo((String)tr[3]);
			trans.setStartDate((String)tr[4]);
			trans.setSysCode((String)tr[5]);
			TransactionSuccessList.add(trans);
		}
		return TransactionSuccessList;
		
}
	
	
	public List<TransactionSuccess> selectParameterCollectiondByPage() {
			String hql = "select uuid,code,code_name,seq_no,business_id,transaction_code,transaction_Name,data_date,start_date,end_date,col1,col2,col3   from MNT_TRANSACTION_SUCCESS  ";
			Query query = super.getSession().createSQLQuery(hql);
			List<Object[]>  list = query.list();
			List<TransactionSuccess>TransactionSuccessList=new ArrayList <TransactionSuccess>();
			for(Object[] tr :list){
				TransactionSuccess trans=new TransactionSuccess();
				trans.setUuid((String)tr[0]);
				trans.setCode((String)tr[1]);
				trans.setCodeName((String)tr[2]);
				trans.setSeqNo((String)tr[3]);
				trans.setBusinessId((String)tr[4]);
				trans.setTransactionCode((String)tr[5]);
				trans.setTransactionName((String)tr[6]);
				trans.setDataDate((String)tr[7]);
				trans.setStartDate((String)tr[8]);
				trans.setEndDate((String)tr[9]);
				trans.setCol1((String)tr[10]);
				trans.setCol2((String)tr[11]);
				trans.setCol3((String)tr[12]);
				TransactionSuccessList.add(trans);
			}
			return TransactionSuccessList;
			
	}
	
	public String selectDay(int day) {
		String hql = "select to_char((select sysdate-"+day+" from dual),'yyyy-mm-dd') from dual";
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		String  dateday ="";
		if(null !=list && list.size()!=0){
			dateday = (String) list.get(0);
		}
		return dateday;
	}
	public int selectDayofNums(String dateday) {
		String hql = "select count(*) from MNT_TRANSACTION_SUCCESS t "
				+ "where t.Data_Date in ('"+dateday+"')";
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int count =0;
		if(null !=list && list.size()!=0){
			 count = Integer.parseInt(list.get(0).toString());
		}
		return count;
	}
	
	
	
	public int selectNums(int hour) {
		Date dateStr = new Date();
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		String str =sdf.format(dateStr);
		int hour2 = hour + 1;
		String shour="";
		String shour2="";
		if(hour<9){
			 shour="0"+hour;
			 shour2="0"+hour2;
		}else if(hour ==9){
			 shour="0"+hour;
			 shour2=""+hour2;
		}else{
			 shour=""+hour;
			 shour2=""+hour2;
		}
		String hql = "select count(*)"
				+ " from MNT_TRANSACTION_SUCCESS t "
				+ "where t.Data_Date='"+ str + "'";
		hql += "and t.start_date between '" + str + " " + shour+ ":00:00' "
				+ "and  '" + str + " " + shour2 + ":00:00'";
		Query query = super.getSession().createSQLQuery(hql);
		List list = query.list();
		int count =0;
		if(null !=list && list.size()!=0){
			 count = Integer.parseInt(list.get(0).toString());
		}
		return count;
	}
	
	

}



