package com.sss.crm.settings.service;

import com.sss.crm.settings.domain.DicValue;

import java.util.List;

public interface DicValueService {

    List<DicValue> selectDicValueByAll();

    DicValue selectDicValueByTypeCodeAndValue(DicValue dicValue);

    int saveCreateDicValue(DicValue dicValue);

    DicValue selectDicValueById(String id);

    int saveEditDicValue(DicValue dicValue);

    int deleteDicValueByIds(String[] id);

    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
