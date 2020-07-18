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

	<script type="text/javascript">
		$(function () {
			//给全选按钮绑定单击事件
			$("#checkAll").click(function () {
				$("#tBody input[type=checkbox]").prop("checked",$(this).prop("checked"));
			})
			//给列表中的复选框添加单击事件
			$("#tBody input[type=checkbox]").click(function () {
				if($("#tBody input[type=checkbox]").length==$("#tBody input[type=checkbox]:checked").length){
					$("#checkAll").prop("checked",true);
				}else {
					$("#checkAll").prop("checked",false);
				}
			})

			//给编辑按钮添加单击事件
			$("#editBtn").click(function () {
				//收集参数
				if($("#tBody input[type=checkbox]:checked").length==0){
					alert("请选择要编辑的数据！");
				}else if($("#tBody input[type=checkbox]:checked").length>1){
					alert("只能选择一条数据编辑！");
				}else {
					var code = $("#tBody input[type=checkbox]:checked").val();
					window.location.href = "settings/dictionary/type/edit.do?code="+code;

				}
			})

			//给删除按钮添加单击事件
			$("#delBtn").click(function () {
				//收集参数
				if($("#tBody input[type=checkbox]:checked").length==0){
					alert("请选择要删除的数据！");
				}else {
					var codes = $("#tBody input[type=checkbox]:checked");
					var codeStr = '';
					$.each(codes,function () {
						codeStr += "code="+ this.value+"&";
					})
					codeStr=codeStr.substr(0,codeStr.length-1);
					if(window.confirm("确定删除吗？")){
						$.ajax({
							url:"settings/dictionary/type/deleteDicTypeByCodes.do",
							data:codeStr,
							type:"post",
							dataType:"json",
							success:function (data) {
								if(data.code=="0"){
									alert(data.message);
								}else {
									window.location.href="settings/dictionary/type/index.do";
								}
							}
						})
					}
				}
			})
		})
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/type/save.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button id="editBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button id="delBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAll" /></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="tBody">
			<c:forEach var="dicType" items="${dicTypeList}" varStatus="vs">
				<tr class="active">
					<td><input type="checkbox" value="${dicType.code}"/></td>
					<td>${vs.count}</td>
					<td>${dicType.code}</td>
					<td>${dicType.name}</td>
					<td>${dicType.description}</td>
				</tr>
			</c:forEach>

			</tbody>
		</table>
	</div>
	
</body>
</html>