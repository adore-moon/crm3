package com.sss.crm.workbench.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.HSSFCellValueUtils;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.User;
import com.sss.crm.settings.service.UserService;
import com.sss.crm.workbench.domain.Activity;
import com.sss.crm.workbench.domain.ActivityRemark;
import com.sss.crm.workbench.service.ActivityRemarkService;
import com.sss.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.*;

@Controller
public class ActivityController {
    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     * 查询user并跳转至市场活动首页
     * @param model
     * @return
     */
    @RequestMapping("/workbench/activity/index.do")
    public String index(Model model){
        List<User> userList = userService.findUser();
        model.addAttribute(userList);
        return "workbench/activity/index";
    }

    /**
     * 保存创建的市场活动
     * @param activity
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateBy(user.getId());
        activity.setCreateTime(DateUtil.formatDate(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = activityService.saveCreateActivity(activity);
            if(i>0){
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统正忙，请稍后再试！");
            }
        }catch (Exception e){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统正忙，请稍后再试！");
        }
        return returnObject;
    }

    /**
     * 根据条件分页查询市场活动及总条数
     * @param map
     * @return
     */
    @RequestMapping("/workbench/activity/queryActivityForPageByCondition.do")
    public @ResponseBody Object queryActivityForPageByCondition(@RequestParam Map<String,Object> map,int beginNo,int pageSize){
        /*String beginNo = (String)map.get("beginNo");
        String pageSize = (String)map.get("pageSize");
        map.put("beginNo",Integer.parseInt(beginNo));
        map.put("pageSize",Integer.parseInt(pageSize));*/
        map.put("beginNo",beginNo);
        map.put("pageSize",pageSize);

        List<Activity> activityList = activityService.queryActivityForPageByCondition(map);
        long totalRows = activityService.queryCountOfActivityByCondition(map);

        Map<String,Object> retMap = new HashMap<>();
        retMap.put("activityList",activityList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    /**
     * 根据id查询市场活动
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/editActivityById.do")
    public @ResponseBody Object editActivityById(String id){
        Activity activity = activityService.queryActivityById(id);
        return activity;
    }

    /**
     * 保存修改的市场活动
     * @param activity
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/saveEditActivity.do")
    public @ResponseBody Object saveEditActivity(Activity activity,HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        activity.setEditBy(user.getId());
        activity.setEditTime(DateUtil.formatDate(new Date()));
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = activityService.saveEditActivity(activity);
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
     * 根据id批量删除市场活动
     * @param id
     * @return
     */
    @RequestMapping("/workbench/activity/deleteActivityByIds.do")
    public @ResponseBody Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = activityService.deleteActivityByIds(id);
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
     * 根据id查询市场活动明细及该市场活动下的所有备注并跳转到明细页面
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("/workbench/activity/detail.do")
    public String detail(String id,Model model){
        Activity activity = activityService.queryActivityDetailById(id);
        List<ActivityRemark> remarkList = activityRemarkService.queryActivityRemarkByActivityId(id);
        model.addAttribute("activity",activity);
        model.addAttribute("remarkList",remarkList);
        return "workbench/activity/detail";
    }


    /**
     * 批量下载市场活动
     * @param request
     * @param response
     */
    @RequestMapping("/workbench/activity/exportActivityAll.do")
    public void exportActivityAll(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<Activity> activityList = activityService.queryActivityDetail();
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        row.createCell(0).setCellValue("id");
        row.createCell(1).setCellValue("所有者");
        row.createCell(2).setCellValue("名称");
        row.createCell(3).setCellValue("开始日期");
        row.createCell(4).setCellValue("结束日期");
        row.createCell(5).setCellValue("成本");
        row.createCell(6).setCellValue("描述");
        row.createCell(7).setCellValue("创建者");
        row.createCell(8).setCellValue("创建时间");
        row.createCell(9).setCellValue("修改者");
        row.createCell(10).setCellValue("修改时间");

        if(activityList!=null){
            Activity activity=null;
            for (int i=0;i<activityList.size();i++ ){
                activity=activityList.get(i);
                row = sheet.createRow(i + 1);
                row.createCell(0).setCellValue(activity.getId());
                row.createCell(1).setCellValue(activity.getOwner());
                row.createCell(2).setCellValue(activity.getName());
                row.createCell(3).setCellValue(activity.getStartDate());
                row.createCell(4).setCellValue(activity.getEndDate());
                row.createCell(5).setCellValue(activity.getCost());
                row.createCell(6).setCellValue(activity.getDescription());
                row.createCell(7).setCellValue(activity.getCreateBy());
                row.createCell(8).setCellValue(activity.getCreateTime());
                row.createCell(9).setCellValue(activity.getEditBy());
                row.createCell(10).setCellValue(activity.getEditTime());
            }
        }

        //设置响应信息
        //1。设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //根据HTTP协议的规定，浏览器每次向服务器发送请求，都会把浏览器信息以请求头的形式发送到服务器
        String browser = request.getHeader("User-Agent");
        //不同的浏览器接收响应头采用的编码格式不一样：
        //IE采用 urlencoded
        String fileName = URLEncoder.encode("市场活动列表", "UTF-8");
        if(browser.contains("firefox")){
            //火狐采用 ISO8859-1
            fileName = new String("市场活动列表".getBytes("UTF-8"),"ISO-8859-1");
        }
        //默认情况下，浏览器接收到响应信息之后，直接在显示窗口中打开；
        //可以设置响应头信息，使浏览器接收到响应信息之后，在下载窗口打开
        response.addHeader("Content-Disposition","attachment;filename="+fileName+".xls");
        //2。获取输出流
        OutputStream os = response.getOutputStream();
        wb.write(os);
        os.flush();
        os.close();
        wb.close();
    }

    /**
     * 选择下载市场活动
     * @param id
     * @param response
     * @param request
     * @throws IOException
     */
    @RequestMapping("/workbench/activity/exportActivityXz.do")
    public void exportActivityXz(String[] id,HttpServletResponse response,HttpServletRequest request) throws IOException {
        List<Activity> activityList = activityService.queryActivityDetailByIds(id);
        HSSFWorkbook wb = new HSSFWorkbook();
        HSSFSheet sheet = wb.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        row.createCell(0).setCellValue("id");
        row.createCell(1).setCellValue("所有者");
        row.createCell(2).setCellValue("名称");
        row.createCell(3).setCellValue("开始日期");
        row.createCell(4).setCellValue("结束日期");
        row.createCell(5).setCellValue("成本");
        row.createCell(6).setCellValue("描述");
        row.createCell(7).setCellValue("创建者");
        row.createCell(8).setCellValue("创建时间");
        row.createCell(9).setCellValue("修改者");
        row.createCell(10).setCellValue("修改时间");

        if(activityList!=null){
            Activity activity=null;
            for (int i=0;i<activityList.size();i++ ){
                activity=activityList.get(i);
                row = sheet.createRow(i + 1);
                row.createCell(0).setCellValue(activity.getId());
                row.createCell(1).setCellValue(activity.getOwner());
                row.createCell(2).setCellValue(activity.getName());
                row.createCell(3).setCellValue(activity.getStartDate());
                row.createCell(4).setCellValue(activity.getEndDate());
                row.createCell(5).setCellValue(activity.getCost());
                row.createCell(6).setCellValue(activity.getDescription());
                row.createCell(7).setCellValue(activity.getCreateBy());
                row.createCell(8).setCellValue(activity.getCreateTime());
                row.createCell(9).setCellValue(activity.getEditBy());
                row.createCell(10).setCellValue(activity.getEditTime());
            }
        }

        //设置响应信息
        //1。设置响应类型
        response.setContentType("application/octet-stream;charset=UTF-8");
        //根据HTTP协议的规定，浏览器每次向服务器发送请求，都会把浏览器信息以请求头的形式发送到服务器
        String browser = request.getHeader("User-Agent");
        //不同的浏览器接收响应头采用的编码格式不一样：
        //IE采用 urlencoded
        String fileName = URLEncoder.encode("市场活动列表", "UTF-8");
        if(browser.contains("firefox")){
            //火狐采用 ISO8859-1
            fileName = new String("市场活动列表".getBytes("UTF-8"),"ISO-8859-1");
        }
        //默认情况下，浏览器接收到响应信息之后，直接在显示窗口中打开；
        //可以设置响应头信息，使浏览器接收到响应信息之后，在下载窗口打开
        response.addHeader("Content-Disposition","attachment;filename="+fileName+".xls");
        //2。获取输出流
        OutputStream os = response.getOutputStream();
        wb.write(os);
        os.flush();
        os.close();
        wb.close();
    }

    /**
     * 导入市场活动文件
     * @param activityFile
     * @param session
     * @return
     */
    @RequestMapping("/workbench/activity/importActivity.do")
    public @ResponseBody Object importActivity(MultipartFile activityFile,HttpSession session){
        User user = (User)session.getAttribute(Contants.SESSION_USER);
        Map<String,Object> retMap = new HashMap<>();
        try{
            InputStream in = activityFile.getInputStream();
            HSSFWorkbook wb = new HSSFWorkbook(in);
            HSSFSheet sheet = wb.getSheetAt(0);

            HSSFRow row = null;
            HSSFCell cell = null;
            List<Activity> activityList = new ArrayList<>();
            Activity activity = null;
            for(int i=1;i<=sheet.getLastRowNum();i++){
                row = sheet.getRow(i);
                activity = new Activity();
                activity.setId(UUIDUtil.getUUID());
                activity.setOwner(user.getId());
                activity.setCreateBy(user.getId());
                activity.setCreateTime(DateUtil.formatDate(new Date()));
                for(int j=0;j<row.getLastCellNum();j++){
                    String cellValue = HSSFCellValueUtils.getCellValue(row.getCell(j));

                    if(j==0){
                        activity.setName(cellValue);
                    }
                    if(j==1){
                        activity.setStartDate(cellValue);
                    }
                    if(j==2){
                        activity.setEndDate(cellValue);
                    }
                    if(j==3){
                        activity.setCost(cellValue);
                    }
                    if(j==4){
                        activity.setDescription(cellValue);
                    }
                }
                activityList.add(activity);
            }
            int i = activityService.saveImportActivity(activityList);
            retMap.put("code",Contants.RETURN_OBJECT_CODE_SUCCESS);
            retMap.put("count",i);
        }catch (Exception e){
            e.printStackTrace();
            retMap.put("code",Contants.RETURN_OBJECT_CODE_FAIL);
            retMap.put("message","系统正忙，请稍后再试！");
        }
        return retMap;
    }


    /**
     * 根据市场活动名称模糊查询此线索已关联的市场活动
     * @param map
     * @return
     */
    @RequestMapping("/workbench/activity/queryActivityDetailByNameInClue.do")
    public @ResponseBody Object queryActivityDetailByNameInClue(@RequestParam Map<String,Object> map){
        List<Activity> activityList = activityService.queryActivityDetailByNameInClue(map);
        return activityList;
    }


}
