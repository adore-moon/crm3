<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
	<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		$("#reDiv").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		})
		$("#reDiv").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		})
		$("#reDiv").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		})
		$("#reDiv").on("mouseout",".myHref",function () {
			$(this).children("span").css("color","#E6E6E6");
		})

		/*$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		*/
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });



		//给阶段图标添加单击事件
		$(".mystage").click(function () {
			var stage = $(this).attr("stid");
			var stageValue = $(this).attr("data-content");
			var tranId = '${tran.id}';
			var money = '${tran.money}';
			var expectedDate = '${tran.expectedDate}';

			$.ajax({
				url:"workbench/transaction/updateTranIco.do",
				data:{
					stage:stage,
					tranId:tranId,
					money:money,
					expectedDate:expectedDate,
					stageValue:stageValue
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					$("#b_st").html(stageValue);
					$("#b_po").html(data.uptran.possi);
					$("#b_edb").html('${sessionScope.sessionUser.name}'+'&nbsp;&nbsp;');
					$("#s_edt").html(data.uptran.editTime);

					flashTranHistory(tranId);

				}
			})

		})


		//给保存按钮添加单击事件
		$("#saveReBtn").click(function () {
			var noteContent = $.trim($("#remark").val());
			var tranId = '${tran.id}';
			if(noteContent==''){
				alert("备注内容不能为空！")
			}else {
				$.ajax({
					url:"workbench/transaction/saveCreateTranRemark.do",
					data:{
						tranId:tranId,
						noteContent:noteContent
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							var htmlStr = '';
							htmlStr+='<div id=\''+data.retData.id+'\' class="remarkDiv" style="height: 60px;">';
							htmlStr+='<img title=\''+data.retData.createBy+'\' src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
							htmlStr+='<div style="position: relative; top: -40px; left: 40px;" >';
							htmlStr+='<h5>'+noteContent+'</h5>';
							htmlStr+='<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.customerId}-${tran.name}</b> <small style="color: gray;"> '+data.retData.createTime+' 由${sessionScope.sessionUser.name}创建</small>';
							htmlStr+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
							htmlStr+='<a class="myHref" name="edit" trId=\''+data.retData.id+'\' href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
							htmlStr+='&nbsp;&nbsp;&nbsp;&nbsp;';
							htmlStr+='<a class="myHref" name="del" trId=\''+data.retData.id+'\' href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
							htmlStr+='</div>';
							htmlStr+='</div>';
							htmlStr+='</div>';

							$("#remarkDiv").before(htmlStr);
							$("#remark").val('')
						}else {
							alert(data.message);
						}
					}
				})
			}
		})

		//给所有的删除图标绑定单击事件
		$("#reDiv").on("click","a[name=del]",function () {
			var id=$(this).attr("trId");
			$.ajax({
				url:"workbench/transaction/deleteTranRemark.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						$("#"+id).remove();
					}else {
						alert(data.message);
					}
				}
			})
		})

		//给所有的编辑图标绑定单击事件
		$("#reDiv").on("click","a[name=edit]",function () {
			var id=$(this).attr("trId");
			var noteContent = $("#"+id+" h5").text();
			$("#noteContent").val(noteContent);
			$("#tranReId").val(id);
			$('#editTranReModal').modal("show");
		})
		//给更新按钮绑定单击事件
		$("#updateTranReBtn").click(function () {
			var noteContent = $("#noteContent").val();
			var id =$("#tranReId").val();
			if(noteContent==''){
				alert('备注不能为空！')
			}else {
				$.ajax({
					url:"workbench/transaction/saveEditTranRemark.do",
					data:{
						id:id,
						noteContent:noteContent
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							$('#editTranReModal').modal("hide");
							$("#"+id+" h5").text(noteContent);
							$("#"+id+" small").html(' '+data.retData.editTime+' 由${sessionScope.sessionUser.name}修改');
						}else {
							alert(data.message);
						}
					}
				})
			}
		})
	});
	
	
	function flashTranHistory(tranId) {
		$.ajax({
			url:"workbench/transaction/queryTranHistory.do",
			data:{
				tranId:tranId
			},
			type:"post",
			dataType:"json",
			success:function (data) {
				var htmlStr = '';
				$.each(data,function (index,obj) {
					htmlStr+='<tr>';
					htmlStr+='<td>'+obj.stage+'</td>';
					htmlStr+='<td>'+obj.money+'</td>';
					htmlStr+='<td>'+obj.possi+'</td>';
					htmlStr+='<td>'+obj.expectedDate+'</td>';
					htmlStr+='<td>'+obj.createBy+'</td>';
					htmlStr+='<td>'+obj.createTime+'</td>';
					htmlStr+='</tr>';
				})
				$("#tBody").html(htmlStr);
			}
		})
	}
	
	
