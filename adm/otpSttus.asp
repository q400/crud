<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: otpSttus.asp - OTP현황
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	dept						= SQLI(Request("dept"))
	team						= SQLI(Request("team"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	cd3							= SQLI(Request("cd3"))
	page						= SQLI(Request("page"))

	If cd3 <> "" Then cd2 = ""				'cd3이 널이 아니면 cd2를 널처리
	If cd1 = "" Then cd1 = "unm"
	If page = "" Then page = 1

	pagesize = 15							'페이지크기

	param = " WHERE cid = '"& USER_COMP &"'"
	param4 = " AND idx LIKE '"& LEFT(dept,1) &"%' "

	If cd2 <> "" Then						'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' AND open_yn = 'Y' "
	ElseIf cd3 <> "" Then
		param = param &" AND dept = '"& cd3 &"' AND open_yn = 'Y' "
	Else									'검색조건이 없는 경우
		param = param &" AND open_yn = 'Y' "
	End If

'	If dept <> "" Then
'		param = param &" AND uid IN (SELECT uid FROM memt010 WHERE dept = '"& dept &"') "
'	End If
	If dept = "" Then
			param = param &""
	Else
		If team = "" Then
			param = param &" AND uid IN (SELECT uid FROM memt010 WHERE dept = '"& dept &"') "
		Else
			param = param &" AND uid IN (SELECT uid FROM memt010 WHERE dept = '"& dept &"' AND team = '"& team &"') "
		End If
	End If

	rso()
	SQL = "	SELECT COUNT(*) FROM memt010 "& param
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/20) + 1
	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&dept="& dept &"&team="& team
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#cd2").keypress(function(event){
		if(event.which == 13){
			goSearch();
		}
	});
	$("#btnBatch").click(function (){	//일괄처리
		setPoint();
	});
	$("#chkAll").change(function(){		//전체선택
		var is_check = $(this).is(":checked");	//전체선택 체크박스의 체크상태 판별
		$(".chk").prop("checked", is_check);	//하위 체크박스에 체크상태 적용
	});

	if($("#cd1 option:selected").index() == 4){
		$("#sub1").hide();
		$("#sub4").show();
	}else{
		$("#sub1").show();
		$("#sub4").hide();
	}
	$("#cd1").change(function(){		//조회조건변경
		if($("#cd1 option:selected").index() == 4){
			$("#sub1").hide();
			$("#sub4").show();
		}else{
			$("#sub1").show();
			$("#sub4").hide();
		}
	});
	$("#dept").change(function(){		//부서변경
		$.ajax({
			url: "/inc/ajax/teamList.asp",
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
function writeKeyDown(){
	if(event.keyCode == 13)	goSearch();
}
function goSearch(){
	$("#page").val(1);
	$("#fm1").attr({action:"otpSttus.asp", method:"post"}).submit();
}
function goSms(a, b){
	var seq = "";
	var sCnt = 0;
	var f = document.fm1;

	for (cnt=0; cnt < f.elements.length; cnt++){
		if(f.elements[cnt].name == 'chk'){
			if(f.elements[cnt].checked == true){
				seq = seq + f.elements[cnt].value + ",\n";
				sCnt = sCnt + 1;
			}
		}
	}
	if(seq != ""){
		seq = seq.substring(0, seq.length-1);
		var msg = "++ 선택한 직원, 총 "+ sCnt +"명 ++     \n\n----------------------------------------     \n\n"+ seq
		+"\n\n----------------------------------------     \n\n\n위 직원(들)에게 SMS를 발송하시겠습니까?     "
		window.event.returnValue = false;

		if(confirm(msg)){
			window.open("/sms/sms03.asp?id="+seq, '_goPage', 'resizable=1,scrollbars=0,status=0,width=192,height=495');
		}
	} else {
		window.open("/sms/sms03.asp?hname="+a+"&level="+b, '_goPage', 'resizable=0,scrollbars=0,status=0,width=192,height=495');
	}
}
function setPoint(){
	var seq = "";
	var unm = "";
	var seq_uid = "";
	var sCnt = 0;
	var otPnt = $("#otp").val();
	var otGubn = $("#gubn").val();

	if(otPnt == "" || otPnt == "0"){
		$("otp").focus();
		alert("적용할 포인트를 입력하세요");
		return false;
	}

	$("input:checkbox[name='chk']:checked").each(function(e){
		let value = $("input:checkbox[name='chk']:checked").eq(e).val();
		let arrVal = value.split(":");

		seq_uid = seq_uid + arrVal[0] + ",";
		unm = unm + arrVal[1] + "\n";
		sCnt = sCnt + 1;
	})

	if(sCnt > 0){
		unm = unm.substring(0, unm.length-1);
		//seq_uid = seq_uid.substring(0, seq_uid.length-1);
		var msg = "++ 선택한 직원, 총 "+ sCnt +" 명 ++\n----------------------------------------\n"+ unm
		+"\n----------------------------------------\n위 직원(들)에게 "+ otPnt +" 포인트를 "+ otGubn +"처리 하시겠습니까?"
		window.event.returnValue = false;

		if(confirm(msg)){
			$("#fm1").attr({action:"otpSttus_x.asp?gubn="+ otGubn +"&setVal="+ otPnt +"&uid="+ seq_uid, method:"post"}).submit();
		}
	}else{
		alert("선택된 인원이 없습니다.");
		return;
	}
}
</script>


<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td valign="top">

<form name="fm1" id="fm1">
<input type="hidden" name="page" id="page" value="<%=page%>" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > OTP현황</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span>
											<select name="dept" id="dept" style="width:180px;" onchange="goSearch();">
												<option value="" <%If dept = "" Then%>selected<%End If%>>부서전체</option>
												<%=cmnCdList("부서",dept,"","","")%>
											</select>
											<select name="team" id="team" style="width:180px;" onchange="goSearch();">
												<option value="" <%If team = "" Then%>selected<%End If%>>팀전체</option>
												<%=cmnCdList("팀",team,dept,"","")%>
											</select>
										</span>
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
											<col style="width:5%;" /><!-- 선택 -->
											<col style="width:15%;" /><!-- 이름 -->
											<col style="width:15%;" /><!-- 연락처 -->
											<col style="width:15%;" /><!-- 소속부서 -->
											<col style="width:15%;" /><!-- 직원등급 -->
											<col style="width:15%;" /><!-- 등록일자 -->
											<col /><!-- 잔여포인트 -->
										</colgroup>
										<thead>
											<tr style="height:40px;">
												<th><input type="checkbox" name="chkAll" id="chkAll" /></th>
												<th>이름</th>
												<th>연락처</th>
												<th>소속부서</th>
												<th>직원등급</th>
												<th>등록일자</th>
												<th>잔여포인트</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		rso()
		SQL = "	SELECT * FROM memt010 "& param &" ORDER BY ddate DESC "
		rs.open SQL, dbcon, 3

		rs.pagesize = 15
		j = rs.recordcount

		If Not (rs.eof And rs.bof) Then

			totalpage = rs.pagecount
			rs.absolutepage = page

			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize
			End If

			i = 1
			Do Until rs.EOF Or i > rs.pagesize

				If rs("open_yn") = "N" Then %>
											<tr align="center" bgcolor="#dddddd" height=34>
<%				Else %>
											<tr align="center" height=34>
<%				End If %>
												<td><input type="checkbox" name=chk id=chk class="chk" value="<%=rs("uid")%>:<%=rs("unm")%>"></td>
												<td>
													<a href="javascript:;" onclick="unoPop('otpHistory.asp?uid=<%=rs("uid")%>','OTP 내역',950,700);"><%=rs("unm")%></a>
												</td>
												<td><a href="javascript:;" onclick="unoPop('otpHistory.asp?uid=<%=rs("uid")%>','OTP 내역',950,700);"><%=rs("hp1") &"-"& rs("hp2") &"-"& rs("hp3")%></a></td>
												<td><a href="javascript:;" onclick="unoPop('otpHistory.asp?uid=<%=rs("uid")%>','OTP 내역',950,700);"><%=cmnCd1("부서", rs("dept"), "")%></a></td>
												<td><a href="javascript:;" onclick="unoPop('otpHistory.asp?uid=<%=rs("uid")%>','OTP 내역',950,700);"><%=cmnCd1("직급", rs("ulvl"), "")%></a></td>
												<td><a href="javascript:;" onclick="unoPop('otpHistory.asp?uid=<%=rs("uid")%>','OTP 내역',950,700);"><%=Left(rs("ddate"),10)%></a></td>
												<td><a href="javascript:;" onclick="unoPop('otpHistory.asp?uid=<%=rs("uid")%>','OTP 내역',950,700);"><b><%=rs("ot_pnt")%></b></a></td>
											</tr>
											<tr>
												<td height="1" colspan="9" background="/img/dot.gif"></td>
											</tr>
<%
				rs.MoveNext
				i = i + 1
				j = j - 1
			Loop
		Else
%>
											<tr><td align="center" height="100" valign="middle" colspan="8">내용이 없습니다.</td></tr>
<%
		End If
		rsc()
%>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan=2 height="2" bgcolor="#b2bdd5"></td>
							</tr>
						</table>
						<div class="ct mt10 mb20"><%=fnPagingGet(totalpage, page, 10, pageParam &"&dept="& dept)%></div>
						<div class="ct vm">
							<select name="cd1" id="cd1" style="width:180px;" class="vt">
								<option value="" <%If cd1 = "" Then%>selected<%End If%>>선택</option>
								<option value="unm" <%If cd1 = "unm" Then%>selected<%End If%>>이름검색</option>
								<option value="uid" <%If cd1 = "uid" Then%>selected<%End If%>>ID검색</option>
								<option value="hp3" <%If cd1 = "hp3" Then%>selected<%End If%>>휴대전화번호검색</option>
								<option value="dept" <%If cd1 = "dept" Then%>selected<%End If%>>부서검색</option>
							</select>
							<span id="sub1">
								<input type="text" name="cd2" id=cd2 <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:150px;" />
							</span>
							<span id="sub4">
								<select name="cd3" style="width:180px;">
									<%=cmnCdList("부서",dept,"","","")%>
								</select>
							</span>
							<button type="button" id=btnSearch onclick="goSearch();">조회</button>
							<button type="button" id=btnReset onclick="location='otpSttus.asp'">새로고침</button>
							<select name="gubn" id=gubn style="width:80px;">
								<option value="적립">증가</option>
								<option value="사용">감소</option>
							</select>
							<input type="number" name="otp" id=otp style="width:80px;" step=1 min=0 max=20 />
							<select name="otpNote" id=otpNote style="width:200px;">
								<%=cmnCdList0("OTP처리사유","","")%>
							</select>
							<button type="button" id=btnBatch class="btn01">일괄적용</button>
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
