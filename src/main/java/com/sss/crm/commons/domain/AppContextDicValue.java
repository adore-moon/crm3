package com.sss.crm.commons.domain;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import com.sss.crm.settings.domain.DicType;
import com.sss.crm.settings.domain.DicValue;
import com.sss.crm.settings.service.DicTypeService;
import com.sss.crm.settings.service.DicValueService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.List;

public class AppContextDicValue implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ApplicationContext app = new ClassPathXmlApplicationContext("conf/applicationContext.xml");
        DicTypeService dicTypeService = app.getBean(DicTypeService.class);
        DicValueService dicValueService = app.getBean(DicValueService.class);
        List<DicType> dicTypes = dicTypeService.selectDicType();
        for(DicType dicType:dicTypes){
            List<DicValue> dicValueList = dicValueService.queryDicValueByTypeCode(dicType.getCode());
            sce.getServletContext().setAttribute(dicType.getCode()+"List",dicValueList);
        }


    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        //使用DriverManager获取所有已经注册的数据库Driver
        Enumeration<Driver> enumeration = DriverManager.getDrivers();
        //遍历所有已经注册的数据库Driver
        while (enumeration.hasMoreElements()) {
            Driver driverTemp=enumeration.nextElement();
            try {
                //注销所有已经注册的数据库Driver
                DriverManager.deregisterDriver(driverTemp);
            }
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
        AbandonedConnectionCleanupThread.checkedShutdown();

    }
}
