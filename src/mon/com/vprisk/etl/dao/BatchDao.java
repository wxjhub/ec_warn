package com.vprisk.etl.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.vprisk.etl.model.Batch;
import com.vprisk.rmplatform.dao.support.Page;

public interface BatchDao {

	Page selectBatchByPage(Map params, int pageNo, int pageSize,
			String orderBy, Boolean isAsc);
	
	Batch selectBatchByBatchId(String batchId);
	
	Batch insertOrUpdateBatch(Batch batch);
	
	void deleteBatchById(String uuid);
	
	void deleteBatchByIds(String[] uuids);

	List<Batch> selectAllBatch();

	Batch selectBatchById(String uuid);

	List<Batch> selectRuningBatch();
	
	Batch selectBatchByUuid(String uuid);

	List<Batch> selectTaskByTaskId();

	void updateBatchRunStatus(String batchId, String runStatus);
	
	void updateBatchendDate(String batchId, Date endDate );

}
