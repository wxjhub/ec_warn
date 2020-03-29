package com.vprisk.mnt.entity;

import java.io.Serializable;

public class TransactionSuccessConfig implements Serializable {
	/**
	 * 交易成功率配置实体类
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String transactionCode;// 交易码
	private String transactionName;// 交易名称
	private String responseCode;// 响应码
	private String responseName;// 响应名称
	private int countCycle; // 统计周期（秒）
	private int transactionSuccessValue;// 实时交易成功率阀值
	private int transactionSuccessValues;// 全天交易成功率阀值
	private int warningLevl;// 预警级别
	private String col1;
	private String col2;
	private String col3;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getTransactionCode() {
		return transactionCode;
	}

	public void setTransactionCode(String transactionCode) {
		this.transactionCode = transactionCode;
	}

	public String getTransactionName() {
		return transactionName;
	}

	public void setTransactionName(String transactionName) {
		this.transactionName = transactionName;
	}

	public String getResponseCode() {
		return responseCode;
	}

	public void setResponseCode(String responseCode) {
		this.responseCode = responseCode;
	}

	public String getResponseName() {
		return responseName;
	}

	public void setResponseName(String responseName) {
		this.responseName = responseName;
	}

	public int getCountCycle() {
		return countCycle;
	}

	public void setCountCycle(int countCycle) {
		this.countCycle = countCycle;
	}

	
	public int getTransactionSuccessValue() {
		return transactionSuccessValue;
	}

	public void setTransactionSuccessValue(int transactionSuccessValue) {
		this.transactionSuccessValue = transactionSuccessValue;
	}

	public int getTransactionSuccessValues() {
		return transactionSuccessValues;
	}

	public void setTransactionSuccessValues(int transactionSuccessValues) {
		this.transactionSuccessValues = transactionSuccessValues;
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

}
