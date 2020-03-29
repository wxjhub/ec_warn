package com.vprisk.mnt.entity;

import java.io.Serializable;

public class ApplyProSoftConfig implements Serializable {
	/**
	 * 应用程序监控实体类
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String hostName;// 主机名称
	private String localIp;// 主机IP
	private String serverName;// 服务名称
	private String userName;// 应用服务用户
	private int maxCourseNum;// 应用服务数
	private int warningLevl;// 预警级别
	private String remark;// 备注
	private String col1;// 预留字段
	private String col2;// 预留字段
	private String col3;// 备注
	
	private int courseNum;//当前进程数
	private String collectDate;//采集时间
	private String courseStatus;//进程状态
	

	public int getCourseNum() {
		return courseNum;
	}

	public void setCourseNum(int courseNum) {
		this.courseNum = courseNum;
	}

	public String getCollectDate() {
		return collectDate;
	}

	public void setCollectDate(String collectDate) {
		this.collectDate = collectDate;
	}

	public String getCourseStatus() {
		return courseStatus;
	}

	public void setCourseStatus(String courseStatus) {
		this.courseStatus = courseStatus;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getHostName() {
		return hostName;
	}

	public void setHostName(String hostName) {
		this.hostName = hostName;
	}

	public String getLocalIp() {
		return localIp;
	}

	public void setLocalIp(String localIp) {
		this.localIp = localIp;
	}

	public String getServerName() {
		return serverName;
	}

	public void setServerName(String serverName) {
		this.serverName = serverName;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public int getMaxCourseNum() {
		return maxCourseNum;
	}

	public void setMaxCourseNum(int maxCourseNum) {
		this.maxCourseNum = maxCourseNum;
	}

	public int getWarningLevl() {
		return warningLevl;
	}

	public void setWarningLevl(int warningLevl) {
		this.warningLevl = warningLevl;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCol1() {
		return col1;
	}

	public void setCol1(String col1) {
		this.col1 = col1;
	}

	public String getCol2() {
		return col2;
	}

	public void setCol2(String col2) {
		this.col2 = col2;
	}

	public String getCol3() {
		return col3;
	}

	public void setCol3(String col3) {
		this.col3 = col3;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
