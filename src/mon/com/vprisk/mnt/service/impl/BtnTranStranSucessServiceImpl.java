package com.vprisk.mnt.service.impl;

import java.util.List;
import java.util.Map;
import com.vprisk.mnt.dao.BtnTranStranSucessDao;
import com.vprisk.mnt.entity.BtnSuccess;
import com.vprisk.mnt.service.BtnTranStranSucessService;
import com.vprisk.rmplatform.dao.support.Page;

public class BtnTranStranSucessServiceImpl implements BtnTranStranSucessService{
    
	private BtnTranStranSucessDao btnTranStranSucessDao;
	
	
	public BtnTranStranSucessDao getBtnTranStranSucessDao() {
		return btnTranStranSucessDao;
	}


	public void setBtnTranStranSucessDao(BtnTranStranSucessDao btnTranStranSucessDao) {
		this.btnTranStranSucessDao = btnTranStranSucessDao;
	}


	@Override
	public List<Map<String, String>> queryBtnSuccess(String minit, String resultdate) {
		return btnTranStranSucessDao.queryBtnSuccess(minit,resultdate);
	}


	@Override
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return btnTranStranSucessDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}


	@Override
	public boolean saveOrUpdateCash(BtnSuccess btnsucc) {
		return btnTranStranSucessDao.saveOrUpdateCash(btnsucc);
	}

    
}
