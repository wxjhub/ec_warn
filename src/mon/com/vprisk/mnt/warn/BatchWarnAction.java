package com.vprisk.mnt.warn;

import java.text.ParseException;
import java.util.TimerTask;

import com.vprisk.mnt.action.WarnBatchAction;


/**
 * 跑批监控处理类
 * @author lenovo
 *
 */
public class BatchWarnAction extends TimerTask{
	private static boolean isrunning = false;
	public void run() {
		try{
			apply();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
    /**
     * 定时器调用的方法
     * @throws ParseException 
     */
	private  synchronized void apply() throws ParseException{
		if(!isrunning){
			isrunning = true;
			WarnBatchAction warnBatchAction = new WarnBatchAction();
			warnBatchAction.serviceServer();
			isrunning = false;
		}else{
			System.out.println("跑批处理还没有运行完毕!");
		}
	}
}
