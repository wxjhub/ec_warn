package com.vprisk.lrms.excel;

import java.lang.reflect.InvocationTargetException; 
import java.util.List;

import org.apache.commons.beanutils.MethodUtils; 
import org.apache.commons.lang.StringUtils; 


/** 
* xls 导入规则 
* @author Administrator 
* 
*/ 
public class XlsImpRule { 
    
    
  /** 
    * 验证数据的合法性 
    * @param propertyName 属性名
    * @param value 
    * @return TRUE:表示通过 
    */ 
  public Boolean validateProperty(BeanSpecification bs,String propertyName,Object value){ 
    PropertySpecification ps =    bs.getProperty().get(propertyName); 
    String formular = ps.getFormular(); 
    if(StringUtils.isBlank(formular)){ 
      return true; 
    } 
    String ismethodName = "is"+StringUtils.capitalize(formular); 
    String setmethodName = "set"+StringUtils.capitalize(formular); 
    Object result = null; 
    try { 
      result = MethodUtils.invokeStaticMethod(ValidateUtil.class,ismethodName,value.toString()); 
        
    } catch (NoSuchMethodException e) { 
      e.printStackTrace(); 
//      try { 
//        result = MethodUtils.invokeStaticMethod(ValidateUtil.class,setmethodName,value); 
//      } catch (Exception es) { 
//        es.printStackTrace(); 
//      }    
    } catch (IllegalAccessException e) { 
      e.printStackTrace(); 
    } catch (InvocationTargetException e) { 
      e.printStackTrace(); 
    } 
    if(result!= null){ 
      return (Boolean)result; 
    } 
    return Boolean.TRUE; 
  } 
  
  /** 
   * 验证数据的合法性 
   * @param num 列号 
   * @param value 
   * @return TRUE:表示通过 
   */ 
 public Boolean validateProperty(BeanSpecification bs,Integer rowNum,Integer num,String value,List<String> errors){ 
   StringBuffer output = new StringBuffer(); 
   PropertySpecification ps =  bs.getPropertyByNum(num);
   if(!ps.isNullable()){
	   if(StringUtils.isBlank(value)){
		   String error = "第"+(rowNum+1)+"行"+ps.getValue()+"列不能为空";
		   errors.add(error);
		   return false;
	   }else{
		   String formular = ps.getFormular(); 
		   if(StringUtils.isBlank(formular)){ 
		     return true; 
		   } 
		   String ismethodName = "is"+StringUtils.capitalize(formular); 
		   String setmethodName = "set"+StringUtils.capitalize(formular); 
		   Object result = null; 
		   try { 
		     result = MethodUtils.invokeStaticMethod(ValidateUtil.class,ismethodName,value.toString()); 
		       
		   } catch (NoSuchMethodException e) { 
		     e.printStackTrace();    
		   } catch (IllegalAccessException e) { 
		     e.printStackTrace(); 
		   } catch (InvocationTargetException e) { 
		     e.printStackTrace(); 
		   } 
		   if(result!= null){
			  if(!(Boolean)result){
				  this.addPropertyWarrning(rowNum,bs,num,output);
				  errors.add(output.toString());
			  }
		     return (Boolean)result; 
		   } 
	   }
   }
   
   return Boolean.TRUE; 
 } 
  /** 
    * 添加某属性警告 
    * @return 
    */ 
  public  void addPropertyWarrning(int rowNum,BeanSpecification bs,String propertyName,StringBuffer output){ 
    PropertySpecification ps =    bs.getProperty().get(propertyName); 
    String wf = ps.getWarringFormat(); 
    String result = String.format(wf,ps.getValue()); 
    output.append("第"+(rowNum+1)+"行数据："); 
    output.append(result).append("\n"); 
  } 
  
  /** 
   * 添加某属性警告 
   * @return 
   */ 
 public void addPropertyWarrning(int rowNum,BeanSpecification bs,Integer num,StringBuffer output){ 
   PropertySpecification ps =    bs.getPropertyByNum(num); 
   String wf = ps.getWarringFormat(); 
   String result = String.format(wf,ps.getValue()); 
   output.append("第"+rowNum+"行数据："); 
   output.append(result).append("\n"); 
 } 



}
