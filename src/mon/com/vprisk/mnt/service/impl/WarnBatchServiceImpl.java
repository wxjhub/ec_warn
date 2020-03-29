package com.vprisk.mnt.service.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jxl.write.DateTime;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.joda.time.convert.Converter;

import com.ibm.db2.jcc.t4.cc;
import com.vprisk.mnt.dao.WarnBatchConfigDao;
import com.vprisk.mnt.dao.WarnBatchDao;
import com.vprisk.mnt.dao.WarnBatchHisTaskLogDao;
import com.vprisk.mnt.dao.WarnHistoryDao;
import com.vprisk.mnt.entity.WarnBatchConfig;
import com.vprisk.mnt.entity.WarnBatchHisTaskLog;
import com.vprisk.mnt.entity.WarnHistory;
import com.vprisk.mnt.entity.WarnModuleConfig;
import com.vprisk.mnt.service.WarnBatchService;
import com.vprisk.mnt.service.WarnModuleConfigService;
import com.vprisk.rmplatform.util.DateUtil;
import com.vprisk.rmplatform.util.StringUtil;

public class WarnBatchServiceImpl implements WarnBatchService {
	private static Log log = LogFactory.getLog(WarnBatchServiceImpl.class);
	WarnModuleConfigService warnModuleConfigService; //预警告警配置
	WarnBatchHisTaskLogDao warnBatchHisTaskLogDao; //跑批日志
    WarnBatchDao warnBatchDao;
    WarnBatchConfigDao warnBatchConfigDao;
    WarnHistoryDao warnHistoryDao;
    
	public WarnHistoryDao getWarnHistoryDao() {
		return warnHistoryDao;
	}

	public void setWarnHistoryDao(WarnHistoryDao warnHistoryDao) {
		this.warnHistoryDao = warnHistoryDao;
	}

	public WarnBatchDao getWarnBatchDao() {
		return warnBatchDao;
	}

	public void setWarnBatchDao(WarnBatchDao warnBatchDao) {
		this.warnBatchDao = warnBatchDao;
	}

	public WarnModuleConfigService getWarnModuleConfigService() {
		return warnModuleConfigService;
	}

	public void setWarnModuleConfigService(
			WarnModuleConfigService warnModuleConfigService) {
		this.warnModuleConfigService = warnModuleConfigService;
	}

	public WarnBatchHisTaskLogDao getWarnBatchHisTaskLogDao() {
		return warnBatchHisTaskLogDao;
	}

	public void setWarnBatchHisTaskLogDao(
			WarnBatchHisTaskLogDao warnBatchHisTaskLogDao) {
		this.warnBatchHisTaskLogDao = warnBatchHisTaskLogDao;
	}

	/**
     * 生成预警告警数据
	 * @throws ParseException 
     */
	@Override
	public void generateData() throws ParseException {
		 //获取该模块的数据数据日期范围T-天 生成要查询的数据日期
		WarnModuleConfig config  = this.warnModuleConfigService.queryWarnModuleByModuleCode("01");
		String asOfDate = this.getAsOfDate(config);
		log.info("T-天 生成要查询的数据日期"+asOfDate);
//		String asOfDate = "2018-08-31";
		//生成错误跑批预警信息
		this.addErrorWarnData(config);
		 //添加晚开始的预警数据
		this.addLaterStartWarnData(config,asOfDate);
		//超过时长的数据
		this.addMorethanWarnData(config);
		 //将跑批日志数据插入到日志表中  数据日期日全量 先删除后添加
		this.addBatchLogData(asOfDate);
		//生成跟前三天做比较的数据比较
		this.addAftertThreeDay(asOfDate);
		//生成跟前三个月末做比较的数据比较
		this.addAftertThreeMonth(asOfDate);
		
	}
	public WarnBatchConfigDao getWarnBatchConfigDao() {
		return warnBatchConfigDao;
	}

	public void setWarnBatchConfigDao(WarnBatchConfigDao warnBatchConfigDao) {
		this.warnBatchConfigDao = warnBatchConfigDao;
	}

