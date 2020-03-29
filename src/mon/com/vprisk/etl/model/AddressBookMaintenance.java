package com.vprisk.etl.model;

import java.io.Serializable;

public class AddressBookMaintenance implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = -1570106435521477179L;
	private String uuid;
	private String organId;
	private String organName;
	private String department;
	private String name;
	private String telephone;
	private String col1;		//COL1	VARCHAR2(255)	Y			Ô¤Áô×Ö¶Î
	private String col2;		//COL2	VARCHAR2(255)	Y			Ô¤Áô×Ö¶Î
	private String col3;		//COL3	VARCHAR2(255)	Y			Ô¤Áô×Ö¶Î
	private String col4;		//COL4	VARCHAR2(255)	Y			Ô¤Áô×Ö¶Î
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getOrganId() {
		return organId;
	}
	public void setOrganId(String organId) {
		this.organId = organId;
	}
	public String getOrganName() {
		return organName;
	}
	public void setOrganName(String organName) {
		this.organName = organName;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
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
	public String getCol4() {
		return col4;
	}
	public void setCol4(String col4) {
		this.col4 = col4;
	}
	public AddressBookMaintenance(String uuid, String organId,
			String organName, String department, String name, String telephone,
			String col1, String col2, String col3, String col4) {
		super();
		this.uuid = uuid;
		this.organId = organId;
		this.organName = organName;
		this.department = department;
		this.name = name;
		this.telephone = telephone;
		this.col1 = col1;
		this.col2 = col2;
		this.col3 = col3;
		this.col4 = col4;
	}
	public AddressBookMaintenance() {
		super();
	}

}
