package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueService {

    List<Clue> queryClueForPageByCondition(Map<String,Object> map);

    long queryCountForPageByCondition(Map<String,Object> map);

    int saveCreateClue(Clue clue);

    int deleteClueByIds(String[] id);

    Clue queryClueById(String id);

    int saveEditClue(Clue clue);

    Clue queryClueDetailById(String id);

    void saveClueConvert(Map<String,Object> map);
}
