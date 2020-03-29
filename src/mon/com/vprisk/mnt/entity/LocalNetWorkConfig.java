package com.vprisk.mnt.entity;

import java.io.Serializable;

public class LocalNetWorkConfig implements Serializable {
	/**
	 * 网络监控实体类
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String hostName;// 主机名称
	private String hostIp;// 主机IP
	private String hostPort;// 主机端口
	private int collectTime;// 采集周期
	private int warningLevl;// 报警级别
	private String col1;// 预留
	private String col2;// 预留
	private String col3;// 预留
	
	private String collectDate;// 采集时间
	private String status;// 状态

	public String getCollectDate() {
		return collectDate;
	}

	public void setCollectDate(String collectDate) {
		this.collectDate = collectDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
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

	public String getHostIp() {
		return hostIp;
	}

	public void setHostIp(String hostIp) {
		this.hostIp = hostIp;
	}

	public String getHostPort() {
		return hostPort;
	}

	public void setHostPort(String hostPort) {
		this.hostPort = hostPort;
	}

	public int getCollectTime() {
		return collectTime;
	}

	public void setCollectTime(int collectTime) {
		this.collectTime = collectTime;
	}

	public int getWarningLevl() {
		return warningLevl;
	}

	public void setWarningLevl(int warningLevl) {
		this.warningLevl = warningLevl;
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
