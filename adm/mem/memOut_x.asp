<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: memOut_x.asp - 관리자용 대기(신입)직원관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))
	outYY						= SQLI(Request("outYY"))
	outMM						= SQLI(Request("outMM"))
	outDD						= SQLI(Request("outDD"))

	If flag = "DD" Then				'완전삭제
		dbcon.Execute "BEGIN Transaction"
		SQL = "	DELETE FROM	memt011 WHERE uid = '"& uid &"' "
		dbcon.execute SQL
		dbcon.Execute "COMMIT Transaction"
	Else
		dbcon.Execute "BEGIN Transaction"
		SQL = "	UPDATE memt011 SET edate = '"& outYY & outMM & outDD &"' WHERE uid = '"& uid &"' "
		dbcon.Execute SQL
		dbcon.Execute "COMMIT Transaction"
	End If
%>
<form name="fm1" id=fm1>
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
</form>
<script>
//	alert("처리완료");
	$("#fm1").attr({action:"/adm/mem/memOut.asp", method:"POST", target:"_top"}).submit();
</script>
<%
	dbc()
%>
