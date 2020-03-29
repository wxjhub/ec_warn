package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.WarnModuleConfigDao;
import com.vprisk.mnt.entity.WarnModuleConfig;
import com.vprisk.mnt.service.WarnModuleConfigService;
import com.vprisk.rmplatform.dao.support.Page;

public class WarnModuleConfigServiceImpl implements WarnModuleConfigService {
    private WarnModuleConfigDao warnModuleConfigDao;

	public WarnModuleConfigDao getWarnModuleConfigDao() {
		return warnModuleConfigDao;
	}

	public void setWarnModuleConfigDao(WarnModuleConfigDao warnModuleConfigDao) {
		this.warnModuleConfigDao = warnModuleConfigDao;
	}
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
			int pageSize, String orderBy, Boolean isAsc) {
		 return this.warnModuleConfigDao.selectWarnModuleByPage(params, pageNo,
					pageSize, orderBy, isAsc);
	 }
	
	 /**
	  * 保存修改的方法
	  * @param warnModule
	  * @return
	  */
	 public boolean saveOrUpdateWarnModuleConfig(WarnModuleConfig warnModule){
		  return this.warnModuleConfigDao.saveOrUpdate(warnModule);
				  
	 }

	@Override
	public void removeByUuid(String uuid) {
		if(uuid.indexOf(",") != -1){
			String[] uuidArr = uuid.split(",");
			for(int i = 0;i < uuidArr.length;i++){
				this.warnModuleConfigDao.deleteByUuid(uuidArr[i]);
			}
		} else {
			this.warnModuleConfigDao.deleteByUuid(uuid);
		}
	}
	/**
	  * 根据模块编码查询模块信息
	  * @param moduleCode
	  * @return
	  */
	 public WarnModuleConfig queryWarnModuleByModuleCode(String moduleCode){
		 List<WarnModuleConfig> data = new ArrayList<WarnModuleConfig>();
		 data = this.warnModuleConfigDao.selectWarnModuleByModuleCode(moduleCode);
		 WarnModuleConfig config = new WarnModuleConfig();
		 if(data.size() > 0){
			 config = data.get(0); 
		 }
		 return config;
	 }
}
