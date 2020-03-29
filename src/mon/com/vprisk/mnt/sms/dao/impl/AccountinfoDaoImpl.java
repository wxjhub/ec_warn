package com.vprisk.mnt.sms.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.sms.dao.AccountinfoDao;
import com.vprisk.mnt.sms.entity.Accountinfo;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * Program Name:  <br>
 * Description:  <br>
 * @author name: gzy <br>
 * Written Date: 2015年10月26日 <br>
 * Modified By: <br>
 * Modified Date: <br>
 */
public class AccountinfoDaoImpl extends BaseDao<Accountinfo> implements AccountinfoDao {

	@Override
	public Accountinfo findAccountinfoByUserNumber(String userNumber) {
		List<Accountinfo> results = null;
		Criteria c = getCriteria(Accountinfo.class);
		c.add(Restrictions.eq("userNumber", userNumber));
		results = c.list();
		if(StringUtil.isNotNullOrEmpty(results)){
			return results.get(0);
		}else{
			return null;
		}
	}

	@Override
	public Accountinfo findAccountinfoByParams(String remarks) {
		List<Accountinfo> results = null;
		Criteria c = getCriteria(Accountinfo.class);
		c.add(Restrictions.eq("remarks", remarks));
		results = c.list();
		if(StringUtil.isNotNullOrEmpty(results)){
			return results.get(0);
		}else{
			return null;
		}
	}

	
	@Override
	public void saveOrUpdateAccountinfo(Accountinfo accountinfo) {
		 this.insertOrUpdate(accountinfo);
	}
}
