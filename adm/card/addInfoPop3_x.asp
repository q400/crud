<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop3_x.asp - 직원부가정보 (경력정보) 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	chk							= Request("chk")
	com_nm						= SQLI(Request("com_nm"))
	com_sdate					= SQLI(Request("com_sdate"))
	com_edate					= SQLI(Request("com_edate"))
	com_work					= SQLI(Request("com_work"))
	com_level					= SQLI(Request("com_level"))
	com_rsn						= SQLI(Request("com_rsn"))
	flag						= Request("flag")
'	Response.Write "com_nm : "& com_nm &"<br>"

	If com_nm = "" Then com_nm = " "
	If com_sdate = "" Then com_sdate = " "
	If com_edate = "" Then com_edate = " "
	If com_work = "" Then com_work = " "
	If com_level = "" Then com_level = " "
	If com_rsn = "" Then com_rsn = " "

	If flag = "W" Then
		dbcon.Execute "BEGIN Transaction"

		'전체삭제
		SQL = " DELETE FROM memt050 WHERE uid = '"& uid &"'"
		dbcon.Execute SQL

		arr01 = Split(com_nm, ",")
		arr02 = Split(com_sdate, ",")
		arr03 = Split(com_edate, ",")
		arr04 = Split(com_work, ",")
		arr05 = Split(com_level, ",")
		arr06 = Split(com_rsn, ",")

		If Trim(arr01(0)) <> "" Then
			For k = LBound(arr01) To UBound(arr01)
				SQL = " INSERT INTO memt050 ("_
					& "			uid, "_
					& "			com_nm, "_
					& "			com_sdate, "_
					& "			com_edate, "_
					& "			com_work, "_
					& "			com_level, "_
					& "			com_rsn, "_
					& "			rgid, "_
					& "			upid "_
					& " ) VALUES ( "_
					& "			'"& uid & "',"_
					& "			'"& Trim(arr01(k)) & "',"_
					& "			'"& Trim(arr02(k)) & "',"_
					& "			'"& Trim(arr03(k)) & "',"_
					& "			'"& Trim(arr04(k)) & "',"_
					& "			'"& Trim(arr05(k)) & "',"_
					& "			'"& Trim(arr06(k)) & "',"_
					& "			'"& USER_ID &"',"_
					& "			'"& USER_ID &"'"_
					& " )"
'				Response.Write SQL &"<br>"
				dbcon.Execute SQL
			Next
		End If
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "D" Then
		arrChk = Split(Trim(chk), ",")

		For k = LBound(arrChk) To UBound(arrChk)
'			Response.Write "k : "& arrChk(k) &"<br>"
			SQL = " DELETE FROM memt050 WHERE seq = "& arrChk(k)
'			Response.Write SQL &"<br>"
			dbcon.Execute SQL
		Next
	End If
	dbc()
%>
<form name="fm1" id=fm1>
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
</form>
<script>
	alert("처리되었습니다.");
	$("#fm1").attr({action:"addInfoPop3.asp", method:"POST", target:"_parent"}).submit();
</script>