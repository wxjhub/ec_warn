package com.vprisk.mnt.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.dao.WarnModuleConfigDao;
import com.vprisk.mnt.entity.WarnModuleConfig;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnModuleConfigDaoImpl extends BaseDao<WarnModuleConfig>  implements WarnModuleConfigDao {
	@SuppressWarnings("rawtypes")
	@Override
	public Page selectWarnModuleByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(WarnModuleConfig.class);
		String warnModuleCode = (String) params.get("warnModuleCode");// 模块名称
		String warnLevl = (String) params.get("warnLevl");//预警级别
		String warnNum = (String) params.get("warnNum");// 预警次数
		// 判断接收到的查询条件信息是否空，并根据相关信息查询
		if (StringUtil.isNotNullOrEmpty(warnModuleCode)) {
			c.add(Restrictions.eq("warnModuleCode", warnModuleCode));
		}
		if (StringUtil.isNotNullOrEmpty(warnLevl)) {
			c.add(Restrictions.eq("warnLevl", Integer.valueOf(warnLevl)));
		}
		if (StringUtil.isNotNullOrEmpty(warnNum)) {
			c.add(Restrictions.eq("warnNum", warnNum));
		}
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}
	 /**
	  * 保存修改的方法
	  * @param warnModule
	  * @return
	  */
	 public boolean saveOrUpdate(WarnModuleConfig warnModule) {
			boolean flag = false;
			try {
				super.insertOrUpdate(warnModule);
				flag = true;
			} catch (Exception e) {
				e.printStackTrace();
			}
			return flag;
		}
	 /**
	  * 删除数据
	  */
	@Override
	public void deleteByUuid(String uuid) {
		super.removeById(uuid);
	}
	@Override
	public List<WarnModuleConfig> selectWarnModuleByModuleCode(String moduleCode) {
		Criteria c = getCriteria(WarnModuleConfig.class);
		c.add(Restrictions.eq("warnModuleCode", moduleCode));
		Map param = new HashMap();
		param.put("warnModuleCode", moduleCode);
		return super.getAll(WarnModuleConfig.class, param, "warnRoundTimeS", false);
	}

}
