package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.LocalNetWork;
import com.vprisk.rmplatform.dao.support.Page;
/**
 * 网络监控参数Dao层实现接口类
 */
public interface LocalNetWorkDao {
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
	 * 保存新增或修改的对象信息
	 * @param pracol对象信息
	 * @return 返回boolean值
	 */
	boolean saveOrUpdateCash(LocalNetWork pracol);
	/**
	 * 新增时，根据对象信息查询相关联对象信息
	 * @param subject 对象信息
	 * @return 通讯录对象集合
	 */
	List<LocalNetWork> findParameterCollectionByAdd(LocalNetWork  subject);
	/**
	 * 修改时，根据对象信息查询相关联对象信息
	 * @param subject 对象信息
	 * @return 通讯录对象集合
	 */
	List<LocalNetWork> findParameterCollectionByUpdate(LocalNetWork  subject);
	/**
	 * 根据对象ID删除对象
	 * @param uuid 对象
	 * @return 无
	 */
	void removeParameterCollectionByuuid(String uuid);
	
	//更新状态
	void updatelocalNetWorkByUuid(String status,String uuid);
   //获取所有LocalNetWork对象
	public List<LocalNetWork> findNetWork();
	
	
	void insertModel(LocalNetWork localNetWork);

}
