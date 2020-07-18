package com.sss.crm.workbench.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.DicValue;
import com.sss.crm.settings.domain.User;
import com.sss.crm.settings.service.DicValueService;
import com.sss.crm.settings.service.UserService;
import com.sss.crm.workbench.domain.*;
import com.sss.crm.workbench.service.ActivityService;
import com.sss.crm.workbench.service.ClueActivityRelationService;
import com.sss.crm.workbench.service.ClueRemarkService;
import com.sss.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;
    @Autowired
    private ReturnObject returnObject1;


    /**
     * 查询数据并跳转到线索首页
     * @param model
     * @return
     */
    @RequestMapping("/workbench/clue/index.do")
    public String index(Model model){
        List<User> userList = userService.findUser();
        List<DicValue> appellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> stage = dicValueService.queryDicValueByTypeCode("clueState");
        List<DicValue> source = dicValueService.queryDicValueByTypeCode("source");
        model.addAttribute("userList",userList);
        model.addAttribute("appellation",appellation);
        model.addAttribute("stage",stage);
        model.addAttribute("source",source);
        return "workbench/clue/index";
    }

    /**
     * 根据条件分页查询线索和总条数
     * @param map
     * @param beginNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/workbench/clue/queryClueForPageByCondition.do")
    public @ResponseBody Object queryClueForPageByCondition(@RequestParam Map<String,Object> map,int beginNo,int pageSize){
        map.put("beginNo",beginNo);
        map.put("pageSize",pageSize);
        List<Clue> clueList = clueService.queryClueForPageByCondition(map);
        long totalRows = clueService.queryCountForPageByCondition(map);
        Map<String,Object> retMap = new HashMap<>();
        retMap.put("clueList",clueList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    /**
     * 保存创建的线索
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveCreateClue.do")
    public @ResponseBody Object saveCreateClue(Clue clue, HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        clue.setId(UUIDUtil.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(DateUtil.formatDate(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = clueService.saveCreateClue(clue);
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

    /**
     * 根据id批量删除线索
     * @param id
     * @return
     */
    @RequestMapping("/workbench/clue/deleteClueByIds.do")
    public @ResponseBody Object deleteClueByIds(String[] id){
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = clueService.deleteClueByIds(id);
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

    /**
     * 根据id查询线索
     * @param id
     * @return
     */
    @RequestMapping("/workbench/clue/queryClueById.do")
    public @ResponseBody Object queryClueById(String id){
         Clue clue = clueService.queryClueById(id);
         return clue;
    }

    /**
     * 保存修改的线索
     * @param clue
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveEditClue.do")
    public @ResponseBody Object saveEditClue(Clue clue,HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        clue.setEditBy(user.getId());
        clue.setEditTime(DateUtil.formatDate(new Date()));
          try{
              int i = clueService.saveEditClue(clue);
              if(i>0){
                  returnObject1.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
              }else {
                  returnObject1.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                  returnObject1.setMessage("系统正忙，请稍后再试！");
              }
          }catch (Exception e){
              e.printStackTrace();
              returnObject1.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
              returnObject1.setMessage("系统正忙，请稍后再试！");
          }
          return returnObject1;
    }

    /**
     * 根据id查询线索明细、线索备注、市场活动并跳转到线索明细页面
     * @param id
     * @return
     */
    @RequestMapping("/workbench/clue/detail.do")
    public String detail(String id,Model model){
        Clue clue = clueService.queryClueDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkByClueId(id);
        List<Activity> activityList = activityService.queryActivityDetailByClueId(id);
        model.addAttribute("clue",clue);
        model.addAttribute("clueRemarkList",clueRemarkList);
        model.addAttribute("activityList",activityList);
        return "workbench/clue/detail";
    }

    /**
     * 根据市场活动名称模糊查询市场活动并排除此线索已关联的市场活动
     * @param map
     * @return
     */
    @RequestMapping("/workbench/clue/queryActivityDetailByName.do")
    public @ResponseBody Object queryActivityDetailByName(@RequestParam Map<String,String> map){
        List<Activity> activityList = activityService.queryActivityDetailByName(map);
        return activityList;
    }

    /**
     * 向关联关系表中添加数据，在市场活动表中查询数据返回
     * @param activityId
     * @param clueId
     * @return
     */
    @RequestMapping("/workbench/clue/saveBundActivity,do")
    public @ResponseBody Object saveBundActivity(String[] activityId,String clueId){
        //封装参数
        ClueActivityRelation clueActivityRelation = null;
        List<ClueActivityRelation> clueActivityRelationList = new ArrayList<>();
        for(String acId:activityId){
            clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDUtil.getUUID());
            clueActivityRelation.setClueId(clueId);
            clueActivityRelation.setActivityId(acId);
            clueActivityRelationList.add(clueActivityRelation);
        }
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = clueActivityRelationService.saveCreateClueActivityRelation(clueActivityRelationList);
              if(i>0){
                  returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
                  List<Activity> activityList = activityService.queryActivityDetailByIds(activityId);
                  returnObject.setRetData(activityList);
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
     *根据市场活动id和线索id删除关联关系
     * @param clueActivityRelation
     * @return
     */
    @RequestMapping("/workbench/clue/deleteActivityRelation.do")
    public @ResponseBody Object deleteActivityRelation(ClueActivityRelation clueActivityRelation){
         ReturnObject returnObject = new ReturnObject();
          try{
              int i = clueActivityRelationService.deleteClueActivityRelationByAC(clueActivityRelation);
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


    /**
     * 跳转 转换页面
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("/workbench/clue/convert.do")
    public String convert(String id,Model model){
        Clue clue = clueService.queryClueDetailById(id);
        model.addAttribute(clue);
        return "workbench/clue/convert";
    }


    /**
     * 转换线索
     * @param map
     * @param session
     * @return
     */
    @RequestMapping("/workbench/clue/saveConvertClue.do")
    public @ResponseBody Object saveConvertClue(@RequestParam Map<String,Object> map,HttpSession session){
         ReturnObject returnObject = new ReturnObject();
         User user = (User)session.getAttribute(Contants.SESSION_USER);
         map.put("user",user);
          try{
              clueService.saveClueConvert(map);
              returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
          }catch (Exception e){
              e.printStackTrace();
              returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
              returnObject.setMessage("系统正忙，请稍后再试！");
          }
          return returnObject;
    }

}
