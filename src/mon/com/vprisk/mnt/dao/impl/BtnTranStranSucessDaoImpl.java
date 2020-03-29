package com.vprisk.mnt.dao.impl;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Criteria;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.dao.BtnTranStranSucessDao;
import com.vprisk.mnt.entity.BtnSuccess;
import com.vprisk.rmplatform.dao.hibernate.BaseDao;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

public class BtnTranStranSucessDaoImpl extends BaseDao<BtnSuccess> implements BtnTranStranSucessDao{
	
	@Override
	public List<Map<String, String>> queryBtnSuccess(String minit, String resultdate) {
		List<Map<String, String>> btn = new ArrayList<Map<String,String>>();
		StringBuilder s = new StringBuilder();
		s.append(" select pp.method_real_name,dd.method_path,count(1) as count, ");
		s.append(" sum((case when ((dd.end_millis - dd.start_millis) < "+minit+") then 1 else 0 end)) as isor ");
		s.append(" from rpm_resp_btn_log dd join rpm_resp_btn_info pp on dd.method_path = pp.method_path ");
		s.append(" where to_char(dd.start_time, 'yyyy-MM-dd') = '"+resultdate+"' group by dd.method_path, pp.method_real_name ");
		Connection conn =  CommonUtils.getConnection("cs.jdbc","Oracle");
		Statement statement = null;
		ResultSet resultSet = null;
		try {
			statement = conn.createStatement();
			resultSet = statement.executeQuery(s.toString());
			while(resultSet.next()) {
				Map<String, String> result = new HashMap<String, String>();
				result.put("methodRealName", resultSet.getString("METHOD_REAL_NAME"));
				result.put("methodPath", resultSet.getString("METHOD_PATH"));
				result.put("count", resultSet.getString("COUNT"));
				result.put("isor", resultSet.getString("ISOR"));
				btn.add(result);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return btn;
	}

	@Override
	public Page selectParameterCollectiondByPage(Map params, int pageNo,
			int pageSize, String orderBy, Boolean isAsc) {
		Criteria c = getCriteria(BtnSuccess.class);
		String recordDate = (String) params.get("recordDate"); 
		String btnName = (String) params.get("btnName"); 
		if (StringUtil.isNotNullOrEmpty(btnName)) {
			c.add(Restrictions.ilike("btnName", btnName, MatchMode.ANYWHERE));
		}
		/*if(StringUtil.isNotNullOrEmpty(recordDate))
		{
			Date dataDateTime = DateUtil.convertStringToDate(recordDate,"yyyy-MM-dd");
			c.add(Restrictions.eq("recordDate", dataDateTime));
		}*/
		if (StringUtil.isNotNullOrEmpty(recordDate)) {
			c.add(Restrictions.ilike("recordDate", recordDate,
					MatchMode.ANYWHERE));
		}
		// 判断查询所选的排序方式
		if (orderBy != null && isAsc != null) {
			if (isAsc)
				c.addOrder(Order.asc(orderBy));
			else
				c.addOrder(Order.desc(orderBy));
		} else {
			c.addOrder(Order.asc("rate"));
		}
		// 执行查询返回结果信息
		return pagedQuery(c, pageNo, pageSize);
	}

	@Override
	public boolean saveOrUpdateCash(BtnSuccess btnsucc) {
		boolean flag = false;
		try {
			super.insertOrUpdate(btnsucc);
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return flag;
	}

}
