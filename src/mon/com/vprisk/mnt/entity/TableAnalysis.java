package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


public class TableAnalysis implements Serializable {
	/**
	 * 表分析实体类
	 * 
	 * @author
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;
	private String tablespaceName;// 表空间名称
	private String tableName;// 表名
	private String lastAnalyzed;// 最后一次表分析时间
	private BigDecimal sampleSize;// 表空间数据量大小
	private BigDecimal tableSize;// 表数据量大小
	private BigDecimal deviation ;//数据量偏差
	private String collectDate;//采集时间
	
	private int warningLevl;//预警级别

	
	
	public int getWarningLevl() {
		return warningLevl;
	}

	public void setWarningLevl(int warningLevl) {
		this.warningLevl = warningLevl;
	}

	public BigDecimal getTableSize() {
		return tableSize;
	}

	public void setTableSize(BigDecimal tableSize) {
		this.tableSize = tableSize;
	}

	public BigDecimal getDeviation() {
		return deviation;
	}

	public void setDeviation(BigDecimal deviation) {
		this.deviation = deviation;
	}

	public String getCollectDate() {
		return collectDate;
	}

	public void setCollectDate(String collectDate) {
		this.collectDate = collectDate;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getTablespaceName() {
		return tablespaceName;
	}

	public void setTablespaceName(String tablespaceName) {
		this.tablespaceName = tablespaceName;
	}

	public String getTableName() {
		return tableName;
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public String getLastAnalyzed() {
		return lastAnalyzed;
	}

	public  void setLastAnalyzed(String lastAnalyzed) {
		this.lastAnalyzed = lastAnalyzed;
	}

	public BigDecimal getSampleSize() {
		return sampleSize;
	}

	public void setSampleSize(BigDecimal sampleSize) {
		this.sampleSize = sampleSize;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
