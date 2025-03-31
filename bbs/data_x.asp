<%
'************************************************************************************
'*  ������ ��		: data_x.asp
'************************************************************************************
%>
<!-- #include virtual = "/inc/header.asp" -->
<%
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	Set upObj = Server.CreateObject("DEXT.FileUpload")			'÷������ ���� Dext Upload component
	upObj.DefaultPath = Server.MapPath(PATH_DATA)				'������
	upObj.MaxFileLen = 50 * 1024 * 1024							'�ϳ��� ���� ũ�⸦ 50M ���Ϸ� ����

	bbs_id					= SQLI(upObj("bbs_id"))				'1-����/2-�ڷ��/10-ȸ�Ƿ�/30-����/50-�����ڷ�
	seq						= SQLI(upObj("seq"))
	idx						= SQLI(upObj("idx"))
	page					= SQLI(upObj("page"))
	cd1					= SQLI(upObj("cd1"))
	cd2					= SQLI(upObj("cd2"))
	flag					= SQLI(upObj("flag"))

	title					= chkWord(upObj("title"))
	contents				= chkWord(upObj("contents"))
	note					= chkWord(upObj("note"))
	cbox					= SQLI(upObj("cbox"))

	If flag = "" Then flag = "W"

	serverPath = Server.MapPath(PATH_DATA)
	webPath = PATH_DATA
	vpath = "data"

	If USER_ID = "" Then
		Call AlertGo("���������� ������� �����߳׿�.","/")
		Response.End
	Else

	If flag = "W" Then							'����

		dbcon.Execute "BEGIN Transaction"
		SQL = "	INSERT INTO _cbbst010	(bbs_id, title, uid, contents) " _
			& "	VALUES ( " _
			& "			"& bbs_id &", " _
			& "			'"& title &"', " _
			& "			'"& USER_ID &"', " _
			& "			'"& contents &"') "
		dbcon.Execute SQL

		For I = 1 To upObj.Form("upFile").Count
			Set upFile = upObj.Form("upFile")(I)
			If upFile.Value <> "" Then
				If upFile.FileLen <= upObj.MaxFileLen Then
					ext				= upFile.FileExtension			'Ȯ����
					file_wd			= upFile.ImageWidth				'�̹��� ��
					If extcheck(UCase(ext)) = True Then
						upObj.DeleteAllSavedFiles
						dbcon.Execute "ROLLBACK Transaction"
						Call AlertGo("��� �Ұ����� �����Դϴ�.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
						Response.End
					Else
						Call upFile.SaveAs(serverPath &"\"& upFile.FileName, False)
						SQL = " INSERT INTO	_cbbst011 (bbs_id, seq, file_path, file_nm, file_sz, file_wd) " _
							& "	VALUES	( " _
							& "			"& bbs_id &", " _
							& "			IDENT_CURRENT('_cbbst010'), " _
							& "			'"& webPath &"', " _
							& "			'"& upFile.LastSavedFileName &"', " _
							& "			'"& upFile.FileLen &"', " _
							& "			'"& file_wd &"') "
						dbcon.Execute SQL,,128
					End If
				Else
					upObj.DeleteAllSavedFiles
					dbcon.Execute "ROLLBACK Transaction"
					Call AlertGo("5 MB������ ���ϸ� ����ϼ���.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
					Response.End
				End If
			End If
		Next
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "R" Then						'����

			SQL = "	INSERT INTO _cbbst013 (bbs_id, seq, uid, note) " _
				& "	VALUES ("& bbs_id &", "& seq &", '"& USER_ID &"', '"& note &"') "
			dbcon.Execute SQL

	ElseIf flag = "OPD" Then					'���ۻ���

			SQL = "	DELETE FROM	_cbbst013 WHERE idx = "& idx
			dbcon.Execute SQL

	ElseIf flag = "M" Then						'����

			dbcon.Execute "BEGIN Transaction"
			SQL = "	UPDATE	_cbbst010 SET " _
				& "			title = '"& title &"', " _
				& "			contents = '"& contents &"' " _
				& "	WHERE	bbs_id = "& bbs_id &" AND seq = "& seq
			dbcon.Execute SQL

			delPhoto_id = Split(cbox, ",")
			For Each key In delPhoto_id
				rso()
				SQL = " SELECT photo_id, bbs_id, seq, file_path, file_nm FROM _cbbst011 WHERE photo_id = "& key
				rs.open SQL, dbcon
				If Not rs.eof Then
					Set fs = Server.CreateObject("Scripting.FileSystemObject")
					If rs("file_nm") <> "" Then							'���������
						If fs.FileExists(serverPath & "\" & rs("file_nm")) Then
							fs.DeleteFile serverPath & "\" & rs("file_nm"), True		'����
						End If
					End If
					Set fs = Nothing
					SQL = "	DELETE FROM _cbbst011 WHERE photo_id = "& rs("photo_id")
					dbcon.Execute SQL
				End If
				rsc()
			Next

			For I = 1 To upObj.Form("upFile").Count
				Set upFile = upObj.Form("upFile")(I)
				If upFile.Value <> "" Then
					If upFile.FileLen <= upObj.MaxFileLen Then
						ext			= upFile.FileExtension					'Ȯ����
						If LCase(ext) = "asp" Or LCase(ext) = "aspx" Or LCase(ext) = "xml" Or LCase(ext) = "asa" Then
							upObj.DeleteAllSavedFiles
							dbcon.Execute "ROLLBACK Transaction"
							Call AlertGo("��� �Ұ����� �����Դϴ�.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
							Response.End
						Else
							Call upFile.SaveAs(serverPath &"\"& upFile.fileName, False)
							SQL = " INSERT INTO	_cbbst011	(bbs_id, seq, file_path, file_nm, file_sz, file_wd) " _
								& "	VALUES	( " _
								& "			"& bbs_id &", " _
								& "			"& seq &", " _
								& "			'"& webPath &"', " _
								& "			'"& upFile.LastSavedFileName &"', " _
								& "			'"& upFile.FileLen &"', " _
								& "			'"& upFile.ImageWidth &"') "
							dbcon.Execute SQL,,128
						End If
					Else
						upObj.DeleteAllSavedFiles
						dbcon.Execute "ROLLBACK Transaction"
						Call AlertGo("5 MB������ ���ϸ� ����ϼ���.",vpath &"_w.asp?page="& page &"&cd1="& cd1 &"&cd2="& cd2)
						Response.End
					End If
				End If
			Next
			dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "D" Then						'����

			rso()
			SQL = " SELECT	* FROM _cbbst011 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
			rs.open SQL, dbcon, 3
			If Not rs.eof Then					'���� ��� ���� �����
				Set ObjFile = Server.CreateObject("Scripting.FileSystemObject")
				While Not rs.eof

					If ObjFile.FileExists(serverPath & "\" & rs("file_nm")) Then
						ObjFile.DeleteFile serverPath & "\" & rs("file_nm"), True
					End If
					rs.MoveNext
				Wend
				Set ObjFile = Nothing
			End If
			rsc()

			SQL = "	DELETE FROM _cbbst010 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
			dbcon.Execute SQL
			SQL = "	DELETE FROM _cbbst011 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
			dbcon.Execute SQL
			SQL = "	DELETE FROM _cbbst012 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
			dbcon.Execute SQL
			SQL = "	DELETE FROM _cbbst013 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
			dbcon.Execute SQL

	End If
	dbc()
%>

<form name="fm1">
<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="cd1" value="<%=cd1%>">
<input type="hidden" name="cd2" value="<%=cd2%>">
<input type="hidden" name="page" value="<%=page%>">
</form>
<%		If flag = "W" Then %>
			<script>
				alert("�ԷµǾ����ϴ�.       ");
				document.fm1.action = "<%=vpath%>.asp";
				document.fm1.method = "post";
				document.fm1.target = "_top";
				document.fm1.submit();
			</script>
<%		ElseIf flag = "R" Then %>
			<script>
				alert("�ԷµǾ����ϴ�.       ");
				document.fm1.action = "<%=vpath%>_v.asp";
				document.fm1.method = "post";
				document.fm1.target = "_top";
				document.fm1.submit();
			</script>
<%		ElseIf flag = "OPD" Then %>
			<script>
				alert("������ �����Ǿ����ϴ�.       ");
				document.fm1.action = "<%=vpath%>_v.asp";
				document.fm1.method = "post";
				document.fm1.target = "_top";
				document.fm1.submit();
			</script>
<%		ElseIf flag = "M" Then %>
			<script>
				alert("�����Ǿ����ϴ�.       ");
				document.fm1.action = "<%=vpath%>_v.asp";
				document.fm1.method = "post";
				document.fm1.target = "_top";
				document.fm1.submit();
			</script>
<%		ElseIf flag = "D" Then %>
			<script>
				alert("�����Ǿ����ϴ�.       ");
				document.fm1.action = "<%=vpath%>.asp";
				document.fm1.method = "post";
				document.fm1.target = "_top";
				document.fm1.submit();
			</script>
<%		End If
	End If %>