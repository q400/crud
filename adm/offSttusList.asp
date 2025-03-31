<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'*  화면명	: offSttusList.asp - 휴무신청현황 LIST
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	pTeam						= SQLI(Request("pTeam"))			'팀
	pGubn						= SQLI(Request("pGubn"))			'구분
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If page = "" Then page = 1

	param = " WHERE B.cid = '"& USER_COMP &"'"

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' AND gubn NOT IN ('지각','탄력') "
	Else								'검색조건이 없는 경우
		param = param &" AND gubn NOT IN ('지각','탄력')"
	End If

	If pGubn <> "" Then					'구분조회
		param = param &" AND gubn = '"& pGubn &"' "
	End If

	If pTeam = "" Then
		param = param &""
	Else
		param = param &" AND A.uid IN (SELECT uid FROM memt010 WHERE team = '"& pTeam &"') "
	End If

'	If pDept = "" Then
'		param = param &""
'	Else
'		param = param &" AND A.uid IN (SELECT uid FROM memt010 WHERE dept = '"& pDept &"') "
'	End If
'	Response.Write "param : "& param &"<br>"

	rso()
	SQL = " SELECT COUNT(*) FROM vact010 A LEFT OUTER JOIN memt010 B ON A.uid = B.uid "& param
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/15) + 1
	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&pTeam="& pTeam &"&pGubn="& pGubn
%>

<script type="text/javascript">
<!--
$(document).ready(function(){
	$("#cd2").keypress(function(event){
		if(event.which == 13){
			goSearch();
		}
	});
});
function goSearch(){
	loadingShow();		//loading
	$("#yy").val("<%=yy%>");
	$("#mm").val("<%=mm%>");
	$("#dd").val("<%=dd%>");
	$("#fm1").attr({action:"offSttusList.asp", method:"post"}).submit();
}
//-->
</script>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td valign="top">

<form name="fm1" id=fm1>
<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
<input type="hidden" name="seq">
<input type="hidden" name="page" value="<%=page%>">

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > 휴무신청현황(목록보기)</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<button type="button" onclick="goUrl('offSttus.asp?yy=<%=yy%>&mm=<%=mm%>&dd=01')">달력보기</button>
										<select name="pTeam" id="pTeam" style="width:180px;" onchange="goSearch();">
											<%=cmnCdList("팀",pTeam,USER_DEPT,"","")%>
										</select>
										<select name="pGubn" id="pGubn" style="width:180px;" onchange="goSearch();">
											<option value="" <%If pGubn = "" Then%>selected<%End If%>>전체</option>
											<option value="반차" <%If pGubn = "반차" Then%>selected<%End If%>>반차</option>
											<option value="연차" <%If pGubn = "연차" Then%>selected<%End If%>>연차</option>
											<option value="주휴" <%If pGubn = "주휴" Then%>selected<%End If%>>주휴</option>
											<option value="반주휴" <%If pGubn = "반주휴" Then%>selected<%End If%>>반주휴</option>
										</select>
										<span class="frt"><%=FormatNumber(recordcount,0)%> 건</span>
									</div>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0" class="tbl900">
										<colgroup>
											<col style="width:5%;" /><!-- 번호 -->
											<col style="width:10%;" /><!-- 휴무구분 -->
											<col /><!-- 사유/장소/연락처 -->
											<col style="width:10%;" /><!-- 제출자 -->
											<col style="width:15%;" /><!-- 해당부서 -->
											<col style="width:10%;" /><!-- 처리여부 -->
											<col style="width:15%;" /><!-- 해당일자 -->
											<col style="width:15%;" /><!-- 등록일자 -->
										</colgroup>
										<thead>
											<tr style="height:40px;">
												<th></th>
												<th>휴무구분</th>
												<th>사유/장소/연락처</th>
												<th>제출자</th>
												<th>해당부서</th>
												<th>처리여부</th>
												<th>해당일자</th>
												<th>등록일자</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		rso()
		SQL = " SELECT TOP 15 A.*, unm FROM vact010 A LEFT OUTER JOIN memt010 B ON A.uid = B.uid "& param _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 15) &" seq FROM vact010 A LEFT OUTER JOIN memt010 B ON A.uid = B.uid "& param _
			& " ORDER BY seq DESC) " _
			& " ORDER BY seq DESC "
