package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.sql.Timestamp;
/**
 * 跑批预警调度日志实体
 * @author lenovo
 *
 */
public class WarnBatchHisTaskLog implements Serializable{
	private static final long serialVersionUID = 5009065783469099577L;
	private String uuid;// 主键
	private String processId;//任务组id
	private String batchId;//批次id
	private String taskId;//任务id
	private String runFlag;//运行标志
	private String runTime;//运行时间
	private Double count;//运行次数
	private Timestamp stdTime;// 开始时间
	private Timestamp endTime;// 结束时间
	private Timestamp asOfDate;//记录日期
	private Timestamp createDate;//数据日期
	private String errorMessage;//错误信息
	private Double sumcount;// 总运行次数
	private String jobId;// 作业id
	private String taskRunid;// 任务运行的进程ID或者存储过程所在的Connection的SID
	
	
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
	public String getProcessId() {
		return processId;
	}
	public void setProcessId(String processId) {
		this.processId = processId;
	}
	public String getBatchId() {
		return batchId;
	}
	public void setBatchId(String batchId) {
		this.batchId = batchId;
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
	public Double getCount() {
		return count;
	}
	public void setCount(Double count) {
		this.count = count;
	}
	public Timestamp getStdTime() {
		return stdTime;
	}
	public void setStdTime(Timestamp stdTime) {
		this.stdTime = stdTime;
	}
	public Timestamp getEndTime() {
		return endTime;
	}
	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}
	public Timestamp getAsOfDate() {
		return asOfDate;
	}
	public void setAsOfDate(Timestamp asOfDate) {
		this.asOfDate = asOfDate;
	}
	public Timestamp getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Timestamp createDate) {
		this.createDate = createDate;
	}
	public String getErrorMessage() {
		return errorMessage;
	}
	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}
	public Double getSumcount() {
		return sumcount;
	}
	public void setSumcount(Double sumcount) {
		this.sumcount = sumcount;
	}
	public String getJobId() {
		return jobId;
	}
	public void setJobId(String jobId) {
		this.jobId = jobId;
	}
	public String getTaskRunid() {
		return taskRunid;
	}
	public void setTaskRunid(String taskRunid) {
		this.taskRunid = taskRunid;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((asOfDate == null) ? 0 : asOfDate.hashCode());
		result = prime * result + ((batchId == null) ? 0 : batchId.hashCode());
		result = prime * result + ((count == null) ? 0 : count.hashCode());
		result = prime * result
				+ ((createDate == null) ? 0 : createDate.hashCode());
		result = prime * result + ((endTime == null) ? 0 : endTime.hashCode());
		result = prime * result
				+ ((errorMessage == null) ? 0 : errorMessage.hashCode());
		result = prime * result + ((jobId == null) ? 0 : jobId.hashCode());
		result = prime * result
				+ ((processId == null) ? 0 : processId.hashCode());
		result = prime * result + ((runFlag == null) ? 0 : runFlag.hashCode());
		result = prime * result + ((runTime == null) ? 0 : runTime.hashCode());
		result = prime * result + ((stdTime == null) ? 0 : stdTime.hashCode());
		result = prime * result
				+ ((sumcount == null) ? 0 : sumcount.hashCode());
		result = prime * result + ((taskId == null) ? 0 : taskId.hashCode());
		result = prime * result
				+ ((taskRunid == null) ? 0 : taskRunid.hashCode());
		result = prime * result + ((uuid == null) ? 0 : uuid.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		WarnBatchHisTaskLog other = (WarnBatchHisTaskLog) obj;
		if (asOfDate == null) {
			if (other.asOfDate != null)
				return false;
		} else if (!asOfDate.equals(other.asOfDate))
			return false;
		if (batchId == null) {
			if (other.batchId != null)
				return false;
		} else if (!batchId.equals(other.batchId))
			return false;
		if (count == null) {
			if (other.count != null)
				return false;
		} else if (!count.equals(other.count))
			return false;
		if (createDate == null) {
			if (other.createDate != null)
				return false;
		} else if (!createDate.equals(other.createDate))
			return false;
		if (endTime == null) {
			if (other.endTime != null)
				return false;
		} else if (!endTime.equals(other.endTime))
			return false;
		if (errorMessage == null) {
			if (other.errorMessage != null)
				return false;
		} else if (!errorMessage.equals(other.errorMessage))
			return false;
		if (jobId == null) {
			if (other.jobId != null)
				return false;
		} else if (!jobId.equals(other.jobId))
			return false;
		if (processId == null) {
			if (other.processId != null)
				return false;
		} else if (!processId.equals(other.processId))
			return false;
		if (runFlag == null) {
			if (other.runFlag != null)
				return false;
		} else if (!runFlag.equals(other.runFlag))
			return false;
		if (runTime == null) {
			if (other.runTime != null)
				return false;
		} else if (!runTime.equals(other.runTime))
			return false;
		if (stdTime == null) {
			if (other.stdTime != null)
				return false;
		} else if (!stdTime.equals(other.stdTime))
			return false;
		if (sumcount == null) {
			if (other.sumcount != null)
				return false;
		} else if (!sumcount.equals(other.sumcount))
			return false;
		if (taskId == null) {
			if (other.taskId != null)
				return false;
		} else if (!taskId.equals(other.taskId))
			return false;
		if (taskRunid == null) {
			if (other.taskRunid != null)
				return false;
		} else if (!taskRunid.equals(other.taskRunid))
			return false;
		if (uuid == null) {
			if (other.uuid != null)
				return false;
		} else if (!uuid.equals(other.uuid))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "WarnBatchHisTaskLog [uuid=" + uuid + ", processId=" + processId
				+ ", batchId=" + batchId + ", taskId=" + taskId + ", runFlag="
				+ runFlag + ", runTime=" + runTime + ", count=" + count
				+ ", stdTime=" + stdTime + ", endTime=" + endTime
				+ ", asOfDate=" + asOfDate + ", createDate=" + createDate
				+ ", errorMessage=" + errorMessage + ", sumcount=" + sumcount
				+ ", jobId=" + jobId + ", taskRunid=" + taskRunid + "]";
	}
	public WarnBatchHisTaskLog(String uuid, String processId, String batchId,
			String taskId, String runFlag, String runTime, Double count,
			Timestamp stdTime, Timestamp endTime, Timestamp asOfDate,
			Timestamp createDate, String errorMessage, Double sumcount,
			String jobId, String taskRunId) {
		super();
		this.uuid = uuid;
		this.processId = processId;
		this.batchId = batchId;
		this.taskId = taskId;
		this.runFlag = runFlag;
		this.runTime = runTime;
		this.count = count;
		this.stdTime = stdTime;
		this.endTime = endTime;
		this.asOfDate = asOfDate;
		this.createDate = createDate;
		this.errorMessage = errorMessage;
		this.sumcount = sumcount;
		this.jobId = jobId;
		this.taskRunid = taskRunid;
	}
	public WarnBatchHisTaskLog() {
		super();
	}
	
}
