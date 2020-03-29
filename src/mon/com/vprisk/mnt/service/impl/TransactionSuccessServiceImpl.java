package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.TransactionSuccessDao;
import com.vprisk.mnt.entity.TransactionSuccess;
import com.vprisk.mnt.service.TransactionSuccessService;
import com.vprisk.rmplatform.dao.support.Page;


public class TransactionSuccessServiceImpl implements TransactionSuccessService {
	private TransactionSuccessDao trasactionSuccessDao;
	
	public TransactionSuccessDao getTransactionSuccessDao() {
		return trasactionSuccessDao;
	}
	public void setTransactionSuccessDao(TransactionSuccessDao TransactionSuccessDao) {
		this.trasactionSuccessDao = TransactionSuccessDao;
	}
	
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return trasactionSuccessDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	@SuppressWarnings("unchecked")
	public  List<TransactionSuccess> selectParameterByPage(Map params) {
		return trasactionSuccessDao.selectParameterByPage(params);
	}

	// 响应码全天交易量
	public int selectSum(Map params, String code) {
		return trasactionSuccessDao.selectSum(params,code);

	}

	// 全天交易量
	public int selectSum2(Map params) {
		return trasactionSuccessDao.selectSum2(params);

	}

	// 响应码实时交易量
	public int selectSumNow(Map params, String code,String time) {
		return trasactionSuccessDao.selectSumNow(params, code,time);

	}

	// 实时交易量
	public int selectSumNow2(Map params,String time) {
		return trasactionSuccessDao.selectSumNow2(params,time);

	}

	//长时间无交易监控
	@SuppressWarnings("unchecked")
	public  List<TransactionSuccess> selectRransactionEndList(Map params) {
		return trasactionSuccessDao.selectRransactionEndList(params);
	}

	
	
	public  List<TransactionSuccess> selectParameterByPage() {
		return trasactionSuccessDao.selectParameterByPage();
	}
	public int selectSum(String code) {
		return trasactionSuccessDao.selectSum(code);

	}
	public int selectSum2() {
		return trasactionSuccessDao.selectSum2();

	}
	public int selectSumNow( String code,String time) {
		return trasactionSuccessDao.selectSumNow( code,time);

	}

	// 实时交易量
	public int selectSumNow2(String time) {
		return trasactionSuccessDao.selectSumNow2(time);

	}
	
	public  List<TransactionSuccess> selectRransactionEndList() {
		return trasactionSuccessDao.selectRransactionEndList();
	}
	
	public List<TransactionSuccess> selectParameterCollectiondByPage() {
		return trasactionSuccessDao.selectParameterCollectiondByPage();
	}
	
	public String selectDay(int day){
		return trasactionSuccessDao.selectDay(day);
	}
	public int selectDayofNums(String dateday){
		return trasactionSuccessDao.selectDayofNums(dateday);
	}
	public int selectNums(int hour){
		return trasactionSuccessDao.selectNums(hour);
	}
	
	
}
