package com.sss.crm.workbench.mapper;

import com.sss.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Jun 30 20:00:22 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Jun 30 20:00:22 CST 2020
     */
    int insert(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Jun 30 20:00:22 CST 2020
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Jun 30 20:00:22 CST 2020
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Jun 30 20:00:22 CST 2020
     */
    int updateByPrimaryKeySelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Tue Jun 30 20:00:22 CST 2020
     */
    int updateByPrimaryKey(Activity record);

    /**
     * 保存创建的市场活动
     * @param activity
     * @return
     */
    int insertActivity(Activity activity);

    /**
     * 根据条件分页查询市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityForPageByCondition(Map<String,Object> map);

    /**
     * 根据条件分页查询符合条件的市场活动的条数
     * @param map
     * @return
     */
    long selectCountOfActivityByCondition(Map<String,Object> map);


    /**
     * 根据id查询市场活动
     * @param id
     * @return
     */
    Activity selectActivityById(String id);

    /**
     * 保存修改的市场活动
     * @param activity
     * @return
     */
    int updateActivity(Activity activity);

    /**
     * 根据id批量删除市场活动
     * @param id
     * @return
     */
    int deleteActivityByIds(String[] id);

    /**
     * 根据id查询市场活动明细
     * @param id
     * @return
     */
    Activity selectActivityDetailById(String id);

    /**
     * 查询所有市场活动明细
     * @return
     */
    List<Activity> selectActivityDetail();

    /**
     * 根据id批量查询市场活动明细
     * @param id
     * @return
     */
    List<Activity> selectActivityDetailByIds(String[] id);

    /**
     * 批量导入市场活动
     * @param activityList
     * @return
     */
    int insertActivityByImport(List<Activity> activityList);

    /**
     * 根据线索id查询市场活动
     * @param clueId
     * @return
     */
    List<Activity> selectActivityDetailByClueId(String clueId);

    /**
     * 根据市场活动名称模糊查询市场活动并排除此线索已关联的市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityDetailByName(Map<String,String> map);


    /**
     * 根据市场活动名称模糊查询市场活动
     * @param name
     * @return
     */
    List<Activity> selectActDetailByName(String name);


    /**
     * 根据市场活动名称模糊查询此线索已关联的市场活动
     * @param map
     * @return
     */
    List<Activity> selectActivityDetailByNameInClue(Map<String,Object> map);


}