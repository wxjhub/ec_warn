package com.vprisk.mnt.sms.service.impl;

import java.util.List;

import com.vprisk.mnt.sms.dao.UserinfoDao;
import com.vprisk.mnt.sms.entity.Userinfo;
import com.vprisk.mnt.sms.service.UserinfoService;


/**
 * Program Name:  <br>
 * Description:  <br>
 * @author name: gzy <br>
 * Written Date: 2015年10月26日 <br>
 * Modified By: <br>
 * Modified Date: <br>
 */
public class UserinfoServiceImpl implements UserinfoService {
	
	private UserinfoDao userinfoDao;

	
	public UserinfoDao getUserinfoDao() {
		return userinfoDao;
	}

	public void setUserinfoDao(UserinfoDao userinfoDao) {
		this.userinfoDao = userinfoDao;
	}

	@Override
	public Userinfo saveOrUpdateUserinfo(Userinfo userinfo) {
		return (Userinfo)this.userinfoDao.saveOrUpdateUserinfo(userinfo);
	}

	@Override
	public void deleteUserinfo(String id) {
		this.userinfoDao.deleteUserinfo(id);
	}

	@Override
	public List<Userinfo> findUserinfoByStatus(String status) {
		List<Userinfo> userinfos = null;
		userinfos = this.userinfoDao.findUserinfoByStatus(status);
		return userinfos;
	}

}
