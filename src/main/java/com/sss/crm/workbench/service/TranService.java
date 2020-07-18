package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.FunnelVo;
import com.sss.crm.workbench.domain.Tran;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TranService {

    List<Tran> queryTranForPageByCondition(Map<String,Object> map);

    long queryCountForPageByCondition(Map<String,Object> map);

    void saveCreateTran(HashMap<String, Object> map);

    Tran queryTranDetailById(String id);

    void saveupdateTranIco(Map<String, Object> map);

    List<FunnelVo> queryCountOfTranGroupByStage();

}
