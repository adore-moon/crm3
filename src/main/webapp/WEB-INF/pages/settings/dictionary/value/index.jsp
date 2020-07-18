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

			//给全选按钮添加单击事件
			$("#checkAll").click(function () {
				$("#tBody input[type=checkbox]").prop("checked",this.checked);
			})
			//给列表中的复选框添加单击事件
			$("#tBody input[type=checkbox]").click(function () {
				$("#checkAll").prop("checked",$("#tBody input[type=checkbox]").length==$("#tBody input[type=checkbox]:checked").length?true:false);
			})

			//给编辑按钮添加单击事件
			$("#editBtn").click(function () {
				//收集参数
				if($("#tBody input[type=checkbox]:checked").length==0){
					alert("请选择要修改的数据！")
				}else if ($("#tBody input[type=checkbox]:checked").length>1){
					alert("请选择一条记录进行修改！")
				}else {
					id= $("#tBody input[type=checkbox]:checked").val();
					window.location.href="settings/dictionary/value/edit.do?id="+id;
				}
			})

			//给删除按钮绑定单击事件
			$("#delBtn").click(function () {
				//收集参数
				if($("#tBody input[type=checkbox]:checked").length==0){
					alert("请选择要删除的数据！");
				}else {
					var checks = $("#tBody input[type=checkbox]:checked");
					var check = "";
					$.each(checks,function (index,obj) {
						check+="id="+this.value;
						if(index<checks.length-1){
							check+="&";
						}
					})
					if(confirm("确定删除吗？")){
						$.ajax({
							url:"settings/dictionary/value/deleteDicValueByIds.do",
							data:check,
							type:"post",
							dataType:"json",
							success:function (data) {
								if(data.code=="1"){
									window.location.href="settings/dictionary/value/index.do";
								}else {
									alert(data.message);
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
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/save.do'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button id="editBtn" type="button" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button id="delBtn" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="checkAll"/></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="tBody">
			<c:forEach items="${dicValueList}" var="dv" varStatus="vs">
				<tr class="active">
					<td><input type="checkbox" value="${dv.id}" /></td>
					<td>${vs.count}</td>
					<td>${dv.value}</td>
					<td>${dv.text}</td>
					<td>${dv.orderNo}</td>
					<td>${dv.typeCode}</td>
				</tr>
			</c:forEach>

				<%--<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td>f</td>
					<td>女</td>
					<td>2</td>
					<td>sex</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>3</td>
					<td>1</td>
					<td>一级部门</td>
					<td>1</td>
					<td>orgType</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>4</td>
					<td>2</td>
					<td>二级部门</td>
					<td>2</td>
					<td>orgType</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>5</td>
					<td>3</td>
					<td>三级部门</td>
					<td>3</td>
					<td>orgType</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	
</body>
</html>