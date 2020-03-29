package com.vprisk.etl.event;

import java.util.Map;
import java.util.Set;
import java.util.Map.Entry;

import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.MapMessage;
import javax.jms.Message;
import javax.jms.MessageProducer;
import javax.jms.Session;

import org.apache.log4j.Logger;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.JmsTemplate102;
import org.springframework.jms.core.MessageCreator;

import com.vprisk.common.Constants;
import com.vprisk.etl.entity.ETLContext;
import com.vprisk.etl.entity.MessageTask;
import com.vprisk.etl.model.Server;
import com.vprisk.etl.service.BatchService;
import com.vprisk.etl.service.BatchStatusService;
import com.vprisk.etl.service.SchedulerParamService;
import com.vprisk.etl.service.TaskStatusService;
import com.vprisk.etl.util.SessionPool;
import com.vprisk.rmplatform.context.ContextHolder;
import com.vprisk.rmplatform.dao.support.DynamicDataSourceContext;


/**
 * 消息发送器
 * @author wq
 *
 */
public class EventMessageSend {

	private JmsTemplate jmsTemplate;
	
	private SchedulerParamService paramService = (SchedulerParamService) ContextHolder.getBean("schedulerParamService");
	private TaskStatusService taskStatusService = (TaskStatusService) ContextHolder.getBean("taskStatusService");
	private BatchStatusService batchService = (BatchStatusService) ContextHolder.getBean("batchStatusService");
	Logger logger = Logger.getLogger(EventMessageSend.class);
	
	public void send(Server Server,MessageTask messageTask){
		Destination destination = DispenseDestination.getDestination(Server.getServerId().trim());
		logger.info("SERVERID is"+Server.getServerId()+"作业:"+messageTask.getJobId()+"任务组："+messageTask.getProcessId()+"任务:"+messageTask.getTaskId());
		final Set<Entry<String, String>> set =MessageConvert.toMessage(messageTask);
		try{
			jmsTemplate.send(destination, new MessageCreator() {
				public Message createMessage(Session session) throws JMSException {
					MapMessage message = session.createMapMessage();
					for(Map.Entry entry : set){
						if(entry.getKey()!=null&&entry.getValue()!=null){
							message.setStringProperty(entry.getKey().toString(), entry.getValue().toString());
						}
						
					}
					return message;
				}
			});
		}catch (Exception e) {
			String type = messageTask.getMessageType();
			if(type.equals(ETLContext.MANAGEMENT_PARAM)){
				String paramId = messageTask.getTaskId();
				String jobId = messageTask.getJobId();
				DynamicDataSourceContext.putSp(Constants.RPM);
				paramService.saveSchedulerParamError(paramId,jobId,"mq连接不上");
				DynamicDataSourceContext.clear();
			}else if(type.equals(ETLContext.MANAGEMENT_SCHEDULER)){
				String taskId = messageTask.getTaskId();
				String jobId = messageTask.getJobId();
				String processId = messageTask.getProcessId();
				DynamicDataSourceContext.putSp(Constants.RPM);
				taskStatusService.saveTaskStatusError(taskId,jobId,processId,"mq连接不上");
				DynamicDataSourceContext.clear();
			}
//			DynamicDataSourceContext.putSp(Constants.RPM);
//			batchService.saveBatchRunStatus(messageTask.getJobId(),"-1");
//			DynamicDataSourceContext.clear();
		}
		
//		SessionPool pool = SessionPool.getSessionPool();
//		Session session = pool.getSession();
//		
//		System.out.println("++++++++++++++++++++++++++++++++++++++++++++++++++"+Server.getServerName());
//		try {
//			MessageProducer producer = session.createProducer(destination);
//			MapMessage message = session.createMapMessage();
//			for(Map.Entry entry : set){
//				if(entry.getKey()!=null&&entry.getValue()!=null){
//					message.setStringProperty(entry.getKey().toString(), entry.getValue().toString());
//				}
//			}

//			producer.send(message);
//			session.commit();
//			pool.closeSession(session);
//		} catch (JMSException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}

//		});
		
	}
	
	public JmsTemplate getJmsTemplate() {
		return jmsTemplate;
	}


	public void setJmsTemplate(JmsTemplate jmsTemplate) {
		this.jmsTemplate = jmsTemplate;
	}


	
	
}
