package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.mnt.base.SMSSendForApiAction;
import com.vprisk.mnt.entity.BookParam;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.BookParamService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.context.UserContext;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * 报警历史action类
 * 
 */
public class WarnHistoryAction extends BaseAction {
	
	private static final long serialVersionUID = 1L;
	private  WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
	private BookParamService bookParamService = (BookParamService) super.getBean("bookParamService");


	@SuppressWarnings("unchecked")
	public void warnHistoryList() {
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
		// 调用按照分页查询信息的方法
		Page page = this.warnHistoryService.selectParameterCollectiondByPage(
				params, pageNo, pageSize, orderBy, isAsc);
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(page.getData()));
		resultObj.put("total", page.getTotalCount());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			// 出现异常把异常信息，写进日志信息
			logger.error("报警历史查询异常" + e.getMessage());
		}
	}
	
	public void handleState(){
		Map params = super.getRequestParams();// 获取页面传过来的参数
		/*String uuids = getHttpRequest().getParameter("uuids");
		String [] str = uuids.split(",");
		for(int i=0;i<str.length;i++){
			warnHistoryService.handleStateById(str[i]);
		}*/
		String userName = UserContext.getUserInfo().getUsername();//获取用户Name
		String userOrganName=UserContext.getUserInfo().getUserOrganName();

		warnHistoryService.updateConfirmation(params,userName,userOrganName);
	}
	
	//查询历史报警
	public void warnHistoryList2() {
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
		// 调用按照分页查询信息的方法
		Page page = this.warnHistoryService.selectParameterCollectiondByPage2(
				params, pageNo, pageSize, orderBy, isAsc);
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(page.getData()));
		resultObj.put("total", page.getTotalCount());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			// 出现异常把异常信息，写进日志信息
			logger.error("报警历史查询异常" + e.getMessage());
		}
	}
	
	
	
	public  void insertIntoWarnHistory(String recordName,String pointName,String pointIp,String warnSort,int warnLevel,String recordDescription,String notificationPerson){
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
		//插入当前预警历史记录
		WarnHistory whis = new WarnHistory();
		whis.setRecordDate(sdf.format(cal.getTime()));
		whis.setRecordName(recordName);// 交易名称
		whis.setPointName(pointName);//所属系统
		whis.setPointIp(pointIp);//ip地址
		whis.setWarnSort(warnSort);//报警分类
		whis.setWarnLevel(warnLevel);
		whis.setRecordDescription(recordDescription);
		logger.info("报警分类"+warnSort);
		logger.info("预计级别"+warnLevel);
		//调用note方法，查询预警人员，并发送短信
		String notepersonnel =note(warnLevel,warnSort,recordDescription);
		/*if (notepersonnel != null && notepersonnel != "") {
			notepersonnel = notepersonnel.substring(0, notepersonnel.length() - 1);
		}*/
		whis.setNotificationPerson(notepersonnel);
		
		warnHistoryService.insertIntoWarnHistory(whis);
		
		
		//查询应用程序代码的是否存在预警异常中
		/*List<WarnHistory> list=warnHistoryService.handleStateByCourseCode(sysCode,startDate,endDate,"9");
		if (list.size() <=0 && list.isEmpty()) {
			//调用插入历史的方法
			warnHistoryService.insertIntoWarnHistory(whis);
		} */
		
		
	}
	
	
	
	// 1通过报警类别，和预警级别查出人 时间段为空和在现在时间范围内的人
	// 2.区分是否有编辑短信内容
	public  String  note(int warnLevel,String warnSort,String recordDescription){
		Calendar cal = Calendar.getInstance();
		int hour = cal.get(Calendar.HOUR_OF_DAY);
		int minute = cal.get(Calendar.MINUTE);
		SMSSendForApiAction smfa = new SMSSendForApiAction();
		double time = hour + (minute / 60.0);
		logger.info("小时加分钟除以六十"+time);
		String note="";
		// 根据应用进程预警级别和预警分类，在这个时间段，短信内容为空查询相关联的预警人员
		logger.info("根据应用进程预警级别和预警分类，在这个时间段，短信内容为空查询相关联的预警人员");
		List<BookParam> listtele = bookParamService.findBookParam(warnLevel,warnSort);
		logger.info("根据应用进程预警级别和预警分类，在这个时间段，短信内容为空查询相关联的预警人员信息数"+listtele.size());
		if (listtele.size() > 0) {
			for (int m = 0; m < listtele.size(); m++) {

				String text = listtele.get(m).getBookValues();
				logger.info("预警内容"+text);
				int StartTime = listtele.get(m).getStartTime();
				logger.info("开始接受时间"+StartTime);
				int EndTime = listtele.get(m).getEndTime();
				logger.info("结束接受时间"+EndTime);
				logger.info("如果开始接受时间并且结束接受时间为0------或者开始时间小于等于，小时加分钟除以六十的时间并且结束时间大于小时加分钟除以六十的时间才发短信");
				if ((StartTime == 0 && EndTime == 0)|| (StartTime <= time && EndTime >= time)) {
					// 判断短信内容是否有特别编写
					if (text == null || text == "") {
						// 调用发送短信的方法
						logger.info("准备发告警错误短信调用发送短信的方法----------------------------------------");
						smfa.sendInfo(recordDescription, listtele.get(m));
					} else {
						smfa.sendInfo(text, listtele.get(m));
					}
					note+=listtele.get(m).getBookName()+";";
					
				} else {
					// 没有配置相关人员，或者是对应的人员不在接受短信时间范围
					System.out.print("人员："+listtele.get(m).getBookName()+"他收短信时间为："+StartTime+"-"+EndTime+",故此人没有收到短信");
				}

			}
			listtele = null;
		}
		return  note;
	}
	
	
	//告警恢复短信
	public void renew(List<WarnHistory> WarnHistorylist) {
		logger.info("告警恢复短信准备发短信啦----------------------------------------");
		for (int j = 0; j < WarnHistorylist.size(); j++) {
			WarnHistory warm = WarnHistorylist.get(j);
			// 取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
			if (warm.getEndDate() == null || warm.getEndDate().equals("")) {
				logger.info("告警恢复短信确认时间++"+warm.getEndDate());
				warnHistoryService.updateWarnHistory(warm.getUuid());
				SMSSendForApiAction smfa = new SMSSendForApiAction();
				String notificationPerson = warm.getNotificationPerson();
				logger.info("短信通知人员++"+notificationPerson);
				String[] strs=null ;
				if(notificationPerson != null && notificationPerson != "" ){
					 strs = notificationPerson.split(";");
					 for (int i = 0; i < strs.length; i++) {
						 String note = strs[i].toString();
						 logger.info("截取后的短信通知人员++"+note);
						 List<BookParam> listtele = bookParamService.findBookParamByNote(note);
						 logger.info("查询到的短信人员数++如果大于0则发送恢复短信"+listtele.size());
						 if (listtele.size() > 0) {
							 for (int m = 0; m < listtele.size(); m++) {
								 smfa.sendInfo(warm.getWarnSort()+"已恢复正常",listtele.get(m));
							 }
						 }
					 }
				}
			}

		}
	}
}
