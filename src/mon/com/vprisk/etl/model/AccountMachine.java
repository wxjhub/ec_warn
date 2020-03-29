package com.vprisk.etl.model;

import java.io.Serializable;

public class AccountMachine implements Serializable {


	/**
	 *ÕË»§»úÖÆ
	 */
	private static final long serialVersionUID = 5868282049606964791L;

	private  String uuid;
	private  String serProduct;
	private  String gold;
	private  String proAccount;
	private  String setAttribute;
	private  String state;
	public String getUuid() {
		return uuid;
	}
	public void setUuid(String uuid) {
		this.uuid = uuid;
	}
	public String getSerProduct() {
		return serProduct;
	}
	public void setSerProduct(String serProduct) {
		this.serProduct = serProduct;
	}
	public String getGold() {
		return gold;
	}
	public void setGold(String gold) {
		this.gold = gold;
	}
	public String getProAccount() {
		return proAccount;
	}
	public void setProAccount(String proAccount) {
		this.proAccount = proAccount;
	}
	public String getSetAttribute() {
		return setAttribute;
	}
	public void setSetAttribute(String setAttribute) {
		this.setAttribute = setAttribute;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public AccountMachine(String uuid, String serProduct, String gold,
			String proAccount, String setAttribute, String state) {
		super();
		this.uuid = uuid;
		this.serProduct = serProduct;
		this.gold = gold;
		this.proAccount = proAccount;
		this.setAttribute = setAttribute;
		this.state = state;
	}
	public AccountMachine() {
		super();
	}
	public AccountMachine(String serProduct, String gold) {
		super();
		this.serProduct = serProduct;
		this.gold = gold;
	}
}
