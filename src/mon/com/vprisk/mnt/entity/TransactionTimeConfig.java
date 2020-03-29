package com.vprisk.mnt.entity;

import java.io.Serializable;

public class TransactionTimeConfig implements Serializable {
	/**
	 * 交易时长配置实体类
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;
	
	private String uuid;// 主键
	private String transactionCode;//交易码
	private String transactionName;//交易名称
	private int countCycle;//统计周期（秒）
	private int transactionTime;//单笔交易标准处理时长（秒）
	private int transactionTimeValueY;//超时交易笔数预警阀值
	private int transactionTimeValueG;//超时交易笔数告警阀值
	private int warningLevl;//预警级别
	private String col1;//预留
	private String col2;//预留
	private String col3;//预留
	
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
	public int getCountCycle() {
		return countCycle;
	}
	public void setCountCycle(int countCycle) {
		this.countCycle = countCycle;
	}
	public int getTransactionTime() {
		return transactionTime;
	}
	public void setTransactionTime(int transactionTime) {
		this.transactionTime = transactionTime;
	}
	public int getTransactionTimeValueY() {
		return transactionTimeValueY;
	}
	public void setTransactionTimeValueY(int transactionTimeValueY) {
		this.transactionTimeValueY = transactionTimeValueY;
	}
	public int getTransactionTimeValueG() {
		return transactionTimeValueG;
	}
	public void setTransactionTimeValueG(int transactionTimeValueG) {
		this.transactionTimeValueG = transactionTimeValueG;
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
