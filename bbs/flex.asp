<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: flex.asp - 탄력근무설정
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	dept						= SQLI(Request("dept"))
	team						= SQLI(Request("team"))
	yy							= SQLI(Request("yy"))
	mm							= SQLI(Request("mm"))
	dd							= SQLI(Request("dd"))

	If yy = "" Then yy = Year(Date)
	If mm = "" Or mm = "0" Then mm = Month(Date)
	If CInt(mm) = 2 Then		'2월
		If CInt(dd) > 28 Then
			dd = "28"
		Else
			dd = Day(Date)
		End If
	Else		'그 외
			dd = Day(Date)
	End If

	If dept = "" Then dept = USER_DEPT
	If team = "" Then team = USER_TEAM

	vDate = CDate(yy &"/"& mm &"/01")

	If dept = "99" Then
		param = ""
	Else
		param = " AND uid IN (SELECT uid FROM memt010 WHERE dept = '"& dept &"') "
	End If
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSet").click(function (){		//설정
		let vdt = [];
		let cnt = $("input:checkbox[name='vdt']:checked").length;
		let past = 0;
		let weekEnd = 0;	//주말
		let weekMid = 0;	//주중

		let now = new Date();	//오늘
		let year = now.getFullYear();
		let mon = (now.getMonth()+1) > 9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
		let day = now.getDate() > 9 ? ''+now.getDate() : '0'+now.getDate();
		let today = year + mon + day;
