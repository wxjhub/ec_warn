package com.vprisk.mnt.service;

import java.util.Map;

import com.vprisk.mnt.entity.WarnModuleConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 预警告警配置service
 * @author lenovo
 *
 */
public interface WarnModuleConfigService {
	/**
	 * 分页查询数据
	 * @param params 查询参数
	 * @param pageNo 第几页
	 * @param pageSize 每页大小
	 * @param orderBy 排序字段
	 * @param isAsc 是否排序
	 * @return page 分页对象
	 */
	 public Page queryWarnModuleByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) ;
	 /**
	  * 保存修改的方法
	  * @param warnModule
	  * @return
	  */
	 public boolean saveOrUpdateWarnModuleConfig(WarnModuleConfig warnModule);
	 /**
	  *  删除方法
	  * @param uuid
	  */
	 public void removeByUuid(String uuid);
	 /**
	  * 根据模块编码查询模块信息
	  * @param moduleCode
	  * @return
	  */
	 public WarnModuleConfig queryWarnModuleByModuleCode(String moduleCode);
}
