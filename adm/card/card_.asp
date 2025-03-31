<!-- #include virtual = "/_db.asp" -->
<!-- #include virtual = "/inc/func.asp" -->
<%
'************************************************************************************
'* 화면명	: card.asp - 인사카드
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	dbo()
	uid							= SQLI(Request("uid"))

	If uid = "" Then
		Call AlertClose("ID가 선택되지 않았습니다.")
	End If

	rso()
	SQL = "	SELECT * "_
		& " FROM memt010 x LEFT JOIN memt020 y "_
		& " ON x.uid = y.uid "_
		& " WHERE x.uid = '"& uid &"' "
'	Response.Write "<br>"& SQL &"<br>"
	rs.open SQL, dbCon, 3
	If Not rs.eof Then
		unm						= rs("unm")
		base_vaca				= rs("base_vaca")					'연차일수
		spcl_vaca				= rs("spcl_vaca")					'특차일수
		email					= rs("email")
		zip						= rs("zip")
		addr					= rs("addr")
		hp1						= rs("hp1")
		hp2						= rs("hp2")
		hp3						= rs("hp3")
		dept					= rs("dept")						'부서
		team					= rs("team")						'팀
		ulvl					= rs("ulvl")						'직급
		auth					= rs("auth")						'권한
		sdate					= rs("sdate")
		birth_yy				= rs("birth_yy")
		birth_mm				= rs("birth_mm")
		birth_dd				= rs("birth_dd")
		pic						= rs("pic")
		ot_pnt					= rs("ot_pnt")
		ddate					= rs("ddate")
		updt					= rs("updt")
		css						= rs("css")

		enterYY					= Left(sdate,4)
		enterMM					= Right(Left(sdate,6),2)
		enterDD					= Right(sdate,2)
		email1					= Left(email, InStr(email, "@")-1)
		email2					= Right(email, Len(email)-Len(email1)-1)
	End If
	rsc()
%>

