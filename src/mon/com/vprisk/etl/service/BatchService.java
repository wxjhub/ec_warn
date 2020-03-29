package com.vprisk.etl.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.vprisk.etl.model.Batch;
import com.vprisk.rmplatform.dao.support.Page;
import com.vprisk.rmplatform.exception.ServiceException;

public interface BatchService {
	/**
	 * 分页查询所有批次
	 * @param params
	 * @param pageNo
	 * @param pageSize
	 * @param orderBy
	 * @param isAsc
	 * @return
	 */
	Page findBatchByPage(Map params, int pageNo, int pageSize, String orderBy, Boolean isAsc);
	
	public Batch findBatchByBatchId(String batchId);
	
	/**
	 * 
	 * @param task
	 * @return
	 * @throws ServiceException
	 */
	public Batch saveBatch(Batch batch) throws ServiceException;
	
	/**
	 * 
	 * @param uuid
	 */
	public void removeBatchById(String uuid);
	
	public void removeBatchByIds(String[] uuids);

	List<Batch> findAllBatch();

	Batch findBatchById(String uuid);

	List<Batch> findRuningBatch();
	/**
	 * 10.28 根据 当前批次修改状态标志位
	 * @param batch
	 * @param string
	 */
	void modifyBatchRunFlag(Batch batch, String string);

	List<Batch> findBatchByBatchId();

	void saveBatchRunStatus(String batchId, String string);
	
	void saveupdateBatchendDate(String batchId, Date endDate);

}
