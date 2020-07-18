package com.sss.crm.workbench.service.impl;

import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.User;
import com.sss.crm.workbench.domain.*;
import com.sss.crm.workbench.mapper.*;
import com.sss.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
@Service
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Override
    public List<Clue> queryClueForPageByCondition(Map<String, Object> map) {
        return clueMapper.selectClueForPageByCondition(map);
    }

    @Override
    public long queryCountForPageByCondition(Map<String, Object> map) {
        return clueMapper.selectCountForPageByCondition(map);
    }

    @Override
    public int saveCreateClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public int deleteClueByIds(String[] id) {
        return clueMapper.deleteClueByIds(id);
    }

    @Override
    public Clue queryClueById(String id) {
        return clueMapper.selectClueById(id);
    }

    @Override
    public int saveEditClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public Clue queryClueDetailById(String id) {
        return clueMapper.selectClueDetailById(id);
    }

    @Override
    public void saveClueConvert(Map<String, Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get("user");
        String isChecked = (String) map.get("isChecked");
        Clue clue = clueMapper.selectClueById(clueId);
        //创建客户
        Customer customer = new Customer();
        customer.setName(clue.getCompany());
        customer.setId(UUIDUtil.getUUID());
        customer.setAddress(clue.getAddress());
        customer.setOwner(user.getId());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(DateUtil.formatDate(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customerMapper.insertCustomer(customer);

        //创建联系人
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullName(clue.getFullName());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setmPhone(clue.getmPhone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtil.formatDate(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsMapper.insertContacts(contacts);


        //根据线索id查询线索备注
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectCRByClueId(clueId);

        //转换备注到客户备注表、联系人备注表中
        if(clueRemarkList!=null && clueRemarkList.size()>0){
            CustomerRemark customerRemark = null;
            ContactsRemark contactsRemark = null;
            List<CustomerRemark> customerRemarkList = new ArrayList<>();
            List<ContactsRemark> contactsRemarkList = new ArrayList<>();
            for(ClueRemark cr:clueRemarkList){
                customerRemark = new CustomerRemark();
                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setNoteContent(cr.getNoteContent());
                customerRemark.setCreateBy(cr.getCreateBy());
                customerRemark.setCreateTime(cr.getCreateTime());
                customerRemark.setEditBy(cr.getEditBy());
                customerRemark.setEditTime(cr.getEditTime());
                customerRemark.setEditFlag(cr.getEditFlag());
                customerRemark.setCustomerId(customer.getId());
                customerRemarkList.add(customerRemark);

                contactsRemark = new ContactsRemark();
                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setNoteContent(cr.getNoteContent());
                contactsRemark.setCreateBy(cr.getCreateBy());
                contactsRemark.setCreateTime(cr.getCreateTime());
                contactsRemark.setEditBy(cr.getEditBy());
                contactsRemark.setEditTime(cr.getEditTime());
                contactsRemark.setEditFlag(cr.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());
                contactsRemarkList.add(contactsRemark);
            }
            customerRemarkMapper.insertCustomerRemark(customerRemarkList);
            contactsRemarkMapper.insertContactsRemark(contactsRemarkList);
        }

        //根据clueId查询线索和市场活动的关联关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectCARByClueId(clueId);
        if(clueActivityRelationList!=null&&clueActivityRelationList.size()>0){
            ContactsActivityRelation contactsActivityRelation = null;
            List<ContactsActivityRelation> contactsActivityRelationList = new ArrayList<>();
            for (ClueActivityRelation clueActivityRelation : clueActivityRelationList) {
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelation.setActivityId(clueActivityRelation.getActivityId());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelationList.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertContactsActivityRelation(contactsActivityRelationList);
        }


        //如果需要创建交易，往交易表中添加一条记录
        if("true".equals(isChecked)){
            Tran tran = new Tran();
            tran.setId(UUIDUtil.getUUID());
            tran.setActivityId((String)map.get("activityId"));
            tran.setMoney((String)map.get("money"));
            tran.setName((String)map.get("name"));
            tran.setExpectedDate((String)map.get("expectedDate"));
            tran.setStage((String)map.get("stage"));
            tran.setContactsId(contacts.getId());
            tran.setCustomerId(customer.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtil.formatDate(new Date()));
            tran.setOwner(user.getId());
            tran.setDescription(clue.getDescription());
            tranMapper.insertTran(tran);

            //给交易历史添加记录
            TranHistory tranHistory = new TranHistory();
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setCreateBy(user.getId());
            tranHistory.setCreateTime(DateUtil.formatDate(new Date()));
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());
            tranHistoryMapper.insertTranHistory(tranHistory);

            //如果需要创建交易，还需要把该线索下所有的备注转换到交易备注表中一份
            //遍历clueRemarkList，封装TranRemark，把该线索下所有的备注转换到交易备注表中一份
            if(clueRemarkList!=null&&clueRemarkList.size()>0){
                TranRemark tranRemark = null;
                List<TranRemark> tranRemarkList = new ArrayList<>();
                for(ClueRemark cr:clueRemarkList){
                    tranRemark = new TranRemark();
                    tranRemark.setId(UUIDUtil.getUUID());
                    tranRemark.setNoteContent(cr.getNoteContent());
                    tranRemark.setCreateBy(cr.getCreateBy());
                    tranRemark.setCreateTime(cr.getCreateTime());
                    tranRemark.setEditBy(cr.getEditBy());
                    tranRemark.setEditTime(cr.getEditTime());
                    tranRemark.setEditFlag(cr.getEditFlag());
                    tranRemark.setTranId(tran.getId());
                    tranRemarkList.add(tranRemark);
                }
                tranRemarkMapper.insertTranRemark(tranRemarkList);
            }
        }
        //根据clueId删除该线索下所有的备注
        clueRemarkMapper.deleteClueRemarkByClueId(clueId);
        //根据clueId删除该线索和市场活动的关联关系
        clueActivityRelationMapper.deleteRelationByClueId(clueId);
        //根据id删除该线索
        clueMapper.deleteClueById(clueId);
    }
}
