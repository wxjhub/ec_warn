package com.vprisk.mnt.sms;

import java.util.Date;
import java.util.Map;

import com.ibm.icu.text.SimpleDateFormat;
import com.vprisk.mnt.sms.entity.Accountinfo;
import com.vprisk.mnt.sms.entity.Userinfo;
import com.vprisk.mnt.sms.service.AccountinfoService;
import com.vprisk.mnt.sms.service.UserinfoService;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.util.StringUtil;

/**
 * @Name: 短信发送工具类
 * @Description: 
 * @Author: sam wang
 * @Version: 
 * @CreateDate: 2017年4月13日
 */
public class MessageUtils {
	private static AccountinfoService accountinfoService = (AccountinfoService)ContextHolder.getBean("accountinfoService");
	private static UserinfoService userinfoService = (UserinfoService)ContextHolder.getBean("userinfoService");
	/**
	 * @Name: 发送回退短信
	 * @Description: 执行任务回退时，发送提醒短信给指定柜员
	 * @Author: sam wang
	 * @Version: 
	 * @CreateDate: 2017年4月13日 
	 * @Parameters: userName 柜员号
	 * @Return:
	 */
	public static void sendMessageWhenTaskBack(String userName, Map<String, Object> param) {
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy年MM月dd日 HH:mm");
		String datestr = sdf1.format(new Date());
		//定价单号
		String businessId = (String) param.get("businessId");
		//客户名称
		String custName = (String) param.get("custName");
		//组织短信内容
		String content = "【产品定价管理系统】"+ datestr +"您的利率审核业务（客户名称：" + custName + "，定价单：" + businessId + "）已被回退，请及时处理。";
		//发送短信
		sendMessage(userName, content);
	}
	
	/**
	 * @Name: 发送审核完成短信
	 * @Description: 执行任务审核完成时，发送提醒短信给指定柜员
	 * @Author: sam wang
	 * @Version: 
	 * @CreateDate: 2017年4月13日 
	 * @Parameters: userName 柜员号
	 * @Return:
	 */
	public static void sendMessageWhenApprovalComplete(String userName, Map<String, Object> param) {
		SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy年MM月dd日 HH:mm");
		String datestr = sdf1.format(new Date());
		//定价单号
		String businessId = (String) param.get("businessId");
		//客户名称
		String custName = (String) param.get("custName");
		//组织短信内容
		String content = "【产品定价管理系统】"+ datestr +"您的利率审核业务（客户名称：" + custName + "，定价单：" + businessId + "）已审核完成。";
		//发送短信
		sendMessage(userName, content);
	}
	
	public static void sendMessageToPerationPerson(Map<String, Object> params) {
		//发送短信内容
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy年MM月dd日");
		String dateStr = sdf.format(new Date());
		String content = "【"+dateStr+"】【产品定价管理系统】推送失败的业务，请及时处理^_^";
		//发送人姓名
		String remindPeople = (String) params.get("remindPeopleName");
		//发送人
		String telephone = (String) params.get("telephone");
		
		//创建短信实体
		Userinfo userinfo = new Userinfo();
		userinfo.setPhoneNumber(telephone);
		userinfo.setContent(content);
		userinfo.setStatus("0");
		userinfo.setUserName(remindPeople);
		userinfoService.saveOrUpdateUserinfo(userinfo);	
	}
	
	/**
	 * @Name: 发送短信
	 * @Description: 
	 * @Author: sam wang
	 * @Version: 
	 * @CreateDate: 2017年4月13日 
	 * @Parameters: userName：柜员号 content：短信主体
	 * @Return:
	 */
	private static void sendMessage(String userName, String content) {
		//获取柜员手机号
		Accountinfo account = accountinfoService.findAccountinfoByUserNumber(userName);
		if(StringUtil.isNotNullOrEmpty(account)) {
			//创建短信实体
			Userinfo userinfo = new Userinfo();
			userinfo.setPhoneNumber(account.getPhoneNumber());
			userinfo.setContent(content);
			userinfo.setStatus("0");
			userinfo.setUserName(account.getUserName());
			userinfoService.saveOrUpdateUserinfo(userinfo);	
		}
	}
}
