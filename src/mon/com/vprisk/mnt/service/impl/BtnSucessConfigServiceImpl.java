package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.BtnSucessConfigDao;
import com.vprisk.mnt.entity.BtnSuccessConfig;
import com.vprisk.mnt.entity.ClientConfig;
import com.vprisk.mnt.service.BtnSucessConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class BtnSucessConfigServiceImpl implements BtnSucessConfigService{
    private BtnSucessConfigDao btnSucessConfigDao;
    
	public BtnSucessConfigDao getBtnSucessConfigDao() {
		return btnSucessConfigDao;
	}


	public void setBtnSucessConfigDao(BtnSucessConfigDao btnSucessConfigDao) {
		this.btnSucessConfigDao = btnSucessConfigDao;
	}


	@Override
	public List<BtnSuccessConfig> findBtnTime() {
		
		return btnSucessConfigDao.findBtnTime();
	}


	@Override
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return btnSucessConfigDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}


	@Override
	public List<BtnSuccessConfig> findParameterCollection(
			BtnSuccessConfig detail) {
		List<BtnSuccessConfig> list = new ArrayList<BtnSuccessConfig>();
		if(StringUtil.isNotNullOrEmpty(detail.getUuid())){
			list = btnSucessConfigDao.findParameterCollectionByUpdate(detail);
		}
		if(StringUtil.isNullOrEmpty(detail.getUuid())){
			list = btnSucessConfigDao.findParameterCollectionByAdd(detail);
		}
		return list;
	}


	@Override
	public boolean saveOrUpdateCash(BtnSuccessConfig detail) {
		return btnSucessConfigDao.saveOrUpdateCash(detail);
	}


	@Override
	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			btnSucessConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}


}
