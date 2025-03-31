<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: otpHistory.asp - OTP 적립/사용내역
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	page						= SQLI(Request("page"))

	pagesize = 12							'페이지크기
	If page = "" Then page = 1

	rso()
	SQL = " SELECT ot_pnt FROM memt010 WHERE uid = '"& uid &"'"
	rs.open SQL, dbcon, 3
		ot_pnt = rs("ot_pnt")
	rsc()

	rso()
	SQL = " SELECT 'a' FROM ovtt010 WHERE uid = '"& uid &"'"
	rs.open SQL, dbcon, 3
		k = rs.recordcount
	rsc()
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnClose").click(function (){		//닫기
		simsClosePopup();
	});
});
</script>


<form name="fm1" id="fm1" method="post">
<input type="hidden" name="page" id=page value="<%=page%>" />
<div>
	<div class="mt20">
		<div class="mb10">
			<div class="ib ml10"><b color='#00aa00'><%=memInfo(uid,"unm")%></b> OTP 이력 [잔여포인트 : <b class="fcy"><%=ot_pnt%></b>]</div>
			<div class="ib frt mr20">전체 <b><%=k%></b> 건</div>
		</div>
		<table width=100% id="list1" class="tbl900">
			<colgroup>
				<col style="width:17%;" /><!-- 해당일자 -->
				<col style="width:10%;" /><!-- 구분 -->
				<col style="width:13%;" /><!-- 적용포인트 -->
				<col style="width:10%;" /><!-- 승인여부 -->
				<col style="width:10%;" /><!-- 상태 -->
				<col /><!-- 등록일자 -->
				<col style="width:12%;" /><!-- 등록자 -->
			</colgroup>
			<thead>
				<tr style="height:30px;">
					<th>해당일자</th>
					<th>구분</th>
					<th>적용포인트</th>
					<th>승인여부</th>
					<th>상태</th>
					<th>등록일자</th>
					<th>등록자</th>
				</tr>
			</thead>
			<tbody>
<%
		rso()
		SQL = " SELECT seq, uid, ampm, adm_chk, sign1, sign2, sign3, gubn, point, sign3, adate, ddate, cancel_yn, cancel_date, upid "_
			& " FROM ovtt010 "_
			& " WHERE uid = '"& uid &"'" _
			& " ORDER BY ddate DESC "
		rs.open SQL, dbcon, 3

		rs.pagesize = pagesize
		j = rs.recordcount

		If Not (rs.eof And rs.bof) Then

			totalpage = rs.pagecount
			rs.absolutepage = page

			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize
			End If

			i = 1
			Do Until rs.EOF Or i > rs.pagesize

				point = rs("point")
				yoil = ""

				If rs("gubn") = "적립" Then
					gubn = "<span class='fc8'>적립</span>"
					point = "<b class='fc8'>"& rs("point") &"</b>"
				Else
					gubn = "사용"
					If rs("adate") <> "" Then
						If Weekday(rs("adate")) = 7 Then '토요일 신청건의 경우
							point = rs("point")/2 & "(<b class='fc8'>" & rs("point") & "</b>)"
						Else
							point = rs("point")
						End If

						Select Case Weekday(rs("adate"))
							Case "1" : yoil = "(일)"
							Case "2" : yoil = "(월)"
							Case "3" : yoil = "(화)"
							Case "4" : yoil = "(수)"
							Case "5" : yoil = "(목)"
							Case "6" : yoil = "(금)"
							Case "7" : yoil = "<font color='red'>(토)</font>"
							Case Else : yoil = ""
						End Select
					End If
				End If
%>
				<tr align="center" height=30>
					<td><%=rs("adate")%><%=yoil%></td>
					<td><%=gubn%></td>
					<td><%=point%></td>
					<td><%If rs("adm_chk") = "Y" Then%>승인<%Else%>대기<%End If%></td>
					<td><%If rs("cancel_yn") = "Y" Then%><span class='fc9'>취소</span><%Else%>완료<%End If%></td>
					<td><%=rs("ddate")%></td>
					<td><%=memInfo(rs("upid"),"unm")%></td>
				</tr>
<%
				rs.MoveNext
				If Not rs.eof Then
%>
				<tr>
					<td colspan=10 background="/img/dot.gif"></td>
				</tr>
<%
				End If
				i = i + 1
				j = j - 1
			Loop
		Else
%>
				<tr>
					<td class="ct vm" colspan=10>내용이 없습니다.</td>
				</tr>
<%
		End If
		rsc()
%>
				<tr>
					<td height="1" colspan=10 bgcolor="#524d45"></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="ct mt10 mb20"><%=fnPagingGet(totalpage, page, 10, "uid="& uid)%></div>
	<div class="ct mt10">
		<button type="button" id=btnClose class="">창닫기</button>
	</div>
</div>
</form>
<%
	dbc()
%>