package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.common.Constants;
import com.vprisk.mnt.base.CommonUtils;
import com.vprisk.mnt.base.SMSSendForApiAction;
import com.vprisk.mnt.entity.SqlBlock;
import com.vprisk.mnt.entity.SqlBlockConfig;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.service.SqlBlockConfigService;
import com.vprisk.mnt.service.SqlBlockService;
import com.vprisk.mnt.service.WarnHistoryService;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * sql阻塞action类
 */
public class SqlBlockAction extends BaseAction {


	private static final long serialVersionUID = 1L;
	private SqlBlockService sqlBlockService = (SqlBlockService) super.getBean("sqlBlockService");
	private SqlBlockConfigService sqlBlockConfigService = (SqlBlockConfigService) super.getBean("sqlBlockConfigService");
	private WarnHistoryService warnHistoryService = (WarnHistoryService) super.getBean("warnHistoryService");
	private String ip = CommonUtils.getProp("ec.jdbc.ip");//获取服务器用户名

	private String result;
	public String getResult() {
		return result;
	}
	public void setResult(String result) {
		this.result = result;
	}
	
	/**
	 * 手工调用sql阻塞进程服务检测
	 * @return 返回null
	 */
	public String serviceServer(){
		Map params =  super.getRequestParams();//获取页面传过来的参数
		DynamicDataSourceContext.putSp(Constants.VIEWDB);
//		DynamicDataSourceContext.putSp(Constants.EC);
		List<SqlBlock> list = sqlBlockService.findSqlBlock(params);
		DynamicDataSourceContext.clear();
		List<SqlBlockConfig> configlist=sqlBlockConfigService.findSqlBlockConfig();
		SqlBlockConfig application = null;
		int warnLevel=1;
		int sqlTimeValue =0;
		if(configlist.size()>0&& configlist.size()==1){
			application=configlist.get(0);
			warnLevel=application.getWarningLevl();
			sqlTimeValue=application.getSqlTimeValue();
		}
		List<Map> listMap=new ArrayList<Map>();
		//声明创建短信对象
		SMSSendForApiAction smfa = new SMSSendForApiAction();
		for(SqlBlock s:list){
			Map m = new HashMap<String, String>();
			m.put("username",s.getUsername());
			m.put("sid",s.getSid());
			m.put("event",s.getEvent());
			m.put("sqlId",s.getSqlId());
			m.put("command",s.getCommand());
			m.put("lastCallEt",s.getLastCallEt());
			m.put("status",s.getStatus());
			m.put("waitClass",s.getWaitClass());
			m.put("blockingInstance",s.getBlockingInstance());
			m.put("blockingSession",s.getBlockingSession());
			m.put("collectDate",s.getCollectDate());
			m.put("warningLevl",warnLevel);
			int lastCallEt=Integer.parseInt(s.getLastCallEt());
			
			if(lastCallEt<sqlTimeValue){
			m.put("courseStatus",1);
				//现在检测为正常时，查看当前预警中此数据                            
				List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode("sql阻塞的sid为"+s.getSid(),s.getUsername(),ip,"8");
				if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
					/*for (int j = 0; j < WarnHistorylist.size(); j++) {
						WarnHistory warm = WarnHistorylist.get(j);
						//取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
						if (warm.getEndDate() == null||warm.getEndDate().equals("")) {
							warnHistoryService.updateWarnHistory(warm.getUuid());
						}
					}*/
					WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
					warnHistoryAction.renew(WarnHistorylist);
				}
			}else{
				//超出最大连接数，变成sql阻塞异常
				m.put("courseStatus",0);
				List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode("sql阻塞的sid为"+s.getSid(),s.getUsername(),ip,"8");
				if (WarnHistorylist.size() <=0 && WarnHistorylist.isEmpty()) {
				String recordDescription =s.getSid() +"进程运行出现异常！";
				//通知人员
				String notificationPerson="";
				//调用执行插入当前历史信息的方法
				WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
				warnHistoryAction.insertIntoWarnHistory( "sql阻塞的sid为"+s.getSid(),s.getUsername(), ip, "8",warnLevel, recordDescription, notificationPerson);
			           }
			}
			sqlBlockService.insertModel(s);

			listMap.add(m);
			
		}
		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(listMap));
		resultObj.put("total", list.size());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			logger.error("应用程序查询异常" + e.getMessage());
		}
		return null;
	}
	
	
	public void autoControl() {
		    DynamicDataSourceContext.putSp(Constants.VIEWDB);
//		    DynamicDataSourceContext.putSp(Constants.EC);
			List<SqlBlock> list = sqlBlockService.findSqlBlock();
			DynamicDataSourceContext.clear();
			List<SqlBlockConfig> configlist=sqlBlockConfigService.findSqlBlockConfig();
			SqlBlockConfig application = null;
			int warnLevel=1;
			int sqlTimeValue =0;
			if(configlist.size()>0&& configlist.size()==1){
				application=configlist.get(0);
				warnLevel=application.getWarningLevl();
				sqlTimeValue=application.getSqlTimeValue();
			}
			List<Map> listMap=new ArrayList<Map>();
			//声明创建短信对象
			SMSSendForApiAction smfa = new SMSSendForApiAction();
			for(SqlBlock s:list){
				Map m = new HashMap<String, String>();
				m.put("username",s.getUsername());
				m.put("sid",s.getSid());
				m.put("event",s.getEvent());
				m.put("sqlId",s.getSqlId());
				m.put("command",s.getCommand());
				m.put("lastCallEt",s.getLastCallEt());
				m.put("status",s.getStatus());
				m.put("waitClass",s.getWaitClass());
				m.put("blockingInstance",s.getBlockingInstance());
				m.put("blockingSession",s.getBlockingSession());
				m.put("collectDate",s.getCollectDate());
				m.put("warningLevl",warnLevel);
				int lastCallEt=Integer.parseInt(s.getLastCallEt());
				
				if(lastCallEt<sqlTimeValue){
				m.put("courseStatus",1);
					//现在检测为正常时，查看当前预警中此数据                            
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode("sql阻塞的sid为"+s.getSid(),s.getUsername(),ip,"8");
					if (WarnHistorylist.size() > 0 && !WarnHistorylist.isEmpty()) {
						for (int j = 0; j < WarnHistorylist.size(); j++) {
							WarnHistory warm = WarnHistorylist.get(j);
							//取最新一条数据（最新一条数据没有恢复时间），改变数据状态为正常，添加恢复时间
							if (warm.getEndDate() == null||warm.getEndDate().equals("")) {
								warnHistoryService.updateWarnHistory(warm.getUuid());
							}
						}
						WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
						warnHistoryAction.renew(WarnHistorylist);
					}
				}else{
					//超出最大连接数，变成sql阻塞异常
					m.put("courseStatus",0);
					List<WarnHistory> WarnHistorylist = warnHistoryService.handleStateByCourseCode("sql阻塞的sid为"+s.getSid(),s.getUsername(),ip,"8");
					if (WarnHistorylist.size() <=0 && WarnHistorylist.isEmpty()) {
						String recordDescription =s.getSid() +"进程运行出现异常！";
						//通知人员
						String notificationPerson="";
						//调用执行插入当前历史信息的方法
						WarnHistoryAction warnHistoryAction=new WarnHistoryAction();
						warnHistoryAction.insertIntoWarnHistory( "sql阻塞的sid为"+s.getSid(),s.getUsername(), ip, "8",warnLevel, recordDescription, notificationPerson);
					}
				}
				sqlBlockService.insertModel(s);
				listMap.add(m);
			}
	}
	
}
