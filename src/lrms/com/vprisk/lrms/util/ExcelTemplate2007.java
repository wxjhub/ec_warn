package com.vprisk.lrms.util;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.List;

import com.vprisk.lrms.excel.ExcelTemplate;

public class ExcelTemplate2007 implements ExcelTemplate{

	public List inputExcel(Class<?> clazz, InputStream inputStream,List<String> errors)
			throws SecurityException, NoSuchMethodException,
			IllegalArgumentException, InstantiationException,
			IllegalAccessException, InvocationTargetException, ParseException {
		
		return null;
	}

	public ByteArrayOutputStream createFixationSheet(List<?> list,
			Class<?> clazz) {
		// TODO Auto-generated method stub
		return null;
	}

}
