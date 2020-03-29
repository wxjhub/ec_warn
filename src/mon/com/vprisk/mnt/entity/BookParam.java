package com.vprisk.mnt.entity;

import java.io.Serializable;

public class BookParam implements Serializable {
	/**
	 * 通讯录参数维护实体类
	 * @author 
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;//主键
	private String bookName;//姓名
	private String bookTele;//手机号码
	private Integer bookWarnLvl;//预警级别
	private String bookValues;//备注 预警内容
	private String warnSort;//报警分类
	private int startTime; //开始接受时间
	private int endTime; //结束接受时间
	
	
	
	
	
	public String getWarnSort() {
		return warnSort;
	}
	public void setWarnSort(String warnSort) {
		this.warnSort = warnSort;
	}
	public int getStartTime() {
		return startTime;
	}
	public void setStartTime(int startTime) {
		this.startTime = startTime;
	}
	public int getEndTime() {
		return endTime;
	}
	public void setEndTime(int endTime) {
		this.endTime = endTime;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getBookName() {
		return bookName;
	}
	public void setBookName(String bookName) {
		this.bookName = bookName;
	}
	public String getBookTele() {
		return bookTele;
	}
	public void setBookTele(String bookTele) {
		this.bookTele = bookTele;
	}
	
	public Integer getBookWarnLvl() {
		return bookWarnLvl;
	}
	public void setBookWarnLvl(Integer bookWarnLvl) {
		this.bookWarnLvl = bookWarnLvl;
	}
	public String getBookValues() {
		return bookValues;
	}
	public void setBookValues(String bookValues) {
		this.bookValues = bookValues;
	}
}
