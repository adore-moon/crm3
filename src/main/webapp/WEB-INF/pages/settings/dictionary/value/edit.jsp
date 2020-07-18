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

	<script type="text/javascript">
		$(function () {
			$("#edit-dicValue").focus(function () {
				$("#msg").text("")
			})
			$("#edit-dicValue").blur(function () {
				yanzheng();
			})
			//给更新按钮绑定单击事件
			$("#saveEditBtn").click(function () {
				var id = $("#edit-id").val();
				var value = $.trim($("#edit-dicValue").val());
				var text = $.trim($("#edit-text").val());
				var orderNo = $.trim($("#edit-orderNo").val());

				if(yanzheng()){
					$.ajax({
						url:"settings/dictionary/value/saveEditDicValue.do",
						data:{
							id:id,
							value:value,
							text:text,
							orderNo:orderNo
						},
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data.code=="1"){
								window.location.href="settings/dictionary/value/index.do";
							}else {
								alert(data.message)
							}
						}
					})
				}
			})
		})

		function yanzheng() {
			//收集参数
			var value = $.trim($("#edit-dicValue").val());
			var typeCode = $("#edit-dicTypeCode").val();

			var result = false;
			//表单验证
			if(value==""){
				$("#msg").text("字典值不能为空！");
				return false;
			}else {
				$("#msg").text("");
			}

			$.ajax({
				url:"settings/dictionary/value/selectDicValueByTypeAndValue.do",
				data:{
					value:value,
					typeCode:typeCode
				},
				//修改为同步请求，必须先等自己执行完拿到return值，其他请求才继续执行
				async:false,
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="0"){
						$("#msg").text(data.message);
						result= false;
					}else {
						$("#msg").text("");
						result= true;
					}
				}
			})
			return result;
		}
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveEditBtn" type="button" class="btn btn-primary">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
		<input type="hidden" id="edit-id" value="${dicValue.id}">
		<div class="form-group">
			<label for="edit-dicTypeCode" class="col-sm-2 control-label">字典类型编码</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-dicTypeCode" style="width: 200%;" value="${dicValue.typeCode}" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-dicValue" style="width: 200%;" value="${dicValue.value}">
				<span id="msg" style="color: red"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-text" style="width: 200%;" value="${dicValue.text}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-orderNo" style="width: 200%;" value="${dicValue.orderNo}">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>