	/**
	 * 生成错误跑批预警信息
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private void addErrorWarnData(WarnModuleConfig config) {
        String warnNum = config.getWarnNum();	
        if(StringUtil.isNullOrEmpty(warnNum)){
        	warnNum = "01";//单次
        }
        List<Map<String,String>> data = new ArrayList<Map<String,String>>();
        //单次
        if(warnNum.equals("01")){
        	//查询所有今天已经报警的错误类型的日志数据
        	Map param = new HashMap();
        	param.put("recordDate", DateUtil.convertDateToString(new Date()));
        	param.put("warnSort", "18");
        	List<WarnHistory> historys = this.warnHistoryDao.selectWarnHistoryByParam(param);
        	log.info("单次时候根据报警时间和确认时间查询历史告警信息表数据个数"+historys.size());
        	data = this.warnBatchDao.queryWrongRunFlagDataFromEtl(this.getWarnHistoryQueryInfo(historys));
        	
        } else {//循环
        	Map param = new HashMap();
        	param.put("recordDate", DateUtil.convertDateToString(new Date()));
        	param.put("endDate", "1");
        	List<WarnHistory> historys = this.warnHistoryDao.selectWarnHistoryByParam(param);
        	log.info("循环时候根据报警时间和确认时间查询历史告警信息表数据个数"+historys.size());
        	data = this.warnBatchDao.queryWrongRunFlagDataFromEtl(this.getWarnHistoryQueryInfo(historys));
        }
        //插入数据
        for(Map<String,String> map : data){
    		Calendar cal = Calendar.getInstance();
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
        	WarnHistory history = new WarnHistory();
        	history.setPointName("ETL"); //-1 错误 1 晚发生 2 超时长
        	history.setRecordName(map.get("batchId")+"-"+map.get("processId")+"-"+map.get("taskId"));
        	history.setWarnSort("18");
        	history.setRecordDate(sdf.format(cal.getTime()));
        	history.setWarnLevel(3);
        	history.setRecordDescription(map.get("errorMessage"));
        	this.warnHistoryDao.insertIntoWarnHistory(history);
        }
	}
	/**
	 * 查询标识字符串
	 * @param history
	 * @return
	 */
    private String getWarnHistoryQueryInfo(List<WarnHistory> historys){
    	String queryId = "(";
    	for(WarnHistory history : historys){
    		queryId += "'"+history.getRecordName().substring(history.getRecordName().lastIndexOf("-")+1, history.getRecordName().length())+"',"; //获取任务id
    	}
    	if(queryId.equals("(")){
    		return "";
    	}
    	return queryId.substring(0,queryId.length()-1)+")";
    }
	/**
	 * 生成报警数据 -晚开始的
	 * @param data
	 */
	@SuppressWarnings({"unchecked", "rawtypes" })
	private void addLaterStartWarnData(WarnModuleConfig config,String asOfDate) {
		String warnNum = config.getWarnNum();	
        if(StringUtil.isNullOrEmpty(warnNum)){
        	warnNum = "01";//单次
        }
        Map param = new HashMap();
    	param.put("recordDate", DateUtil.convertDateToString(new Date()));
    	param.put("warnSort", "16");
    	param.put("warnNum", warnNum);
    	param.put("warnContent", "01");
    	//查询所有已经预警的batchId 及已批注的数据 //所有已经预警的taskSetId 及已批注的数据 //所有已经预警的taskId 及已批注的数据
    	List<WarnBatchConfig> batchId = this.warnBatchConfigDao.queryAllBatchIdConfig(param);
    	log.info("生成报警数据 -晚开始的查询所有已经预警的batchId个数，及已批注的数据"+batchId.size());
    	List<WarnBatchConfig> taskSetId = this.warnBatchConfigDao.queryAllTaskSetIdConfig(param);
    	log.info("生成报警数据 -晚开始的查询所有已经预警的batchId个数，所有已经预警的taskSetId 及已批注的数据"+taskSetId.size());
		List<WarnBatchConfig> taskId = this.warnBatchConfigDao.queryAllTaskIdConfig(param);
		log.info("生成报警数据 -晚开始的查询所有已经预警的batchId个数，所有已经预警的taskId 及已批注的数据"+taskId.size());
		log.info("获取所有batchId编码的字符串逗号分隔"+this.getIdsStr(batchId, "1"));
		log.info("获取所有taskSetId编码的字符串逗号分隔"+this.getIdsStr(taskSetId, "2"));
		log.info("获取所有taskId编码的字符串逗号分隔"+this.getIdsStr(taskId, "3"));
		Map<String,List<Map<String,String>>> warnData = this.warnBatchDao.
				queryLaterDataFromEtl(this.getIdsStr(batchId, "1"), this.getIdsStr(taskSetId, "2"), 
						this.getIdsStr(taskId, "3"),asOfDate);
		log.info("生成报警数据 -晚开始的查询晚于时点的预警数据个数"+warnData.size());
    	//获取要处理的预警数据
		List<Map<String,String>> batchData = warnData.get("batchData");
		List<Map<String,String>> taskSetData = warnData.get("taskSetData");
		List<Map<String,String>> taskData = warnData.get("taskData");
    	//处理判断是否产生预警 批次
        addWarnHistoryForLaterTime(batchId, batchData,"0");
        //处理判断是否产生预警 任务组
        addWarnHistoryForLaterTime(taskSetId, taskSetData,"1");
       //处理判断是否产生预警 任务
        addWarnHistoryForLaterTime(taskId, taskData,"2");
        
	}
    /**
     * 添加预警数据 时点
     * @param batchId
     * @param batchData
     */
	private void addWarnHistoryForLaterTime(List<WarnBatchConfig> congigDate,
			List<Map<String, String>> dealData,String flag) {
		for(Map<String,String> map : dealData){
			WarnBatchConfig rConfig = new WarnBatchConfig();
        	if("1".equals(flag)){
        		 rConfig = this.ifAddWarnForTaskSetId(congigDate, map,"01");
        	} else if("2".equals(flag)){
        		 rConfig = this.ifAddWarnForTaskId(congigDate, map,"01");
        	} else {
        		rConfig = this.ifAddWarnForBatchId(congigDate, map,"01");
        	}
        	if(rConfig.getUuid() != null){
        		Calendar cal = Calendar.getInstance();
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
            	WarnHistory history = new WarnHistory();
            	history.setPointName("ETL"); //-1 错误 1 晚发生 2 超时长
            	String stdTime = StringUtil.isNotNullOrEmpty(map.get("stdTime"))?map.get("stdTime"):"未开始";
            	if("1".equals(flag)){
            		history.setRecordName(map.get("batchId")+"-"+map.get("processId"));
            		history.setRecordDescription("任务组"+history.getRecordName()+"的开始时间是 "
                        	+stdTime+",晚于设定的时间"+rConfig.getWarnContentValue());
           	    } else if("2".equals(flag)){
           	    	history.setRecordName(map.get("batchId")+"-"+map.get("processId")+"-"+map.get("taskId"));
           	    	history.setRecordDescription("任务"+history.getRecordName()+"的开始时间是 "
                        	+stdTime+",晚于设定的时间"+rConfig.getWarnContentValue());
           	    } else {
           	    	history.setRecordName(map.get("batchId"));
                	history.setRecordDescription("批次"+history.getRecordName()+"的开始时间是 "
                        	+stdTime+",晚于设定的时间"+rConfig.getWarnContentValue());
           	    }
            	history.setWarnSort("16");
            	history.setRecordDate(sdf.format(cal.getTime()));
            	history.setWarnLevel(rConfig.getWarnLevl());
            	this.warnHistoryDao.insertIntoWarnHistory(history);
        	}
        }
	}
	/**
	 * 判断某个批次是否预警
	 * @param batchData
	 * @param batchId
	 * @return
	 */
	public WarnBatchConfig  ifAddWarnForBatchId(List<WarnBatchConfig> batchIds,Map<String,String> map,String warnConent){
		String batchId = map.get("batchId");
		WarnBatchConfig rConfig = new WarnBatchConfig();
		if("01".equals(warnConent)){ //时点
			for(WarnBatchConfig config:batchIds){
				if(config.getBatchId().equals(batchId)){
					String stdTime = map.get("stdTime");
					if(StringUtil.isNullOrEmpty(stdTime)){ //没开始 与当前时间进行判断
						stdTime = DateUtil.convertDateToString(new Date(), "yyyy-MM-dd HH:mm:ss");
					} 
					if(stdTime.substring(stdTime.indexOf(" ")+1, stdTime.length()).compareTo(config.getWarnContentValue()+":00") >0){
						rConfig = config;
					}
					break;
				}
			}
		} else {
			for(WarnBatchConfig config:batchIds){
				if(config.getBatchId().equals(batchId)){
					String stdTime = map.get("stdTime");
					long nowRunTime = this.diffTwoDate(new Date(),DateUtil.convertStringToDate(stdTime, "yyyy-MM-dd HH:mm:ss"));
					if(nowRunTime > Long.valueOf(config.getWarnContentValue())){
						rConfig = config;
						rConfig.setNowRunTime(nowRunTime+"");
					}
					break;
				}
			}
		}
		return rConfig;
	}
	/**
	 * 判断某个任务组是否预警
	 * @param batchData
	 * @param batchId
	 * @return
	 */
	public WarnBatchConfig  ifAddWarnForTaskSetId(List<WarnBatchConfig> taskSetIds,Map<String,String> map,String warnConent){
		String taskSetId = map.get("processId");
		WarnBatchConfig rConfig = new WarnBatchConfig();
		if("01".equals(warnConent)){ //时点
			for(WarnBatchConfig config:taskSetIds){
				if(config.getTaskSetId().equals(taskSetId)){
					String stdTime = map.get("stdTime");
					if(StringUtil.isNullOrEmpty(stdTime)){ //没开始 与当前时间进行判断
						stdTime = DateUtil.convertDateToString(new Date(), "yyyy-MM-dd HH:mm:ss");
					} 
					if(stdTime.substring(stdTime.indexOf(" ")+1, stdTime.length()).compareTo(config.getWarnContentValue()+":00") >0){
						rConfig = config;
					}
					break;
				}
			}
		} else { //时长
			for(WarnBatchConfig config:taskSetIds){
				if(config.getTaskSetId().equals(taskSetId)){
					String stdTime = map.get("stdTime");
					long nowRunTime = this.diffTwoDate(new Date(),DateUtil.convertStringToDate(stdTime, "yyyy-MM-dd HH:mm:ss"));
					if(nowRunTime > Long.valueOf(config.getWarnContentValue())){
						rConfig = config;
						rConfig.setNowRunTime(nowRunTime+"");
					}
					break;
				}
			}
		}
		
		return rConfig;
	}
	/**
	 * 判断某个任务是否预警
	 * @param batchData
	 * @param batchId
	 * @return
	 */
	public WarnBatchConfig  ifAddWarnForTaskId(List<WarnBatchConfig> taskIds,Map<String,String> map,String warnConent){
		String taskId = map.get("taskId");
		WarnBatchConfig rConfig = new WarnBatchConfig();
		if("01".equals(warnConent)){ //时点
			for(WarnBatchConfig config:taskIds){
				if(config.getTaskId().equals(taskId)){
					String stdTime = map.get("stdTime");
					if(StringUtil.isNullOrEmpty(stdTime)){ //没开始 与当前时间进行判断
						stdTime = DateUtil.convertDateToString(new Date(), "yyyy-MM-dd HH:mm:ss");
					} 
					if(stdTime.substring(stdTime.indexOf(" ")+1, stdTime.length()).compareTo(config.getWarnContentValue()+":00") >0){
						rConfig = config;
					}
					break;
				}
			}
		} else {
			for(WarnBatchConfig config:taskIds){
				if(config.getTaskId().equals(taskId)){
					String stdTime = map.get("stdTime");
					long nowRunTime = this.diffTwoDate(new Date(),DateUtil.convertStringToDate(stdTime, "yyyy-MM-dd HH:mm:ss"));
					if(nowRunTime > Long.valueOf(config.getWarnContentValue())){
						rConfig = config;
						rConfig.setNowRunTime(nowRunTime+"");
					}
					break;
				}
			}
		}
		return rConfig;
	}
	/**
	 * 生成报警数据 -超过时长的
	 * @param data
	 */
	@SuppressWarnings({ "unchecked", "rawtypes"})
	private void addMorethanWarnData(WarnModuleConfig config) {
		String warnNum = config.getWarnNum();	
        if(StringUtil.isNullOrEmpty(warnNum)){
        	warnNum = "01";//单次
        }
        Map param = new HashMap();
    	param.put("recordDate", DateUtil.convertDateToString(new Date()));
    	param.put("warnSort", "17");
    	param.put("warnNum", warnNum);
    	param.put("warnContent", "02");
    	//查询所有已经预警的batchId 及已批注的数据 //所有已经预警的taskSetId 及已批注的数据 //所有已经预警的taskId 及已批注的数据
    	List<WarnBatchConfig> batchId = this.warnBatchConfigDao.queryAllBatchIdConfig(param);
    	log.info("生成报警数据 -超过时长的查询所有已经预警的batchId个数，及已批注的数据"+batchId.size());
    	List<WarnBatchConfig> taskSetId = this.warnBatchConfigDao.queryAllTaskSetIdConfig(param);
    	log.info("生成报警数据 -超过时长的查询所有已经预警的batchId个数，及已批注的数据"+batchId.size());
		List<WarnBatchConfig> taskId = this.warnBatchConfigDao.queryAllTaskIdConfig(param);
		log.info("生成报警数据 -超过时长的查询所有已经预警的batchId个数，及已批注的数据"+batchId.size());
		Map<String,List<Map<String,String>>> warnData = this.warnBatchDao.
				queryMorethanDataFromEtl(this.getIdsStr(batchId, "1"), this.getIdsStr(taskSetId, "2"), 
						this.getIdsStr(taskId, "3"));
		log.info("生成报警数据 -超过时长的查询晚于时点的预警数据个数"+warnData.size());
    	//获取要处理的预警数据
		List<Map<String,String>> batchData = warnData.get("batchData");
		List<Map<String,String>> taskSetData = warnData.get("taskSetData");
		List<Map<String,String>> taskData = warnData.get("taskData");
    	//处理判断是否产生预警 批次
        addWarnHistoryForMorethan(batchId, batchData,"0");
        //处理判断是否产生预警 任务组
        addWarnHistoryForMorethan(taskSetId, taskSetData,"1");
       //处理判断是否产生预警 任务
        addWarnHistoryForMorethan(taskId, taskData,"2");
	}
	/**
     * 添加预警数据 时长
     * @param batchId
     * @param batchData
     */
	private void addWarnHistoryForMorethan(List<WarnBatchConfig> congigDate,
			List<Map<String, String>> dealData,String flag) {
		for(Map<String,String> map : dealData){
			WarnBatchConfig rConfig = new WarnBatchConfig();
        	if("1".equals(flag)){
        		 rConfig = this.ifAddWarnForTaskSetId(congigDate, map,"02");
        	} else if("2".equals(flag)){
        		 rConfig = this.ifAddWarnForTaskId(congigDate, map,"02");
        	} else {
        		rConfig = this.ifAddWarnForBatchId(congigDate, map,"02");
        	}
        	if(rConfig.getUuid() != null){
        		Calendar cal = Calendar.getInstance();
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS");
            	WarnHistory history = new WarnHistory();
            	history.setPointName("ETL"); //-1 错误 1 晚发生 2 超时长
            	String stdTime = StringUtil.isNotNullOrEmpty(map.get("stdTime"))?map.get("stdTime"):"未开始";
            	if("1".equals(flag)){
            		history.setRecordName(map.get("batchId")+"-"+map.get("processId"));
            		history.setRecordDescription("任务组"+history.getRecordName()+","+stdTime+"开始运行，运行时长是 "
                        	+rConfig.getNowRunTime()+"秒,超过规定的时长"+rConfig.getWarnContentValue()+"秒;");
           	    } else if("2".equals(flag)){
           	    	history.setRecordName(map.get("batchId")+"-"+map.get("processId")+"-"+map.get("taskId"));
           	    	history.setRecordDescription("任务"+history.getRecordName()+","+stdTime+"开始运行，运行时长是 "
           	    			+rConfig.getNowRunTime()+"秒,超过规定的时长"+rConfig.getWarnContentValue()+"秒;");
           	    } else {
           	    	history.setRecordName(map.get("batchId"));
                	history.setRecordDescription("批次"+history.getRecordName()+","+stdTime+"开始运行，运行时长是 "
                			+rConfig.getNowRunTime()+"秒,超过规定的时长"+rConfig.getWarnContentValue()+"秒;");
           	    }
            	history.setWarnSort("17");
            	history.setRecordDate(sdf.format(cal.getTime()));
            	history.setWarnLevel(rConfig.getWarnLevl());
            	this.warnHistoryDao.insertIntoWarnHistory(history);
        	}
        }
	}

