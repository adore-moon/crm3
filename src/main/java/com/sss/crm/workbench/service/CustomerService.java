package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerService {

    List<Customer> queryCustomerByName(String name);
}
