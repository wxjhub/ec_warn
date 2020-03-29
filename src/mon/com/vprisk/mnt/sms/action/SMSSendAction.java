package com.vprisk.mnt.sms.action;

import java.util.List;

import com.vprisk.mnt.sms.SMSSendForApiAction;
import com.vprisk.mnt.sms.entity.Userinfo;
import com.vprisk.mnt.sms.service.UserinfoService;
import com.vprisk.rmplatform.util.StringUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

public class SMSSendAction extends BaseAction{
	private static final long serialVersionUID = 1L;
	private UserinfoService userinfoService = (UserinfoService) super.getBean("userinfoService");
	public void serviceServerAuto(){
		try {
			//声明创建短信对象
			SMSSendForApiAction smfa = new SMSSendForApiAction();
			List<Userinfo> userinfos = userinfoService.findUserinfoByStatus("0");
			if(StringUtil.isNotNullOrEmpty(userinfos)){
				for(Userinfo userinfo:userinfos){
					//调用发送短信的方法
					smfa.sendInfo(userinfo.getContent(), userinfo);
					userinfo.setStatus("1");
					userinfoService.saveOrUpdateUserinfo(userinfo);	
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public static void main(String[] args) {
		SMSSendAction sa = new SMSSendAction();
		sa.serviceServerAuto();
	}
}
