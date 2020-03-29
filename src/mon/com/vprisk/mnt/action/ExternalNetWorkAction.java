package com.vprisk.mnt.action;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

import com.ibm.icu.text.SimpleDateFormat;
import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.entity.ApplyProSoftConfig;
import com.vprisk.mnt.entity.ExternalNetWork;
import com.vprisk.mnt.entity.ExternalNetWorkConfig;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.ApplyProSoftConfigService;
import com.vprisk.mnt.service.ExternalNetWorkConfigService;
import com.vprisk.mnt.service.ExternalNetWorkService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.entity.BeanUtil;
import com.vprisk.rmplatform.util.StringUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * 网络监控测试action类
 */
public class ExternalNetWorkAction extends BaseAction {

	
	private static final long serialVersionUID = 1L;
	private ApplyProSoftConfigService applyProSoftConfigService = (ApplyProSoftConfigService) super.getBean("applyProSoftConfigService");
	private ExternalNetWorkService externalnetWorkService = (ExternalNetWorkService) super.getBean("externalNetWorkService");
	private ExternalNetWorkConfigService externalnetWorkConfigService = (ExternalNetWorkConfigService) super.getBean("externalNetWorkConfigService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
	private String ip = CommonUtils.getProp("sysuser.ec.ip");//获取服务器IP地址
	private String username = CommonUtils.getProp("sysuser.ec.name");//获取服务器用户名
	private String pass_word = CommonUtils.getProp("sysuser.ec.password");//获取服务器密码-->加密
	
	private String result;
	private String line;
	public String getLine() {
		return line;
	}
	public void setLine(String line) {
		this.line = line;
	}
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	/**
	 * 分页查监控网络信息
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String findNetWorkList(){
		HttpServletRequest request = super.getHttpRequest();
		int pageSize = Integer.parseInt(request.getParameter("rows"));//获取页行数
		int pageNo = Integer.parseInt(request.getParameter("page"));//获取页码
		
		String order = request.getParameter("order");//排序方式：asc or desc
		String orderBy = request.getParameter("sort");//按哪个属性排序：order prop
		Boolean isAsc = null;
		if(order!=null){//判断排序方式
			isAsc = order.equalsIgnoreCase("asc")?true:false;
		}
		Map params =  super.getRequestParams();//获取页面传过来的参数
		//调用按照分页查询信息的方法
		Page page = this.externalnetWorkConfigService.selectParameterCollectiondByPage(params, pageNo, pageSize, orderBy, isAsc);
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(page.getData()));
		resultObj.put("total", page.getTotalCount());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			//出现异常把异常信息，写进日志信息
			logger.error("网络监控参数维护查询异常"+e.getMessage());
		}
		return null;
		
	}
	/**
	 * 新增和修改的方法
	 * @return
	 */
	public String save(){
		ExternalNetWork detail = (ExternalNetWork) BeanUtil.getObject(getHttpRequest(), ExternalNetWork.class);
		//通过request方法获取页面传递的参数
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			//调用根据对象参数信息，对于信息新增修改时是否存在重复数据
		//	List<ExternalNetWork> list = externalnetWorkService.findParameterCollection(detail);
		//	if(list.size()<1){//判断是修改
				boolean flag = externalnetWorkService.saveOrUpdateCash(detail);	//保存，调用修改的方法
				if(flag){
					pw.print(1);
				}else{
					pw.print(3);
				}
			/*}else{
				pw.print(2);
			}*/
			pw.flush();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
			//出现异常把异常信息，写进日志信息
			logger.debug(e.getMessage());
		}
		return null;
	}
	/**
	 * 删除信息的方法
	 * @return
	 */
	public String remove(){
		//获取页面传过来的uuid
		String uuid = getHttpRequest().getParameter("uuid");
	    try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			externalnetWorkService.removeParameterCollectionByuuid(uuid);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	 * 手工调用网络监控服务检测
	 * 把信息封装成JSON对象，通过Ajax的请求返回数据信息
	 * @return 返回SUCCESS 
	 */
	public String serviceServer(){
		ExternalNetWorkConfig enw = (ExternalNetWorkConfig) BeanUtil.getObject(getHttpRequest(), ExternalNetWorkConfig.class);
		String netIP = enw.getOppositeHostIP();
		String netPort = enw.getOppositeHostPort();
		String pointIp = enw.getHostIp();
		String command = "telnet " + netIP+" "+netPort;
		Map<String,String> map = new HashMap<String,String>();
		BufferedReader br = null;
		try {
			String userName = null;
			String password = null;
			List<ApplyProSoftConfig> applyProSoftConfiglist = applyProSoftConfigService.findApplyProSoftConfig();
			for(int i=0;i<applyProSoftConfiglist.size();i++){
				ApplyProSoftConfig app = applyProSoftConfiglist.get(i);
				if(app.getLocalIp().equals(netIP)){
					userName = app.getUserName();
					password = app.getCol1();
					break;
				}
			}
			/*List<ApplyProSoft> apsList = applyProSoftService.findApplyProSoft();
			for(ApplyProSoft aps:apsList){
				if(aps.getLocalIP().equals(pointIP)){
					userName = aps.getUserName();
					password = aps.getUserPassword();
					break;
				}
			}*/
//			if(netIP.equals(ip) ){
//				userName =username;
//				password =pass_word;
//			}
			if(StringUtil.isNullOrEmpty(password)||StringUtil.isNullOrEmpty(userName)){
				PrintWriter pw=null;
				pw = super.getHttpResponse().getWriter();
				pw.print(1);
				pw.flush();
				pw.close();
				String status = "0";
			    externalnetWorkConfigService.updateExternalnetWorkByUuid(status,enw.getUuid());
				exception(enw);
				return null;
			}
			//调用远程连接服务器的方法
			Connection conn = CommandRunner.getOpenedConnection(pointIp,userName,password);
			Session sess = conn.openSession();
			//执行shell命令
			sess.execCommand(command);
			//读取执行命令的内容
			InputStream is = new StreamGobbler(sess.getStdout());
			br = new BufferedReader(new InputStreamReader(is));
//			//创建并执行命令的过程
//			Process pro = Runtime.getRuntime().exec(command);
//			//读取执行命令后的内容
//			BufferedReader br = new BufferedReader(new InputStreamReader(pro.getInputStream(),"gbk"));
			String line = ""; 
			String strs = "";
			while ((line = br.readLine()) != null) {
				strs += line+"</br>";
			}
			map.put("mess", strs);
			String status = "0";
			if(parseResult(strs,netIP)||parseResult2(strs)){
			     status = "1";
			    List<WarnHistory> list=warnHistoryService.handleStateByCourseCode("对端端口号为："+ enw.getOppositeHostPort(),"对端ip为："+enw.getOppositeHostIP(),enw.getHostIp(),"3");
			    if(list.size()==1){
			    	//warnHistoryService.updateWarnHistory(list.get(0).getUuid());
			    	WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					warnHistoryAction.renew(list);
			    }
			}else{
				 status = "0";
				exception(enw);
			}
			externalnetWorkConfigService.updateExternalnetWorkByUuid(status,enw.getUuid());
			 insertModel(enw);
			CommandRunner.closeConn(conn, sess);
			br.close();
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
			String status = "0";
			externalnetWorkConfigService.updateExternalnetWorkByUuid(status,enw.getUuid());
			exception(enw);
		}
		JSONObject jsonobject = JSONObject.fromObject(map);
		result = jsonobject.toString();
		return SUCCESS;
	}
	public boolean parseResult(String str,String IP){
		boolean flag = false;
		//Pattern p = Pattern.compile(".*Connected to "+IP+".*");
		//Pattern p = Pattern.compile(".*connection refused*");
		Pattern p = Pattern.compile(".*Connected to.*");
		Matcher m = p.matcher(str);
		flag = m.matches();
		return flag;
	}
	public boolean parseResult2(String str){
		boolean flag = false;
		Pattern p = Pattern.compile(".*ActiveMQ.*");
		Matcher m = p.matcher(str);
		flag = m.matches();
		return flag;
	}
	
	
	
	//异常处理
		public void exception(ExternalNetWorkConfig enw ){
			List<WarnHistory> list=warnHistoryService.handleStateByCourseCode("对端端口号为："+ enw.getOppositeHostPort(),"对端ip为："+enw.getOppositeHostIP(),enw.getHostIp(),"3");
			if (list.size() <=0 && list.isEmpty()) {
				 WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
				    String recordDescription = "节点IP"+enw.getOppositeHostName()+"对端系统IP"+enw.getOppositeHostIP()+"端口"+enw.getOppositeHostPort()+"连接异常";
					//通知人员
					String notificationPerson="";
					warnHistoryAction.insertIntoWarnHistory("对端端口号为："+ enw.getOppositeHostPort(),"对端ip为："+enw.getOppositeHostIP(), enw.getHostIp(), "3", enw.getWarningLevl(), recordDescription, notificationPerson);
			}
		}
	
	
	
	public void autoControl(){
		List<ExternalNetWorkConfig> enwList = externalnetWorkConfigService.findNetWork();
		for(ExternalNetWorkConfig enw:enwList){
			Connection conn = null;
			Session sess = null;
			String netPort = enw.getOppositeHostPort();
			String netIP = enw.getOppositeHostIP();
			String pointIp = enw.getHostIp();
			String command = "telnet "+netIP+" "+netPort;
			String userName = null;
			String password = null;
			List<ApplyProSoftConfig> applyProSoftConfiglist = applyProSoftConfigService.findApplyProSoftConfig();
			for(int i=0;i<applyProSoftConfiglist.size();i++){
				ApplyProSoftConfig app = applyProSoftConfiglist.get(i);
				if(app.getLocalIp().equals(netIP)){
					userName = app.getUserName();
					password = app.getCol1();
					break;
				}
			}
			/*List<ApplyProSoft> apsList = applyProSoftService.findApplyProSoft();
			for(ApplyProSoft aps:apsList){
				if(aps.getLocalIP().equals(pointIP)){
					userName = aps.getUserName();
					password = aps.getUserPassword();
					break;
				}
			}*/
			
//			if(netIP.equals(ip) ){
//				userName =username;
//				password =pass_word;
//			}
			//执行shell命令
			try {
				conn = CommandRunner.getOpenedConnection(pointIp,userName,password);
				sess = conn.openSession();
				sess.execCommand(command);
			//读取执行命令的内容
			InputStream is = new StreamGobbler(sess.getStdout());
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			String line = ""; 
			String strs = "";
				while ((line = br.readLine()) != null) {
					strs += line+"</br>";
				}
			
				String status = "0";
				if(parseResult(strs,netIP)||parseResult2(strs)){
				     status = "1";
				    List<WarnHistory> list=warnHistoryService.handleStateByCourseCode("对端端口号为："+ enw.getOppositeHostPort(),"对端ip为："+enw.getOppositeHostIP(),enw.getHostIp(),"3");
				    if(list.size()==1){
				    	//warnHistoryService.updateWarnHistory(list.get(0).getUuid());
				    	WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
						warnHistoryAction.renew(list);
				    }
				}else{
					 status = "0";
					exception(enw);
				}
				externalnetWorkConfigService.updateExternalnetWorkByUuid(status,enw.getUuid());
				 insertModel(enw);
				CommandRunner.closeConn(conn, sess);
				br.close();
				is.close();
			} catch (Exception e) {
				e.printStackTrace();
				String status = "0";
				externalnetWorkConfigService.updateExternalnetWorkByUuid(status,enw.getUuid());
				exception(enw);
			}
		}
	}
	
	
	/**
	 * 插入应用程序监控记录
	 * 
	 */
	
	private void insertModel(ExternalNetWorkConfig app){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		ExternalNetWork externalNetWork = new ExternalNetWork();
			
		externalNetWork.setHostName(app.getHostName());
		externalNetWork.setHostIp(app.getHostIp());
		
		externalNetWork.setOppositeHostName(app.getOppositeHostName());
		externalNetWork.setOppositeHostIP(app.getOppositeHostIP());
		externalNetWork.setOppositeHostPort(app.getOppositeHostPort());
		//externalNetWork.setNetMeaning(app.getNetMeaning());


		//LocalNetWork.setCollectTime(app.getCollectTime());
		externalNetWork.setCollectDate(sdf.format(cal.getTime()));
		externalNetWork.setStatus(app.getStatus());
		externalNetWork.setWarningLevl(app.getWarningLevl());
		externalNetWork.setCol1(app.getCol1());
		externalNetWork.setCol2(app.getCol2());
		externalNetWork.setCol3(app.getCol3());
		
		externalnetWorkService.insertModel(externalNetWork);
	}
}
