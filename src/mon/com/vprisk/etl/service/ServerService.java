package com.vprisk.etl.service;

import java.util.List;
import java.util.Map;

import com.vprisk.etl.model.Server;
import com.vprisk.rmplatform.dao.support.Page;

/**Program Name: ServerService <br>
 * Description:  <br>
 * @author name: SUPER <br>
 * Written Date: 2012-10-18 <br>
 */
public interface ServerService {
	/**
	 * Methods Name: findAllServers <br>
	 * Description: <br>
	 * @return
	 */
	List<Server> findAllServers();
	
	/**
	 * Methods Name: findServerByPage <br>
	 * Description: <br>
	 * @param params
	 * @param pageNo
	 * @param pageSize
	 * @param orderBy
	 * @param isAsc
	 * @return
	 */
	Page findServerByPage(Map params, int pageNo, int pageSize,String orderBy, Boolean isAsc);
	/**
	 * Methods Name: findServerByServerId <br>
	 * Description: <br>
	 * @param serverId
	 * @return
	 */
	Server findServerByServerId(String serverId);
	
	/**
	 * Methods Name: saveServer <br>
	 * Description: <br>
	 * @param server
	 */
	void saveServer(Server server);
	/**
	 * Methods Name: findServerCombobox <br>
	 * Description: <br>
	 * @param q
	 * @return
	 */
	List<Server> findServerCombobox(String q);
	/**
	 * Methods Name: removeServerById <br>
	 * Description: <br>
	 * @param uuid
	 */
	void removeServerById(String uuid);
	/**
	 * Methods Name: findServerCountByServerId <br>
	 * Description: <br>
	 * @param serverId
	 * @return
	 */
	int findServerCountByServerId(String serverId);

	void startCheckServer(String[] s);

	void updateCheckServerStatus(String serverId);

	Page checkServerByPage(String[] s, int pageNo, int pageSize);
	
}
