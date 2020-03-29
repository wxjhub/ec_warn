package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import com.vprisk.mnt.entity.BtnSuccess;
import com.vprisk.mnt.entity.BtnSuccessConfig;
import com.vprisk.mnt.service.BtnSucessConfigService;
import com.vprisk.mnt.service.BtnTranStranSucessService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.web.action.BaseAction;

public class BtnTranStranSucssAction extends BaseAction{
	private static final long serialVersionUID = 1L;
	private BtnTranStranSucessService btnTranStranSucessService = (BtnTranStranSucessService)super.getBean("btnTranStranSucessService");
	private BtnSucessConfigService btnSucessConfigService = (BtnSucessConfigService)super.getBean("btnSucessConfigService");
	public String findBtnTranStranSucssList() {
		HttpServletRequest request = super.getHttpRequest();
		int pageSize = Integer.parseInt(request.getParameter("rows"));// 获取页行数
		int pageNo = Integer.parseInt(request.getParameter("page"));// 获取页码
		String order = request.getParameter("order");// 排序方式：asc or desc
		String orderBy = request.getParameter("sort");// 按哪个属性排序：order prop
		Boolean isAsc = null;
		if (order != null) {// 判断排序方式
			isAsc = order.equalsIgnoreCase("asc") ? true : false;
		}
		Map params = super.getRequestParams();// 获取页面传过来的参数

		// 调用按照分页查询信息的方法
		Page page = this.btnTranStranSucessService.selectParameterCollectiondByPage(
				params, pageNo, pageSize, orderBy, isAsc);

		JSONObject resultObj = new JSONObject();
		resultObj.put("rows", JSONArray.fromObject(page.getData()));
		resultObj.put("total", page.getTotalCount());
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			// 出现异常把异常信息，写进日志信息
			logger.error("应用程序查询异常" + e.getMessage());
		}
		return null;
	}
	
	//定时任务
	public void btnTranStranSucss() {
		try {
			List<BtnSuccessConfig> btnTimeList =  btnSucessConfigService.findBtnTime();
		    for (BtnSuccessConfig btnSuccessConfig :btnTimeList) {
			   Date date = new Date();
			   SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			   Calendar cal = Calendar.getInstance();
			   SimpleDateFormat sdfsave = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			   String resultdate = sdf.format(date);
			   BigDecimal onehanrode = new BigDecimal("100");
			   List<Map<String, String>> btnList = btnTranStranSucessService.queryBtnSuccess(btnSuccessConfig.getBtnTime(),resultdate);
			   if(btnList!=null && btnList.size()>0) {
				   for(Map<String, String> map:btnList) {
						 String  methodRealName = map.get("methodRealName");
						 String  methodPath = map.get("methodPath");
						 String  count = map.get("count");
						 String  isor = map.get("isor");
						 BigDecimal allcount = new BigDecimal(count);
						 BigDecimal success = new BigDecimal(isor);
//						 BigDecimal rate= success.divide(allcount).setScale(2, BigDecimal.ROUND_HALF_UP);
						 BigDecimal rate= success.divide(allcount,2,RoundingMode.HALF_UP);
						 BtnSuccess btnsucc = new BtnSuccess();
						 btnsucc.setAllCount(allcount.intValue());
						 btnsucc.setSuccCount(success.intValue());
						 btnsucc.setBtnName(methodRealName);
						 btnsucc.setBtnPath(methodPath);
						 btnsucc.setLocalSystem(btnSuccessConfig.getSystemCode());
						 btnsucc.setRate(String.valueOf(rate.multiply(onehanrode)));
						 btnsucc.setRecordDate(sdfsave.format(cal.getTime()));
						 btnTranStranSucessService.saveOrUpdateCash(btnsucc);
				  } 
			   }
			}
		} catch (Exception e) {
			e.printStackTrace();
			// 出现异常把异常信息，写进日志信息
			logger.debug(e.getMessage());
		}
	}
}
