<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop4.asp - 직원부가정보 (자격증정보) 관리
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
				+ "<td><input type=\"text\" name=\"license_nm\" id=license_nm style=\"width:250px;\" maxlength=50 /></td>"		//자격증(외국어)명
				+ "<td><input type=\"text\" name=\"license_lvl\" id=license_lvl style=\"width:100px;\" maxlength=10 /></td>"		//급수
				+ "<td><input type=\"text\" name=\"license_date\" id=license_date style=\"width:130px;\" maxlength=10 placeholder=\"예)2001.03.09\" /></td>"	//취득일자
				+ "<td><input type=\"text\" name=\"license_no\" id=license_no style=\"width:150px;\" maxlength=30 /></td>"		//자격증번호
				+ "<td><input type=\"text\" name=\"license_inst\" id=license_inst style=\"width:150px;\" maxlength=50 /></td>"	//발행기관
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
				$("#fm1").attr({action:"addInfoPop4_x.asp", method:"POST", target:"nullframe"}).submit();
			}
		}
	});
	$("#btnReload").click(function (){
		$("#fm1").attr({action:"addInfoPop4.asp", method:"POST"}).submit();
	});
	$("#btnSave").click(function (){
		if(fnValidation($("#fm1"))) return;		//유효성 체크
		$("#flag").val("W");
		$("#fm1").attr({action:"addInfoPop4_x.asp", method:"POST", target:"nullframe"}).submit();
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
		<button type="button" onclick="location='addInfoPop3.asp?uid=<%=uid%>'" class="">경력정보</button>
		<button type="button" onclick="location='addInfoPop4.asp?uid=<%=uid%>'" class="btn03">자격증정보</button>
		<button type="button" onclick="location='addInfoPop5.asp?uid=<%=uid%>'" class="">급여정보</button>
		<button type="button" onclick="location='addInfoPop6.asp?uid=<%=uid%>'" class="">인사고과정보</button>
	</div>
	<div class=""><!-- 자격증/외국어능력정보 -->
		<table width=100% id="list1">
			<colgroup>
				<col style="width:2%;" /><!-- 선택 -->
				<col style="width:30%;" /><!-- 자격증(외국어)명 -->
				<col style="width:15%;" /><!-- 급수 -->
				<col style="width:15%;" /><!-- 취득일자 -->
				<col style="width:20%;" /><!-- 자격증번호 -->
				<col /><!-- 발행기관 -->
			</colgroup>
			<thead>
				<tr>
					<th height=30 colspan=10>
						<span class="flt mt5 ml20 f17 fc3">자격증/외국어능력정보</span>
						<span class="frt mr10"><button type="button" id="btnAdd" />추가</button></span>
					</th>
				</tr>
				<tr height=30>
					<th></th>
					<th>자격증(외국어)명</th>
					<th>급수</th>
					<th>취득일자</th>
					<th>자격증번호</th>
					<th>발행기관</th>
				</tr>
			</thead>
			<tbody>
<%
	rso()
	SQL = " SELECT * FROM memt060 WHERE uid = '"& uid &"' ORDER BY license_date "
	rs.open SQL, dbcon, 3
	If Not (rs.eof And rs.bof) Then
		i = 0
		rs.MoveFirst
		Do Until rs.EOF
%>
				<tr height=34>
					<td><input type="checkbox" name="chk" id="chk<%=i%>" value="<%=rs("seq")%>"></td>
					<td><input type="text" name="license_nm" id=license_nm style="width:100%;" maxlength=50 value="<%=rs("license_nm")%>" /></td><!-- 자격증(외국어)명 -->
					<td><input type="text" name="license_lvl" id=license_lvl style="width:100%;" maxlength=10 value="<%=rs("license_lvl")%>" /></td><!-- 급수 -->
					<td><input type="text" name="license_date" id=license_date style="width:100%;" maxlength=10 value="<%=rs("license_date")%>" /></td><!-- 취득일자 -->
					<td><input type="text" name="license_no" id=license_no style="width:100%;" maxlength=30 value="<%=rs("license_no")%>" /></td><!-- 자격증번호 -->
					<td><input type="text" name="license_inst" id=license_inst style="width:100%;" maxlength=50 value="<%=rs("license_inst")%>" /></td><!-- 발행기관 -->
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
