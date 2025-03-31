<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명 :	setPop_x.asp (POPUP)
'* 고객사별 부서·직급·팀 설정 처리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	cid							= SQLI(Request("cid"))
	upCd						= SQLI(Request("dept"))
	cdSe						= SQLI(Request("code_se"))
	arrVal						= SQLI(Request("arrVal3"))

	arrVal = Split(arrVal, ",")
'	Response.Write "cdSe : "& cdSe &"<br>"

	Select Case cdSe
		Case "부서" : val = "AD"
		Case "직급" : val = "AJ"
		Case "팀" : val = "AG"
		Case "권한" : val = "AA"
	End Select
'	Response.Write "val : "& val &"<br>"

	msg = "저장되었습니다."

	rso()
	SQL = " SELECT opt1, opt2 FROM cmpt010 WHERE cid = '"& cid &"'"
	rs.open SQL, dbcon, 3
		opt1 = rs("opt1")		'기본출근시간
		opt2 = rs("opt2")		'기본퇴근시간
	rsc()

	dbcon.Execute "BEGIN Transaction"
	If val = "AD" Or Val = "AJ" Then			'부서/직급 선택
		SQL = " DELETE FROM codt020 WHERE cid = '"& cid &"' AND code_id LIKE '"& val &"%'"
'		Response.Write "부서/직급 DELETE 1 -<br>"& SQL &"<br>"
		dbcon.Execute SQL
		SQL = " DELETE FROM codt020 WHERE cid = '"& cid &"' AND up_cd = '"& val &"'"
'		Response.Write "부서/직급 DELETE 2 -<br>"& SQL &"<br>"
		dbcon.Execute SQL

		For intLoop = LBound(arrVal) To UBound(arrVal)
			SQL = "	INSERT INTO codt020 (cid, up_cd, code_id, use_yn, opt1, opt2, odrby) VALUES ( "_
				& "		'"& cid &"'" _
				& ",	'"& upCd &"'" _
				& ",	'"& arrVal(intLoop) &"'" _
				& ",	'Y'" _
				& ",	'"& opt1 &"'" _
				& ",	'"& opt2 &"'" _
				& ",	''" _
				& ")"
'			Response.Write "부서직급 INSERT -<br>"& SQL &"<br>"
			dbcon.Execute SQL
		Next
	ElseIf val = "AG" Then						'팀 선택
		SQL = " DELETE FROM codt020 WHERE cid = '"& cid &"' AND up_cd = '"& upCd &"'"
'		Response.Write "팀 DELETE -<br>"& SQL &"<br>"
		dbcon.Execute SQL

		For intLoop = LBound(arrVal) To UBound(arrVal)
			SQL = "	INSERT INTO codt020 (cid, up_cd, code_id, use_yn, opt1, opt2, odrby) VALUES ( "_
				& "		'"& cid &"'" _
				& ",	'"& upCd &"'" _
				& ",	'"& arrVal(intLoop) &"'" _
				& ",	'Y'" _
				& ",	'"& opt1 &"'" _
				& ",	'"& opt2 &"'" _
				& ",	''" _
				& ")"
'			Response.Write "팀 INSERT -<br>"& SQL &"<br>"
			dbcon.Execute SQL
		Next
	Else										'권한 선택
		SQL = " DELETE FROM codt020 WHERE cid = '"& cid &"' AND code_id LIKE '"& val &"%'"
'		Response.Write "권한 DELETE -<br>"& SQL &"<br>"
		dbcon.Execute SQL

		For intLoop = LBound(arrVal) To UBound(arrVal)
			SQL = "	INSERT INTO codt020 (cid, up_cd, code_id, use_yn, opt1, opt2, odrby) VALUES ( "_
				& "		'"& cid &"'" _
				& ",	'"& upCd &"'" _
				& ",	'"& arrVal(intLoop) &"'" _
				& ",	'Y'" _
				& ",	'"& opt1 &"'" _
				& ",	'"& opt2 &"'" _
				& ",	''" _
				& ")"
'			Response.Write "권한 INSERT -<br>"& SQL &"<br>"
			dbcon.Execute SQL
		Next
	End If
	dbcon.Execute "COMMIT Transaction"
%>

<script>
	alert("<%=msg%>");
	parent.location.reload();
	simsClosePopup();
</script>
<%
	dbc()
%>
