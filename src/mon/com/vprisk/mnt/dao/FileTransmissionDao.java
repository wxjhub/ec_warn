package com.vprisk.mnt.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.FileTransmission;
import com.vprisk.rmplatform.dao.support.Page;
/**
 * 文件传输监控Dao层接口类
 */
public interface FileTransmissionDao {

	/**
	 * 查询对象结果集集合
	 * @return 结果集集合
	 */
	
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	List<FileTransmission> findFileTransmission();
	List<FileTransmission> findFileTransmission(String tranType);
	
	int findFileNumByGetSystem(String sysName, Date datedata);
	int findFileNumBySendSystem(String sysName, Date datedata);
	String findZt(String FileName,Date DataDate);

}
