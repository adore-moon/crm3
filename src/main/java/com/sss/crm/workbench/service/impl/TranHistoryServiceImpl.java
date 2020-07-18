package com.sss.crm.workbench.service.impl;

import com.sss.crm.workbench.domain.TranHistory;
import com.sss.crm.workbench.mapper.TranHistoryMapper;
import com.sss.crm.workbench.service.TranHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class TranHistoryServiceImpl implements TranHistoryService {
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Override
    public List<TranHistory> queryTranHistoryByTranId(String id) {
        return tranHistoryMapper.selectTranHistoryByTranId(id);
    }
}
