<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: mem_x.asp - 관리자용 직원관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))
'권한	AA0050	관리자
'권한	AA0500	부서장
'권한	AA0700	팀장
'권한	AA0900	일반
'권한	AA0999	대기

	If flag = "A" Then				'관리자설정
		rso()
		SQL = "	SELECT auth FROM memt010 WHERE uid = '"& uid &"' "
		rs.open SQL, dbcon, 3
		If Not rs.eof Then
			auth = rs(0)
		End If
		rsc()

		If trim(auth) <> "AA0050"  Then
			SQL = "	UPDATE memt010 SET auth = 'AA0050' WHERE uid = '"& uid &"' "
			dbcon.Execute SQL
		Else
			SQL = "	UPDATE memt010 SET auth = 'AA0900' WHERE uid = '"& uid &"' "
			dbcon.Execute SQL
		End If

	ElseIf flag = "B" Then			'활성화
		rso()
		SQL = "	SELECT open_yn FROM memt010 WHERE uid = '"& uid &"' "
		rs.open SQL, dbcon, 3
		If Not rs.eof Then
			open_yn = rs(0)
		End If
		rsc()

		If open_yn = "Y" Then		'활성화 -> 비활성화
			SQL = "	UPDATE memt010 SET open_yn = 'N', edate = TRIM(CONVERT(CHAR(10),getdate(),112)) WHERE uid = '"& uid &"' "
			dbcon.Execute SQL
		Else						'비활성화 -> 활성화
			SQL = "	UPDATE memt010 SET open_yn = 'Y' WHERE uid = '"& uid &"' "
			dbcon.Execute SQL
		End If

	ElseIf flag = "DD" Then			'삭제 테이블로 이동
		dbcon.Execute "BEGIN Transaction"
		SQL = " INSERT INTO memt011	("_
			& "			uid, unm, pwd, dept, team, "_
			& "			ulvl, auth, base_vaca, spcl_vaca, email, "_
			& "			birth_yy, birth_mm, birth_dd, hp1, hp2, "_
			& "			hp3, zip, addr, sdate, edate, "_
			& "			open_yn, ot_pnt, pic, "_
			& "			rgid " _
			& " ) "_
			& "		SELECT	uid, unm, pwd, dept, team, "_
			& "				ulvl, auth, base_vaca, spcl_vaca, email, "_
			& "				birth_yy, birth_mm, birth_dd, hp1, hp2, "_
			& "				hp3, zip, addr, sdate, TRIM(CONVERT(CHAR(10),getdate(),112)), "_
			& "				open_yn, ot_pnt, pic, '"& USER_ID &"' "_
			& "		FROM	memt010 " _
			& "		WHERE	uid = '"& uid &"'"
'		Response.Write SQL &"<br><br>"
		dbcon.execute SQL

		SQL = "	DELETE FROM	memt030 WHERE uid = '"& uid &"' "
'		dbcon.execute SQL

		SQL = "	DELETE FROM	memt040 WHERE uid = '"& uid &"' "
'		dbcon.execute SQL

		SQL = "	DELETE FROM	memt050 WHERE uid = '"& uid &"' "
'		dbcon.execute SQL

		SQL = "	DELETE FROM	memt060 WHERE uid = '"& uid &"' "
'		dbcon.execute SQL

		SQL = "	DELETE FROM	memt070 WHERE uid = '"& uid &"' "
'		dbcon.execute SQL

		SQL = "	DELETE FROM	memt080 WHERE uid = '"& uid &"' "
'		dbcon.execute SQL

		SQL = "	DELETE FROM	memt010 WHERE uid = '"& uid &"' "
'		Response.Write SQL &"<br><br>"
		dbcon.execute SQL
		dbcon.Execute "COMMIT Transaction"
	End If
%>
<form name="fm1" id=fm1>
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
</form>
<script>
	alert("처리되었습니다.");
	$("#fm1").attr({action:"mem.asp", method:"POST", target:"_top"}).submit();
</script>
<%
	dbc()
%>
