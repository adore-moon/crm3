package com.sss.crm.settings.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.DicType;
import com.sss.crm.settings.domain.DicValue;
import com.sss.crm.settings.service.DicTypeService;
import com.sss.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DicValueController {
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private DicTypeService dicTypeService;

    /**
     * 查询字典值并跳转到字典值首页
     * @param model
     * @return
     */
    @RequestMapping("/settings/dictionary/value/index.do")
    public String index(Model model){
        List<DicValue> dicValueList = dicValueService.selectDicValueByAll();
        model.addAttribute(dicValueList);
        return "settings/dictionary/value/index";
    }

    /**
     * 查询字典类型并跳转到创建界面
     * @param model
     * @return
     */
    @RequestMapping("/settings/dictionary/value/save.do")
    public String save(Model model){
        List<DicType> dicTypeList = dicTypeService.selectDicType();
        model.addAttribute(dicTypeList);
        return "settings/dictionary/value/save";
    }

    /**
     * 根据typeCode和Value查询字典值，判断是否重复
     * @param dicValue
     * @return
     */
    @RequestMapping("/settings/dictionary/value/selectDicValueByTypeAndValue.do")
    public @ResponseBody Object selectDicValueByTypeAndValue(DicValue dicValue){
        ReturnObject returnObject = new ReturnObject();
        DicValue dv = dicValueService.selectDicValueByTypeCodeAndValue(dicValue);
        if(dv!=null){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("字典值已存在！");
        }else {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }
        return returnObject;

    }

    /**
     * 保存创建的字典值
     * @param dicValue
     * @return
     */
    @RequestMapping("/settings/dictionary/value/saveCreateDicValue.do")
    public @ResponseBody Object saveCreateDicValue(DicValue dicValue){
        dicValue.setId(UUIDUtil.getUUID());
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = dicValueService.saveCreateDicValue(dicValue);
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
     * 根据id查询字典值并跳转到编辑界面
     * @param id
     * @param model
     * @return
     */
    @RequestMapping("/settings/dictionary/value/edit.do")
    public String edit(String id,Model model){
        DicValue dicValue = dicValueService.selectDicValueById(id);
        model.addAttribute(dicValue);
        return "settings/dictionary/value/edit";
    }

    /**
     * 保存修改的字典值
     * @param dicValue
     * @return
     */
    @RequestMapping("/settings/dictionary/value/saveEditDicValue.do")
    public @ResponseBody Object saveEditDicValue(DicValue dicValue){
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = dicValueService.saveEditDicValue(dicValue);
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
     * 根据id批量删除字典值
     * @param id
     * @return
     */
    @RequestMapping("/settings/dictionary/value/deleteDicValueByIds.do")
    public @ResponseBody Object deleteDicValueByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = dicValueService.deleteDicValueByIds(id);
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
