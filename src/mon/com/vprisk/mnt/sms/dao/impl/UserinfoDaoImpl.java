package com.vprisk.mnt.sms.dao.impl;

import java.util.List;

import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.sms.dao.UserinfoDao;
import com.vprisk.mnt.sms.entity.Userinfo;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;

/**
 * Program Name:  <br>
 * Description:  <br>
 * @author name: gzy <br>
 * Written Date: 2015年10月26日 <br>
 * Modified By: <br>
 * Modified Date: <br>
 */
public class UserinfoDaoImpl extends BaseDao<Userinfo> implements UserinfoDao {

	@Override
	public Userinfo saveOrUpdateUserinfo(Userinfo userinfo) {
		return (Userinfo)this.insertOrUpdate(userinfo);
	}

	@Override
	public void deleteUserinfo(String id) {
		this.deleteById(id, null);
	}

	@Override
	public List<Userinfo> findUserinfoByStatus(String status) {
		List<Userinfo> results = null;
		Criteria c = getCriteria(Userinfo.class);
		c.add(Restrictions.eq("status", status));
		results = c.list();
		return results;
	}

}
