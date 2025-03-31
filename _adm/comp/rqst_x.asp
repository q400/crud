<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: rqst_x.asp - 사용신청
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	Set upObj = Server.CreateObject("DEXT.FileUpload")			'첨부파일 저장 Dext Upload component
	upObj.CodePage = 65001
	upObj.DefaultPath = Server.MapPath(PATH_REQUEST)			'저장경로
	upObj.MaxFileLen = 20*1024*1024								'하나 20 MB로 제한

	bbs_id						= 100							'100-신청/200-작업요청
	seq							= SQLI(upObj("seq"))
	page						= SQLI(upObj("page"))
	cd1							= SQLI(upObj("cd1"))
	cd2							= SQLI(upObj("cd2"))
	flag						= SQLI(upObj("flag"))

	cid							= upObj("cid")					'고객사ID
	comp_nm						= chkWord(upObj("comp_nm"))
	induty_cl					= upObj("induty_cl")			'업종분류코드
	mngr_id						= upObj("mngr_id")				'담당자ID
	mngr_nm						= upObj("mngr_nm")				'담당자이름
	mngr_tel					= upObj("mngr_tel")				'담당자연락처
	mngr_eml					= upObj("mngr_eml")				'담당자이메일
	emp_cnt						= upObj("emp_cnt")				'직원수
	scrty_cmp					= upObj("scrty_cmp")			'보안업체
	sttus						= upObj("sttus")				'상태
	use_yn						= upObj("use_yn")
	opt1						= upObj("opt1")					'기본출근시간
	opt2						= upObj("opt2")					'기본퇴근시간
	contents					= upObj("contents")				'하고싶은 말씀
	cbox						= SQLI(upObj("cbox"))

	If flag = "" Then flag = "W"

	serverPath					= Server.MapPath(PATH_REQUEST)
	webPath						= PATH_REQUEST
	vpath						= "rqst"

	If flag = "W" Then							'쓰기
		dbcon.Execute "BEGIN Transaction"

		SQL = "	INSERT INTO cmpt010	(cid, comp_nm, induty_cl, mngr_id, mngr_nm, mngr_tel, mngr_eml, emp_cnt, scrty_cmp, opt1, opt2, contents) " _
			& "	VALUES ( " _
			& "			'"& cid &"', " _
			& "			'"& comp_nm &"', " _
			& "			'"& induty_cl &"', " _
			& "			'"& mngr_id &"', " _
			& "			'"& mngr_nm &"', " _
			& "			'"& mngr_tel &"', " _
			& "			'"& mngr_eml &"', " _
			& "			"& emp_cnt &", " _
			& "			'"& scrty_cmp &"'," _
			& "			'"& opt1 &"'," _
			& "			'"& opt2 &"'," _
			& "			'"& contents &"'" _
			& " )"
