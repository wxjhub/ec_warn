package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.util.Date;

public class DayEndConfig implements Serializable {
	/**
	 * 日终实体类
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String dayendName;// 日终步骤名称
	private String dayendNo;// 日终步骤号
	private Date dayendDate;// 日切时间
	private String dayendMaxTime;// 日终最晚发起时间
	private String dayendEndTime;// 日终最晚结束时间
	private int warningLevl;// 预警级别
	private String dayendState;// 日终步骤状态
	private String col1;// 预留字段
	private String col2;// 预留字段
	private String col3;// 预留字段

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getDayendName() {
		return dayendName;
	}

	public void setDayendName(String dayendName) {
		this.dayendName = dayendName;
	}

	public String getDayendNo() {
		return dayendNo;
	}

	public void setDayendNo(String dayendNo) {
		this.dayendNo = dayendNo;
	}

	public Date getDayendDate() {
		return dayendDate;
	}

	public void setDayendDate(Date dayendDate) {
		this.dayendDate = dayendDate;
	}
    
	public String getDayendMaxTime() {
		return dayendMaxTime;
	}

	public void setDayendMaxTime(String dayendMaxTime) {
		this.dayendMaxTime = dayendMaxTime;
	}

	public String getDayendEndTime() {
		return dayendEndTime;
	}

	public void setDayendEndTime(String dayendEndTime) {
		this.dayendEndTime = dayendEndTime;
	}

	public int getWarningLevl() {
		return warningLevl;
	}

	public void setWarningLevl(int warningLevl) {
		this.warningLevl = warningLevl;
	}

	public String getDayendState() {
		return dayendState;
	}

	public void setDayendState(String dayendState) {
		this.dayendState = dayendState;
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
