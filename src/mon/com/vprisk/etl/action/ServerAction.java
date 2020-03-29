package com.vprisk.etl.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.vprisk.common.Constants;
import com.vprisk.etl.entity.ETLContext;
import com.vprisk.etl.entity.MessageTask;
import com.vprisk.etl.event.EventMessageSend;
import com.vprisk.etl.model.Server;
import com.vprisk.etl.service.ServerService;
import com.vprisk.etl.service.TaskService;
import com.vprisk.etl.util.IpUtil;
import com.vprisk.rmplatform.components.log.LogConstants;
import com.vprisk.rmplatform.components.log.LogUtil;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.MessageUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

public class ServerAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	private ServerService serverService = (ServerService) getBean("serverService");
	private TaskService taskService=(TaskService) getBean("taskService");
	private static Logger logger  = Logger.getLogger(ServerAction.class);
	private EventMessageSend eventMessageSend = (EventMessageSend) ContextHolder.getBean("send");

	@SuppressWarnings("unchecked")
	public String findAllServers(){
		HttpServletRequest request = super.getHttpRequest();
		String check = request.getParameter("check");
		int pageSize = Integer.parseInt(request.getParameter("rows"));
		int pageNo = Integer.parseInt(request.getParameter("page"));
		Page page;
		if("1".equals(check)){
			String serverIds = request.getParameter("serverIds");
			String[] s=serverIds.split(",");
			DynamicDataSourceContext.putSp(Constants.ETL);
			page = this.serverService.checkServerByPage(s, pageNo, pageSize);
			DynamicDataSourceContext.clear();
		}else{
			Map params = super.getRequestParams();
			String order = request.getParameter("order");//排序方式：asc or desc
			String orderBy = request.getParameter("sort");//按哪个属性排序：order prop
			Boolean isAsc = null;
			if(order!=null){
				isAsc = order.equalsIgnoreCase("asc")?true:false;
			}
			DynamicDataSourceContext.putSp(Constants.ETL);
			page = this.serverService.findServerByPage(params, pageNo, pageSize, orderBy, isAsc);
			DynamicDataSourceContext.clear();
		}
		JSONObject resultObj=new JSONObject(); 
		List<Server> taskList = page.getData();
		resultObj.put("rows", JSONArray.fromObject(taskList));
		resultObj.put("total", page.getTotalCount());
		LogUtil.logOperation(LogConstants.LOG_TYPE_BUSINESS, ETLContext.OPER_TYPE_SERVER,"查询服务列表", IpUtil.getIpAddr(ServletActionContext.getRequest()));
		
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
		return null;
	}
	
	public String findAllServersByCombobox(){
		List<Server> taskList = this.serverService.findAllServers();
		JSONArray resultObj = JSONArray.fromObject(taskList);
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.debug(e.getMessage());
		}
		return null;
	}
	public String toForm(){
		
		String serverId = getHttpRequest().getParameter("serverId");
	
		if (serverId != null) {
			Server server = this.serverService.findServerByServerId(serverId);
			super.getHttpRequest().setAttribute("server", server);
		
		}
		return "toForm";
	}
	
//	public void saveServer(){
//		Server server  = (Server) BeanUtil.getObject(getHttpRequest(),Server.class);
//		String serverId=super.getHttpRequest().getParameter("serverId");
//		String serverName=super.getHttpRequest().getParameter("serverName");
//		String serverUrl=super.getHttpRequest().getParameter("serverUrl");
//		String serverPort=super.getHttpRequest().getParameter("serverPort");
//		String serverUserName=super.getHttpRequest().getParameter("serverUserName");
//		String serverPassWord=super.getHttpRequest().getParameter("serverPassWord");
//		String serverType=super.getHttpRequest().getParameter("serverType");
//		try {
//			server.setServerId(serverId);
//			server.setServerName(serverName);
//			server.setServerPassWord(serverPassWord);
//			server.setServerPort(serverPort);
//			server.setServerType(serverType);
//			server.setServerUrl(serverUrl);
//			server.setServerUserName(serverUserName);
//			serverService.saveServer(server);
//			PrintWriter pw = super.getHttpResponse().getWriter();
//			pw.print("1");
//			pw.flush();
//			pw.close();
//		} catch (Exception e) {
//			e.printStackTrace();
//			logger.debug(e.getMessage());
//		}
//		LogUtil.logAudit(LogConstants.LOG_TYPE_BUSINESS, ETLContext.OPER_TYPE_SERVER,"服务保存", server, null, server.getServerId(), IpUtil.getIpAddr(ServletActionContext.getRequest()));
//	
//	}
	
	
//	public String remove(){
//		 String serverIds=super.getHttpRequest().getParameter("serverIds");
//		 String uuids = super.getHttpRequest().getParameter("uuids");
//		 String[] a=uuids.split(",");
//		 String[] b=serverIds.split(",");
//		for (String serverId : b) {
//		      int checkServerId = taskService.findTaskCountByServerId(serverId);
//		      if(checkServerId==0){
//				  		for(int i=0;i<a.length;i++){
//				  			this.serverService.removeServerById(a[i]);
//				  			LogUtil.logOperation(LogConstants.LOG_TYPE_BUSINESS, ETLContext.OPER_TYPE_SERVER, "删除服务，服务uuid:"+a[i] , IpUtil.getIpAddr(ServletActionContext.getRequest()));
//				  		}
//		      		}else if(checkServerId>0){
//					    	  try {
//							  			PrintWriter pw = super.getHttpResponse().getWriter();
//							  			pw.print("1");
//							  			pw.flush();
//							  			pw.close();
//					  				}catch (IOException e) {
//					  					e.printStackTrace();
//					  			}
//		      		}
//			}
//		
//		return null;
//	}
	
//	public String checkServerId()throws ServletException,IOException{
//		
//		String serverId = getHttpRequest().getParameter("serverId");
//		int rsServer = this.serverService.findServerCountByServerId(serverId);
//		int flag = 0;
//		if(rsServer>0){
//			flag = 1;
//		}
//		try {
//			PrintWriter pw = super.getHttpResponse().getWriter();
//			pw.print(flag);
//			pw.flush();
//			pw.close();
//		} catch (IOException e) {
//			logger.error(e.getMessage());
//		}
//		
//		return null;	
//	}
	
	
	public String checkServerState(){
		 String serverIds=super.getHttpRequest().getParameter("serverIds");
		 String[] s=serverIds.split(",");
		 int i=0;
		 DynamicDataSourceContext.putSp(Constants.ETL);
		 serverService.startCheckServer(s);
		 DynamicDataSourceContext.clear();
		 for (String serverId : s) {
			DynamicDataSourceContext.putSp(Constants.ETL);
		    Server server = this.serverService.findServerByServerId(serverId);
		    DynamicDataSourceContext.clear();
		    if(server!=null){
		    	i++;
		    	MessageTask messageTask = new MessageTask();
		    	messageTask.setServerUrl(server.getServerUrl());
		    	messageTask.setUserName(server.getServerUserName());
		    	messageTask.setMessageType(ETLContext.MANAGEMENT_CHECHSERVER);
		    	eventMessageSend.send(server, messageTask);	
		    }
		 }
		 try {
			 String timer = MessageUtil.getSysMessage("check.server.time", "4000");
			 Thread.sleep(Integer.parseInt(timer));
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print("1");
			pw.flush();
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
			logger.debug(e.getMessage());
		}
		return null;
	}
	
}
