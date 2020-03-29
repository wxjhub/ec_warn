package com.vprisk.lrms.util;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.sql.DataSource;

import com.vprisk.rmplatform.context.ContextHolder;

public class ProcExec {
	public static String streeProdExec(Date dataDate,String SettingName,String Currency){// 调用存储过程
		String Remsg = "";
		Connection con = null;
		//toUpperCase()变成打大写
		CallableStatement castm = null;
		try {

			DataSource ds;
			Object o = ContextHolder.getBean("dataSource");
			ds = (DataSource) o;
			con = ds.getConnection();
			String sql = "";
			SimpleDateFormat  sd = new SimpleDateFormat("yyyy-MM-dd");  
			String asofDate =  sd.format(dataDate).toString();
			sql="{call FLOW_YL(to_date('"+asofDate+"','YYYY-MM-DD'),'"+SettingName+"')}";
			String sql1="";
			if("CNY".equals(Currency)||"SYUSD".equals(Currency)||"TOTAL".equals(Currency))
			{
			sql1="{call FLOW_YLH(to_date('"+asofDate+"','YYYY-MM-DD'),'"+SettingName+"')}";
				castm = con.prepareCall(sql);
				castm.execute();
				castm = con.prepareCall(sql1);
				castm.execute();
			}else
			{
				castm = con.prepareCall(sql);
				castm.execute();
			}
			//sql = "{call A_TIME}";
			
			if (Remsg.equals("")) {
				Remsg = "runnable success";
			}
			System.out.println(Remsg);

		} catch (Exception e1) {
			try {
				if ((e1.getMessage()).contains("无法从套接字读取更多的数据")) {
					Remsg = "TASKSTOP";
				} else if (!(e1.getMessage()).contains("ORA-00028")) {
					Remsg = "ERROR:" + e1.getMessage();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		} finally {
			try {
				castm.close();
				con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return Remsg;
	}
	public static String dynaProdExec(Date dataDate,String SettingName){// 调用存储过程
		String Remsg = "";
		Connection con = null;
		//toUpperCase()变成打大写
		CallableStatement castm = null;
		try {

			DataSource ds;
			Object o = ContextHolder.getBean("dataSource");
			ds = (DataSource) o;
			con = ds.getConnection();
			String sql = "";
			System.out.println(dataDate);
			SimpleDateFormat  sd = new SimpleDateFormat("yyyy-MM-dd");  
			String asofDate =  sd.format(dataDate).toString();
			sql="{call lrms_dynamic_simulation(to_date('"+asofDate+"','YYYY-MM-DD'),'"+SettingName+"')}";
			castm = con.prepareCall(sql);
			//castm.setDate(1,(java.sql.Date) dataDate);
			castm.execute();
			if (Remsg.equals("")) {
				Remsg = "runnable success";
			}
			System.out.println(Remsg);

		} catch (Exception e1) {
			try {
				if ((e1.getMessage()).contains("无法从套接字读取更多的数据")) {
					Remsg = "TASKSTOP";
				} else if (!(e1.getMessage()).contains("ORA-00028")) {
					Remsg = "ERROR:" + e1.getMessage();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		
		} finally {
			try {
				castm.close();
				con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return Remsg;
	}
}
