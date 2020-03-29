package com.vprisk.mnt.action;

import java.io.BufferedReader;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;


import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.entity.ApplyProSoft;
import com.vprisk.mnt.entity.ApplyProSoftConfig;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.ApplyProSoftConfigService;
import com.vprisk.mnt.service.ApplyProSoftService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.mnt.service.impl.WarnBatchServiceImpl;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;


/**
 * 应用程序监控action类
 * 
 */
public class ApplyProSoftAction extends BaseAction {

	private static Log log = LogFactory.getLog(ApplyProSoftAction.class);
	private static final long serialVersionUID = 1L;
	private ApplyProSoftService applyProSoftService = (ApplyProSoftService) super.getBean("applyProSoftService");
	private ApplyProSoftConfigService applyProSoftConfigService = (ApplyProSoftConfigService) super.getBean("applyProSoftConfigService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
	private String ip = CommonUtils.getProp("sysuser.mnt.ip");//获取服务器IP地址
	private String username = CommonUtils.getProp("sysuser.ec.name");//获取服务器用户名
	private String password = CommonUtils.getProp("sysuser.ec.password");//获取服务器密码-->加密
	private String queryOrder = CommonUtils.getProp("sysuser.ec.shell.applysoft");//获取执行脚本
	//private String passwo = DESUtils.getDecryptString(password);//解密
	private String result;
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	
	
	
	
	/**
	 * 分页查询页面信息
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String findApplyProSoftList(){
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
		Page page = this.applyProSoftConfigService.selectParameterCollectiondByPage(params, pageNo, pageSize, orderBy, isAsc);
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
			logger.error("应用程序查询异常"+e.getMessage());
		}
		return null;
	}
	
	
	/**
	 * 手工调用应用进程服务检测
	 * @return 返回null
	 */
	public void serviceServer(){
		try {
			List<ApplyProSoftConfig> list = applyProSoftConfigService.findApplyProSoftConfig();
				for(int i=0;i<list.size();i++){
					ApplyProSoftConfig app = list.get(i);
					String courseStatus = "1";
					//通过服务器的IP和用户信息，在配置文件中匹配密码和执行语句(这里是暂时有1个服务端，有几个后期就配置几个)
					int num=0;
					log.info("start"+i);
                    log.info("调用的主机ip"+app.getLocalIp());
					if(app.getLocalIp()!=null&&app.getUserName()!=null&&app.getCol1()!=null&&app.getCol2()!=null) {
						num = command2(app.getLocalIp(),app.getUserName(),app.getCol1(),app.getCol2());
					}
					log.info("应用服务进程数++"+num);
					if(num==0) {
						courseStatus = "0";
					}
//					if(app.getLocalIp().equals(ip) && app.getUserName().equals(username) ){
//					    num = command2(ip,username,password,queryOrder);
//					}
//					String[] ipsum =ip.split(",");
//					String[] usernamesum =username.split(",");
//					String[] passwordsum =password.split(",");
//					String[] queryOrdersum =queryOrder.split(",");
//					int k = 0;
//					for (String s:ipsum) {
//						if(app.getLocalIp().equals(s) && app.getUserName().equals(usernamesum[k]) ){
//						    num = command2(s,usernamesum[k],passwordsum[k],queryOrdersum[k]);
//						    break;
//						}
//						k++;
//					}
					log.info("应用服务数据++"+app.getMaxCourseNum());
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(app.getHostName(), app.getServerName(), app.getLocalIp(), "1");
					log.info("根据主机名称和服务名称和主机ip查询历史告警中数据是否存在"+WarnHistorylist.size());
					//判断是否存在这个预警，如果存在状态更新，如果不存在，看状态
					if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty() && num==app.getMaxCourseNum()) {
//						if(num==app.getMaxCourseNum()){
//							courseStatus = "1";// 正常
//							log.info("是否是正常1代表正常++"+courseStatus);
//							WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
//							warnHistoryAction.renew(WarnHistorylist);
//						}
							courseStatus = "1";// 正常
							log.info("是否是正常1代表正常++"+courseStatus);
							WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
							warnHistoryAction.renew(WarnHistorylist);
					}else{
						if(num!=app.getMaxCourseNum() ){
							courseStatus = "0";//异常
							log.info("是否是异常0代表异常++"+courseStatus);
							//进程异常，手工调用不进行短信预警，并插入当前报警记录
							String recordDescription = app.getHostName()+"进程运行出现异常！";
							//通知人员
							String notificationPerson="";
							//调用执行插入当前历史信息的方法
							WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
							warnHistoryAction.insertIntoWarnHistory( app.getHostName(), app.getServerName(), app.getLocalIp(), "1", app.getWarningLevl(), recordDescription, notificationPerson);
						}else{
							//页面配置的和配置文件的配置没有匹配成功，应用服务数为0 并与配置的0相同，状态显示为异常，但并不出现在当前告警中
						}
					}
					//根据进程代码更新进程状态
				 log.info("根据进程代码更新进程状态的参数");
				 log.info("主机ip++"+app.getLocalIp());
				 log.info("应用服务用户++"+app.getUserName());
				 log.info("命令返回进程个数++"+num);
				 log.info("状态是否异常0代表异常，1代表正常++"+courseStatus);
				 applyProSoftConfigService.updateApplyProSoftConfigStatus(app.getLocalIp(),app.getUserName(),num,courseStatus,app.getHostName());
				 app.setCourseStatus(courseStatus);
				 insertModel(app);
				 log.info("end"+i);
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
	
	/**
	 * 插入应用程序监控记录
	 * 
	 */
	
	private void insertModel(ApplyProSoftConfig app){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		ApplyProSoft applyProSoft = new ApplyProSoft();
			
			applyProSoft.setHostName(app.getHostName());
			applyProSoft.setLocalIp(app.getLocalIp());
			applyProSoft.setMaxCourseNum(app.getMaxCourseNum());
			applyProSoft.setCourseNum(app.getCourseNum());
			applyProSoft.setCollectDate(sdf.format(cal.getTime()));
			applyProSoft.setCourseStatus(app.getCourseStatus());
			applyProSoft.setWarningLevl(app.getWarningLevl());
			applyProSoft.setRemark(app.getRemark());
			applyProSoft.setCol1(app.getCol1());
			applyProSoft.setCol2(app.getCol2());
			applyProSoft.setCol3(app.getCol3());
			applyProSoft.setUserName(app.getLocalIp());
			if (app.getLocalIp() == ip && app.getUserName() == username) {
			applyProSoft.setUserPassword(password);
			applyProSoft.setQueryOrder(queryOrder);
				}
		
		applyProSoftService.insertModel(applyProSoft);
		
	}
	
	
	
	
	
	/**
	 * 远程执行脚本
	 * @param string 
	 * @return 返回读取的执行shell命令的流文件内容
	 */
	private int command2(String ip,String userName,String userPassword,String queryOrder){
		BufferedReader br = null;
		int num=0;
		try {
			//调用远程连接服务器的方法
			Connection conn = CommandRunner.getOpenedConnection(ip,userName,userPassword);
			Session sess = conn.openSession();
			//执行shell命令
			sess.execCommand(queryOrder);
			//读取执行命令的内容
			InputStream is = new StreamGobbler(sess.getStdout());
			br = new BufferedReader(new InputStreamReader(is));
			String line = br.readLine();
			 num=Integer.parseInt(line.trim())-1;
			CommandRunner.closeConn(conn, sess);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return num;
	}
}
