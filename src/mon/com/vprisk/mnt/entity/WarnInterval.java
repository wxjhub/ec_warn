package com.vprisk.mnt.entity;

import java.io.Serializable;

public class WarnInterval implements Serializable {
	/**
	 * 预警时间间隔实体类
	 * @author wanglin
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String warnIntervalId; //预警时间间隔id
	private String warnName;//预警名称
	private int warnInterval;//预警间隔时间
	private String warnCode;//预警名称代号
	private String remark;//备注
	private String onceTime;//上次预警时间
	
	private String col1;//预留字段1
	private String col2;//预留字段2
	private String col3;//预留字段3
	
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
	
	
	public String getOnceTime() {
		return onceTime;
	}
	public void setOnceTime(String onceTime) {
		this.onceTime = onceTime;
	}
	public String getWarnIntervalId() {
		return warnIntervalId;
	}
	public void setWarnIntervalId(String warnIntervalId) {
		this.warnIntervalId = warnIntervalId;
	}
	public String getWarnName() {
		return warnName;
	}
	public void setWarnName(String warnName) {
		this.warnName = warnName;
	}
	public int getWarnInterval() {
		return warnInterval;
	}
	public void setWarnInterval(int warnInterval) {
		this.warnInterval = warnInterval;
	}
	public String getWarnCode() {
		return warnCode;
	}
	public void setWarnCode(String warnCode) {
		this.warnCode = warnCode;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}

}
