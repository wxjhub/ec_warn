package com.vprisk.mnt.entity;

import java.io.Serializable;
/**
 * 预警告警参数配置
 * @author lenovo
 *
 */
public class WarnModuleConfig implements Serializable {
	private static final long serialVersionUID = 8419630607330725719L;
	private String uuid;// 主键
	private String warnModuleCode;//预警模块
	private Integer warnLevl;// 预警级别
	private String warnNum;// 预警次数
	private String warnRoundTimeS;// 轮循时间（s）
	private String warnDatadateScope;// 监控数据日期范围(天)T-warnDatadateScope
	private String col1; //预留字段1
	private String col2; //预留字段2
	private String col3; //预留字段3
	
	public String getWarnDatadateScope() {
		return warnDatadateScope;
	}
	public void setWarnDatadateScope(String warnDatadateScope) {
		this.warnDatadateScope = warnDatadateScope;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getWarnModuleCode() {
		return warnModuleCode;
	}
	public void setWarnModuleCode(String warnModuleCode) {
		this.warnModuleCode = warnModuleCode;
	}
	public Integer getWarnLevl() {
		return warnLevl;
	}
	public void setWarnLevl(Integer warnLevl) {
		this.warnLevl = warnLevl;
	}
	public String getWarnNum() {
		return warnNum;
	}
	public void setWarnNum(String warnNum) {
		this.warnNum = warnNum;
	}
	public String getWarnRoundTimeS() {
		return warnRoundTimeS;
	}
	public void setWarnRoundTimeS(String warnRoundTimeS) {
		this.warnRoundTimeS = warnRoundTimeS;
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
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((col1 == null) ? 0 : col1.hashCode());
		result = prime * result + ((col2 == null) ? 0 : col2.hashCode());
		result = prime * result + ((col3 == null) ? 0 : col3.hashCode());
		result = prime * result + ((uuid == null) ? 0 : uuid.hashCode());
		result = prime * result
				+ ((warnLevl == null) ? 0 : warnLevl.hashCode());
		result = prime * result
				+ ((warnModuleCode == null) ? 0 : warnModuleCode.hashCode());
		result = prime * result + ((warnNum == null) ? 0 : warnNum.hashCode());
		result = prime * result
				+ ((warnRoundTimeS == null) ? 0 : warnRoundTimeS.hashCode());
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
		WarnModuleConfig other = (WarnModuleConfig) obj;
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
		if (uuid == null) {
			if (other.uuid != null)
				return false;
		} else if (!uuid.equals(other.uuid))
			return false;
		if (warnLevl == null) {
			if (other.warnLevl != null)
				return false;
		} else if (!warnLevl.equals(other.warnLevl))
			return false;
		if (warnModuleCode == null) {
			if (other.warnModuleCode != null)
				return false;
		} else if (!warnModuleCode.equals(other.warnModuleCode))
			return false;
		if (warnNum == null) {
			if (other.warnNum != null)
				return false;
		} else if (!warnNum.equals(other.warnNum))
			return false;
		if (warnRoundTimeS == null) {
			if (other.warnRoundTimeS != null)
				return false;
		} else if (!warnRoundTimeS.equals(other.warnRoundTimeS))
			return false;
		return true;
	}
	@Override
	public String toString() {
		return "WarnModuleConfig [uuid=" + uuid + ", warnModuleCode="
				+ warnModuleCode + ", warnLevl=" + warnLevl + ", warnNum="
				+ warnNum + ", warnRoundTimeS=" + warnRoundTimeS + ", col1="
				+ col1 + ", col2=" + col2 + ", col3=" + col3 + "]";
	}
	public WarnModuleConfig(String uuid, String warnModuleCode,
			Integer warnLevl, String warnNum, String warnRoundTimeS,
			String col1, String col2, String col3) {
		super();
		this.uuid = uuid;
		this.warnModuleCode = warnModuleCode;
		this.warnLevl = warnLevl;
		this.warnNum = warnNum;
		this.warnRoundTimeS = warnRoundTimeS;
		this.col1 = col1;
		this.col2 = col2;
		this.col3 = col3;
	}
	public WarnModuleConfig() {
		super();
	}
	
}
