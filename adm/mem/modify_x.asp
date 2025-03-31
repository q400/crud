<!-- #include virtual = "/inc/header.asp" -->
<!-- #include virtual = "/lib/aes.asp" -->
<%
'************************************************************************************
'* 화면명	: modify_x.asp - 직원정보 수정
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, "/")

	Set upObj = Server.CreateObject("DEXT.FileUpload")			'첨부파일 저장 Dext Upload component
	upObj.CodePage = 65001
	upObj.DefaultPath = Server.MapPath(PATH_PIC)				'직원사진 경로
	Set objImage = Server.CreateObject("DEXT.ImageProc")

	uid							= SQLI(upObj("uid"))
	ot_pnt						= SQLI(upObj("ot_pnt"))			'초과근무 point
	pwd1						= SQLI(upObj("pwd1"))
	pwd2						= SQLI(upObj("pwd2"))
	unm							= SQLI(upObj("unm"))
	base_vaca					= SQLI(upObj("base_vaca"))		'기본연차
	spcl_vaca					= SQLI(upObj("spcl_vaca"))		'특별휴가
	email1						= SQLI(upObj("email1"))
	email2						= SQLI(upObj("email2"))
	hp1							= SQLI(upObj("hp1"))
	hp2							= SQLI(upObj("hp2"))
	hp3							= SQLI(upObj("hp3"))
	emgc_tel					= SQLI(upObj("emgc_tel"))		'비상연락망
	emgc_rel					= SQLI(upObj("emgc_rel"))		'비상연락관계
	zip							= SQLI(upObj("zip"))
	addr						= SQLI(upObj("addr"))
	dept						= SQLI(upObj("dept"))			'부서
	team						= SQLI(upObj("team"))			'팀
	ulvl						= SQLI(upObj("ulvl"))			'직급
	auth						= SQLI(upObj("auth"))			'권한
	enterYY						= SQLI(upObj("enterYY"))
	enterMM						= SQLI(upObj("enterMM"))
	enterDD						= SQLI(upObj("enterDD"))
	birthYY						= SQLI(upObj("birthYY"))
	birthMM						= SQLI(upObj("birthMM"))
	birthDD						= SQLI(upObj("birthDD"))
	open_yn						= SQLI(upObj("open_yn"))

	cd1							= SQLI(upObj("cd1"))
	cd2							= SQLI(upObj("cd2"))
	cd3							= SQLI(upObj("cd3"))			'조직
	cd4							= SQLI(upObj("cd4"))			'부서
	cd5							= SQLI(upObj("cd5"))			'퇴사자
	cd6							= SQLI(upObj("cd6"))			'직급
	cd7							= SQLI(upObj("cd7"))			'권한
	page						= SQLI(upObj("page"))
	flag						= SQLI(upObj("flag"))

	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&cd4="& cd4 &"&cd5="& cd5 &"&cd6="& cd6 &"&cd7="& cd7 &"&page="& page

	email						= email1 & "@" & email2
	enterDay					= enterYY & enterMM & enterDD

