package com.vprisk.lrms.excel;

import java.lang.reflect.Method;
/**  
* 这是一个用于方法反射的工具类  
* 这将运用JDK的反射机制  
* @author strive  
*  
*/ 
public class MethodTool {
	/**  
	  * 反转一个有返回值的无参方法  
	  * @param object  
	  * @param methodName  
	 * @return  
	  * @throws Exception  
	  */  
	public static Object excuteMethod(Object object,String methodName) throws Exception   
	{   
	  Class c=object.getClass();   
	  Method m=c.getMethod(methodName);   
	  return m.invoke(object);   
	}   
	/**  
	  * 反转一个没有返回值的有一个参数的方法  
	 * @param object  
	  * @param methodName  
	  * @param parameter  
	  * @throws Exception  
	  */  
	public static void excuteMethod(Object object,String methodName,Object parameter) throws Exception   
	{   
	  Class c=object.getClass();   
	  Method m=c.getDeclaredMethod(methodName, parameter.getClass());   
	  m.invoke(object,parameter);   
	}   
	/**  
	  * 执行一个参数为boolean类型的方法  
	  * @param object  
	  * @param methodName  
	  * @param parameter  
	 * @throws Exception  
	  */  
	public static void excuteBoolMethod(Object object,String methodName,boolean parameter) throws Exception   
	{   
	  Class c=object.getClass();   
	  Method m=c.getDeclaredMethod(methodName,boolean.class);   
	  m.invoke(object,parameter);   
	}   
	/**  
	  * 获得一个属性的set方法名  
	  * @param property  
	  * @return  
	  */  
	public static String returnSetMethodName(String property)   
	{   
	    return "set"+Character.toUpperCase(property.charAt(0))+property.substring(1);   
	}   
	/**  
	 * 获得一个属性的get方法名  
	  * @param property  
	  * @return  
	  */  
	public static String returnGetMethodName(String property)   
	{   
		return "get"+Character.toUpperCase(property.charAt(0))+property.substring(1);   
	}   

}
