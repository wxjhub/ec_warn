package com.vprisk.mnt.entity;

import java.io.Serializable;

public class TransactionEndConfig implements Serializable {
	/**
	 * 长时间无交易配置实体类
	 * 
	 */
	
	private String uuid;// 主键
	private String sysName;//系统名称
	private String sysCode;//系统号
	private String transactionDay;//交易日
	private String noTransactionDay;//无交易日
	private String transactionTime;//交易时段
	private String noTransactionTime;//非交易时段
	private String sysFreeTime;//系统闲时时段
	private String sysBusyTime;//系统忙时时段
	private int noTransactionTimeValuesY;//无交易时长预警阀值
	private int noTransactionTimeValuesG;//无交易时长告警阀值
	private int warningLevl;//预警级别
	private String col1;//预留
	private String col2;//预留
	private String col3;//预留
	
	private static final long serialVersionUID = 5868282049606964791L;
	
	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getSysName() {
		return sysName;
	}

	public void setSysName(String sysName) {
		this.sysName = sysName;
	}

	public String getSysCode() {
		return sysCode;
	}

	public void setSysCode(String sysCode) {
		this.sysCode = sysCode;
	}

	public String getTransactionDay() {
		return transactionDay;
	}

	public void setTransactionDay(String transactionDay) {
		this.transactionDay = transactionDay;
	}

	public String getNoTransactionDay() {
		return noTransactionDay;
	}

	public void setNoTransactionDay(String noTransactionDay) {
		this.noTransactionDay = noTransactionDay;
	}

	public String getTransactionTime() {
		return transactionTime;
	}

	public void setTransactionTime(String transactionTime) {
		this.transactionTime = transactionTime;
	}

	public String getNoTransactionTime() {
		return noTransactionTime;
	}

	public void setNoTransactionTime(String noTransactionTime) {
		this.noTransactionTime = noTransactionTime;
	}

	public String getSysFreeTime() {
		return sysFreeTime;
	}

	public void setSysFreeTime(String sysFreeTime) {
		this.sysFreeTime = sysFreeTime;
	}

	public String getSysBusyTime() {
		return sysBusyTime;
	}

	public void setSysBusyTime(String sysBusyTime) {
		this.sysBusyTime = sysBusyTime;
	}

	public int getNoTransactionTimeValuesY() {
		return noTransactionTimeValuesY;
	}

	public void setNoTransactionTimeValuesY(int noTransactionTimeValuesY) {
		this.noTransactionTimeValuesY = noTransactionTimeValuesY;
	}

	public int getNoTransactionTimeValuesG() {
		return noTransactionTimeValuesG;
	}

	public void setNoTransactionTimeValuesG(int noTransactionTimeValuesG) {
		this.noTransactionTimeValuesG = noTransactionTimeValuesG;
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
