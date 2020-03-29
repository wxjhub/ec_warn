package com.vprisk.mnt.dao;

import java.util.List;

import com.vprisk.mnt.entity.BtnRespTimeInfo;



/**
 * @author KivenZheng
 * @date 2018年8月15日 上午10:38:13
 * @discription 按钮响应时长dao
 *
 */
public interface BtnRespTimeInfoDao {

	/**
	 * 获取所有需要记录时长的按钮
	 * 
	 * @return
	 */
	public List<BtnRespTimeInfo> getButtonInfo();

	/**
	 * 根据方法路径查询方法信息
	 * 
	 * @param methodPath
	 *            方法路径
	 * @return
	 */
	public List<BtnRespTimeInfo> queryByMethodPath(String methodPath);
}
