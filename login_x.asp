<!-- #include virtual = "/inc/header.asp" -->
<!-- #include virtual = "/lib/aes.asp" -->
<%
'************************************************************************************
'* 화면명	: login_x.asp
'************************************************************************************
	dbo()
	uid							= LCase(Replace(Request("uid"),"'","''"))
	pwd							= Request("passwd")
	encrypted					= AESEncrypt(uid, pwd)			'암호화 값
	preURL						= SQLI(Request("preURL"))
	uid_len						= Len(uid)

	If uid_len > 19 Then
		Call JSalert("아이디는 20자 이내로 입력하세요.")
		Response.End
	End If

	rso()
	SQL = " SELECT * FROM memt010 WHERE uid = '"& uid &"' AND open_yn = 'Y' "
	rs.open SQL, dbcon
'Response.Write "<br>"& SQL &"<br>"
	If rs.eof Then
		Call JSAlert("아이디가 존재하지 않거나 미승인 상태입니다.")
		Response.End
	Else
		If encrypted <> rs("pwd") Then			'암호화 값 불일치
			Call JSAlert("비밀번호가 일치하지 않습니다.")
			Response.End
		Else
			session.contents("USER_ID")			= uid
			session.contents("USER_NAME")		= rs("unm")
			session.contents("USER_COMP")		= rs("cid")
			session.contents("USER_HP")			= rs("hp1") & rs("hp2") & rs("hp3")
			session.contents("USER_ULVL")		= rs("ulvl")
			session.contents("USER_AUTH")		= CInt(Right(rs("auth"),4))			'우측 4자리 숫자로 변환
			session.contents("USER_DEPT")		= rs("dept")
			session.contents("USER_TEAM")		= rs("team")
			session.contents("USER_PIC")		= rs("pic")

'			Session.Timeout = 1			'분

'			Response.Cookies("OK_ID")			= uid
'			Response.Cookies("OK_ID").expires	= Date + 1							'7일간 보관

'			Response.Write "value : "& rs("auth") &"<br>"

			If USER_AUTH > 10 Then
				SQL = " INSERT INTO logt010 (uid, conn_ip, conn_tm) VALUES ('"& uid &"', '"& Request.ServerVariables("REMOTE_ADDR") &"', getdate()) "
				dbcon.Execute SQL
			End If

			If preURL = "" Or preURL = "login.asp" Then
				If CInt(Right(rs("auth"),4)) <> "" And CInt(Right(rs("auth"),4)) <= 10 Then
					Response.Redirect "/_adm/index.asp?chk=chk"
				Else
					Response.Redirect "/"
				End If
			Else
				Response.Redirect preURL
			End If
		End If
	End If
	rsc()
	dbc()
%>