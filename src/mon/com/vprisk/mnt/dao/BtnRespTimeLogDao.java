package com.vprisk.mnt.dao;

import com.vprisk.mnt.entity.BtnRespTimeLog;


/**
 * @author KivenZheng
 * @date 2018年8月15日 上午10:38:13
 * @discription 按钮响应时长dao
 *
 */
public interface BtnRespTimeLogDao {

	/**
	 * 将按钮时长信息保存
	 * 
	 * @param log 要保存的按钮时长信息
	 */
	public void saveLog(BtnRespTimeLog log);
}
