<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: addInfoPop5_x.asp - 직원부가정보 (급여정보) 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))
'	On Error Resume Next

	uid							= SQLI(Request("uid"))
	chk							= Request("chk")
	pay_date					= SQLI(Request("pay_date"))
	pay_note					= SQLI(Request("pay_note"))
	pay_amt						= SQLI(Request("pay_amt"))
	pay_rto						= SQLI(Request("pay_rto"))
	pay_rsn						= SQLI(Request("pay_rsn"))
	flag						= Request("flag")

	If pay_note = "" Then pay_note = " "
	If pay_rto = "" Then pay_rto = "-"
	If pay_rsn = "" Then pay_rsn = " "
'	Response.Write "pay_note : "& pay_note &"<br>"

	If flag = "W" Then
		If pay_date = "" Then
			Call OnlyAlert("정확한 값을 입력 바랍니다.")
			Response.End
		End If

		dbcon.Execute "BEGIN Transaction"

		'전체삭제
		SQL = " DELETE FROM memt070 WHERE uid = '"& uid &"'"
		dbcon.Execute SQL

		arr01 = Split(pay_date, ",", -1)
		arr04 = Split(pay_note, ",", -1)
		arr02 = Split(pay_amt, ",", -1)
		arr03 = Split(pay_rto, ",", -1)
		arr05 = Split(pay_rsn, ",", -1)

'		Response.Write "UBound : "& UBound(arr01) &"<br>"

		If Trim(arr01(0)) <> "" Then
				For k = 0 To UBound(arr01)
					SQL = " INSERT INTO memt070 ("_
						& "			uid, "_
						& "			pay_date, "_
						& "			pay_amt, "_
						& "			pay_rto, "_
						& "			pay_note, "_
						& "			pay_rsn, "_
						& "			rgid, "_
						& "			upid "_
						& " ) VALUES ( "_
						& "			'"& uid & "',"_
						& "			'"& Trim(arr01(k)) & "',"_
						& "			IIF('"& Trim(arr02(k)) &"' = '', 0, '"& Trim(arr02(k)) &"'), " _
						& "			IIF('"& Trim(arr03(k)) &"' = '', 0, '"& Trim(arr03(k)) &"'), " _
						& "			'"& Trim(arr04(k)) & "',"_
						& "			'"& Trim(arr05(k)) & "',"_
						& "			'"& USER_ID &"',"_
						& "			'"& USER_ID &"'"_
						& " )"
					Response.Write SQL &"<br>"
					dbcon.Execute SQL
				Next
		End If

		If Err.Number <> 0 Then
			Response.Write "오류 : "& Err.Description &"<br>"
		End If

		dbcon.Execute "COMMIT Transaction"

	ElseIf flag = "D" Then
		arrChk = Split(Trim(chk), ",")

		For k = LBound(arrChk) To UBound(arrChk)
'			Response.Write "k : "& arrChk(k) &"<br>"
			SQL = " DELETE FROM memt070 WHERE seq = "& Trim(arrChk(k))
'			Response.Write SQL &"<br>"
			dbcon.Execute SQL
		Next

		If Err.Number <> 0 Then
			Response.Write "오류 : "& Err.Description &"<br>"
		End If
	End If
	dbc()
%>
<form name="fm1" id=fm1>
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
</form>
<script>
	alert("처리되었습니다.");
	$("#fm1").attr({action:"addInfoPop5.asp", method:"POST", target:"_parent"}).submit();
</script>