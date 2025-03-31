<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: offSttus.asp - 휴무현황 월별보기
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	dept						= SQLI(Request("dept"))			'부서구분
	gubn						= SQLI(Request("gubn"))			'연차,반차,주휴,반주휴 구분
	yy							= SQLI(Request("yy"))
	mm							= SQLI(Request("mm"))
	dd							= SQLI(Request("dd"))

	If yy = "" Then yy = Year(Date)
	If mm = "" Then mm = Month(Date)
	If CInt(mm) = 2 Then		'2월
		If CInt(dd) > 28 Then
			dd = "28"
		Else
			dd = Day(Date)
		End If
	Else		'그 외
			dd = Day(Date)
	End If

'	If dept = "" Then
'		dept = USER_DEPT
'	End If

	param = ""

	vDate = CDate(yy &"/"& mm &"/01")

	If gubn = "" Then		'전체
		param3 = " AND x.gubn IN ('반차','반주휴','연차','특차','주휴') "
	Else
		param3 = " AND x.gubn = '"& gubn &"' "
	End If

	If dept = "" Then
		param = param &""
	Else
		param = param &" AND uid IN (SELECT uid FROM memt010 WHERE dept = '"& dept &"') "
	End If
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSet").click(function (){		//휴무신청
		unoPop('totalOffPop.asp?yy=<%=yy%>&mm=<%=setP(mm)%>&dd=<%=setP(vDay)%>','휴무신청',800,600);
	});
	$("#btnSave").click(function (){		//저장
		if($("#sign3").val() == ""){
			alert("담당부서장을 입력하세요.");
			$("#sign3").focus();
			return;
		}
		if(confirm("입력하시겠습니까?")){
			$("#fm1").attr({action:"flex_x.asp", method:"post"}).submit();
		}
	});
	$("#btnDelete").click(function (){		//삭제
		if(!confirm("정말 삭제하시겠습니까?")){
			return;
		}
		$("#op1").val("D");
		$("#fm1").attr({action:"off_x.asp", method:"post"}).submit();
	});
	$("#btnClose").click(function (){		//닫기
		simsClosePopup();
	});
});
function vacaDel(vSeq,vID){
	if(confirm("연차를 삭제합니까?")){
		document.fm1.action = "vaca_ax.asp?seq="+ vSeq +"&idx="+ vID +"&op1=VX&yy=<%=yy%>&mm=<%=mm%>";
		document.fm1.method = "post";
//		document.fm1.target = "nullframe";
		document.fm1.submit();
	}
}
function otpDel(vSeq){
	if(confirm("초과근무 사용신청을 삭제(취소)합니까?")){
		$("#fm1").attr({action:"/bbs/otpAply_x.asp?seq="+ vSeq +"&flag=DD&yy=<%=yy%>&mm=<%=mm%>", method:"post"}).submit();
	}
}
function goSearch(){
	loadingShow();		//loading
	$("#yy").val("<%=yy%>");
	$("#mm").val("<%=mm%>");
	$("#dd").val("<%=dd%>");
	$("#fm1").attr({action:"offSttus.asp", method:"post"}).submit();
}
function prevMonth(){
	loadingShow();		//loading
	$("#yy").val("<%=Year(vDate-1)%>");
	$("#mm").val("<%=Month(vDate-1)%>");
	$("#dd").val("01");
	$("#dept").val("<%=dept%>");
	$("#gubn").val("<%=gubn%>");
	$("#fm1").attr({action:"offSttus.asp", method:"post"}).submit();
}
function nextMonth(){
	loadingShow();		//loading
	$("#yy").val("<%=Year(vDate+31)%>");
	$("#mm").val("<%=Month(vDate+31)%>");
	$("#dd").val("01");
	$("#dept").val("<%=dept%>");
	$("#gubn").val("<%=gubn%>");
	$("#fm1").attr({action:"offSttus.asp", method:"post"}).submit();
}
//-->
</script>


