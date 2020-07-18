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
			$("#create-code").focus(function () {
				$("#msg").text("");
			});

			$("#create-code").blur(function () {
				yanzheng();
			})

			//给保存按钮添加单击事件
			$("#saveBtn").click(function () {
				//收集参数
				var code = $.trim($("#create-code").val());
				var name = $.trim($("#create-name").val());
				var description = $.trim($("#create-describe").val());
				if(yanzheng()){
					$.ajax({
						url:"settings/dictionary/type/saveCreateDicType.do",
						data:{
							code:code,
							name:name,
							description:description
						},
						type:"post",
						dataType:"json",
						success:function (data) {
							if(data.code=="1"){
								window.location.href="settings/dictionary/type/index.do"
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
			var result = false;
			var code = $.trim($("#create-code").val());
			if(code==""){
				$("#msg").text("编码不能为空！");
				return false;
			}else {
				$("#msg").text("");
			}
			$.ajax({
				url:"settings/dictionary/type/selectDicTypeByCode.do",
				data:{
					code:code
				},
				//修改为同步请求，必须先等自己执行完拿到retuan值，其他请求才继续执行
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
		<h3>新增字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button id="saveBtn" type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form">
					
		<div class="form-group">
			<label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-code" style="width: 200%;">
				<span id="msg" style="color: red"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-name" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" id="create-describe" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>