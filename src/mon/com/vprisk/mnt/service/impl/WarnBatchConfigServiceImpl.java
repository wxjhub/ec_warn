package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.vprisk.mnt.dao.WarnBatchConfigDao;
import com.vprisk.mnt.entity.WarnBatchConfig;
import com.vprisk.mnt.service.WarnBatchConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnBatchConfigServiceImpl implements WarnBatchConfigService {
	WarnBatchConfigDao warnBatchConfigDao;

	public WarnBatchConfigDao getWarnBatchConfigDao() {
		return warnBatchConfigDao;
	}

	public void setWarnBatchConfigDao(WarnBatchConfigDao warnBatchConfigDao) {
		this.warnBatchConfigDao = warnBatchConfigDao;
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
	 public Page queryWarnBatchByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		 Page page = this.warnBatchConfigDao.selectWarnBatchByPage(params, pageNo,
					pageSize, orderBy, isAsc);
		 List<WarnBatchConfig> data = page.getData();
		 System.out.print("跑批监控配置"+data.size());
		 for(WarnBatchConfig config:data){
			 List<Map<String,String>> bttdata = this.warnBatchConfigDao.selectBatchInfo(config.getBatchId(), config.getTaskSetId(), config.getTaskId());
			 for(Map<String,String> map:bttdata) {
				config.setBatchName(StringUtil.isNotNullOrEmpty(map.get("batchName"))?map.get("batchName").toString():"");
				config.setTaskSetName(StringUtil.isNotNullOrEmpty(map.get("taskSetName"))?map.get("taskSetName").toString():"");
				config.setTaskName(StringUtil.isNotNullOrEmpty(map.get("taskName"))?map.get("taskName").toString():"");
			 } 
		 }
		 page.setData(data);
		 return page;
	 }
	 /**
		 * 分页查询任务数据
		 * @param params
		 * @param pageNo
		 * @param pageSize
		 * @param orderBy
		 * @param isAsc
		 * @return
		 */
	public	Page queryTaskByPage(Map params, int pageNo, int pageSize, String orderBy,
				Boolean isAsc){
		Page page = this.warnBatchConfigDao.selectTaskByPage(params, pageNo,
				pageSize, orderBy, isAsc);
		List<Object[]> data = page.getData();
		List<Map<String,String>>  rData = new ArrayList<Map<String,String>>();
		 for(Object[] config:data){
				 Map<String,String> tmp = new HashMap<String,String>();
				 tmp.put("taskId", (String)config[0]);
				 tmp.put("taskName",  (String)config[1]);
				 rData.add(tmp);
		 }
		 page.setData(rData);
		 return page;
	 }
	 /**
	  * 保存修改的方法
	  * @param warnModule
	  * @return
	  */
	 public boolean saveOrUpdateWarnBatchConfig(WarnBatchConfig warnConfig){
		  return this.warnBatchConfigDao.saveOrUpdate(warnConfig);
				  
	 }

	@Override
	public void removeByUuid(String uuid) {
		if(uuid.indexOf(",") != -1){
			String[] uuidArr = uuid.split(",");
			for(int i = 0;i < uuidArr.length;i++){
				this.warnBatchConfigDao.deleteByUuid(uuidArr[i]);
			}
		} else {
			this.warnBatchConfigDao.deleteByUuid(uuid);
		}
		
		
	}
    /**
     * 根据id查询数据
     */
	@Override
	public WarnBatchConfig queryById(String uuid) {
		return this.warnBatchConfigDao.selectEntityById(uuid);
	}
	/**
	 * 根据sql查询数据
	 * @return
	 */
    public List<Map<String,String>> queryBatchList(){
    	List data = this.warnBatchConfigDao.selectBatchList();
    	List<Map<String,String>> rMap = this.changeData(data, "batchId", "batchName");
    	return rMap;
    }
    /**
     * 根据sql查询数据
     * @return
     */
    public List<Map<String,String>> queryTaskSetList(String BatchId){
    	List data = this.warnBatchConfigDao.selectTaskSetList(BatchId);
    	List<Map<String,String>> rMap = this.changeData(data, "taskSetId", "taskSetName");
    	return rMap;
    }
    /**
     * 根据sql查询数据
     * @return
     */
    public List<Map<String,String>> queryTaskList(String taskSetId){
    	List data = this.warnBatchConfigDao.selectTaskList(taskSetId);
    	List<Map<String,String>> rMap = this.changeData(data, "taskId", "taskName");
    	return rMap;
    }
    /**
     * 对结果进行转换
     * @param data
     * @param keyId
     * @param keyName
     * @return
     */
    private List<Map<String,String>> changeData(List data,String keyId,String keyName){
    	List<Map<String,String>> rMap = new ArrayList<Map<String,String>>();
    	for(int i = 0;i < data.size();i++){
    		Object[] obj = (Object[])data.get(i);
    		Map<String,String> temMap = new HashMap<String,String>();
    		temMap.put(keyId, obj[0].toString());
    		temMap.put(keyName, obj[1].toString());
    		rMap.add(temMap);
    	}
    	return rMap;
    }
    /**
	 * 根据taskId查询taskName
	 * @param taskId
	 * @return
	 */
	public String queryTaskNameByTaskId(String taskId){
		String taskName = "该任务不存在";
		List data = this.warnBatchConfigDao.selectTaskNameById(taskId);
		if(data.size()>0){
			taskName = ((Object[])data.get(0))[1].toString();
		}
		return taskName;
	}
}
