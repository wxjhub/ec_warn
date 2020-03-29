package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.WarnInterval;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 预警时间间隔service接口类
 */
public interface WarnIntervalService {
	/**
	 * 获得预警时间间隔设置集合
	 * @param warnName 预警名称
	 * @return 返回预警时间间隔设置集合
	 */
	public List<WarnInterval> findItemsByName(String warnName);

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
	/**
	 * 保存新增或者修改的对象
	 * @param pracol 通讯录参数对象
	 * @return 返回boolean值
	 */
	boolean saveOrUpdateCash(WarnInterval pracol);
	/**
	 * 根据预警时间代码查询对应关联的预警时间
	 * @param warnCode 预警时间间隔代码
	 * @author yanggaolei
	 * @date 2015-5-19（新增）
	 * @return 返回预警时间间隔对象
	 */
	public WarnInterval findWarnIntervalByWarnCode(String warnCode);
	/**
	 * 根据预警时间代码更新对应关联的对象预警时间
	 * @param warnCode 预警时间间隔代码
	 * @param datedata 预警时间
	 * @author yanggaolei
	 * @date 2015-5-29（新增）
	 * @return 无
	 */
	public void updateWarnIntervalByWarnCode(String warnCode,String datedata);
	
	
	/**
	 * 根据对象的ID删除管理对象信息
	 * @param uuid 参数信息ID
	 */
	void removeParameterCollectionByuuid(String uuid);

}
