package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.TranHistory;

import java.util.List;

public interface TranHistoryService {
    List<TranHistory> queryTranHistoryByTranId(String id);
}
