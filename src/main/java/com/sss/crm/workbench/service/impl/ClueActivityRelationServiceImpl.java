package com.sss.crm.workbench.service.impl;

import com.sss.crm.workbench.domain.ClueActivityRelation;
import com.sss.crm.workbench.mapper.ClueActivityRelationMapper;
import com.sss.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Override
    public int saveCreateClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList) {
        return clueActivityRelationMapper.insertClueActivityRelation(clueActivityRelationList);
    }

    @Override
    public int deleteClueActivityRelationByAC(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByAC(clueActivityRelation);
    }
}
