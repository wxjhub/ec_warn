package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.mnt.entity.WarnInterval;
import com.vprisk.mnt.service.WarnIntervalService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.entity.BeanUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * 预警时间间隔设置action类
 * 
 * @author wanglin
 */
public class WarnIntervalAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	private WarnIntervalService warnIntervalService = (WarnIntervalService) super
			.getBean("warnIntervalService");

	/**
	 * 显示预警时间间隔设置条目
	 */
	@SuppressWarnings("unchecked")
	public void showList() {
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
		Page page = this.warnIntervalService.selectParameterCollectiondByPage(
				params, pageNo, pageSize, orderBy, isAsc);
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
			logger.error("预警时间间隔设置异常" + e.getMessage());
		}

	}

	public void save() {

		WarnInterval detail = (WarnInterval) BeanUtil.getObject(
				getHttpRequest(), WarnInterval.class);
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			// 调用根据对象参数信息，对于信息新增修改时是否存在重复数据
			boolean flag = warnIntervalService.saveOrUpdateCash(detail); // 保存，调用修改的方法
			if (flag) {
				pw.print(1);
			} else {
				pw.print(3);
			}
			pw.flush();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
			// 出现异常把异常信息，写进日志信息
			logger.debug(e.getMessage());
		}
	}
	/**
	 * 根据预警时间代码查询对应关联的预警时间
	 * @param warnCode 预警时间间隔代码
	 * @author yanggaolei
	 * @param warnCode 预警对象ID
	 * @param status 执行方法状态
	 * @date 2015-5-19（新增）
	 * @return 返回预警时间间隔对象
	 */
	public WarnInterval WarnIntervalByWarnCode(String warnCode, String status,String datedata){
		WarnInterval wi = null;
		if("find".equals(status)){
			wi =  warnIntervalService.findWarnIntervalByWarnCode(warnCode);
		}else if("update".equals(status)){
			warnIntervalService.updateWarnIntervalByWarnCode(warnCode,datedata);
		}
		return wi;
	}
	
	
	/**
	 * 删除信息的方法
	 * @return
	 */
	public String remove(){
		//获取页面传过来的uuid
		String warnIntervalId = getHttpRequest().getParameter("warnIntervalId");
			warnIntervalService.removeParameterCollectionByuuid(warnIntervalId);
		return null;
	}
}