	/**
	 * 获取该模块的数据数据日期范围T-天 生成要查询的数据日期
	 * @return
	 */
	private String getAsOfDate(WarnModuleConfig config){
		String datatDateS = "2"; //默认T-2
		if(StringUtil.isNotNullOrEmpty(config.getWarnDatadateScope())){
			datatDateS = config.getWarnDatadateScope();
		}
		String asOfDate = DateUtil.convertDateToString(DateUtil.addDays(new Date(), Integer.valueOf("-"+datatDateS)), "yyyy-MM-dd");
		return asOfDate;
	}
	
	/**
	 * 获取最新的日志数据
	 * @param dataDate
	 * @return
	 */
	private void addBatchLogData(String asOfDate){
		List<WarnBatchHisTaskLog> data = this.warnBatchDao.queryWarnBatchHisTaskLogFromEtl(asOfDate);
		//先删除原来的日志 
		this.warnBatchHisTaskLogDao.deleteAllData(asOfDate);
		//
		for(WarnBatchHisTaskLog log : data){
			this.warnBatchHisTaskLogDao.insertOrUpdateLog(log);
		}
	}

	/**
	 * 获取所有编码的字符串逗号分隔
	 * @param data
	 * @param flag 1 batchId 2 taskSetId 3 taskId
	 * @return
	 */
	private String getIdsStr(List<WarnBatchConfig> data,String flag){
		String ids = "(";
		for(WarnBatchConfig config:data){
			if("1".equals(flag)){
				ids += "'"+config.getBatchId()+"',";
			} else if("2".equals(flag)){
				ids += "'"+config.getTaskSetId()+"',";
			} else {
				ids += "'"+config.getTaskId()+"',";
			}
		}
		if(ids.equals("(")){
			return "";
		}
		return ids.substring(0,ids.length()-1)+")";
	}
	
	
    /**
	 * 计算两个日期差（毫秒）
	 * @param date1 时间1
	 * @param date2 时间2
	 * @return 相差毫秒数
	 */
	private  long diffTwoDate(Date date1, Date date2) {
		long l1 = date1.getTime();
		long l2 = date2.getTime();
		return (l1 - l2)/1000;
	}
	