<table width=100% border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td class="vt">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td class="vt">

<form name="fm1" id="fm1" method="post">
<input type="hidden" name="yy" id="yy" />
<input type="hidden" name="mm" id="mm" />
<input type="hidden" name="dd" id="dd" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > 휴무신청현황(달력보기)</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span>
											<button type="button" onclick="location='?yy=<%=yy%>&mm=<%=mm%>&dd=01'">새로고침</button>
											<button type="button" onclick="goUrl('offSttusList.asp')">목록보기</button>
											<select name="dept" id="dept" style="width:180px;" onchange="goSearch();">
												<%=cmnCdList("부서",dept,"","","")%>
											</select>
											<select name="gubn" id="gubn" style="width:150px;" onChange="goSearch();">
												<option value="" <%If gubn = "" Then%>selected<%End If%>>전체</option>
												<option value="반차" <%If gubn = "반차" Then%>selected<%End If%>>반차</option>
												<option value="연차" <%If gubn = "연차" Then%>selected<%End If%>>연차</option>
												<option value="주휴" <%If gubn = "주휴" Then%>selected<%End If%>>주휴</option>
												<option value="반주휴" <%If gubn = "반주휴" Then%>selected<%End If%>>반주휴</option>
											</select>
										</span>
										<span class="frt">
											<button type="button" onclick="prevMonth();">이전달</button>
											<a href="?yy=<%=Year(Date)%>&mm=<%=Month(Date)%>&dd=<%=Day(Date)%>&dept=<%=dept%>" class="ml10 mr10"><b class="ff fc9 f17 ls"><%=yy%> 년 <%=setp(mm)%> 월</b></a>
											<button type="button" onclick="nextMonth();">다음달</button>
										</span>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<table width=100% border=1 cellspacing="0" cellpadding="0" align="center" bordercolor="#b2bdd5" style="border-collapse:collapse;" class="tbl1200">
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

	if( vFirstWeek = 6 And vLastday = 31 ) Or ( vFirstWeek = 7 ) Then
		vDisplayCol = 42
	Else
		vDisplayCol = 35
	End If

	While i <= vDisplayCol
		If j = 8 Then
%>
										</tr>
										<tr>
<%
			j = 1
		End If

		If j = 7 Then
			vfontcolor = "#5c7b9e"
		ElseIf j = 1 Then
			vfontcolor = "#f86259"
		Else
			vfontcolor = "#eee"
		End If

		if(vFirstWeek = j And vDay = 1) Or (vDay > 1 And vDay <= vLastday) Then
%>
											<td class="rg vt" style="padding:3px;" height="120">
<%
			If vDay = CInt(dd) Then			'해당일
%>
												<div style="background-color:#5cac45;" class="mb5 pt">
													<b class="fcw f15 ff mt5 mr3 mb5 ls"><u><%=setP(vDay)%></u></b>
												</div>
<%			Else %>
												<div class="mr3 mb5 pt">
													<b class="f15 ff mt5 mb5 ls"><font color="<%=vfontcolor%>"><%=setP(vDay)%></font></b>
												</div>
<%
			End If
%>
												<div>
<%
'			If gubn = "" Then			'gubn 있으면 start
				rso()
				SQL = "	SELECT x.seq, x.uid, x.gubn, x.adm_chk, y.idx "_
					& " FROM vact010 x INNER JOIN vact011 y "_
					& " ON x.seq = y.seq " _
					& "	WHERE cid = '"& USER_COMP &"'" _
					& " AND y.vdate = '"& yy &"-"& setP(mm) &"-"& setP(vDay) &"'"& param & param3 _
					& "	ORDER BY x.seq "
