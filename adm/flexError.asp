<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: flexError.asp - 탄력근무관리(오류정보)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	dept						= SQLI(Request("dept"))
	team						= SQLI(Request("team"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))
'	Response.Write "team : "& team &"<br>"

	If page = "" Then page = 1

	param = " WHERE C.stime = '' "
	param4 = " AND idx LIKE '"& LEFT(dept,1) &"%' "

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' AND gubn = '탄력'"
	Else								'검색조건이 없는 경우
		param = param &" AND gubn = '탄력'"
	End If

'	If dept = "" Then
'		dept = USER_DEPT
'	End If

'	If team = "" Then
'		team = USER_TEAM
'	End If

	If dept = "" Then
			param = param &""
	Else
		If team = "" Then
			param = param &" AND A.uid IN (SELECT uid FROM memt010 WHERE dept = '"& dept &"') "
		Else
			param = param &" AND A.uid IN (SELECT uid FROM memt010 WHERE dept = '"& dept &"' AND team = '"& team &"') "
		End If
	End If

	rso()
	SQL = " SELECT COUNT(*) " _
		& "	FROM vact010 A LEFT OUTER JOIN vact011 C " _
		& "		ON A.seq = C.seq "_
		& " LEFT OUTER JOIN memt010 B "_
		& "		ON A.uid = B.uid " _
		& param
'	Response.write SQL
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/15) + 1
	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&dept="& dept &"&team="& team
%>

<script type="text/javascript">
var v1 = "";
var v2 = "";
$(document).ready(function(){
	$("#btnSet").click(function (){		//설정
		let vdt = [];
		let cnt = $("input:checkbox[name='vdt']:checked").length;
		let flag1 = 0;
		let flag2 = 0;

		if(cnt == 0){
			alert("최소 하루 이상 선택하세요.");
			return;
		}else{
			$("input:checkbox[name='vdt']:checked").each(function(e){
				let value = $("input:checkbox[name='vdt']:checked").eq(e).val();
				let yoil = String(value);
				let weekDay = "";

				yoil = yoil.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
				weekDay = new Date(yoil).getDay();

				if(weekDay == 0 || weekDay == 6){
					flag1 = flag1 + 1;
				}else{
					flag2 = flag2 + 1;
				}
				vdt.push(value);
			})
			if(flag1 == 0){		//토요일,일요일 최소 1개 이상 포함
				if(flag2 == 0){
					alert("최소 하루 이상 선택하세요.");
					return;
				}else{
					unoPop("flexPop.asp?vdt="+ vdt,"탄력근무설정","700","700");
				}
			}else{
				if(flag2 == 0){
					unoPop("flexPop.asp?vdt="+ vdt,"탄력근무설정","700","700");
				}else{
					alert("토요일,일요일은 별도로 등록하세요.");
					return;
				}
			}
		}
	});
	$("#dept").change(function(){		//부서변경
		$.ajax({
			url: "teamList.asp",
			type: "POST",
			data: {
				dept : $("#dept").val()
			},
			dataType: "text",
			success: function(data){
//				console.log("________"+ data);
				if(data != ""){
					$("#team").find("option").remove();
					$("#team").html(data);
				}
			}
		});
	});
});
function goSearch(){
	loadingShow();		//loading
	$("#yy").val("<%=yy%>");
	$("#mm").val("<%=mm%>");
	$("#dd").val("<%=dd%>");
	$("#fm1").attr({action:"flexError.asp", method:"post"}).submit();
}
function prevMonth(){
	loadingShow();		//loading
	$("#yy").val("<%=Year(vDate-1)%>");
	$("#mm").val("<%=Month(vDate-1)%>");
	$("#dd").val("01");
	$("#dept").val("<%=dept%>");
	$("#team").val("<%=team%>");
	$("#fm1").attr({action:"flexError.asp", method:"post"}).submit();
}
function nextMonth(){
	loadingShow();		//loading
	$("#yy").val("<%=Year(vDate+31)%>");
	$("#mm").val("<%=Month(vDate+31)%>");
	$("#dd").val("01");
	$("#dept").val("<%=dept%>");
	$("#team").val("<%=team%>");
	$("#fm1").attr({action:"flexError.asp", method:"post"}).submit();
}
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
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="page" id="page" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > 탄력근무관리</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span>
											<button type="button" id=reload onclick="location='flexError.asp'">새로고침</button>
											<button type="button" onclick="goUrl('flexList.asp')">목록보기</button>
											<button type="button" onclick="goUrl('flexError.asp')">오류자료</button>
											<select name="dept" id="dept" style="width:180px;" onchange="goSearch();">
												<option value="" selected>선택</option>
												<%=cmnCdList("부서",dept,"","","")%>
											</select>
											<select name="team" id="team" style="width:180px;" onchange="goSearch();">
												<option value="" selected>선택</option>
												<%=cmnCdList("팀",team,dept,"","")%>
											</select>
										</span>
										<span class="frt"><%=FormatNumber(recordcount,0)%> 건</span>
									</div>
								</td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0" class="tbl900">
										<colgroup>
											<col style="width:7%;" /><!-- 순번 -->
											<col style="width:12%;" /><!-- 해당부서 -->
											<col style="width:12%;" /><!-- 팀 -->
											<col style="width:10%;" /><!-- 대상자 -->
											<col style="width:10%;" /><!-- 담당부서장 -->
											<col style="width:10%;" /><!-- 해당일자 -->
											<col /><!-- 선택근무시간 -->
											<col style="width:10%;" /><!-- 처리상태 -->
											<col style="width:10%;" /><!-- 등록일자 -->
										</colgroup>
										<thead>
											<tr>
												<td height=2 colspan=10 bgcolor="#b2bdd5"></td>
											</tr>
											<tr style="height:40px;">
												<th>순번</th>
												<th>해당부서</th>
												<th>팀</th>
												<th>대상자</th>
												<th>담당부서장</th>
												<th>해당일자</th>
												<th>선택근무시간</th>
												<th>처리상태</th>
												<th>등록일자</th>
											</tr>
											<tr>
												<td height=1 bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		rso()
		SQL = " SELECT TOP 15 A.*, unm, C.* "_
			& "	FROM vact010 A " _
			& "	LEFT OUTER JOIN vact011 C "_
			& "		ON A.seq = C.seq "_
			& " LEFT OUTER JOIN memt010 B "_
			& "		ON A.uid = B.uid "& param _
			& " AND C.seq NOT IN ("_
			& "		SELECT TOP "& ((page-1) * 15) &" A.seq "_
			& "		FROM vact010 A "_
			& "		LEFT OUTER JOIN vact011 C "_
			& "			ON A.seq = C.seq "_
			& "		LEFT OUTER JOIN memt010 B "_
			& "			ON A.uid = B.uid "& param _
			& "		ORDER BY C.seq DESC) " _
			& " ORDER BY C.seq DESC "
