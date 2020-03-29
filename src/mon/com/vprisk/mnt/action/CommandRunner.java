package com.vprisk.mnt.action;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import ch.ethz.ssh2.Connection;
import ch.ethz.ssh2.SCPClient;
import ch.ethz.ssh2.Session;
import ch.ethz.ssh2.StreamGobbler;


/**
 * Provides static methods for running SSH, scp as well as local commands.
 * 
 */
public class CommandRunner {

	private CommandRunner() {
	}

	/**
	 * Get remote file through scp
	 * 
	 * @param host
	 * @param username
	 * @param password
	 * @param remoteFile
	 * @param localDir
	 * @throws IOException
	 */
	public static void scpGet(String host, String username, String password,
			String remoteFile, String localDir) throws IOException {
		Connection conn = getOpenedConnection(host, username, password);
		SCPClient client = new SCPClient(conn);
		client.get(remoteFile, localDir);
		conn.close();
	}

	/**
	 * Put local file to remote machine.
	 * 
	 * @param host
	 * @param username
	 * @param password
	 * @param localFile
	 * @param remoteDir
	 * @throws IOException
	 */
	public static void scpPut(String host, String username, String password,
			String localFile, String remoteDir) throws IOException {
		Connection conn = getOpenedConnection(host, username, password);
		SCPClient client = new SCPClient(conn);
		client.put(localFile, remoteDir);
		conn.close();
	}

	/**
	 * Run SSH command.
	 * 
	 * @param host
	 * @param username
	 * @param password
	 * @param cmd
	 * @return exit status
	 * @throws IOException
	 */
	public static int runSSH(String host, String username, String password,
			String cmd) throws IOException {
		Connection conn = getOpenedConnection(host, username, password);
		Session sess = conn.openSession();
		sess.execCommand(cmd);
		InputStream stdout = new StreamGobbler(sess.getStdout());
		BufferedReader br = new BufferedReader(new InputStreamReader(stdout));
		while (true) {
			// attention: do not comment this block, or you will hit
			// NullPointerException
			// when you are trying to read exit status
			String line = br.readLine();
			if (line == null)
				break;
		}
		sess.close();
		conn.close();
		return sess.getExitStatus().intValue();
	}

	/**
	 * return a opened Connection
	 * 
	 * @param host
	 * @param username
	 * @param password
	 * @return
	 * @throws IOException
	 */
	public static Connection getOpenedConnection(String host, String username,
			String password) throws IOException {
		Connection conn = new Connection(host);
		conn.connect(); // make sure the connection is opened
		boolean isAuthenticated = conn.authenticateWithPassword(username,
				password);
		if (isAuthenticated == false)
			throw new IOException("Authentication failed.");
		return conn;
	}

	/**
	 * Run local command
	 * 
	 * @param cmd
	 * @return exit status
	 * @throws IOException
	 */
	public static boolean runLocal(String cmd) throws IOException {
		boolean flag = false;
		Runtime rt = Runtime.getRuntime();
		Process p = rt.exec(cmd);
		InputStream stdout = new StreamGobbler(p.getInputStream());
		BufferedReader br = new BufferedReader(new InputStreamReader(stdout));
		String str = "";
		str = br.readLine();
		while (str!=null) {
			if (str.indexOf("10238")>0){
				flag = true;
			}
		}
		return flag;
	}
	public static void closeConn(Connection conn,Session sess){
		if(conn!=null){
			conn.close();
		}
		if(sess!=null){
			sess.close();	
		}
	}
}
