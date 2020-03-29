package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.text.ParseException;
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

import com.vprisk.mnt.base.SMSSendForApiAction;
import com.vprisk.mnt.entity.TransactionEndConfig;
import com.vprisk.mnt.entity.TransactionNoTradeModel;
import com.vprisk.mnt.entity.TransactionSuccess;
import com.vprisk.mnt.entity.TransactionSuccessConfig;
import com.vprisk.mnt.entity.TransactionSuccessModel;
import com.vprisk.mnt.entity.TransactionTimeConfig;
import com.vprisk.mnt.entity.TransactionTimeModel;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.TransactionEndConfigService;
import com.vprisk.mnt.service.TransactionSuccessConfigService;
import com.vprisk.mnt.service.TransactionSuccessModelService;
import com.vprisk.mnt.service.TransactionSuccessService;
import com.vprisk.mnt.service.TransactionTimeConfigService;
import com.vprisk.mnt.service.TransactionTimeModelService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;


/**
 * 交易成功率监控action类
 * @author
 */
public class TransactionSuccessAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	private TransactionSuccessService transactionSuccessService = (TransactionSuccessService) super.getBean("transactionSuccessService");
	private TransactionSuccessConfigService transactionSuccessConfigService = (TransactionSuccessConfigService) super.getBean("transactionSuccessConfigService");
	private TransactionTimeConfigService transactionTimeConfigService = (TransactionTimeConfigService) super.getBean("transactionTimeConfigService");
	private TransactionEndConfigService transactionEndConfigService=(TransactionEndConfigService) super.getBean("transactionEndConfigService");
	private TransactionSuccessModelService transactionSuccessModelService = (TransactionSuccessModelService) super.getBean("transactionSuccessModelService");
	private TransactionTimeModelService transactionTimeModelService = (TransactionTimeModelService) super.getBean("transactionTimeModelService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");


	/**
	 * 查询当天交易成功率
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String findTransactionSuccessList(){
		Map params =  super.getRequestParams();//获取页面传过来的参数
		List<TransactionSuccess> list = this.transactionSuccessService.selectParameterByPage(params);
		List<Map> listMap=new ArrayList<Map>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("code", f.getCode());
			m.put("codeName", f.getCodeName());
			m.put("transactionName", f.getTransactionName());
			//响应码，当天交易量
			int sum=transactionSuccessService.selectSum(params, f.getCode());
			//全部。当天交易量
			int sum2=transactionSuccessService.selectSum2(params);
			NumberFormat numberFormat=NumberFormat.getInstance();
			numberFormat.setMaximumFractionDigits(2);
			//比率 （当天）
			String ratio = "";
			if (sum == 0 || sum2 == 0) {
				ratio = "0";
			}else{
				ratio = numberFormat.format((float) sum / (float) sum2 * 100);
			}
			m.put("sum", sum);
			m.put("ratio", ratio+"%");	
			insertModel(f.getTransactionName(),f.getCode(),f.getCodeName(),sum+"",sum2+"",ratio,"1");
			warning(f,ratio,14);
			listMap.add(m);
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(listMap));
		//resultObj.put("total", page.getTotalCount());
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
	
	//自动执行 -查询当天交易成功率
	public void serviceServer(){
		List<TransactionSuccess> list = this.transactionSuccessService.selectParameterByPage();
		List<Map> listMap=new ArrayList<Map>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("code", f.getCode());
			m.put("codeName", f.getCodeName());
			m.put("transactionName", f.getTransactionName());
			//响应码，当天交易量
			int sum=transactionSuccessService.selectSum(f.getCode());
			//全部。当天交易量
			int sum2=transactionSuccessService.selectSum2();
			NumberFormat numberFormat=NumberFormat.getInstance();
			numberFormat.setMaximumFractionDigits(2);
			//比率 （当天）
			String ratio = "";
			if (sum == 0 || sum2 == 0) {
				ratio = "0";
			}else{
				ratio = numberFormat.format((float) sum / (float) sum2 * 100);
			}
			m.put("sum", sum);
			m.put("ratio", ratio+"%");	
			insertModel(f.getTransactionName(),f.getCode(),f.getCodeName(),sum+"",sum2+"",ratio,"1");
			warning(f,ratio,14);
			listMap.add(m);
		}
	}
	/**
	 * 查询实时交易成功率
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String findTransactionSuccessList2(){
		Map params =  super.getRequestParams();//获取页面传过来的参数
		List<TransactionSuccess> list = this.transactionSuccessService.selectParameterByPage(params);
		List<Map> listMap=new ArrayList<Map>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("code", f.getCode());
			m.put("codeName", f.getCodeName());
			m.put("transactionName", f.getTransactionName());
			String code=f.getCode();
			String time="";
			int transactionSuccessValue=0;
			int transactionSuccessValues=0;
			List<TransactionSuccessConfig> TransactionSuccessConfiglist=transactionSuccessConfigService.selectTransactionSuccessValue(f.getTransactionName(),f.getCode());
			if(!TransactionSuccessConfiglist.isEmpty()&& TransactionSuccessConfiglist.size()==1){
				time=TransactionSuccessConfiglist.get(0).getCountCycle()+"";
				//如果比率小于预警和告警阀值，则进行预警
				 transactionSuccessValue=TransactionSuccessConfiglist.get(0).getTransactionSuccessValue();
				 transactionSuccessValues=TransactionSuccessConfiglist.get(0).getTransactionSuccessValues();
			}
			if(time.equals("")){
				time="10";
			}
			//响应码，实时交易量
			int sum=transactionSuccessService.selectSumNow(params,code,time);
			//全部。实时交易量
			int sum2=transactionSuccessService.selectSumNow2(params,time);
			NumberFormat numberFormat=NumberFormat.getInstance();
			numberFormat.setMaximumFractionDigits(2);
			//比率 （实时）
			String ratio = "";
			if (sum == 0 || sum2 == 0) {
				ratio = "0";
			}else{
				ratio = numberFormat.format((float) sum / (float) sum2 * 100);
			}
			m.put("sum", sum);
			m.put("ratio", ratio+"%");	
			
			insertModel(f.getTransactionName(),f.getCode(),f.getCodeName(),sum+"",sum2+"",ratio,"2");
			warning(f,ratio,9);
			listMap.add(m);
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(listMap));
		//resultObj.put("total", page.getTotalCount());
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
	
	
	//自动执行 -查询实时交易成功率
	public void serviceServer2(){
		List<TransactionSuccess> list = this.transactionSuccessService.selectParameterByPage();
		List<Map> listMap=new ArrayList<Map>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("code", f.getCode());
			m.put("codeName", f.getCodeName());
			m.put("transactionName", f.getTransactionName());
			String code=f.getCode();
			String time="";
			int transactionSuccessValue=0;
			int transactionSuccessValues=0;
			List<TransactionSuccessConfig> TransactionSuccessConfiglist=transactionSuccessConfigService.selectTransactionSuccessValue(f.getTransactionName(),f.getCode());
			if(!TransactionSuccessConfiglist.isEmpty()&& TransactionSuccessConfiglist.size()==1){
				time=TransactionSuccessConfiglist.get(0).getCountCycle()+"";
				//如果比率小于预警和告警阀值，则进行预警
				 transactionSuccessValue=TransactionSuccessConfiglist.get(0).getTransactionSuccessValue();
				 transactionSuccessValues=TransactionSuccessConfiglist.get(0).getTransactionSuccessValues();
			}
			if(time.equals("")){
				time="10";
			}
			//响应码，实时交易量
			int sum=transactionSuccessService.selectSumNow(code,time);
			//全部。实时交易量
			int sum2=transactionSuccessService.selectSumNow2(time);
			NumberFormat numberFormat=NumberFormat.getInstance();
			numberFormat.setMaximumFractionDigits(2);
			//比率 （实时）
			String ratio = "";
			if (sum == 0 || sum2 == 0) {
				ratio = "0";
			}else{
				ratio = numberFormat.format((float) sum / (float) sum2 * 100);
			}
			m.put("sum", sum);
			m.put("ratio", ratio+"%");	
			
			insertModel(f.getTransactionName(),f.getCode(),f.getCodeName(),sum+"",sum2+"",ratio,"2");
			warning(f,ratio,9);
			listMap.add(m);
		}
	}

	
	
	/**
	 * 交易时长监控
	 * @return
	 * @throws ParseException 
	 */
	@SuppressWarnings("unchecked")
	public String findTransactionTimeList() throws ParseException{
		HttpServletRequest request = super.getHttpRequest();
		Map params =  super.getRequestParams();//获取页面传过来的参数
		int pageSize = Integer.parseInt(request.getParameter("rows"));//获取页行数
		int pageNo = Integer.parseInt(request.getParameter("page"));//获取页码
		String order = request.getParameter("order");//排序方式：asc or desc
		String orderBy = request.getParameter("sort");//按哪个属性排序：order prop
		Boolean isAsc = null;
		if(order!=null){//判断排序方式
			isAsc = order.equalsIgnoreCase("asc")?true:false;
		}
		//DynamicDataSourceContext.putSp(Constants.RPM);
		//调用按照分页查询信息的方法
		Page page = this.transactionSuccessService.selectParameterCollectiondByPage(params, pageNo, pageSize, orderBy, isAsc);
		//DynamicDataSourceContext.clear();
		List<TransactionSuccess> list=page.getData(); 
		SMSSendForApiAction smfa = new SMSSendForApiAction();
		List<Map> listMap=new ArrayList<Map>();
		Map<String,Integer> nummap=new HashMap<String,Integer>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("seqNo", f.getSeqNo());
			String tCode=f.getTransactionCode();
			m.put("transactionCode", tCode);
			m.put("transactionName", f.getTransactionName());
			m.put("code", f.getCode());
			m.put("codeName", f.getCodeName());
			m.put("startDate", f.getStartDate());
			m.put("endDate", f.getEndDate());
			String startDate=f.getStartDate();
			String endDate=f.getEndDate();
			SimpleDateFormat sim=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date =sim.parse(startDate);
			long timeStemp=date.getTime();
			Date date2 =sim.parse(endDate);
			long timeStemp2=date2.getTime();
			long transactionTime=(timeStemp2-timeStemp)/1000;
			m.put("transactionTime", transactionTime);//交易时长
			m.put("dataDate", f.getDataDate());
			m.put("sysCode", f.getSysCode());
			
		 List<TransactionTimeConfig> valueList=transactionTimeConfigService.selectTransactionTimeValue(tCode);
		    int normTransactionTime=0;
			int transactionTimeWarnLevel=0;
			int transactionTimeValueY=0;
			int transactionTimeValueG=0;
			if(!valueList.isEmpty()||valueList.size()>0){
				normTransactionTime=valueList.get(0).getTransactionTime();
				transactionTimeWarnLevel=valueList.get(0).getWarningLevl();
				transactionTimeValueY=valueList.get(0).getTransactionTimeValueY();
				transactionTimeValueG=valueList.get(0).getTransactionTimeValueG();
			}
			m.put("normTransactionTime", normTransactionTime);//标准时长
			//交易时长-标准时长
			long transactionTimeValue=transactionTime-normTransactionTime;
			//希望统计出每个交易名称 ，超出标准时长的数量。与该交易名称的阀值进行比较
			int val =0;
			if (transactionTimeValue>0){
				if(nummap.get(tCode)!=null){
					val=nummap.get(tCode)+1;
					nummap.put(tCode, val);
				}else{
					nummap.put(tCode,val);
				}
			}
			String type="";
			int TrT=nummap.get(tCode);
			if (TrT > transactionTimeValueY) {
				List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTransactionName(),"交易码为："+tCode, "高于预警阀值", "10");
				if (WarnHistorylist.size() <= 0 && WarnHistorylist.isEmpty()) {
					type = "预警阀值数";
					String recordDescription = f.getTransactionName()+ "对应的交易时长数量高于" + type + "！";
					// 通知人员
					String notificationPerson = "";
					// 调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
					warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(), "交易码为："+tCode, "高于预警阀值", "10",transactionTimeWarnLevel, recordDescription,notificationPerson);
				}
			}
		  if (TrT > transactionTimeValueG) {
				List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTransactionName(),"交易码为："+tCode, "高于告警阀值", "10");
				if (WarnHistorylist.size() <= 0 && WarnHistorylist.isEmpty()) {
					type = "告警阀值数";
					String recordDescription = f.getTransactionName()+ "对应的交易时长数量高于" + type + "！";
					// 通知人员
					String notificationPerson = "";
					// 调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
					warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(),"交易码为："+tCode, "高于告警阀值", "10",transactionTimeWarnLevel, recordDescription,notificationPerson);
				}
			}
			insertTimeModel(f.getSeqNo(),tCode,f.getTransactionName(),f.getCode(),f.getCodeName(),f.getStartDate(),f.getEndDate(),transactionTime+"",normTransactionTime+"");
			listMap.add(m);
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
			//出现异常把异常信息，写进日志信息
			logger.error("应用程序查询异常"+e.getMessage());
		}
		return null;
	}
	
	//（自动）交易时长
	public void serviceServer3(){
		try {
		List<TransactionSuccess> list = this.transactionSuccessService.selectParameterCollectiondByPage();
//		List<TransactionSuccess> list=page.getData(); 
		SMSSendForApiAction smfa = new SMSSendForApiAction();
		List<Map> listMap=new ArrayList<Map>();
		Map<String,Integer> nummap=new HashMap<String,Integer>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("seqNo", f.getSeqNo());
			String tCode=f.getTransactionCode();
			m.put("transactionCode", tCode);
			m.put("transactionName", f.getTransactionName());
			m.put("code", f.getCode());
			m.put("codeName", f.getCodeName());
			m.put("startDate", f.getStartDate());
			m.put("endDate", f.getEndDate());
			String startDate=f.getStartDate();
			String endDate=f.getEndDate();
			SimpleDateFormat sim=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date date = sim.parse(startDate);
			long timeStemp=date.getTime();
			Date date2 =sim.parse(endDate);
			long timeStemp2=date2.getTime();
			long transactionTime=(timeStemp2-timeStemp)/1000;
			m.put("transactionTime", transactionTime);//交易时长
			m.put("dataDate", f.getDataDate());
			m.put("sysCode", f.getSysCode());
		 List<TransactionTimeConfig> valueList=transactionTimeConfigService.selectTransactionTimeValue(tCode);
		    int normTransactionTime=0;
			int transactionTimeWarnLevel=0;
			int transactionTimeValueY=0;
			int transactionTimeValueG=0;
			if(!valueList.isEmpty()||valueList.size()>0){
				normTransactionTime=valueList.get(0).getTransactionTime();
				transactionTimeWarnLevel=valueList.get(0).getWarningLevl();
				transactionTimeValueY=valueList.get(0).getTransactionTimeValueY();
				transactionTimeValueG=valueList.get(0).getTransactionTimeValueG();
			}
			m.put("normTransactionTime", normTransactionTime);//标准时长
			//交易时长-标准时长
			long transactionTimeValue=transactionTime-normTransactionTime;
			//希望统计出每个交易名称 ，超出标准时长的数量。与该交易名称的阀值进行比较
			int val =0;
			if (transactionTimeValue>0){
				if(nummap.get(tCode)!=null){
					val=nummap.get(tCode)+1;
					nummap.put(tCode, val);
				}else{
					nummap.put(tCode,val);
				}
			}
			String type="";
			int TrT=nummap.get(tCode);
			if (TrT > transactionTimeValueY) {
				List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTransactionName(),"交易码为："+tCode, "高于预警阀值", "10");
				if (WarnHistorylist.size() <= 0 && WarnHistorylist.isEmpty()) {
					type = "预警阀值数";
					String recordDescription = f.getTransactionName()+ "对应的交易时长数量高于" + type + "！";
					// 通知人员
					String notificationPerson = "";
					// 调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
					warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(), "交易码为："+tCode, "高于预警阀值", "10",transactionTimeWarnLevel, recordDescription,notificationPerson);
				}
			}
		  if (TrT > transactionTimeValueG) {
				List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode(f.getTransactionName(),"交易码为："+tCode, "高于告警阀值", "10");
				if (WarnHistorylist.size() <= 0 && WarnHistorylist.isEmpty()) {
					type = "告警阀值数";
					String recordDescription = f.getTransactionName()+ "对应的交易时长数量高于" + type + "！";
					// 通知人员
					String notificationPerson = "";
					// 调用执行插入当前历史信息的方法
					WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
					warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(),"交易码为："+tCode, "高于告警阀值", "10",transactionTimeWarnLevel, recordDescription,notificationPerson);
				}
			}
			insertTimeModel(f.getSeqNo(),tCode,f.getTransactionName(),f.getCode(),f.getCodeName(),f.getStartDate(),f.getEndDate(),transactionTime+"",normTransactionTime+"");
			listMap.add(m);
		}
	
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * 查询长时间无交易
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String findTransactionEndList(){
		//HttpServletRequest request = super.getHttpRequest();
		Map params =  super.getRequestParams();//获取页面传过来的参数
		//DynamicDataSourceContext.putSp(Constants.RPM);
		//DynamicDataSourceContext.clear();
		//调用按照分页查询信息的方法
		//Page page = this.transactionSuccessService.selectParameterCollectiondByPage(params, pageNo, pageSize, orderBy, isAsc);
		//List<TransactionSuccess> list=page.getData(); 
		SMSSendForApiAction smfa = new SMSSendForApiAction();
		List<TransactionSuccess> list = this.transactionSuccessService.selectRransactionEndList(params);
		List<Map> listMap=new ArrayList<Map>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("transactionCode", f.getTransactionCode());
			m.put("transactionName", f.getTransactionName());
			//m.put("sysCode", f.getSysCode());
			m.put("startDate", f.getStartDate());
			m.put("seqNo", f.getSeqNo());
			
			String startDate=f.getStartDate();
			Date dateStr = new Date();
			SimpleDateFormat sim=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String str =sim.format(dateStr);
			Date date = null;
			Date date2 = null;
			try {
				date = sim.parse(startDate);
				date2 =sim.parse(str);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			long timeStemp=date.getTime();
			long now=date2.getTime();
			long noTransaction=(now-timeStemp)/1000;
			m.put("noTransaction", noTransaction);//无交易时长
			warning3(f,"12",noTransaction);
			insertNoTradeModel(f.getTransactionCode(), f.getTransactionName(),f.getStartDate(),f.getSeqNo(),noTransaction+"");
			listMap.add(m);
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(listMap));
		//resultObj.put("total", page.getTotalCount());
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
	
	//（自动），长时间无交易
	public void serviceServer4(){
		List<TransactionSuccess> list = this.transactionSuccessService.selectRransactionEndList();
		List<Map> listMap=new ArrayList<Map>();
		for (TransactionSuccess f : list) {
			Map m = new HashMap<String, String>();
			m.put("transactionCode", f.getTransactionCode());
			m.put("transactionName", f.getTransactionName());
			//m.put("sysCode", f.getSysCode());
			m.put("startDate", f.getStartDate());
			m.put("seqNo", f.getSeqNo());
			
			String startDate=f.getStartDate();
			Date dateStr = new Date();
			SimpleDateFormat sim=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String str =sim.format(dateStr);
			Date date = null;
			Date date2 = null;
			try {
				date = sim.parse(startDate);
				date2 =sim.parse(str);
			} catch (ParseException e) {
				e.printStackTrace();
			}
			long timeStemp=date.getTime();
			long now=date2.getTime();
			long noTransaction=(now-timeStemp)/1000;
			m.put("noTransaction", noTransaction);
			warning3(f,"12",noTransaction);
			insertNoTradeModel(f.getTransactionCode(), f.getTransactionName(),f.getStartDate(),f.getSeqNo(),noTransaction+"");
			listMap.add(m);
		}
	}

	
	//预警（交易成功率）
	private void warning(TransactionSuccess f,String ratio,int what){
		
		//通过响应码和交易码，查询出对应的阀值。与现在的进行比较，超出的预警
		List<TransactionSuccessConfig> numList=transactionSuccessConfigService.selectTransactionSuccessValue(f.getTransactionName(), f.getCode());
		int numValue=0;
		int numValues=0;
		int warningLevl=0;
		if (numList.size() > 0 && !numList.isEmpty()) {
			numValue=numList.get(0).getTransactionSuccessValue();
			numValues=numList.get(0).getTransactionSuccessValues();
			warningLevl=numList.get(0).getWarningLevl();
		}
		String warnSort = "";
		int Value=0;
		//14全天交易成功率，9实时交易成功率
		if (what == 14) {
			warnSort = "14";
			Value=numValues;
		} else if(what == 9)  {
			warnSort = "9";
			Value=numValue;
		}
		//String localIp=UserContext.getUserInfo().getIp();//由于自动运行时无法获取UserContext
		String localIp="";
			List<WarnHistory> WarnHistorylist= warnHistoryService.handleStateByCourseCode(f.getTransactionName(),f.getCode(),localIp,warnSort);
		if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
			// 正常
			if ( Double.parseDouble(ratio)>= Value) {
			/*	for (int j = 0; j < WarnHistorylist.size(); j++) {
					WarnHistory warm = WarnHistorylist.get(j);
					// 取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
					if (warm.getEndDate() == null|| warm.getEndDate().equals("")) {
						warnHistoryService.updateWarnHistory(warm.getUuid());
					}
				}*/
				WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
				warnHistoryAction.renew(WarnHistorylist);
			}
		} else {
			// 异常
			if (Double.parseDouble(ratio) < Value) {
				String recordDescription = f.getTransactionName() + "响应码"+f.getCode()+",交易成功率低于阀值！";
				// 通知人员
				String notificationPerson = "";
				// 调用执行插入当前历史信息的方法
				WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
				warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(),f.getCode(), localIp, warnSort,warningLevl, recordDescription,notificationPerson);
			} else {
				// 页面配置的和配置文件的配置没有匹配成功，应用服务数为0 并与配置的0相同，状态显示为异常，但并不出现在当前告警中
			}

		}		
		
	}
	

	//预警(长时间无交易)
	private void warning3(TransactionSuccess f,String warnSort,long noTransaction){
		String localIp="";
		List<WarnHistory> WarnHistorylist= warnHistoryService.handleStateByCourseCode(f.getTransactionName(),f.getCode(),localIp,warnSort);
		List<TransactionEndConfig> value=transactionEndConfigService.selectTransactionEndValue(f.getSysCode());
		int transactionTimeV=0;
		int transactionTimeG=0;
		int transactionTimeWarnLevel=0;
		if(!value.isEmpty()||value.size()>0){
			transactionTimeV=value.get(0).getNoTransactionTimeValuesY();
			transactionTimeG=value.get(0).getNoTransactionTimeValuesG();
			transactionTimeWarnLevel=value.get(0).getWarningLevl();
		}
		//无交易时长-无交易时长预警阀值
		long transactionTimeValue=noTransaction-transactionTimeV;
		long transactionTimeValue2=noTransaction-transactionTimeG;
	//预警判断
		if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
		// 正常
		if ( transactionTimeValue<= 0) {
			/*for (int j = 0; j < WarnHistorylist.size(); j++) {
				WarnHistory warm = WarnHistorylist.get(j);
				// 取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
				if (warm.getEndDate() == null|| warm.getEndDate().equals("")) {
					warnHistoryService.updateWarnHistory(warm.getUuid());
				}
			}*/
			WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
			warnHistoryAction.renew(WarnHistorylist);
		}
	} else {
		// 异常
		if (transactionTimeValue > 0) {
			String recordDescription = f.getTransactionName()+",长时间无交易高于预警阀值！";
			// 通知人员
			String notificationPerson = "";
			// 调用执行插入当前历史信息的方法
			WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
			warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(),f.getSysCode(), localIp, warnSort,transactionTimeWarnLevel, recordDescription,notificationPerson);
		} 
	}
		
		//告警判断
	if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
		// 正常
		if ( transactionTimeValue2<= 0) {
			/*for (int j = 0; j < WarnHistorylist.size(); j++) {
				WarnHistory warm = WarnHistorylist.get(j);
				// 取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
				if (warm.getEndDate() == null|| warm.getEndDate().equals("")) {
					warnHistoryService.updateWarnHistory(warm.getUuid());
				}
			}*/
			WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
			warnHistoryAction.renew(WarnHistorylist);
		}else{
			String recordDescription = f.getTransactionName()+",长时间无交易高于告警阀值！";
			// 通知人员
			String notificationPerson = "";
			// 调用执行插入当前历史信息的方法
			WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
			warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(),f.getSysCode(), localIp, warnSort,transactionTimeWarnLevel, recordDescription,notificationPerson);
		}
	} else {
		// 异常
		if (transactionTimeValue2 > 0) {
			String recordDescription = f.getTransactionName()+",长时间无交易高于告警阀值！";
			// 通知人员
			String notificationPerson = "";
			// 调用执行插入当前历史信息的方法
			WarnHistoryAction warnHistoryAction = new WarnHistoryAction();
			warnHistoryAction.insertIntoWarnHistory(f.getTransactionName(),f.getSysCode(), localIp, warnSort,transactionTimeWarnLevel, recordDescription,notificationPerson);
		} 
	}
	}
	
	
	
	
	/**
	 * 插入交易成功率记录
	 * 
	 */
	
	private void insertModel(String transactionName,String code,String codeName,String sum ,String sum2 ,String ratio,String executeType){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		
		TransactionSuccessModel model = new TransactionSuccessModel();
		model.setTransactionName(transactionName);
		model.setCode(code);
		model.setCodeName(codeName);
		model.setTransactionNum(sum);
		model.setTransactionSumNum(sum2);
		model.setRatio(ratio);
		model.setExecuteType(executeType);
		model.setExecuteDate(sdf.format(cal.getTime()));
		
		transactionSuccessModelService.insertModel(model);
		
	}
	
	/**
	 * 插入交易时长记录
	 * 
	 */
	
	private void insertTimeModel(String seqNo,String transactionCode,String transactionName,String codeName,String code,String startDate,String endDate,String transactionTime,String normTransactionTime){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		
		TransactionTimeModel model = new TransactionTimeModel();
		model.setSeqNo(seqNo);
		model.setTransactionCode(transactionCode);
		model.setTransactionName(transactionName);
		model.setCodeName(codeName);
		model.setCode(code);
		model.setStartDate(startDate);
		model.setEndDate(endDate);
		model.setTransactionTime(transactionTime);
		model.setNormTransactionTime(normTransactionTime);
		model.setExecuteDate(sdf.format(cal.getTime()));
		
		
		List<TransactionTimeModel> list = transactionTimeModelService.selectSeqNo(seqNo);
		if (list.size() <= 0 && list.isEmpty()) {
			transactionTimeModelService.insertModel(model);
		}
	}
	
	
	
	/**
	 * 插入长时间无交易记录
	 * 
	 */
	private void insertNoTradeModel(String transactionCode, String transactionName,String startDate,String seqNo,String noTransaction ){
		//每次查询都插入实时数据
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		
		TransactionNoTradeModel model = new TransactionNoTradeModel();
		model.setTransactionCode(transactionCode);
		model.setTransactionName(transactionName);
		model.setStartDate(startDate);
		model.setSeqNo(seqNo);
		model.setNoTransaction(noTransaction);
		model.setExecuteDate(sdf.format(cal.getTime()));
		
		/*List<TransactionNoTradeModel> list = transactionNoTradeModelService.selectSeqNo(seqNo);
		if (list.size() <= 0 && list.isEmpty()) {
			transactionNoTradeModelService.insertModel(model);
		}*/
	}
	
	public String report(){
		//Map params =  super.getRequestParams();//获取页面传过来的参数
		List<Map> listMap=new ArrayList<Map>();
		for(int i = 31;i >=0 ; i--){
			Map m = new HashMap<String, String>();
			String day=transactionSuccessService.selectDay(i);
			int n=transactionSuccessService.selectDayofNums(day);
			m.put("day", day);
			m.put("number", n);
			listMap.add(m);
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("Rows", JSONArray.fromObject(listMap));
		//resultObj.put("total", page.getTotalCount());
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
	public String report2(){
		//Map params =  super.getRequestParams();//获取页面传过来的参数
		List<Map> listMap=new ArrayList<Map>();
		for(int i = 0;i< 24; i++){
			Map m = new HashMap<String, String>();
			int n=transactionSuccessService.selectNums(i);
			m.put("hour", i);
			m.put("number", n);
			listMap.add(m);
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("Rows", JSONArray.fromObject(listMap));
		//resultObj.put("total", page.getTotalCount());
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
	
	
	
	//交易量统计
	public String statistics(){
		Map params =  super.getRequestParams();//获取页面传过来的参数
		List<TransactionSuccessModel> list = this.transactionSuccessModelService.statistics(params);
		List<Map> listMap=new ArrayList<Map>();
		for (TransactionSuccessModel f : list) {
			Map m = new HashMap<String, String>();
			m.put("executeDate", f.getExecuteDate());
			m.put("transactionName", f.getTransactionName());
			m.put("code", f.getCode());
			m.put("codeName", f.getCodeName());
			m.put("executeType", f.getExecuteType());
			m.put("transactionNum", f.getTransactionNum());
			m.put("transactionSumNum", f.getTransactionSumNum());
			m.put("ratio", f.getRatio());
			listMap.add(m);
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(listMap));
		//resultObj.put("total", page.getTotalCount());
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
}
