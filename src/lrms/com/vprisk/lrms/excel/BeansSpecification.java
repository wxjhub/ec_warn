package com.vprisk.lrms.excel;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import com.vprisk.lrms.util.BeansSpecificationUtil;




public class BeansSpecification {

	private static BeansSpecification instance= null; 
	public static BeansSpecification getInstance(InputStream inputStream){ 
	    if(instance== null){ 
	      try {
			instance = BeansSpecificationUtil.getBeans(inputStream);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	    } 
	    return instance; 
  } 
  /** 
    * 跟元素下所有的beans 
    */ 
  private List<BeanSpecification> beans = new ArrayList<BeanSpecification>(); 

  public List<BeanSpecification> getBeans() { 
    return this.beans; 
  } 

  public void addBean(BeanSpecification field) { 
    this.beans.add(field); 
  } 

  /** 
    * 根据文件名和类名查找 
    * @param fileName 
    * @return 
    */ 
  public BeanSpecification getBean(String fileName) { 
    for (BeanSpecification bean : beans) { 
      if (bean.getClassName().equals(fileName)) { 
        return bean; 
      } 
    } 
    return null; 
  } 
  public BeanSpecification getBeanByClassName(String className) { 
    for (BeanSpecification bean : beans) { 
      if (bean.getClassName().equals(className)) { 
        return bean; 
      } 
    } 
    return null; 
  } 
}

