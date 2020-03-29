package com.vprisk.mnt.sms.service.impl;

import com.vprisk.mnt.sms.dao.AccountinfoDao;
import com.vprisk.mnt.sms.entity.Accountinfo;
import com.vprisk.mnt.sms.service.AccountinfoService;


/**
 * Program Name:  <br>
 * Description:  <br>
 * @author name: gzy <br>
 * Written Date: 2015年10月26日 <br>
 * Modified By: <br>
 * Modified Date: <br>
 */
public class AccountinfoServiceImpl implements AccountinfoService {
	
	private AccountinfoDao accountinfoDao;

	public AccountinfoDao getAccountinfoDao() {
		return accountinfoDao;
	}

	public void setAccountinfoDao(AccountinfoDao accountinfoDao) {
		this.accountinfoDao = accountinfoDao;
	}

	@Override
	public Accountinfo findAccountinfoByUserNumber(String userNumber) {
		return accountinfoDao.findAccountinfoByUserNumber(userNumber);
	}

	@Override
	public Accountinfo findAccountinfoByParams(String remarks) {
		return accountinfoDao.findAccountinfoByParams(remarks);
	}

	@Override
	public void saveOrUpdateAccountinfo(Accountinfo accountinfo) {
		accountinfoDao.saveOrUpdateAccountinfo(accountinfo);
	}



}
