package com.sss.crm.workbench.service.impl;

import com.sss.crm.workbench.domain.Contacts;
import com.sss.crm.workbench.mapper.ContactsMapper;
import com.sss.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
@Service
public class ContactsServiceImpl implements ContactsService {
    @Autowired
    private ContactsMapper contactsMapper;
    @Override
    public List<Contacts> queryContactsByName(String fullName) {
        return contactsMapper.selectContactsByFullName(fullName);
    }
}
