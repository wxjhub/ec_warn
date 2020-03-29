package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.common.Constants;
import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.base.SMSSendForApiAction;
import com.vprisk.mnt.entity.TableAnalysis;
import com.vprisk.mnt.entity.TableAnalysisConfig;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.TableAnalysisConfigService;
import com.vprisk.mnt.service.TableAnalysisService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * 表分析 Action 类
 * 
 */
public class TableAnalysisAction extends BaseAction {

	
	private static final long serialVersionUID = 1L;
	private TableAnalysisService tableAnalysisService = (TableAnalysisService) super.getBean("tableAnalysisService");
	private TableAnalysisConfigService tableAnalysisConfigService = (TableAnalysisConfigService) super.getBean("tableAnalysisConfigService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
	private String username = CommonUtils.getProp("ec.jdbc.username");//获取服务器用户名
	private String ip = CommonUtils.getProp("ec.jdbc.ip");//获取服务器用户名
	
	private String result;
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	
	
	@SuppressWarnings("unchecked")
	public String findList(){
		HttpServletRequest request = super.getHttpRequest();
		String user = request.getParameter("user");// 获取页行数
		/*if (user==""||user=="null"||("rpm").equals(user)||user==null) {
			DynamicDataSourceContext.putSp(Constants.RPM);
		} else if (user.equals("cognos_rep")) {
			DynamicDataSourceContext.putSp(Constants.COGNOS_REP);
		}*/
		Map params =  super.getRequestParams();//获取页面传过来的参数
		//调用按照分页查询信息的方法
		String order = request.getParameter("order");// 排序方式：asc or desc
		Boolean isAsc = null;
		if (order != null) {// 判断排序方式
			isAsc = order.equalsIgnoreCase("asc") ? true : false;
		}
		DynamicDataSourceContext.putSp(Constants.EC);
		Page page = this.tableAnalysisService.findList(params);
		DynamicDataSourceContext.clear();
		List<TableAnalysis> list=page.getData(); 
		List<Map> listMap=new ArrayList<Map>();
		if(!list.isEmpty()||list.size()>0){
			for (TableAnalysis f : list) {
				Map m = new HashMap<String, String>();
				m.put("tablespaceName",(String)f.getTablespaceName());
				m.put("tableName",(String)f.getTableName());
				m.put("lastAnalyzed",f.getLastAnalyzed());
				m.put("sampleSize",f.getSampleSize()+"");
			
				/*if (user==""||user=="null"||("rpm").equals(user)||user==null) {
					DynamicDataSourceContext.putSp(Constants.RPM);
				} else if (user.equals("cognos_rep")) {
					DynamicDataSourceContext.putSp(Constants.COGNOS_REP);
				}*/
				//通过表名，查询该表的数据量
				DynamicDataSourceContext.putSp(Constants.EC);
				int tableSize=tableAnalysisService.selectTableSize((String)f.getTableName());
				DynamicDataSourceContext.clear();
				m.put("tableSize",tableSize+"");
				List <TableAnalysisConfig> tablelist=tableAnalysisConfigService.findTableAnalysisConfig();
				int warnLevel=1;
				String dataDeviationValues="0";
				if (tablelist.size() > 0 && !tablelist.isEmpty()) {
					warnLevel=tablelist.get(0).getWarningLevl();
					dataDeviationValues=tablelist.get(0).getDataDeviationValues();
				}
				int  dataDeviation=Integer.parseInt(dataDeviationValues);
				BigDecimal data=BigDecimal.valueOf(dataDeviation);
				
				if(f.getLastAnalyzed()!=null){
					//现在检测为正常时，查看当前预警中此数据     
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(),ip,"11");
					logger.info("查询WarnHistorylist数据量++"+WarnHistorylist.size());
					if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
						for (int j = 0; j < WarnHistorylist.size(); j++) {
							WarnHistory warm = WarnHistorylist.get(j);
							logger.info("确认时间++"+warm.getEndDate());
							//取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
							if (warm.getEndDate() == null||warm.getEndDate().equals("")) {
								warnHistoryService.updateWarnHistory(warm.getUuid());
							}
						}
						WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
						logger.info("准备发短信----------------------------------------");
						warnHistoryAction.renew(WarnHistorylist);
					}
				}else{
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(), ip, "11");
					if (WarnHistorylist.size() <=0 && WarnHistorylist.isEmpty()) {
					//进程异常，进行短信预警，并插入当前报警记录
					String recordDescription = "数据库用户："+username+"，表："+(String)f.getTableName()+"，表分析异常！(表分析时间异常)";
					//通知人员
					String notificationPerson="";
					//调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					logger.info("准备发告警错误短信----------------------------------------");
					warnHistoryAction.insertIntoWarnHistory( f.getTablespaceName(),(String)f.getTableName(), ip, "11",warnLevel, recordDescription, notificationPerson);
					}
				}
				BigDecimal tableSize2=new BigDecimal(tableSize);
				BigDecimal deviation;
				if(f.getSampleSize()==null){
					 deviation=tableSize2;
				}else{
					 deviation= tableSize2.subtract(f.getSampleSize());
				}
				m.put("deviation",deviation);
				if(deviation.compareTo(data) < 0){
					//现在检测为正常时，查看当前预警中此数据
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(), ip, "15");
					logger.info("查询WarnHistorylist数据量++"+WarnHistorylist.size());
					if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
						for (int j = 0; j < WarnHistorylist.size(); j++) {
							WarnHistory warm = WarnHistorylist.get(j);
							logger.info("确认时间++"+warm.getEndDate());
							//取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
							if (warm.getEndDate() == null||warm.getEndDate().equals("")) {
								warnHistoryService.updateWarnHistory(warm.getUuid());
							}
						}
						WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
						logger.info("准备发短信----------------------------------------");
						warnHistoryAction.renew(WarnHistorylist);
					}
				}else if(deviation.compareTo(data) > 0){
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(), ip, "15");
					if (WarnHistorylist.size() <=0 && WarnHistorylist.isEmpty()) {
					//进程异常，进行短信预警，并插入当前报警记录
					String recordDescription = "数据库用户："+username+"，表："+(String)f.getTableName()+"，表分析异常！(表分析数据量异常)";
					//通知人员
					String notificationPerson="";
					//调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					logger.info("准备发告警错误短信----------------------------------------");
					warnHistoryAction.insertIntoWarnHistory( f.getTablespaceName(),(String)f.getTableName(), ip, "15",warnLevel, recordDescription, notificationPerson);
					}
					
				}
				insertModel(f,tableSize2,deviation);
				listMap.add(m);
			}
		}
		JSONObject resultObj = new JSONObject();
