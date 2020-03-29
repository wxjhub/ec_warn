package com.vprisk.mnt.entity;

import java.io.Serializable;

public class TransactionSuccessModel implements Serializable {
	/**
	 * 交易成功率监控实体类
	 * 
	 * @author
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String transactionName;//交易名称
	private String code; //响应码
	private String codeName;//响应码名称
	private String transactionNum;//交易量
	private String transactionSumNum;//总交易量
	private String ratio;//比率
	private String executeType;//执行类型(1全天，2实时)
	private String executeDate;//执行时间
	private String col1;
	private String col2;
	private String col3;
	
	
	
	
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getTransactionName() {
		return transactionName;
	}
	public void setTransactionName(String transactionName) {
		this.transactionName = transactionName;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getCodeName() {
		return codeName;
	}
	public void setCodeName(String codeName) {
		this.codeName = codeName;
	}
	public String getTransactionNum() {
		return transactionNum;
	}
	public void setTransactionNum(String transactionNum) {
		this.transactionNum = transactionNum;
	}
	public String getRatio() {
		return ratio;
	}
	public void setRatio(String ratio) {
		this.ratio = ratio;
	}
	public String getExecuteType() {
		return executeType;
	}
	public void setExecuteType(String executeType) {
		this.executeType = executeType;
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
	public String getTransactionSumNum() {
		return transactionSumNum;
	}
	public void setTransactionSumNum(String transactionSumNum) {
		this.transactionSumNum = transactionSumNum;
	}

}
