package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 文件传输预警实体类
 * 
 */
public class FileConfig implements Serializable {

	private static final long serialVersionUID = 1L;
	private String uuid;// 主键
	private String sysName;// 系统名称
	private String sysCode;// 系统号
	private String fileName;// 文件名
	private String fileType;// 文件类型
	private String fileSize;// 文件大小
	private int dealTimeValuesY;// 处理时长预警阀值
	private int dealTimeValuesG;// 处理时长告警阀值
	private int dealFailTimeValues;// 处理失败告警阀值
	private int rate;// 批量文件处理失败比率阀值
	private int dealTime;// 文件预计处理的时长
	private int fileRecTime;// 文件最晚到达时间
	private int warnLevel;// 预警级别
	private String remark;// 备注
	/*private String monthDay;// 每月第几日
	private Date startTime;// 开始日期
	private Date endTime;// 结束日期
	private String delayDay;// 延迟天数
	private int isOrControl;// 以延迟天数*/
    private String style;//类型
    private int datePrice;//日期差值
    private int theOtherDay;//前几天
    private Date fixedDate;//固定日期
	private int fileNumber;// 文件个数
    
	public String getStyle() {
		return style;
	}

	public void setStyle(String style) {
		this.style = style;
	}

	public int getDatePrice() {
		return datePrice;
	}

	public void setDatePrice(int datePrice) {
		this.datePrice = datePrice;
	}

	public int getTheOtherDay() {
		return theOtherDay;
	}

	public void setTheOtherDay(int theOtherDay) {
		this.theOtherDay = theOtherDay;
	}

	public Date getFixedDate() {
		return fixedDate;
	}

	public void setFixedDate(Date fixedDate) {
		this.fixedDate = fixedDate;
	}

	public int getFileNumber() {
		return fileNumber;
	}

	public void setFileNumber(int fileNumber) {
		this.fileNumber = fileNumber;
	}

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

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileType() {
		return fileType;
	}

	public void setFileType(String fileType) {
		this.fileType = fileType;
	}

	public String getFileSize() {
		return fileSize;
	}

	public void setFileSize(String fileSize) {
		this.fileSize = fileSize;
	}

	public int getDealTimeValuesY() {
		return dealTimeValuesY;
	}

	public void setDealTimeValuesY(int dealTimeValuesY) {
		this.dealTimeValuesY = dealTimeValuesY;
	}

	public int getDealTimeValuesG() {
		return dealTimeValuesG;
	}

	public void setDealTimeValuesG(int dealTimeValuesG) {
		this.dealTimeValuesG = dealTimeValuesG;
	}

	public int getDealFailTimeValues() {
		return dealFailTimeValues;
	}

	public void setDealFailTimeValues(int dealFailTimeValues) {
		this.dealFailTimeValues = dealFailTimeValues;
	}

	public int getRate() {
		return rate;
	}

	public void setRate(int rate) {
		this.rate = rate;
	}

	public int getDealTime() {
		return dealTime;
	}

	public void setDealTime(int dealTime) {
		this.dealTime = dealTime;
	}

	public int getWarnLevel() {
		return warnLevel;
	}

	public void setWarnLevel(int warnLevel) {
		this.warnLevel = warnLevel;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getFileRecTime() {
		return fileRecTime;
	}

	public void setFileRecTime(int fileRecTime) {
		this.fileRecTime = fileRecTime;
	}

}