//		resultObj.put("rows", JSONArray.fromObject(page.getData()));
		resultObj.put("total", page.getTotalCount());
		resultObj.put("rows", JSONArray.fromObject(listMap));
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
	
	public void autoControl() {
		DynamicDataSourceContext.putSp(Constants.EC);
		List<TableAnalysis> list = this.tableAnalysisService.findList();
		DynamicDataSourceContext.clear();
		List<Map> listMap=new ArrayList<Map>();
		SMSSendForApiAction smfa = new SMSSendForApiAction();
		if(!list.isEmpty()||list.size()>0){
			for (TableAnalysis f : list) {
				Map m = new HashMap<String, String>();
				m.put("tablespaceName",(String)f.getTablespaceName());
				m.put("tableName",(String)f.getTableName());
				m.put("lastAnalyzed",f.getLastAnalyzed());
				m.put("sampleSize",f.getSampleSize()+"");
			
				/*if (user==""||user=="null"||("rpm").equals(user)||user==null) {
					DynamicDataSourceContext.putSp(Constants.RPM);
				} else if (user.equals("cognos_rep")) {
					DynamicDataSourceContext.putSp(Constants.COGNOS_REP);
				}*/
				//通过表名，查询该表的数据量
				DynamicDataSourceContext.putSp(Constants.EC);
				int tableSize=tableAnalysisService.selectTableSize((String)f.getTableName());
				DynamicDataSourceContext.clear();
				m.put("tableSize",tableSize+"");
				List <TableAnalysisConfig> tablelist=tableAnalysisConfigService.findTableAnalysisConfig();
				int warnLevel=1;
				String dataDeviationValues="";
				if (tablelist.size() > 0 && !tablelist.isEmpty()) {
					warnLevel=tablelist.get(0).getWarningLevl();
					dataDeviationValues=tablelist.get(0).getDataDeviationValues();
				}
				int  dataDeviation=Integer.parseInt(dataDeviationValues);
				BigDecimal data=BigDecimal.valueOf(dataDeviation);
				
				if(f.getLastAnalyzed()!=null){
					//现在检测为正常时，查看当前预警中此数据     
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(),ip,"11");
					logger.info("查询WarnHistorylist数据量++"+WarnHistorylist.size());
					if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
						for (int j = 0; j < WarnHistorylist.size(); j++) {
							WarnHistory warm = WarnHistorylist.get(j);
							logger.info("确认时间++"+warm.getEndDate());
							//取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
							if (warm.getEndDate() == null||warm.getEndDate().equals("")) {
								warnHistoryService.updateWarnHistory(warm.getUuid());
							}
						}
						WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
						logger.info("准备发短信----------------------------------------");
						warnHistoryAction.renew(WarnHistorylist);
					}
				}else{
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(), ip, "11");
					if (WarnHistorylist.size() <=0 && WarnHistorylist.isEmpty()) {
					//进程异常，进行短信预警，并插入当前报警记录
					String recordDescription = "数据库用户："+username+"，表："+(String)f.getTableName()+"，表分析异常！(表分析时间异常)";
					//通知人员
					String notificationPerson="";
					//调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					warnHistoryAction.insertIntoWarnHistory( f.getTablespaceName(),(String)f.getTableName(), "", "11",warnLevel, recordDescription, notificationPerson);
					}
				}
				BigDecimal tableSize2=new BigDecimal(tableSize);
				BigDecimal deviation;
				if(f.getSampleSize()==null){
					 deviation=tableSize2;
				}else{
					 deviation= tableSize2.subtract(f.getSampleSize());
				}
				m.put("deviation",deviation);
				if(deviation.compareTo(data) < 0){
					//现在检测为正常时，查看当前预警中此数据
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(), ip, "15");
					logger.info("查询WarnHistorylist数据量++"+WarnHistorylist.size());
					if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
						for (int j = 0; j < WarnHistorylist.size(); j++) {
							WarnHistory warm = WarnHistorylist.get(j);
							logger.info("确认时间++"+warm.getEndDate());
							//取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
							if (warm.getEndDate() == null||warm.getEndDate().equals("")) {
								warnHistoryService.updateWarnHistory(warm.getUuid());
							}
						}
						WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
						warnHistoryAction.renew(WarnHistorylist);
					}
				}else if(deviation.compareTo(data) > 0){
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTablespaceName(),(String)f.getTableName(), ip, "15");
					if (WarnHistorylist.size() <=0 && WarnHistorylist.isEmpty()) {
					//进程异常，进行短信预警，并插入当前报警记录
					String recordDescription = "数据库用户："+username+"，表："+(String)f.getTableName()+"，表分析异常！(表分析数据量异常)";
					//通知人员
					String notificationPerson="";
					//调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					warnHistoryAction.insertIntoWarnHistory( f.getTablespaceName(),(String)f.getTableName(), "", "15",warnLevel, recordDescription, notificationPerson);
					}
					
				}
				insertModel(f,tableSize2,deviation);
				listMap.add(m);
			}
		}
	}
	
	
	
	
	/**
	 * 插入应用程序监控记录
	 * 
	 */
	
	private void insertModel(TableAnalysis ana,BigDecimal tableSize,BigDecimal deviation){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		TableAnalysis tableAnalysis = new TableAnalysis();
			
		tableAnalysis.setTablespaceName(ana.getTablespaceName());
		tableAnalysis.setTableName(ana.getTableName());
		tableAnalysis.setLastAnalyzed(ana.getLastAnalyzed());
		tableAnalysis.setSampleSize(ana.getSampleSize());
		tableAnalysis.setTableSize(tableSize);
		tableAnalysis.setDeviation(deviation);
		tableAnalysis.setWarningLevl(ana.getWarningLevl());
		tableAnalysis.setCollectDate(sdf.format(cal.getTime()));
		
		tableAnalysisService.insertModel(tableAnalysis);
		
	}
}
