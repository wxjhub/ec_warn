package com.vprisk.mnt.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.FileConfig;
import com.vprisk.rmplatform.dao.support.Page;

/**
 * 文件传输预警Dao层接口类
 * 
 */
public interface FileConfigDao {

	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);

	void removeParameterCollectionByuuid(String uuid);

	List<FileConfig> findParameterCollectionByAdd(FileConfig subject);

	List<FileConfig> findParameterCollectionByUpdate(FileConfig subject);

	boolean saveOrUpdateCash(FileConfig pracol);
	
	List<FileConfig> findFile(String fileName);
	
	List<FileConfig> findAll();

	void updateState(int state,String id);

}
