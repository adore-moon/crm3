package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkService {

    List<ClueRemark> queryClueRemarkByClueId(String clueId);

    int saveCreateClueRemark(ClueRemark clueRemark);

    int saveEditClueRemark(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);
}
