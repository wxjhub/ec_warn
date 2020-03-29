package com.vprisk.ftp.sys.entity;

import java.math.BigDecimal;
import java.util.Date;

 /**
 * Program Name: 用户表实体<br>
 * Description: <br>
 * @author name: AUTO_GEN<br>
 * Written Date: AUTO_GEN<br>
 * Modified By: <br>
 * Modified Date: 
 */
public class SecUser{
	private String userId; //用户编号
	private String userName; //用户名
	private String password; //密码
	private String realName; //姓名
	private String orgId; //机构ID
	private String userFlg; //启用
	private Date lockedTime; //用户锁定时间
	private Date lastLoginTime; //最后登录时间
	private String status; //生效标志
	private Long loginNum; //登录次数
	private String isFirstLogin; //是否首次登录
	private Date pwdModifyTime; //密码修改时间
	private Long pwdErrorNum; //密码错误次数
	private String oldPwd; //上次密码
	private String hisPwd; //历史密码
	private String idcard; //身份证号
	private String deptId; //部门号
	private String email; //邮件
	private String remark; //备注
	private String officePhone; //办公电话
	private String mobilePhone; //移动电话
	private String famliyPhone; //家庭电话
	private String createUser; //创建人
	private Date createTime; //创建时间
	private String updateUser; //更新人
	private Date updateTime; //更新时间
	private String empNo; //员工编号
	private String field1; //备用字段1
	private String field2; //备用字段2
	private String field3; //备用字段3
	private BigDecimal field4; //备用字段4
	private String isLdap; //是否同步到ldap
	
	public SecUser(){}

