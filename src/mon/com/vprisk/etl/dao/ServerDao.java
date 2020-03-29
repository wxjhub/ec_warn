package com.vprisk.etl.dao;

import java.util.List;
import java.util.Map;

import com.vprisk.etl.model.Server;
import com.vprisk.rmplatform.dao.support.Page;

/**Program Name: ServerDao <br>
 * Description:  <br>
 * @author name: SUPER <br>
 * Written Date: 2012-10-18 <br>
 */
public interface ServerDao {
	/**
	 * Methods Name: selectAllServers <br>
	 * Description: <br>
	 * @return
	 */
	List<Server> selectAllServers();
	/**
	 * Methods Name: selectServerByPage <br>
	 * Description: <br>
	 * @param params
	 * @param pageNo
	 * @param pageSize
	 * @param orderBy
	 * @param isAsc
	 * @return
	 */
	Page selectServerByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	/**
	 * Methods Name: selectServerByServerId <br>
	 * Description: <br>
	 * @param serverId
	 * @return
	 */
	Server selectServerByServerId(String serverId);
	/**
	 * Methods Name: saveServer <br>
	 * Description: <br>
	 * @param server
	 */
	void saveServer(Server server);
	/**
	 * Methods Name: selectServer <br>
	 * Description: <br>
	 * @param hql
	 * @param page
	 * @param rows
	 * @param param
	 * @return
	 */
	public List<Server> selectServer(String hql, int page, int rows, Object... param);
	/**
	 * Methods Name: deleteServerById <br>
	 * Description: <br>
	 * @param uuid
	 */
	void deleteServerById(String uuid);
	/**
	 * Methods Name: selectServerCountByServerId <br>
	 * Description: <br>
	 * @param serverId
	 * @return
	 */
	int selectServerCountByServerId(String serverId);
	List<Server> find(String hql, List<Object> values, Integer page, Integer rows);
	Long count(String hql, List<Object> param);
	void startCheckServer(String[] s);
	void updateCheckServerStatus(String serverId);
	Page findCheckServerByPage(String[] s, int pageNo, int pageSize);
}
