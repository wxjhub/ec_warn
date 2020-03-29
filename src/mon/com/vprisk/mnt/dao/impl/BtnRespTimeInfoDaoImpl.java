package com.vprisk.mnt.dao.impl;

import java.util.List;
import java.util.Map;

import org.hibernate.Query;

import com.vprisk.mnt.dao.BtnRespTimeInfoDao;
import com.vprisk.mnt.entity.ApplyProSoftConfig;
import com.vprisk.mnt.entity.BtnRespTimeInfo;
import com.vprisk.rmplatform.components.security.cache.Cacheable;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;
import net.sf.ehcache.config.CacheConfiguration;


public class BtnRespTimeInfoDaoImpl extends BaseDao<BtnRespTimeInfo> implements BtnRespTimeInfoDao {

	@Override
	public List<BtnRespTimeInfo> getButtonInfo() {
		return null;
		// Criteria c = this.getCriteria(BtnRespTimeInfo.class);
		// 将按钮结果添加进缓存，防止多次访问数据库造成锁表等问题
		// c.setCacheable(true);
//		return this.queryAll();
		// return c.list();
	}

	// @Override
	// public BtnRespTimeInfo queryByMethodPath(String methodPath) {
	// Map<String, Object> params = new HashMap<String, Object>();
	// params.put("methodPath", methodPath);
	// List<BtnRespTimeInfo> list = this.queryForListByMap(params);
	// if (list.size() == 0)
	// return new BtnRespTimeInfo();
	// else
	// return list.get(0);
	// }

	@Override
	public List<BtnRespTimeInfo> queryByMethodPath(String methodPath) {
//		CacheFacade cf = CacheFacade.getInstance();
//		BtnRespTimeInfo btnRespTimeInf = new BtnRespTimeInfo();
//		try {
//			if (cf.getAllCacheData("methodPathCache") == null) {
//				btnRespTimeInf = (BtnRespTimeInfo) load().get(methodPath);
//			} else {
//				btnRespTimeInf = (BtnRespTimeInfo) cf.getAllCacheData("methodPathCache").get(methodPath);
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		return btnRespTimeInf == null ? new BtnRespTimeInfo() : btnRespTimeInf;
		String hql = "from BtnRespTimeInfo where methodPath = ?";
		Query query = getSession().createQuery(hql);
		query.setParameter(0,methodPath);
		List<BtnRespTimeInfo> list = query.list();
		return list;
	}

//	@Cacheable(cacheName = "methodPathCache")
	public Map<String, Object> load() {
//		CacheFacade cf = CacheFacade.getInstance();
//		CacheManager cm = (CacheManager) ContextHolder.getBean("cacheManager");
//		List<BtnRespTimeInfo> list = this.getAll();
//		for (BtnRespTimeInfo method : list) {
//			if (cm.getCache("methodPathCache") == null) {
//				cm.addCache(new Cache(new CacheConfiguration("methodPathCache", 0)));
//			}
//			Cache cache = cm.getCache("methodPathCache");
//			cache.put(new Element(method.getMethodPath(), method));
//		}
//		Map<String, Object> menuMap = cf.getAllCacheData("methodPathCache");
//		return menuMap;
		return null;
	}

}
