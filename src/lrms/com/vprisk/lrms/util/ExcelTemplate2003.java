package com.vprisk.lrms.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.vprisk.lrms.excel.BeanSpecification;
import com.vprisk.lrms.excel.BeansSpecification;
import com.vprisk.lrms.excel.ExcelTemplate;
import com.vprisk.lrms.excel.MethodTool;
import com.vprisk.lrms.excel.PropertySpecification;
import com.vprisk.lrms.excel.XlsImpRule;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.dao.hibernate.HibernateGenericDao;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * Excel导入导出工具类
 * 
 * @author wq
 * 
 */
public class ExcelTemplate2003 implements ExcelTemplate{
	final static SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	private static HibernateGenericDao dao = new HibernateGenericDao();
	public  ByteArrayOutputStream createFixationSheet(List<?> list,
			Class<?> clazz) {
		HSSFWorkbook wb = new HSSFWorkbook();
		ByteArrayOutputStream bo = new ByteArrayOutputStream();
		BeansSpecification bs = BeansSpecification.getInstance(null);
		BeanSpecification beanSpecification = bs.getBean(clazz.getName());
		
		String fileName = beanSpecification.getFileName();
		if(StringUtil.isNullOrEmpty(fileName))
			fileName =  clazz.getSimpleName();
		
		HSSFSheet sheet = wb.createSheet(fileName);
		
		if (beanSpecification == null) {
			throw new RuntimeException("该实体" + clazz.getName() + "不能够导出");
		}
		BeansSpecificationUtil.createTitleRow(wb, sheet, beanSpecification);
		if(list!=null&&list.size()>0){
			Field[] fields = clazz.getDeclaredFields();
			List<String> names = beanSpecification.getPropertyList();
			int headCol = 0;
			int fromCol = 1;
			if (beanSpecification.getHead() != null) {
				headCol = beanSpecification.getHead() - 1 < 0 ? 0 : beanSpecification.getHead() - 1;
			}
			if (beanSpecification.getHead() != null) {
				fromCol = beanSpecification.getFrom() - 1 < 1 ? 1 : beanSpecification.getFrom() - 1;
			}
			HSSFCellStyle cellStyleShortDt = wb.createCellStyle();
			// 指定日期显示格式
			cellStyleShortDt.setDataFormat((HSSFDataFormat
					.getBuiltinFormat("yyyy-MM-dd")));
			HSSFCellStyle cellStyle2 = wb.createCellStyle();
	        HSSFDataFormat format = wb.createDataFormat();
	        cellStyle2.setDataFormat(format.getFormat("@"));
			for (int i = 0; i < list.size(); i++) {
				Object ob = list.get(i);
				HSSFRow row = sheet.createRow(fromCol);
				for (Field field : fields) {
					field.setAccessible(true);
					try {
						Class class1 = field.getType();
						//System.out.println(class1.getName());
						Object object = field.get(ob);
						String name = field.getName();
						if (names.contains(name)) {
							//System.out.println((String) object.toString());
							PropertySpecification ps = beanSpecification
									.getProperty().get(name);
							cteateCell(wb, row, ps.getSeq(), object, class1.getName(),beanSpecification,cellStyleShortDt,cellStyle2);
							
						}

					} catch (IllegalArgumentException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					}
				}
				fromCol++;
			}
			try {
				wb.write(bo);
			} catch (IOException e) {
				e.printStackTrace();
			}

		}else{//生成模板
			try {
				wb.write(bo);
			} catch (IOException e) {
				e.printStackTrace();
			}
			
		}
		return bo;
		
	}

