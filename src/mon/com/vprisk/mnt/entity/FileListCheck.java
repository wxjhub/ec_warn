package com.vprisk.mnt.entity;

import java.io.Serializable;
import java.util.Date;

public class FileListCheck implements Serializable {
	/**
	 * 关联系统LIST文件实体类
	 * @author yanggaolei
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private String uuid;//主键
	private String soursesysName;//关联系统代码
	private int listSendNum;//文件接受数（chklist）
	private int listNum;// 文件接受实际数 
	private int listNumSend;// 文件发送 （设置）
	private int factFileRecNum;//文件发送实际数
	private Date asOfDate;//备注
	private String col1;//预留字段
	private String col2;//预留字段
	
	public int getListNumSend() {
		return listNumSend;
	}
	public void setListNumSend(int listNumSend) {
		this.listNumSend = listNumSend;
	}
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getSoursesysName() {
		return soursesysName;
	}
	public void setSoursesysName(String soursesysName) {
		this.soursesysName = soursesysName;
	}
	public int getListNum() {
		return listNum;
	}
	public void setListNum(int listNum) {
		this.listNum = listNum;
	}
	public int getListSendNum() {
		return listSendNum;
	}
	public void setListSendNum(int listSendNum) {
		this.listSendNum = listSendNum;
	}
	public Date getAsOfDate() {
		return asOfDate;
	}
	public void setAsOfDate(Date asOfDate) {
		this.asOfDate = asOfDate;
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
	public int getFactFileRecNum() {
		return factFileRecNum;
	}
	public void setFactFileRecNum(int factFileRecNum) {
		this.factFileRecNum = factFileRecNum;
	}
}
