package com.sss.crm.workbench.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.User;
import com.sss.crm.settings.service.UserService;
import com.sss.crm.workbench.domain.*;
import com.sss.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TransactionController {
    @Autowired
    private TranService tranService;
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TranRemarkService tranRemarkService;
    @Autowired
    private TranHistoryService tranHistoryService;

    @RequestMapping("/workbench/transaction/index.do")
    public String index(){
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/queryTranForPageByCondition.do")
    public @ResponseBody Object queryTranForPageByCondition(@RequestParam Map<String,Object> map,int beginNo,int pageSize){
        map.put("beginNo",beginNo);
        map.put("pageSize",pageSize);
        List<Tran> tranList = tranService.queryTranForPageByCondition(map);
        long totalRows = tranService.queryCountForPageByCondition(map);
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("tranList",tranList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/workbench/transaction/save.do")
    public String save(Model model){
        List<User> user = userService.findUser();
        model.addAttribute("users",user);
        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/getPossibility.do")
    public @ResponseBody Object getPossibility(String stage){
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        String string = possibility.getString(stage);
        return string;
    }

    @RequestMapping("/workbench/transaction/queryActDetailByName.do")
    public @ResponseBody Object queryActDetailByName(String name){
        List<Activity> activityList = activityService.queryActDetailByName(name);
        return activityList;
    }

    @RequestMapping("/workbench/transaction/queryContactsByFullName.do")
    public @ResponseBody Object queryContactsByFullName(String fullName){
        List<Contacts> contacts = contactsService.queryContactsByName(fullName);
        return contacts;
    }

    @RequestMapping("/workbench/transaction/queryCustomerByName.do")
    public @ResponseBody Object queryCustomerByName(String customerName){
        List<Customer> customers = customerService.queryCustomerByName(customerName);
        return customers;
    }

    /**
     * 创建交易
     * @param tran
     * @param customerName
     * @param session
     * @return
     */
    @RequestMapping("/workbench/transaction/saveCreateTran.do")
    public @ResponseBody Object saveCreateTran(Tran tran, String customerName, HttpSession session){
        User user  =(User)session.getAttribute(Contants.SESSION_USER);
        tran.setId(UUIDUtil.getUUID());
        tran.setCreateBy(user.getId());
        tran.setCreateTime(DateUtil.formatDate(new Date()));
        HashMap<String, Object> map = new HashMap<>();
        map.put("tran",tran);
        map.put("user",user);
        map.put("customerName",customerName);
         ReturnObject returnObject = new ReturnObject();
          try{
              tranService.saveCreateTran(map);
              returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
          }catch (Exception e){
              e.printStackTrace();
              returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
              returnObject.setMessage("系统正忙，请稍后再试！");
          }
          return returnObject;

    }

    /**
     * 条状到详细页面，并根据id查询交易，查询交易备注，查询交易历史记录
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("/workbench/transaction/detail.do")
    public String detail(String id,Model model){
        Tran tran = tranService.queryTranDetailById(id);
        List<TranRemark> tranRemarkList = tranRemarkService.queryTranRemarkByTranId(id);
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryByTranId(id);
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        String possi = possibility.getString(tran.getStage());
        tran.setPossi(possi);
        for (TranHistory th : tranHistoryList) {
            possi = possibility.getString(th.getStage());
            th.setPossi(possi);
        }
        model.addAttribute(tran);
        model.addAttribute(tranRemarkList);
        model.addAttribute(tranHistoryList);
        return "workbench/transaction/detail";
    }


    /**
     * 点击阶段图标更新交易和交易历史记录
     * @param tranId
     * @param money
     * @param stage
     * @param expectedDate
     * @return
     */
    @RequestMapping("/workbench/transaction/updateTranIco.do")
    public @ResponseBody Object updateTranIco(String stageValue,String tranId,String money,String stage,String expectedDate,HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        //更新交易，封装参数
        Tran tran = new Tran();
        tran.setId(tranId);
        tran.setStage(stage);
        String possi = possibility.getString(stageValue);
        tran.setPossi(possi);
        tran.setEditBy(user.getId());
        tran.setEditTime(DateUtil.formatDate(new Date()));

        //新增交易历史记录，封装参数
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setPossi(possi);
        tranHistory.setTranId(tranId);
        tranHistory.setStage(stage);
        tranHistory.setMoney(money);
        tranHistory.setExpectedDate(expectedDate);
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtil.formatDate(new Date()));

        Map<String,Object> map = new HashMap<>();
        map.put("uptran",tran);
        map.put("newth",tranHistory);

        tranService.saveupdateTranIco(map);

        return map;
    }


    /**
     * 根据交易id 查询交易历史记录
     * @param tranId
     * @return
     */
    @RequestMapping("/workbench/transaction/queryTranHistory.do")
    public @ResponseBody Object queryTranHistory(String tranId){
        List<TranHistory> tranHistoryList = tranHistoryService.queryTranHistoryByTranId(tranId);
        ResourceBundle possibility = ResourceBundle.getBundle("possibility");
        for (TranHistory th : tranHistoryList) {
            String possi = possibility.getString(th.getStage());
            th.setPossi(possi);
        }
        return tranHistoryList;
    }

}
