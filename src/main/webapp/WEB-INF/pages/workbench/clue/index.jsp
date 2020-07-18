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
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!--  PAGINATION plugin -->
	<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
	<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript">

	$(function(){
		
		queryClueForPageByCondition(1,10);
		//给搜索按钮添加单击事件
		$("#queryBtn").click(function () {
			queryClueForPageByCondition(1,$("#demo_page").bs_pagination("getOption","rowsPerPage"))
		})

		//给全选按钮绑定单击事件
		$("#checkAll").click(function () {
			$("#tBody input[type=checkbox]").prop("checked",this.checked);
		})
		//给列表中的复选框绑定单击事件
		$("#tBody").on("click",$("input[type=checkbox]"),function () {
			$("#checkAll").prop("checked",$("#tBody input[type=checkbox]").length==$("#tBody input[type=checkbox]:checked").length)
		})
		$(".myDate").datetimepicker({
			language: "zh-CN",//语言
			format: "yyyy-mm-dd",//日期格式
			minView: "month",//日期选择器上最小能选择的日期的视图
			initData: new Date(),//日历的初始化时间，默认当前时间
			autoclose: true,//选择日期后，是否自动关闭日历
			todayBtn: true,//是否显示当前日期的按钮
			clearBtn: true,//是否显示清空按钮
			container:"#createClueModal" //在创建的模态窗口上加日历

		})
		$(".myDate1").datetimepicker({
			language: "zh-CN",//语言
			format: "yyyy-mm-dd",//日期格式
			minView: "month",//日期选择器上最小能选择的日期的视图
			initData: new Date(),//日历的初始化时间，默认当前时间
			autoclose: true,//选择日期后，是否自动关闭日历
			todayBtn: true,//是否显示当前日期的按钮
			clearBtn: true,//是否显示清空按钮
			container:"#editClueModal" //在创建的模态窗口上加日历

		})


		//给创建按钮绑定单击事件
		 $("#createBtn").click(function () {
			$("#clueForm")[0].reset();
			 $("#create-clueOwner").val('${sessionScope.sessionUser.id}');
		 	$("#createClueModal").modal("show");
		 })
		//给保存按钮绑定单击事件
		$("#saveCreateBtn").click(function () {
			//收集参数
			var owner = $("#create-clueOwner").val();
			var company = $.trim($("#create-company").val());
			var appellation = $("#create-call").val();
			var fullName = $.trim($("#create-surname").val());
			var job = $.trim($("#create-job").val());
			var email = $.trim($("#create-email").val());
			var phone = $.trim($("#create-phone").val());
			var state = $("#create-status").val();
			var source = $("#create-source").val();
			var mPhone = $.trim($("#create-mphone").val());
			var website = $.trim($("#create-website").val());
			var description = $.trim($("#create-describe").val());
			var contactSummary = $.trim($("#create-contactSummary").val());
			var nextContactTime = $("#create-nextContactTime").val();
			var address = $.trim($("#create-address").val());

			//表单验证
			if (owner == "") {
				alert("所有者不能为空！");
				return;
			}
			if (company == "") {
				alert("公司不能为空！");
				return;
			}
			if (fullName == "") {
				alert("姓名不能为空！");
				return;
			}
			var regExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(email!='' && !regExp.test(email)){
				alert("邮箱格式不正确！")
				return;
			}
			regExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if(phone!='' && !regExp.test(phone)){
				alert("公司座机格式不正确！")
				return;
			}
			regExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(mPhone!='' && !regExp.test(mPhone)){
				alert("手机电话格式不正确！")
				return;
			}
			regExp = /[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/;
			if(website!='' && !regExp.test(website)){
				alert("公司网站格式不正确！")
				return;
			}
			//发送请求
			$.ajax({
				url:"workbench/clue/saveCreateClue.do",
				data:{
					owner:owner,
					company:company,
					appellation:appellation,
					fullName:fullName,
					job:job,
					email:email,
					phone:phone,
					state:state,
					source:source,
					mPhone:mPhone,
					website:website,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						queryClueForPageByCondition(1,$("#demo_page").bs_pagination("getOption","rowsPerPage"));
						$("#createClueModal").modal("hide");
					}else {
						alert(data.message);
						$("#createClueModal").modal("show");
					}
				}
			})
		})


		//给修改按钮添加单击事件
		$("#editBtn").click(function () {
			var checks = $("#tBody input[type=checkbox]:checked");
			if(checks.length==0){
				alert("请选择要修改的记录！")
			}else if (checks.length>1){
				alert("请选择一条记录进行修改！")
			}else {
				$.ajax({
					url:"workbench/clue/queryClueById.do",
					data:{
						id:checks.val()
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						$("#edit-id").val(checks.val());
						$("#edit-clueOwner").val(data.owner);
						$("#edit-company").val(data.company);
						$("#edit-call").val(data.appellation);
						$("#edit-surname").val(data.fullName);
						$("#edit-job").val(data.job);
						$("#edit-email").val(data.email);
						$("#edit-phone").val(data.phone);
						$("#edit-website").val(data.website);
						$("#edit-mphone").val(data.mPhone);
						$("#edit-status").val(data.state);
						$("#edit-source").val(data.source);
						$("#edit-describe").val(data.description);
						$("#edit-contactSummary").val(data.contactSummary);
						$("#edit-nextContactTime").val(data.nextContactTime);
						$("#edit-address").val(data.address);
						$("#editClueModal").modal("show")
					}
				})
			}
		})
		//给更新按钮添加单击事件
		$("#saveEditBtn").click(function () {
			//收集参数
			var id=$("#edit-id").val();
			var owner=$("#edit-clueOwner").val();
			var company=$("#edit-company").val();
			var appellation=$("#edit-call").val();
			var fullName=$("#edit-surname").val();
			var job=$("#edit-job").val();
			var email=$("#edit-email").val();
			var phone=$("#edit-phone").val();
			var website=$("#edit-website").val();
			var mPhone=$("#edit-mphone").val();
			var state=$("#edit-status").val();
			var source=$("#edit-source").val();
			var description=$("#edit-describe").val();
			var contactSummary=$("#edit-contactSummary").val();
			var nextContactTime=$("#edit-nextContactTime").val();
			var address=$("#edit-address").val();
			$("#editClueModal").modal("show")
			//表单验证
			if (owner == "") {
				alert("所有者不能为空！");
				return;
			}
			if (company == "") {
				alert("公司不能为空！");
				return;
			}
			if (fullName == "") {
				alert("姓名不能为空！");
				return;
			}
			var regExp = /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
			if(email!='' && !regExp.test(email)){
				alert("邮箱格式不正确！")
				return;
			}
			regExp = /\d{3}-\d{8}|\d{4}-\d{7}/;
			if(phone!='' && !regExp.test(phone)){
				alert("公司座机格式不正确！")
				return;
			}
			regExp = /^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/;
			if(mPhone!='' && !regExp.test(mPhone)){
				alert("手机电话格式不正确！")
				return;
			}
			regExp = /[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/;
			if(website!='' && !regExp.test(website)){
				alert("公司网站格式不正确！")
				return;
			}
			//发送请求
			 $.ajax({
			 	url:"workbench/clue/saveEditClue.do",
			 	data:{
					id:id,
					owner:owner,
					company:company,
					appellation:appellation,
					fullName:fullName,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mPhone:mPhone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
			 	},
			 	type:"post",
			 	dataType:"json",
			 	success:function (data) {
			 		if(data.code=="1"){
						$("#editClueModal").modal("hide")
						queryClueForPageByCondition($("#demo_page").bs_pagination("getOption","currentPage"),$("#demo_page").bs_pagination("getOption","rowsPerPage"))
			 		}else {
			 			alert(data.message);
						$("#editClueModal").modal("show")
			 		}
			 	}
			 })
		})


		//给删除按钮绑定单击事件
		$("#delBtn").click(function () {
			var checks = $("#tBody input[type=checkbox]:checked");
			if(checks.length==0){
				alert("请选择要删除的记录！")
			}else {
				var ids = "";
				$.each(checks,function (index,obj) {
					ids+="id="+this.value;
					if(index<checks.length-1){
						ids+="&"
					}
				})
				if(confirm("确定删除吗？")){
					$.ajax({
						url:"workbench/clue/deleteClueByIds.do",
						data:ids,
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data.code=="1"){
								queryClueForPageByCondition($("#demo_page").bs_pagination("getOption","currentPage"),$("#demo_page").bs_pagination("getOption","rowsPerPage"))
							}else {
								alert(data.message);
							}
						}
					})
				}
			}
		})
	});

	//分页函数
	function queryClueForPageByCondition(pageNo,pageSize) {
		//收集参数
		var fullName=$("#query-fullName").val();
		var owner=$("#query-owner").val();
		var company=$("#query-company").val();
		var phone=$("#query-phone").val();
		var mPhone=$("#query-mPhone").val();
		var stage=$("#query-stage").val();
		var source=$("#query-source").val();
		$.ajax({
			url:"workbench/clue/queryClueForPageByCondition.do",
			data:{
				beginNo:(pageNo-1)*pageSize,
				pageSize:pageSize,
				fullName:fullName,
				owner:owner,
				company:company,
				phone:phone,
				mPhone:mPhone,
				stage:stage,
				source:source
			},
			type:"post",
			dataType:"json",
			success:function (data) {
				var htmlStr="";
				//遍历
				$.each(data.clueList,function (index,obj) {
					//拼接html
					htmlStr+='<tr>';
					htmlStr+='<td><input type="checkbox" value='+obj.id+' /></td>';
					htmlStr+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+obj.id+'\';">'+obj.fullName+obj.appellation+'</a></td>';
					htmlStr+='<td>'+obj.company+'</td>';
					htmlStr+='<td>'+obj.phone+'</td>';
					htmlStr+='<td>'+obj.mPhone+'</td>';
					htmlStr+='<td>'+obj.source+'</td>';
					htmlStr+='<td>'+obj.owner+'</td>';
					htmlStr+='<td>'+obj.state+'</td>';
					htmlStr+='</tr>';
				})
				//把拼接好的html放到tbody中
				$("#tBody").html(htmlStr);

				//计算总页数
				var totalPages = 1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else {
					totalPages=parseInt(data.totalRows/pageSize) +1;
				}
				//使用分页插件
				$("#demo_page").bs_pagination({
					currentPage: pageNo,//当前页
					rowsPerPage: pageSize,//每页显示条数
					totalRows: data.totalRows,//总条数
					totalPages: totalPages,//总页数

					visiblePageLinks: 5,//显示的翻页卡片数

					showGoToPage: true,//是否显示 跳转到第几页
					showRowsPerPage: true,//是否显示 每页显示条数
					showRowsInfo: true,//是否显示 记录的信息

					//每次切换页号都会自动触发此函数，函数能够返回切换之后的页号和每页显示条数
					onChangePage: function (e, pageObj) {
						$("#checkAll").prop("checked",false);
						queryClueForPageByCondition(pageObj.currentPage, pageObj.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form id="clueForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-clueOwner">
								  <option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-call">
								  <option></option>
									<c:forEach items="${appellation}" var="ap">
										<option value="${ap.id}">${ap.value}</option>
									</c:forEach>

								</select>
							</div>
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-status">
									<option></option>
									<c:forEach items="${stage}" var="stage">
										<option value="${stage.id}" >${stage.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${source}" var="source">
									  <option value="${source.id}">${source.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate" readonly id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<option></option>
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<option></option>
									<c:forEach items="${appellation}" var="ap">
										<option value="${ap.id}">${ap.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<option></option>
									<c:forEach items="${stage}" var="stage">
										<option value="${stage.id}" >${stage.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${source}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control myDate1" readonly id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input id="query-fullName" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input id="query-company" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input id="query-phone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select id="query-source" class="form-control">
						  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input id="query-owner" class="form-control" type="text">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input id="query-mPhone" class="form-control" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select id="query-stage" class="form-control">
						  <option></option>
						  <c:forEach items="${stage}" var="stage">
							  <option value="${stage.id}" >${stage.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button id="queryBtn" type="button" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button id="createBtn" type="button" class="btn btn-primary" ><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button id="editBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button id="delBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>


			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="tBody">
						<%--<tr>
							<td><input type="checkbox" /></td>
							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
							<td>动力节点</td>
							<td>010-84846003</td>
							<td>12345678901</td>
							<td>广告</td>
							<td>zhangsan</td>
							<td>已联系</td>
						</tr>
                        <tr class="active">
                            <td><input type="checkbox" /></td>
                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">李四先生</a></td>
                            <td>动力节点</td>
                            <td>010-84846003</td>
                            <td>12345678901</td>
                            <td>广告</td>
                            <td>zhangsan</td>
                            <td>已联系</td>
                        </tr>--%>
					</tbody>
				</table>
				<div id="demo_page"></div>
			</div>
			
			<%--<div style="height: 50px; position: relative;top: 60px;">
				<div>
					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>
				</div>
				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">
					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>
					<div class="btn-group">
						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
							10
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="#">20</a></li>
							<li><a href="#">30</a></li>
						</ul>
					</div>
					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
				</div>
				<div style="position: relative;top: -88px; left: 285px;">
					<nav>
						<ul class="pagination">
							<li class="disabled"><a href="#">首页</a></li>
							<li class="disabled"><a href="#">上一页</a></li>
							<li class="active"><a href="#">1</a></li>
							<li><a href="#">2</a></li>
							<li><a href="#">3</a></li>
							<li><a href="#">4</a></li>
							<li><a href="#">5</a></li>
							<li><a href="#">下一页</a></li>
							<li class="disabled"><a href="#">末页</a></li>
						</ul>
					</nav>
				</div>
			</div>--%>
			
		</div>
		
	</div>
</body>
</html>