package com.vprisk.mnt.base;


import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

import com.vprisk.rmplatform.util.DESUtils;
import com.vprisk.rmplatform.util.StringUtil;

public class CommonUtils {

	/*
	 * 
	 * 建立连接
	 */
	public static Connection getConn(String abc){
		try{    
		    //加载Oracle的驱动类    
			Class.forName("oracle.jdbc.driver.OracleDriver") ;    
		}catch(ClassNotFoundException e){    
		    System.out.println("找不到驱动程序类 ，加载驱动失败！");    
		    e.printStackTrace() ;    
		}
		String url= null;
		String username= null;
		String password = null;
		if(StringUtil.isNotNullOrEmpty(abc)){
			String c=getProp("rpm."+abc+".password");//获取密码配置文件内容
			username = getProp("rpm."+abc+".username");
			password = DESUtils.getDecryptString(c);//解密//TODO从配置文件获取，且存成密文
			//测试环境数据库连接
			url = getProp("rpm."+abc+".url");
			//生产环境数据库连接
			//url="jdbc:oracle:thin:@(description=(address_list=(address=(host=21.1.128.142)(protocol=tcp)(port=1521))(address=(host=21.1.128.144)(protocol=tcp)(port=1521))(load_balance=yes)(failover=yes))(connect_data=(service_name=dmdb)))";
		}
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url,username,password);
		} catch (SQLException e) {
			System.out.println("数据库连接失败！");
			e.printStackTrace();
		}
		return conn;
	}
	/*
	 * 
	 * 建立连接
	 */
	public static Connection getConnection(String conName,String driverType){
		try{    
			//加载Oracle的驱动类    
			if(driverType.equals("db2")){
				Class.forName("com.ibm.db2.jcc.DB2Driver") ;    
			} else {
				Class.forName("oracle.jdbc.driver.OracleDriver") ;    
			}
		}catch(ClassNotFoundException e){    
			System.out.println("找不到驱动程序类 ，加载驱动失败！");    
			e.printStackTrace() ;    
		}
		String url= null;
		String username= null;
		String password = null;
		String encrypt= null; //是否加密密码
		if(StringUtil.isNotNullOrEmpty(conName)){
			String c=getProp(conName+".password");//获取密码配置文件内容
			username = getProp(conName+".username");
			encrypt = getProp(conName+".encrypt");
			if(StringUtil.isNotNullOrEmpty(encrypt) && encrypt.equals("true")){
				password = DESUtils.getDecryptString(c);//解密//TODO从配置文件获取，且存成密文
			} else {
				password = c;//解密//TODO从配置文件获取，且存成密文
			}
			//测试环境数据库连接
			url = getProp(conName+".url");
			//生产环境数据库连接
			//url="jdbc:oracle:thin:@(description=(address_list=(address=(host=21.1.128.142)(protocol=tcp)(port=1521))(address=(host=21.1.128.144)(protocol=tcp)(port=1521))(load_balance=yes)(failover=yes))(connect_data=(service_name=dmdb)))";
		}
		Connection conn = null;
		try {
			conn = DriverManager.getConnection(url,username,password);
		} catch (SQLException e) {
			System.out.println("数据库连接失败！");
			e.printStackTrace();
		}
		return conn;
	}
	
	/*
	 * 释放JDBC资源
	 */
	public static void closeConn(ResultSet rs,Statement stmt,Connection conn){
		if(rs != null){   // 关闭记录集    
	        try{    
	            rs.close() ;    
	        }catch(SQLException e){   
	            e.printStackTrace() ;    
	        }
        }
        if(stmt != null){   // 关闭声明    
	        try{    
	            stmt.close() ;    
	        }catch(SQLException e){    
	            e.printStackTrace() ;    
	        }
        }
        if(conn != null){  // 关闭连接对象    
	         try{    
	            conn.close() ;    
	         }catch(SQLException e){    
	            e.printStackTrace() ;    
	         }
        }
	}
	public static String getProp(String propName){
		ClassLoader loader = CommonUtils.class.getClassLoader();
		InputStream inStream =	loader.getResourceAsStream(FILENAME);
		Properties propes=new Properties();
		String propValue = null;
		try {
			propes.load(inStream);
			propValue = propes.getProperty(propName);
				 
		} catch (IOException e) {
			e.printStackTrace();
		}
		return propValue;
	}
	private static final String FILENAME= "config.properties";
}

