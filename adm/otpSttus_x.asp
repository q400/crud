<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: otpSttus_x.asp - OTP 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	cd3							= SQLI(Request("cd3"))
	page						= SQLI(Request("page"))
	gubn						= SQLI(Request("gubn"))
	setVal						= SQLI(Request("setVal"))
	otpNote						= SQLI(Request("otpNote"))
'	Response.Write "gubn : "& gubn &"<br>"

	If uid <> "" Then
		arrId = Split(uid, ",", -1)
		For k = LBound(arrId) To UBound(arrId) - 1
			uid_i = Trim(arrId(k))
'			Response.Write "<br>uid_i : "& uid_i &"<br>"
			rso()
			SQL = "	SELECT ot_pnt FROM memt010 WHERE uid = '"& uid_i &"' AND open_yn <> 'N' "
			rs.open SQL, dbcon, 3
			If Not rs.eof Then
				otPnt = rs("ot_pnt")
				If gubn = "적립" Then
					otPnt_u = otPnt + setVal
				Else
					otPnt_u = otPnt - setVal
				End If
			End If
			rsc()

			dbcon.Execute "BEGIN Transaction"
			'메인 테이블의 총 잔여갯수를 업데이트
			SQL = "UPDATE memt010 SET ot_pnt = "& otPnt_u &" WHERE uid='"& uid_i &"'"
'			Response.Write SQL
			dbcon.Execute SQL,,128

			'증가분 이력데이터를 추가
			SQL = "	INSERT INTO	ovtt010 ("_
				& "			uid"_
				& "			,ampm"_
				& "			,adm_chk"_
				& "			,sign1"_
				& "			,sign2"_
				& "			,sign3"_
				& "			,gubn"_
				& "			,point"_
				& "			,adate"_
				& "			,ddate"_
				& "			,cancel_yn"_
				& "			,cancel_date"_
				& "			,upid" _
				& " ) VALUES (" _
				& "			'"& uid_i &"'" _
				& "			,''" _
				& "			,'Y'" _
				& "			,''" _
				& "			,''" _
				& "			,''" _
				& "			,'"& gubn &"'" _
				& "			,"& setVal _
				& "			,''" _
				& "			,getdate()" _
				& "			,'N'" _
				& "			,''" _
				& "			,'"& USER_ID &"'"_
				& ")"
'			Response.Write SQL
			dbcon.Execute SQL,,128
			dbcon.Execute "COMMIT Transaction"
		Next
	Else
		Call alertClose3("비정상적 경로로 접근했습니다.")
	End If
%>
<form name="fm1" id=fm1>
<input type="hidden" name="cd1" value="<%=cd1%>" />
<input type="hidden" name="cd2" value="<%=cd2%>" />
<input type="hidden" name="cd3" value="<%=cd3%>" />
<input type="hidden" name="page" value="<%=page%>" />
</form>
<script>
	alert("<%=gubn%> 처리되었습니다.");
	$("#fm1").attr({action:"otpSttus.asp", method:"post", target:"_top"}).submit();
</script>
<%
	dbc()
%>