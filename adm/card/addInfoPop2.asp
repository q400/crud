<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop2.asp - 직원부가정보 (가족정보) 관리
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
				+ "<td></td>"
				+ "<td><input type=\"text\" name=\"fam_nm\" id=fam_nm style=\"width:130px;\" maxlength=20 placeholder=\"띄어쓰기 없이\" /></td>"		//성명
				+ "<td><input type=\"text\" name=\"fam_rel\" id=fam_rel style=\"width:130px;\" maxlength=20 /></td>"		//관계
				+ "<td><input type=\"text\" name=\"fam_etc\" id=fam_etc style=\"width:90%;\" maxlength=100 /></td>"	//비고
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
				$("#fm1").attr({action:"addInfoPop2_x.asp", method:"POST", target:"nullframe"}).submit();
			}
		}
	});
	$("#btnReload").click(function (){
		$("#fm1").attr({action:"addInfoPop2.asp", method:"POST"}).submit();
	});
	$("#btnSave").click(function (){
		$("#flag").val("W");
		$("#fm1").attr({action:"addInfoPop2_x.asp", method:"POST", target:"nullframe"}).submit();
	});
});
</script>


<form name=fm1 id=fm1 method="POST">
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
<input type="hidden" name="flag" id="flag" />
<div>
	<div class="mt5 ml5 mb5">
		<button type="button" onclick="location='addInfoPop1.asp?uid=<%=uid%>'" class="">학력정보</button>
		<button type="button" onclick="location='addInfoPop2.asp?uid=<%=uid%>'" class="btn03">가족정보</button>
		<button type="button" onclick="location='addInfoPop3.asp?uid=<%=uid%>'" class="">경력정보</button>
		<button type="button" onclick="location='addInfoPop4.asp?uid=<%=uid%>'" class="">자격증정보</button>
		<button type="button" onclick="location='addInfoPop5.asp?uid=<%=uid%>'" class="">급여정보</button>
		<button type="button" onclick="location='addInfoPop6.asp?uid=<%=uid%>'" class="">인사고과정보</button>
	</div>
	<div class=""><!-- 가족정보 -->
		<table width=100% id="list1">
			<colgroup>
				<col style="width:2%;" /><!-- 선택 -->
				<col style="width:20%;" /><!-- 성명 -->
				<col style="width:20%;" /><!-- 관계 -->
				<col /><!-- 비고 -->
			</colgroup>
			<thead>
				<tr>
					<th height=30 colspan=10>
						<span class="flt mt5 ml20 f17 fc3">가족정보</span>
						<span class="frt mr10"><button type="button" id="btnAdd" />추가</button></span>
					</th>
				</tr>
				<tr height=30>
					<th></th>
					<th>성명</th>
					<th>관계</th>
					<th>비고</th>
				</tr>
			</thead>
			<tbody>
<%
	rso()
	SQL = " SELECT * FROM memt040 WHERE uid = '"& uid &"' ORDER BY rgdt "
	rs.open SQL, dbcon, 3
	If Not rs.Bof Or Not rs.Eof Then
		i = 0
		rs.MoveFirst
		Do Until rs.EOF
%>
				<tr height=34>
					<td><input type="checkbox" name="chk" id="chk<%=i%>" value="<%=rs("seq")%>"></td>
					<td><input type="text" name="fam_nm" id=fam_nm style="width:100%;" maxlength=20 value="<%=rs("fam_nm")%>" /></td><!-- 성명 -->
					<td><input type="text" name="fam_rel" id=fam_rel style="width:100%;" maxlength=20 value="<%=rs("fam_rel")%>" /></td><!-- 관계 -->
					<td><input type="text" name="fam_etc" id=fam_etc style="width:100%;" maxlength=100 value="<%=rs("fam_etc")%>" /></td><!-- 비고 -->
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
