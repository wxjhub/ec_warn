package com.vprisk.mnt.entity;

import java.util.Date;

/**
 * @author KivenZheng
 * @date 2018年8月15日 上午10:35:15
 * @discription 按钮响应时长记录表
 *
 */
public class BtnRespTimeLog {

	private String uuid;
	private String methodPath;
	private Date startTime;
	private String startMillis;
	private Date endTime;
	private String endMillis;
	private String isSuccess;

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getMethodPath() {
		return methodPath;
	}

	public void setMethodPath(String methodPath) {
		this.methodPath = methodPath;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public String getStartMillis() {
		return startMillis;
	}

	public void setStartMillis(String startMillis) {
		this.startMillis = startMillis;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public String getEndMillis() {
		return endMillis;
	}

	public void setEndMillis(String endMillis) {
		this.endMillis = endMillis;
	}

	public String getIsSuccess() {
		return isSuccess;
	}

	public void setIsSuccess(String isSuccess) {
		this.isSuccess = isSuccess;
	}

}
