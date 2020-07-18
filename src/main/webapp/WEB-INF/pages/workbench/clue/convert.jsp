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
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>


<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript">
	$(function(){
		$("#isCreateTransaction").click(function(){
			if(this.checked){
				$("#create-transaction2").show(200);
			}else{
				$("#create-transaction2").hide(200);
			}
		});

		$(".myDate").datetimepicker({
			language: "zh-CN",//语言
			format: "yyyy-mm-dd",//日期格式
			minView: "month",//日期选择器上最小能选择的日期的视图
			initData: new Date(),//日历的初始化时间，默认当前时间
			autoclose: true,//选择日期后，是否自动关闭日历
			todayBtn: true,//是否显示当前日期的按钮
			clearBtn: true,//是否显示清空按钮
			container:"#create-transaction2" //在创建的模态窗口上加日历

		})
		//给市场活动源添加单击事件
		$("#searchAct").click(function () {
			$("#tBody").html("");
			$("#actTxt").val("");
			$("#searchActivityModal").modal("show");
		})
		//给搜索框添加键盘弹起事件
		$("#actTxt").keyup(function () {
			var actName = $("#actTxt").val();
			$.ajax({
				url:"workbench/activity/queryActivityDetailByNameInClue.do",
				data:{
					actName:actName,
					clueId:'${clue.id}'
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					var htmlStr = '';
					$.each(data,function (index,obj) {
						htmlStr+='<tr>';
						htmlStr+='<td><input actName='+obj.name+' type="radio" name="activity" value='+obj.id+' ></td>';
						htmlStr+='<td>'+obj.name+'</td>';
						htmlStr+='<td>'+obj.startDate+'</td>';
						htmlStr+='<td>'+obj.endDate+'</td>';
						htmlStr+='<td>'+obj.owner+'</td>';
						htmlStr+='</tr>';
					})
					$("#tBody").html(htmlStr);


				}
			})
		})
		//给单选按钮绑定单击事件
		$("#tBody").on("click","input[type=radio]",function () {
			$("#actId").val($(this).val());
			$("#activity").val($(this).attr("actName"));
			$("#searchActivityModal").modal("hide");
		})

		//给转换按钮绑定单击事件
		$("#changeBtn").click(function () {
			var clueId = '${clue.id}';
			var isChecked = $("#isCreateTransaction").prop("checked");
			var money =$.trim($("#amountOfMoney").val());
			var name =$.trim($("#tradeName").val());
			var expectedDate =$("#expectedClosingDate").val();
			var stage =$("#stage").val();
			var activityId =$("#actId").val();
			//表单验证
			if(isChecked){
				var regExp =/^(([1-9]\d*)|0)$/;
				if(!regExp.test(money)){
					alert("金额只能为非负整数");
					return;
				}
				if(stage==""){
					alert("请选择相应阶段");
					return;
				}
			}
			//发送请求
			$.ajax({
				url:"workbench/clue/saveConvertClue.do",
				data:{
					clueId:clueId,
					isChecked:isChecked,
					money:money,
					name:name,
					expectedDate:expectedDate,
					stage:stage,
					activityId:activityId
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						window.location.href="workbench/clue/index.do"
					}else{
						alert(data.message)
					}
				}
			})
		})
	});
</script>

</head>
<body>
	
	<!-- 搜索市场活动的模态窗口 -->
	<div class="modal fade" id="searchActivityModal" role="dialog" >
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">搜索市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="actTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
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

	<div id="title" class="page-header" style="position: relative; left: 20px;">
		<h4>转换线索 <small>${clue.fullName}${clue.appellation}-${clue.company}</small></h4>
	</div>
	<div id="create-customer" style="position: relative; left: 40px; height: 35px;">
		新建客户：${clue.company}
	</div>
	<div id="create-contact" style="position: relative; left: 40px; height: 35px;">
		新建联系人：${clue.fullName}${clue.appellation}
	</div>
	<div id="create-transaction1" style="position: relative; left: 40px; height: 35px; top: 25px;">
		<input type="checkbox" id="isCreateTransaction"/>
		为客户创建交易
	</div>
	<div id="create-transaction2" style="position: relative; left: 40px; top: 20px; width: 80%; background-color: #F7F7F7; display: none;" >
	
		<form>
		  <div class="form-group" style="width: 400px; position: relative; left: 20px;">
		    <label for="amountOfMoney">金额</label>
		    <input type="text" class="form-control" id="amountOfMoney">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="tradeName">交易名称</label>
		    <input type="text" class="form-control" id="tradeName" >
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="expectedClosingDate">预计成交日期</label>
		    <input type="text" class="form-control myDate" readonly id="expectedClosingDate">
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="stage">阶段</label>
		    <select id="stage"  class="form-control">
		    	<option></option>
				<c:forEach items="${stageList}" var="stage">
					<option value="${stage.id}" >${stage.value}</option>
				</c:forEach>
		    </select>
		  </div>
		  <div class="form-group" style="width: 400px;position: relative; left: 20px;">
		    <label for="activity">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchAct" style="text-decoration: none;"><span class="glyphicon glyphicon-search"></span></a></label>
			  <input type="hidden" id="actId">
		    <input type="text" class="form-control" id="activity" placeholder="点击上面搜索" readonly>
		  </div>
		</form>
		
	</div>
	
	<div id="owner" style="position: relative; left: 40px; height: 35px; top: 50px;">
		记录的所有者：<br>
		<b>${clue.owner}</b>
	</div>
	<div id="operation" style="position: relative; left: 40px; height: 35px; top: 100px;">
		<input class="btn btn-primary" type="button" id="changeBtn" value="转换">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input class="btn btn-default" type="button" value="取消">
	</div>
</body>
</html>