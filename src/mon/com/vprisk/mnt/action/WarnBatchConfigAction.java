package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.common.Constants;
import com.vprisk.mnt.entity.WarnBatchConfig;
import com.vprisk.mnt.service.WarnBatchConfigService;

import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.entity.BeanUtil;
import com.vprisk.rmplatform.util.StringUtil;
import com.vprisk.rmplatform.web.action.BaseAction;
/**
 * 跑批配置action
 * @author lenovo
 *
 */
public class WarnBatchConfigAction   extends BaseAction {
	
	private WarnBatchConfigService warnBatchConfigService = (WarnBatchConfigService) super.getBean("warnBatchConfigService");
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
		Page page = warnBatchConfigService.queryWarnBatchByPage(params, pageNo, pageSize, orderBy, isAsc);
		logger.info("初始化查询数据量++"+page.getData().size());
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
	/**
	 * 分页查询数据
	 */
	public void queryTask(){
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
		String taskSetId = (String)params.get("taskSetId");
		logger.info("页面获取的任务组ID做查询任务编号任务名称用"+taskSetId);
		String taskId = (String)params.get("taskId");
		logger.info("页面获取的任务ID做查询任务编号任务名称用"+taskId);
		DynamicDataSourceContext.putSp(Constants.ETL);
		Page page = warnBatchConfigService.queryTaskByPage(params, pageNo, pageSize, orderBy, isAsc);
		DynamicDataSourceContext.clear();
		logger.info("页面点击选择时，弹出框查询出的数据个数"+page.getData().size());
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
	/**
	 * 查询系统批次下拉框的数据
	 */
	public void queryBatchId(){
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			DynamicDataSourceContext.putSp(Constants.ETL);
			List<Map<String,String>> batchMap = this.warnBatchConfigService.queryBatchList();
			pw.print(JSONArray.fromObject(batchMap));
			logger.info("查询系统批次下拉框的数据个数"+batchMap.size());
			DynamicDataSourceContext.clear();
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error("文件传输监控查询异常" + e.getMessage());
		}
	}
	/**
	 * 查询系统批次下拉框的数据
	 */
	public void queryTaskSetId(){
		HttpServletRequest request = super.getHttpRequest();
		String batchId = request.getParameter("batchId");// 排序方式：asc or desc
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			DynamicDataSourceContext.putSp(Constants.ETL);
			List<Map<String,String>> batchSMap = this.warnBatchConfigService.queryTaskSetList(batchId);
			pw.print(JSONArray.fromObject(batchSMap));
			logger.info("查询任务组的数据个数"+batchSMap.size());
			DynamicDataSourceContext.clear();
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error("文件传输监控查询异常" + e.getMessage());
		}
	}
	/**
	 * 查询系统批次下拉框的数据
	 */
	public void queryTaskId(){
		HttpServletRequest request = super.getHttpRequest();
		String taskSetId = request.getParameter("taskSetId");// 排序方式：asc or desc
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			DynamicDataSourceContext.putSp(Constants.ETL);
			pw.print(JSONArray.fromObject(this.warnBatchConfigService.queryTaskList(taskSetId)));
			DynamicDataSourceContext.clear();
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error("文件传输监控查询异常" + e.getMessage());
		}
	}
	
	/**
	 * 保存方法
	 * @return
	 */
	public String save(){
		WarnBatchConfig detail = (WarnBatchConfig) BeanUtil.getObject(getHttpRequest(), WarnBatchConfig.class);
		// 通过request方法获取页面传递的参数
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			// 调用根据对象参数信息，对于信息新增修改时是否存在重复数据
			boolean flag = warnBatchConfigService.saveOrUpdateWarnBatchConfig(detail);
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
		return null;
	}
	/**
	 * 删除信息的方法
	 * @return
	 */
	public String remove() {
		// 获取页面传过来的uuid
		String uuid = getHttpRequest().getParameter("uuid");
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			warnBatchConfigService.removeByUuid(uuid);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 跳转到编辑页面
	 * @return
	 */
	public String toForm(){
	    String uuid = super.getHttpRequest().getParameter("uuid");
	    if (uuid != null) {
	      WarnBatchConfig detail = this.warnBatchConfigService.queryById(uuid);
	      if(StringUtil.isNotNullOrEmpty(detail.getTaskId())){
	    	  DynamicDataSourceContext.putSp(Constants.ETL);
	    	  detail.setTaskName(this.warnBatchConfigService.queryTaskNameByTaskId(detail.getTaskId()));
	    	  DynamicDataSourceContext.clear();
	      }
	      super.getHttpRequest().setAttribute("detail", detail);
	    }
	    return "toForm";
	}
}
