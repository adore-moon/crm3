package com.sss.crm.settings.service.impl;

import com.sss.crm.settings.domain.DicType;
import com.sss.crm.settings.mapper.DicTypeMapper;
import com.sss.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    private DicTypeMapper dicTypeMapper;
    @Override
    public List<DicType> selectDicType() {
        return dicTypeMapper.selectDicType();
    }

    @Override
    public DicType selectDicTypeByCode(String code) {
        return dicTypeMapper.selectDicTypeByCode(code);
    }

    @Override
    public int saveCreateDicType(DicType dicType) {
        return dicTypeMapper.insertDicType(dicType);
    }

    @Override
    public int saveEditDicType(DicType dicType) {
        return dicTypeMapper.updateDicType(dicType);
    }

    @Override
    public int deleteDicTypeByCodes(String[] code) {
        return dicTypeMapper.deleteDicTypeByCodes(code);
    }
}
