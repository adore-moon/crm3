package com.sss.crm.settings.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.settings.domain.DicType;
import com.sss.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class DicTypeController {

    @Autowired
    private DicTypeService dicTypeService;

    /**
     * 查询字典类型并跳转到字典类型主页面
     * @param model
     * @return
     */
    @RequestMapping("/settings/dictionary/type/index.do")
    public String index(Model model){
        List<DicType> dicTypeList = dicTypeService.selectDicType();
        model.addAttribute(dicTypeList);
        return "settings/dictionary/type/index";
    }

    /**
     * 跳转到创建界面
     * @return
     */
    @RequestMapping("/settings/dictionary/type/save.do")
    public String save(){
        return "settings/dictionary/type/save";
    }

    /**
     * 根据code查询字典类型
     * @param code
     * @return
     */
    @RequestMapping("/settings/dictionary/type/selectDicTypeByCode.do")
    public @ResponseBody Object selectDicTypeByCode(String code){
        DicType dicType = dicTypeService.selectDicTypeByCode(code);
        ReturnObject returnObject = new ReturnObject();
        if(dicType!=null){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("字典类型已存在！");
        }else {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
        }
        return returnObject;
    }

    /**
     * 保存创建的字典类型
     * @param dicType
     * @return
     */
    @RequestMapping("/settings/dictionary/type/saveCreateDicType.do")
    public @ResponseBody Object saveCreateDicType(DicType dicType){
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = dicTypeService.saveCreateDicType(dicType);
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
     * 根据code查询数据字典类型并跳转到编辑界面
     * @param code
     * @param model
     * @return
     */
    @RequestMapping("/settings/dictionary/type/edit.do")
    public String edit(String code,Model model){
        DicType dicType = dicTypeService.selectDicTypeByCode(code);
        model.addAttribute(dicType);
        return "settings/dictionary/type/edit";
    }

    /**
     * 保存编辑的数据字典类型
     * @param dicType
     * @return
     */
    @RequestMapping("/settings/dictionary/type/saveEditDicType.do")
    public @ResponseBody Object saveEditDicType(DicType dicType){
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = dicTypeService.saveEditDicType(dicType);
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
     * 批量删除数据字典类型
     * @param code
     * @return
     */
    @RequestMapping("/settings/dictionary/type/deleteDicTypeByCodes.do")
    public @ResponseBody Object deleteDicTypeByCodes(String[] code){
        ReturnObject returnObject = new ReturnObject();
        try{
            int i = dicTypeService.deleteDicTypeByCodes(code);
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
}
