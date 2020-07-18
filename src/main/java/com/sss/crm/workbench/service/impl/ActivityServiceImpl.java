package com.sss.crm.workbench.service.impl;

import com.sss.crm.workbench.domain.Activity;
import com.sss.crm.workbench.mapper.ActivityMapper;
import com.sss.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityForPageByCondition(Map<String, Object> map) {
        return activityMapper.selectActivityForPageByCondition(map);
    }

    @Override
    public long queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int saveEditActivity(Activity activity) {
        return activityMapper.updateActivity(activity);
    }

    @Override
    public int deleteActivityByIds(String[] id) {
        return activityMapper.deleteActivityByIds(id);
    }

    @Override
    public Activity queryActivityDetailById(String id) {
        return activityMapper.selectActivityDetailById(id);
    }

    @Override
    public List<Activity> queryActivityDetail() {
        return activityMapper.selectActivityDetail();
    }

    @Override
    public List<Activity> queryActivityDetailByIds(String[] id) {
        return activityMapper.selectActivityDetailByIds(id);
    }

    @Override
    public int saveImportActivity(List<Activity> activityList) {
        return activityMapper.insertActivityByImport(activityList);
    }

    @Override
    public List<Activity> queryActivityDetailByClueId(String clueId) {
        return activityMapper.selectActivityDetailByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityDetailByName(Map<String,String> map) {
        return activityMapper.selectActivityDetailByName(map);
    }

    @Override
    public List<Activity> queryActDetailByName(String name) {
        return activityMapper.selectActDetailByName(name);
    }

    @Override
    public List<Activity> queryActivityDetailByNameInClue(Map<String,Object> map) {
        return activityMapper.selectActivityDetailByNameInClue(map);
    }
}