'		Response.Write "<br>"& SQL &"<br>"
		dbcon.Execute SQL

		For I = 1 To upObj.Form("upFile").Count
			Set upFile = upObj.Form("upFile")(I)
			If upFile.Value <> "" Then
				If upFile.FileLen <= upObj.MaxFileLen Then
					ext				= upFile.FileExtension			'확장자
					file_wd			= upFile.ImageWidth				'이미지 폭
					If LCase(ext) = "asp" Or LCase(ext) = "asa" Or LCase(ext) = "aspx" Or LCase(ext) = "xml" Then
						upObj.DeleteAllSavedFiles
						dbcon.Execute "ROLLBACK Transaction"
						Call AlertGo("등록 불가능 확장자입니다.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
					Else
						Call upFile.SaveAs(serverPath &"\"& upFile.FileName, False)
						SQL = " INSERT INTO	bbst051 (bbs_id, seq, file_path, file_nm, file_sz, file_wd, ext) " _
							& "	VALUES	( " _
							& "			"& bbs_id &", " _
							& "			IDENT_CURRENT('cmpt010'), " _
							& "			'"& webPath &"', " _
							& "			'"& upFile.LastSavedFileName &"', " _
							& "			'"& upFile.FileLen &"', " _
							& "			'"& file_wd &"',"_
							& "			'"& LCase(ext) &"'"_
							& ")"
						dbcon.Execute SQL,,128
					End If
				Else
					upObj.DeleteAllSavedFiles
					dbcon.Execute "ROLLBACK Transaction"
					Call AlertGo("20 MB이하의 파일만 등록하세요.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
				End If
			End If
		Next

		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "M" Then						'수정
		dbcon.Execute "BEGIN Transaction"

		SQL = "	UPDATE	cmpt010 SET " _
			& "			cid = '"& cid &"', " _
			& "			comp_nm = '"& comp_nm &"'," _
			& "			induty_cl = '"& induty_cl &"'," _
			& "			mngr_id = '"& mngr_id &"'," _
			& "			mngr_nm = '"& mngr_nm &"'," _
			& "			mngr_tel = '"& mngr_tel &"'," _
			& "			mngr_eml = '"& mngr_eml &"'," _
			& "			emp_cnt = "& emp_cnt &"," _
			& "			scrty_cmp = '"& scrty_cmp &"'," _
			& "			sttus = ISNULL('"& sttus &"', '진행중')," _
			& "			use_yn = ISNULL('"& use_yn &"', 'Y')," _
			& "			opt1 = '"& opt1 &"'," _
			& "			opt2 = '"& opt2 &"'," _
			& "			contents = '"& contents &"'" _
			& "	WHERE	seq = "& seq
		dbcon.Execute SQL

		'기본권한 + 경영지원부,기타 + 대표이사,원장,부장,사원,기타
		arrVal = "AA0050,AA0500,AA0700,AA0900,AA0999,AD1020,AD9990,AJ1010,AJ1015,AJ1040,AJ1135,AJ9990"
		arrVal = Split(arrVal, ",")

		For intLoop = LBound(arrVal) To UBound(arrVal)
			SQL = "	INSERT INTO codt020 (cid, up_cd, code_id, use_yn, opt1, opt2, odrby) VALUES ( "_
				& "		'"& cid &"'" _
				& ",	''" _
				& ",	'"& arrVal(intLoop) &"'" _
				& ",	'Y'" _
				& ",	'"& opt1 &"'" _
				& ",	'"& opt2 &"'" _
				& ",	''" _
				& ")"
'			Response.Write "권한 INSERT -<br>"& SQL &"<br>"
			dbcon.Execute SQL
		Next

		delFileId = Split(cbox, ",")
		For Each key In delFileId
			rso()
			SQL = " SELECT file_id, seq, file_path, file_nm FROM bbst051 WHERE file_id = "& key
			rs.open SQL, dbcon
			If Not rs.eof Then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				If rs("file_nm") <> "" Then				'파일존재시
					If fs.FileExists(serverPath & "\" & rs("file_nm")) Then
						fs.DeleteFile serverPath & "\" & rs("file_nm"), True
					End If
				End If
				Set fs = Nothing
				SQL = "	DELETE FROM bbst051 WHERE file_id = "& rs("file_id")
				dbcon.Execute SQL
			End If
			rsc()
		Next

		For I = 1 To upObj.Form("upFile").Count
			Set upFile = upObj.Form("upFile")(I)
			If upFile.Value <> "" Then
				If upFile.FileLen <= upObj.MaxFileLen Then
					ext				= upFile.FileExtension			'확장자
					file_wd			= upFile.ImageWidth				'이미지 폭
					If LCase(ext) = "asp" Or LCase(ext) = "asa" Or LCase(ext) = "aspx" Or LCase(ext) = "xml" Then
						upObj.DeleteAllSavedFiles
						dbcon.Execute "ROLLBACK Transaction"
						Call AlertGo("등록 불가능 확장자입니다.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
					Else
						Call upFile.SaveAs(serverPath &"\"& upFile.FileName, False)
						SQL = " INSERT INTO	bbst051 (bbs_id, seq, file_path, file_nm, file_sz, file_wd, ext) " _
							& "	VALUES	( " _
							& "			"& bbs_id &", " _
							& "			"& seq &", " _
							& "			'"& webPath &"', " _
							& "			'"& upFile.LastSavedFileName &"', " _
							& "			'"& upFile.FileLen &"', " _
							& "			'"& file_wd &"',"_
							& "			'"& LCase(ext) &"'"_
							& ")"
						dbcon.Execute SQL,,128
					End If
				Else
					upObj.DeleteAllSavedFiles
					dbcon.Execute "ROLLBACK Transaction"
					Call AlertGo("20 MB이하의 파일만 등록하세요.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
				End If
			End If
		Next

		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "delFile" Then					'첨부파일삭제
		delFileId = Split(cbox, ",")
		For Each key In delFileId
			rso()
			SQL = " SELECT file_id, seq, file_path, file_nm FROM bbst051 WHERE file_id = "& key
			rs.open SQL, dbcon

			If Not rs.eof Then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				If rs("file_nm") <> "" Then				'파일존재시
					If fs.FileExists(serverPath & "\" & rs("file_nm")) Then
						fs.DeleteFile serverPath & "\" & rs("file_nm"), True
					End If
				End If
				Set fs = Nothing

				SQL = "	DELETE FROM bbst051 WHERE file_id = "& rs("file_id")
				dbcon.Execute SQL
			End If
			rsc()
		Next

	ElseIf flag = "D" Then						'삭제
		dbcon.Execute "BEGIN Transaction"

		rso()
		SQL = " SELECT file_id, seq, file_path, file_nm FROM bbst051 WHERE seq = "& seq
		rs.open SQL, dbcon

		While Not rs.eof
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			If rs("file_nm") <> "" Then				'파일존재시
				If fs.FileExists(serverPath & "\" & rs("file_nm")) Then
					fs.DeleteFile serverPath & "\" & rs("file_nm"), True
				End If
			End If
			Set fs = Nothing
			SQL = "	DELETE FROM bbst051 WHERE file_id = "& rs("file_id")
			dbcon.Execute SQL
			rs.MoveNext
		Wend
		rsc()

		SQL = "	DELETE FROM codt020 WHERE cid = '"& cid &"' "
'		dbcon.Execute SQL

		SQL = "	DELETE FROM memt010 WHERE cid = '"& cid &"' "
'		dbcon.Execute SQL

		SQL = "	DELETE FROM cmpt010 WHERE seq = "& seq
'		dbcon.Execute SQL

		dbcon.Execute "COMMIT Transaction"

	End If
%>

<form name="fm1" id=fm1>
<input type="hidden" name="seq" id=seq value="<%=seq%>" />
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
<input type="hidden" name="flag" id=flag value="<%=flag%>" />
</form>
<%	If flag = "W" Then %>
<script>
	alert("등록되었습니다.");
	$("#fm1").attr({action:"/login.asp", method:"post", target:"_top"}).submit();
</script>
<%	ElseIf flag = "M" Then %>
<script>
	alert("기본 정보 입력과 함께 수정되었습니다.");
	$("#fm1").attr({action:"<%=vpath%>_w.asp", method:"post", target:"_top"}).submit();
</script>
<%	ElseIf flag = "delFile" Then %>
<script>
	alert("첨부파일이 삭제되었습니다.");
	$("#fm1").attr({action:"<%=vpath%>.asp", method:"post", target:"_top"}).submit();
</script>
<%	ElseIf flag = "D" Then %>
<script>
	alert("삭제되었습니다.");
	$("#fm1").attr({action:"<%=vpath%>.asp", method:"post", target:"_top"}).submit();
</script>
<%
	End If
	dbc()
%>