<html>
<head>
<title>인사기록카드</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="/inc/css/ext01.css">
<style type="text/css">
body {}
th {margin:0px; color:#000; font-size:12px; text-align:center; background-color:#eee; font-weight:bold;}
td {margin:0px; color:#000; font-size:12px; text-align:center;}
</style>
</head>


<body style="margin:20px;">
<table width=100% border=1 cellpadding="0" cellspacing="0" style="border-collapse:collapse;" class="mb5">
	<colgroup>
		<col /><!-- 사진 -->
		<col style="width:15%;" />
		<col style="width:25%;" />
		<col style="width:15%;" />
		<col style="width:25%;" />
	</colgroup>
	<tbody>
		<tr>
			<th colspan=5 style="font-size:19px;line-height:30px;">직원인사기록카드</th>
		</tr>
		<tr>
			<td height=23 colspan=5 class="pr10 rg">최종수정일 : <%=updt%></td>
		</tr>
		<tr height=30>
			<td rowspan=6></td>
			<th>입사일자</th>
			<td>&nbsp;</td>
			<th>퇴사일자</th>
			<td>&nbsp;</td>
		</tr>
		<tr height=30>
			<th>성명</th>
			<td>&nbsp;</td>
			<th>생년월일</th>
			<td>&nbsp;</td>
		</tr>
		<tr height=30>
			<th>부서명</th>
			<td>&nbsp;</td>
			<th>직책</th>
			<td>&nbsp;</td>
		</tr>
		<tr height=30>
			<th>주소</th>
			<td colspan=3>&nbsp;</td>
		</tr>
		<tr height=30>
			<th rowspan=2>휴대전화</th>
			<td rowspan=2>&nbsp;</td>
			<th>관계</th>
			<td>&nbsp;</td>
		</tr>
		<tr height=30>
			<th>비상연락처</th>
			<td>&nbsp;</td>
		</tr>
	</tbody>
</table>
<table width=100% border=1 cellpadding="0" cellspacing="0" style="border-collapse:collapse;" class="mb5">
	<colgroup>
		<col style="width:20%;" /><!-- 학교명 -->
		<col style="width:20%;" /><!-- 입학년월 -->
		<col style="width:20%;" /><!-- 졸업년월 -->
		<col style="width:20%;" /><!-- 전공 -->
		<col /><!-- 소재지 -->
	</colgroup>
	<thead>
		<tr>
			<th height=30 colspan=10>학력정보</th>
		</tr>
		<tr height=30>
			<th>학교명</th>
			<th>입학년월</th>
			<th>졸업년월</th>
			<th>전공</th>
			<th>소재지</th>
		</tr>
	</thead>
	<tbody>
<%
	rso()
	SQL = " SELECT * FROM memt030 WHERE uid = '"& uid &"' ORDER BY sch_sdate "
'	Response.Write SQL &"<br>"
	rs.open SQL, dbcon, 3
	iCnt = rs.recordcount
	If Not rs.Bof Then
		arrRs = rs.GetRows(iCnt)
		intFlds = UBound(arrRs, 1)
		intRows1 = UBound(arrRs, 2)
	End If
	rsc()
Response.Write "intFlds : "& intFlds &"<br>"
Response.Write "intRows1 : "& intRows1 &"<br>"
'uid(1)sch_nm(2)sch_sdate(3)sch_edate(4)sch_major(5)sch_loca(6)

	If intRows1 > 0 Then
		For intLoop = 0 To intRows1
%>
		<tr height=24 style="font-size:12px;">
			<!--<td style="mso-number-format:\@"><%=intLoop + 1%></td> 순번 -->
			<td><%=arrRs(2,intLoop)%></td><!-- 학교명 -->
			<td><%=arrRs(3,intLoop)%></td><!-- 입학년월 -->
			<td><%=arrRs(4,intLoop)%></td><!-- 졸업년월 -->
			<td class="lf pl5"><span style="letter-spacing:-1px;"><%=arrRs(5,intLoop)%></span></td><!-- 전공 -->
			<td class="lf pl5"><span style="letter-spacing:-1px;"><%=arrRs(6,intLoop)%></span></td><!-- 소재지 -->
		</tr>
<%
		Next
	Else
%>
		<tr height=24 style="font-size:12px;">
			<td colspan=10 class="ct">-</td>
		</tr>
<%
	End If
%>
	</tbody>
</table>
<table width=100% border=1 cellpadding="0" cellspacing="0" style="border-collapse:collapse;" class="mb5">
	<colgroup>
		<col style="width:20%;" /><!-- 성명 -->
		<col style="width:20%;" /><!-- 관계 -->
		<col /><!-- 비고 -->
	</colgroup>
	<thead>
		<tr>
			<th height=30 colspan=10>가족정보</th>
		</tr>
		<tr height=30>
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
	iCnt = rs.recordcount
	If Not rs.Bof Or Not rs.Eof Then
		arrRs = rs.GetRows(iCnt)
		intFlds = UBound(arrRs, 1)
		intRows2 = UBound(arrRs, 2)
	End If
	rsc()
'Response.Write "intRows2 : "& intRows2 &"<br>"
'uid(1)fam_nm(2)fam_rel(3)fam_etc(4)

	If intRows2 > 0 Then
		For intLoop = 0 To intRows2
%>
		<tr height=24 style="font-size:12px;">
			<td><%=arrRs(2,intLoop)%></td><!-- 성명 -->
			<td><%=arrRs(3,intLoop)%></td><!-- 관계 -->
			<td class="lf pl5"><span style="letter-spacing:-1px;"><%=arrRs(4,intLoop)%></span></td><!-- 비고 -->
		</tr>
<%
		Next
	Else
%>
		<tr height=24 style="font-size:12px;">
			<td colspan=10 class="ct">-</td>
		</tr>
<%
	End If
%>
	</tbody>
</table>
<table width=100% border=1 cellpadding="0" cellspacing="0" style="border-collapse:collapse;" class="mb5">
	<colgroup>
		<col style="width:30%;" /><!-- 직장명 -->
		<col style="width:20%;" /><!-- 재직기간 -->
		<col style="width:20%;" /><!-- 담당업무 -->
		<col style="width:10%;" /><!-- 직급 -->
		<col /><!-- 퇴직사유 -->
	</colgroup>
	<thead>
		<tr>
			<th height=30 colspan=10>경력정보</th>
		</tr>
		<tr height=30>
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
	iCnt = rs.recordcount
	If Not rs.Bof Or Not rs.Eof Then
		arrRs = rs.GetRows(iCnt)
		intFlds = UBound(arrRs, 1)
		intRows3 = UBound(arrRs, 2)
	End If
	rsc()
'uid(1)com_nm(2)com_sdate(3)com_edate(4)com_work(5)com_level(6)com_rsn(7)

	If intRows3 > 0 Then
		For intLoop = 0 To intRows3
%>
		<tr height=24 style="font-size:12px;">
			<td class="lf pl5"><%=arrRs(2,intLoop)%></td><!-- 직장명 -->
			<td><%=arrRs(3,intLoop)%>~<%=arrRs(4,intLoop)%></td><!-- 재직기간 -->
			<td><%=arrRs(5,intLoop)%></td><!-- 담당업무 -->
			<td><%=arrRs(6,intLoop)%></td><!-- 직급 -->
			<td class="lf pl5"><span style="letter-spacing:-1px;"><%=arrRs(7,intLoop)%></span></td><!-- 퇴직사유 -->
		</tr>
<%
		Next
	Else
%>
		<tr height=24 style="font-size:12px;">
			<td colspan=10 class="ct">-</td>
		</tr>
<%
	End If
%>
	</tbody>
</table>
<table width=100% border=1 cellpadding="0" cellspacing="0" style="border-collapse:collapse;" class="mb5">
	<colgroup>
		<col style="width:30%;" /><!-- 자격증(외국어)명 -->
		<col style="width:15%;" /><!-- 급수 -->
		<col style="width:15%;" /><!-- 취득일자 -->
		<col style="width:20%;" /><!-- 자격증번호 -->
		<col /><!-- 발행기관 -->
	</colgroup>
	<thead>
		<tr>
			<th height=30 colspan=10>자격증/외국어능력정보</th>
		</tr>
		<tr height=30>
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
	iCnt = rs.recordcount
	If Not rs.Bof Or Not rs.Eof Then
		arrRs = rs.GetRows(iCnt)
		intFlds = UBound(arrRs, 1)
		intRows4 = UBound(arrRs, 2)
	End If
	rsc()
'uid(1)license_nm(2)license_lvl(3)license_date(4)license_no(5)license_inst(6)

	If intRows4 > 0 Then
		For intLoop = 0 To intRows4
%>
		<tr height=24 style="font-size:12px;">
			<td class="lf pl5"><%=arrRs(2,intLoop)%></td><!-- 자격증(외국어)명 -->
			<td><%=arrRs(3,intLoop)%></td><!-- 급수 -->
			<td><%=arrRs(4,intLoop)%></td><!-- 취득일자 -->
			<td><%=arrRs(5,intLoop)%></td><!-- 자격증번호 -->
			<td class="lf pl5"><span style="letter-spacing:-1px;"><%=arrRs(6,intLoop)%></span></td><!-- 발행기관 -->
		</tr>
<%
		Next
	Else
%>
		<tr height=24 style="font-size:12px;">
			<td colspan=10 class="ct">-</td>
		</tr>
<%
	End If
%>
	</tbody>
</table>
<table width=100% border=1 cellpadding="0" cellspacing="0" style="border-collapse:collapse;" class="mb5">
	<colgroup>
		<col style="width:20%;" /><!-- 협상일자 -->
		<col style="width:20%;" /><!-- 내용 -->
		<col style="width:20%;" /><!-- 급여액 -->
		<col style="width:20%;" /><!-- 변동률 -->
		<col /><!-- 사유 -->
	</colgroup>
	<thead>
		<tr>
			<th height=30 colspan=10>급여변동정보</th>
		</tr>
		<tr height=30>
			<th>협상일자</th>
			<th>내용</th>
			<th>급여액</th>
			<th>변동률</th>
			<th>사유</th>
		</tr>
	</thead>
	<tbody>
<%
	rso()
	SQL = " SELECT * FROM memt070 WHERE uid = '"& uid &"' ORDER BY pay_date "
	rs.open SQL, dbcon, 3
	iCnt = rs.recordcount
	If Not rs.Bof Or Not rs.Eof Then
		arrRs = rs.GetRows(iCnt)
		intFlds = UBound(arrRs, 1)
		intRows5 = UBound(arrRs, 2)
	End If
	rsc()
'uid(1)pay_date(2)pay_amt(3)pay_rto(4)pay_note(5)pay_rsn(6)

	If intRows5 > 0 Then
		For intLoop = 0 To intRows5
%>
		<tr height=24 style="font-size:12px;">
			<td><%=arrRs(2,intLoop)%></td><!-- 협상일자 -->
			<td><%=arrRs(5,intLoop)%></td><!-- 내용 -->
			<td class="rg pr5" style="mso-number-format:\@"><%=FormatNumber(arrRs(3,intLoop),0)%></td><!-- 급여액 -->
			<td class="rg pr5" style="mso-number-format:\@"><%=arrRs(4,intLoop)%> %</td><!-- 변동률 -->
			<td class="lf pl5"><span style="letter-spacing:-1px;"><%=arrRs(6,intLoop)%></span></td><!-- 사유 -->
		</tr>
<%
		Next
	Else
%>
		<tr height=24 style="font-size:12px;">
			<td colspan=10 class="ct">-</td>
		</tr>
<%
	End If
%>
	</tbody>
</table>
<table width=100% border=1 cellpadding="0" cellspacing="0" style="border-collapse:collapse;" class="mb50">
	<colgroup>
		<col style="width:20%;" /><!-- 등록일자 -->
		<col style="width:20%;" /><!-- 종류 -->
		<col style="width:20%;" /><!-- 평가 및 내용 -->
		<col /><!-- 비고 -->
	</colgroup>
	<thead>
		<tr>
			<th height=30 colspan=10>인사고과정보(특이사항)</th>
		</tr>
		<tr height=30>
			<th>등록일자</th>
			<th>종류</th>
			<th>평가 및 내용</th>
			<th>비고</th>
		</tr>
	</thead>
	<tbody>
<%
	rso()
	SQL = " SELECT * FROM memt080 WHERE uid = '"& uid &"' ORDER BY rating_date "
	rs.open SQL, dbcon, 3
	iCnt = rs.recordcount
	If Not rs.Bof Or Not rs.Eof Then
		arrRs = rs.GetRows(iCnt)
		intFlds = UBound(arrRs, 1)
		intRows6 = UBound(arrRs, 2)
	End If
	rsc()
'uid(1)rating_date(2)rating_gubn(3)rating_note(4)rating_etc(5)

	If intRows6 > 0 Then
		For intLoop = 0 To intRows6
%>
		<tr height=24 style="font-size:12px;">
			<td><%=arrRs(2,intLoop)%></td><!-- 등록일자 -->
			<td><%=arrRs(3,intLoop)%></td><!-- 종류 -->
			<td class="lf pl5"><%=arrRs(4,intLoop)%></td><!-- 평가 및 내용 -->
			<td class="lf pl5"><span style="letter-spacing:-1px;"><%=arrRs(5,intLoop)%></span></td><!-- 비고 -->
		</tr>
<%
		Next
	Else
%>
		<tr height=24 style="font-size:12px;">
			<td colspan=10 class="ct">-</td>
		</tr>
<%
	End If
%>
	</tbody>
</table>
<%	dbc() %>
