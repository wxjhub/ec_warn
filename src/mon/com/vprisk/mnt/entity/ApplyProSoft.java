package com.vprisk.mnt.entity;

import java.io.Serializable;

public class ApplyProSoft implements Serializable {
	/**
	 * 应用程序监控实体类
	 * @author
	 */
	
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;//主键
	private String hostName;//主机名
	private String localIp;//IP
	private String courseCode;//应用进程代码
	
	private String courseName;//应用进程名称
	private String courseMeaning;//进程含义
	private int maxCourseNum;//进程数
	private int courseNum;//当前进程数
	private String collectDate;//采集时间
	private String courseStatus;//进程状态
	private int warningLevl;//预警级别
	private String remark;//备注
	private String col1;//预留字段
	private String col2;//预留字段
	private String col3;//预留字段
	private String userName;//用户名
	private String userPassword;//密码
	private String queryOrder;//查询指令
	
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public String getQueryOrder() {
		return queryOrder;
	}
	public void setQueryOrder(String queryOrder) {
		this.queryOrder = queryOrder;
	}

	
	public String getCourseCode() {
		return courseCode;
	}
	public void setCourseCode(String courseCode) {
		this.courseCode = courseCode;
	}
	
	public String getHostName() {
		return hostName;
	}
	public void setHostName(String hostName) {
		this.hostName = hostName;
	}
	public String getCourseMeaning() {
		return courseMeaning;
	}
	public void setCourseMeaning(String courseMeaning) {
		this.courseMeaning = courseMeaning;
	}
	public int getMaxCourseNum() {
		return maxCourseNum;
	}
	public void setMaxCourseNum(int maxCourseNum) {
		this.maxCourseNum = maxCourseNum;
	}
	public int getCourseNum() {
		return courseNum;
	}
	public void setCourseNum(int courseNum) {
		this.courseNum = courseNum;
	}
	public String getCollectDate() {
		return collectDate;
	}
	public void setCollectDate(String collectDate) {
		this.collectDate = collectDate;
	}
	/**
	 * 主键(PK)
	 * @return
	 */
	public String getUuid() {
		return uuid;
	}
	/**
	 * 
	 * @param uuid
	 */
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	/**
	 * IP地址
	 * @return
	 */
	public String getLocalIp() {
		return localIp;
	}
	/**
	 * 
	 * @param localIP
	 */
	public void setLocalIp(String localIp) {
		this.localIp = localIp;
	}

	/**
	 * 进程名称
	 * @return
	 */
	public String getCourseName() {
		return courseName;
	}
	/**
	 * 
	 * @param courseName
	 */
	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}
	/**
	 * 进程状态
	 * @return
	 */
	public String getCourseStatus() {
		return courseStatus;
	}
	/**
	 * 
	 * @param courseStatus
	 */
	public void setCourseStatus(String courseStatus) {
		this.courseStatus = courseStatus;
	}
	/**
	 * 预警级别
	 * @return
	 */
	public int getWarningLevl() {
		return warningLevl;
	}
	/**
	 * 
	 * @param warningLevl
	 */
	public void setWarningLevl(int warningLevl) {
		this.warningLevl = warningLevl;
	}
	/**
	 * 备注
	 * @return
	 */
	public String getRemark() {
		return remark;
	}
	/**
	 * 
	 * @param remark
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}
	/**
	 * 预留字段
	 * @return
	 */
	public String getCol1() {
		return col1;
	}
	/**
	 * 
	 * @param col1
	 */
	public void setCol1(String col1) {
		this.col1 = col1;
	}
	/**
	 * 预留字段
	 * @return
	 */
	public String getCol2() {
		return col2;
	}
	/**
	 * 
	 * @param col2
	 */
	public void setCol2(String col2) {
		this.col2 = col2;
	}
	/**
	 * 预留字段
	 * @return
	 */
	public String getCol3() {
		return col3;
	}
	/**
	 * 
	 * @param col3
	 */
	public void setCol3(String col3) {
		this.col3 = col3;
	}
}



