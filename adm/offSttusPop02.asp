<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'*  화면명	: offSttusPop.asp - 휴무신청정보
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	seq							= Request("seq")
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	pDept						= SQLI(Request("pDept"))			'부서
	pGubn						= SQLI(Request("pGubn"))			'구분
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If USER_ID = "" Or seq = "" Then
		Call AlertClose3("비정상적인 접근입니다. 다시 진행해 주세요.")
		Response.End
	End If

	rso()
	If seq <> "" Then
		SQL = "	SELECT uid, gubn, ddate, sign1, sign3, ampm, use_day, adm_chk, handover, note " _
			& "	FROM vact010 " _
			& "	WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			uid					= rs("uid")
			gubn				= rs("gubn")
			ddate				= rs("ddate")
			sign1				= rs("sign1")
			sign3				= rs("sign3")
			ampm				= rs("ampm")
			use_day				= rs("use_day")
			adm_chk				= rs("adm_chk")				'Y/N (확인여부)
			handover			= rs("handover")
			note				= rs("note")
		End If
	End If
	rsc()

	dept3 = cmnCd("부서",USER_DEPT,"","")					'부서
	ulvl = cmnCd("직급",USER_ULVL,"","")					'직급
'	Response.Write "uid : "& uid &"<br>"

	rso()
	SQL = "	SELECT ISNULL(COUNT(*),0) FROM bbst012 WHERE tbl_id = 'vact010' AND seq = "& seq &" AND uid = '"& USER_ID &"' "
	rs.open SQL, dbcon, 3
	If Not rs.eof Then
		intReadCnt = rs(0)
	End If

	If intReadCnt = 0 Then		'열람자 확인
		SQL = " INSERT INTO bbst012 (tbl_id, seq, uid) VALUES ('vact010', "& seq &", '"& USER_ID &"') "
		dbcon.Execute SQL
	End If
	rsc()
%>

<script type="text/javascript">
function sancConfirm(vSign){
	if(confirm("결재하시겠습니까?")){
		$("#flag").val("V");
		$("#sign").val(vSign);
		$("#fm1").attr({action:"offSttusPop_x.asp", method:"post", target:"nullframe"}).submit();
	}
}
function goSms(a, b){
	if(confirm("재가 재촉 SMS를 발송합니까?")){
		$("#seq").val(a);
		$("#cp").val(b);
		$("#fm1").attr({action:"report_sms.asp", method:"post", target:"nullframe"}).submit();
	}
}
function sancWindow(ref, vType, vWidth, vHeight){
	var screenWidth = window.screen.availWidth;
	var screenHeight = window.screen.availHeight;
	var leftPos = (screenWidth - vWidth) / 2;
	var topPos = (screenHeight - vHeight - 50) / 2;
	window.open(ref+'?gubn='+ vType,'zipWin','toolbar=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=0,width='+ vWidth +',height='+ vHeight +',top='+ topPos +',left='+ leftPos +',location=0');
}
function goDelete(){			//삭제
	if(!confirm("정말 삭제하시겠습니까?")){
		return;
	}
	$("#flag").val("D");
	$("#fm1").attr({action:"offSttusPop_x.asp", method:"post", target:"nullframe"}).submit();
}
function goAdmDelete(){			//관리자 삭제
	if(!confirm("관리자 권한으로 삭제하시겠습니까?")){
		return;
	}
	$("#flag").val("DD");
	$("#fm1").attr({action:"offSttusPop_x.asp", method:"post"}).submit();
}
</script>


<form name=fm1 id=fm1 method="post">
<input type="hidden" name="seq" id=seq value="<%=seq%>" />
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="pDept" id=pDept value="<%=pDept%>" />
<input type="hidden" name="pGubn" id=pGubn value="<%=pGubn%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
<input type="hidden" name="flag" id=flag value="<%=flag%>" />
<input type="hidden" name="sign" id=sign />
<input type="hidden" name="cp" id=cp />
<table width=100% align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center">
			<table width=96% border=1 cellspacing="0" cellpadding="0" bordercolor="#b2bdd5" style="border-collapse:collapse;" class="mt10">
				<tr>
					<th rowspan=2>확인</th>
					<th width="13%" height=34>인사팀장</th>
					<th width="13%" rowspan=2 class="vm">결재</th>
					<th width="13%">담당</th>
					<th width="13%">부서장</th>
					<th width="13%">부원장</th>
					<th width="13%">원장</th>
				</tr>
				<tr align="center" height=90>
					<td>
<%
		If Right(sign1,3) = "gif" Then			'결재완료
%>
						<span class="fcy">완결</span><!-- <img src="/img/pass03.gif"> -->

<%
		ElseIf sign1 = USER_ID Or USER_AUTH <= 10 Then		'결재자 = 로그인ID 또는 관리자
%>
						<span class="fcy">완결</span><!-- <a href="javascript:sancConfirm(1);">인사팀장<br><span class="fcy">결재要</span></a> -->
<%
		Else
			If sign1 <> "" Then
%>
						<!-- <a href="javascript:goSms('<%=seq%>','<%=memInfo(sign1,"hp1")%>');" title="<%=memInfo(sign1,"hp1")%>"> -->
						<span class="fcy">완결</span><!-- <font color="#acacac">[인사팀장]<br>대기중</font> --><!-- </a> -->
<%
			End If
		End If
%>
					</td>
					<td>&nbsp;</td>
					<td>
