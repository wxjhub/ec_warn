package com.vprisk.etl.service.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.beans.BeanUtils;
import com.vprisk.etl.dao.ServerDao;
import com.vprisk.etl.model.Server;
import com.vprisk.etl.service.ServerService;
import com.vprisk.rmplatform.dao.support.Page;

/**Program Name: ServerServiceImpl <br>
 * Description:  <br>
 * @author name: SUPER <br>
 * Written Date: 2012-10-18 <br>
 */
public class ServerServiceImpl implements ServerService {

	private ServerDao serverDao;
	/* (non-Javadoc)
	 * @see com.vprisk.etl.service.ServerService#findAllServers()
	 */
	public List<Server> findAllServers() {
		 List<Server> servers = serverDao.selectAllServers();
		return servers;
	}

	/* (non-Javadoc)
	 * @see com.vprisk.etl.service.ServerService#findServerByPage(java.util.Map, int, int, java.lang.String, java.lang.Boolean)
	 */
	public Page findServerByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc) {
		Page page = serverDao.selectServerByPage(params, pageNo, pageSize, orderBy, isAsc);
		return page;
	}
	
	/* (non-Javadoc)
	 * @see com.vprisk.etl.service.ServerService#findServerByServerId(java.lang.String)
	 */
	public Server findServerByServerId(String serverId) {
		Server server = serverDao.selectServerByServerId(serverId);
		return server;
	}
	

	public void saveServer(Server server) {
		this.serverDao.saveServer(server);
		
	}
	
	/**Methods Name: getServerDao <br>
	 * Description: <br>
	 * @return
	 */
	public ServerDao getServerDao() {
		return serverDao;
	}

	/**Methods Name: setServerDao <br>
	 * Description: <br>
	 * @param serverDao
	 */
	public void setServerDao(ServerDao serverDao) {
		this.serverDao = serverDao;
	}

	/* (non-Javadoc)
	 * @see com.vprisk.etl.service.ServerService#findServerCombobox(java.lang.String)
	 */
	public List<Server> findServerCombobox(String q) {
		if (q == null) {
			q = "";
		}
		//distinct s.serverType
		String hql = "from Server s where serverId like '%%" + q.trim() + "%%'";
		List<Server> serverList = serverDao.selectServer(hql, 1, 10);
		List<Server> serverListWarp = new ArrayList<Server>();
		if (serverList != null && serverList.size() > 0){
			for (Server serverl : serverList) {
				Server server = new Server();
				BeanUtils.copyProperties(serverl,server);
				serverListWarp.add(server);
			}
		}
		return serverListWarp;
	}

	/* (non-Javadoc)
	 * @see com.vprisk.etl.service.ServerService#removeServerById(java.lang.String)
	 */
	public void removeServerById(String uuid) {
		
		this.serverDao.deleteServerById(uuid);
	}
	/* (non-Javadoc)
	 * @see com.vprisk.etl.service.ServerService#findServerCountByServerId(java.lang.String)
	 */
	public int findServerCountByServerId(String serverId) {
		return serverDao.selectServerCountByServerId(serverId);
	}

	public void startCheckServer(String[] s) {
		serverDao.startCheckServer(s);
	}

	public void updateCheckServerStatus(String serverId) {
		serverDao.updateCheckServerStatus(serverId);
	}

	public Page checkServerByPage(String[] s, int pageNo, int pageSize) {
		
		Page page = serverDao.findCheckServerByPage(s,pageNo,pageSize);
		return page;
	}
	
}
