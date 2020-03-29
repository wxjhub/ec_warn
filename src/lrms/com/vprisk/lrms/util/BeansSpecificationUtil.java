package com.vprisk.lrms.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import com.vprisk.lrms.excel.BeanSpecification;
import com.vprisk.lrms.excel.BeansSpecification;
import com.vprisk.lrms.excel.PropertySpecification;




public class BeansSpecificationUtil {
	  
	  /**
		 * 解析XML文件
		 * 
		 * @param className
		 * @return
		 * @throws ParserConfigurationException
		 * @throws IOException
		 * @throws SAXException
		 */
		public static BeansSpecification getBeans(InputStream inputStream) throws Exception {
			if(inputStream==null){
				inputStream = BeansSpecificationUtil.class.getClassLoader().getResourceAsStream("lrmsbeans.xml");
			}
			BeansSpecification beansSpecification  = new BeansSpecification();
			Document doc = DocumentBuilderFactory.newInstance()
					.newDocumentBuilder().parse(inputStream);
			 Element elem = doc.getDocumentElement();             
		    NodeList nodeList = elem.getElementsByTagName("bean");   

			//NodeList nodeList = doc.getElementsByTagName("bean");
			Element element;
			for (int i = 0; i < nodeList.getLength(); i++) {
				element = (Element) nodeList.item(i);
				BeanSpecification e = new BeanSpecification();
				NodeList properList = element.getChildNodes();
				Map<String,PropertySpecification> map = new HashMap<String, PropertySpecification>();
				for(int j=0;j<properList.getLength();j++){
					if(properList.item(j).getNodeType()==Node.ELEMENT_NODE){
						Element chilElement =  (Element) properList.item(j);
						PropertySpecification specification = new PropertySpecification();
						
						specification.setFormular(chilElement.getAttribute("formular"));
						if(chilElement.getAttribute("index")!=null&&!"".equals(chilElement.getAttribute("index"))){
							specification.setIndex(Integer.parseInt(chilElement.getAttribute("index")));
						}
						specification.setName(chilElement.getAttribute("name"));
						String bl = chilElement.getAttribute("nullable");
						if(bl!=null&&!"".equals(bl)){
							if("true".equals(bl))
								specification.setNullable(Boolean.TRUE);
							else if("false".equals(bl)) {
								specification.setNullable(Boolean.FALSE);
							}
						}else{
							specification.setNullable(Boolean.TRUE);
						}
						String unique = chilElement.getAttribute("unique");
						if(unique!=null&&!"".equals(unique)){
							if("true".equals(unique))
								specification.setUnique(Boolean.TRUE);
							else if("false".equals(unique)) {
								specification.setUnique(Boolean.FALSE);
							}
						}else{
							specification.setUnique(Boolean.FALSE);
						}
						specification.setSeq(Integer.parseInt(chilElement.getAttribute("seq")));
						specification.setType(chilElement.getAttribute("type"));
						specification.setValue(chilElement.getAttribute("value"));
						specification.setWarringFormat(chilElement.getAttribute("warringFormat"));
						String className = chilElement.getAttribute("class");
						if(className!=null&&!"".equals(className)){
							specification.setClazz(Class.forName(className));
						}
						String propertyName = chilElement.getAttribute("property");
						if(propertyName!=null&&!"".equals(propertyName)){
							specification.setPropertyName(propertyName);
						}
						map.put(chilElement.getAttribute("name"), specification);
						e.addProperty(specification);
					}
					
				}
				e.setClassName(element.getAttribute("className"));
				e.setFileName(element.getAttribute("fileName"));
				//e.setFrom(Integer.parseInt(element.getAttribute("from")));
				//e.setHead(Integer.parseInt(element.getAttribute("head")));
				beansSpecification.addBean(e);
			}
			return beansSpecification;
		}
		/**
		 * 
		 * 以一个数组方式创建一个标题行　
		 * 
		 * @param row
		 * @param title
		 */
		public static void createTitleRow(HSSFWorkbook workbook,HSSFSheet sheet,
				BeanSpecification spf) {
			List<String> title = spf.getPropertyList();
			int length = title.size();
//			HSSFCellStyle style = workbook.createCellStyle();
			HSSFFont font = workbook.createFont();
			font.setColor(HSSFColor.BLUE.index);
			font.setFontHeightInPoints((short) 10);
			font.setBoldweight((short) 15);
			HSSFCellStyle cellStyle2 = workbook.createCellStyle();
	        HSSFDataFormat format = workbook.createDataFormat();
	        cellStyle2.setDataFormat(format.getFormat("@"));
//	        cell.setCellStyle(cellStyle2);
	        cellStyle2.setFont(font);
	        cellStyle2.setFillBackgroundColor(HSSFColor.YELLOW.index);
	        cellStyle2.setLocked(true);
			HSSFRow row = sheet.createRow(0);
			for (int i = 0; i < length; i++) {
				HSSFCell cell = row.createCell((short) i);
				String value = spf.getValueByName(title.get(i));
				cell.setCellValue(value);
				cell.setCellStyle(cellStyle2);
				sheet.setColumnWidth((short)i,(short) (value.length()*1000));
			}
		}

}
