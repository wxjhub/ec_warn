package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.mnt.entity.SqlBlockConfig;
import com.vprisk.mnt.service.SqlBlockConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.entity.BeanUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * sql阻塞监控配置action类
 * 
 * @author
 */
public class SqlBlockConfigAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	private SqlBlockConfigService sqlBlockConfigService = (SqlBlockConfigService) super.getBean("sqlBlockConfigService");
	

	@SuppressWarnings("unchecked")
	public String findList() {
		HttpServletRequest request = super.getHttpRequest();
		int pageSize = Integer.parseInt(request.getParameter("rows"));// 获取页行数
		int pageNo = Integer.parseInt(request.getParameter("page"));// 获取页码

		String order = request.getParameter("order");// 排序方式：asc or desc
		String orderBy = request.getParameter("sort");// 按哪个属性排序：order prop
		Boolean isAsc = null;
		if (order != null) {// 判断排序方式
			isAsc = order.equalsIgnoreCase("asc") ? true : false;
		}
		Map params = super.getRequestParams();// 获取页面传过来的参数

		// 调用按照分页查询信息的方法
		Page page = this.sqlBlockConfigService.selectParameterCollectiondByPage(params, pageNo, pageSize,
						orderBy, isAsc);

		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(page.getData()));
		resultObj.put("total", page.getTotalCount());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			// 出现异常把异常信息，写进日志信息
			logger.error("应用程序查询异常" + e.getMessage());
		}
		return null;
	}

	/**
	 * 新增和修改的方法
	 * 
	 * @return
	 */
	public String save() {
		SqlBlockConfig detail = (SqlBlockConfig) BeanUtil.getObject(
				getHttpRequest(), SqlBlockConfig.class);
		// 通过request方法获取页面传递的参数
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			// 调用根据对象参数信息，对于信息新增修改时是否存在重复数据
			List<SqlBlockConfig> list = sqlBlockConfigService.findParameterCollection(detail);
			if (list.size() < 1) {// 判断是修改
				boolean flag = sqlBlockConfigService.saveOrUpdateCash(detail);// 保存，调用修改的方法
				if (flag) {
					pw.print(1);
				} else {
					pw.print(3);
				}
			} else {
				pw.print(2);
			}
			pw.flush();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
			// 出现异常把异常信息，写进日志信息
			logger.debug(e.getMessage());
		}
		return null;
	}

	/**
	 * 删除信息的方法
	 * 
	 * @return
	 */
	public String remove() {
		// 获取页面传过来的uuid
		String uuid = getHttpRequest().getParameter("uuid");
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			sqlBlockConfigService.removeParameterCollectionByuuid(uuid);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

}
