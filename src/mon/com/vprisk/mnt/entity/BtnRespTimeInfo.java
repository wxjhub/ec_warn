package com.vprisk.mnt.entity;

/**
 * @author KivenZheng
 * @date 2018年8月15日 上午10:34:18
 * @discription 响应时长按钮信息表
 *
 */
public class BtnRespTimeInfo {

	private String uuid;
	private String methodName;
	private String methodRealName;
	private String methodPath;

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getMethodName() {
		return methodName;
	}

	public void setMethodName(String methodName) {
		this.methodName = methodName;
	}

	public String getMethodRealName() {
		return methodRealName;
	}

	public void setMethodRealName(String methodRealName) {
		this.methodRealName = methodRealName;
	}

	public String getMethodPath() {
		return methodPath;
	}

	public void setMethodPath(String methodPath) {
		this.methodPath = methodPath;
	}

}
