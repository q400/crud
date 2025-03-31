<!-- #include virtual = "/inc/header.asp" -->
<!-- #include virtual = "/inc/bsfCode.asp" -->
<%
'************************************************************************************
'* 화면명	: mem_x.asp 직원정보 수정
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, "/")

	uid							= SQLI(Request("uid"))
	cid							= SQLI(Request("cid"))
	open_yn						= SQLI(Request("open_yn"))			'정보공개 여부
	ot_pnt						= SQLI(Request("ot_pnt"))			'초과근무 point
	pwd1						= SQLI(Request("pwd1"))
	pwd2						= SQLI(Request("pwd2"))
	unm							= SQLI(Request("unm"))
	base_vaca					= SQLI(Request("base_vaca"))		'기본연차
	spcl_vaca					= SQLI(Request("spcl_vaca"))		'특별휴가
	email1						= SQLI(Request("email1"))
	email2						= SQLI(Request("email2"))
	hp1							= SQLI(Request("hp1"))
	hp2							= SQLI(Request("hp2"))
	hp3							= SQLI(Request("hp3"))
	emgc_tel					= SQLI(Request("emgc_tel"))			'비상연락망
	emgc_rel					= SQLI(Request("emgc_rel"))			'비상연락관계
	zip							= SQLI(Request("zip"))
	addr						= SQLI(Request("addr"))
	dept						= SQLI(Request("dept"))				'부서
	team						= SQLI(Request("team"))				'팀
	ulvl						= SQLI(Request("ulvl"))				'직급
	auth						= SQLI(Request("auth"))				'권한
	enterYY						= SQLI(Request("enterYY"))
	enterMM						= SQLI(Request("enterMM"))
	enterDD						= SQLI(Request("enterDD"))
	birthYY						= SQLI(Request("birthYY"))
	birthMM						= SQLI(Request("birthMM"))
	birthDD						= SQLI(Request("birthDD"))

	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	cd3							= SQLI(Request("cd3"))				'조직
	cd4							= SQLI(Request("cd4"))				'부서
	cd5							= SQLI(Request("cd5"))				'퇴사자
	cd6							= SQLI(Request("cd6"))				'직급
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&cd4="& cd4 &"&cd5="& cd5 &"&cd6="& cd6 &"&page="& page

	email						= email1 & "@" & email2
	enterDay					= enterYY & enterMM & enterDD
'	Response.Write "auth : "& auth &"<br>"

	Set cx = New BsfCode
	dbcon.Execute "BEGIN Transaction"

	If USER_ID <> "" Then
		SQL = "	UPDATE memt010 SET " _
			& "			unm = '"& unm &"'"
		If pwd1 <> "" Then
		SQL = SQL & ",	pwd = '"& cx.SetEncode(pwd1) &"'"
		End If
		SQL = SQL & ",	email = ISNULL('"& email &"','')" _
			& ",		open_yn = ISNULL('"& open_yn &"','N')" _
			& ",		hp1 = '"& hp1 &"'" _
			& ",		hp2 = '"& hp2 &"'" _
			& ",		hp3 = '"& hp3 &"'" _
			& ",		birth_yy = '"& birthYY &"'" _
			& ",		birth_mm = '"& birthMM &"'" _
			& ",		birth_dd = '"& birthDD &"'" _
			& ",		ulvl = ISNULL('"& ulvl &"','')" _
			& ",		auth = ISNULL('"& auth &"','AA0990')" _
			& ",		upid = '"& USER_ID &"'" _
			& ",		updt = getdate()" _
			& ",		zip = '"& zip &"'" _
			& ",		addr = '"& addr &"'" _
			& "	WHERE	uid = '"& uid &"' "
'		Response.Write "<br>"& SQL &"<br>"
		dbcon.Execute SQL

		SQL2= " MERGE INTO memt020 x " _
			& " USING (SELECT 1 as DUAL) y ON x.uid = '"& uid &"' " _
			& " WHEN MATCHED THEN " _
			& "		UPDATE SET " _
			& "			x.emgc_tel = ISNULL('"& emgc_tel &"',''), " _
			& "			x.emgc_rel = ISNULL('"& emgc_rel &"','') " _
			& "	WHEN NOT MATCHED THEN " _
			& "		INSERT(uid, css, emgc_tel, emgc_rel, fontsz) VALUES ( " _
			& "			'"& uid &"'," _
			& "			'bg01'," _
			& "			ISNULL('"& emgc_tel &"','')," _
			& "			ISNULL('"& emgc_rel &"','')," _
			& "			1.0 " _
			& "		);"
		dbcon.Execute SQL2
	End If
	dbcon.Execute "COMMIT Transaction"

	If flag = "ADMIN" Then		'관리자권한부여
		SQL = "	UPDATE memt010 SET " _
			& "			auth = 'AA0050'" _
			& " WHERE	uid = '"& uid &"' "
		dbcon.Execute SQL
	End If
%>
<form name="fm1" id=fm1>
<input type="hidden" name="cid" id=cid value="<%=cid%>" />
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="cd3" id=cd3 value="<%=cd3%>" />
<input type="hidden" name="cd4" id=cd4 value="<%=cd4%>" />
<input type="hidden" name="cd5" id=cd5 value="<%=cd5%>" />
<input type="hidden" name="cd6" id=cd6 value="<%=cd6%>" />
<input type="hidden" name="cd7" id=cd7 value="<%=cd7%>" />
<input type="hidden" name="page" value="<%=page%>" />
</form>
<script>
	alert("정보가 수정되었습니다.");
	$("#fm1").attr({action:"mem.asp", method:"POST", target:"_top"}).submit();
</script>
<%
	Set cx = Nothing
	dbc()
%>