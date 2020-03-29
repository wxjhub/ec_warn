package com.vprisk.mnt.service;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.BookParam;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 通讯录参数维护service接口类
 */
public interface BookParamService {
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
	boolean saveOrUpdateCash(BookParam pracol);
	/**
	 * 根据通讯录参数ID查找相对应的对象信息
	 * @param detail 通讯录参数信息ID
	 * @return 返回对象结果集合
	 */
	List<BookParam> findParameterCollection(BookParam detail);
	/**
	 * 根据对象的ID删除管理对象信息
	 * @param uuid 通讯录参数信息ID
	 */
	void removeParameterCollectionByuuid(String uuid);
	/**
	 * 根据预警级别查询相关通讯录对象
	 * @param warningLevl 预警级别
	 * @return 通讯录对象集合
	 */
	List<BookParam> findBookParamByWarnLvl(int warningLevl);
	// 根据应用进程预警级别和预警分类，在这个时间段 查询相关联的预警人员
	List<BookParam> findBookParam(int warningLevl,String warnSort );
	
	List<BookParam> findBookParamByNote(String note);



}
