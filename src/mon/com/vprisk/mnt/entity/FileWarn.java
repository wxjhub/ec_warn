package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.util.Date;


public class FileWarn implements Serializable {
	/**
	 * 文件监控实体类
	 * 
	 * @author
	 */

	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String fileName;// 文件名称
	private String sourseSys;// 系统号
	private String tranStat;// 传输状态
	private String collectDate;// 采集时间
	private Date dataDate;// 数据日期
	private int warningLevl;// 预警级别
	private String fileType;// 文件类型
	private String fileSize;// 文件大小
	private Date tranStartTime;// 开始时间
	private Date tranEndTime;// 结束时间
	private String fileTime;// 文件用时
	private String fileZt;// 是否实时
	private String col1;// 预留字段
	private String col2;// 预留字段
	private String col3;// 预留字段
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getSourseSys() {
		return sourseSys;
	}
	public void setSourseSys(String sourseSys) {
		this.sourseSys = sourseSys;
	}
	public String getTranStat() {
		return tranStat;
	}
	public void setTranStat(String tranStat) {
		this.tranStat = tranStat;
	}
	public String getCollectDate() {
		return collectDate;
	}
	public void setCollectDate(String collectDate) {
		this.collectDate = collectDate;
	}
	public Date getDataDate() {
		return dataDate;
	}
	public void setDataDate(Date dataDate) {
		this.dataDate = dataDate;
	}
	public int getWarningLevl() {
		return warningLevl;
	}
	public void setWarningLevl(int warningLevl) {
		this.warningLevl = warningLevl;
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
	public Date getTranStartTime() {
		return tranStartTime;
	}
	public void setTranStartTime(Date tranStartTime) {
		this.tranStartTime = tranStartTime;
	}
	public Date getTranEndTime() {
		return tranEndTime;
	}
	public void setTranEndTime(Date tranEndTime) {
		this.tranEndTime = tranEndTime;
	}
	public String getFileTime() {
		return fileTime;
	}
	public void setFileTime(String fileTime) {
		this.fileTime = fileTime;
	}
	public String getFileZt() {
		return fileZt;
	}
	public void setFileZt(String fileZt) {
		this.fileZt = fileZt;
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
