package com.vprisk.mnt.dao.impl;

import com.vprisk.mnt.dao.BtnRespTimeLogDao;
import com.vprisk.mnt.entity.BtnRespTimeLog;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;

public class BtnRespTimeLogDaoImpl extends BaseDao<BtnRespTimeLog> implements BtnRespTimeLogDao {

	@Override
	public void saveLog(BtnRespTimeLog log) {
		super.save(log);

	}

}
