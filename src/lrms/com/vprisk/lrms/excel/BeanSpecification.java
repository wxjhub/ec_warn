package com.vprisk.lrms.excel;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.beanutils.PropertyUtils;



public class BeanSpecification {
	//以属性名为key值
	private Map<String,PropertySpecification> properties = new HashMap<String,PropertySpecification>(); 
	//以列号为key值
	private Map<Integer,PropertySpecification> propertieNum = new HashMap<Integer, PropertySpecification>();
	  /** 
	    * 类路径名 
	    */ 
	  private String className; 
	  /** 
	    * 描述对应Class的properties 
	    */ 
	  private Map    describer; 
	  /** 
	    * 文件名 
	    */ 
	  private String fileName; 
	  /** 
	    * excel中数据记录的起点行数 
	    */ 
	  private Integer from; 

	  /** 
	    * 列标题所在行 
	    */ 
	  private Integer head; 

	  /** 
	    * 类属性和excel列名对应键值对 
	    */ 
	  private Map<String, String> nv=new LinkedHashMap<String,String>(); 
	    
	  /** 
	    * 类属性和excel列名对应键值对,反过来 
	    */ 
	  private Map<String, String> vn=new HashMap<String,String>(); 
	    
	  private List<String> propertyList = new ArrayList<String>(); 

	  public void addProperty(PropertySpecification field) { 
	    this.nv.put(field.getName(), field.getValue()); 
	    this.vn.put(field.getValue(),field.getName()); 
	    this.properties.put(field.getName(), field); 
	    this.propertieNum.put(field.getSeq(), field);
	    propertyList.add(field.getName()); 
	  } 

	    
	  public List<String> getPropertyList() { 
	    return propertyList; 
	  } 


	  public String getClassName() { 
	    return this.className; 
	  } 

	  public void setClassName(String classname) { 
	    this.className = classname; 
	  } 

	  public Map<String,PropertySpecification> getProperty() { 
	    return properties; 
	  } 

	  public String getPropertyNameByValue(String value) { 
	    return vn.get(value); 
	  } 
	  public String getValueByName(String name){
		  return nv.get(name);
	  }
	  public boolean nullable(String propertyName){ 
	    if(this.properties.containsKey(propertyName)){ 
	      return this.properties.get(propertyName).isNullable(); 
	    }else return false; 
	  } 

	  public void setProperty(Map<String,PropertySpecification> property) { 
	    this.properties = property; 
	  } 

	  public String getFileName() { 
	    return fileName; 
	  } 

	  public void setFileName(String fileName) { 
	    this.fileName = fileName; 
	  } 

	  public Integer getFrom() { 
	    return from; 
	  } 

	  public void setFrom(Integer from) { 
	    this.from = from; 
	  } 

	  public Integer getHead() { 
	    return head; 
	  } 

	  public void setHead(Integer head) { 
	    this.head = head; 
	  } 

	  public Map<String, String> getNv() { 
	    return nv; 
	  } 

	  public void setNv(Map<String, String> nv) { 
	    this.nv = nv; 
	  } 
	  
	  public PropertySpecification getPropertyByNum(Integer key){
		  PropertySpecification specification = this.propertieNum.get(key);
		  return specification;
	  }

	  @SuppressWarnings("unchecked") 
	  public Map getDescriber() { 
	    describer = new HashMap(); 
	    try { 
	      Class cls = Class.forName(this.className); 
	      Object bean = cls.newInstance(); 
	      describer = PropertyUtils.describe(bean); 
	    } catch (Exception e) { 
	      e.printStackTrace(); 
	    } 
	    return describer; 
	  } 

}
