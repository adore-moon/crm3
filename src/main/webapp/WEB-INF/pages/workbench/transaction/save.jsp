<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
	<base href="<%=basePath%>"/>
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript">
	$(function () {
		$(".myDate").datetimepicker({
			language: "zh-CN",//语言
			format: "yyyy-mm-dd",//日期格式
			minView: "month",//日期选择器上最小能选择的日期的视图
			initData: new Date(),//日历的初始化时间，默认当前时间
			autoclose: true,//选择日期后，是否自动关闭日历
			todayBtn: true,//是否显示当前日期的按钮
			clearBtn: true,//是否显示清空按钮
			//container:"#query-div" //在创建的模态窗口上加日历

		})
		//$("#create-transactionOwner").val('${sessionScope.sessionUser.id}')

		//给阶段框添加change事件
		$("#create-transactionStage").change(function () {
			var stage = $("#create-transactionStage option:selected").text();
			if(stage==''){
				$("#create-possibility").val('');
				return;
			}
			$.ajax({
				url:"workbench/transaction/getPossibility.do",
				data:{
					stage:stage
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					$("#create-possibility").val(data+'%');
				}
			})
		})

		//给市场活动源添加单击事件
		$("#searchActivityBtn").click(function () {
			$("#findMarketActivity").modal("show")
		})
		$("#queryActivityTxt").keyup(function () {
			var name = $("#queryActivityTxt").val();
			$.ajax({
				url:"workbench/transaction/queryActDetailByName.do",
				data:{
					name:name
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = '';
					$.each(data,function (index,obj) {
						htmlStr+='<tr>';
						htmlStr+='<td><input type="radio" name="activity" actname=\''+obj.name+'\' value=\''+obj.id+'\'/></td>';
						htmlStr+='<td>'+obj.name+'</td>';
						htmlStr+='<td>'+obj.startDate+'</td>';
						htmlStr+='<td>'+obj.endDate+'</td>';
						htmlStr+='<td>'+obj.owner+'</td>';
						htmlStr+='</tr>';
					})
					$("#tBodyAct").html(htmlStr);
				}
			})
		})
		//给单选按钮添加单击事件
		$("#tBodyAct").on("click","input[type=radio]",function () {
			var id = $(this).val();
			var actName = $(this).attr("actname");
			$("#actId").val(id);
			$("#create-activitySrc").val(actName);
			$("#findMarketActivity").modal("hide")
		})

		//给联系人名称添加单击事件
		$("#searchContactsBtn").click(function () {
			$("#findContacts").modal("show")
		})
		$("#searchConTxt").keyup(function () {
			var fullName = $("#searchConTxt").val();
			$.ajax({
				url:"workbench/transaction/queryContactsByFullName.do",
				data:{
					fullName:fullName
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = '';
					$.each(data,function (index,obj) {
						htmlStr+='<tr>';
						htmlStr+='<td><input type="radio" name="activity" ConName=\''+obj.fullName+'\' value=\''+obj.id+'\' ></td>';
						htmlStr+='<td>'+obj.fullName+'</td>';
						htmlStr+='<td>'+obj.email+'</td>';
						htmlStr+='<td>'+obj.mPhone+'</td>';
						htmlStr+='</tr>';

					})
					$("#tBodyCon").html(htmlStr);
				}
			})
		})
		//给单选按钮添加单击事件
		$("#tBodyCon").on("click","input[type=radio]",function () {
			var id = $(this).val();
			var conName = $(this).attr("ConName");
			$("#conId").val(id);
			$("#create-contactsName").val(conName);
			$("#findContacts").modal("hide")
		})


		var nameAid = {};
		$("#create-accountName").typeahead({
			//query是用户输入的关键字
			//process是能够把一个json字符串数组交给source使用
			source:function (query,process) {
				$.ajax({
					url:"workbench/transaction/queryCustomerByName.do",
					data:{
						customerName:query
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						var customerName = [];
						$.each(data,function (index,obj) {
							customerName.push(obj.name);
							nameAid[obj.name]=obj.id;
						})
						process(customerName);
					}
				})
			},
			afterSelect:function (item) {
				//用户选中后自动触发补全信息
				//item:选中后自动补全的名称
				$("#cusId").val(nameAid[item])
			}
		})


		//给保存按钮绑定单击事件
		$("#saveCreateBtn").click(function () {
			//收集参数
			var owner =$("#create-transactionOwner").val();
			var money =$.trim($("#create-amountOfMoney").val());
			var name =$.trim($("#create-transactionName").val());
			var expectedDate =$("#create-expectedClosingDate").val();
			var customerId =$("#cusId").val();
			var stage =$("#create-transactionStage").val();
			var type =$("#create-transactionType").val();
			var source =$("#create-clueSource").val();
			var activityId =$("#actId").val();
			var contactsId =$("#conId").val();
			var description =$.trim($("#create-describe").val());
			var contactSummary =$.trim($("#create-contactSummary").val());
			var nextContactTime =$("#create-nextContactTime").val();
			var customerName =$.trim($("#create-accountName").val());
			//表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			var regExp = /^(([1-9]\d*)|0)$/;
			if (!regExp.test(money)) {
				alert("金额只能是非负整数");
				return;
			}
			if(name==""){
				alert("名称不能为空");
				return;
			}
			if(expectedDate==""){
				alert("预计交易日期不能为空");
				return;
			}
			if(customerName==""){
				alert("客户名称不能为空");
				return;
			}
			if(stage==""){
				alert("阶段不能为空");
				return;
			}
			$.ajax({
				url:"workbench/transaction/saveCreateTran.do",
				data:{
					owner:owner,
					money:money,
					name:name,
					expectedDate:expectedDate,
					customerId:customerId,
					stage:stage,
					type:type,
					source:source,
					activityId:activityId,
					contactsId:contactsId,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					customerName:customerName
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						window.location.href="workbench/transaction/index.do";
					}else {
						alert(data.message)
					}
				}
			})

		})

	})
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="queryActivityTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="tBodyAct">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" id="searchConTxt" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="tBodyCon">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveCreateBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
				  <option></option>
					<c:forEach items="${users}" var="u">
						<option value="${u.id}" ${u.id eq sessionUser.id ? "selected":""}>${u.name}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" readonly id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="cusId">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
				  <c:forEach items="${stageList}" var="st">
					  <option value="${st.id}">${st.value}</option>
				  </c:forEach>


			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.id}">${t.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" readonly id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
					<option></option>
					<c:forEach items="${sourceList}" var="so">
						<option value="${so.id}">${so.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="actId">
				<input type="text" class="form-control" readonly id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="conId">
				<input type="text" class="form-control" readonly id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control myDate" readonly id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>