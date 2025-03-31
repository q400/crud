<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: main.asp
'************************************************************************************
	Call checkLevel(USER_AUTH, 9999, Request.ServerVariables("PATH_INFO"))
%>
<meta http-equiv="Refresh" Content="120;url=/main.asp">
<script>
var url = "https://crud.kr/login_success.asp";
var user_id = "xxxx";
function success(position) {
	const latitude  = position.coords.latitude;
	const longitude = position.coords.longitude;
//	window.location = url + "?uid=<%=USER_ID%>&lat="+ latitude +"&lon="+ longitude;
}
function error(position) {
	//HTTPS가 아니거나 위치수집 동의를 안 할 경우
	//alert('error');
}
$(document).ready(function(){
	if(!navigator.geolocation) {
		//Geolocation API를 지원하지 않는 브라우저일 경우
		alert('GPS를 지원하지 않습니다.');
	} else {
		//Geolocation API를 지원하는 브라우저일 경우
		var optn = {enableHighAccuracy : true, timeout : 30000, maximumage: 0};
		navigator.geolocation.getCurrentPosition(success, error, optn);
	}
})
</script>

<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=250 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td valign="top">
						<table width=95% border=0 cellspacing="0" cellpadding="0">
							<tr>
								<td width=40% class="vt">
									<div class="mt10 mb10">
										<span class="f17 fc4 fb ls">공지사항</span>
										<span class="f11 frt pt mr40" onclick="goUrl('/bbs/notice.asp');">바로가기</span>
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
			& " WHERE bbs_id = 100 AND cid = '"& USER_COMP &"' " _
			& " ORDER BY seq DESC "
		rs.open SQL, dbcon, 3
		If Not rs.eof Then
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
													<a href="/bbs/notice_v.asp?seq=<%=rs("seq")%>"><%=TrimText(rs("title"),40)%></a>
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
													<a href="/bbs/notice_v.asp?seq=<%=rs("seq")%>"><%=Left(rs("rgdt"),10)%></a>
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
		Else
%>
											<tr style="height:182px;">
												<td colspan=10 class="ct">" Data가 없습니다. "</td>
											</tr>
<%
		End If
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
										<span class="f17 fc4 fb ls">인사발령</span>
										<span class="f11 frt pt mr40" onclick="goUrl('/bbs/insa.asp');">바로가기</span>
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
		'인사발령
		rso()
		SQL = " SELECT TOP 5 * FROM bbst010 " _
			& " WHERE bbs_id = 200 AND cid = '"& USER_COMP &"' " _
			& " ORDER BY seq DESC "
		rs.open SQL, dbcon, 3
		If Not rs.eof Then
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
													<a href="/bbs/insa_v.asp?seq=<%=rs("seq")%>"><%=TrimText(rs("title"),40)%></a>
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
													<a href="/bbs/insa_v.asp?seq=<%=rs("seq")%>"><%=Left(rs("rgdt"),10)%></a>
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
		Else
%>
											<tr style="height:182px;">
												<td colspan=10 class="ct">" Data가 없습니다. "</td>
											</tr>
<%
		End If
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
							<tr>
								<td colspan=2 height=50></td>
							</tr>
							<tr>
								<td width=40% class="vt">
									<div class="mt10 mb10">
										<span class="f17 fc4 fb ls">휴무알림 <b class="fcy"><%=cmnCd("부서",USER_DEPT,"","")%> / <%=cmnCd("팀",USER_TEAM,"","")%></b></span>
										<span class="f11 frt pt mr40" onclick="goUrl('/welfare/offAplySttus.asp');">바로가기</span>
									</div>
									<table width=95% border=0 cellspacing="0" cellpadding="0" style="min-width:500px;">
										<colgroup>
											<col /><!-- 휴무구분 -->
											<col style="width:20%;" /><!-- 제출자 -->
											<col style="width:20%;" /><!-- 부서장 처리여부 -->
											<col style="width:20%;" /><!-- 등록일자 -->
										</colgroup>
										<thead>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
											<tr style="height:40px;">
												<th>휴무구분</th>
												<th>제출자</th>
												<th>처리여부</th>
												<th>등록일자</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		'부서휴무신청
		rso()
		SQL = " SELECT TOP 10 A.seq, A.adm_chk, A.sign3, A.gubn, A.ddate, B.uid, B.unm " _
			& " FROM vact010 A LEFT OUTER JOIN memt010 B ON A.uid = B.uid " _
			& " WHERE gubn != '탄력' AND A.cid = '"& USER_COMP &"' " _
			& " AND B.team = '"& USER_TEAM &"' " _
			& " ORDER BY seq DESC "
		rs.open SQL, dbcon, 3
		If Not rs.eof Then
			While Not rs.eof
%>
											<tr style="height:34px;">
												<td class="pl10">
													<a href="javascript:;" onclick="unoPop('/welfare/offAplySttusPop.asp?seq=<%=rs("seq")%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=rs("gubn")%></a>
<%
				If Right(rs("sign3"), 3) <> "gif" Then
%>
													<img src="/img/icon/new05.gif" class="vm" title="신규" />
<%
				End If