	/**
	 * 用户编号 Getter
	 */
	public String getUserId() {
		return userId;
	}
	/**
	 * 用户编号 Setter
	 */
	public void setUserId(String userId) {
		this.userId = userId;
	}
	/**
	 * 用户名 Getter
	 */
	public String getUserName() {
		return userName;
	}
	/**
	 * 用户名 Setter
	 */
	public void setUserName(String userName) {
		this.userName = userName;
	}
	/**
	 * 密码 Getter
	 */
	public String getPassword() {
		return password;
	}
	/**
	 * 密码 Setter
	 */
	public void setPassword(String password) {
		this.password = password;
	}
	/**
	 * 姓名 Getter
	 */
	public String getRealName() {
		return realName;
	}
	/**
	 * 姓名 Setter
	 */
	public void setRealName(String realName) {
		this.realName = realName;
	}
	/**
	 * 机构ID Getter
	 */
	public String getOrgId() {
		return orgId;
	}
	/**
	 * 机构ID Setter
	 */
	public void setOrgId(String orgId) {
		this.orgId = orgId;
	}
	/**
	 * 启用 Getter
	 */
	public String getUserFlg() {
		return userFlg;
	}
	/**
	 * 启用 Setter
	 */
	public void setUserFlg(String userFlg) {
		this.userFlg = userFlg;
	}
	/**
	 * 用户锁定时间 Getter
	 */
	public Date getLockedTime() {
		return lockedTime;
	}
	/**
	 * 用户锁定时间 Setter
	 */
	public void setLockedTime(Date lockedTime) {
		this.lockedTime = lockedTime;
	}
	/**
	 * 最后登录时间 Getter
	 */
	public Date getLastLoginTime() {
		return lastLoginTime;
	}
	/**
	 * 最后登录时间 Setter
	 */
	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}
	/**
	 * 生效标志 Getter
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * 生效标志 Setter
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	/**
	 * 登录次数 Getter
	 */
	public Long getLoginNum() {
		return loginNum;
	}
	/**
	 * 登录次数 Setter
	 */
	public void setLoginNum(Long loginNum) {
		this.loginNum = loginNum;
	}
	/**
	 * 是否首次登录 Getter
	 */
	public String getIsFirstLogin() {
		return isFirstLogin;
	}
	/**
	 * 是否首次登录 Setter
	 */
	public void setIsFirstLogin(String isFirstLogin) {
		this.isFirstLogin = isFirstLogin;
	}
	/**
	 * 密码修改时间 Getter
	 */
	public Date getPwdModifyTime() {
		return pwdModifyTime;
	}
	/**
	 * 密码修改时间 Setter
	 */
	public void setPwdModifyTime(Date pwdModifyTime) {
		this.pwdModifyTime = pwdModifyTime;
	}
	/**
	 * 密码错误次数 Getter
	 */
	public Long getPwdErrorNum() {
		return pwdErrorNum;
	}
	/**
	 * 密码错误次数 Setter
	 */
	public void setPwdErrorNum(Long pwdErrorNum) {
		this.pwdErrorNum = pwdErrorNum;
	}
	/**
	 * 上次密码 Getter
	 */
	public String getOldPwd() {
		return oldPwd;
	}
	/**
	 * 上次密码 Setter
	 */
	public void setOldPwd(String oldPwd) {
		this.oldPwd = oldPwd;
	}
	/**
	 * 历史密码 Getter
	 */
	public String getHisPwd() {
		return hisPwd;
	}
	/**
	 * 历史密码 Setter
	 */
	public void setHisPwd(String hisPwd) {
		this.hisPwd = hisPwd;
	}
	/**
	 * 身份证号 Getter
	 */
	public String getIdcard() {
		return idcard;
	}
	/**
	 * 身份证号 Setter
	 */
	public void setIdcard(String idcard) {
		this.idcard = idcard;
	}
	/**
	 * 部门号 Getter
	 */
	public String getDeptId() {
		return deptId;
	}
	/**
	 * 部门号 Setter
	 */
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	/**
	 * 邮件 Getter
	 */
	public String getEmail() {
		return email;
	}
	/**
	 * 邮件 Setter
	 */
	public void setEmail(String email) {
		this.email = email;
	}
	/**
	 * 备注 Getter
	 */
	public String getRemark() {
		return remark;
	}
	/**
	 * 备注 Setter
	 */
	public void setRemark(String remark) {
		this.remark = remark;
	}
	/**
	 * 办公电话 Getter
	 */
	public String getOfficePhone() {
		return officePhone;
	}
	/**
	 * 办公电话 Setter
	 */
	public void setOfficePhone(String officePhone) {
		this.officePhone = officePhone;
	}
	/**
	 * 移动电话 Getter
	 */
	public String getMobilePhone() {
		return mobilePhone;
	}
	/**
	 * 移动电话 Setter
	 */
	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}
	/**
	 * 家庭电话 Getter
	 */
	public String getFamliyPhone() {
		return famliyPhone;
	}
	/**
	 * 家庭电话 Setter
	 */
	public void setFamliyPhone(String famliyPhone) {
		this.famliyPhone = famliyPhone;
	}
	/**
	 * 创建人 Getter
	 */
	public String getCreateUser() {
		return createUser;
	}
	/**
	 * 创建人 Setter
	 */
	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}
	/**
	 * 创建时间 Getter
	 */
	public Date getCreateTime() {
		return createTime;
	}
	/**
	 * 创建时间 Setter
	 */
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	/**
	 * 更新人 Getter
	 */
	public String getUpdateUser() {
		return updateUser;
	}
	/**
	 * 更新人 Setter
	 */
	public void setUpdateUser(String updateUser) {
		this.updateUser = updateUser;
	}
	/**
	 * 更新时间 Getter
	 */
	public Date getUpdateTime() {
		return updateTime;
	}
	/**
	 * 更新时间 Setter
	 */
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	/**
	 * 员工编号 Getter
	 */
	public String getEmpNo() {
		return empNo;
	}
	/**
	 * 员工编号 Setter
	 */
	public void setEmpNo(String empNo) {
		this.empNo = empNo;
	}
	/**
	 * 备用字段1 Getter
	 */
	public String getField1() {
		return field1;
	}
	/**
	 * 备用字段1 Setter
	 */
	public void setField1(String field1) {
		this.field1 = field1;
	}
	/**
	 * 备用字段2 Getter
	 */
	public String getField2() {
		return field2;
	}
	/**
	 * 备用字段2 Setter
	 */
	public void setField2(String field2) {
		this.field2 = field2;
	}
	/**
	 * 备用字段3 Getter
	 */
	public String getField3() {
		return field3;
	}
	/**
	 * 备用字段3 Setter
	 */
	public void setField3(String field3) {
		this.field3 = field3;
	}
	/**
	 * 备用字段4 Getter
	 */
	public BigDecimal getField4() {
		return field4;
	}
	/**
	 * 备用字段4 Setter
	 */
	public void setField4(BigDecimal field4) {
		this.field4 = field4;
	}
	/**
	 * 是否同步到ldap Getter
	 */
	public String getIsLdap() {
		return isLdap;
	}
	/**
	 * 是否同步到ldap Setter
	 */
	public void setIsLdap(String isLdap) {
		this.isLdap = isLdap;
	}
	
	/**
	 * toString显示名词字段
	 */
	public String toString() {
		if(this.realName != null)
			return this.realName.toString();
		return null;
	}
	
}