</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${tran.customerId}-${tran.name} <small>￥${tran.money}</small></h3>
		</div>
		
	</div>

	<br/>
	<br/>
	<br/>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<c:forEach items="${applicationScope.stageList}" var="st" varStatus="vs">
<!--			fn:length()函数返回字符串长度或集合中元素的数量-->
<!--			先判断最后两个图标-->
			<c:if test="${vs.count==fn:length(stageList) || vs.count==fn:length(stageList)-1}">
				<!--如果stage就是当前交易的阶段，则图标显示为红色-->
				<c:if test="${st.value==tran.stage}">
					<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" data-content="${st.value}" stid="${st.id}" style="color: red;"></span>
					-----------
				</c:if>
				<!--如果stage不是当前交易的阶段，则图标显示为黑色-->
				<c:if test="${st.value!=tran.stage}">
					<span class="glyphicon glyphicon-thumbs-down mystage" data-toggle="popover" data-placement="bottom" data-content="${st.value}" stid="${st.id}" ></span>
					-----------
				</c:if>
			</c:if>
<!--			再判断普通图标-->
			<c:if test="${vs.count<fn:length(stageList)-1}" >
				<!--如果当前交易阶段就是"成交"或者处在"成交"之前,不需要记住失败之前的状态,stageList下标取'成交'的orderNo-->
				<c:if test="${tran.orderNo<=stageList[fn:length(stageList)-2].orderNo}">
					<c:if test="${st.value==tran.stage}">
						<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="${st.value}" stid="${st.id}" style="color: #90F790;"></span>
						-----------
					</c:if>
					<c:if test="${st.orderNo<tran.orderNo}">
						<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="${st.value}" stid="${st.id}" style="color: #90F790;"></span>
						-----------
					</c:if>
					<c:if test="${st.orderNo>tran.orderNo}">
						<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${st.value}" stid="${st.id}"></span>
						-----------
					</c:if>
				</c:if>
				<c:if test="${tran.orderNo>stageList[fn:length(stageList)-2].orderNo}" >
					<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="${st.value}" stid="${st.id}"></span>
					-----------
				</c:if>
			</c:if>
		</c:forEach>
		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${tran.expectedDate}</span>
	</div>



	<!-- 修改交易备注的模态窗口 -->
	<div class="modal fade" id="editTranReModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="tranReId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="noteContent" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateTranReBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}-${tran.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.customerId}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="b_st">${tran.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="b_po">${tran.possi}%</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${tran.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${tran.activityId}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.contactsId}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${tran.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="b_edb">${tran.editBy}&nbsp;&nbsp;</b><small id="s_edt" style="font-size: 10px; color: gray;">${tran.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${tran.contactSummary}&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${tran.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="reDiv" style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<c:forEach items="${tranRemarkList}" var="tr">
			<!-- 备注1 -->
			<div id="${tr.id}" class="remarkDiv" style="height: 60px;">
				<img title="${tr.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${tr.noteContent}</h5>
					<font color="gray">交易</font> <font color="gray">-</font> <b>${tran.customerId}-${tran.name}</b> <small style="color: gray;"> ${tr.editFlag==0?tr.createTime:tr.editTime} 由${tr.editFlag==0?tr.createBy:tr.editBy}${tr.editFlag==0?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="edit" trId="${tr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="del" trId="${tr.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		
		<%--<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">交易</font> <font color="gray">-</font> <b>动力节点-交易01</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>
		--%>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveReBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建人</td>
							<td>创建时间</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<c:forEach items="${tranHistoryList}" var="th">
							<tr>
								<td>${th.stage}</td>
								<td>${th.money}</td>
								<td>${th.possi}%</td>
								<td>${th.expectedDate}</td>
								<td>${th.createBy}</td>
								<td>${th.createTime}</td>
							</tr>
						</c:forEach>

						<%--<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>