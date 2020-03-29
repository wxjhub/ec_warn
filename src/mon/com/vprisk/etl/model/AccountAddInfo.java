package com.vprisk.etl.model;

import java.io.Serializable;

public class AccountAddInfo implements Serializable {
	
	/**
	 * 新增科目字典实体类
	 */
	private static final long serialVersionUID = 8164665200463937425L;
	private String uuid;//主键（PK）
	private String glAccountId;//科目号
	private String glAccountDesc;//科目名称
	private String oneGlId;//一级机构号
	private String twoGlId;//二级机构号
	private String threeGlId;//三级机构号
	private String fourGlId;//四级机构号
	private String fiveGlId;//五级机构号
	private String addGlDate;//科目新增日期
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getAddGlDate() {
		return addGlDate;
	}
	public void setAddGlDate(String addGlDate) {
		this.addGlDate = addGlDate;
	}
	public String getGlAccountId() {
		return glAccountId;
	}
	public void setGlAccountId(String glAccountId) {
		this.glAccountId = glAccountId;
	}
	public String getGlAccountDesc() {
		return glAccountDesc;
	}
	public void setGlAccountDesc(String glAccountDesc) {
		this.glAccountDesc = glAccountDesc;
	}
	public String getOneGlId() {
		return oneGlId;
	}
	public void setOneGlId(String oneGlId) {
		this.oneGlId = oneGlId;
	}
	public String getTwoGlId() {
		return twoGlId;
	}
	public void setTwoGlId(String twoGlId) {
		this.twoGlId = twoGlId;
	}
	public String getThreeGlId() {
		return threeGlId;
	}
	public void setThreeGlId(String threeGlId) {
		this.threeGlId = threeGlId;
	}
	public String getFourGlId() {
		return fourGlId;
	}
	public void setFourGlId(String fourGlId) {
		this.fourGlId = fourGlId;
	}
	public String getFiveGlId() {
		return fiveGlId;
	}
	public void setFiveGlId(String fiveGlId) {
		this.fiveGlId = fiveGlId;
	}
}