	public  List inputExcel(Class<?> clazz, InputStream inputStream,List<String> errors)
			throws SecurityException, NoSuchMethodException,
			IllegalArgumentException, InstantiationException,
			IllegalAccessException, InvocationTargetException, ParseException, NoSuchFieldException {
		//List<String> errors = new ArrayList<String>();
		List dist = new ArrayList();
		BeansSpecification bs = BeansSpecification.getInstance(null);
		BeanSpecification bean = bs.getBean(clazz.getName());
		try {
			POIFSFileSystem poi = new POIFSFileSystem(inputStream);
			HSSFWorkbook wb = new HSSFWorkbook(poi);
			HSSFSheet sheet = wb.getSheetAt(0);
			int headCol = 0;
			int fromCol = 1;
			if (bean.getHead() != null) {
				headCol = bean.getHead() - 1 < 0 ? 0 : bean.getHead() - 1;
			}
			if (bean.getHead() != null) {
				fromCol = bean.getFrom() - 1 < 1 ? 1 : bean.getFrom() - 1;
			}

			/**
			 * 解析头部信息
			 */
			HSSFRow head = sheet.getRow(headCol);
			int cols = head.getPhysicalNumberOfCells();
			String[] p = new String[cols];
			for (int j = 0; j < cols; j++) {
				HSSFCell cell = head.getCell(j);
				String col = cell.getStringCellValue();
				if (bean.getPropertyNameByValue(col) != null) {
					p[j] = col;
				}
			}
			Map<String, PropertySpecification> map = bean.getProperty();
			List<String> names = new ArrayList<String>();
			for (int i = 0; i < p.length; i++) {
				String name = bean.getPropertyNameByValue(p[i]);
				names.add(name);
			}
			/**
			 * 类反射得到调用方法
			 */
			// 得到目标目标类的所有的字段列表
			Field filed[] = clazz.getDeclaredFields();
			// 将所有标有Annotation的字段，也就是允许导入数据的字段,放入到一个map中
			Map<Integer, Method> fieldmap = new HashMap<Integer, Method>();
			// 循环读取所有字段
			for (int i = 0; i < filed.length; i++) {
				Field f = filed[i];
				if (names.contains(f.getName())) {
					String fieldname = f.getName();
					String setMethodName = "set"+ fieldname.substring(0, 1).toUpperCase()+ fieldname.substring(1);
					// 构造调用的method，
					Method setMethod = clazz.getMethod(setMethodName,
							new Class[] { f.getType() });
					PropertySpecification ps = map.get(fieldname);
					fieldmap.put(ps.getSeq(), setMethod);
				}
			}

			int rows = sheet.getPhysicalNumberOfRows();
			for (int i = fromCol; i < rows; i++) {
				HSSFRow row = sheet.getRow(i);
				if (row != null&&isEmptyRow(row)) {
					Object object = readRow(bean,row, clazz, fieldmap,errors);
					if (object != null) {
						dist.add(object);
					}
				}

			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return dist;

	}

	/**
	 * 创建一个列并注入值
	 * 
	 * @param wb
	 * @param row要插入的行
	 * @param col要创建的列在行中的位置，以0开始
	 * @param val要向该列插入的值
	 */
	private static void cteateCell(HSSFWorkbook wb, HSSFRow row, int col,
			Object val, String type,BeanSpecification bean,HSSFCellStyle cellStyleShortDt,HSSFCellStyle cellStyle2) {
		
		if(StringUtil.isNotNullOrEmpty(val)){
			
			HSSFCell cell = row.createCell(col);
		
			//cell.setEncoding(HSSFCell.ENCODING_UTF_16);
			if (type.endsWith("String")) {
				cell.setCellValue((String) val);
			} else if ("int".equals(type) || "java.lang.Integer".equals(type)) {
				cell.setCellValue((Integer) val);
			} else if ("double".equals(type) || "java.lang.Double".equals(type)) {
				cell.setCellValue((Double) val);
			} else if (type.endsWith("Date")) {
				cell = row.createCell((short) col);
				cell.setCellValue(new Date());
				// 设定单元格日期显示格式
				cell.setCellStyle(cellStyleShortDt);
				cell.setCellValue(format.format((Date) val));
			} else if (type.endsWith("Calendar")) {
				cell.setCellValue((Calendar) val);
			} else if ("boolean".equals(type) || "java.lang.Boolean".equals(type)) {
				cell.setCellValue((Double) val);
			} else {
				PropertySpecification ps = bean.getPropertyByNum(col);
				Class clazz = ps.getClazz();
				String propertyName = ps.getPropertyName();
				if(clazz!=null&&propertyName!=null&&!"".equals(propertyName)){
					try {
						Field field = clazz.getDeclaredField(propertyName);
						field.setAccessible(true);
						Object object = field.get(val);
						String className = field.getType().getName();
						if (className.endsWith("String")) {
							cell.setCellValue((String) object);
						} else if ("int".equals(className) || "java.lang.Integer".equals(className)) {
							cell.setCellValue((Integer) object);
						} else if ("double".equals(className) || "java.lang.Double".equals(className)) {
							cell.setCellValue((Double) object);
						} else if (className.endsWith("Date")) {
							cell = row.createCell((short) col);
							cell.setCellValue(new Date());
							// 设定单元格日期显示格式
							cell.setCellStyle(cellStyleShortDt);
							cell.setCellValue(format.format((Date) object));
						} else if (className.endsWith("Calendar")) {
							cell.setCellValue((Calendar) object);
						} else if ("boolean".equals(className) || "java.lang.Boolean".equals(className)) {
							cell.setCellValue((Double) object);
						}
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
				}else{
					throw new RuntimeException("数据格式有问题");
				}
			}
				
			if (!type.endsWith("Date")) {
		        cell.setCellStyle(cellStyle2);
			}
		}
	
	}

	private static Object readRow(BeanSpecification bean,HSSFRow rown, Class clazz,
			Map<Integer, Method> fieldmap,List<String> errors) throws InstantiationException,
			IllegalAccessException, IllegalArgumentException,
			InvocationTargetException, ParseException, SecurityException, NoSuchFieldException {
		XlsImpRule rule = new XlsImpRule();
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		// 行的所有列
		Iterator<Cell> cellbody = rown.cellIterator();
		// 得到传入类的实例
		Object tObject = clazz.newInstance();
		boolean validate = true;
		// 遍历一行的列
		while (cellbody.hasNext()) {
			Cell cell = cellbody.next();
			if (cell != null) {
				int num = cell.getColumnIndex();
				PropertySpecification ps = bean.getPropertyByNum(num);
				if(ps.isUnique()){
					if(isUnique(getCellValue(cell), clazz, ps.getName())){
						Method setMethod = (Method) fieldmap.get(num);
						if (setMethod != null) {
							// 得到setter方法的参数
							Type[] ts = setMethod.getGenericParameterTypes();
							// 只要一个参数
							String xclass = ts[0].toString();
							Class cla = ps.getClazz();
							
							String propertyName = ps.getPropertyName();
							if(cla!=null&&propertyName!=null&&!"".equals(propertyName)){
								Object object = cla.newInstance();
								String methodName = MethodTool.returnSetMethodName(propertyName);
								Field field = cla.getDeclaredField(propertyName);
								String className = field.getType().getName();
								String value = getCellValue(cell);
								if(isExist(value,cla,propertyName)){
									try {
										Method setMet = cla.getMethod(methodName,
												new Class[] {field.getType()});
										Object o =null;
										// 判断参数类型
										if (className.equals("java.lang.String")) {
											
											boolean b = rule.validateProperty(bean,rown.getRowNum(), num, value,errors);
											if(b){
												 o = setMet.invoke(object,value );
											}else {
												validate = false;
											}
											
										} else if (className.equals("java.util.Date")) {
											
											boolean b = rule.validateProperty(bean,rown.getRowNum(), num, value,errors);
											if(b){
												if(value!=null&&!"".equals(value)){
													 o =  setMet.invoke(object, sf.parse(value));
												}
											}else {
												validate = false;
											}
										} else if (className.equals("java.lang.Boolean")) {
											boolean b = rule.validateProperty(bean,rown.getRowNum(), num, getCellValue(cell),errors);
											if(b){
												Boolean boolname = true;
												if (getCellValue(cell).equals("否")) {
													boolname = false;
												}
												 o = setMet.invoke(object, boolname);
											}else{
												validate = false;
											}
											
										} else if (className.equals("java.lang.Integer")) {
											
											boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
											if(b){
												 o = setMet.invoke(object, new Integer(value));
											}else{
												validate = false;
											}
											
										}

										else if (className.equals("java.lang.Long")) {
											
											boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
											if(b){
												 o = setMet.invoke(object, new Integer(value));
											}else{
												validate = false;
											}
										}	
										
										setMethod.invoke(tObject,object);
									} catch (SecurityException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									} catch (NoSuchMethodException e) {
										// TODO Auto-generated catch block
										e.printStackTrace();
									}
								}else{
									validate = false;
									errors.add((rown.getRowNum()+1)+"的"+propertyName+"所对应的"+cla.getSimpleName()+"数据库不存在");
								}
								
							}else{
								// 判断参数类型
								if (xclass.equals("class java.lang.String")) {
									String value = getCellValue(cell);
									boolean b = rule.validateProperty(bean,rown.getRowNum(), num, value,errors);
									if(b){
										setMethod.invoke(tObject,value );
									}else {
										validate = false;
									}
									
								} else if (xclass.equals("class java.util.Date")) {
									String va = getCellValue(cell);
									boolean b = rule.validateProperty(bean,rown.getRowNum(), num, va,errors);
									if(b){
										if(va!=null&&!"".equals(va)){
											setMethod.invoke(tObject, sf.parse(va));
										}
									}else {
										validate = false;
									}
								} else if (xclass.equals("class java.lang.Boolean")) {
									boolean b = rule.validateProperty(bean,rown.getRowNum(), num, getCellValue(cell),errors);
									if(b){
										Boolean boolname = true;
										if (getCellValue(cell).equals("否")) {
											boolname = false;
										}
										setMethod.invoke(tObject, boolname);
									}else{
										validate = false;
									}
									
								} else if (xclass.equals("class java.lang.Integer")) {
									String value = getCellValue(cell);
									boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
									if(b){
										setMethod.invoke(tObject, new Integer(value));
									}else{
										validate = false;
									}
									
								}

								else if (xclass.equals("class java.lang.Long")) {
									String value = getCellValue(cell);
									boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
									if(b){
										setMethod.invoke(tObject, new Integer(value));
									}else{
										validate = false;
									}
								}	
						
						}
					}
					}else{
						validate = false;
						errors.add("第"+(rown.getRowNum()+1)+"行的"+getCellValue(cell)+"数据库已存在;");
					}
				}else{
					Method setMethod = (Method) fieldmap.get(num);
					if (setMethod != null) {
						// 得到setter方法的参数
						Type[] ts = setMethod.getGenericParameterTypes();
						// 只要一个参数
						String xclass = ts[0].toString();
						Class cla = ps.getClazz();
						
						String propertyName = ps.getPropertyName();
						if(cla!=null&&propertyName!=null&&!"".equals(propertyName)){
							Object object = cla.newInstance();
							String methodName = MethodTool.returnSetMethodName(propertyName);
							Field field = cla.getDeclaredField(propertyName);
							String className = field.getType().getName();
							String value = getCellValue(cell);
							if(isExist(value,cla,propertyName)){
								try {
									Method setMet = cla.getMethod(methodName,
											new Class[] {field.getType()});
									Object o =null;
									// 判断参数类型
									if (className.equals("java.lang.String")) {
										
										boolean b = rule.validateProperty(bean,rown.getRowNum(), num, value,errors);
										if(b){
											 o = setMet.invoke(object,value );
										}else {
											validate = false;
										}
										
									} else if (className.equals("java.util.Date")) {
										
										boolean b = rule.validateProperty(bean,rown.getRowNum(), num, value,errors);
										if(b){
											if(value!=null&&!"".equals(value)){
												 o =  setMet.invoke(object, sf.parse(value));
											}
										}else {
											validate = false;
										}
									} else if (className.equals("java.lang.Boolean")) {
										boolean b = rule.validateProperty(bean,rown.getRowNum(), num, getCellValue(cell),errors);
										if(b){
											Boolean boolname = true;
											if (getCellValue(cell).equals("否")) {
												boolname = false;
											}
											 o = setMet.invoke(object, boolname);
										}else{
											validate = false;
										}
										
									} else if (className.equals("java.lang.Integer")) {
										
										boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
										if(b){
											 o = setMet.invoke(object, new Integer(value));
										}else{
											validate = false;
										}
										
									}

									else if (className.equals("java.lang.Long")) {
										
										boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
										if(b){
											 o = setMet.invoke(object, new Integer(value));
										}else{
											validate = false;
										}
									}	
									
									setMethod.invoke(tObject,object);
								} catch (SecurityException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								} catch (NoSuchMethodException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}else{
								validate = false;
								errors.add((rown.getRowNum()+1)+"的"+propertyName+"所对应的"+cla.getSimpleName()+"数据库不存在");
							}
							
				}else{
							// 判断参数类型
							if (xclass.equals("class java.lang.String")) {
								String value = getCellValue(cell);
								boolean b = rule.validateProperty(bean,rown.getRowNum(), num, value,errors);
								if(b){
									setMethod.invoke(tObject,value );
								}else {
									validate = false;
								}
								
							} else if (xclass.equals("class java.util.Date")) {
								String va = getCellValue(cell);
								boolean b = rule.validateProperty(bean,rown.getRowNum(), num, va,errors);
								if(b){
									if(va!=null&&!"".equals(va)){
										setMethod.invoke(tObject, sf.parse(va));
									}
								}else {
									validate = false;
								}
							} else if (xclass.equals("class java.lang.Boolean")) {
								boolean b = rule.validateProperty(bean,rown.getRowNum(), num, getCellValue(cell),errors);
								if(b){
									Boolean boolname = true;
									if (getCellValue(cell).equals("否")) {
										boolname = false;
									}
									setMethod.invoke(tObject, boolname);
								}else{
									validate = false;
								}
								
							} else if (xclass.equals("class java.lang.Integer")) {
								String value = getCellValue(cell);
								boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
								if(b){
									setMethod.invoke(tObject, new Integer(value));
								}else{
									validate = false;
								}
								
							}

							else if (xclass.equals("class java.lang.Long")) {
								String value = getCellValue(cell);
								boolean b = rule.validateProperty(bean,rown.getRowNum(), num,value,errors);
								if(b){
									setMethod.invoke(tObject, new Integer(value));
								}else{
									validate = false;
								}
							}	
					
					}
				}
				}
				
			}
		}
		if(!validate){
			return null;
		}
		return tObject;
	}

	private static String getCellValue(Cell hssfCell) {
		double EXP = 0.0000000000000001;
		// Object value = null;
		// 获取单元格的值
		String retStr = "";
		if (hssfCell != null) {
			int type = hssfCell.getCellType();

			switch (type) {

			case HSSFCell.CELL_TYPE_NUMERIC: // Numeric
				if (HSSFDateUtil.isCellDateFormatted(hssfCell)) {
					retStr = (new SimpleDateFormat("yyyy-MM-dd")
							.format(hssfCell.getDateCellValue()));
				} else {
					double value = hssfCell.getNumericCellValue();
					// 如果两个数值相差很小,则转换为整数
					if (Math.abs(value - (long) value) < EXP) {
						retStr = String.valueOf((long) value);
					} else {
						// double值
						retStr = String.valueOf(hssfCell.getNumericCellValue());
					}
				}
				break;
			case HSSFCell.CELL_TYPE_STRING: // String
				retStr = hssfCell.getRichStringCellValue().getString();
				break;
			case HSSFCell.CELL_TYPE_FORMULA: // Formula 公式, 方程式
				retStr = String.valueOf(hssfCell.getNumericCellValue());
				break;
			case HSSFCell.CELL_TYPE_BLANK: // Blank
				retStr = "";
				break;
			case HSSFCell.CELL_TYPE_BOOLEAN: // boolean
				retStr = Boolean.valueOf(hssfCell.getBooleanCellValue())
						.toString();
				break;
			case HSSFCell.CELL_TYPE_ERROR: // Error
				break;
			}
		}
		// 除去字符串中的空格
		return retStr.replaceAll("//s", "");
	}
	
	private static boolean isEmptyRow(HSSFRow rown){
		Iterator<Cell> cellbody = rown.cellIterator();
		while (cellbody.hasNext()) {
			Cell cell = cellbody.next();
			if(cell.getCellType()!=HSSFCell.CELL_TYPE_BLANK&&!"".equals(getCellValue(cell))){
				return true;
			}
		}
		return false;
	}
	private static boolean isExist(String value,Class clazz,String name){
		SessionFactory factory = (SessionFactory) ContextHolder.getBean("sessionFactory");
		Session session = factory.openSession();
		boolean b = true;
		String hql = "from " + clazz.getSimpleName() +" t where t."+name+ " = ?";
		Query query =session.createQuery(hql);
		query.setParameter(0, value);
		List list = query.list();
		session.close();
		if(list==null||list.size()==0){
			return false;
		}
		return b;
	}
	
	private static boolean isUnique(String value,Class clazz,String name){
		SessionFactory factory = (SessionFactory) ContextHolder.getBean("sessionFactory");
		Session session = factory.openSession();
		boolean b = true;
		String hql = "from " + clazz.getSimpleName() +" t where t."+name+ " = ?";//20120937470  
		Query query =session.createQuery(hql);
		query.setParameter(0, value);
		List list = query.list();
		session.close();
		if(list.size()>0){
			return false;
		}
		return b;
	}
	
}
