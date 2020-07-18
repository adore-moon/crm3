package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.Activity;
import org.omg.PortableInterceptor.ACTIVE;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityForPageByCondition(Map<String,Object> map);

    long queryCountOfActivityByCondition(Map<String,Object> map);

    Activity queryActivityById(String id);

    int saveEditActivity(Activity activity);

    int deleteActivityByIds(String[] id);

    Activity queryActivityDetailById(String id);

    List<Activity> queryActivityDetail();

    List<Activity> queryActivityDetailByIds(String[] id);

    int saveImportActivity(List<Activity> activityList);

    List<Activity> queryActivityDetailByClueId(String clueId);

    List<Activity> queryActivityDetailByName(Map<String,String> map);

    List<Activity> queryActDetailByName(String name);

    List<Activity> queryActivityDetailByNameInClue(Map<String,Object> map);
}
