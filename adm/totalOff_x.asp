<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: totalOff_x.asp - 휴무신청(관리자)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	idx							= SQLI(Request("idx"))
	page						= SQLI(Request("page"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	pDept						= SQLI(Request("pDept"))
	pGubn						= SQLI(Request("pGubn"))
	flag						= SQLI(Request("flag"))			'등록,수정,삭제,재가 구분
	op2							= SQLI(Request("op2"))			'1이면 /adm/totalOff.asp 으로 이동

	uid							= SQLI(Request("uid"))
	sdate01						= SQLI(Request("sdate01"))		'반차/반주휴일자
	sdate03						= SQLI(Request("sdate03"))		'연차/특차/주휴일자
	ampm						= SQLI(Request("ampm"))

	rowCnt						= SQLI(Request("rowCnt"))		'휴무일자 개수

	handover					= SQLI(Request("handover"))
	note						= SQLI(Request("note"))
	sign0						= SQLI(Request("sign0"))
	sign1						= "insa"
	sign3						= SQLI(Request("sign3"))
	sign						= SQLI(Request("sign"))

	rtnUrl						= "/bbs/totalOff.asp"

	If flag = "" Then flag = "W"
	If op2 = "1" Then rtnUrl = "/adm/off.asp"		'관리자

	If flag = "W" Then
		msg = "등록되었습니다..."
	ElseIf flag = "V" Then
		msg = "재가되었습니다."
	ElseIf flag = "M" Then
		msg = "수정되었습니다."
	ElseIf flag = "D" Or flag = "DD" Then
		msg = "삭제되었습니다."
	End If

	If USER_ID = "" Or Trim(uid) = "" Then
		Call AlertGo("비정상적인 접근입니다.","/")
		Response.End
	End If

	Select Case gubn
		Case "반차" : sdate = sdate01
		Case "반주휴" : sdate = sdate01
		Case "연차" : sdate = sdate03
		Case "특차" : sdate = sdate03
		Case "주휴" : sdate = sdate03
	End Select

	dtArr01 = Split(sdate03, ", ")

'	For m = LBound(dtArr01) To UBound(dtArr01)
'		Response.Write "<br>dtArr01"& m &" : "& dtArr01(m) &"<br>"
'	Next

	rso()		'직원 소속 팀 기본 출|퇴근 시간
	SQL = " SELECT opt1, opt2 " _
		& " FROM memt010 a LEFT OUTER JOIN codt010 b ON a.team = b.idx "_
		& " WHERE a.uid = '"& uid &"'" _
		& " AND b.gubn = '팀'" _
		& " AND b.use_yn = 'Y'"
	rs.open SQL, dbcon
	If Not rs.eof Then
		opt1 = rs(0)	'팀 기준 출근시간
		opt2 = rs(1)	'팀 기준 퇴근시간
	End If
	rsc()

	If ampm <> "" Then
		rso()		'해당일자에 해당직원이 탄력근무인지 확인
		SQL = " SELECT COUNT(*), stime, etime " _
			& " FROM vact010 a LEFT OUTER JOIN vact011 b ON a.seq = b.seq "_
			& " WHERE a.uid = '"& uid &"'" _
			& " AND a.gubn = '탄력'" _
			& " AND b.vdate = '"& sdate &"'" _
			& " GROUP BY stime, etime "
		rs.open SQL, dbcon
		If Not rs.eof Then
			vCnt = rs(0)
			stm0 = rs(1)
			etm0 = rs(2)
		End If
		rsc()
	'	Response.Write "vCnt : "& vCnt &"<br>"

		If ampm = "오후" Then		'오후 반차일 때
			If vCnt > 0 Then		'탄력근무 O
				stm = stm0
				etm = halfTm		'_db에서 정의
			Else					'탄력근무 X
				stm = opt1
				etm = halfTm
			End If
		Else						'오전 반차일 때
			If vCnt > 0 Then		'탄력근무 O
				stm = halfTm
				etm = etm0
			Else					'탄력근무 X
				If Weekday(sdate) = 1 Or Weekday(sdate) = 7 Then
					opt2 = "280"	'일,토요일의 경우 18:00
				End If
				stm = halfTm
				etm = opt2
			End If
		End If
	End If

	If flag = "W" Then							'쓰기
		dbcon.Execute "BEGIN Transaction"
		If gubn = "연차" Or gubn = "특차" Or gubn = "주휴" Then
			SQL = "	INSERT INTO vact010 (" _
				& "				uid" _
				& ",			gubn" _
				& ",			ampm" _
				& ",			use_day" _
				& ",			sign1" _
				& ",			sign3" _
				& ",			handover" _
				& ",			note" _
				& ") VALUES (" _
				& "				'"& uid &"'" _
				& "				,'"& gubn &"'" _
				& "				,'"& ampm &"'" _
				& "				,"& rowCnt &"" _
				& "				,'"& sign1 &"'" _
				& "				,'"& sign3 &"'" _
				& "				,'"& handover &"'" _
				& "				,'"& note &"'" _
				& ")"
			dbcon.Execute SQL

			For i = 0 To rowCnt - 1
				If dtArr01(i) <> "" Then		'연차|특차|주휴
					SQL = " INSERT INTO vact011 (" _
						& "				seq" _
						& "				,vdate" _
						& "				,stime" _
						& "				,etime" _
						& "				,app_yn" _
						& ") VALUES (" _
						& "				IDENT_CURRENT('vact010')" _
						& "				,'"& dtArr01(i) &"'" _
						& "				,''" _
						& "				,''" _
						& "				,'Y'" _
						& ")"
					dbcon.Execute SQL
				End If
			Next
		Else
			'반차, 반주휴 삽입
			SQL = "	INSERT INTO vact010 (" _
				& "				uid" _
				& ",			gubn" _
				& ",			ampm" _
				& ",			use_day" _
				& ",			sign1" _
				& ",			sign3" _
				& ",			handover" _
				& ",			note" _
				& ") VALUES (" _
				& "				'"& uid &"'" _
				& "				,'"& gubn &"'" _
				& "				,'"& ampm &"'" _
				& "				,0.5"_
				& "				,'"& sign1 &"'" _
				& "				,'"& sign3 &"'" _
				& "				,'"& handover &"'" _
				& "				,'"& note &"'" _
				& ")"
			dbcon.Execute SQL

			SQL = " INSERT INTO vact011 (" _
				& "				seq" _
				& "				,vdate" _
				& "				,stime" _
				& "				,etime" _
				& "				,app_yn" _
				& ") VALUES (" _
				& "				IDENT_CURRENT('vact010')" _
				& "				,'"& sdate &"'" _
				& "				,'"& stm &"'" _
				& "				,'"& etm &"'" _
				& "				,'Y'" _
				& ")"
'			Response.Write SQL &"<br><br>"
			dbcon.Execute SQL
		End If
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "M" Then						'수정
		rso()
		SQL = " SELECT adm_chk FROM vact010 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cchk = rs(0)
		End If
		rsc()

		dbcon.Execute "BEGIN Transaction"
		If cchk = "N" Then						'미승인의 경우 수정가능
			If gubn = "연차" Or gubn = "특차" Or gubn = "주휴" Then
				SQL = "	UPDATE	vact010 SET " _
					& "			gubn = '"& gubn &"', " _
					& "			ampm = '', " _
					& "			sign1 = '"& sign1 &"', " _
					& "			sign3 = '"& sign3 &"', " _
					& "			use_day = '"& rowCnt &"', " _
					& "			handover = '"& handover &"', " _
					& "			note = '"& note &"' " _
					& "	WHERE	seq = "& seq
				dbcon.Execute SQL

				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL

				'삭제 후 재입력
				For i = 0 To rowCnt - 1
					If dtArr01(i) <> "" Then
						SQL = " INSERT INTO vact011 (" _
							& "				seq" _
							& "				,vdate" _
							& "				,stime" _
							& "				,etime" _
							& "				,app_yn" _
							& ") VALUES (" _
							& "				IDENT_CURRENT('vact010')" _
							& "				,'"& dtArr01(i) &"'" _
							& "				,''" _
							& "				,''" _
							& "				,'Y'" _
							& ")"
						dbcon.Execute SQL
					End If
				Next
			Else		'반차, 반주휴 삽입
				SQL = "	UPDATE	vact010 SET " _
					& "			gubn = '"& gubn &"', " _
					& "			ampm = '"& ampm &"', " _
					& "			sign1 = '"& sign1 &"', " _
					& "			sign3 = '"& sign3 &"', " _
					& "			use_day = 0.5, " _
					& "			handover = '"& handover &"', " _
					& "			note = '"& note &"' " _
					& "	WHERE	seq = "& seq
				dbcon.Execute SQL

				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL

				'삭제 후 재입력
				SQL = " INSERT INTO vact011 (" _
					& "				seq" _
					& "				,vdate" _
					& "				,stime" _
					& "				,etime" _
					& "				,app_yn" _
					& ") VALUES (" _
					& "				IDENT_CURRENT('vact010')" _
					& "				,'"& sdate &"'" _
					& "				,'"& stm &"'" _
					& "				,'"& etm &"'" _
					& "				,'Y'" _
					& ")"
				dbcon.Execute SQL
			End If
		Else
			Call JSalert("승인돤료된 신청서는 수정이 불가능 합니다.\n인사팀에 문의바랍니다.")
			Response.End

		End If
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "V" Then						'재가
		dbcon.Execute "BEGIN Transaction"
		SQL = "	UPDATE	vact010 SET sign"& sign &" = '"& USER_ID &"_0.gif' WHERE seq = "& seq
		dbcon.Execute SQL

		If sign = 1 Then						'인사팀장
			SQL = "	UPDATE	vact010 SET adm_chk = 'Y' WHERE seq = "& seq
			dbcon.Execute SQL
		End If
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "D" Then		'삭제
		rso()
		SQL = " SELECT adm_chk FROM vact010 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cchk = rs(0)
		End If

		dbcon.Execute "BEGIN Transaction"
		If USER_AUTH <= 10 Then
				'휴가
				SQL = "	DELETE FROM vact010 WHERE seq = "& seq
				dbcon.Execute SQL
				'휴가상세
				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL
				'게시물조회자
				SQL = "	DELETE FROM bbst012 WHERE tbl_id = 'vact010' AND seq = "& seq
				dbcon.Execute SQL
		Else
			If cchk <> "Y" Then			'미승인의 경우 삭제가능
				'휴가
				SQL = "	DELETE FROM vact010 WHERE seq = "& seq
				dbcon.Execute SQL
				'휴가상세
				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL
				'게시물조회자
				SQL = "	DELETE FROM bbst012 WHERE tbl_id = 'vact010' AND seq = "& seq
				dbcon.Execute SQL
			Else
				Call AlertGo("승인돤료된 신청서는 삭제가 불가능 합니다.\n인사팀에 문의바랍니다.","report.asp")
				Response.End
			End If
		End If
		rsc()
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "DD" Then		'관리자 삭제

		If USER_AUTH <= 10 Then
				SQL = "	DELETE FROM vact010 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM bbst012 WHERE tbl_id = 'vact010' AND seq = "& seq
				dbcon.Execute SQL
		Else
				Call AlertGo("관리자만 접근이 가능합니다.\n인사팀에 문의바랍니다.","report.asp")
				Response.End
		End If

	End If
%>

<form name="fm1" id=fm1>
<input type="hidden" name="seq" id="seq" value="<%=seq%>">
<input type="hidden" name="cd1" id="cd1" value="<%=cd1%>">
<input type="hidden" name="cd2" id="cd2" value="<%=cd2%>">
<input type="hidden" name="pDept" id=pDept value="<%=pDept%>" />
<input type="hidden" name="pGubn" id=pGubn value="<%=pGubn%>" />
<input type="hidden" name="flag" id="flag" value="<%=flag%>">
<input type="hidden" name="page" id="page" value="<%=page%>">
</form>
<script type="text/javascript">
	simsClosePopup();
	alert("<%=msg%>");
	parent.document.location.reload();
//	$("#fm1").attr({action:"<%=rtnUrl%>", method:"post", target:"_top"}).submit();
</script>
<%
	dbc()
%>