'	Response.Write "flag : "& flag &"<br>"

	serverPath					= Server.MapPath(PATH_PIC)
	webPath						= PATH_PIC

	Set upFile = upObj.Form("upFile")

	If upFile.Value <> "" Then
		rso()
		SQL = " SELECT pic FROM memt010 WHERE uid = '"& uid &"' "
		rs.open SQL, dbcon
		If Not rs.eof Then
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			If rs("pic") <> "" Then			'파일존재시
				If fs.FileExists(serverPath & "\" & rs("pic")) Then
					fs.DeleteFile serverPath & "\" & rs("pic"), True
				End If
				If fs.FileExists(serverPath & "\s" & rs("pic")) Then
					fs.DeleteFile serverPath & "\s" & rs("pic"), True
				End If
			End If
			Set fs = Nothing
		End If
		rsc()

		ext = upFile.FileExtension					'확장자
		iwidth = upFile.ImageWidth					'이미지 폭
		iheight = upFile.ImageHeight				'이미지 높이

		ratio20 = iheight*20/iwidth					'목록용
		ratio50 = iheight*50/iwidth					'조직도용
		ratio150 = iheight*150/iwidth				'원본용

'		newFileNm = unm &"_"& hp3 &"."& ext			'파일이름 생성
'		Response.Write "iwidth : "& iwidth &"<br>"

		If LCase(ext)="asp" Or LCase(ext)="asa" Or LCase(ext)="aspx" Or LCase(ext)="xml" Then
			upObj.DeleteAllSavedFiles
			Call AlertGo("등록 불가능 확장자입니다.","modify.asp?uid="& uid &"&"& pageParam)
			dbcon.Execute "ROLLBACK Transaction"
		Else
'			If iwidth >= 150 And iwidth <= 200 Then				'150~200 size = 정상
				If True = objImage.SetSourceFile(upFile.TempFilePath) Then		'임시저장
					fileNm1 = "ss"& unm &"_"& hp3 &".jpg"		'20 size
					fileNm2 = "s"& unm &"_"& hp3 &".jpg"		'50 size
					fileNm3 = unm &"_"& hp3 &".jpg"				'150 size
					'썸네일 20 size
					Call objImage.SaveasThumbnail(serverPath &"\"& fileNm1, objImage.ImageWidth/iwidth*20, objImage.ImageHeight/iheight*ratio20, True)
					'썸네일 50 size
					Call objImage.SaveasThumbnail(serverPath &"\"& fileNm2, objImage.ImageWidth/iwidth*50, objImage.ImageHeight/iheight*ratio50, True)
					'정상사진
					Call objImage.SaveasThumbnail(serverPath &"\"& fileNm3, objImage.ImageWidth/iwidth*150, objImage.ImageHeight/iheight*ratio150, True)
				End If
'			Else
'				Call AlertGo("가로 크기 150~200픽셀의 사진을 등록하세요.","modify.asp?uid="& uid &"&"& pageParam)
'			End If
'			Call upFile.SaveAs(serverPath &"\"& fileNm3, True)			'덮어쓰기 OK
		End If
	End If

	If USER_ID <> "" Then
		If flag = "RESET" Then		'비밀번호 reset
			msg = "비밀번호가 12345로 리셋되었습니다."
			dbcon.Execute "BEGIN Transaction"
			SQL = "	UPDATE memt010 SET " _
				& "		pwd = '"& AESEncrypt(uid, "12345") &"'" _
				& ",	upid = '"& USER_ID &"'" _
				& ",	updt = getdate()" _
				& "	WHERE uid = '"& uid &"' "
			dbcon.Execute SQL
			SQL = "	INSERT INTO logt020 (" _
				& "			gubn, trgt, rgid, note" _
				& " ) VALUES (" _
				& "			'M'" _
				& ",		'"& uid &"'" _
				& ",		'"& USER_ID &"'" _
				& ",		'"& memInfo(uid, "unm") &" 비밀번호 초기화'" _
				& ")"
			dbcon.Execute SQL
			dbcon.Execute "COMMIT Transaction"
		Else
			msg = "처리되었습니다."
			dbcon.Execute "BEGIN Transaction"
			SQL = "	UPDATE memt010 SET " _
				& "		unm = '"& unm &"'"
			If pwd1 <> "" Then
			SQL = SQL & ", pwd = '"& AESEncrypt(uid, pwd1) &"'"
			End If
			If dept <> "" Then
			SQL = SQL & ", dept = '"& dept &"'"
			End If
			If team <> "" Then
			SQL = SQL & ", team = '"& team &"'"
			End If
			If ulvl <> "" Then
			SQL = SQL & ", ulvl = '"& ulvl &"'"
			End If
			If auth <> "" Then
			SQL = SQL & ", auth = '"& auth &"'"
			End If
			SQL = SQL & ", ot_pnt = '"& ot_pnt &"'" _
				& ",	base_vaca = '"& base_vaca &"'" _
				& ",	spcl_vaca = '"& spcl_vaca &"'" _
				& ",	email = '"& email &"'" _
				& ",	hp1 = '"& hp1 &"'" _
				& ",	hp2 = '"& hp2 &"'" _
				& ",	hp3 = '"& hp3 &"'" _
				& ",	birth_yy = '"& birthYY &"'" _
				& ",	birth_mm = '"& birthMM &"'" _
				& ",	birth_dd = '"& birthDD &"'" _
				& ",	open_yn = '"& open_yn &"'" _
				& ",	upid = '"& USER_ID &"'" _
				& ",	updt = getdate()" _
				& ",	zip = '"& zip &"'" _
				& ",	addr = '"& addr &"'"
			If upFile.Value <> "" Then
			SQL = SQL & ",	pic = '"& fileNm3 &"'"
			End If
			SQL = SQL & ",	sdate = '"& enterDay &"'" _
				& "	WHERE	uid = '"& uid &"' "
			dbcon.Execute SQL

			SQL = "	INSERT INTO logt020 (" _
				& "			gubn, trgt, rgid, note" _
				& " ) VALUES (" _
				& "			'M'" _
				& ",		'"& uid &"'" _
				& ",		'"& USER_ID &"'" _
				& ",		'"& memInfo(uid, "unm") &" 직원정보 수정'" _
				& ")"
			dbcon.Execute SQL

			If emgc_tel <> "" Then
				rso()
				SQL = "	SELECT COUNT(*) FROM memt020 WHERE uid = '"& uid &"' "
'				Response.Write "<br>"& SQL &"<br>"
				rs.open SQL, dbCon, 3
					rCnt = rs(0)
				rsc()

				If rCnt = 0 Then	'없을때
					SQL = "	INSERT INTO memt020 (" _
						& "			uid, css, emgc_tel, emgc_rel" _
						& " ) VALUES (" _
						& "			'"& uid &"'" _
						& ",		''" _
						& ",		'"& emgc_tel &"'" _
						& ",		'"& emgc_rel &"'" _
						& ")"
					dbcon.Execute SQL
				Else				'있을때
					SQL = "	UPDATE memt020 SET " _
						& "			emgc_tel = '"& emgc_tel &"'" _
						& ",		emgc_rel = '"& emgc_rel &"'" _
						& "	WHERE	uid = '"& uid &"' "
					dbcon.Execute SQL
				End If
			End If
			dbcon.Execute "COMMIT Transaction"
		End If
	End If

	Set objImage = Nothing
	Set upObj = Nothing
	dbc()
%>
<form name="fm1" id=fm1>
<input type="hidden" name="cd1" id="cd1" value="<%=cd1%>">
<input type="hidden" name="cd2" id="cd2" value="<%=cd2%>">
<input type="hidden" name="cd3" id="cd3" value="<%=cd3%>">
<input type="hidden" name="cd4" id="cd4" value="<%=cd4%>">
<input type="hidden" name="cd5" id="cd5" value="<%=cd5%>">
<input type="hidden" name="cd6" id="cd6" value="<%=cd6%>">
<input type="hidden" name="cd7" id="cd7" value="<%=cd7%>">
<input type="hidden" name="page" id="page" value="<%=page%>">
</form>
<script>
	alert("<%=msg%>");
	$("#fm1").attr({action:"mem.asp", method:"post", target:"_top"}).submit();
</script>
