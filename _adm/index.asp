<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: /_adm/index.asp
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	chk							= SQLI(Request("chk"))
%>
<meta http-equiv="Refresh" Content="120;url=/_adm/index.asp">
<script>
var url = "https://crud.kr/login_success.asp";
function success(position) {
	const latitude  = position.coords.latitude;
	const longitude = position.coords.longitude;
//	window.location = url + "?uid=<%=USER_ID%>&lat="+ latitude +"&lon="+ longitude;
}
function error(position) {
	//HTTPS가 아니거나 위치수집 동의를 안 할 경우
	alert('error');
}
if('<%=chk%>' == 'chk'){ //출근처리
	if(!navigator.geolocation) {
		//Geolocation API를 지원하지 않는 브라우저일 경우
		alert('GPS를 지원하지 않습니다.');
	} else {
		//Geolocation API를 지원하는 브라우저일 경우
		var optn = {enableHighAccuracy : true, timeout : 30000, maximumage: 0};
		navigator.geolocation.getCurrentPosition(success, error, optn);
	}
}else{

}
</script>


<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=250 valign="top">
						<!-- #include virtual = "/inc/adm_left.asp" -->
					</td>
					<td valign="top">
						<table width=100% border=0 cellspacing="0" cellpadding="0">
							<tr>
								<td width=40% class="vt">
									<div class="mt10 mb10">
										<span class="f17 fc4 fb ls">서비스신청</span>
										<span class="f11 frt pt mr40" onclick="goUrl('/_adm/comp/rqst.asp');">
											<svg width="30" viewBox="-10 0 34 34" xmlns="http://www.w3.org/2000/svg"><!-- 더하기01 -->
												<path fill="none" stroke="currentColor" stroke-width="2" d="M12 22V2M2 12h20"/>
											</svg>
										</span>
									</div>
									<table width=95% border=0 cellspacing="0" cellpadding="0" style="min-width:500px;">
										<colgroup>
											<col /><!-- 고객사이름 -->
											<col style="width:15%;" /><!-- 담당자 -->
											<col style="width:10%;" /><!-- 직원수 -->
											<col style="width:20%;" /><!-- 등록일자 -->
										</colgroup>
										<thead>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
											<tr style="height:40px;">
												<th>고객사이름</th>
												<th>담당자</th>
												<th>직원수</th>
												<th>등록일자</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		'서비스신청
		rso()
		SQL = " SELECT TOP 5 seq, cid, comp_nm, mngr_nm, ddate, (SELECT COUNT(*) FROM memt010 WHERE cid=cmp.cid) emp_cnt "_
			& " FROM cmpt010 cmp " _
			& " WHERE 1=1 " _
			& " ORDER BY seq DESC "
		rs.open SQL, dbcon, 3
		While Not rs.eof
%>
											<tr style="height:34px;">
												<td class="pl10">
													<a href="/_adm/comp/rqst_w.asp?seq=<%=rs("seq")%>&flag=M"><%=rs("comp_nm")%></a>
<%
				If Date() - rs("ddate") < 3 Then
%>
													<img src="/img/icon/new05.gif" class="vm" title="신규" />
<%
				End If
%>
												</td>
												<td class="ct">
													<a href="/_adm/comp/rqst_w.asp?seq=<%=rs("seq")%>&flag=M"><%=rs("mngr_nm")%></a>
												</td>
												<td class="ct">
													<a href="/_adm/comp/rqst_w.asp?seq=<%=rs("seq")%>&flag=M"><%=dataCnt("emp",rs("cid"))%></a>
												</td>
												<td class="ct">
													<a href="/_adm/comp/rqst_w.asp?seq=<%=rs("seq")%>&flag=M"><%=Left(rs("ddate"),10)%></a>
												</td>
											</tr>
<%
			rs.MoveNext
			If Not rs.eof Then
%>
											<tr>
												<td height="1" colspan="9" background="/img/dot.gif"></td>
											</tr>
<%
			End If
		Wend
		rsc()
%>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</tbody>
									</table>
								</td>
								<td width=40% class="vt">
									<div class="mt10 mb10">
										<span class="f17 fc4 fb ls">공지사항</span>
										<span class="f11 frt pt mr40" onclick="goUrl('/bbs5/notice.asp');">
											<svg width="30" viewBox="-10 0 34 34" xmlns="http://www.w3.org/2000/svg"><!-- 더하기01 -->
												<path fill="none" stroke="currentColor" stroke-width="2" d="M12 22V2M2 12h20"/>
											</svg>
										</span>
									</div>
									<table width=95% border=0 cellspacing="0" cellpadding="0" style="min-width:500px;">
										<colgroup>
											<col /><!-- 제목 -->
											<col style="width:20%;" /><!-- 등록일자 -->
										</colgroup>
										<thead>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
											<tr style="height:40px;">
												<th>제목</th>
												<th>등록일자</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		'공지사항
		rso()
		SQL = " SELECT TOP 5 * FROM bbst010 " _
			& " WHERE bbs_id = 110 " _
			& " ORDER BY seq DESC "
		rs.open SQL, dbcon, 3
		While Not rs.eof
				Set rs3 = Server.CreateObject("ADODB.Recordset")
				SQL = " SELECT ISNULL(COUNT(*),0) FROM bbst011 WHERE seq = "& rs("seq")
				rs3.open SQL, dbcon
					photoCnt = rs3(0)
				rs3.close
				Set rs3 = Nothing
%>
											<tr style="height:34px;">
												<td class="pl10">
													<a href="/bbs5/notice_v.asp?seq=<%=rs("seq")%>"><%=TrimText(rs("title"),40)%></a>
<%
				If photoCnt <> 0 Then
%>
													<span class="fc4 f12 ff ls" title="첨부파일 개수"><%=photoCnt%></span>
<%
				End If
				If Date() - rs("rgdt") < 3 Then
%>
													<img src="/img/icon/new05.gif" class="vm" title="신규" />
<%
				End If
%>
												</td>
												<td class="ct">
													<a href="/bbs5/notice_v.asp?seq=<%=rs("seq")%>"><%=Left(rs("rgdt"),10)%></a>
												</td>
											</tr>
<%
			rs.MoveNext
			If Not rs.eof Then
%>
											<tr>
												<td height="1" colspan="9" background="/img/dot.gif"></td>
											</tr>
<%
			End If
		Wend
		rsc()
%>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
