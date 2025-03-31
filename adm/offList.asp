<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: offList.asp - 휴무내역표 (관리자)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	time1 = Timer()

	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색어
	cd3							= SQLI(Request("cd3"))			'조직
	cd4							= SQLI(Request("cd4"))			'부서
	page						= SQLI(Request("page"))

	If cd3 <> "" Then cd2 = ""				'조직에 값이 있으면 cd2를 ""처리
	If cd4 <> "" Then cd2 = ""				'부서에 값이 있으면 cd2를 ""처리
	If cd1 = "" Then cd1 = "uid"
	If page = "" Then page = 1

	pagesize = 20							'페이지크기

	param = " WHERE cid = '"& USER_COMP &"'"

	If cd2 <> "" Then						'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' "
	ElseIf cd3 <> "" Then
		param = param &" AND org = '"& cd3 &"' "
	ElseIf cd4 <> "" Then
		param = param &" AND dept = '"& cd4 &"' "
	Else									'검색조건이 없는 경우
		param = param
	End If
'	param = param & " AND rank2 <> 99 "

	'직원수
	rso()
	SQL = " SELECT COUNT(*) FROM memt010 "& param
'	Response.Write "<br>"& SQL &"<br>"
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/20) + 1
	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&cd4="& cd4
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSet").click(function (){		//설정
		let vdt = [];
		let cnt = $("input:checkbox[name='vdt']:checked").length;
		let flag1 = 0;
		let flag2 = 0;

		if(cnt == 0){
			alert("최소 하루 이상 선택하세요.");
			return;
		}else{
			$("input:checkbox[name='vdt']:checked").each(function(e){
				let value = $("input:checkbox[name='vdt']:checked").eq(e).val();
				let yoil = String(value);
				let weekDay = "";

				yoil = yoil.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
				weekDay = new Date(yoil).getDay();

				if(weekDay == 0 || weekDay == 6){
					flag1 = flag1 + 1;
				}else{
					flag2 = flag2 + 1;
				}
				vdt.push(value);
			})
			if(flag1 == 0){		//토요일,일요일 최소 1개 이상 포함
				if(flag2 == 0){
					alert("최소 하루 이상 선택하세요.");
					return;
				}else{
					unoPop("flex_w.asp?vdt="+ vdt,"탄력근무설정","700","700");
				}
			}else{
				if(flag2 == 0){
					unoPop("flex_w.asp?vdt="+ vdt,"탄력근무설정","700","700");
				}else{
					alert("토요일,일요일은 별도로 등록하세요.");
					return;
				}
			}
		}
	});
	$("#chkAll").change(function(){		//전체선택
		var is_check = $(this).is(":checked");
		$(".chk").prop("checked", is_check);
	});
});
function checkForm(){
	return true;
}
function writeKeyDown(){
	if (event.keyCode == 13)	goSearch();
}
function goSearch(){
	loadingShow();
	document.fm1.page.value = 1;
	document.fm1.action = "offList.asp";
	document.fm1.submit();
}
function chkDel(vID,vcd1,vcd2,vcd3,vcd4){
	if (confirm("삭제합니까?")){
		document.fm1.action = "mem_del_dbx.asp?uid="+ vID +"&cd1="+ vcd1 +"&cd2="+ vcd2 +"&cd3="+ vcd3 +"&cd4="+ vcd4;
		document.fm1.method = "post";
		document.fm1.target = "nullframe";
		document.fm1.submit();
	}
}
var checkflag = "false";
function check(field){
	if (checkflag == "false"){
		for (i = 0; i < field.length; i++){
			field[i].checked = true;
		}
		checkflag = "true";
		return "모두해제";
	} else {
		for (i = 0; i < field.length; i++){
			field[i].checked = false;
		}
		checkflag = "false";
		return "모두선택";
	}
}
function controlKey(){
	var direction = event.keyCode;
	switch (direction){
		case 39:			//우측방향키
			controlList(1);
			break;
		case 37:			//좌측방향키
			controlList(-1);
			break;
		default:
			break;
	}
}
function controlList(vIdx){
	if (vIdx == 1){
	<%If Int(page) < totalpage Then%>
		document.location = "?page=<%=page+1%>&cate=<%=cate%>&cd1=<%=cd1%>&cd2=<%=cd2%>&cd3=<%=cd3%>&cd4=<%=cd4%>";
	<%Else%>
		alert("마지막 페이지입니다.");
	<%End If%>
	} else if (vIdx == -1){
	<%If page <> 1 Then%>
		document.location = "?page=<%=page-1%>&cate=<%=cate%>&cd1=<%=cd1%>&cd2=<%=cd2%>&cd3=<%=cd3%>&cd4=<%=cd4%>";
	<%Else%>
		alert("첫 페이지입니다.");
	<%End If%>
	}
}
</script>


<body onkeydown="controlKey();">
<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td valign="top">