//		console.log("today ______"+ today);

		if(cnt == 0){
			alert("설정하고자 하는 날짜를 선택하세요.");
			return;
		}else{
			$("input:checkbox[name='vdt']:checked").each(function(e){
				let value = $("input:checkbox[name='vdt']:checked").eq(e).val();	//선택일자
				let dt2 = value.replaceAll("-", "");
				let yoil = String(value);
				let weekDay = "";
//				let dt2 = new Date(value);	//선택일자

				yoil = yoil.replace(/(\d{4})(\d{2})(\d{2})/, '$1-$2-$3');
				weekDay = new Date(yoil).getDay();	//일-0/월-1/화-2/수-3/목-4/금-5/토-6
//				console.log("dt2 ______"+ dt2);

				if(weekDay == 0 || weekDay == 6){	//토,일이면 weekEnd + 1
					weekEnd = weekEnd + 1;
				}else{
					weekMid = weekMid + 1;
				}
				if(today <= dt2){		//선택일자가 오늘 또는 미래
					vdt.push(value);
				}else{					//과거선택
					past = past + 1;
					vdt.push(value);	//과거도 포함 2025.03.21
				}
			})
			if(weekEnd == 0){			//평일
				if(weekMid == 0){		//평일 선택 없음
					alert("최소 하루 이상 선택하세요.");
					return;
				}else{
				console.log("vdt ______"+ vdt);
//					if(past > 0){		//과거일자 포함
//						alert("과거 일자가 포함되어 있습니다.\n해당 일자를 제외하고 입력합니다.");
						if(vdt == ""){
							alert("등록 가능한 선택 일자가 없습니다.");
							return;
						}else{
							unoPop("flexPop.asp?vdt="+ vdt,"탄력근무설정","700","700");
						}
//					}else{
//						unoPop("flexPop.asp?vdt="+ vdt,"탄력근무설정","700","700");
//					}
				}
			}else{						//토요일,일요일 최소 1개 이상 포함
				if(weekMid == 0){		//평일 선택 없음
//					if(past > 0){
//						alert("과거 일자가 포함되어 있습니다.\n해당 일자를 제외하고 입력합니다.");
						if(vdt == ""){
							alert("등록 가능한 선택 일자가 없습니다.");
							return;
						}else{
							unoPop("flexPop.asp?vdt="+ vdt,"탄력근무설정","700","700");
						}
//					}else{
//						unoPop("flexPop.asp?vdt="+ vdt,"탄력근무설정","700","700");
//					}
				}else{
					alert("토요일,일요일은 별도로 등록하세요.");
					return;
				}
			}
		}
	});
	$("#chkAll1").change(function(){		//일
		var is_check = $(this).is(":checked");
		$(".vdt1").prop("checked", is_check);
	});
	$("#chkAll2").change(function(){		//월
		var is_check = $(this).is(":checked");
		$(".vdt2").prop("checked", is_check);
	});
	$("#chkAll3").change(function(){		//화
		var is_check = $(this).is(":checked");
		$(".vdt3").prop("checked", is_check);
	});
	$("#chkAll4").change(function(){		//수
		var is_check = $(this).is(":checked");
		$(".vdt4").prop("checked", is_check);
	});
	$("#chkAll5").change(function(){		//목
		var is_check = $(this).is(":checked");
		$(".vdt5").prop("checked", is_check);
	});
	$("#chkAll6").change(function(){		//금
		var is_check = $(this).is(":checked");
		$(".vdt6").prop("checked", is_check);
	});
	$("#chkAll7").change(function(){		//토
		var is_check = $(this).is(":checked");
		$(".vdt7").prop("checked", is_check);
	});
});
function goSearch(){
	loadingShow();		//loading
	$("#yy").val("<%=yy%>");
	$("#mm").val("<%=mm%>");
	$("#dd").val("<%=dd%>");
	$("#fm1").attr({action:"flex.asp", method:'post'}).submit();
}
function prevMonth(){
	loadingShow();		//loading
	$("#yy").val("<%=Year(vDate-1)%>");
	$("#mm").val("<%=Month(vDate-1)%>");
	$("#dd").val("01");
	$("#dept").val("<%=dept%>");
	$("#team").val("<%=team%>");
	$("#fm1").attr({action:"flex.asp", method:'post'}).submit();
}
function nextMonth(){
	loadingShow();		//loading
	$("#yy").val("<%=Year(vDate+31)%>");
	$("#mm").val("<%=Month(vDate+31)%>");
	$("#dd").val("01");
	$("#dept").val("<%=dept%>");
	$("#team").val("<%=team%>");
	$("#fm1").attr({action:"flex.asp", method:'post'}).submit();
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
<input type="hidden" name="yy" id="yy" />
<input type="hidden" name="mm" id="mm" />
<input type="hidden" name="dd" id="dd" />
<input type="hidden" name="dept" id="dept" value="<%=CStr(dept)%>" />
<input type="hidden" name="team" id="team" value="<%=CStr(team)%>" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">
									신청정보 > <b class="fcy">"<%=cmnCd("부서",USER_DEPT,"","")%> / <%=cmnCd("팀",USER_TEAM,"","")%>
									(근무시간 : <%=cmnCd2(team,"opt1")%> ~ <%=cmnCd2(team,"opt2")%>)"</b> 탄력근무관리
								</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span>
											<button type="button" id=btnReset onclick="location='?yy=<%=yy%>&mm=<%=mm%>&dd=01'">새로고침</button>
											<!--
											<select name="dept" id="dept" style="width:180px;" onchange="goSearch();">
												<option value="99" <%If dept = "99" Then%>selected<%End If%>>전체</option>
<%
'			rso()
'			SQL = "	SELECT x.code_id, x.code_nm " _
'				& " FROM codt010 x LEFT OUTER JOIN codt020 y " _
'				& "		ON x.code_id = y.code_id " _
'				& " WHERE cid = '"& USER_COMP &"'" _
'				& " AND code_se = '부서'" _
'				& " ORDER BY y.odrby DESC "
'			Do Until rs.eof
%>
<%
'				rs.MoveNext
'			Loop
'			rsc()
%>
											</select>
											//-->
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
									<table width=100% border=1 cellspacing="0" cellpadding="0" align="center" bordercolor="#b2bdd5" style="border-collapse:collapse;">
										<tr align="center" bgcolor="#404955" height="20">
											<td>일<input type="checkbox" name="chkAll" id="chkAll1" /></td>
											<td width="15%">월<input type="checkbox" name="chkAll" id="chkAll2" /></td>
											<td width="15%">화<input type="checkbox" name="chkAll" id="chkAll3" /></td>
											<td width="15%">수<input type="checkbox" name="chkAll" id="chkAll4" /></td>
											<td width="15%">목<input type="checkbox" name="chkAll" id="chkAll5" /></td>
											<td width="15%">금<input type="checkbox" name="chkAll" id="chkAll6" /></td>
											<td width="15%">토<input type="checkbox" name="chkAll" id="chkAll7" /></td>
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
			fColor = "#5c7b9e"
		ElseIf j = 1 Then
			fColor = "#f86259"
		Else
			fColor = "#eee"
		End If

		If(vFirstWeek = j And vDay = 1) Or (vDay > 1 And vDay <= vLastday) Then
%>
											<td class="rg vt" height=120>
<%
			If vDay = CInt(dd) Then			'해당일
%>
												<div style="background-color:#5cac45;" class="pt">
													<input type="checkbox" name="vdt" id="vdt" class="vdt<%=j%>" value="<%=yy%>-<%=setP(mm)%>-<%=setP(vDay)%>" />
													<b class="fcw f15 ff mt5 mr5 mb5 ls"><u><%=setP(vDay)%></u></b>
												</div>
<%			Else %>
												<div class="pt">
													<input type="checkbox" name="vdt" id="vdt" class="vdt<%=j%>" value="<%=yy%>-<%=setP(mm)%>-<%=setP(vDay)%>" />
													<b class="f15 ff mt5 mr5 mb5 ls"><font color="<%=fColor%>"><%=setP(vDay)%></font></b>
												</div>
<%
			End If
%>
												<div>
<%
			rso()
			SQL = "	SELECT x.seq, y.idx, x.uid, y.stime, y.etime, x.adm_chk, y.vdate, LEFT(CONVERT(CHAR(10),getdate(),120),10) today "_
				& " FROM vact010 x INNER JOIN vact011 y ON x.seq = y.seq "_
				& "	WHERE cid = '"& USER_COMP &"'" _
				& " AND y.vdate = '"& yy &"-"& setP(mm) &"-"& setP(vDay) &"'"& param _
				& " AND gubn = '탄력'"_
				& "	ORDER BY x.seq "
'			Response.Write "<br>"& SQL &"<br>"
			rs.open SQL, dbcon, 3
			Do While rs.EOF = False
				cchk = ""
				cchk = "<span class='fcy'>ⓦ</span>"
				vdt = rs("vdate")
				today = rs("today")
'				vdt = Replace(rs("vdate"),"-","")
				tm1 = "<span class='ls'>"& cmnCd2(USER_TEAM,"opt1") &"~"& cmnCd2(USER_TEAM,"opt2") &"</span>"
				tm2 = "<span class='ls'>"& rs("stime") &"~"& rs("etime") &"</span>"

'Response.Write "value : "& rs("adm_chk") &"<br>"

				If rs("adm_chk") = "N" Then			'인사팀 재가 전
					If USER_ID = rs("uid") Then		'본인
%>
													<a href="javascript:;" class="fc3" onclick="unoPop('flexPop.asp?vdt=<%=vdt%>&seq=<%=rs("seq")%>&idx=<%=rs("idx")%>&opt=M','탄력근무설정',700,700);">
													<%=memInfo(rs("uid"),"unm")%>[<%=tm2%>]<%=cchk%></a>
													<br />
<%
					Else							'본인 아닌 경우
%>
													<a href="javascript:;" class="fc3" onclick="unoPop('flexPop.asp?vdt=<%=vdt%>&seq=<%=rs("seq")%>&idx=<%=rs("idx")%>&opt=M','탄력근무설정',700,700);">
													<%=memInfo(rs("uid"),"unm")%>[<%=tm2%>]<%=cchk%></a>
													<br />
<%
					End If
				Else								'인사팀 재가 후
					If today <= vdt Then			'등록일자가 오늘보다 미래 -> 수정/삭제 가능
%>
													<a href="javascript:;" class="fc3" onclick="unoPop('flexPop.asp?vdt=<%=vdt%>&seq=<%=rs("seq")%>&idx=<%=rs("idx")%>&opt=M','탄력근무설정',700,700);">
													<%=memInfo(rs("uid"),"unm")%>[<%=tm2%>]</a>
													<br />
<%
					Else							'과거
%>
													<span class="hint--info hint--top fc2" aria-label="승인 완료된 탄력근무는 수정할 수 없습니다."><%=memInfo(rs("uid"),"unm")%>[<%=tm2%>]</span>
													<br />
<%
					End If
				End If
				rs.MoveNext
			Loop
			rsc()
%>
												</div>
<%
			vDay = vDay + 1
		Else
%>
											<td align="right" valign="top" height=120>&nbsp;
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
							<button type="button" id=btnSet class="btn01">근무설정</button>
						</div><!--
						<div class="mt10">
							<span><b class="fcy">"과거"</b>는 탄력근무 신청을 할 수 없습니다. 반드시 오늘 이후의 <b class="fcy">"미래"</b>를 지정하세요.</span>
						</div> -->
						<div class="mt10 mb10">
							<span><b>AM</b> : 오전 / <b>PM</b> : 오후 / <b>(숫자)</b> : 초과근무시간 사용값 / <span class="fcy">ⓦ</span> : 부서장 승인 전 / <span class="fc8">ⓒ</span> : 취소완료</span>
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
