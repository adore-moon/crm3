package com.sss.crm.settings.web.controller;

import com.sss.crm.commons.contants.Contants;
import com.sss.crm.commons.domain.ReturnObject;
import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.MD5Util;
import com.sss.crm.settings.domain.User;
import com.sss.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {
    @Autowired
    private UserService userService;
    @Autowired
    private JedisPool jedisPool;

    @RequestMapping("/settings/qx/user/tologin.do")
    public String tologin(HttpServletRequest request){
        /*Cookie[] cookies = request.getCookies();
        if(cookies!=null){
            Map<String,Object> map = new HashMap<>();
            for (Cookie c:cookies){

                if("loginAct".equals(c.getName())){
                    map.put("loginAct",c.getValue());
                    continue;
                }
                if("loginPwd".equals(c.getName())){
                    map.put("loginPwd",c.getValue());
                }
            }
            User user = userService.findUserByActAndPwd(map);
            if(user!=null){
                request.getSession().setAttribute(Contants.SESSION_USER,user);
                return "workbench/index";
            }
        }*/
        Jedis jedis = jedisPool.getResource();
        jedis.select(1);
        String loginAct = jedis.get("loginAct");
        String loginPwd = jedis.get("loginPwd");
        if(loginAct!="" && loginPwd!=""){
            Map<String,Object> map = new HashMap<>();
            map.put("loginAct",loginAct);
            map.put("loginPwd",loginPwd);
            User user = userService.findUserByActAndPwd(map);
            if(user!=null){
                request.getSession().setAttribute(Contants.SESSION_USER,user);
                return "workbench/index";
            }
        }
        return "settings/qx/user/login";
    }

    @RequestMapping("/settings/qx/user/login.do")
    public @ResponseBody Object
    login(String loginAct, String loginPwd, String check, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        Map<String,Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd", MD5Util.getMD5(loginPwd));
        User user = userService.findUserByActAndPwd(map);
        ReturnObject returnObject = new ReturnObject();
        if(user==null){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("用户名或密码错误！");
        }else if(user.getLockState()=="0"){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("账户处于锁定状态！");
        }else if(DateUtil.formatDate(new Date()).compareTo(user.getExpireTime())>0){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("账户已失效！");
        }else if(!user.getAllowIps().contains(request.getRemoteAddr())){
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("ip地址受限！");
        }else {
            returnObject.setCode(Contants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setMessage("登陆成功！");
            session.setAttribute(Contants.SESSION_USER,user);
            Jedis jedis = jedisPool.getResource();
            if("true".equals(check)){
                /*Cookie c1 = new Cookie("loginAct", loginAct);
                c1.setMaxAge(60*60*24*10);
                response.addCookie(c1);
                Cookie c2 = new Cookie("loginPwd", MD5Util.getMD5(loginPwd));
                c2.setMaxAge(60*60*24*10);
                response.addCookie(c2);*/

                jedis.select(1);
                jedis.set("loginAct",loginAct);
                jedis.set("loginPwd",MD5Util.getMD5(loginPwd));
            }else{
                /*Cookie[] cookies = request.getCookies();
                if(cookies!=null){
                    for (Cookie c:cookies){
                        if("loginAct".equals(c.getName())||"loginPwd".equals(c.getName())){
                            c.setMaxAge(0);
                            response.addCookie(c);
                        }
                    }
                }*/
                jedis.select(1);
                jedis.flushDB();
            }
        }
        return returnObject;
    }

    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpSession session,HttpServletResponse response) {
        //清空session，删除cookie
        session.invalidate();
        /*Cookie c1 = new Cookie("loginAct", "");
        c1.setMaxAge(0);
        response.addCookie(c1);
        Cookie c2 = new Cookie("loginPwd", "");
        c2.setMaxAge(0);
        response.addCookie(c2);*/
        Jedis jedis = jedisPool.getResource();
        jedis.select(1);
        jedis.flushDB();
        return "redirect:/";
    }

    @RequestMapping("/settings/index.do")
    public String index(){
        return "settings/index";
    }

    @RequestMapping("/settings/dictionary/index.do")
    public String dicIndex(){
        return "settings/dictionary/index";
    }
}
