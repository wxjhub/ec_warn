package com.vprisk.mnt.base;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.boco.vas.msplatform.api.partner.CMSShortAPILoginInformation;
import com.boco.vas.msplatform.api.partner.CMSShortConnectionAPI;
import com.boco.vas.msplatform.api.partner.command.CMSCommandContext;
import com.boco.vas.msplatform.api.partner.command.CMSMTMessage;
import com.boco.vas.msplatform.api.partner.command.CMSMTMessageRet;
import com.boco.vas.msplatform.api.partner.command.CMSShortMessage;
import com.boco.vas.msplatform.common.CMSLongConnectionAPIErrorInfo;
import com.vprisk.mnt.entity.BookParam;
import com.vprisk.mnt.sms.CommonUtils;


public class SMSSendForApiAction{

	CMSShortConnectionAPI pApi;
	private static Log log = LogFactory.getLog(SMSSendForApiAction.class);
	public void sendInfo(String smsBean,BookParam add) {
		log.info("进入对接短信发送逻辑");
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
		
		
		log.info("mt消息的基本属性");
		// mt消息的基本属性
		CMSMTMessage MessageProperty = new CMSMTMessage();
		MessageProperty.strDesMsisdn = add.getBookTele();
		MessageProperty.strBusinessCode = CommonUtils.getProp("SMSSend.BusinessCode");
		MessageProperty.strFeeMsisdn = add.getBookTele();
		MessageProperty.strLinkId = "LinkId";
		MessageProperty.bMediaType = 1;
		MessageProperty.strLongCode = "";
		MessageProperty.strServiceCode = "";

		// 命令的上下文
		CMSCommandContext context = new CMSCommandContext();
		// 代理号，一般代理号与接入号一致
		context.iProxyClientId = Integer.parseInt(CommonUtils.getProp("SMSSend.IClientId"));
		// 调用查询黑名单命令的超时时间
		context.sSecondsOfTimeout = 20;
		MessageProperty.setContext(context);

		// 短消息
		log.info("短消息");
		CMSShortMessage objShortMessage = new CMSShortMessage();
		objShortMessage.bContentType = 15;
		objShortMessage.bPKNumber = 1;
		objShortMessage.bPKTotal = 1;
		objShortMessage.bTpPid = 0;
		objShortMessage.bTpUdhi = 0;
		objShortMessage.bLongSMS = 1;
		objShortMessage.strContent = smsBean;
		// 发送短消息
		log.info("发送短消息"+MessageProperty+objShortMessage);
		CMSMTMessageRet messageRet = pApi.MSSendShortMessage(MessageProperty, objShortMessage);
		log.info("发送短信代码"+messageRet.iResult);
		log.info("发送短信返回结果"+messageRet.getIResult());
		if (messageRet.iResult == CMSLongConnectionAPIErrorInfo.CMSLONGCONNECTIONAPI_DISPOSE_SUCCEED) {
			// MT消息已经被成功的发送到了消息服务平台
			System.out.println("发送到:" + MessageProperty.getStrDesMsisdn() + "的消息已经被成功发送!!MessageId:" + messageRet.strMessageId);
		} else {
			System.out.println("发送到:" + MessageProperty.getStrDesMsisdn() + "的消息，在发送过程中出现错误，错误代码是：" + messageRet.getIResult() + " 错误信息是："
					+ messageRet.getStrErrorDescription());
		}
	}
}
