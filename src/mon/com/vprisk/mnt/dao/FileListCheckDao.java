package com.vprisk.mnt.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.vprisk.mnt.entity.FileListCheck;
import com.vprisk.rmplatform.dao.support.Page;
/**
 * 关联系统List文件Dao层实现接口类
 */
public interface FileListCheckDao {
	/**
	 * 分页查询参数信息
	 * @param params 分页传递参数信息集合
	 * @param pageNo 页码
	 * @param pageSize 页行数
	 * @param orderBy 排序的属性
	 * @param isAsc 排序方式
	 * @return 分页信息
	 */
	@SuppressWarnings("unchecked")
	Page selectParameterCollectiondByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	/**
	 * 查询关联系统List相关信息
	 * @return 返回关联系统List相关信息集合
	 */
	List<FileListCheck> selectFileListCheck();
	/**
	 * 根据系统号更新关联系统LIST文件的数量
	 * @param string  系统号
	 * @param num 文件数
	 * @param asOfDate 数据日期
	 * @return 返回更新成功的boolean值
	 */
	boolean updateFileListCheckByListNum(String string, int num, Date asOfDate);
	/**
	 * 根据系统号更新关联系统LIST文件的发送文件数量
	 * @param soursesysName 系统号
	 * @param num 文件数
	 */
	void updateFileListCheckByListSendNum(String soursesysName, int num,int factNum);
	void updateFileListCheckByListSendNum2(String soursesysName, int num,int factNum, Date asOfDate);
	int selectListNum(String soursesysName);
	int  selectListNumSend(String soursesysName);
	int  selectListSendNum(String soursesysName);
	int  selectFactFileRecNum(String soursesysName);
}
