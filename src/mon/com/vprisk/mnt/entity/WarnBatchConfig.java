package com.vprisk.mnt.entity;

import java.io.Serializable;
/**
 * 跑批预警配置
 * @author lenovo
 *
 */
public class WarnBatchConfig implements Serializable{
	private static final long serialVersionUID = -7738846240512139208L;
	private String uuid;// 主键
	private String batchId; //批次id
	private String taskSetId; //任务组id
	private String taskId; //任务id
	private String warnContent; //预警内容 时点 时长
	private String warnContentValue;//预警内容值
	private Integer warnLevl;// 预警级别
	private String col1; //预留字段1
	private String col2; //预留字段2
	private String col3; //预留字段3
	//非数据库字段
	private String batchName; //批次name
	private String taskSetName; //任务组name
	private String taskName; //任务name
	private String nowRunTime; //截止到现在的运行时长  秒
	
	public String getNowRunTime() {
		return nowRunTime;
	}
	public void setNowRunTime(String nowRunTime) {
		this.nowRunTime = nowRunTime;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getBatchId() {
		return batchId;
	}
	public void setBatchId(String batchId) {
		this.batchId = batchId;
	}
	public String getTaskSetId() {
		return taskSetId;
	}
	public void setTaskSetId(String taskSetId) {
		this.taskSetId = taskSetId;
	}
	public String getTaskId() {
		return taskId;
	}
	public void setTaskId(String taskId) {
		this.taskId = taskId;
	}
	public String getWarnContent() {
		return warnContent;
	}
	public void setWarnContent(String warnContent) {
		this.warnContent = warnContent;
	}
	public String getWarnContentValue() {
		return warnContentValue;
	}
	public void setWarnContentValue(String warnContentValue) {
		this.warnContentValue = warnContentValue;
	}
	public Integer getWarnLevl() {
		return warnLevl;
	}
	public void setWarnLevl(Integer warnLevl) {
		this.warnLevl = warnLevl;
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
	
	public String getBatchName() {
		return batchName;
	}
	public void setBatchName(String batchName) {
		this.batchName = batchName;
	}
	public String getTaskSetName() {
		return taskSetName;
	}
	public void setTaskSetName(String taskSetName) {
		this.taskSetName = taskSetName;
	}
	public String getTaskName() {
		return taskName;
	}
	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((batchId == null) ? 0 : batchId.hashCode());
		result = prime * result + ((col1 == null) ? 0 : col1.hashCode());
		result = prime * result + ((col2 == null) ? 0 : col2.hashCode());
		result = prime * result + ((col3 == null) ? 0 : col3.hashCode());
		result = prime * result + ((taskId == null) ? 0 : taskId.hashCode());
		result = prime * result
				+ ((taskSetId == null) ? 0 : taskSetId.hashCode());
		result = prime * result + ((uuid == null) ? 0 : uuid.hashCode());
		result = prime * result
				+ ((warnContent == null) ? 0 : warnContent.hashCode());
		result = prime
				* result
				+ ((warnContentValue == null) ? 0 : warnContentValue.hashCode());
		result = prime * result
				+ ((warnLevl == null) ? 0 : warnLevl.hashCode());
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
		WarnBatchConfig other = (WarnBatchConfig) obj;
		if (batchId == null) {
			if (other.batchId != null)
				return false;
		} else if (!batchId.equals(other.batchId))
			return false;
		if (col1 == null) {
			if (other.col1 != null)
				return false;
		} else if (!col1.equals(other.col1))
			return false;
		if (col2 == null) {
			if (other.col2 != null)
				return false;
		} else if (!col2.equals(other.col2))
			return false;
		if (col3 == null) {
			if (other.col3 != null)
				return false;
		} else if (!col3.equals(other.col3))
			return false;
		if (taskId == null) {
			if (other.taskId != null)
				return false;
		} else if (!taskId.equals(other.taskId))
			return false;
		if (taskSetId == null) {
			if (other.taskSetId != null)
				return false;
		} else if (!taskSetId.equals(other.taskSetId))
			return false;
		if (uuid == null) {
			if (other.uuid != null)
				return false;
		} else if (!uuid.equals(other.uuid))
			return false;
		if (warnContent == null) {
			if (other.warnContent != null)
				return false;
		} else if (!warnContent.equals(other.warnContent))
			return false;
		if (warnContentValue == null) {
			if (other.warnContentValue != null)
				return false;
		} else if (!warnContentValue.equals(other.warnContentValue))
			return false;
		if (warnLevl == null) {
			if (other.warnLevl != null)
				return false;
		} else if (!warnLevl.equals(other.warnLevl))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "WarnBacthConfig [uuid=" + uuid + ", batchId=" + batchId
				+ ", taskSetId=" + taskSetId + ", taskId=" + taskId
				+ ", warnContent=" + warnContent + ", warnContentValue="
				+ warnContentValue + ", warnLevl=" + warnLevl + ", col1="
				+ col1 + ", col2=" + col2 + ", col3=" + col3 + "]";
	}
	public WarnBatchConfig() {
		super();
	}
	
}
