package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkService {

    List<TranRemark> queryTranRemarkByTranId(String id);

    int saveCreateTranRemark(TranRemark tranRemark);

    int deleteTranRemark(String id);

    int saveEditTranRemark(TranRemark tranRemark);
}
