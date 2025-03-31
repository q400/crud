<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: late_x.asp (탄력근무설정)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	lateDt						= SQLI(Request("lateDt"))
	flag						= SQLI(Request("flag"))
'	arrDate = Split(lateDt, ",")

	If flag = "LD" Then
		SQL = "	DELETE FROM latt010 WHERE uid = '"& uid &"' AND ldate = '"& Trim(lateDt) &"' "
		dbcon.Execute SQL

	ElseIf flag = "LI" Then
		rso()
		SQL = " SELECT COUNT(*) FROM latt010 WHERE uid = '"& uid &"' AND ldate = '"& Trim(lateDt) &"' "
		rs.open SQL, dbcon
			rcnt = rs(0)
		rsc()

		If rcnt = 0 Then	'등록정보가 없으면
			SQL = "	INSERT INTO latt010 (uid, ldate, chk, rgid, rgdt) " _
				& " VALUES ('"& uid &"', '"& Trim(lateDt) &"', 'Y', '"& USER_ID &"', getdate()) "
'			Response.Write SQL &"<br>"
			dbcon.Execute SQL
		Else
			SQL = "	DELETE FROM latt010 WHERE uid = '"& uid &"' AND ldate = '"& Trim(lateDt) &"' "
			dbcon.Execute SQL
		End If
	End If
%>
<form name="fm1" id=fm1>
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
</form>
<%
	If flag = "LD" Then
%>
<script>
	alert("처리되었습니다.");
	document.fm1.action = "late_all.asp";
	document.fm1.method = "post";
	document.fm1.target = "_top";
	document.fm1.submit();
</script>
<%
	ElseIf flag = "LI" Then
%>
<script>
	simsClosePopup();
	alert("처리되었습니다.");
	parent.document.location.reload();
</script>
<%
	End If
	dbc()
%>