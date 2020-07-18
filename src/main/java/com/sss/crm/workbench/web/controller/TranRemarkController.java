package com.sss.crm.workbench.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.User;
import com.sss.crm.workbench.domain.TranRemark;
import com.sss.crm.workbench.service.TranRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
public class TranRemarkController {

    @Autowired
    private TranRemarkService tranRemarkService;

    /**
     * 保存创建的交易备注
     * @param tranRemark
     * @param session
     * @return
     */
    @RequestMapping("/workbench/transaction/saveCreateTranRemark.do")
    public @ResponseBody Object saveCreateTranRemark(TranRemark tranRemark, HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        tranRemark.setId(UUIDUtil.getUUID());
        tranRemark.setCreateBy(user.getId());
        tranRemark.setCreateTime(DateUtil.formatDate(new Date()));
        tranRemark.setEditFlag("0");
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = tranRemarkService.saveCreateTranRemark(tranRemark);
              if(i>0){
                  returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                  returnObject.setRetData(tranRemark);
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
     * 根据id删除交易备注
     * @param id
     * @return
     */
    @RequestMapping("/workbench/transaction/deleteTranRemark.do")
    public @ResponseBody Object deleteTranRemark(String id){
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = tranRemarkService.deleteTranRemark(id);
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

    @RequestMapping("/workbench/transaction/saveEditTranRemark.do")
    public @ResponseBody Object saveEditTranRemark(TranRemark tranRemark,HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        tranRemark.setEditFlag("1");
        tranRemark.setEditTime(DateUtil.formatDate(new Date()));
        tranRemark.setEditBy(user.getId());
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = tranRemarkService.saveEditTranRemark(tranRemark);
              if(i>0){
                  returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                  returnObject.setRetData(tranRemark);
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
