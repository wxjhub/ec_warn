package com.vprisk.mnt.service;

import java.text.ParseException;

/**
 * 跑批预警service
 * @author lenovo
 *
 */
public interface WarnBatchService {
    /**
     * 生成预警告警数据
     * @throws ParseException 
     */
	void generateData() throws ParseException;

}
