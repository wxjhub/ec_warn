package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.util.Date;

/**
 * 交易成功率记录实体类
 * @author wangxinji
 *
 */
public class BtnSuccess implements Serializable {
	
	private static final long serialVersionUID = 5868282049606964791L;
	
	private String uuid;
	//按钮名称
	private String btnName;
	//按钮方法路径
	private String btnPath;
	//所属系统
	private String localSystem;
	//成功率
	private String rate;
	//采集日期
	private String recordDate; 
	private String col1;
	//总个数
	private Integer allCount;
	//成功个数
	private Integer succCount; 
    
	public String getCol1() {
		return col1;
	}

	public void setCol1(String col1) {
		this.col1 = col1;
	}

	public Integer getAllCount() {
		return allCount;
	}

	public void setAllCount(Integer allCount) {
		this.allCount = allCount;
	}

	public Integer getSuccCount() {
		return succCount;
	}

	public void setSuccCount(Integer succCount) {
		this.succCount = succCount;
	}

	public String getRecordDate() {
		return recordDate;
	}

	public void setRecordDate(String recordDate) {
		this.recordDate = recordDate;
	}

	public String getUuid() {
		return uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	public String getBtnName() {
		return btnName;
	}

	public void setBtnName(String btnName) {
		this.btnName = btnName;
	}

	public String getBtnPath() {
		return btnPath;
	}

	public void setBtnPath(String btnPath) {
		this.btnPath = btnPath;
	}

	public String getLocalSystem() {
		return localSystem;
	}

	public void setLocalSystem(String localSystem) {
		this.localSystem = localSystem;
	}

	public String getRate() {
		return rate;
	}

	public void setRate(String rate) {
		this.rate = rate;
	}

}
