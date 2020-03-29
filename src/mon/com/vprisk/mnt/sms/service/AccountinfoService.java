package com.vprisk.mnt.sms.service;

import com.vprisk.mnt.sms.entity.Accountinfo;



/**
 * Program Name:  <br>
 * Description:  <br>
 * @author name: gzy <br>
 * Written Date: 2015年10月26日 <br>
 * Modified By: <br>
 * Modified Date: <br>
 */
public interface AccountinfoService {
	
	Accountinfo findAccountinfoByUserNumber(String userNumber);
	
	Accountinfo findAccountinfoByParams(String remarks);

	void saveOrUpdateAccountinfo(Accountinfo accountinfo);
}
