<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop6.asp - 직원부가정보 (인사고과정보) 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	chk							= Request("chk")
	rating_date					= SQLI(Request("rating_date"))
	rating_gubn					= SQLI(Request("rating_gubn"))
	rating_note					= SQLI(Request("rating_note"))
	rating_etc					= SQLI(Request("rating_etc"))
	flag						= Request("flag")
'	Response.Write "rating_date : "& rating_date &"<br>"

	If rating_date = "" Then rating_date = " "
	If rating_gubn = "" Then rating_gubn = " "
	If rating_note = "" Then rating_note = " "
	If rating_etc = "" Then rating_etc = " "

	If flag = "W" Then
		dbcon.Execute "BEGIN Transaction"

		'전체삭제
		SQL = " DELETE FROM memt080 WHERE uid = '"& uid &"'"
		dbcon.Execute SQL

		arr01 = Split(rating_date, ",")
		arr02 = Split(rating_gubn, ",")
		arr03 = Split(rating_note, ",")
		arr04 = Split(rating_etc, ",")

		If Trim(arr01(0)) <> "" Then
			For k = LBound(arr01) To UBound(arr01)
				SQL = " INSERT INTO memt080 ("_
					& "			uid, "_
					& "			rating_date, "_
					& "			rating_gubn, "_
					& "			rating_note, "_
					& "			rating_etc, "_
					& "			rgid, "_
					& "			upid "_
					& " ) VALUES ( "_
					& "			'"& uid & "',"_
					& "			'"& Trim(arr01(k)) & "',"_
					& "			'"& Trim(arr02(k)) & "',"_
					& "			'"& Trim(arr03(k)) & "',"_
					& "			'"& Trim(arr04(k)) & "',"_
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
			SQL = " DELETE FROM memt080 WHERE seq = "& arrChk(k)
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
	$("#fm1").attr({action:"addInfoPop6.asp", method:"POST", target:"_parent"}).submit();
</script>