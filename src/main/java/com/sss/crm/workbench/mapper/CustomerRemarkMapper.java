package com.sss.crm.workbench.mapper;

import com.sss.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Jul 06 17:54:02 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Jul 06 17:54:02 CST 2020
     */
    int insert(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Jul 06 17:54:02 CST 2020
     */
    int insertSelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Jul 06 17:54:02 CST 2020
     */
    CustomerRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Jul 06 17:54:02 CST 2020
     */
    int updateByPrimaryKeySelective(CustomerRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_customer_remark
     *
     * @mbggenerated Mon Jul 06 17:54:02 CST 2020
     */
    int updateByPrimaryKey(CustomerRemark record);

    /**
     * 批量添加客户备注
     * @param customerRemarkList
     * @return
     */
    int insertCustomerRemark(List<CustomerRemark> customerRemarkList);
}