'		Response.write SQL
		rs.open SQL, dbcon, 3

		rs.pagesize = 15
		j = recordcount

		If Not (rs.eof And rs.bof) Then
			rs.absolutepage = page
			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize + 1
			End If

			i = 1
			rs.MoveFirst
			Do Until rs.EOF

				Set rs7 = Server.CreateObject("ADODB.recordset")
				SQL = " SELECT	ISNULL(COUNT(*),0) FROM vact011 WHERE seq = "& rs("seq")
				rs7.open SQL, dbcon
					vcnt = rs7(0)
				Set rs7 = Nothing

				Set rs8 = Server.CreateObject("ADODB.recordset")
				If vcnt = 0 Then	'seq는 존재하나 날짜 기입이 안된 경우
					vdate = ""
					comment = "<span class='fb fc9' title='휴무일자가 없습니다. 휴무 신청자에게 물어보세요.'>지정일자없음</span>"
				Else
					If vcnt = 1 Then
						SQL = " SELECT vdate FROM vact011 WHERE seq = "& rs("seq")
						comment = ""
					Else
						SQL = " SELECT TOP 1 vdate FROM vact011 WHERE seq = "& rs("seq")
						comment = "+"& vcnt - 1 &"일"
					End If
					rs8.open SQL, dbcon
					If Not rs.eof Then
						vdate = rs8(0)
					End If
					Set rs8 = Nothing
				End If
%>
											<tr height=34 align="center">
												<td><%=j%></td>
												<td>
													<a href="javascript:;" onclick="unoPop('offSttusPop.asp?seq=<%=rs("seq")%>&<%=pageParam%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=rs("gubn")%></a>
													<%If rs("adm_chk")="N" Then%><img src="/img/icon/new03.gif" class="vm ml5" /><%End If%>
												</td>
												<td class="lf pl10">
													<a href="javascript:;" onclick="unoPop('offSttusPop.asp?seq=<%=rs("seq")%>&<%=pageParam%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=trimText(rs("note"),50)%></a>
												</td>
												<td>
													<a href="javascript:;" onclick="unoPop('offSttusPop.asp?seq=<%=rs("seq")%>&<%=pageParam%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=memInfo(rs("uid"),"unm")%></a>
												</td>
												<td><%=cmnCd("부서",memInfo(rs("uid"),"dept"),"","")%></td>
												<td>
													<%If rs("adm_chk") = "Y" Then%><font color="#cccccc">완료</font>
													<%Else%><span class="fc9"><b>대기</b></span>
													<%End If%>
												</td>
												<td>
<%							If rs("gubn") = "반차" Then %>
													<a href="javascript:;" onclick="unoPop('offSttusPop.asp?seq=<%=rs("seq")%>&<%=pageParam%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=vdate%>&nbsp;(<%=rs("ampm")%>)</a>
<%							Else %>
													<a href="javascript:;" onclick="unoPop('offSttusPop.asp?seq=<%=rs("seq")%>&<%=pageParam%>','휴무신청정보 : <%=rs("seq")%>',780,900);"><%=vdate%>&nbsp;<%=comment%></a>
<%							End If %>
												</td>
												<td class="hint--info hint--top" aria-label="<%=rs("ddate")%>"><%=Left(rs("ddate"),10)%></td>
												<!-- <td onMouseover="ddrivetip('<%=rs("ddate")%>',150)" onMouseout="hideddrivetip();"><%=Left(rs("ddate"),10)%></td> -->
											</tr>
<%							rs.MoveNext
							If Not rs.eof Then %>
											<tr>
												<td height="1" colspan="9" background="/img/dot.gif"></td>
											</tr>
<%							End If
					j = j - 1
			Loop
		Else
%>
											<tr height="100">
												<td align="center" valign="middle" colspan="9">내용이 없습니다.</td>
											</tr>
<%
		End If
		rsc()
%>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td height="5"></td>
							</tr>
						</table>
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, pageParam)%></div>
						<div class="ct mt10 pb50">
							<select name="cd1" id="cd1" style="width:160px;" class="vt">
								<option value="unm" <%If cd1 = "" Or cd1 = "unm" Then%>selected<%End If%>>제출자명</option>
							</select>
							<input type="text" name="cd2" id="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:180px;" />
							<button type="button" id=btnSearch onclick="goSearch();">조회</button>
							<button type="button" id=btnReset onclick="location='offSttusList.asp'">새로고침</button>
						</div>
</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
