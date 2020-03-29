package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 报警历史Dao层实现接口类
 */

public interface WarnHistoryDao {
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
	//历史报警
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage2(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	/**
	 * 保存新增或修改的对象信息
	 * @param pracol对象信息
	 * @return 返回boolean值
	 */
	boolean saveOrUpdateCash(WarnHistory pracol);
	/**
	 * 通过Id修改处理状态
	 * @param id 主键Id
	 */
	void handleStateById(String id);
	/**
	 * 插入当前历史预警信息
	 * @param warnhistory 需要插入的信息对象
	 * @author yanggaolei
	 * @return 无返回值
	 */
	void insertIntoWarnHistory(WarnHistory warnhistory);
	
	
	/**
	 * 通过应用Id和预警类别  查询应用是否在预警中
	 * @param id 主键Id
	 */

	List<WarnHistory> handleStateByCourseCode(String recordName,String pointName, String pointIp, String warnSort);

	
	//更新当前历史预警信息
	void updateWarnHistory(String id);
	
	
	void updateConfirmation(Map params,String userName, String userOrganName);
	
	/**
	 * 根据参数查询数据
	 * @param param
	 * @return
	 */
	List<WarnHistory> selectWarnHistoryByParam(Map param);
}
