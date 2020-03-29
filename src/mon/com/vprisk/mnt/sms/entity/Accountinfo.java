package com.vprisk.mnt.sms.entity;

import com.vprisk.rmplatform.security.entity.Organ;

 /**
 * Program Name: 柜员信息实体<br>
 * Description: <br>
 * @author name: AUTO_GEN<br>
 * Written Date: AUTO_GEN<br>
 * Modified By: <br>
 * Modified Date: 
 */
public class Accountinfo{
	private String uuid; //ID
	private String userNumber; //柜员编号
	private String userName; //柜员姓名
	private Organ organ; //机构
	private String phoneNumber; //手机号码
	private String remarks; //备注
	
	public Accountinfo(){}

	/**
	 * ID Getter
	 */
	public String getUuid() {
		return uuid;
	}
	/**
	 * ID Setter
	 */
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	/**
	 * 柜员编号 Getter
	 */
	public String getUserNumber() {
		return userNumber;
	}
	/**
	 * 柜员编号 Setter
	 */
	public void setUserNumber(String userNumber) {
		this.userNumber = userNumber;
	}
	/**
	 * 柜员姓名 Getter
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * 柜员姓名 Setter
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}
	/**
	 * 机构 Getter
	 */
	public Organ getOrgan() {
		return organ;
	}
	/**
	 * 机构 Setter
	 */
	public void setOrgan(Organ organ) {
		this.organ = organ;
	}
	/**
	 * 手机号码 Getter
	 */
	public String getPhoneNumber() {
		return phoneNumber;
	}
	/**
	 * 手机号码 Setter
	 */
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	/**
	 * 备注 Getter
	 */
	public String getRemarks() {
		return remarks;
	}
	/**
	 * 备注 Setter
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	
	/**
	 * toString显示名词字段
	 */
	public String toString() {
		if(this.uuid != null)
			return this.uuid.toString();
		return null;
	}
	
}
