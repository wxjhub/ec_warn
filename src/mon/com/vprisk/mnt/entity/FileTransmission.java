package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.util.Date;
/**
 * 文件传输实体类
 * 
 * @author 
 * 
 */
public class FileTransmission implements Serializable{
	private static final long serialVersionUID = 1L;
	private String fileName;//文件名称
	private String sourseSys;//关联系统
	private String tranStat;//传输状态
	private Date tranStartTime;//传输开始时间
	private Date tranEndTime;//传输结束时间
	private Integer tranTimeSize;//传输时长
	private Date dataDate;//数据日期
	private String errorInfo;//错误信息
	private String tranType;//传输类型
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
	public Integer getTranTimeSize() {
		return tranTimeSize;
	}
	public void setTranTimeSize(Integer tranTimeSize) {
		this.tranTimeSize = tranTimeSize;
	}
	public Date getDataDate() {
		return dataDate;
	}
	public void setDataDate(Date dataDate) {
		this.dataDate = dataDate;
	}
	public String getErrorInfo() {
		return errorInfo;
	}
	public void setErrorInfo(String errorInfo) {
		this.errorInfo = errorInfo;
	}
	public String getTranType() {
		return tranType;
	}
	public void setTranType(String tranType) {
		this.tranType = tranType;
	}
	

}
