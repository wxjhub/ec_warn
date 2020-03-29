package com.vprisk.mnt.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.vprisk.mnt.entity.FileConfig;
import com.vprisk.mnt.service.FileConfigService;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.entity.BeanUtil;
import com.vprisk.rmplatform.web.action.BaseAction;

/**
 * 文件传输预警配置action类
 * 
 * @author
 */
public class FileConfigAction extends BaseAction {

	private static final long serialVersionUID = 1L;
	private FileConfigService fileConfigService = (FileConfigService) super.getBean("fileConfigService");

	@SuppressWarnings("unchecked")
	public void fileTranWarnList() {
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
		Page page = this.fileConfigService.selectParameterCollectiondByPage(
				params, pageNo, pageSize, orderBy, isAsc);
		JSONObject resultObj = new JSONObject();
		resultObj.put("total", page.getTotalCount());
		resultObj.put("rows", JSONArray.fromObject(page.getData()).toString());
		PrintWriter pw;
		try {
			pw = super.getHttpResponse().getWriter();
			pw.print(resultObj);
			pw.flush();
			pw.close();
		} catch (IOException e) {
			// 出现异常把异常信息，写进日志信息
			logger.error("文件传输预警异常" + e.getMessage());
		}

	}

	/**
	 * 根据id删除条目
	 */
	public void remove() {
		HttpServletRequest request = super.getHttpRequest();
		String uuids = request.getParameter("uuids");
		this.fileConfigService.removeParameterCollectionByuuid(uuids);
	}

	/**
	 * 保存信息
	 * 
	 * @author
	 * @return 无返回值
	 */
	public String save() {
		FileConfig detail = (FileConfig) BeanUtil.getObject(getHttpRequest(),FileConfig.class);
		// 通过request方法获取页面传递的参数
		try {
			PrintWriter pw = super.getHttpResponse().getWriter();
			// 调用根据对象参数信息，对于信息新增修改时是否存在重复数据
			List<FileConfig> list = fileConfigService.findParameterCollection(detail);
			if (list.size() < 1) {// 判断是修改
				boolean flag = fileConfigService.saveOrUpdateCash(detail);// 保存，调用修改的方法
				if (flag) {
					pw.print(1);
				} else {
					pw.print(3);
				}
			} else {
				pw.print(2);
			}
			pw.flush();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
			// 出现异常把异常信息，写进日志信息
			logger.debug(e.getMessage());
		}
		return null;
	}

}
