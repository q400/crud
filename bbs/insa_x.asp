<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: insa_x.asp - 인사발령
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	Set upObj = Server.CreateObject("DEXT.FileUpload")			'첨부파일 저장 Dext Upload component
	upObj.CodePage = 65001
	upObj.DefaultPath = Server.MapPath(PATH_INSA)				'저장경로
	upObj.MaxFileLen = 20*1024*1024								'하나 20 MB로 제한

	bbs_id						= 200							'100-공지/200-인사발령/300-자료/400-사진자료/500-일간브리핑/900-작업
	seq							= SQLI(upObj("seq"))
	page						= SQLI(upObj("page"))
	cd1							= SQLI(upObj("cd1"))
	cd2							= SQLI(upObj("cd2"))
	flag						= SQLI(upObj("flag"))

	title						= chkWord(upObj("title"))
	noti_yn						= upObj("noti_yn")				'상단공지
	atm_yn						= upObj("atm_yn")				'상시공지
	contents					= upObj("contents")
	cbox						= SQLI(upObj("cbox"))

	If flag = "" Then flag = "W"

	serverPath					= Server.MapPath(PATH_INSA)
	webPath						= PATH_INSA
	vpath						= "insa"

	If flag = "W" Then							'쓰기
		dbcon.Execute "BEGIN Transaction"
		SQL = "	INSERT INTO bbst010	(bbs_id, cid, title, uid, noti_yn, atm_yn, contents) " _
			& "	VALUES ( " _
			& "			"& bbs_id &", " _
			& "			'"& USER_COMP &"', " _
			& "			'"& title &"', " _
			& "			'"& USER_ID &"', " _
			& "			IIF('"& noti_yn &"' = 'Y', 'Y', 'N'), " _
			& "			IIF('"& atm_yn &"' = 'Y', 'Y', 'N'), " _
			& "			'"& contents &"'" _
			& " )"
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
						SQL = " INSERT INTO	bbst011 (bbs_id, seq, file_path, file_nm, file_sz, file_wd, ext) " _
							& "	VALUES	( " _
							& "			"& bbs_id &", " _
							& "			IDENT_CURRENT('bbst010'), " _
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
		SQL = "	UPDATE	bbst010 SET " _
			& "			title = '"& title &"', " _
			& "			noti_yn = IIF('"& noti_yn &"' = 'Y', 'Y', 'N'), " _
			& "			atm_yn = IIF('"& atm_yn &"' = 'Y', 'Y', 'N'), " _
			& "			contents = '"& contents &"' " _
			& "	WHERE	bbs_id = "& bbs_id &" AND seq = "& seq
		dbcon.Execute SQL

		delFileId = Split(cbox, ",")
		For Each key In delFileId
			rso()
			SQL = " SELECT file_id, seq, file_path, file_nm FROM bbst011 WHERE file_id = "& key
			rs.open SQL, dbcon
			If Not rs.eof Then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				If rs("file_nm") <> "" Then				'파일존재시
					If fs.FileExists(serverPath & "\" & rs("file_nm")) Then
						fs.DeleteFile serverPath & "\" & rs("file_nm"), True
					End If
				End If
				Set fs = Nothing
				SQL = "	DELETE FROM bbst011 WHERE file_id = "& rs("file_id")
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
						SQL = " INSERT INTO	bbst011 (bbs_id, seq, file_path, file_nm, file_sz, file_wd, ext) " _
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
			SQL = " SELECT file_id, seq, file_path, file_nm FROM bbst011 WHERE file_id = "& key
			rs.open SQL, dbcon

			If Not rs.eof Then
				Set fs = Server.CreateObject("Scripting.FileSystemObject")
				If rs("file_nm") <> "" Then				'파일존재시
					If fs.FileExists(serverPath & "\" & rs("file_nm")) Then
						fs.DeleteFile serverPath & "\" & rs("file_nm"), True
					End If
				End If
				Set fs = Nothing

				SQL = "	DELETE FROM bbst011 WHERE file_id = "& rs("file_id")
				dbcon.Execute SQL
			End If
			rsc()
		Next

	ElseIf flag = "D" Then						'삭제
		dbcon.Execute "BEGIN Transaction"
		rso()
		SQL = " SELECT file_id, seq, file_path, file_nm FROM bbst011 WHERE seq = "& seq
		rs.open SQL, dbcon

		While Not rs.eof
			Set fs = Server.CreateObject("Scripting.FileSystemObject")
			If rs("file_nm") <> "" Then				'파일존재시
				If fs.FileExists(serverPath & "\" & rs("file_nm")) Then
					fs.DeleteFile serverPath & "\" & rs("file_nm"), True
				End If
			End If
			Set fs = Nothing
			SQL = "	DELETE FROM bbst011 WHERE file_id = "& rs("file_id")
			dbcon.Execute SQL
			rs.MoveNext
		Wend
		rsc()

		SQL = "	DELETE FROM bbst010 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
		dbcon.Execute SQL

		SQL = "	DELETE FROM bbst012 WHERE seq = "& seq
		dbcon.Execute SQL
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
	$("#fm1").attr({action:"<%=vpath%>.asp", method:"post", target:"_top"}).submit();
</script>
<%	ElseIf flag = "M" Then %>
<script>
	alert("수정되었습니다.");
	$("#fm1").attr({action:"<%=vpath%>.asp", method:"post", target:"_top"}).submit();
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