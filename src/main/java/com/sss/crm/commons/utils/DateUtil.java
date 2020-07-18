package com.sss.crm.commons.utils;


import java.text.SimpleDateFormat;
import java.util.Date;

public class DateUtil {
    public static String formatDate(Date date){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String format = simpleDateFormat.format(date);
        return format;
    }
}
