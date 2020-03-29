package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.common.Constants;
import com.vprisk.mnt.service.impl.WarnBatchHisTaskLogService;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;

public class WarnBatchHisTaskLogAction   extends BaseAction {
	private static final long serialVersionUID = 7265538541371166357L;
	private  WarnBatchHisTaskLogService warnBatchHisTaskLogService = (WarnBatchHisTaskLogService) super.getBean("warnBatchHisTaskLogService");
	/**
     * 分页查询数据
     */
	public void query(){
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
//		DynamicDataSourceContext.putSp(Constants.ETL);
		Page page = warnBatchHisTaskLogService.queryWarnBatchHisLogByPage(params, pageNo, pageSize, orderBy, isAsc);
//		DynamicDataSourceContext.clear();
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(page.getData()));
		resultObj.put("total", page.getTotalCount());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error("文件传输监控查询异常" + e.getMessage());
		}
	}
}
