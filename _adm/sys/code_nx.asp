<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: code_nx.asp - 표준코드 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	cdSe						= SQLI(Request("code_se"))
	cdId						= SQLI(Request("code_id"))
	cdNm						= SQLI(Request("code_nm"))
	okYn						= SQLI(Request("ok_yn"))
	flag						= SQLI(Request("flag"))

	If odrby = "" Then odrby = 1
	If flag = "" Then flag = "W"
'	Response.Write "flag : "& flag &"<br>"

	Select Case cdSe
		Case "부서" : val = "AD"
		Case "팀" : val = "AG"
		Case "직급" : val = "AJ"
	End Select

	If cdId = "" Then
		rso()
		SQL = "SELECT RIGHT(MAX(code_id), 4) + 5 FROM codt010 WHERE code_se = '"& cdSe &"' AND RIGHT(code_id, 4) <> '9990'"
		rs.open SQL, dbcon
		If Not rs.eof Then
			cdId				= val & rs(0)
		End If
		rsc()
	End If

	rso()
	SQL = " SELECT COUNT(*) FROM codt010 WHERE code_se = '"& cdSe &"' AND code_nm = '"& cdNm &"'"
	rs.open SQL, dbcon, 3
		cnt1 = rs(0)					'동일 코드이름 수
	rsc()

	If flag = "D" Then							'삭제
		msg = "삭제되었습니다."
		SQL = "	DELETE FROM codt040 WHERE seq = "& seq
		dbcon.Execute SQL

	Else
		If cnt1 = 0 Then
			msg = "등록되었습니다."
			SQL = "	INSERT INTO codt010 (code_se, code_id, code_nm, use_yn, odrby) VALUES ( "_
					& "		'"& cdSe &"'" _
					& ",	'"& cdId &"'" _
					& ",	'"& cdNm &"'" _
					& ",	'Y'" _
					& ",	'5000'" _
					& ")"
			dbcon.Execute SQL

			If seq <> "" Then
				SQL = "	UPDATE codt040 SET "_
					& "		ok_yn = 'Y'" _
					& ",	pdate = CONVERT(CHAR(10), getdate(), 23) "_
					& " WHERE seq = "& seq
				dbcon.Execute SQL
			End If
		Else
			If okYn = "N" Then
				msg = "미승인 상태로 변경됩니다."
				SQL = "	UPDATE codt040 SET "_
					& "		ok_yn = 'N'" _
					& ",	pdate = '' "_
					& " WHERE seq = "& seq
				dbcon.Execute SQL
			Else
				msg = "중복된 코드이름이 있습니다."
			End If
		End If

	End If
%>

<form name="fm1" id=fm1>
<input type="hidden" name="seq" value="<%=seq%>">
</form>
<script>
	alert("<%=msg%>");
	parent.location.reload();
	simsClosePopup();
</script>
<%
	dbc()
%>
