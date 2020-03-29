package com.vprisk.mnt.action;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;

import com.vprisk.common.Constants;
import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.entity.FileConfig;
import com.vprisk.mnt.entity.FileTransmission;
import com.vprisk.mnt.entity.FileWarn;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.FileConfigService;
import com.vprisk.mnt.service.FileTransmissionService;
import com.vprisk.mnt.service.FileWarnService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.components.datadict.DictUtil;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.util.StringUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * 文件传输监控action类
 * 
 */
public class FileTranControlAction extends BaseAction {
	
	
	private static final long serialVersionUID = 1L;
	private FileTransmissionService fileTransmissionService = (FileTransmissionService)super.getBean("fileTransmissionService");
	private FileConfigService fileConfigService = (FileConfigService)super.getBean("fileConfigService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
	private FileWarnService fileWarnService = (FileWarnService) super.getBean("fileWarnService");
	private String command = CommonUtils.getProp("sysuser.ec.address.fileListCheck");//获取执行接受脚本命令路径
	private String commandput = CommonUtils.getProp("sysuser.ec.address.fileListCheckput");//获取执行接受脚本命令路径
	private String ip = CommonUtils.getProp("sysuser.ec.file.ip");//获取服务器IP地址
	private String username = CommonUtils.getProp("sysuser.ec.file.name");//获取服务器用户名
	private String password = CommonUtils.getProp("sysuser.ec.file.password");//获取服务器密码-->加密
	
	/**
	 * 获取文件传输监控列表
	 */
	@SuppressWarnings("unchecked")
	public void fileTranControlList() {
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
		String tranType = (String) params.get("tranType");
		DynamicDataSourceContext.putSp(Constants.EC);
		@SuppressWarnings("rawtypes")
		Page page = this.fileTransmissionService.selectParameterCollectiondByPage(params, pageNo, pageSize,orderBy, isAsc);
		DynamicDataSourceContext.clear();
		List<FileTransmission> list=page.getData(); 
		List<Map> listMap=new ArrayList<Map>();
		Date date = new Date();
		for (FileTransmission f : list) {
			Map m = new HashMap<String, String>();
			String fileName=f.getFileName();
			m.put("fileName", fileName);
			m.put("sourseSys", f.getSourseSys());
			m.put("tranStat", f.getTranStat());
			m.put("collectDate", date);
			m.put("dataDate", f.getDataDate());
			logger.info("文件名称++"+fileName);
			//str是取文件名，系统号与0000直接部分
			String[] fileN=fileName.split("_");
			String fname= fileN[0];
			String str = "";
			if(fileName.indexOf("_0000_")==-1) {
				str=fileName.substring(0, 23);
			} else {
				str=fileName.substring(fname.length()+1, fileName.indexOf("_0000_"));
			}
			logger.info("截取后的文件名称"+str);
			List<FileConfig> fileList=fileConfigService.findFile(str);
			logger.info("配置文件中是否存在"+fileList.size());
			int warnLevel=0;
			int dealTime=0;
			String norfileSize="";
			if(!fileList.isEmpty()&& fileList.size()>0){
				 warnLevel=fileList.get(0).getWarnLevel();
				 dealTime=fileList.get(0).getDealTime();
				 norfileSize=fileList.get(0).getFileSize();
			}
			m.put("warningLevl", warnLevel);
/*			String hy="";
			//资债系统
			if(fileName.indexOf("99700270000")!=-1 && fileName.indexOf("0000")!=-1){
				hy=fileName.substring(12);//去掉"99700270000_"
				String[]h=hy.split("_0000_");
				hy=h[0];
			//柜员系统	
			}else if(fileName.indexOf("99700060000")!=-1){
				hy="99700060000";
			//机构系统
			}else if(fileName.indexOf("99700050000")!=-1){
				hy="99700050000";
			}
			
			m.put("hy", hy);*/
			String[] fileT=fileName.split("\\.");
			String fileType=fileT[1];
			m.put("fileType",fileType );
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String dateFormatdata = sdf.format(f.getDataDate());
			String ssh = "";
			if("0".equals(tranType)) {
				ssh="du -sk "+command+dateFormatdata+"/"+fileName+"|awk '{print $1}'" ;
			}
			if("1".equals(tranType)) {
				ssh="du -sk "+commandput+dateFormatdata+"/"+fileName+"|awk '{print $1}'" ;
			}
			
			int fileSize=remoteCommand(ssh);
			logger.info("定时任务脚本执行后文件数量++"+fileSize);
			m.put("fileSize",fileSize );//文件大小  （ du -sh 文件名|awk '{print $1}'）
			List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(fileName, f.getSourseSys(),ip, "5");
			logger.info("历史告警中是否存在++"+WarnHistorylist.size());
			if (WarnHistorylist.size() <= 0 && WarnHistorylist.isEmpty()) {
				//文件大小 如小于配置的最小文件大小，进行预 警
				if (!"".equals(norfileSize)&&fileSize < Integer.parseInt(norfileSize)) {
					logger.info("这条数据是报警数据"+fileName);
					String recordDescription = f.getSourseSys() + "系统文件"+ fileName + ",文件大小为" + fileSize+ ",比配置的最小文件大小小,请相关人员及时协调解决";
					// 通知人员
					String notificationPerson = "";
					// 调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
					logger.info("开始报警");
					logger.info("文件名称"+fileName); 
					warnHistoryAction.insertIntoWarnHistory(fileName,f.getSourseSys(), ip, "5",warnLevel, recordDescription, notificationPerson);
				} 
			}else{
				if (!"".equals(norfileSize)&&fileSize > Integer.parseInt(norfileSize)) {
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					warnHistoryAction.renew(WarnHistorylist);
				}
			}
			m.put("tranStartTime", f.getTranStartTime());
			m.put("tranEndTime", f.getTranEndTime());
			long fileTime=0;
			if(StringUtil.isNotNullOrEmpty(f.getTranEndTime())&&StringUtil.isNotNullOrEmpty(f.getTranEndTime())){
				 fileTime=f.getTranEndTime().getTime()-f.getTranStartTime().getTime();
			}
			m.put("fileTime",fileTime );
			String fileZt="";
			if(fileTime<=dealTime){
				 fileZt="实时";
			}else{
				 fileZt="不是实时";
			}
			m.put("fileZt",fileZt );//是否实时  ：文件处理时间 与标准处理时间比较
			listMap.add(m);
			insertModel(f, warnLevel, fileType, fileSize+"", fileTime+"", fileZt);
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(listMap));
		resultObj.put("total", page.getTotalCount());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			// 出现异常把异常信息，写进日志信息
			logger.error("文件传输监控查询异常" + e.getMessage());
		}
	}
	
	
	private int remoteCommand(String ssh){
		Connection conn = null;
		Session sess = null;
		InputStream is = null;
		BufferedReader brStat = null;
		int num = 0;
		
		try {
			//连接远程服务器，获取list文件数量
			conn = CommandRunner.getOpenedConnection(ip,username,password);
			sess = conn.openSession();//创建session
			//执行命令
			sess.execCommand(ssh);
			is = new StreamGobbler(sess.getStdout());
			//读取文件流内容
			brStat = new BufferedReader(new InputStreamReader(is));
			String line = brStat.readLine();
			while(line != null){
//				String lin = line.trim().substring(0, line.trim().length()-1);
//				String end = line.trim().substring(line.trim().length()-1);
//				num += Integer.parseInt(line.trim());
				num += Integer.parseInt(line.trim());
				line = brStat.readLine();
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			CommandRunner.closeConn(conn, sess);
		}
		return num;
	}
	
	private String remoteCommandMANDG(String ssh){
		Connection conn = null;
		Session sess = null;
		InputStream is = null;
		BufferedReader brStat = null;
		int num = 0;
		String end = "";
		Double d = 0.0;
		try {
			//连接远程服务器，获取list文件数量
			conn = CommandRunner.getOpenedConnection(ip,username,password);
			sess = conn.openSession();//创建session
			//执行命令
			sess.execCommand(ssh);
			is = new StreamGobbler(sess.getStdout());
			//读取文件流内容
			brStat = new BufferedReader(new InputStreamReader(is));
			String  line = brStat.readLine();
			while(line != null){
				String lin = line.trim().substring(0, line.trim().length()-1);
				end = line.trim().substring(line.trim().length()-1);
				if(lin.indexOf(".")!=-1) {
					d += Double.parseDouble(lin);
				} else {
					num += Integer.parseInt(lin);
				}
				line = brStat.readLine();
				logger.info("每次返回文件大小"+num);
				logger.info("每次返回文件的后缀"+end);
			}
		} catch (NumberFormatException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
			CommandRunner.closeConn(conn, sess);
		}
		if(d!=0.0) {
			return d+end;
		} else {
			return num+end;
		}
		
	}
	
	//文件数预警（自动）
	public void fileTranWarn() {
		try {
			// 调用查询文件传输预警信息方法
			List<FileConfig> ftwList = fileConfigService.findAll();
			for (int i = 0; i < ftwList.size(); i++) {
					FileConfig ftw = ftwList.get(i);
					Calendar cal = Calendar.getInstance();
					int hour = cal.get(Calendar.HOUR_OF_DAY);
					int minute = cal.get(Calendar.MINUTE);
					cal.add(Calendar.DATE, -1);
					// 系统时间大于文件最晚到达时间，进行比较文件数，如文件数不够进行预警				
					if (hour + (minute / 60.0) > ftw.getFileRecTime()) {
						SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
						//SimpleDateFormat ymd = new SimpleDateFormat("yyyy-MM-dd");
						Date date = new Date();
						Calendar calendar = Calendar.getInstance();
						if(ftw.getStyle()!=null && Constants.one.equals(ftw.getStyle())) {
//							calendar.setTime(date);
							calendar.add(calendar.DAY_OF_MONTH, -(ftw.getDatePrice()));
							String everyDay = sdf.format(calendar.getTime());
							result(ftw,everyDay);
						} else if(ftw.getStyle()!=null && Constants.two.equals(ftw.getStyle())) {
//							calendar.setTime(date);
							calendar.add(calendar.MONTH, 0);
//							calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
							calendar.set(Calendar.DAY_OF_MONTH, 0);
							String lastlday = sdf.format(calendar.getTime());
							Calendar calendarDay = Calendar.getInstance();
							calendarDay.add(calendar.DAY_OF_MONTH, -ftw.getDatePrice());
							String theday = sdf.format(calendarDay.getTime());	
							if(lastlday.equals(theday)) {
								result(ftw,theday);
							}
						} else if(ftw.getStyle()!=null && Constants.three.equals(ftw.getStyle())) {
//							calendar.setTime(date);
							calendar.add(calendar.MONTH, 0);
							calendar.set(Calendar.DAY_OF_MONTH, 0);
							calendar.setTime(calendar.getTime());
							calendar.add(calendar.DAY_OF_MONTH, -ftw.getTheOtherDay());
							String lastday = sdf.format(calendar.getTime());
							Calendar calendarDay = Calendar.getInstance();
							calendarDay.add(calendar.DAY_OF_MONTH, -ftw.getDatePrice());
							String theday = sdf.format(calendarDay.getTime());
							if(lastday.equals(theday)) {
								result(ftw,theday);
							}
						} else if(ftw.getStyle()!=null && ftw.getFixedDate()!=null && Constants.four.equals(ftw.getStyle())) {
//							calendar.setTime(date);
							calendar.add(calendar.DAY_OF_MONTH, -ftw.getDatePrice());
							String fixedday = sdf.format(calendar.getTime());
							if(sdf.format(ftw.getFixedDate()).equals(fixedday)) {
								result(ftw,fixedday);
							}
						} else {
							continue;
						}
					}
			     }
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
	
	private void result(FileConfig ftw,String dateFormatdata) {
		String ssh = "";
		if("0".equals(ftw.getFileType())) {
			ssh = "ls -lrt " + command + dateFormatdata + "/*"+ ftw.getFileName() + "*.xml|wc -l";
		}
		if("1".equals(ftw.getFileType())) {
			ssh = "ls -lrt " + commandput + dateFormatdata + "/*"+ ftw.getFileName() + "*.xml|wc -l";
		}
		logger.info("linux命令"+ssh);
		int fileSize = remoteCommand(ssh);
		logger.info("定时任务脚本执行后文件数量lrt"+fileSize);
		List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(ftw.getFileName(),ftw.getSysName(), ip, "5");
		// 实际文件数如果小于设置的文件数，进行预警
		if (fileSize < ftw.getFileNumber()) {
			String sysname = DictUtil.getDictValue("sourseSys",ftw.getSysName());
			String recordDescription = sysname + "文件在最晚到达时间"+ ftw.getFileRecTime()+ ":00止，仍没有收到文件,请相关人员及时协调解决";
			if (WarnHistorylist.size() <= 0&& WarnHistorylist.isEmpty()) {
				// 通知人员
				String notificationPerson = "";
				// 调用执行插入当前历史信息的方法							
				WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
				warnHistoryAction.insertIntoWarnHistory(ftw.getFileName(), ftw.getSysName(),ip, "5", ftw.getWarnLevel(),recordDescription, notificationPerson);
			}
		}else{
			if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
				WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
				warnHistoryAction.renew(WarnHistorylist);
			}
		}
	}
	
	
	private void insertModel(FileTransmission app,int warnLevel,String fileType,String fileSize,String fileTime,String fileZt){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		FileWarn FileWarn = new FileWarn();
			
		FileWarn.setFileName(app.getFileName());
		FileWarn.setSourseSys(app.getSourseSys());
		FileWarn.setTranStat(app.getTranStat());
		FileWarn.setCollectDate(sdf.format(cal.getTime()));
		FileWarn.setDataDate(app.getDataDate());
		FileWarn.setTranStartTime(app.getTranStartTime());
		FileWarn.setTranEndTime(app.getTranEndTime());
		FileWarn.setWarningLevl(warnLevel);
		FileWarn.setFileType(fileType);
		FileWarn.setFileSize(fileSize);
		FileWarn.setFileTime(fileTime);
		FileWarn.setFileZt(fileZt);
		FileWarn.setCol1("");
		FileWarn.setCol2("");
		FileWarn.setCol3("");
		
		
		fileWarnService.insertModel(FileWarn);
		
	}
}
	
