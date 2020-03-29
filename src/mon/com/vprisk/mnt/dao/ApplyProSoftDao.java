package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.ApplyProSoft;
import com.vprisk.rmplatform.dao.support.Page;
/**
 * 应用程序Dao层实现接口类
 */
public interface ApplyProSoftDao {
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
	 * @param pracol 对象信息
	 * @return 返回boolean值
	 */
	boolean saveOrUpdateCash(ApplyProSoft pracol);
	/**
	 * 新增时，根据对象信息查询相关联对象信息
	 * @param subject 对象信息
	 * @return 通讯录对象集合
	 */
	List<ApplyProSoft> findParameterCollectionByAdd(ApplyProSoft  subject);
	/**
	 * 修改时，根据对象信息查询相关联对象信息
	 * @param subject 对象信息
	 * @return 通讯录对象集合
	 */
	List<ApplyProSoft> findParameterCollectionByUpdate(ApplyProSoft  subject);
	/**
	 * 根据对象ID删除对象
	 * @param uuid 对象
	 * @return 无
	 */
	void removeParameterCollectionByuuid(String uuid);
	/**
	 * 更新本级IP地址
	 * @param ip ip地址
	 */
	void updateApplyProSoftByIP(String ip);
	/**
	 * 查询对象结果集集合
	 * @return 结果集集合
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
