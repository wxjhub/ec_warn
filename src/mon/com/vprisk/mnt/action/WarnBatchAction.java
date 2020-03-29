package com.vprisk.mnt.action;

import java.text.ParseException;

import com.vprisk.mnt.service.WarnBatchService;
import com.vprisk.rmplatform.web.action.BaseAction;
/**
 * 跑批预警action
 * @author lenovo
 *
 */
public class WarnBatchAction  extends BaseAction{
	private  WarnBatchService warnBatchService = (WarnBatchService)super.getBean("warnBatchService");
    /**
     * 调用ETL的数据 生成报警 并插入日志数据
     * @throws ParseException 
     */
	public void serviceServer() throws ParseException {
		warnBatchService.generateData();
	}

}
