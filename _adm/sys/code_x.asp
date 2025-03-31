<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: code_x.asp - 공통코드 CRUD 처리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	code_se						= SQLI(Request("code_se"))
	code_id						= SQLI(Request("code_id"))
	code_nm						= SQLI(Request("code_nm"))
	odrby						= SQLI(Request("odrby"))
	use_yn						= SQLI(Request("use_yn"))
	opt1						= SQLI(Request("opt1"))
	opt2						= SQLI(Request("opt2"))
	opt3						= SQLI(Request("opt3"))
	opt4						= SQLI(Request("opt4"))
	flag						= SQLI(Request("flag"))

	If odrby = "" Then odrby = 1
	If flag = "" Then flag = "W"
'	Response.Write "flag : "& flag &"<br>"

	Select Case flag
		Case "W" msg = "등록되었습니다." : goPage = "code"
		Case "M" msg = "수정되었습니다." : goPage = "code"
		Case "D" msg = "삭제되었습니다." : goPage = "code"
	End Select

'	If USER_ID = "" Then
'		Call AlertGo("비정상적인 접근입니다.","/")
'		Response.End
'	End If

	If flag = "W" Then							'쓰기

'		rso()
'		SQL = " SELECT MAX(odrby) + 1 FROM codt010 WHERE code_se = '"& code_se &"'"
'		rs.open SQL, dbcon
'		If Not rs.eof Then
'			modrby = rs(0)
'		End If
'		rsc()

		SQL = "	INSERT INTO codt010 ("_
			& "				code_se"_
			& ",			code_id"_
			& ",			code_nm"_
			& ",			odrby"_
			& ",			use_yn"_
			& ") VALUES ("_
			& "				'"& code_se &"'"_
			& ",			'"& code_id &"'"_
			& ",			'"& code_nm &"'"_
			& ",			"& odrby &""_
			& ",			'"& use_yn &"'"_
			& ")"
		dbcon.Execute SQL

	ElseIf flag = "M" Then						'수정
		SQL = "	UPDATE codt010 SET "_
			& "		odrby = "& odrby &"" _
			& ",	code_id = '"& code_id &"'"_
			& ",	code_nm = '"& code_nm &"'"_
			& ",	use_yn = '"& use_yn &"'"_
			& " WHERE seq = "& seq
'		Response.Write "<br>"& SQL &"<br>"
		dbcon.Execute SQL

	ElseIf flag = "D" Then						'삭제
		SQL = "	DELETE FROM codt010 WHERE seq = "& seq
		dbcon.Execute SQL

	End If
%>

<form name="fm1">
<input type="hidden" name="seq" value="<%=seq%>">
</form>
<script>
//	alert("<%=msg%>");
	parent.location.reload();
	simsClosePopup();
</script>
<%
	dbc()
%>
