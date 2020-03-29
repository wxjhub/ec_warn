package com.vprisk.mnt.entity;

import java.io.Serializable;

public class BtnSuccessConfig implements Serializable{
	
    private static final long serialVersionUID = 5868282049606964791L;
	
	private String uuid;
	//系统名称
	private String systemName;
	//系统代码
	private String systemCode;
	//按钮响应时间
	private String btnTime;
	//备注
	private String remark;
	private String col1; 
	private String col2; 
	private String col3;
	
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getSystemName() {
		return systemName;
	}
	public void setSystemName(String systemName) {
		this.systemName = systemName;
	}
	public String getSystemCode() {
		return systemCode;
	}
	public void setSystemCode(String systemCode) {
		this.systemCode = systemCode;
	}
	public String getBtnTime() {
		return btnTime;
	}
	public void setBtnTime(String btnTime) {
		this.btnTime = btnTime;
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
	
	
}
