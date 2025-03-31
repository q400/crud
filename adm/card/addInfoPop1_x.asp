<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop1_x.asp - 직원부가정보 (학력정보) 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	chk							= Request("chk")
	sch_nm						= SQLI(Request("sch_nm"))
	sch_sdate					= SQLI(Request("sch_sdate"))
	sch_edate					= SQLI(Request("sch_edate"))
	sch_major					= SQLI(Request("sch_major"))
	sch_loca					= SQLI(Request("sch_loca"))
	flag						= Request("flag")
'	Response.Write "sch_nm : "& sch_nm &"<br>"

	If sch_nm = "" Then sch_nm = " "
	If sch_sdate = "" Then sch_sdate = " "
	If sch_edate = "" Then sch_edate = " "
	If sch_major = "" Then sch_major = " "
	If sch_loca = "" Then sch_loca = " "

	If flag = "W" Then
		dbcon.Execute "BEGIN Transaction"

		'전체삭제
		SQL = " DELETE FROM memt030 WHERE uid = '"& uid &"'"
		dbcon.Execute SQL

		arr01 = Split(sch_nm, ",")
		arr02 = Split(sch_sdate, ",")
		arr03 = Split(sch_edate, ",")
		arr04 = Split(sch_major, ",")
		arr05 = Split(sch_loca, ",")

		If Trim(arr01(0)) <> "" Then
			For k = LBound(arr01) To UBound(arr01)
				SQL = " INSERT INTO memt030 ("_
					& "			uid, "_
					& "			sch_nm, "_
					& "			sch_sdate, "_
					& "			sch_edate, "_
					& "			sch_major, "_
					& "			sch_loca, "_
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
			SQL = " DELETE FROM memt030 WHERE seq = "& arrChk(k)
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
	$("#fm1").attr({action:"addInfoPop1.asp", method:"POST", target:"_parent"}).submit();
</script>