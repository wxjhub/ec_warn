package com.vprisk.mnt.sms;

import com.boco.vas.msplatform.api.partner.CMSShortAPILoginInformation;
import com.boco.vas.msplatform.api.partner.CMSShortConnectionAPI;
import com.boco.vas.msplatform.api.partner.command.CMSCommandContext;
import com.boco.vas.msplatform.api.partner.command.CMSMTMessage;
import com.boco.vas.msplatform.api.partner.command.CMSMTMessageRet;
import com.boco.vas.msplatform.api.partner.command.CMSShortMessage;
import com.boco.vas.msplatform.common.CMSLongConnectionAPIErrorInfo;
import com.vprisk.mnt.sms.entity.Userinfo;

public class SMSSendForApiAction{

	CMSShortConnectionAPI pApi;

	public void sendInfo(String smsBean,Userinfo user) {
		// 短连接API配置参数
		CMSShortAPILoginInformation objStartParameter = new CMSShortAPILoginInformation();
		// 客户端id
		objStartParameter.setIClientId(Integer.parseInt(CommonUtils.getProp("SMSSend.IClientId")));
		// 客户端密码
		objStartParameter.setStrPassword(CommonUtils.getProp("SMSSend.StrPassword"));
		// 本地绑定的IP地址
		objStartParameter.setStrLocalIP(CommonUtils.getProp("SMSSend.StrLocalIP"));
		// 服务端的端口号
		objStartParameter.setIServerPort(Integer.parseInt(CommonUtils.getProp("SMSSend.IServerPort")));
		// 服务端的ip地址
		objStartParameter.setStrServerIP(CommonUtils.getProp("SMSSend.StrServerIP"));//生产
		pApi = new CMSShortConnectionAPI(objStartParameter);
		
		

		// mt消息的基本属性
		CMSMTMessage messageProperty = new CMSMTMessage();
			messageProperty.strDesMsisdn = user.getPhoneNumber();
			System.out.println(user.getPhoneNumber());
			messageProperty.strBusinessCode = CommonUtils.getProp("SMSSend.BusinessCode");
			messageProperty.strFeeMsisdn = user.getPhoneNumber();
			messageProperty.strLinkId = null;
			messageProperty.bMediaType = 1;
			messageProperty.strLongCode = null;
			messageProperty.strServiceCode = null;
		

		// 命令的上下文
		CMSCommandContext context = new CMSCommandContext();
		// 代理号，一般代理号与接入号一致
		context.iProxyClientId = Integer.parseInt(CommonUtils.getProp("SMSSend.IClientId"));;
		// 调用查询黑名单命令的超时时间
		context.sSecondsOfTimeout = 20;
		messageProperty.setContext(context);

		// 短消息
		CMSShortMessage objShortMessage = new CMSShortMessage();
		objShortMessage.bContentType = 15;
		objShortMessage.bPKNumber = 1;
		objShortMessage.bPKTotal = 1;
		objShortMessage.bTpPid = 0;
		objShortMessage.bTpUdhi = 0;
		objShortMessage.bLongSMS = 1;
		objShortMessage.strContent = smsBean;
		// 发送短消息
		CMSMTMessageRet messageRet = pApi.MSSendShortMessage(messageProperty, objShortMessage);
		if (messageRet.iResult == CMSLongConnectionAPIErrorInfo.CMSLONGCONNECTIONAPI_DISPOSE_SUCCEED) {
			// MT消息已经被成功的发送到了消息服务平台
			System.out.println("发送到:" + messageProperty.getStrDesMsisdn() + "的消息已经被成功发送!!MessageId:" + messageRet.strMessageId);
		} else {
			System.out.println("发送到:" + messageProperty.getStrDesMsisdn() + "的消息，在发送过程中出现错误，错误代码是：" + messageRet.getIResult() + " 错误信息是："
					+ messageRet.getStrErrorDescription());
		}
	}
}
