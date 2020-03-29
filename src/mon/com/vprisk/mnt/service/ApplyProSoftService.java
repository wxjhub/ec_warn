package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ApplyProSoft;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 应用程序service接口类
 * 
 */
public interface ApplyProSoftService {
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
	 * @param pracol 参数对象
	 * @return 返回boolean值
	 */
	boolean saveOrUpdateCash(ApplyProSoft pracol);
	/**
	 * 根据通讯录参数ID查找相对应的对象信息
	 * @param detail 参数信息ID
	 * @return 返回对象结果集合
	 */
	List<ApplyProSoft> findParameterCollection(ApplyProSoft detail);
	/**
	 * 根据对象的ID删除管理对象信息
	 * @param uuid 参数信息ID
	 */
	void removeParameterCollectionByuuid(String uuid);
	/**
	 * 更新本级IP地址
	 * @param ip ip地址
	 */
	void updateApplyProSoftByIP(String ip);
	/**
	 * 查询对象集合信息
	 * @return
	 */
	List<ApplyProSoft> findApplyProSoft();
	/**
	 * 根据进程代码更新进程状态
	 * @param courseStatus 进程状态情况1：正常，0：异常
	 * @param courseCode 应用进程代码
	 * @return 无
	 */
	void updateApplyProSoftByCourseCode(int num,String courseStatus,String courseCode,String localIp);
	
	void insertModel(ApplyProSoft applyProSoft);


}
