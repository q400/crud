<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: log_x.asp - 접속로그 CRUD 처리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색어
	cbox						= SQLI(Request("cbox"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If flag = "" Then flag = "W"

	Select Case flag
		Case "W" msg = "등록되었습니다." : goPage = "code"
		Case "M" msg = "수정되었습니다." : goPage = "code"
		Case "D" msg = "삭제되었습니다." : goPage = "code"
	End Select

	arrChk = Split(cbox, ", ")

	If flag = "W" Then							'쓰기

	ElseIf flag = "M" Then						'수정

	ElseIf flag = "D" Then						'삭제
		For k = LBound(arrChk) To UBound(arrChk)
			SQL = "	DELETE FROM logt010 WHERE seq = "& arrChk(k)
'			Response.Write "<br>"& SQL &"<br>"
			dbcon.Execute SQL
		Next
	End If
%>

<form name="fm1" id="fm1">
<input type="hidden" name="seq" id="seq" value="<%=seq%>" />
<input type="hidden" name="cd1" id="cd1" value="<%=cd1%>" />
<input type="hidden" name="cd2" id="cd2" value="<%=cd2%>" />
<input type="hidden" name="flag" id="flag" value="<%=flag%>" />
<input type="hidden" name="page" id="page" value="<%=page%>" />
</form>
<script>
	alert("<%=msg%>");
	$("#fm1").attr({action:"log.asp", method:"post"}).submit();
</script>
<%
	dbc()
%>
