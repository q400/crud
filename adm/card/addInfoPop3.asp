<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop3.asp - 직원부가정보 (경력정보) 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	dbo()
	uid							= SQLI(Request("uid"))

	If uid = "" Then
		Call AlertClose("ID가 선택되지 않았습니다.")
	End If
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnClose").click(function (){
		simsClosePopup();
	});
	$("#btnAdd").click(function (){		//row 추가
		let list = "";
		list = list + "<tr height=34>"
				+ "<td><span style='display:none;'><em class='fc4 ml5'>*</em></span></td>"
				+ "<td><input type=\"text\" name=\"com_nm\" id=com_nm style=\"width:180px;\" maxlength=50 /></td>"		//직장명
				+ "<td><input type=\"text\" name=\"com_sdate\" id=com_sdate style=\"width:40%;\" maxlength=10 placeholder=\"예)2001.03\" />"
				+ " ~ "
				+ "<input type=\"text\" name=\"com_edate\" id=com_edate style=\"width:40%;\" maxlength=10 placeholder=\"예)2003.10\" /></td>"	//재직기간
				+ "<td><input type=\"text\" name=\"com_work\" id=com_work style=\"width:180px;\" maxlength=30 /></td>"	//담당업무
				+ "<td><input type=\"text\" name=\"com_level\" id=com_level style=\"width:90px;\" maxlength=20 /></td>"	//직급
				+ "<td><input type=\"text\" name=\"com_rsn\" id=com_rsn style=\"width:90%;\" maxlength=100 /></td>"	//퇴직사유
				+ "</tr>";
		$("tbody").append(list);
		$("#add").remove();
	});
	$("#btnDelete").click(function (){	//선택삭제
		if($("input[name=chk]:checked").length == 0){
			alert("삭제 대상을 1개 이상 선택하세요.");
			return;
		}else{
			if(confirm("선택 항목을 삭제합니까?")){
				$("#flag").val("D");
				$("#fm1").attr({action:"addInfoPop3_x.asp", method:"POST", target:"nullframe"}).submit();
			}
		}
	});
	$("#btnReload").click(function (){
		$("#fm1").attr({action:"addInfoPop3.asp", method:"POST"}).submit();
	});
	$("#btnSave").click(function (){
		if(fnValidation($("#fm1"))) return;		//유효성 체크
		$("#flag").val("W");
		$("#fm1").attr({action:"addInfoPop3_x.asp", method:"POST", target:"nullframe"}).submit();
	});
});
</script>

<form name=fm1 id=fm1 method="POST">
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
<input type="hidden" name="flag" id="flag" />
<div>
	<div class="mt5 ml5 mb5">
		<button type="button" onclick="location='addInfoPop1.asp?uid=<%=uid%>'" class="">학력정보</button>
		<button type="button" onclick="location='addInfoPop2.asp?uid=<%=uid%>'" class="">가족정보</button>
		<button type="button" onclick="location='addInfoPop3.asp?uid=<%=uid%>'" class="btn03">경력정보</button>
		<button type="button" onclick="location='addInfoPop4.asp?uid=<%=uid%>'" class="">자격증정보</button>
		<button type="button" onclick="location='addInfoPop5.asp?uid=<%=uid%>'" class="">급여정보</button>
		<button type="button" onclick="location='addInfoPop6.asp?uid=<%=uid%>'" class="">인사고과정보</button>
	</div>
	<div class=""><!-- 경력정보 -->
		<table width=100% id="list1">
			<colgroup>
				<col style="width:2%;" /><!-- 선택 -->
				<col style="width:20%;" /><!-- 직장명 -->
				<col style="width:22%;" /><!-- 재직기간 -->
				<col style="width:20%;" /><!-- 담당업무 -->
				<col style="width:10%;" /><!-- 직급 -->
				<col /><!-- 퇴직사유 -->
			</colgroup>
			<thead>
				<tr>
					<th height=30 colspan=10>
						<span class="flt mt5 ml20 f17 fc3">경력정보</span>
						<span class="frt mr10"><button type="button" id="btnAdd" />추가</button></span>
					</th>
				</tr>
				<tr height=30>
					<th></th>
					<th>직장명</th>
					<th>재직기간</th>
					<th>담당업무</th>
					<th>직급</th>
					<th>퇴직사유</th>
				</tr>
			</thead>
			<tbody>
<%
	rso()
	SQL = " SELECT * FROM memt050 WHERE uid = '"& uid &"' ORDER BY com_sdate "
	rs.open SQL, dbcon, 3
	If Not rs.Bof Or Not rs.Eof Then
		i = 0
		rs.MoveFirst
		Do Until rs.EOF
%>
				<tr height=34>
					<td><input type="checkbox" name="chk" id="chk<%=i%>" value="<%=rs("seq")%>"></td>
					<td><input type="text" name="com_nm" id=com_nm style="width:100%;" maxlength=50 value="<%=rs("com_nm")%>" /></td><!-- 직장명 -->
					<td>
						<input type="text" name="com_sdate" id=com_sdate style="width:40%;" maxlength=10 value="<%=rs("com_sdate")%>" />
						~
						<input type="text" name="com_edate" id=com_edate style="width:40%;" maxlength=10 value="<%=rs("com_edate")%>" />
					</td><!-- 재직기간 -->
					<td><input type="text" name="com_work" id=com_work style="width:100%;" maxlength=30 value="<%=rs("com_work")%>" /></td><!-- 담당업무 -->
					<td><input type="text" name="com_level" id=com_level style="width:100%;" maxlength=20 value="<%=rs("com_level")%>" /></td><!-- 직급 -->
					<td><input type="text" name="com_rsn" id=com_rsn style="width:100%;" maxlength=100 value="<%=rs("com_rsn")%>" /></td><!-- 퇴직사유 -->
				</tr>
<%
			rs.MoveNext
			i = i + 1
		Loop
	Else
%>
				<tr height=34 id="add">
					<td colspan=10 class="ct">"추가 버튼을 눌러 정보를 추가하세요."</td>
				</tr>
<%
	End If
	rsc()
%>
			</tbody>
		</table>
	</div>
	<div class="mt10 mb50 ct">
		<button type="button" id="btnSave" class="btn03" />저장</button>
		<button type="button" id="btnDelete" class="btn01" />선택삭제</button>
		<button type="button" id="btnReload" />새로고침</button>
		<button type="button" id="btnClose" />창닫기</button>
	</div>
</div>
</form>
<%	dbc() %>
