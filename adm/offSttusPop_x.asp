<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'*  화면명	: offSttusPop_x.asp - 휴무신청정보(관리자단)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	idx							= SQLI(Request("idx"))
	page						= SQLI(Request("page"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	pDept						= SQLI(Request("pDept"))
	pGubn						= SQLI(Request("pGubn"))
	flag						= SQLI(Request("flag"))

	uid							= SQLI(Request("uid"))
	sdate01						= SQLI(Request("sdate01"))
	sdate02						= SQLI(Request("sdate02"))
	sdate03						= SQLI(Request("sdate03"))
	ampm						= SQLI(Request("ampm"))

	rowcnt						= SQLI(Request("rowcnt"))
	sdate030t					= SQLI(Request("sdate030h"))
	sdate031t					= SQLI(Request("sdate031h"))
	sdate032t					= SQLI(Request("sdate032h"))
	sdate033t					= SQLI(Request("sdate033h"))
	sdate034t					= SQLI(Request("sdate034h"))
	sdate035t					= SQLI(Request("sdate035h"))
	sdate036t					= SQLI(Request("sdate036h"))

	use_day01					= SQLI(Request("use_day01"))
	use_day02					= SQLI(Request("use_day02"))
	use_day03					= SQLI(Request("use_day03"))
	handover					= SQLI(Request("handover"))
	note						= SQLI(Request("note"))
	sign0						= SQLI(Request("sign0"))
	sign1						= "insa"
	sign2						= SQLI(Request("sign2"))
	sign3						= SQLI(Request("sign3"))
	sign4						= SQLI(Request("sign4"))
	sign5						= SQLI(Request("sign5"))
	sign						= SQLI(Request("sign"))
	regDate						= Date()
	callback					= memInfo(uid,"hp1") & memInfo(uid,"hp2") & memInfo(uid,"hp3")

	If flag = "" Then flag = "W"

	If USER_ID = "" Then
		Call alertClose3()
		Response.End
	End If

	Select Case pGubn
		Case "반차" : sdate = sdate01: use_day = use_day01
'		Case "월차" : sdate = sdate02: use_day = use_day02
		Case "연차" : sdate = sdate03: use_day = DateDiff("d",sdate03,edate03)+1
		Case "특차" : sdate = sdate03: use_day = DateDiff("d",sdate03,edate03)+1
	End Select
'	Response.Write "idx : "& idx &"<br>"
	arr03 = sdate030t &","& sdate031t &","& sdate032t &","& sdate033t &","& sdate034t &","& sdate035t &","& sdate036t
	arrSdt = Split(arr03, ",")

	If flag = "W" Then							'쓰기
		msg = "오류가 있습니다."

		If Trim(uid) = "" Then
			Call alertClose5("필수 정보가 없습니다. 다시 진행해 주세요.")
			Response.End
		End If

		dbcon.Execute "BEGIN Transaction"
		If pGubn = "연차" Or pGubn = "특차" Then
			SQL = "	INSERT INTO vact010 (" _
				& "				mno" _
				& ",			uid" _
				& ",			gubn" _
				& ",			ampm" _
				& ",			use_day" _
				& ",			sign1" _
				& ",			sign2" _
				& ",			sign3" _
				& ",			handover" _
				& ",			note" _
				& ") VALUES (" _
				& "				''"_
				& ",			'"& uid &"'" _
				& ",			'"& pGubn &"'" _
				& ",			'"& ampm &"'" _
				& ",			"& rowcnt &"" _
				& ",			'"& sign1 &"'" _
				& ",			'"& sign2 &"'" _
				& ",			'"& sign3 &"'" _
				& ",			'"& handover &"'" _
				& ",			'"& note &"'" _
				& ")"
'			Response.Write SQL &"<br><br>"
'			dbcon.Execute SQL

			For i = 0 To rowcnt - 1
				If arrSdt(i) <> "" Then
					SQL = " INSERT INTO vact011 ("_
						& "		seq"_
						& ",	vdate"_
						& ",	app_yn"_
						& ") VALUES ("_
						& "		IDENT_CURRENT('vact010')"_
						& ",	'"& arrSdt(i) &"'"_
						& ",	'Y'"_
						& ") "
'					Response.Write SQL &"<br><br>"
'					dbcon.Execute SQL
				End If
			Next
		Else
			'연차 삽입
			SQL = "	INSERT INTO vact010 (" _
				& "				mno" _
				& ",			uid" _
				& ",			gubn" _
				& ",			ampm" _
				& ",			use_day" _
				& ",			sign1" _
				& ",			sign2" _
				& ",			sign3" _
				& ",			handover" _
				& ",			note" _
				& ") VALUES (" _
				& "				''"_
				& ",			'"& uid &"'" _
				& ",			'"& pGubn &"'" _
				& ",			'"& ampm &"'" _
				& ",			"& use_day _
				& ",			'"& sign1 &"'" _
				& ",			'"& sign2 &"'" _
				& ",			'"& sign3 &"'" _
				& ",			'"& handover &"'" _
				& ",			'"& note &"'" _
				& ")"
'			Response.Write SQL &"<br><br>"
'			dbcon.Execute SQL

			SQL = " INSERT INTO vact011 (seq, vdate, app_yn) VALUES (IDENT_CURRENT('vact010'), '"& sdate &"', 'Y') "
'			Response.Write SQL &"<br><br>"
'			dbcon.Execute SQL
		End If

		If sign1 <> "" Then						'인사팀장
			xhp1 = memInfo(sign1,"hp1")
			SQL = "	INSERT INTO em_tran	(tran_id, tran_phone, tran_callback, tran_status, tran_date, tran_msg ) " _
				& "	VALUES ('"& uid &"', '"& xhp1 &"', '"& callback &"', '1', getdate(), " _
				& "			'[전자결재]"& memInfo(uid,"uname") &"(이)가 작성한 결재건이 있습니다.재가 바랍니다.') "
			'dbcon.Execute SQL,,128
		End If

		If sign3 <> "" Then						'담당팀장
			xhp3 = memInfo(sign3,"hp1")
			SQL = "	INSERT INTO em_tran	(tran_id, tran_phone, tran_callback, tran_status, tran_date, tran_msg ) " _
				& "	VALUES ('"& uid &"', '"& xhp3 &"', '"& callback &"', '1', getdate(), " _
				& "			'[전자결재]"& memInfo(uid,"uname") &"(이)가 작성한 결재건이 있습니다.재가 바랍니다.') "
			'dbcon.Execute SQL,,128
		End If
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "V" Then						'재가
		msg = "재가되었습니다."

		dbcon.Execute "BEGIN Transaction"
		SQL = "	UPDATE vact010 SET sign"& sign &" = '"& USER_ID &"_0.gif' WHERE seq = "& seq
		dbcon.Execute SQL

'		If sign = 1 Then						'인사팀장 - 2022.07.15 인사팀 재가 없앰 (부서장 재가로 adm_chk Y 처리 - 승인 완료)
			SQL = "	UPDATE vact010 SET adm_chk = 'Y' WHERE seq = "& seq
			dbcon.Execute SQL
'		End If
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "M" Then						'수정
		msg = "수정되었습니다."

		rso()
		SQL = " SELECT adm_chk FROM vact010 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cchk = rs(0)
		End If
		rsc()

		If cchk = "N" Then						'미승인의 경우 수정가능
			dbcon.Execute "BEGIN Transaction"
			If pGubn = "연차" Or pGubn = "특차" Then
				SQL = "	UPDATE	vact010 SET " _
					& "			gubn = '"& pGubn &"', " _
					& "			ampm = '"& ampm &"', " _
					& "			sign1 = '"& sign1 &"', " _
					& "			sign2 = '"& sign2 &"', " _
					& "			sign3 = '"& sign3 &"', " _
					& "			use_day = '"& rowcnt &"', " _
					& "			handover = '"& handover &"', " _
					& "			note = '"& note &"' " _
					& "	WHERE	seq = "& seq
				dbcon.Execute SQL

				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL

				For i = 0 To rowcnt - 1
					If arrSdt(i) <> "" Then
						SQL = " INSERT INTO vact011 (seq, vdate, app_yn) VALUES ("& seq &", '"& arrSdt(i) &"', 'Y' ) "
						dbcon.Execute SQL
					End If
				Next
			Else
				SQL = "	UPDATE	vact010 SET " _
					& "			gubn = '"& pGubn &"', " _
					& "			ampm = '"& ampm &"', " _
					& "			sign1 = '"& sign1 &"', " _
					& "			sign2 = '"& sign2 &"', " _
					& "			sign3 = '"& sign3 &"', " _
					& "			use_day = '"& use_day &"', " _
					& "			handover = '"& handover &"', " _
					& "			note = '"& note &"' " _
					& "	WHERE	seq = "& seq
				dbcon.Execute SQL
				SQL = "	UPDATE vact011 SET vdate = '"& sdate &"' WHERE idx = "& idx
				dbcon.Execute SQL
			End If
			dbcon.Execute "COMMIT Transaction"
		Else
			Call JSalert("승인돤료된 신청서는 수정이 불가능 합니다.\n인사팀에 문의바랍니다.")
			Response.End

		End If

	ElseIf flag = "D" Then		'삭제
		msg = "삭제되었습니다."

		rso()
		SQL = " SELECT adm_chk FROM vact010 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cchk = rs(0)
		End If

		If USER_AUTH <= 10 Then
				dbcon.Execute "BEGIN Transaction"
				SQL = "	DELETE FROM vact010 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM bbst012 WHERE bbs_id = 80 AND seq = "& seq
				dbcon.Execute SQL
				dbcon.Execute "COMMIT Transaction"
		Else
			If cchk = "N" Then		'미승인의 경우 삭제가능
				dbcon.Execute "BEGIN Transaction"
				SQL = "	DELETE FROM vact010 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM bbst012 WHERE bbs_id = 80 AND seq = "& seq
				dbcon.Execute SQL
				dbcon.Execute "COMMIT Transaction"
			Else
				Call alertClose5("승인돤료된 신청서는 삭제가 불가능 합니다.\n인사팀에 문의바랍니다.")
				Response.End
			End If
		End If
		rsc()

	ElseIf flag = "DD" Then		'관리자 삭제
		msg = "삭제되었습니다."

		If USER_AUTH <= 10 Then
				dbcon.Execute "BEGIN Transaction"
				SQL = "	DELETE FROM vact010 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM vact011 WHERE seq = "& seq
				dbcon.Execute SQL
				SQL = "	DELETE FROM bbst012 WHERE seq = "& seq
				dbcon.Execute SQL
				dbcon.Execute "COMMIT Transaction"
		Else
				Call alertClose5("관리자만 접근이 가능합니다.\n인사팀에 문의바랍니다.")
				Response.End
		End If
		rsc()

	End If
%>

<form name="fm1" id=fm1>
<input type="hidden" name="seq" id="seq" value="<%=seq%>" />
<input type="hidden" name="cd1" id="cd1" value="<%=cd1%>" />
<input type="hidden" name="cd2" id="cd2" value="<%=cd2%>" />
<input type="hidden" name="pDept" id=pDept value="<%=pDept%>" />
<input type="hidden" name="pGubn" id=pGubn value="<%=pGubn%>" />
<input type="hidden" name="flag" id="flag" value="<%=flag%>" />
<input type="hidden" name="page" id="page" value="<%=page%>" />
</form>
<script>
	simsClosePopup();
	alert("<%=msg%>");
	$("#fm1").attr({action:"offSttusList.asp", method:"post", target:"_top"}).submit();
</script>
<%
	dbc()
%>