package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Date;

public class DayEndMonitor implements Serializable {
	/**
	 * 日终
	 */
	private static final long serialVersionUID = 5868282049606964791L;
	
	private String uuid;// 主键
	private String batchId;// 批次编号
	private String jobId;// 作业编号
	private String processId;
	private String taskId;
	private String runFlag;// 运行状态
	private String runTime;
	private BigDecimal count;
	private String errorMessage;// 错误信息
	private Date asOfDate;// 数据日期
	private Date stdTime;// 开始时间
	private Date endTime;// 结束时间
	
	private String processName;
	private String taskName;
	private String batchName;
    
	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}


	public String getTaskName() {
		return taskName;
	}


	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}


	public String getBatchName() {
		return batchName;
	}


	public void setBatchName(String batchName) {
		this.batchName = batchName;
	}


	public String getUuid() {
		return uuid;
	}


	public void setUuid(String uuid) {
		this.uuid = uuid;
	}


	public static long getSerialversionuid() {
		return serialVersionUID;
	}


	public String getBatchId() {
		return batchId;
	}

	public void setBatchId(String batchId) {
		this.batchId = batchId;
	}

	public String getJobId() {
		return jobId;
	}

	public void setJobId(String jobId) {
		this.jobId = jobId;
	}

	public String getProcessId() {
		return processId;
	}

	public void setProcessId(String processId) {
		this.processId = processId;
	}

	public String getTaskId() {
		return taskId;
	}

	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}

	public String getRunFlag() {
		return runFlag;
	}

	public void setRunFlag(String runFlag) {
		this.runFlag = runFlag;
	}

	public String getRunTime() {
		return runTime;
	}

	public void setRunTime(String runTime) {
		this.runTime = runTime;
	}

	public BigDecimal getCount() {
		return count;
	}

	public void setCount(BigDecimal count) {
		this.count = count;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public Date getAsOfDate() {
		return asOfDate;
	}

	public void setAsOfDate(Date asOfDate) {
		this.asOfDate = asOfDate;
	}

	public Date getStdTime() {
		return stdTime;
	}

	public void setStdTime(Date stdTime) {
		this.stdTime = stdTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
    
	
}
