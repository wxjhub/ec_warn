package com.vprisk.mnt.entity;

import java.io.Serializable;

/**
 * 预警历史实体类
 * 
 * @author 
 * 
 */
public class WarnHistory implements Serializable {

	private static final long serialVersionUID = 1L;
	private String uuid;// 主键
	private String recordName; // 交易名称
	private String pointName;// 所属系统
	private String pointIp;// IP地址
	private String warnSort;// 报警分类
	private int warnLevel;// 预警级别
	private String recordDate;// 报警时间
	private String recordDescription;// 报警内容
	private String notificationPerson;// 通知人员（这个是短信配置）
	private String remark;// 批注
	private String endDate;// 确认时间
	private String confirmationPerson;// 确认人
	private String department;// 所在部门
	private String col1;// 预留字段1
	private String col2;// 预留字段2
	private String col3;// 预留字段3
	
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getRecordName() {
		return recordName;
	}
	public void setRecordName(String recordName) {
		this.recordName = recordName;
	}
	public String getPointName() {
		return pointName;
	}
	public void setPointName(String pointName) {
		this.pointName = pointName;
	}
	public String getPointIp() {
		return pointIp;
	}
	public void setPointIp(String pointIp) {
		this.pointIp = pointIp;
	}
	public String getWarnSort() {
		return warnSort;
	}
	public void setWarnSort(String warnSort) {
		this.warnSort = warnSort;
	}
	public int getWarnLevel() {
		return warnLevel;
	}
	public void setWarnLevel(int warnLevel) {
		this.warnLevel = warnLevel;
	}
	public String getRecordDate() {
		return recordDate;
	}
	public void setRecordDate(String recordDate) {
		this.recordDate = recordDate;
	}
	public String getRecordDescription() {
		return recordDescription;
	}
	public void setRecordDescription(String recordDescription) {
		this.recordDescription = recordDescription;
	}
	public String getNotificationPerson() {
		return notificationPerson;
	}
	public void setNotificationPerson(String notificationPerson) {
		this.notificationPerson = notificationPerson;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getConfirmationPerson() {
		return confirmationPerson;
	}
	public void setConfirmationPerson(String confirmationPerson) {
		this.confirmationPerson = confirmationPerson;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
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