<%		If Right(sign3,3) = "gif" Then				'결재완료 %>
						<span class="fcy">완결</span><!-- <img src="/img/pass03.gif"> -->
<%		ElseIf sign3 = USER_ID Then					'결재자 = 로그인ID %>
						<a href="javascript:sancConfirm(3);"><%=memInfo(sign3,"unm")%><br><span class="fcy">결재要</span></a>
<%		Else
			If sign3 <> "" Then %>
						<font color="#acacac">[<%=memInfo(sign3,"unm")%>]<br>대기중</font>
<%			End If
		End If %>
					</td>
					<td>
<%		'If Right(sign4,3) = "gif" Then				'결재완료 %>
						<!-- <img src="<%=PATH_SIGN%>/<%=sign4%>" width="50" height="50"> -->
<%		'ElseIf sign4 = USER_ID Then				'결재자 = 로그인ID %>
						<!-- <a href="javascript:sancConfirm(4);"><%=sign4%><br><font color="red">결재要</font></a> -->
<%		'Else
		'	If sign4 <> "" Then %>
						<!-- <a href="javascript:goSms('<%=seq%>','<%=memInfo(sign4,"hp1")%>');">
						<font color="#acacac">[<%=sign4%>]<br>대기중</font></a> -->
<%		'	End If
		'End If %>
					</td>
					<td>
						<!-- <img src="/img/pass03.gif"> -->
<%		'If Right(sign5,3) = "gif" Then				'결재완료 %>
						<!-- <img src="<%=PATH_SIGN%>/<%=sign5%>" width="50" height="50"> -->
<%		'ElseIf sign5 = USER_ID Then				'결재자 = 로그인ID %>
						<!-- <a href="javascript:sancConfirm(5);"><%=sign5%><br><font color="red">결재要</font></a> -->
<%		'Else
		'	If sign5 <> "" Then %>
						<!-- <a href="javascript:goSms('<%=seq%>','<%=memInfo(sign5,"hp1")%>');">
						<font color="#acacac">[<%=sign5%>]<br>대기중</font></a> -->
<%		'	End If
		'End If %>
					</td>
				</tr>
				<tr height=34>
					<th>구분</th>
					<td colspan=6 class="pl10">
						<b class="fcg"><%=gubn%></b>
<%
		If ampm <> "" Then
%>
						<span class="fcg">(<%=ampm%>)</span>
<%
		End If
%>
					</td>
				</tr>
				<tr align="center">
					<th rowspan="2">신청인</th>
					<th colspan="2" height=34>소속</th>
					<th colspan="2">직급</th>
					<th colspan="2">성명</th>
				</tr>
				<tr align="center" height=34>
					<td colspan="2"><%=dept3%></td>
					<td colspan="2"><%=ulvl%></td>
					<td colspan="2">
						<span class="fcg"><%=memInfo(uid,"unm")%></span>
					</td>
				</tr>
				<tr height=34>
					<th>휴무사유 외</th>
					<td colspan=6 class="pl10"><%=note%></td>
				</tr>
				<tr height=34>
					<th>업무인계자</th>
					<td colspan=6 class="pl10"><%=handover%></td>
				</tr>
				<tr height=34>
					<th>기간</th>
					<td colspan=6 class="fcg pl10">
<%
			rso()
			SQL = " SELECT vdate FROM vact011 WHERE seq = "& seq
			rs.open SQL, dbcon
			While Not rs.eof
%>
						<%=rs("vdate")%>
<%
				rs.MoveNext
%>
						<%If Not rs.eof Then%>&nbsp;/&nbsp;<%End If%>
<%
			Wend
			rsc()
%>
					</td>
				</tr>
				<tr>
					<td colspan=7 align="center" height=300>
						<table width=92% border=0 cellpadding="0" cellspacing="0">
							<tr height="100">
								<td align="right">위와 같은 사유로 인해 제출하오니 허가하여 주시기 바랍니다.</td>
							</tr>
							<tr height="50">
								<td align="right"><%=Year(ddate)%> 년&nbsp; <%=Month(ddate)%> 월&nbsp; <%=Day(ddate)%> 일</td>
							</tr>
							<tr height="100">
								<td align="center">제출자 : <%=memInfo(uid,"unm")%></td>
							</tr>
							<tr height="100">
								<td align="right" class="f25"><b><%=cmpInfo(USER_COMP,"comp_nm")%></b></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<div class="mt10 mb10 ml20">
	<span class="blue fcb fb">열람자목록</span>
</div>
<div class="mt10 mb10 ml20">
<%
			rso()
			SQL = "	SELECT	uid, ddate FROM bbst012 WHERE tbl_id = 'vact010' AND seq = "& seq &" ORDER BY ddate "
			rs.open SQL, dbcon, 3
			While Not rs.eof
%>
	<span <%If USER_AUTH <= 10 Then%>onMouseover="ddrivetip('<%=rs("ddate")%>',160)" onMouseout="hideddrivetip();"<%End If%>><%=meminfo(rs("uid"),"unm")%></span>
<%
				rs.MoveNext
			Wend
			rsc()
%>
</div>
<div class="ct mt20 mb30">
<%
		If USER_AUTH <> "" And USER_AUTH <= 10 Then		'관리자
%>
	<button type="button" id=btnDelete onclick="goAdmDelete();" class="btn01">관리자삭제</button>
<%
		End If
%>
	<button type="button" id=btnClose onclick="simsClosePopup();" class="">창닫기</button>
</div>
</form>
<%
	dbc()
%>
