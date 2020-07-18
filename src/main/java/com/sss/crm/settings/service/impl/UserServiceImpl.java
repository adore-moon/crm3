package com.sss.crm.settings.service.impl;

import com.sss.crm.settings.domain.User;
import com.sss.crm.settings.mapper.UserMapper;
import com.sss.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User findUserByActAndPwd(Map<String, Object> map) {
        return userMapper.selectUserByActAndPwd(map);
    }

    @Override
    public List<User> findUser() {
        return userMapper.selectUserByAll();
    }
}
