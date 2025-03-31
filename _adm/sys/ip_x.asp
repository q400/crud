<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: ip_x.asp - 허용IP CRUD 처리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	gubn						= SQLI(Request("gubn"))
	ip							= SQLI(Request("ip"))
	use_yn						= SQLI(Request("use_yn"))
	flag						= SQLI(Request("flag"))

	If flag = "" Then flag = "W"
'	Response.Write "flag : "& flag &"<br>"

	Select Case flag
		Case "W" msg = "등록되었습니다." : goPage = "code"
		Case "M" msg = "수정되었습니다." : goPage = "code"
		Case "D" msg = "삭제되었습니다." : goPage = "code"
	End Select

	If flag = "W" Then							'쓰기

		SQL = "	INSERT INTO ipdt010 ("_
			& "				gubn"_
			& ",			ip"_
			& ",			use_yn"_
			& ") VALUES ("_
			& "				'"& gubn &"'"_
			& ",			'"& ip &"'"_
			& ",			'"& use_yn &"'"_
			& ")"
		dbcon.Execute SQL

	ElseIf flag = "M" Then						'수정
		SQL = "	UPDATE ipdt010 SET "_
			& "		ip = '"& ip &"'" _
			& "	,	gubn = '"& gubn &"'" _
			& "	,	use_yn = '"& use_yn &"'" _
			& " WHERE seq = "& seq
		dbcon.Execute SQL

	ElseIf flag = "D" Then						'삭제
		SQL = "	DELETE FROM ipdt010 WHERE seq = "& seq
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
