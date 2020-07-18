package com.sss.crm.workbench.service;

import com.sss.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {

    List<Contacts> queryContactsByName(String fullName);
}
