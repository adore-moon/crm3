package com.sss.crm.settings.service.impl;

import com.sss.crm.settings.domain.DicValue;
import com.sss.crm.settings.mapper.DicValueMapper;
import com.sss.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;
    @Override
    public List<DicValue> selectDicValueByAll() {
        return dicValueMapper.selectDicValueAll();
    }

    @Override
    public DicValue selectDicValueByTypeCodeAndValue(DicValue dicValue) {
        return dicValueMapper.selectDicValueByTypeCodeAndValue(dicValue);
    }

    @Override
    public int saveCreateDicValue(DicValue dicValue) {
        return dicValueMapper.insertDicValue(dicValue);
    }

    @Override
    public DicValue selectDicValueById(String id) {
        return dicValueMapper.selectDicValueById(id);
    }

    @Override
    public int saveEditDicValue(DicValue dicValue) {
        return dicValueMapper.updateDicValue(dicValue);
    }

    @Override
    public int deleteDicValueByIds(String[] id) {
        return dicValueMapper.deleteDicValueByIds(id);
    }

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }
}
