package com.vprisk.lrms.excel;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.List;

public interface ExcelTemplate {
	public ByteArrayOutputStream createFixationSheet(List<?> list,
			Class<?> clazz);
	public  List inputExcel(Class<?> clazz, InputStream inputStream,List<String> errors) throws SecurityException, NoSuchMethodException,
	IllegalArgumentException, InstantiationException,
	IllegalAccessException, InvocationTargetException, ParseException, NoSuchFieldException;
}
