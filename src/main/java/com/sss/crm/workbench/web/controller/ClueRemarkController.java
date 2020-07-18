package com.sss.crm.workbench.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.User;
import com.sss.crm.workbench.domain.ClueRemark;
import com.sss.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class ClueRemarkController {
    @Autowired
    private ClueRemarkService clueRemarkService;

    /**
     * 保存创建的线索备注
     * @param clueRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveCreateClueRemark.do")
    public @ResponseBody Object saveCreateClueRemark(ClueRemark clueRemark, HttpSession session){
        User user  =(User)session.getAttribute(Contants.SESSION_USER);
        clueRemark.setId(UUIDUtil.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(DateUtil.formatDate(new Date()));
        clueRemark.setEditFlag("0");
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = clueRemarkService.saveCreateClueRemark(clueRemark);
              if(i>0){
                  returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                  returnObject.setRetData(clueRemark);
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
     * 保存修改的线索备注
     * @param clueRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveEditClueRemark.do")
    public @ResponseBody Object saveEditClueRemark(ClueRemark clueRemark,HttpSession session){
        clueRemark.setEditFlag("1");
        User user = (User) session.getAttribute(Contants.SESSION_USER);
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditTime(DateUtil.formatDate(new Date()));
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = clueRemarkService.saveEditClueRemark(clueRemark);
              if(i>0){
                  returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                  returnObject.setRetData(clueRemark);
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
     * 根据id删除线索备注
     * @param id
     * @return
     */
    @RequestMapping("/workbench/clue/deleteClueRemarkById.do")
    public @ResponseBody Object deleteClueRemarkById(String id){
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = clueRemarkService.deleteClueRemarkById(id);
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
