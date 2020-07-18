package com.sss.crm.settings.service;

import com.sss.crm.settings.domain.DicType;
import com.sss.crm.settings.domain.DicValue;

import java.util.List;

public interface DicTypeService {

    List<DicType> selectDicType();

    DicType selectDicTypeByCode(String code);

    int saveCreateDicType(DicType dicType);

    int saveEditDicType(DicType dicType);

    int deleteDicTypeByCodes(String[] code);

 }
