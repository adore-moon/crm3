package com.sss.crm.workbench.service.impl;

import com.sss.crm.workbench.domain.Customer;
import com.sss.crm.workbench.mapper.CustomerMapper;
import com.sss.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class CustomerServiceImpl implements CustomerService {
    @Autowired
    private CustomerMapper customerMapper;
    @Override
    public List<Customer> queryCustomerByName(String name) {
        return customerMapper.selectCustomerByName(name);
    }
}