'		Response.Write "<br>"& SQL &"<br>"
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
'				Set rs8 = Server.CreateObject("ADODB.recordset")
'				SQL = " SELECT idx, vdate, stime, etime FROM vact011 WHERE seq = "& rs("seq")
'				rs8.open SQL, dbcon
'				If Not rs.eof Then
'					idx = rs8(0)
'					vdate = rs8(1)
'					stime = rs8(2)
'					etime = rs8(3)
'				End If
'				Set rs8 = Nothing

'				stm = cmnCd1("시간", stime, "")
'				etm = cmnCd1("시간", etime, "")
%>
											<tr height=34 align="center">
												<td><%=j%></td>
												<td><%=cmnCd1("부서",rs("dept"),"")%></td><!-- 해당부서 -->
												<td><%=cmnCd1("팀",rs("team"),"")%></td><!-- 팀 -->
												<td><!-- 대상자 -->
													<a href="javascript:;" onclick="unoPop('flexPop.asp?vdt=<%=rs("vdate")%>&seq=<%=rs("seq")%>&idx=<%=rs("idx")%>','탄력근무설정',700,700);" title="<%=rs("seq")%>:<%=rs("idx")%>">
													<%=memInfo(rs("uid"),"unm")%><!-- <br><%=rs("uid")%> --></a>
												</td>
												<td><!-- 담당부서장 -->
													<a href="javascript:;" onclick="unoPop('flexPop.asp?vdt=<%=rs("vdate")%>&seq=<%=rs("seq")%>&idx=<%=rs("idx")%>','탄력근무설정',700,700);" title="<%=rs("seq")%>:<%=rs("idx")%>">
													<%=memInfo(Replace(rs("sign3"),"_0.gif",""),"unm")%></a>
												</td>
												<td><!-- 해당일자 -->
													<a href="javascript:;" onclick="unoPop('flexPop.asp?vdt=<%=rs("vdate")%>&seq=<%=rs("seq")%>&idx=<%=rs("idx")%>','탄력근무설정',700,700);" title="<%=rs("seq")%>:<%=rs("idx")%>">
													<%=rs("vdate")%></a>
												</td>
												<td><!-- 선택근무시간 -->
													<a href="javascript:;" onclick="unoPop('flexPop.asp?vdt=<%=rs("vdate")%>&seq=<%=rs("seq")%>&idx=<%=rs("idx")%>','탄력근무설정',700,700);" title="<%=rs("seq")%>:<%=rs("idx")%>">
													<%=rs("stime")%>~<%=rs("etime")%></a>
												</td>
												<td><!-- 처리여부 -->
													<%If rs("adm_chk") = "Y" Then%><font color="#cccccc">완료</font>
													<%Else%><font color="#ff6622"><b>대기</b></font>
													<%End If%>
												</td>
												<td onMouseover="ddrivetip('<%=rs("ddate")%>',150)" onMouseout="hideddrivetip();">
													<%=Left(rs("ddate"),10)%><!-- 등록일자 -->
												</td>
											</tr>
<%
				rs.MoveNext
				If Not rs.eof Then
%>
											<tr>
												<td height="1" colspan=10 background="/img/dot.gif"></td>
											</tr>
<%
				End If
				j = j - 1
			Loop
		Else
%>
											<tr height="100">
												<td align="center" valign="middle" colspan=10>내용이 없습니다.</td>
											</tr>
<%
		End If
		rsc()
%>
											<tr>
												<td height=1 colspan=10 bgcolor="#b2bdd5"></td>
											</tr>
										</tbody>
									</table>
								</td>
							</tr>
						</table>
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 15, pageParam)%></div>
						<div class="ct mt10 pb50 pr50">
							<select name="cd1" id="cd1" style="width:120px;">
								<option value="unm" <%If cd1 = "" Or cd1 = "unm" Then%>selected<%End If%>>제출자명</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" onkeydown="writeKeyDown();" />
							<button type="button" id=search onclick="goSearch();">조회</button>
							<button type="button" id=reload onclick="location='flexError.asp'">새로고침</button>
							<!-- <button type="button" onclick="location='notice_w.asp'" class="btn01">글쓰기</button> -->
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