<form name="fm1" id="fm1" onsubmit="return checkForm();">
<input type="hidden" name="page" id="page" value="<%=page%>" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > 휴무내역표</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span>
											<select name="cd4" id="cd4" style="width:180px;" onchange="goSearch();"><!-- 부서 -->
												<option value="" selected>전체</option>
												<%=cmnCdList("부서",cd4,"","","")%>
											</select>
										</span>
										<span class="frt"><%=FormatNumber(recordcount,0)%> 건</span>
									</div>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0" class="tbl900">
										<colgroup>
											<col style="width:5%;" /><!-- 선택 -->
											<col style="width:10%;" /><!-- 이름 -->
											<col style="width:15%;" /><!-- 입사일자 -->
											<col style="width:12%;" /><!-- 휴가일수 -->
											<col style="width:12%;" /><!-- 특차일수 -->
											<col style="width:12%;" /><!-- 사용일수 -->
											<col style="width:12%;" /><!-- 잔여일수 -->
											<col style="width:12%;" /><!-- 지각횟수 -->
											<col /><!-- 전체 -->
										</colgroup>
										<thead>
											<tr style="height:40px;">
												<th><input type="checkbox" name="chkAll" id="chkAll" /></th>
												<th>이름</th>
												<th>입사일자</th>
												<th>휴가일수</th>
												<th>특차일수</th>
												<th>사용일수</th>
												<th>잔여일수</th>
												<th>지각횟수</th>
												<th>전체</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		rso()
		SQL = " SELECT TOP 20 * FROM memt010 "& param _
			& " AND uid NOT IN (SELECT TOP "& ((page-1) * 20) &" uid FROM memt010 "& param &" ORDER BY ddate DESC) " _
			& " ORDER BY ddate DESC "
'		Response.Write "<br>"& SQL &"<br>"
		rs.open SQL, dbcon, 3

		rs.pagesize = 20
		j = recordcount

		If Not (rs.eof And rs.bof) Then
			rs.absolutepage = page
			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize + 1
			End If

			i = 1
			rs.MoveFirst
			Do Until rs.EOF
				bbase = rs("base_vaca")
				sspec = rs("spcl_vaca")
				sdt = Left(rs("sdate"),4) &"-"& Mid(rs("sdate"),5,2) &"-"& Right(rs("sdate"),2)
				llate = chkLate(rs("uid"))
				sumUseDay = useVaca(rs("uid"),"반차") + useVaca(rs("uid"),"연차") + useVaca(rs("uid"),"특차")

				optVaca1 = bbase + sspec - sumUseDay		'잔여휴가
				optVaca2 = optVaca1 - llate * 0.5			'합계
%>
											<tr align="center">
												<td><input type="checkbox" name="chk" id="chk" class="chk" value="<%=rs("uid")%>:<%=rs("unm")%>" /></td>
												<td><%=rs("unm")%></td>
												<td><%=sdt%></td>
												<td class="rg pr10">
													<%=bbase%> 일<!-- 기본휴가일수 -->
												</td>
												<td class="rg pr10">
													<%=sspec%> 일<!-- 특차일수 -->
												</td>
												<td class="rg pr10" style="background-color:#404955;">
													<a href="javascript:;" onclick="unoPop('offPop.asp?uid=<%=rs("uid")%>&flag=U&vYear=<%=Year(Date())%>','휴가사용일수',400,600);">
													<b><%=sumUseDay%></b> 일</a><!-- 사용일수 -->
												</td>
												<td class="rg pr10">
													<%=optVaca1%> 일<!-- 남은일수 -->
												</td>
												<td class="rg pr10" style="background-color:#404955;">
													<a href="javascript:;" onclick="unoPop('lateListPop.asp?uid=<%=rs("uid")%>','지각일자목록',400,500);">
													<b><%=llate%></b> 회</a><!-- 지각횟수 -->
												</td>
												<td class="rg pr10">
													<%=optVaca2%> 일<!-- 전체 -->
												</td>
											</tr>
<%
				rs.MoveNext
				i = i + 1
				j = j - 1
			Loop
		Else
%>
											<tr>
												<td class="ct vm" height="100" colspan=10>내용이 없습니다.</td>
											</tr>
<%
		End If
		rsc()
%>
											<tr>
												<td height="2" colspan=10 bgcolor="#b2bdd5"></td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</table>
						<div class="ct mt10 mb10"><%=fnPagingGet(totalpage, page, 10, "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&cd4="& cd4)%></div>
						<div class="ct mt5 mb5">
							<select name="cd1" id="cd1" style="width:180px;">
								<option value="" <%If cd1 = "" Then%>selected<%End If%>>선택</option>
								<option value="unm" <%If cd1 = "unm" Then%>selected<%End If%>>이름검색</option>
								<option value="uid" <%If cd1 = "uid" Then%>selected<%End If%>>ID검색</option>
								<option value="hp" <%If cd1 = "hp" Then%>selected<%End If%>>휴대전화번호검색</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:130px;" onkeydown="writeKeyDown();" />
							<button type="button" onclick="goSearch();">조회</button>
						</div>
</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
<%
	time2 = Timer()
	Response.Write "<span class='f11'>"& Left((time2 - time1),5) &"</span>"
%>
