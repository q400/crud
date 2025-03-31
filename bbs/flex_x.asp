<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: flex_x.asp (탄력근무설정)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	idx							= SQLI(Request("idx"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	opt							= SQLI(Request("opt"))			'등록,수정,삭제,재가 구분
	page						= SQLI(Request("page"))

	xid							= SQLI(Request("xid"))
	ids							= SQLI(Request("ids"))			'직원ID 배열값
	vdt							= SQLI(Request("vdt"))			'해당일자
	stime						= SQLI(Request("stime"))		'탄력적용된 출근시간
	etime						= SQLI(Request("etime"))		'탄력적용된 퇴근시간

	arrId = Split(ids, ",")
	arrDt = Split(vdt, ", ")

	sign1						= "insa"
	sign3						= SQLI(Request("sign3"))

	If opt = "" Then opt = "W"

	Select Case opt
		Case "W" msg = "등록되었습니다."
		Case "V" msg = "재가되었습니다."
		Case "M" msg = "수정되었습니다."
		Case "D" msg = "삭제되었습니다."
		Case "DD" msg = "삭제되었습니다."
	End Select

	If USER_ID = "" Then
		Call AlertClose3()
		Response.End
	End If

	If opt = "W" Then							'쓰기
		dbcon.Execute "BEGIN Transaction"
		'2022.04.27 [김명진 과장] 인사팀 재가 불필요. 팀장 등록에서 adm_chk = Y 처리
		For ii = LBound(arrId) To UBound(arrId)
			arrKK = Split(arrId(ii), ":")		'ID, 이름 분리
			SQL = "	INSERT INTO vact010 ("_
				& "				cid" _
				& ",			uid" _
				& ",			gubn"_
				& ",			ampm"_
				& ",			ddate"_
				& ",			use_day"_
				& ",			sign1"_
				& ",			sign3"_
				& ",			adm_chk"_
				& ",			handover"_
				& ",			note"_
				& ") VALUES ("_
				& "				'"& USER_COMP &"'" _
				& ",			'"& arrKK(0) &"'" _
				& ",			'탄력'"_
				& ",			''"_
				& ",			getdate()"_
				& ",			0"_
				& ",			'"& sign1 &"'"_
				& ",			'"& sign3 &"_0.gif'"_
				& ",			'Y'" _
				& ",			''"_
				& ",			''"_
				& ")"
'			Response.Write "<br>"& SQL &"<br>"
			dbcon.Execute SQL

			For dd = LBound(arrDt) To UBound(arrDt)
				SQL = "	INSERT INTO vact011 (" _
					& "				seq" _
					& ",			stime"_
					& ",			etime"_
					& ",			vdate" _
					& ",			app_yn" _
					& ",			ddate" _
					& ") VALUES (" _
					& "				IDENT_CURRENT('vact010')" _
					& ",			'"& replace(stime,":","") &"'"_
					& ",			'"& replace(etime,":","") &"'"_
					& ",			'"& arrDt(dd) &"'" _
					& ",			'Y'" _
					& ",			getdate()" _
					& ")"
				dbcon.Execute SQL
			Next
		Next
		dbcon.Execute "COMMIT Transaction"

	ElseIf opt = "M" Then						'수정
		rso()
		SQL = " SELECT adm_chk FROM vact010 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cchk = rs(0)
		End If
		rsc()

'		If cchk = "N" Then						'미승인의 경우 수정가능
			dbcon.Execute "BEGIN Transaction"
			If Right(sign3, 6) <> "_0.gif" Then
				SQL = "	UPDATE vact010 SET "_
					& "		sign3 = '"& sign3 &"_0.gif'"_
					& " WHERE seq = "& seq
				dbcon.Execute SQL
			End If

			SQL = "	UPDATE vact011 SET " _
				& "		stime = '"& replace(stime,":","") &"'"_
				& ",	etime = '"& replace(etime,":","") &"'"_
				& ",	vdate = '"& vdt &"'" _
				& " WHERE seq = "& seq _
				& " AND idx = "& idx
			dbcon.Execute SQL
			dbcon.Execute "COMMIT Transaction"
'		Else
'			Call AlertClose5("승인완료된 신청서는 수정이 불가능 합니다.\n인사팀에 문의바랍니다.")
'			Response.End
'		End If

	ElseIf opt = "V" Then						'재가(미사용)
		SQL = "	UPDATE vact010 SET sign"& sign &" = '"& USER_ID &"_0.gif' WHERE seq = "& seq
		dbcon.Execute SQL

		If sign = 1 Then						'인사팀
			SQL = "	UPDATE vact010 SET adm_chk = 'Y' WHERE seq = "& seq
			dbcon.Execute SQL
		End If

	ElseIf opt = "D" Then		'삭제
		rso()
		SQL = " SELECT adm_chk FROM vact010 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cchk = rs(0)
		End If
		rsc()
		rso()
		SQL = " SELECT COUNT(*) FROM vact011 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cCnt = rs(0)
		End If
		rsc()

		If USER_AUTH <= 10 Then
				If cCnt = 1 Then		'1건
					SQL = "	DELETE FROM vact010 WHERE seq = "& seq
					dbcon.Execute SQL
				End If
					SQL = "	DELETE FROM vact011 WHERE seq = "& seq &" AND idx = "& idx
					dbcon.Execute SQL
		Else
'			If cchk <> "Y" Then			'미승인의 경우 삭제가능
				If cCnt = 1 Then		'1건
					SQL = "	DELETE FROM vact010 WHERE seq = "& seq
					dbcon.Execute SQL
				End If
					SQL = "	DELETE FROM vact011 WHERE seq = "& seq &" AND idx = "& idx
					dbcon.Execute SQL
'			Else
'					Call AlertClose5("승인완료된 신청서는 삭제가 불가능 합니다.\n인사팀에 문의바랍니다.")
'					Response.End
'			End If
		End If

	ElseIf opt = "DD" Then		'관리자 삭제
		rso()
		SQL = " SELECT COUNT(*) FROM vact011 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cCnt = rs(0)
		End If
		rsc()

		If USER_AUTH <= 10 Then
				If cCnt = 1 Then		'1건
					SQL = "	DELETE FROM vact010 WHERE seq = "& seq
					dbcon.Execute SQL
				End If
					SQL = "	DELETE FROM vact011 WHERE seq = "& seq &" AND idx = "& idx
					dbcon.Execute SQL
		Else
					Call AlertClose5("관리자만 접근이 가능합니다.\n인사팀에 문의바랍니다.")
					Response.End
		End If
	End If
%>

<form name="fm1">
<input type="hidden" name="seq" id="seq" value="<%=seq%>" />
<input type="hidden" name="opt" id="opt" value="<%=opt%>" />
<input type="hidden" name="cd1" id="cd1" value="<%=cd1%>" />
<input type="hidden" name="cd2" id="cd2" value="<%=cd2%>" />
<input type="hidden" name="page" id="page" value="<%=page%>" />
</form>
<script>
	simsClosePopup();
	alert("<%=msg%>");
	parent.document.location.reload();
</script>
<%
	dbc()
%>