%>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('/welfare/offAplySttusPop.asp?seq=<%=rs("seq")%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=rs("unm")%></a>
												</td>
												<td class="ct">
<%
				If Right(rs("sign3"), 3) = "gif" Then
%>
													<font color="#cccccc">완료</font>
<%
				Else
%>
													<a href="javascript:;" onclick="unoPop('/welfare/offAplySttusPop.asp?seq=<%=rs("seq")%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><span class="fc9"><b>대기</b></span></a>
<%
				End If
%>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('/welfare/offAplySttusPop.asp?seq=<%=rs("seq")%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=Left(rs("ddate"),10)%></a>
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
		Else
%>
											<tr style="height:182px;">
												<td colspan=10 class="ct">" Data가 없습니다. "</td>
											</tr>
<%
		End If
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
										<span class="f17 fc4 fb ls">부서 OTP 사용신청 <b class="fcy"><%=cmnCd("부서",USER_DEPT,"","")%></b></span>
										<span class="f11 frt pt mr40" onclick="goUrl('/welfare/otpAply.asp');">바로가기</span>
									</div>
									<table width=95% border=0 cellspacing="0" cellpadding="0" style="min-width:500px;">
										<colgroup>
											<col /><!-- 해당일자 -->
											<col style="width:20%;" /><!-- 제출자 -->
											<col style="width:15%;" /><!-- 사용포인트 -->
											<col style="width:15%;" /><!-- 상태 -->
											<col style="width:20%;" /><!-- 신청일자 -->
										</colgroup>
										<thead>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
											<tr style="height:40px;">
												<th>해당일자</th>
												<th>제출자</th>
												<th>사용포인트</th>
												<th>상태</th>
												<th>신청일자</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		'부서 OTP 사용신청
		rso()
		SQL = " SELECT TOP 10 A.seq, A.uid, A.ampm, A.ddate, A.cancel_yn, A.adm_chk, A.sign3, A.adate, A.point, A.cancel_date " _
			& " FROM ovtt010 A LEFT OUTER JOIN memt010 B ON A.uid = B.uid " _
			& " WHERE A.gubn = '사용' AND A.cid = '"& USER_COMP &"' " _
			& " AND A.adate <> '' " _
			& " AND B.team = '"& USER_TEAM &"' " _
			& " ORDER BY A.ddate DESC "
		rs.open SQL, dbcon, 3
		If Not rs.eof Then
			While Not rs.eof
				If rs("cancel_yn") = "Y" Then			'취소
							status = "취소처리"
				Else			'대기
					If rs("adm_chk") = "Y" Then			'처리완료
							status = "<span class=fc9>사용(완료)</span>"
					Else		'미처리
						If Right(rs("sign3"), 6) = "_0.gif" Then		'부서장 결재 완료
							status = "<span class=fc8>부서장결재</span>"
						Else
							status = "<span class=fc9>처리중</span>"
						End If
					End If
				End If

				If Weekday(rs("adate")) = 7 Then	'토요일 신청건의 경우, 절반값만 표기한다. 실제는 화면값의 두배가 차감됨
					point = "<span class='fcy' title='토요일 신청건(실제 차감포인트 : "& rs("point") &")'>"& rs("point") &"</span>"
				Else
					point = rs("point")
				End If
%>
											<tr style="height:34px;">
												<td class="pl10">
													<a href="javascript:;" onclick="unoPop('/welfare/otpAplyPop_v.asp?seq=<%=rs("seq")%>','OTP사용신청 : <%=rs("seq")%>',780,900);"><%=rs("adate")%>&nbsp;(<%=rs("ampm")%>)</a>
<%
				If Date() - rs("ddate") < 3 Then
%>
													<img src="/img/icon/new05.gif" class="vm" title="신규" />
<%
				End If
%>
												</td>
												<td class="ct"><!-- 제출자 -->
													<a href="javascript:;" onclick="unoPop('/welfare/otpAplyPop_v.asp?seq=<%=rs("seq")%>','OTP사용신청 : <%=rs("seq")%>',780,900);"><span><%=memInfo(rs("uid"),"unm")%></span></a>
												</td>
												<td class="ct"><!-- 사용포인트 -->
													<a href="javascript:;" onclick="unoPop('/welfare/otpAplyPop_v.asp?seq=<%=rs("seq")%>','OTP사용신청 : <%=rs("seq")%>',780,900);"><b class="ff ls fc9"><%=point%></b></a>
												</td>
												<td class="ct" <%If rs("cancel_date") <> "" Then%>onMouseover="ddrivetip('취소일시 : <%=rs("cancel_date")%>',210);" onMouseout="hideddrivetip();"<%End If%>><!-- 상태 -->
													<a href="javascript:;" onclick="unoPop('/welfare/otpAplyPop_v.asp?seq=<%=rs("seq")%>','OTP사용신청 : <%=rs("seq")%>',780,900);"><%=status%></a>
												</td>
												<td class="ct"><!-- 신청일자 -->
													<a href="javascript:;" onclick="unoPop('/welfare/otpAplyPop_v.asp?seq=<%=rs("seq")%>','OTP사용신청 : <%=rs("seq")%>',780,900);"><%=Left(rs("ddate"),10)%></a>
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
		Else
%>
											<tr style="height:182px;">
												<td colspan=10 class="ct">" Data가 없습니다. "</td>
											</tr>
<%
		End If
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
							<tr>
								<td colspan=2 height=50></td>
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
