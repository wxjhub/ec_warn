package com.vprisk.mnt.entity;

import java.io.Serializable;

public class ClientConfig implements Serializable {
	/**
	 * 系统基本配置实体类
	 *
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;//主键
	private String systemName;//系统名称
	private String subsystemName;//子系统名称
	private String nodeName;//节点名称
	private String ipAddress;//ip地址
	private String informationCenter;//主机存放信息中心
	private String remarks;//描述
	
	
	
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getSystemName() {
		return systemName;
	}
	public void setSystemName(String systemName) {
		this.systemName = systemName;
	}
	public String getSubsystemName() {
		return subsystemName;
	}
	public void setSubsystemName(String subsystemName) {
		this.subsystemName = subsystemName;
	}
	public String getNodeName() {
		return nodeName;
	}
	public void setNodeName(String nodeName) {
		this.nodeName = nodeName;
	}
	public String getIpAddress() {
		return ipAddress;
	}
	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}
	public String getInformationCenter() {
		return informationCenter;
	}
	public void setInformationCenter(String informationCenter) {
		this.informationCenter = informationCenter;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	
}
