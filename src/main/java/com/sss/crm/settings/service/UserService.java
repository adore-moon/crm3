package com.sss.crm.settings.service;

import com.sss.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    User findUserByActAndPwd(Map<String,Object> map);

    List<User> findUser();
}
