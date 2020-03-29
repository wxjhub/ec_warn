package com.vprisk.mnt.entity;

import java.io.Serializable;

public class TransactionTimeModel implements Serializable {
	/**
	 * 交易时长实体
	 * @author
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String seqNo;// 流水号
	private String transactionCode; // 交易码

	private String transactionName; // 交易名称
	private String codeName;// 响应名称
	private String code;// 响应码
	private String startDate;// 交易开始时间
	private String endDate;// 交易结束时间
	private String transactionTime;// 交易时长(s)
	private String normTransactionTime;// 标准处理时间（s）
	private String executeDate;// 执行时间
	private String col1;
	private String col2;
	private String col3;
	
	

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getSeqNo() {
		return seqNo;
	}

	public void setSeqNo(String seqNo) {
		this.seqNo = seqNo;
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

	public String getCodeName() {
		return codeName;
	}

	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getTransactionTime() {
		return transactionTime;
	}

	public void setTransactionTime(String transactionTime) {
		this.transactionTime = transactionTime;
	}

	public String getNormTransactionTime() {
		return normTransactionTime;
	}

	public void setNormTransactionTime(String normTransactionTime) {
		this.normTransactionTime = normTransactionTime;
	}

	public String getExecuteDate() {
		return executeDate;
	}

	public void setExecuteDate(String executeDate) {
		this.executeDate = executeDate;
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
