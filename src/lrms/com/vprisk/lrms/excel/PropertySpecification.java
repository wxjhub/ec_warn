package com.vprisk.lrms.excel;

public class PropertySpecification {
	  /** 
	    * 顺序号 
	    */ 
	  private int    seq; 
	  /** 
	    * 格式 
	    */ 
	  private String formular; 
	  /** 
	    * 提示格式 
	    */ 
	  private String warringFormat; 
	    
	  private String type; 
	  /** 
	    * 属性名 
	    */ 
	  private String name; 
	    
	  /** 
	    * 列名 
	    */ 
	  private String value; 
	    
	  /** 
	    * 是否可以为空 
	    */ 
	  private boolean nullable=true; 
	    
	  private boolean unique = false;
	  private int index; 

	  private String propertyName;
	  
	  private Class clazz;
	  public String getName() { 
	    return name; 
	  } 

	  public void setName(String name) { 
	    this.name = name; 
	  } 

	  public String getValue() { 
	    return value; 
	  } 

	  public void setValue(String value) { 
	    this.value = value; 
	  } 

	  public int getIndex() { 
	    return index; 
	  } 

	  public void setIndex(int index) { 
	    this.index = index; 
	  } 
	    
	    
	  public boolean isNullable() { 
	    return nullable; 
	  } 

	  public void setNullable(boolean nullable) { 
	    this.nullable = nullable; 
	  } 

	  @Override 
	  public String toString() { 
	    return "name="+name+";value="+value+";seq="+seq+";type="+type+",nullable="+nullable; 
	  } 

	  public int getSeq() { 
	    return seq; 
	  } 

	  public void setSeq(int seq) { 
	    this.seq = seq; 
	  } 

	  public String getType() { 
	    return type; 
	  } 

	  public void setType(String type) { 
	    this.type = type; 
	  } 

	  public String getFormular() { 
	    return formular; 
	  } 

	  public void setFormular(String formular) { 
	    this.formular = formular; 
	  } 

	  public String getWarringFormat() { 
	    return warringFormat; 
	  } 

	  public void setWarringFormat(String warringFormat) { 
	    this.warringFormat = warringFormat; 
	  }

	public String getPropertyName() {
		return propertyName;
	}

	public void setPropertyName(String propertyName) {
		this.propertyName = propertyName;
	}

	public Class getClazz() {
		return clazz;
	}

	public void setClazz(Class clazz) {
		this.clazz = clazz;
	}

	public boolean isUnique() {
		return unique;
	}

	public void setUnique(boolean unique) {
		this.unique = unique;
	}

	
}
