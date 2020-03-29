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
import com.vprisk.mnt.entity.BookParam;
import com.vprisk.mnt.entity.ConstantEntity;
import com.vprisk.mnt.entity.DayEndMonitor;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.BookParamService;
import com.vprisk.mnt.service.DayEndMonitorService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;


/**
 * 日终监控Action类
 */
public class DayEndMonitorAction extends BaseAction {

	
	private static final long serialVersionUID = 1L;
	private DayEndMonitorService dayEndMonitorService = (DayEndMonitorService) super.getBean("dayEndMonitorService");
	private BookParamService bookParamService = (BookParamService) super.getBean("bookParamService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
//	private DayEndConfigService dayEndConfigService = (DayEndConfigService) super.getBean("dayEndConfigService");
	private String ip = CommonUtils.getProp("etl.jdbc.ip");//获取服务器IP地址
	
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
		SMSSendForApiAction smfa = new SMSSendForApiAction();
//		Map params = super.getRequestParams();
//		DynamicDataSourceContext.putSp(Constants.ETL);
//		//调用按照分页查询信息的方法
//		List<DayEndMonitor> list = this.dayEndMonitorService.findList(params);
//		DynamicDataSourceContext.clear();
		int pageSize = Integer.parseInt(request.getParameter("rows"));// 获取页行数
		int pageNo = Integer.parseInt(request.getParameter("page"));// 获取页码
		String order = request.getParameter("order");// 排序方式：asc or desc
		String orderBy = request.getParameter("sort");// 按哪个属性排序：order prop
		Boolean isAsc = null;
		if (order != null) {// 判断排序方式
			isAsc = order.equalsIgnoreCase("asc") ? true : false;
		}
		Map params = super.getRequestParams();// 获取页面传过来的参数
		logger.info("日期"+params.get("asOfDate"));
		DynamicDataSourceContext.putSp(Constants.ETL);
		Page page = dayEndMonitorService.queryWarnBatchHisLogByPage(params, pageNo, pageSize, orderBy, isAsc);
		DynamicDataSourceContext.clear();
		List<DayEndMonitor> data = page.getData();
		logger.info("查询etl数据个数"+data.size());
		List<Map> listMap=new ArrayList<Map>();
		for(DayEndMonitor f:data){ 
			Map m = new HashMap<String, String>();
			m.put("batchId",(String)f.getBatchId());
			logger.info("批次编号"+f.getBatchId());
			m.put("jobId",(String)f.getJobId());
			m.put("processId",(String)f.getProcessId());
			m.put("taskId",(String)f.getTaskId());
			m.put("runFlag",f.getRunFlag());	//0未运行，1正在运行，2已完成，-1错误
			m.put("runTime",(String)f.getRunTime());
			m.put("count",(BigDecimal)f.getCount());
			m.put("errorMessage",f.getErrorMessage());
			m.put("asOfDate",f.getAsOfDate());
			m.put("stdTime",f.getStdTime());
			m.put("endTime",f.getEndTime());
			m.put("batchName",f.getBatchName());
			logger.info("批次名称"+f.getBatchName());
			m.put("taskName",f.getTaskName());
			m.put("processName",f.getProcessName());
//		if(!list.isEmpty()||list.size()>0){
//			for (DayEndMonitor f : list) {
//				Map m = new HashMap<String, String>();
//				m.put("batchId",(String)f.getBatchId());
//				m.put("jobId",(String)f.getJobId());
//				m.put("processId",(String)f.getProcessId());
//				m.put("taskId",(String)f.getTaskId());
//				m.put("runFlag",f.getRunFlag()+"");	//0未运行，1正在运行，2已完成，-1错误
//				m.put("runTime",(String)f.getRunTime());
//				m.put("count",(BigDecimal)f.getCount());
//				m.put("errorMessage",f.getErrorMessage()+"");
//				String time=f.getAsOfDate()+"";
//				String array[] =time.split(" ");
//				String dateTime=array[0];
//				m.put("asOfDate",dateTime);
//				m.put("stdTime",f.getStdTime()+"");
//				m.put("endTime",f.getEndTime()+"");
			/*List<DayEndConfig> dayEndConfig = dayEndConfigService.findAll();
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss");
			String time = sdf.format(date);*/
			if(!f.getRunFlag().equals("-1")){
					//现在检测为正常时，查看当前预警中此数据
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getBatchName(),Constants.ETL,ip,"13");
					logger.info("现在检测为正常时，查看当前预警中此数据个数"+WarnHistorylist.size());
					if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
						for (int j = 0; j < WarnHistorylist.size(); j++) {
							WarnHistory warm = WarnHistorylist.get(j);
							//取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
							if (warm.getEndDate() == null||warm.getEndDate().equals("")) {
								warnHistoryService.updateWarnHistory(warm.getUuid());
							}
						}
					}
				}else{
					//进程异常，进行短信预警，并插入当前报警记录
					String mess = f.getAsOfDate()+"，日终异常！"+f.getErrorMessage();
					//根据应用进程预警级别查询相关联的预警人员
					//这里日终没有预警级别，默认设置为1
					List<BookParam> listtele = bookParamService.findBookParamByWarnLvl(1);
					logger.info("根据应用进程预警级别查询相关联的预警人员"+listtele.size());
					if(listtele.size()>0){
						for(int m2=0;m2<listtele.size();m2++){
							//调用发送短信的方法
							smfa.sendInfo(mess, listtele.get(m2));
						}
						listtele = null;
					}
					//调用执行插入当前历史信息的方法
					insertIntoWarnHistory(f.getBatchName(),Constants.ETL,1,f.getErrorMessage(), mess);
				}
				listMap.add(m);
				logger.info("返回数据个数"+listMap.size());
//			}
//		}
		  }
		JSONObject resultObj = new JSONObject();
		//resultObj.put("rows", JSONArray.fromObject(page.getData()));
		//resultObj.put("total", page.getTotalCount());
		resultObj.put("rows", JSONArray.fromObject(listMap));
//		resultObj.put("rows", JSONArray.fromObject(page.getData()));
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
	 * 插入当前历史预警信息
	 * @param app 应用程序对象
	 * @param mess 短信发送信息
	 * @return 无
	 */
	private void insertIntoWarnHistory(String BatchId,String asOfDate,int warnLevel,String errorMessage ,String mess){
		//插入当前预警历史记录
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		
		WarnHistory whis = new WarnHistory();
		whis.setPointName(BatchId);//节点名称  写入的是批次编号
		whis.setPointIp(ip);//
		whis.setRecordName(BatchId+","+asOfDate);//日志名称
		whis.setWarnLevel(warnLevel);
		whis.setRecordDescription(mess);
		whis.setRecordDate(sdf.format(cal.getTime()));
		whis.setRemark(ConstantEntity.TABLE_MONITOR_REARK);
//		whis.setState("0");//0表示未处理
		whis.setWarnSort("13");//报警分类； 13为日终报警
		
		//查询应用程序代码的是否存在预警异常中(state!=2的数据)
		List<WarnHistory> list=warnHistoryService.handleStateByCourseCode(BatchId,asOfDate,ip,"13");
		if (list.size() <=0 && list.isEmpty()) {
			//调用插入历史的方法
			warnHistoryService.insertIntoWarnHistory(whis);
		} 
	}
}
