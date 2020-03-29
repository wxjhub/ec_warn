package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ExternalNetWork;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 网络监控维护service接口类
 * 
 */
public interface ExternalNetWorkService {
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
	 * @param pracol 网络监控参数对象
	 * @return 返回boolean值
	 */
	boolean saveOrUpdateCash(ExternalNetWork pracol);
	/**
	 * 根据网络监控参数ID查找相对应的对象信息
	 * @param detail 网络监控参数信息ID
	 * @return 返回对象结果集合
	 */
	List<ExternalNetWork> findParameterCollection(ExternalNetWork detail);
	/**
	 * 根据对象的ID删除管理对象信息
	 * @param uuid 网络监控参数信息ID
	 */
	void removeParameterCollectionByuuid(String uuid);

	
	//更新状态
	void updateExternalnetWorkByUuid(String status,String uuid);
	 //获取所有ExternalNetWork对象
	 List<ExternalNetWork> findNetWork();
	 
	 void insertModel(ExternalNetWork externalNetWork);
}
