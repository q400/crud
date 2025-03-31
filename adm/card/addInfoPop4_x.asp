<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop4.asp - 직원부가정보 (자격증정보) 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	chk							= Request("chk")
	license_nm					= SQLI(Request("license_nm"))
	license_lvl					= SQLI(Request("license_lvl"))
	license_date				= SQLI(Request("license_date"))
	license_no					= SQLI(Request("license_no"))
	license_inst				= SQLI(Request("license_inst"))
	flag						= Request("flag")
'	Response.Write "sch_nm : "& sch_nm &"<br>"

	If license_nm = "" Then license_nm = " "
	If license_lvl = "" Then license_lvl = " "
	If license_date = "" Then license_date = " "
	If license_no = "" Then license_no = " "
	If license_inst = "" Then license_inst = " "

	If flag = "W" Then
		dbcon.Execute "BEGIN Transaction"

		'전체삭제
		SQL = " DELETE FROM memt060 WHERE uid = '"& uid &"'"
		dbcon.Execute SQL

		arr01 = Split(license_nm, ",")
		arr02 = Split(license_lvl, ",")
		arr03 = Split(license_date, ",")
		arr04 = Split(license_no, ",")
		arr05 = Split(license_inst, ",")

		If Trim(arr01(0)) <> "" Then
			For k = LBound(arr01) To UBound(arr01)
				SQL = " INSERT INTO memt060 ("_
					& "			uid, "_
					& "			license_nm, "_
					& "			license_lvl, "_
					& "			license_date, "_
					& "			license_no, "_
					& "			license_inst, "_
					& "			rgid, "_
					& "			upid "_
					& " ) VALUES ( "_
					& "			'"& uid & "',"_
					& "			'"& Trim(arr01(k)) & "',"_
					& "			'"& Trim(arr02(k)) & "',"_
					& "			'"& Trim(arr03(k)) & "',"_
					& "			'"& Trim(arr04(k)) & "',"_
					& "			'"& Trim(arr05(k)) & "',"_
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
			SQL = " DELETE FROM memt060 WHERE seq = "& arrChk(k)
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
	$("#fm1").attr({action:"addInfoPop4.asp", method:"POST", target:"_parent"}).submit();
</script>