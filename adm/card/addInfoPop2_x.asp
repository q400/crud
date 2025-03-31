<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop2_x.asp - 직원부가정보 (가족정보) 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	chk							= Request("chk")
	fam_nm						= SQLI(Request("fam_nm"))
	fam_rel						= SQLI(Request("fam_rel"))
	fam_etc						= SQLI(Request("fam_etc"))
	flag						= Request("flag")

	If fam_nm = "" Then fam_nm = " "
	If fam_rel = "" Then fam_rel = " "
	If fam_etc = "" Then fam_etc = " "

	If flag = "W" Then
		dbcon.Execute "BEGIN Transaction"

		'전체삭제
		SQL = " DELETE FROM memt040 WHERE uid = '"& uid &"'"
		dbcon.Execute SQL

		arr01 = Split(fam_nm, ", ")
		arr02 = Split(fam_rel, ", ")
		arr03 = Split(fam_etc, ", ")

		For m = LBound(arr01,1) To UBound(arr01,1)
			SQL = " INSERT INTO memt040 ("_
				& "			uid, "_
				& "			fam_nm, "_
				& "			fam_rel, "_
				& "			fam_etc, "_
				& "			rgid, "_
				& "			upid "_
				& " ) VALUES ( "_
				& "			'"& uid & "',"_
				& "			'"& Trim(arr01(m)) & "',"_
				& "			'"& Trim(arr02(m)) & "',"_
				& "			'"& Trim(arr03(m)) &"'," _
				& "			'"& USER_ID &"',"_
				& "			'"& USER_ID &"'"_
				& " )"
'			Response.Write SQL &"<br>"
			dbcon.Execute SQL
		Next
		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "D" Then
		arrChk = Split(Trim(chk), ",")

		For m = LBound(arrChk) To UBound(arrChk)
'			Response.Write "m : "& arrChk(m) &"<br>"
			SQL = " DELETE FROM memt040 WHERE seq = "& arrChk(m)
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
	$("#fm1").attr({action:"addInfoPop2.asp", method:"POST", target:"_parent"}).submit();
</script>