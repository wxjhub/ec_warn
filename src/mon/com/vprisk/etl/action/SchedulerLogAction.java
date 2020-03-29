package com.vprisk.etl.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts2.ServletActionContext;

import com.vprisk.etl.entity.ETLContext;
import com.vprisk.etl.model.BatchHisDetailInfo;
import com.vprisk.etl.model.ProcessHisDetailInfo;
import com.vprisk.etl.model.TaskHisDetailInfo;
import com.vprisk.etl.service.BatchHisDetailInfoService;
import com.vprisk.etl.service.ProcessHisDetaiInfoService;
import com.vprisk.etl.service.TaskHisDetailInfoService;
import com.vprisk.etl.util.IpUtil;
import com.vprisk.rmplatform.components.log.LogConstants;
import com.vprisk.rmplatform.components.log.LogUtil;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;

public class SchedulerLogAction extends BaseAction {

	private TaskHisDetailInfoService taskHisDetailInfoService = (TaskHisDetailInfoService) ContextHolder.getBean("taskHisDetailInfoService");
	private BatchHisDetailInfoService batchHisDetailInfoService = (BatchHisDetailInfoService) ContextHolder.getBean("batchHisDetailInfoService");
	private ProcessHisDetaiInfoService processHisDetaiInfoService = (ProcessHisDetaiInfoService) ContextHolder.getBean("processHisDetaiInfoService");
	
	public void taskHistList(){
		HttpServletRequest request = super.getHttpRequest();
		int pageSize = Integer.parseInt(request.getParameter("rows"));
		int pageNo = Integer.parseInt(request.getParameter("page"));
		Map params = super.getRequestParams();
		String order = request.getParameter("order");//排序方式：asc or desc
		String orderBy = request.getParameter("sort");//按哪个属性排序：order prop
		Boolean isAsc = null;
		if(order!=null){
			isAsc = order.equalsIgnoreCase("asc")?true:false;
		}
		Page page = taskHisDetailInfoService.findTaskHisDetailInfoByPage(params, pageNo, pageSize, orderBy, isAsc);

		JSONObject resultObj=new JSONObject(); 
		List<TaskHisDetailInfo> taskList = page.getData();
		
		resultObj.put("rows", JSONArray.fromObject(taskList));
		resultObj.put("total", page.getTotalCount());
		
	//	LogUtil.logOperation(LogConstants.LOG_TYPE_BUSINESS, ETLContext.OPER_TYPE_BATCH,"查询批次列表",IpUtil.getIpAddr(ServletActionContext.getRequest()));
		
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
		
	}
	
	public void processHistList(){
		HttpServletRequest request = super.getHttpRequest();
		int pageSize = Integer.parseInt(request.getParameter("rows"));
		int pageNo = Integer.parseInt(request.getParameter("page"));
		String batchId = request.getParameter("batchId");
		Map params = super.getRequestParams();
		String order = request.getParameter("order");//排序方式：asc or desc
		String orderBy = request.getParameter("sort");//按哪个属性排序：order prop
		Boolean isAsc = null;
		if(order!=null){
			isAsc = order.equalsIgnoreCase("asc")?true:false;
		}	
		Page page = this.processHisDetaiInfoService.findProcessHisDetailInfoByPage(params, pageNo, pageSize, orderBy, isAsc);
		

		JSONObject resultObj=new JSONObject(); 
		List<ProcessHisDetailInfo> taskList = page.getData();
		
		resultObj.put("rows", JSONArray.fromObject(taskList));
		resultObj.put("total", page.getTotalCount());
		
	//	LogUtil.logOperation(LogConstants.LOG_TYPE_BUSINESS, ETLContext.OPER_TYPE_BATCH,"查询批次列表",IpUtil.getIpAddr(ServletActionContext.getRequest()));
		
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
	}
	
	public void batchHistList(){
		HttpServletRequest request = super.getHttpRequest();
		int pageSize = Integer.parseInt(request.getParameter("rows"));
		int pageNo = Integer.parseInt(request.getParameter("page"));
		Map params = super.getRequestParams();
		String order = request.getParameter("order");//排序方式：asc or desc
		String orderBy = request.getParameter("sort");//按哪个属性排序：order prop
		Boolean isAsc = null;
		if(order!=null){
			isAsc = order.equalsIgnoreCase("asc")?true:false;
		}	
		Page page = this.batchHisDetailInfoService.findBatchHisDetailInfoByPage(params, pageNo, pageSize, orderBy, isAsc);

		JSONObject resultObj=new JSONObject(); 
		List<BatchHisDetailInfo> taskList = page.getData();
		
		resultObj.put("rows", JSONArray.fromObject(taskList));
		resultObj.put("total", page.getTotalCount());
		
	//	LogUtil.logOperation(LogConstants.LOG_TYPE_BUSINESS, ETLContext.OPER_TYPE_BATCH,"查询批次列表",IpUtil.getIpAddr(ServletActionContext.getRequest()));
		
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error(e.getMessage());
		}
	}
}
