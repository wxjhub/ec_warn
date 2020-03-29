package com.vprisk.lrms.excel;

import com.vprisk.lrms.util.ExcelTemplate2003;
import com.vprisk.lrms.util.ExcelTemplate2007;



public class ExcelTemplateFactory {
	public static final int TYPE_EXCEL2003 = 1;
	public static final int TYPE_EXCEL2007 = 2;
	private static ExcelTemplateFactory INSTANCE = null;

	private ExcelTemplateFactory()
	{
	}

	public static ExcelTemplateFactory instance()
	{
		if (INSTANCE == null)
			INSTANCE = new ExcelTemplateFactory();
		return INSTANCE;
	}

	public ExcelTemplate createExcelTemplate(int excelType)
	{
		switch (excelType)
		{
		case 1: // '\001'
			return new ExcelTemplate2003();

		case 2: // '\002'
			return new ExcelTemplate2007();
		}
		return new ExcelTemplate2003();
	}

	public int getExcelType(String filepath)
	{
		String suffix = filepath.substring(filepath.lastIndexOf("."));
		if (".xls".equals(suffix.toLowerCase()))
			return 1;
		if (".xlsx".equals(suffix.toLowerCase()))
			return 2;
		else
			throw new RuntimeException();
	}

}
