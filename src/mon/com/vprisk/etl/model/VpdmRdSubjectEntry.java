package com.vprisk.etl.model;

import java.io.Serializable;

public class VpdmRdSubjectEntry implements Serializable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private  String subjectId;
	private  String subjectName;
	private  String entryCode;
	private  String dsubjceId;
	private  String dsubjectName;
	private  String csubjectId;
	private  String csubjectName;
	private  String summary;
	public String getSubjectId() {
		return subjectId;
	}
	public void setSubjectId(String subjectId) {
		this.subjectId = subjectId;
	}
	public String getSubjectName() {
		return subjectName;
	}
	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}
	public String getEntryCode() {
		return entryCode;
	}
	public void setEntryCode(String entryCode) {
		this.entryCode = entryCode;
	}
	public String getDsubjceId() {
		return dsubjceId;
	}
	public void setDsubjceId(String dsubjceId) {
		this.dsubjceId = dsubjceId;
	}
	public String getDsubjectName() {
		return dsubjectName;
	}
	public void setDsubjectName(String dsubjectName) {
		this.dsubjectName = dsubjectName;
	}
	public String getCsubjectId() {
		return csubjectId;
	}
	public void setCsubjectId(String csubjectId) {
		this.csubjectId = csubjectId;
	}
	public String getCsubjectName() {
		return csubjectName;
	}
	public void setCsubjectName(String csubjectName) {
		this.csubjectName = csubjectName;
	}
	public String getSummary() {
		return summary;
	}
	public void setSummary(String summary) {
		this.summary = summary;
	}
	
}
