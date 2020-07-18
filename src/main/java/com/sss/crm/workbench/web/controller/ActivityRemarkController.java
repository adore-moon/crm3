package com.sss.crm.workbench.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.User;
import com.sss.crm.workbench.domain.ActivityRemark;
import com.sss.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     * 保存创建的市场活动备注
     * @param activityRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveCreateActivityRemark.do")
    public @ResponseBody Object saveCreateActivityRemark(ActivityRemark activityRemark, HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        activityRemark.setId(UUIDUtil.getUUID());
        activityRemark.setCreateBy(user.getId());
        activityRemark.setCreateTime(DateUtil.formatDate(new Date()));
        activityRemark.setEditFlag("0");
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = activityRemarkService.saveCreateActivityRemark(activityRemark);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试！");
        }
        return returnObject;
    }

    /**
     * 保存修改的市场活动备注
     * @param activityRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveEditActivityRemark.do")
    public @ResponseBody Object saveEditActivityRemark(ActivityRemark activityRemark,HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditTime(DateUtil.formatDate(new Date()));
        activityRemark.setEditFlag("1");
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = activityRemarkService.saveEditActivityRemark(activityRemark);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(activityRemark);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试！");
        }
        return returnObject;
    }

    /**
     * 根据id删除市场活动备注
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/deleteActivityRemark.do")
    public @ResponseBody Object deleteActivityRemark(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = activityRemarkService.deleteActivityRemark(id);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试！");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试！");
        }
        return returnObject;
    }
}
