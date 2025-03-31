<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: latePop.asp - 지각현황 popup
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	vYear						= SQLI(Request("pYear"))
	vMonth						= SQLI(Request("pMonth"))
	vToday						= SQLI(Request("pDay"))

	If vYear = "" Then vYear = Year(Date)
	If vMonth = "" Then vMonth = Month(Date)
	If vToday = "" Then vToday = Day(Date)

	vDate = CDate(vYear&"/"&vMonth&"/01")
	vThisWeek = Weekday(CDate(vYear&"/"&vMonth&"/"&vToday))
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnClose").click(function (){		//닫기
		simsClosePopup();
	});
});
function chkLate(ldate){
	$("#lateDt").val(ldate);
	$("#fm1").attr({action:"late_x.asp", method:"post"}).submit();
}
</script>


<form name="fm1" id=fm1>
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
<input type="hidden" name="lateDt" id="lateDt" />
<input type="hidden" name="flag" id="flag" value="LI" />
<div>
	<div class="mt20 ml10 mr10">
		<div class="ml5">
			<a href="?pYear=<%=Year(vDate-1)%>&pMonth=<%=Month(vDate-1)%>&pDay=01&uid=<%=uid%>">[이전달]</a>
			<a href="?pYear=<%=Year(Date)%>&pMonth=<%=Month(Date)%>&pDay=<%=Day(Date)%>&uid=<%=uid%>"><b class="f20 ff fc8"><%=vYear%> . <%=setp(vMonth)%></b></a>
			<a href="?pYear=<%=Year(vDate+31)%>&pMonth=<%=Month(vDate+31)%>&pDay=01&uid=<%=uid%>">[다음달]</a>
		</div>
		<div class="">
			<span class="fc9 frt mb5 mr10">지각일자를 체크하세요.</span>
		</div>
		<table width=100% border=1 cellspacing="0" cellpadding="0" align="center" bordercolor="#b2bdd5" style="border-collapse:collapse;">
			<tr align="center" bgcolor="#404955" height="20">
				<td>일</td>
				<td width="15%">월</td>
				<td width="15%">화</td>
				<td width="15%">수</td>
				<td width="15%">목</td>
				<td width="15%">금</td>
				<td width="15%">토</td>
			</tr>
			<tr>
<%
	i = 1
	j = 1

	vLastday = Day(CDate(Year(vDate)&"/"& Month(vDate+31)&"/"&"01") - 1)
	vFirstWeek = Weekday(vDate)

	vDay = 1

	If ( vFirstWeek = 6 And vLastday = 31 ) Or ( vFirstWeek = 7 ) Then
		vDisplayCol = 42
	Else
		vDisplayCol = 35
	End If

	While i <= vDisplayCol
		If j = 8 Then
%>
			</tr>
			<tr height="40">
<%
			j = 1
		End If

		If j = 7 Then
			fColor = "#5c7b9e"
		ElseIf j = 1 Then
			fColor = "#f86259"
		Else
			fColor = "#fff"
		End If

		If (vFirstWeek = j And vDay = 1) Or (vDay > 1 And vDay <= vLastday) Then
			rso()
			SQL = " SELECT COUNT(*) FROM latt010 WHERE ldate = '"& vYear &"-"& setP(vMonth) &"-"& setP(vDay) &"' AND uid = '"& uid &"' "
			rs.open SQL, dbcon
			If Not rs.eof Then
				lcnt = rs(0)
			End If
			rsc()
%>
				<td style="padding:3px;">
					<table width="64" cellspacing="0" cellpadding="0" align="center" bordercolor="#c88080" style="border-collapse:collapse;border:1 dotted;">
						<tr style="padding:2px;">
							<td align="right">
								<b><font color="<%=fColor%>"><%=setP(vDay)%></font></b>
								<input type="checkbox" name="lateChk" id="lateChk" value="Y" <%If lcnt <> 0 Then%>checked<%End If%> onclick="chkLate('<%=vYear &"-"& setP(vMonth) &"-"& setP(vDay)%>');">
							</td>
						</tr>
					</table>
<%
			vDay = vDay + 1
		Else
%>
				<td align="right" valign="top" height="40">&nbsp;
<%		End If %>
				</td>
<%
			i = i + 1
			j = j + 1
	Wend
%>
			</tr>
		</table>
		<div class="ct mt10">
			<button type="button" id=btnClose class="">창닫기</button>
		</div>
	</div>
</div>
</form>
</body>
</html>
<%	dbc() %>
