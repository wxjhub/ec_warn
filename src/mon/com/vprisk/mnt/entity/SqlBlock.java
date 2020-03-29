package com.vprisk.mnt.entity;

import java.io.Serializable;

public class SqlBlock implements Serializable {
	/**
	 * sql阻塞实体类
	 * 
	 * @author
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	
	private String uuid;//主键
	private String username;
	private String sid;
	private String event;
	private String sqlId;
	private String command;
	private String blockingInstance;
	private String blockingSession;
	private String lastCallEt;
	private String status;
	private String waitClass;
	private String collectDate;
	
	private int warningLevl;//预警级别
	private String remark;//备注
	private String col1;//预留字段
	private String col2;//预留字段
	private String col3;//预留字段
	
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
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getSid() {
		return sid;
	}

	public void setSid(String sid) {
		this.sid = sid;
	}

	public String getEvent() {
		return event;
	}

	public void setEvent(String event) {
		this.event = event;
	}

	public String getSqlId() {
		return sqlId;
	}

	public void setSqlId(String sqlId) {
		this.sqlId = sqlId;
	}

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	public String getBlockingInstance() {
		return blockingInstance;
	}

	public void setBlockingInstance(String blockingInstance) {
		this.blockingInstance = blockingInstance;
	}

	public String getBlockingSession() {
		return blockingSession;
	}

	public void setBlockingSession(String blockingSession) {
		this.blockingSession = blockingSession;
	}

	public String getLastCallEt() {
		return lastCallEt;
	}

	public void setLastCallEt(String lastCallEt) {
		this.lastCallEt = lastCallEt;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getWaitClass() {
		return waitClass;
	}

	public void setWaitClass(String waitClass) {
		this.waitClass = waitClass;
	}

	
	public String getCollectDate() {
		return collectDate;
	}

	public void setCollectDate(String collectDate) {
		this.collectDate = collectDate;
	}
}
