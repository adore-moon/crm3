package com.sss.crm.workbench.service.impl;

import com.sss.crm.workbench.domain.ActivityRemark;
import com.sss.crm.workbench.mapper.ActivityRemarkMapper;
import com.sss.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;
    @Override
    public List<ActivityRemark> queryActivityRemarkByActivityId(String activityid) {
        return activityRemarkMapper.selectActivityRemarkByActivityId(activityid);
    }

    @Override
    public int saveCreateActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.insertActivityRemark(activityRemark);
    }

    @Override
    public int saveEditActivityRemark(ActivityRemark activityRemark) {
        return activityRemarkMapper.updateActivityRemark(activityRemark);
    }

    @Override
    public int deleteActivityRemark(String id) {
        return activityRemarkMapper.deleteActivityRemark(id);
    }
}
