package com.sss.crm.workbench.service.impl;

import com.sss.crm.workbench.domain.TranRemark;
import com.sss.crm.workbench.mapper.TranRemarkMapper;
import com.sss.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class TranRemarkServiceImpl implements TranRemarkService {
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Override
    public List<TranRemark> queryTranRemarkByTranId(String id) {
        return tranRemarkMapper.selectTranRemarkByTranId(id);
    }

    @Override
    public int saveCreateTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.insertTranRemarkOne(tranRemark);
    }

    @Override
    public int deleteTranRemark(String id) {
        return tranRemarkMapper.deleteTranRemark(id);
    }

    @Override
    public int saveEditTranRemark(TranRemark tranRemark) {
        return tranRemarkMapper.updateTranRemark(tranRemark);
    }
}
