package com.vprisk.mnt.sms.entity;

import java.util.Date;

 /**
 * Program Name: 短信发送实体<br>
 * Description: <br>
 * @author name: AUTO_GEN<br>
 * Written Date: AUTO_GEN<br>
 * Modified By: <br>
 * Modified Date: 
 */
public class Userinfo{
	private String uuid; //UUID
	private String userName; //接收人
	private String phoneNumber; //手机号
	private String content; //发送内容
	private String status; //状态
	private Date time; //发送时间
	
	public Userinfo(){}

	/**
	 * UUID Getter
	 */
	public String getUuid() {
		return uuid;
	}
	/**
	 * UUID Setter
	 */
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	/**
	 * 接收人 Getter
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * 接收人 Setter
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}
	/**
	 * 手机号 Getter
	 */
	public String getPhoneNumber() {
		return phoneNumber;
	}
	/**
	 * 手机号 Setter
	 */
	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
	/**
	 * 发送内容 Getter
	 */
	public String getContent() {
		return content;
	}
	/**
	 * 发送内容 Setter
	 */
	public void setContent(String content) {
		this.content = content;
	}
	/**
	 * 状态 Getter
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * 状态 Setter
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	/**
	 * 发送时间 Getter
	 */
	public Date getTime() {
		return time;
	}
	/**
	 * 发送时间 Setter
	 */
	public void setTime(Date time) {
		this.time = time;
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
