package com.vprisk.mnt.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.dao.ClientConfigDao;
import com.vprisk.mnt.entity.ClientConfig;
import com.vprisk.mnt.service.ClientConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;


public class ClientConfigServiceImpl implements ClientConfigService {
	
	private ClientConfigDao clientConfigDao;
	
	public ClientConfigDao getClientConfigDao() {
		return clientConfigDao;
	}
	public void setClientConfigDao(ClientConfigDao clientConfigDao) {
		this.clientConfigDao = clientConfigDao;
	}
	
	
	
	@SuppressWarnings("unchecked")
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		return clientConfigDao.selectParameterCollectiondByPage(params, pageNo,
				pageSize, orderBy, isAsc);
	}
	
	public List<ClientConfig> findParameterCollection(ClientConfig subject) {
		List<ClientConfig> list = new ArrayList<ClientConfig>();
		if(StringUtil.isNotNullOrEmpty(subject.getUuid())){
			list = clientConfigDao.findParameterCollectionByUpdate(subject);
		}
		if(StringUtil.isNullOrEmpty(subject.getUuid())){
			list = clientConfigDao.findParameterCollectionByAdd(subject);
		}
		return list;
		
	}
	
	public boolean saveOrUpdateCash(ClientConfig pracol) {
		return clientConfigDao.saveOrUpdateCash(pracol);
	}
	
	public void removeParameterCollectionByuuid(String uuid) {
		String [] str = uuid.split(",");
		for(int i=0;i<str.length;i++){
			clientConfigDao.removeParameterCollectionByuuid(str[i]);
		}
	}
	
}
