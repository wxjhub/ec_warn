package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.WarnModuleConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 预警告警配置
 * @author lenovo
 *
 */
public interface WarnModuleConfigDao {
    /**
     * 分页查询数据
     * @param params
     * @param pageNo
     * @param pageSize
     * @param orderBy
     * @param isAsc
     * @return
     */
	Page selectWarnModuleByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	 /**
	  * 保存修改的方法
	  * @param warnModule
	  * @return
	  */
	 boolean saveOrUpdate(WarnModuleConfig warnModule);
	 /**
	  * 删除数据 
	  * @param uuid
	  */
	 void deleteByUuid(String uuid);
	 /**
	  * 根据模块code查询配置信息
	  * @param moduleCode
	  * @return
	  */
	 List<WarnModuleConfig> selectWarnModuleByModuleCode(String moduleCode);

}
