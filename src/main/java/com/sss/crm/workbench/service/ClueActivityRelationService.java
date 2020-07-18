package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationService {

    int saveCreateClueActivityRelation(List<ClueActivityRelation> clueActivityRelationList);

    int deleteClueActivityRelationByAC(ClueActivityRelation clueActivityRelation);
}
