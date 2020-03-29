package com.vprisk.mnt.entity;

import java.io.Serializable;

public class TableAnalysisConfig implements Serializable {
	
	
	/**
	 * 表分析监控配置实体类
	 * 
	 */
	
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;// 主键
	private String warnTime;// 预警时长
	private String dataDeviationValues;// 数据量偏差预警量
	private int warningLevl;// 预警级别
	private String remark;// 备注
	private String col1;// 预留字段
	private String col2;// 预留字段
	private String col3;// 预留字段

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getWarnTime() {
		return warnTime;
	}

	public void setWarnTime(String warnTime) {
		this.warnTime = warnTime;
	}

	public String getDataDeviationValues() {
		return dataDeviationValues;
	}

	public void setDataDeviationValues(String dataDeviationValues) {
		this.dataDeviationValues = dataDeviationValues;
	}

	public int getWarningLevl() {
		return warningLevl;
	}

	public void setWarningLevl(int warningLevl) {
		this.warningLevl = warningLevl;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
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
