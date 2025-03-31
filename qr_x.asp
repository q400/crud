<!-- #include virtual = "/inc/mHeader.asp" -->
<%
'************************************************************************************
'* 화면명	: qr.asp
'************************************************************************************
%>
<%
	uid							= SQLI(Request("uid"))
	cid							= SQLI(Request("cid"))				'업체코드
	att							= SQLI(Request("att"))				'출근/퇴근 구분
	hp							= SQLI(Request("hp"))				'휴대전화번호
	d1							= SQLI(Request("d1"))				'yyyy-MM-dd
	d2							= SQLI(Request("d2"))				'24HH:mm:ss
	ip							= SQLI(Request("ip"))				'IP주소
	lat							= SQLI(Request("lat"))				'위도
	lon							= SQLI(Request("lon"))				'경도

	If uid = "" Then
		Call JSalert("아이디가 없습니다.")
		Response.End
	End If

	rso()
	SQL = " SELECT TOP 1 datediff(mi, '"& d1 &" "& d2 &"', getdate()) diff, " _
		& "		CONVERT(CHAR(19),getdate(),120) d0, " _
		& "		REPLACE(CONVERT(CHAR(8),getdate(),108),':','') d2 " _
		& " FROM cmpt010 "
'Response.Write "<br>"& SQL &"<br>"
	rs.open SQL, dbcon
	If Not rs.eof Then
		diff					= rs("diff") 'qr생성 시간과 현재시간 차
		d0						= rs("d0") 'yyyy-MM-dd hh:mm:ss
		d2						= rs("d2") 'hhmmss
	End If
	rsc()

	'Response.Write "QR코드 생성 후 "& diff &"분이 지났습니다.<br>10분 이내만 유효합니다."

	If diff > 10 Then
		Call JSalert("유효하지 않은 시간입니다.")
		Response.End
	End If

	rso()
	SQL = " SELECT hp2, hp3, unm FROM memt010 WHERE uid = '"& uid &"' "
	rs.open SQL, dbcon
	If rs.eof Then
		Call JSAlert("휴대전화번호가 없습니다.")
		Response.End
	Else
		If rs("hp2") & rs("hp3") <> hp Then
			Call JSAlert("휴대전화번호가 일치하지 않습니다.")
			Response.End
		End If
		unm = rs("unm")
	End If
	rsc()

	dbcon.Execute "BEGIN Transaction"
		SQL = " MERGE INTO work_history X " _
			& "	USING (SELECT 1 as DUAL) Y " _
			& "	ON ( " _
			& "		work_dt = REPLACE('"& d1 &"','-','') AND uid = '"& uid &"'" _
			& "	) " _
			& "	WHEN MATCHED THEN " _
			& "		UPDATE SET " _
			& "			cid = '"& cid &"'"
	If att = "in" Then
		SQL = SQL & "	,wstime = '"& d0 &"' " _
			& "			,wstm = LEFT('"& d2 &"', 4) "
	Else
		SQL = SQL &" 	,wctime = '"& d0 &"' " _
			& "			,wctm = LEFT('"& d2 &"', 4) "
	End If
		SQL = SQL &" 	,lat = '"& lat &"' " _
			& "			,lon =  '"& lon &"' " _
			& "			,ip =  '"& ip &"' " _
			& "			,updt = getdate() " _
			& "	WHEN NOT MATCHED THEN " _
			& "		INSERT( " _
			& "			work_dt " _
			& "			,cid " _
			& "			,uid " _
			& "			,nm " _
			& "			,wstime " _
			& "			,wstm " _
			& "			,wctime " _
			& "			,wctm " _
			& "			,lat " _
			& "			,lon " _
			& "			,ip " _
			& "			,rgdt " _
			& "		) VALUES ( " _
			& "			REPLACE('"& d1 &"','-','') " _
			& "			,'"& cid &"' " _
			& "			,'"& uid &"' " _
			& "			,'"& unm &"' "
	If att = "in" Then
		SQL = SQL &" 	,'"& d0 &"'" _
			& "			,LEFT('"& d2 &"', 4) " _
			& "			,'' " _
			& "			,'' "
	Else
		SQL = SQL &" 	,''" _
			& "			,'' " _
			& "			,'"& d0 &"' " _
			& "			,LEFT('"& d2 &"', 4) "
	End If
		SQL = SQL &" 	,'"& lat &"' " _
			& "			,'"& lon &"' " _
			& "			,'"& ip &"' " _
			& "			,getdate() " _
			& "		);"
'		Response.Write "<br>"& SQL &"<br>"
		dbcon.Execute SQL
	dbcon.Execute "COMMIT Transaction"

	Call AlertGo(tm &" 처리되었습니다.", "/")
	dbc()
%>