	/**当前配置的时间减去配置的天数，和前三天的日期做比对
	 * @author wangxinji add
	 * @param asOfDate
	 * @throws ParseException
	 */
	private void addAftertThreeDay(String asOfDate) throws ParseException {
		log.info("进入当前时间和前三天做比较的逻辑");
		//查询当前系统日期etl的数据
		List<Map<String,String>>  data = this.warnBatchDao.queryTask("'"+asOfDate+"'","");
		log.info("生成处理数据"+data.size());
		for(Map<String,String> dateMap:data) {
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat threesf = new SimpleDateFormat("yyyy-MM-dd");
			String aso = dateMap.get("asOfDate");
			String taskId = dateMap.get("taskId");
			String stdTime = dateMap.get("stdTime");
			String endTime = dateMap.get("endTime");
			//取当前系统时间etl的数据的时间差
			long resultTime = sf.parse(endTime).getTime()-sf.parse(stdTime).getTime();
			//字符串转换成日期
			Date newAsOfDate = threesf.parse(aso);
			String selectNewdate = "";
			//循环拼接当前日期前3天的日期
			for(int i=1; i<=3 ;i++) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(newAsOfDate);
				calendar.add(calendar.DAY_OF_MONTH, -i);
				String select = threesf.format(calendar.getTime());
				selectNewdate += "'"+select+"'"+",";
			}
            long resultTimeAll = 0;
            //查询出前三天的数据
			List<Map<String,String>> datas = warnBatchDao.queryTask(selectNewdate.substring(0, selectNewdate.length()-1),taskId);
			if(datas!=null&&datas.size()>0) {
				for(Map<String,String> dateMapS:datas) {
					String stdTime1 = dateMapS.get("stdTime");
					String endTime1 = dateMapS.get("endTime");
					long time = sf.parse(endTime1).getTime()-sf.parse(stdTime1).getTime();
					resultTimeAll += time;
				}
			} else {
				continue;
			}
			if(resultTime>(resultTimeAll/3)) {
				WarnHistory history = new WarnHistory();
				Calendar cal = Calendar.getInstance();
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				history.setRecordDescription(taskId+"跑批监控时长大于前三天跑批时长的和，请运维人员知晓");
				history.setWarnSort("17");
            	history.setRecordDate(sdf.format(cal.getTime()));
            	history.setWarnLevel(1);
            	history.setPointName("ETL");
				history.setRecordName(dateMap.get("taskId"));
            	this.warnHistoryDao.insertIntoWarnHistory(history);
			}
		}
		
		
	}
	
	/**
	 * 月末的数据时间差，和前三个月的时间差做比较
	 * @param asOfDate
	 * @throws ParseException
	 */
	private void addAftertThreeMonth(String asOfDate) throws ParseException {
		List<Map<String,String>>  data = this.warnBatchDao.queryTask("'"+asOfDate+"'","");
		//查询出当前日期的数据
		for(Map<String,String> dateMap:data) {
			log.info("进入当前时间和前三天做比较的逻辑");
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat threesf = new SimpleDateFormat("yyyy-MM-dd");
			String aso = dateMap.get("asOfDate");
			String taskId = dateMap.get("taskId");
			String stdTime = dateMap.get("stdTime");
			String endTime = dateMap.get("endTime");
			String[] month = aso.split("-");
			//大月31天的
			String[] maxmonth = {"01","03","05","07","08","10","12"};
			//小月30天的
			String[] minmonth = {"04","06","09","11"};
			long resultTime = 0;
			//取出当前月的时间间隔
			if(Arrays.asList(maxmonth).contains(month[1]) && "31".equals(month[2])) {
				resultTime = sf.parse(endTime).getTime()-sf.parse(stdTime).getTime();
			} else if (Arrays.asList(minmonth).contains(month[1]) && "30".equals(month[2])) {
				resultTime = sf.parse(endTime).getTime()-sf.parse(stdTime).getTime();
			} else if ("02".equals(month[1]) && "28".equals(month[2])){
				resultTime = sf.parse(endTime).getTime()-sf.parse(stdTime).getTime();
			} else {
				continue;
			}
			Date asOfDates = threesf.parse(aso);
			String resultdate = "";
			//拼接出前三个月的月末日期
			for(int i=1; i<=3 ;i++) {
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(asOfDates);
				calendar.add(calendar.MONTH, -i);
				String newdate = threesf.format(calendar.getTime());
				String[] aftermonth = newdate.split("-");
				String date = "";
				if(Arrays.asList(maxmonth).contains(aftermonth[1])) {
					date = aftermonth[0]+"-"+aftermonth[1]+"-"+"31";
				} else if (Arrays.asList(minmonth).contains(aftermonth[1])) {
					date = aftermonth[0]+"-"+aftermonth[1]+"-"+"30";
				} else {
					date = aftermonth[0]+"-"+aftermonth[1]+"-"+"28";
				}
				resultdate += "'"+date+"'"+",";
			}
            long resultAll = 0;
            //查询出前3个月的数据
			List<Map<String,String>>  datas = warnBatchDao.queryTask(resultdate.substring(0, resultdate.length()-1),taskId);
			if(datas!=null&&datas.size()>0) {
				for(Map<String,String> dateMapS:datas) {
					String stdTime1 = dateMapS.get("stdTime");
					String endTime1 = dateMapS.get("endTime");
					long result = sf.parse(endTime1).getTime()-sf.parse(stdTime1).getTime();
					resultAll  = resultAll+ result;
				}
			} else {
				continue;
			}
			if(resultTime>(resultAll/3)) {
				WarnHistory history = new WarnHistory();
				Calendar cal = Calendar.getInstance();
        		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				history.setRecordDescription(taskId+"月末的跑批监控时长大于前三个月的跑批时长之和，请运维人员知晓");
				history.setWarnSort("17");
				history.setPointName("ETL");
				history.setRecordName(dateMap.get("taskId"));
            	history.setRecordDate(sdf.format(cal.getTime()));
            	history.setWarnLevel(1);
            	this.warnHistoryDao.insertIntoWarnHistory(history);
			}
		}
	}
}
