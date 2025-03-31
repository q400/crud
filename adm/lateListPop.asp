<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: lateListPop.asp - 지각목록 popup (휴무내역표)
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
	<div class="mt20">
		<table width=100% id="list1">
			<colgroup>
				<col style="width:50%;" /><!-- 지각일자 -->
				<col /><!-- 지각시간 -->
			</colgroup>
			<thead>
				<tr style="height:30px;">
					<th>해당일자</th>
					<th>지각시간</th>
				</tr>
			</thead>
			<tbody>
<%
		rso()
		SQL = " SELECT x.ldate, LEFT(y.wstm,2)+ ':'+ RIGHT(y.wstm,2) wstm "_
			& " FROM latt010 x LEFT JOIN work_history y "_
			& " ON x.uid = y.uid AND REPLACE(x.ldate, '-', '') = y.work_dt " _
			& "	WHERE x.uid = '"& uid &"' "_
			& " AND x.chk = 'Y' "_
			& " AND CONVERT(VARCHAR, x.ldate, 112) BETWEEN '"& lastYr &"' AND '"& thisYr &"' " _
			& " ORDER BY x.ldate DESC "
'		Response.Write SQL &"<br>"
		rs.open SQL, dbcon
		While Not rs.eof
%>
				<tr height=26>
					<td><%=rs("ldate")%></td>
					<td><%=rs("wstm")%></td>
				</tr>
<%
			rs.MoveNext
		Wend
		rsc()
%>
			</tbody>
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
