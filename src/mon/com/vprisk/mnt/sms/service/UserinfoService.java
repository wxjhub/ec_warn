package com.vprisk.mnt.sms.service;

import java.util.List;

import com.vprisk.mnt.sms.entity.Userinfo;

/**
 * Program Name:  <br>
 * Description:  <br>
 * @author name: gzy <br>
 * Written Date: 2015年10月26日 <br>
 * Modified By: <br>
 * Modified Date: <br>
 */
public interface UserinfoService {
	
	Userinfo saveOrUpdateUserinfo(Userinfo userinfo);
	
	void deleteUserinfo(String id);
	
	List<Userinfo> findUserinfoByStatus(String status);
	
}
