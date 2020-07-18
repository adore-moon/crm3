package com.sss.crm.workbench.mapper;

import com.sss.crm.workbench.domain.TranRemark;

import java.util.List;

public interface TranRemarkMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_remark
     *
     * @mbggenerated Mon Jul 06 14:12:10 CST 2020
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_remark
     *
     * @mbggenerated Mon Jul 06 14:12:10 CST 2020
     */
    int insert(TranRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_remark
     *
     * @mbggenerated Mon Jul 06 14:12:10 CST 2020
     */
    int insertSelective(TranRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_remark
     *
     * @mbggenerated Mon Jul 06 14:12:10 CST 2020
     */
    TranRemark selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_remark
     *
     * @mbggenerated Mon Jul 06 14:12:10 CST 2020
     */
    int updateByPrimaryKeySelective(TranRemark record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_tran_remark
     *
     * @mbggenerated Mon Jul 06 14:12:10 CST 2020
     */
    int updateByPrimaryKey(TranRemark record);

    /**
     * 批量创建交易备注
     * @param tranRemarkList
     */
    void insertTranRemark(List<TranRemark> tranRemarkList);

    /**
     * 根据交易id 查询备注信息
     * @param tranId
     * @return
     */
    List<TranRemark> selectTranRemarkByTranId(String tranId);

    /**
     * 保存创建的交易备注
     * @param tranRemark
     * @return
     */
    int insertTranRemarkOne(TranRemark tranRemark);

    /**
     * 根据id删除交易备注
     * @param id
     * @return
     */
    int deleteTranRemark(String id);

    /**
     * 保存更新的交易备注
     * @param tranRemark
     * @return
     */
    int updateTranRemark(TranRemark tranRemark);
}