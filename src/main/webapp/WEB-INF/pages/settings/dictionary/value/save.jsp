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

			$("#create-dicTypeCode").blur(function () {
				yanzheng();
			})
			//给字典值输入框添加失去焦点事件
			$("#create-dicValue").blur(function () {
				yanzheng();
			})
			$("#create-dicTypeCode").focus(function () {
				$("#msg").text("");
			})
			//给字典值输入框添加失去焦点事件
			$("#create-dicValue").focus(function () {
				$("#msg1").text("");
			})


			//给保存按钮添加单击事件
			$("#saveBtn").click(function () {
				//收集参数
				var value = $.trim($("#create-dicValue").val());
				var typeCode = $("#create-dicTypeCode").val();
				var text = $.trim($("#create-text").val());
				var orderNo = $.trim($("#create-orderNo").val());

				if(yanzheng()){
					$.ajax({
						url:"settings/dictionary/value/saveCreateDicValue.do",
						data:{
							value:value,
							typeCode:typeCode,
							text:text,
							orderNo:orderNo
						},
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data.code=="1"){
								window.location.href="settings/dictionary/value/index.do"
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
			var value = $.trim($("#create-dicValue").val());
			var typeCode = $("#create-dicTypeCode").val();

			var result = false;
			//表单验证
			if(typeCode==""){
				$("#msg").text("字典类型编码不能为空！");
				return false;
			}else {
				$("#msg").text("");
			}
			if(value==""){
				$("#msg1").text("字典值不能为空！");
				return false;
			}else {
				$("#msg1").text("");
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
						$("#msg1").text(data.message);
						result= false;
					}else {
						$("#msg1").text("");
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
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-dicTypeCode" style="width: 200%;">
				  <option></option>
					<c:forEach items="${dicTypeList}" var="dt">
						<option value="${dt.code}">${dt.name}</option>
					</c:forEach>
				</select>
				<span id="msg" style="color:red;"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-dicValue" style="width: 200%;">
				<span id="msg1" style="color:red;"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-orderNo" style="width: 200%;">
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>