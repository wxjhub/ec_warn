package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.TransactionSuccess;
import com.vprisk.rmplatform.dao.support.Page;
/**
 * 交易成功率Dao层实现接口类
 */
public interface TransactionSuccessDao {
	/**
	 * 分页查询参数信息
	 * @param params 分页传递参数信息集合
	 * @param pageNo 页码
	 * @param pageSize 页行数
	 * @param orderBy 排序的属性
	 * @param isAsc 排序方式
	 * @return 分页信息
	 */
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	
	@SuppressWarnings("unchecked")
	List<TransactionSuccess> selectParameterByPage(Map params);
	
	// 响应码全天交易量
	int selectSum(Map params, String code);

	// 全天交易量
	int selectSum2(Map params);

	// 响应码实时交易量
	int selectSumNow(Map params, String code,String time);

	// 实时交易量
	int selectSumNow2(Map params,String time);
	//长时间无交易
	@SuppressWarnings("unchecked")
	List<TransactionSuccess> selectRransactionEndList(Map params);
	
	
	List<TransactionSuccess> selectParameterByPage();
	int selectSum( String code);
	int selectSum2();
	int selectSumNow( String code,String time);
	int selectSumNow2(String time);
	List<TransactionSuccess> selectRransactionEndList();
	List<TransactionSuccess>  selectParameterCollectiondByPage();
	String selectDay(int day);
	int selectDayofNums(String dateday);
	int selectNums(int hour);
}
