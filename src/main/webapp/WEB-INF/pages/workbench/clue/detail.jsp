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

		$("#remarkList").on("mouseover",".remarkDiv",function () {
			$(this).children("div").children("div").show();
		})
		$("#remarkList").on("mouseout",".remarkDiv",function () {
			$(this).children("div").children("div").hide();
		})
		$("#remarkList").on("mouseover",".myHref",function () {
			$(this).children("span").css("color","red");
		})
		$("#remarkList").on("mouseout",".myHref",function () {
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
		});*/

		//给保存按钮添加单击事件
		$("#saveCreateBtn").click(function () {
			//收集参数
			var clueId = '${clue.id}';
			var noteContent = $.trim($("#remark").val());

			if(noteContent==""){
				alert("备注内容不能为空！")
			}else{
				$.ajax({
					url:"workbench/clue/saveCreateClueRemark.do",
					data:{
						clueId:clueId,
						noteContent:noteContent
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							$("#remark").val("")
							var htmlStr = '';
							htmlStr+='<div id=div-'+data.retData.id+' class="remarkDiv" style="height: 60px;">';
							htmlStr+='<img title="${sessionScope.sessionUser.name}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
							htmlStr+='<div style="position: relative; top: -40px; left: 40px;" >';
							htmlStr+='<h5>'+noteContent+'</h5>';
							htmlStr+='<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> '+data.retData.createTime+' 由${sessionScope.sessionUser.name}创建</small>';
							htmlStr+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
							htmlStr+='<a class="myHref" name="editBtn" reId='+data.retData.id+' href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>';
							htmlStr+='&nbsp;&nbsp;&nbsp;&nbsp;';
							htmlStr+='<a class="myHref" name="delBtn" reId='+data.retData.id+' href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>';
							htmlStr+='</div>';
							htmlStr+='</div>';
							htmlStr+='</div>';

							$("#remarkDiv").before(htmlStr);
						}else {
							alert(data.message);
						}
					}
				})
			}
		})


		//给所有的编辑图标添加单击事件
		$("#remarkList").on("click","a[name=editBtn]",function () {
			var id = $(this).attr("reId");
			var noteContent = $("#div-"+id+ " h5").text()
			$("#clueReId").val(id);
			$("#noteContent").val(noteContent)
			$("#editClueModal").modal("show")
		})
		//给更新按钮绑定单击事件
		$("#updateClueReBtn").click(function () {
			var id = $("#clueReId").val();
			var noteContent = $("#noteContent").val();
			if(noteContent==""){
				alert("备注内容不能为空！")
			}else{
				$.ajax({
					url:"workbench/clue/saveEditClueRemark.do",
					data:{
						id,
						noteContent
					},
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							$("#editClueModal").modal("hide")
							$("#div-"+id+ " h5").text(noteContent);
							$("#div-"+id+ " small").html(' '+data.retData.editTime+' 由${sessionScope.sessionUser.name}修改');
						}else {
							alert(data.message);
						}
					}
				})
			}
		})

		//给所有的删除图标绑定单击事件
		$("#remarkList").on("click","a[name=delBtn]",function () {
			var id = $(this).attr("reId");
			$.ajax({
				url:"workbench/clue/deleteClueRemarkById.do",
				data:{
					id:id
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						$("#div-"+id).remove();
					}else {
						alert(data.message);
					}
				}
			})
		})

		//给关联市场活动按钮添加单击事件
		$("#relationBtn").click(function () {
			$("#tBody").html("");
			$("#queryTxt").val("");
			$("#bundModal").modal("show")
		})

		//给查询输入框添加键盘弹起事件
		$("#queryTxt").keyup(function () {
			var name = $("#queryTxt").val();
			var clueId = '${clue.id}';
			$("#checkAll").prop("checked",false);
			$.ajax({
				url:"workbench/clue/queryActivityDetailByName.do",
				data:{
					name:name,
					clueId:clueId
				},
				type:"post",
				dataType:"json",
				success:function (data) {

					var htmlStr = '';
					$.each(data,function (index,obj) {
						htmlStr+='<tr>';
						htmlStr+='<td><input value="'+obj.id+'" type="checkbox"/></td>';
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

		//给全选框添加单击事件
		$("#checkAll").click(function () {
			$("#tBody input[type=checkbox]").prop("checked",this.checked)
		})
		//给列表中的复选框添加单击事件
		$("#tBody").on("click","input[type=checkbox]",function () {
			$("#checkAll").prop("checked",$("#tBody input[type=checkbox]").length==$("#tBody input[type=checkbox]:checked").length)
		})

		//给关联按钮添加单击事件
		$("#retBtn").click(function () {
			var clueId = '${clue.id}';
			var check = $("#tBody input[type=checkbox]:checked");
			if(check.length==0){
				alert("请选择要关联的市场活动")
			}else {
				var ids = '';
				$.each(check,function () {
					ids+="activityId="+this.value+"&";
				})
				ids+="clueId="+clueId;

				$.ajax({
					url:"workbench/clue/saveBundActivity,do",
					data:ids,
					type:"post",
					dataType:"json",
					success:function (data) {
						if(data.code=="1"){
							$("#bundModal").modal("hide");
							var htmlStr='';
							$.each(data.retData,function (index,obj) {
								htmlStr+='<tr id='+obj.id+'>';
								htmlStr+='<td>'+obj.name+'</td>';
								htmlStr+='<td>'+obj.startDate+'</td>';
								htmlStr+='<td>'+obj.endDate+'</td>';
								htmlStr+='<td>'+obj.owner+'</td>';
								htmlStr+='<td><a href="javascript:void(0);" activityId='+obj.id+' style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
								htmlStr+='</tr>';
							})
							$("#ttBody").append(htmlStr);
						}else {
							alert(data.message);
						}
					}
				})
			}
		})

		//给解除关联按钮添加单击事件
		$("#ttBody").on("click","a",function () {
			var clueId='${clue.id}';
			var activityId = $(this).attr("activityId");
			$.ajax({
				url:"workbench/clue/deleteActivityRelation.do",
				data:{
					clueId:clueId,
					activityId:activityId
				},
				type:"post",
				dataType:"json",
				success:function (data) {
					if(data.code=="1"){
						$("#"+activityId).remove();
					}else {
						alert(data.message);
					}
				}
			})
		})
	});
	
</script>

</head>
<body>
<!-- 修改线索备注的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
	<%-- 备注的id --%>
	<input type="hidden" id="clueReId">
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
				<button type="button" class="btn btn-primary" id="updateClueReBtn">更新</button>
			</div>
		</div>
	</div>
</div>
	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input id="queryTxt" type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="checkAll"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="tBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="retBtn">关联</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullName}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.do?id=${clue.id}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			
		</div>
	</div>
	
	<br/>
	<br/>
	<br/>

	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullName}${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mPhone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkList" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<c:forEach items="${clueRemarkList}" var="re">
			<!-- 备注1 -->
			<div id="div-${re.id}" class="remarkDiv" style="height: 60px;">
				<img title="${re.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
				<div style="position: relative; top: -40px; left: 40px;" >
					<h5>${re.noteContent}</h5>
					<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullName}${clue.appellation}-${clue.company}</b> <small style="color: gray;"> ${re.editFlag==0?re.createTime:re.editTime} 由${re.editFlag==0?re.createBy:re.editBy}${re.editFlag==0?'创建':'修改'}</small>
					<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
						<a class="myHref" name="editBtn" reId="${re.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
						&nbsp;&nbsp;&nbsp;&nbsp;
						<a class="myHref" name="delBtn" reId="${re.id}" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
					</div>
				</div>
			</div>
		</c:forEach>

		
		<%--<!-- 备注2 -->
		<div class="remarkDiv" style="height: 60px;">
			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
			<div style="position: relative; top: -40px; left: 40px;" >
				<h5>呵呵！</h5>
				<font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>
				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>
				</div>
			</div>
		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="saveCreateBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="ttBody">
						<c:forEach items="${activityList}" var="ac">
							<tr id="${ac.id}">
								<td>${ac.name}</td>
								<td>${ac.startDate}</td>
								<td>${ac.endDate}</td>
								<td>${ac.owner}</td>
								<td><a href="javascript:void(0);" activityId="${ac.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
							</tr>
						</c:forEach>

						<%--<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="relationBtn" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>