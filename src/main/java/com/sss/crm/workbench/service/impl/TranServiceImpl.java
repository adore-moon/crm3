package com.sss.crm.workbench.service.impl;

import com.sss.crm.commons.utils.DateUtil;
import com.sss.crm.commons.utils.UUIDUtil;
import com.sss.crm.settings.domain.User;
import com.sss.crm.workbench.domain.Customer;
import com.sss.crm.workbench.domain.FunnelVo;
import com.sss.crm.workbench.domain.Tran;
import com.sss.crm.workbench.domain.TranHistory;
import com.sss.crm.workbench.mapper.CustomerMapper;
import com.sss.crm.workbench.mapper.TranHistoryMapper;
import com.sss.crm.workbench.mapper.TranMapper;
import com.sss.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
@Service
public class TranServiceImpl implements TranService {
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Override
    public List<Tran> queryTranForPageByCondition(Map<String, Object> map) {
        return tranMapper.queryTranForPageByCondition(map);
    }

    @Override
    public long queryCountForPageByCondition(Map<String, Object> map) {
        return tranMapper.queryCountForPageByCondition(map);
    }

    @Override
    public void saveCreateTran(HashMap<String, Object> map) {
        Tran tran = (Tran)map.get("tran");
        String customerName = (String)map.get("customerName");
        User user = (User)map.get("user");

        if(tran.getCustomerId()==null || tran.getCustomerId().trim().length()==0){
            //创建 客户
            Customer customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(user.getId());
            customer.setName(customerName);
            customer.setCreateBy(user.getId());
            customer.setCreateTime(DateUtil.formatDate(new Date()));
            customerMapper.insertCustomer(customer);
            tran.setCustomerId(customer.getId());
        }

        tranMapper.insertTran(tran);

        //保存交易历史记录
        TranHistory tranHistory = new TranHistory();
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setCreateBy(user.getId());
        tranHistory.setCreateTime(DateUtil.formatDate(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());
        tranHistoryMapper.insertTranHistory(tranHistory);
    }

    @Override
    public Tran queryTranDetailById(String id) {
        return tranMapper.selectTranDetailById(id);
    }

    @Override
    public void saveupdateTranIco(Map<String, Object> map) {
        Tran uptran = (Tran) map.get("uptran");
        TranHistory newth = (TranHistory) map.get("newth");

        tranMapper.updateTran(uptran);

        tranHistoryMapper.insertTranHistory(newth);

    }

    @Override
    public List<FunnelVo> queryCountOfTranGroupByStage() {

        return tranMapper.queryCountOfTranGroupByStage();
    }
}
