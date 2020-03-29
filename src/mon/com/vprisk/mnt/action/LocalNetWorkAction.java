package com.vprisk.mnt.action;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.UnknownHostException;
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
import com.vprisk.mnt.entity.LocalNetWork;
import com.vprisk.mnt.entity.LocalNetWorkConfig;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.LocalNetWorkConfigService;
import com.vprisk.mnt.service.LocalNetWorkService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.entity.BeanUtil;
import com.vprisk.rmplatform.util.StringUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

public class LocalNetWorkAction extends BaseAction {

	/**
	 * 网络监控测试action类
	 */
	private static final long serialVersionUID = 1L;
	private LocalNetWorkService localNetWorkService = (LocalNetWorkService) super.getBean("localNetWorkService");
	private LocalNetWorkConfigService localNetWorkConfigService = (LocalNetWorkConfigService) super.getBean("localNetWorkConfigService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
	private String ip = CommonUtils.getProp("sysuser.mnt.ip");//获取服务器IP地址
	private String username = CommonUtils.getProp("sysuser.mnt.name");//获取服务器用户名
	private String pass_word = CommonUtils.getProp("sysuser.mnt.password");//获取服务器密码-->加密
	
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
		Page page = this.localNetWorkConfigService.selectParameterCollectiondByPage(params, pageNo, pageSize, orderBy, isAsc);
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
		LocalNetWork detail = (LocalNetWork) BeanUtil.getObject(getHttpRequest(), LocalNetWork.class);
		//通过request方法获取页面传递的参数
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			//调用根据对象参数信息，对于信息新增修改时是否存在重复数据
		//	List<LocalNetWork> list = localNetWorkService.findParameterCollection(detail);
		//	if(list.size()<1){//判断是修改
				boolean flag = localNetWorkService.saveOrUpdateCash(detail);	//保存，调用修改的方法
				if(flag){
					pw.print(1);
				}else{
					pw.print(3);
				}
		/*	}else{
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
			localNetWorkService.removeParameterCollectionByuuid(uuid);
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
	 * @throws UnknownHostException 
	 */
	public String serviceServer() throws UnknownHostException{
		LocalNetWorkConfig lnw = (LocalNetWorkConfig) BeanUtil.getObject(getHttpRequest(), LocalNetWorkConfig.class);
		String netPort = lnw.getHostPort();
		String pointIP = lnw.getHostIp();
		//String netMeaning = lnw.getNetMeaning();
		String command = "telnet "+pointIP+" "+netPort;
		
		Map<String,String> map = new HashMap<String,String>();
		BufferedReader br = null;
		try {
			String userName = null;
			String password = null;
			/*List<ApplyProSoft> apsList = applyProSoftService.findApplyProSoft();
			for(ApplyProSoft aps:apsList){
				if(aps.getLocalIP().equals(pointIP)){
					userName = aps.getUserName();
					password = aps.getUserPassword();
					break;
				}
			}*/
			if(pointIP.equals(ip) ){
				userName =username;
				password =pass_word;
			}
			if(StringUtil.isNullOrEmpty(password)||StringUtil.isNullOrEmpty(userName)){
				PrintWriter pw = super.getHttpResponse().getWriter();
				pw.print(1);
				pw.flush();
				pw.close();
				String status = "0";
				localNetWorkConfigService.updatelocalNetWorkByUuid(status,lnw.getUuid());
				exception(lnw);
				return null;
			}
			//调用远程连接服务器的方法
			Connection conn = CommandRunner.getOpenedConnection(pointIP,userName,password);
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
			String status="0";
			if (parseResult(strs, pointIP) || parseResult2(strs)) {
				status = "1";
				List<WarnHistory> list = warnHistoryService.handleStateByCourseCode("端口号为："+ lnw.getHostPort(),lnw.getHostName(),lnw.getHostIp(),"2");
				if (list.size() == 1) {
					//warnHistoryService.updateWarnHistory(list.get(0).getUuid());
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					warnHistoryAction.renew(list);
				}
			}else{
				status = "0";
				exception(lnw);
			}
			localNetWorkConfigService.updatelocalNetWorkByUuid(status,lnw.getUuid());
			insertModel(lnw);
			CommandRunner.closeConn(conn, sess);
			br.close();
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
			String status = "0";
			localNetWorkConfigService.updatelocalNetWorkByUuid(status,lnw.getUuid());
			exception(lnw);
		}
		JSONObject jsonobject = JSONObject.fromObject(map);
		result = jsonobject.toString();
		return SUCCESS;
	}
	
	//异常处理
	public void exception(LocalNetWorkConfig lnw ){
		List<WarnHistory> list=warnHistoryService.handleStateByCourseCode("端口号为："+ lnw.getHostPort(),lnw.getHostName(),lnw.getHostIp(),"2");
		if (list.size() <=0 && list.isEmpty()) {
			 WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
			    String recordDescription = "本端节点,IP为："+lnw.getHostIp()+"，端口为："+lnw.getHostPort()+"，连接异常";
				//通知人员
				String notificationPerson="";
				warnHistoryAction.insertIntoWarnHistory("端口号为："+ lnw.getHostPort(),lnw.getHostName(), lnw.getHostIp(), "2", lnw.getWarningLevl(), recordDescription, notificationPerson);
		}
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
	public void autoControl(){
		List<LocalNetWorkConfig> lnwList = localNetWorkConfigService.findNetWork();
		for(LocalNetWorkConfig lnw:lnwList){
			Connection conn = null;
			Session sess = null;
			String netPort = lnw.getHostPort();
			String pointIP = lnw.getHostIp();
			String command = "telnet "+pointIP+" "+netPort;
			String userName = null;
			String password = null;
			/*List<ApplyProSoft> apsList = applyProSoftService.findApplyProSoft();
			for(ApplyProSoft aps:apsList){
				if(aps.getLocalIP().equals(pointIP)){
					userName = aps.getUserName();
					password = aps.getUserPassword();
					break;
				}
			}*/
			if(pointIP.equals(ip) ){
				userName =username;
				password =pass_word;
			}
			//执行shell命令
			try {
				conn = CommandRunner.getOpenedConnection(pointIP,userName,password);
				sess = conn.openSession();
				sess.execCommand(command);
			
//			Process pro=null;
//			BufferedReader br = null;
//			try {
//				//创建并执行命令的过程
//				pro = Runtime.getRuntime().exec(command);
//				//读取执行命令后的内容
//				br = new BufferedReader(new InputStreamReader(pro.getInputStream(),"gbk"));
//			} catch (IOException e1) {
//				// TODO Auto-generated catch block
//				e1.printStackTrace();
//			}
			//读取执行命令的内容
			InputStream is = new StreamGobbler(sess.getStdout());
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			String line = ""; 
			String strs = "";
				while ((line = br.readLine()) != null) {
					strs += line+"</br>";
				}
			
			String status = "0";
			if (parseResult(strs, pointIP) || parseResult2(strs)) {
				status = "1";
				List<WarnHistory> list = warnHistoryService.handleStateByCourseCode(lnw.getHostPort(),lnw.getHostName(), lnw.getHostIp(), "2");
				if (list.size() == 1) {
					//warnHistoryService.updateWarnHistory(list.get(0).getUuid());
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					warnHistoryAction.renew(list);
				}
			} else {
				status = "0";
				exception(lnw);
			}
			localNetWorkConfigService.updatelocalNetWorkByUuid(status,lnw.getUuid());
			insertModel(lnw);
			CommandRunner.closeConn(conn, sess);
			br.close();
			is.close();
			} catch (IOException e) {
				e.printStackTrace();
				String status = "0";
				localNetWorkConfigService.updatelocalNetWorkByUuid(status,lnw.getUuid());
				exception(lnw);
			}
		}
		
	}
	/*private void insertIntoWarnHistory(LocalNetWork app,String mess){
		//插入当前预警历史记录
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		WarnHistory whis = new WarnHistory();
		whis.setRecordDate(sdf.format(cal.getTime()));
		whis.setRecordName(app.getNetPort());
		whis.setPointName(app.getPointName());
		whis.setPointIp(app.getPointIP());
		whis.setWarnSort("2");
		whis.setWarnLevel(app.getWarningLevl());
		whis.setState("0");//0表示未处理
		whis.setRecordDescription(mess);
		whis.setRemark(ConstantEntity.LOCALNETWORK_REMARK);
		//调用插入历史的方法
		warnHistoryService.insertIntoWarnHistory(whis);
	}*/
	
	
	/**
	 * 插入应用程序监控记录
	 * 
	 */
	
	private void insertModel(LocalNetWorkConfig app){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		LocalNetWork localNetWork = new LocalNetWork();
			
		localNetWork.setHostName(app.getHostName());
		localNetWork.setHostIp(app.getHostIp());
		localNetWork.setHostPort(app.getHostPort());
		//localNetWork.setCollectTime(app.getCollectTime());
		localNetWork.setCollectDate(sdf.format(cal.getTime()));
		localNetWork.setStatus(app.getStatus());
		localNetWork.setWarningLevl(app.getWarningLevl());
		localNetWork.setCol1(app.getCol1());
		localNetWork.setCol2(app.getCol2());
		localNetWork.setCol3(app.getCol3());
		
		localNetWorkService.insertModel(localNetWork);
		
	}
	
}
