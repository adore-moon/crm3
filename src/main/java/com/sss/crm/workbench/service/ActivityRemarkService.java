package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkService {

    List<ActivityRemark> queryActivityRemarkByActivityId(String activityid);

    int saveCreateActivityRemark(ActivityRemark activityRemark);

    int saveEditActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemark(String id);
}