'				Response.Write "<br>"& SQL &"<br>"
				rs.open SQL, dbcon, 3
				Do While rs.EOF = False
					cchk = ""
					Select Case rs("gubn")
						Case "반차" : ico = "<span class='fcg'><u>반차</u></span>"
						Case "반주휴" : ico = "<span class='fcg'><u>반주휴</u></span>"
						Case "연차" : ico = "<span class='fc3'><u>연차</u></span>"
						Case "주휴" : ico = "<span class='fc3'><u>주휴</u></span>"
						Case "특차" : ico = "<span class='fc9'><u>특차</u></span>"
					End Select
					If rs("adm_chk") = "N" Then cchk = "<span class='fc9'>ⓦ</span>"		'인사팀 재가 전
%>
													<a href="javascript:;" onclick="unoPop('totalOffPop.asp?yy=<%=yy%>&mm=<%=setP(mm)%>&dd=<%=setP(vDay)%>&seq=<%=rs("seq")%>','휴무신청',800,600);">
													<%=ico%>&nbsp;<%=memInfo(rs("uid"),"unm")%><%=cchk%></a>
													<br />
<%
					rs.MoveNext
				Loop
				rsc()
'			End If

			If gubn = "" Or gubn = "사용" Then			'포인트 사용 start
				rso()
				SQL = "	SELECT seq, uid, ampm, adm_chk, point, cancel_yn, cancel_date, upid "_
					& " FROM ovtt010 " _
					& "	WHERE cid = '"& USER_COMP &"'" _
					& " AND adate = '"& yy &"-"& setP(mm) &"-"& setP(vDay) &"'"& param _
					& "	ORDER BY seq "
				rs.open SQL, dbcon, 3
				Do While rs.EOF = False
					cchk = ""
					Select Case rs("ampm")
						Case "오전" : ico = "OT<img src='/img/icon/am01.png' class=vt />"
						Case "오후" : ico = "OT<img src='/img/icon/pm01.png' class=vt />"
					End Select
					If rs("adm_chk") = "N" Then cchk = "<span class='fc9'>ⓦ</span>"
					If rs("cancel_yn") = "Y" Then status = "<span class='fc8'>ⓒ</span>"

					'토요일의 경우에는 2배 차감되므로, 원래 신청한 시간으로 표기한다.
					If Weekday(yy &"-"& setP(mm) &"-"& setP(vDay)) = 7 Then
						point = rs("point") / 1
					Else
						point = rs("point")
					End If

					If rs("cancel_yn") = "Y" Then
%>
													<span title="처리자 : <%=memInfo(rs("upid"),"unm")%> [<%=rs("cancel_date")%>]"><%=ico%>&nbsp;<%=memInfo(rs("uid"),"unm")%>(<%=rs("point")%>)<%=status%></span>
													<br />
<%
					Else
%>
													<!-- <a href="javascript:otpDel(<%=rs("seq")%>);"> --><a href="javascript:;" onclick="unoPop('/bbs/otpPop_w.asp?yy=<%=yy%>&mm=<%=setP(mm)%>&dd=<%=setP(vDay)%>&seq=<%=rs("seq")%>','OTP사용신청',800,600);"><%=ico%>&nbsp;<%=memInfo(rs("uid"),"unm")%>(<%=point%>)<%=cchk%></a>
													<br />
<%
					End If
					rs.MoveNext
				Loop
				rsc()
			End If
%>
												</div>
<%
			vDay = vDay + 1
		Else
%>
											<td align="right" valign="top" height="90">&nbsp;
<%		End If %>
											</td>
<%
			i = i + 1
			j = j + 1
	Wend
%>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<div class="ct mt10">
							<button type="button" id=btnSet class="btn01">휴무신청</button>
						</div>
						<div class="mt10 mb10">
							<span>AM : 오전 / PM : 오후 / (숫자) : 초과근무시간 사용값 / <span class='fc9'>ⓦ</span> : 부서장 승인 전 / <span class='fc8'>ⓒ</span> : 취소완료</span>
						</div>
</form>
					</td>
				</tr>
				<tr>
					<td height="30" colspan="3"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
