<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: /adm/memOut.asp - 퇴사자관리(관리자)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색어
	cd3							= SQLI(Request("cd3"))			'팀
	cd4							= SQLI(Request("cd4"))			'부서
	cd6							= SQLI(Request("cd6"))			'직급
	cd7							= SQLI(Request("cd7"))			'권한
	page						= SQLI(Request("page"))
'	Response.Write "cd2 : "& cd2 &"<br>"

'	If cd3 <> "" Then cd2 = ""				'조직에 값이 있으면 cd2를 ""처리
'	If cd4 <> "" Then cd2 = ""				'부서에 값이 있으면 cd2를 ""처리
	If cd1 = "" Then cd1 = "unm"
	If page = "" Then page = 1

	pagesize = 20							'페이지크기

	param = " WHERE cid = '"& USER_COMP &"'"
	param4 = ""

	If cd2 <> "" Then						'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' "
	End If

	If cd3 <> "" Then
		param = param &" AND team = '"& cd3 &"' "
	End If

	If cd4 <> "" Then
		param = param &" AND dept = '"& cd4 &"' "
		param4 = " AND idx LIKE '"& LEFT(cd4,1) &"%' "
	End If

	If cd6 <> "" Then param = param &" AND ulvl = "& cd6
	If cd7 <> "" Then param = param &" AND auth = "& cd7

	rso()
	SQL = "	SELECT * FROM memt011 "& param &" ORDER BY rgdt DESC "
'	Response.Write "<br>"& SQL &"<br>"
	rs.open SQL, dbcon, 3
		k = rs.recordcount
	rsc()

	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&cd4="& cd4 &"&cd6="& cd6 &"&cd7="& cd7
%>

<script type="text/javascript">
<!--
function checkForm(){
	return true;
}
function goSms(a, b){
	var seq = "";
	var selectedCount = 0;
	var f = document.fm1;

	for (cnt=0; cnt < f.elements.length; cnt++){
		if(f.elements[cnt].name == 'chk'){
			if(f.elements[cnt].checked == true){
				seq = seq + f.elements[cnt].value + ",\n";
				selectedCount = selectedCount+1;
			}
		}
	}
	if(seq != ""){
		seq = seq.substring(0, seq.length-1);
		var msg = "++ 선택한 직원, 총 "+ selectedCount +"명 ++\n\n----------------------------------------\n\n"+ seq
		+"\n\n----------------------------------------\n\n\n위 직원(들)에게 SMS를 발송하시겠습니까?"
		window.event.returnValue = false;

		if(confirm(msg)){
			window.open("/sms/sms03.asp?id="+seq, '_goPage', 'resizable=1,scrollbars=0,status=0,width=192,height=495');
		}
	} else {
		window.open("/sms/sms03.asp?hname="+a+"&level="+b, '_goPage', 'resizable=0,scrollbars=0,status=0,width=192,height=495');
	}
}
function writeKeyDown(){
	if(event.keyCode == 13)	goSearch();
}
function goSearch(){
	$(".loader").show();
	document.fm1.page.value = 1;
	document.fm1.action = "memOut.asp";
	document.fm1.submit();
}
function goDelete(vID){
	if(confirm("완전히 삭제합니까?")){
		$("#fm1").attr({action:"memOut_x.asp?flag=DD&uid="+ vID +"&<%=pageParam%>&page=<%=page%>", method:"POST", target:"nullframe"}).submit();
	}
}
var checkflag = "false";
function check(field){
	if(checkflag == "false"){
		for (i = 0; i < field.length; i++){
			field[i].checked = true;
		}
		checkflag = "true";
		return "모두해제";
	} else {
		for (i = 0; i < field.length; i++){
			field[i].checked = false;
		}
		checkflag = "false";
		return "모두선택";
	}
}
//-->
</script>
<script type="text/javascript" src="/inc/js/comscript.js"></script>


<table width=100% border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td class="vt">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td class="vt">

<form name="fm1" id=fm1 method="post" onsubmit="return checkForm();">
<input type="hidden" name="page" value="<%=page%>">

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > 퇴사(삭제)직원관리</td>
							</tr>
							<tr>
								<td>
									<div class="ib mb5">
										<button type="button" onclick="location='mem.asp'" class="btn03">직원목록</button>
										&nbsp;
										<select name="cd4" id="cd4" style="width:160px;" onchange="goSearch();"><!-- 부서 -->
											<option value="" selected>부서전체</option>
											<%=cmnCdList("부서",cd4,"","","")%>
										</select>
										<select name="cd3" id="cd3" style="width:160px;" onchange="goSearch();"><!-- 팀 -->
											<option value="" selected>팀전체</option>
											<%=cmnCdList("팀",cd3,cd4,"","")%>
										</select>
										<select name="cd6" id="cd6" style="width:160px;" onchange="goSearch();"><!-- 직급 -->
											<option value="" selected>직급전체</option>
											<%=cmnCdList("직급",cd6,"","","")%>
										</select>
										<select name="cd7" id="cd7" style="width:160px;" onchange="goSearch();"><!-- 권한 -->
											<option value="" selected>권한전체</option>
											<%=cmnCdList("권한",cd6,"","","")%>
										</select>
									</div>
									<div class="ib frt"><strong><%=FormatNumber(k,0)%></strong>건</div>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td class="vt">
									<table width=100% border="0" cellpadding="0" cellspacing="0" class="tbl900">
										<tr height=40>
											<th width=5%>No.</th>
											<th width=3%></th>
											<th width=10%>이름</th>
											<th width=12%>아이디</th>
											<th width=10%>연락처</th>
											<th width=10%>과거부서</th>
											<th width=10%>과거팀</th>
											<th width=8%>과거직급</th>
											<th width=8%>과거권한</th>
											<th width=10%>입사일자</th>
											<th>퇴사일자</th>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=20></td>
										</tr>
<%
		rso()
		SQL = "	SELECT * FROM memt011 "& param &" ORDER BY rgdt DESC "
'		Response.Write SQL &"<br>"
		rs.open SQL, dbcon, 3

		rs.pagesize = 20
		j = rs.recordcount

		If Not (rs.eof And rs.bof) Then

			totalpage = rs.pagecount
			rs.absolutepage = page

			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize
			End If

			i = 1
			Do Until rs.EOF Or i > rs.pagesize

			Select Case rs("auth")
				Case "90" : auth = "일반"
				Case "60" : auth = "<span class='blue fcb'>팀장</span>"
				Case "40" : auth = "<span class='redyellow fcb'>부서장</span>"
				Case "10" : auth = "<span class='yellow fcb'>관리자</span>"
				Case Else : auth = "대기"
			End Select
%>
										<tr align="center" height=34>
											<td><%=j%></td><!-- <input type="checkbox" name="chk" id="chk" value="<%=rs("uid")%>:<%=rs("unm")%>"> -->
											<td>
<%
				If rs("pic") = "" Then
%>
												<img src="<%=PATH_PIC%>/pic40.png" width=20 />
<%
				Else
%>
												<a href="javascript:;" onclick="unoPop('/mem/picPop.asp?img=<%=PATH_PIC%>/<%=rs("pic")%>','<%=rs("unm")%>',250,320);">
												<img src="<%=PATH_PIC%>/ss<%=rs("pic")%>" /></a>
<%
				End If
%>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><b class="fcy"><%=rs("unm")%></b></a>
<%
				If USER_ID = "q400" Then
%>
												<img src="/img/icon/delete02.gif" class="vm pt" onclick="goDelete('<%=rs("uid")%>');" title="삭제" />
<%
				End If
%>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=rs("uid")%></a>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=rs("hp1") &"-"& rs("hp2") &"-"& rs("hp3")%></a>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=cmnCd1("부서", rs("dept"), "")%></a>
											</td>
											<td>
												<a href="modify.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=cmnCd1("팀", rs("team"), "")%></a>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=cmnCd1("직급", rs("ulvl"), "")%></a>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=auth%></a>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=getDt(rs("sdate"), ".")%></a>
											</td>
											<td>
												<a href="memOutVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=getDt(rs("edate"), ".")%></a>
											</td>
										</tr>
<%
							rs.MoveNext
							If Not rs.eof Then
%>
										<tr>
											<td height="1" colspan=20 background="/img/dot.png"></td>
										</tr>
<%
							End If
					i = i + 1
					j = j - 1
			Loop
		Else
%>
										<tr><td align="center" height="100" valign="middle" colspan=20>조회 내용이 없습니다.</td></tr>
<%
		End If
		rsc()
%>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan=2 height="2" bgcolor="#b2bdd5"></td>
							</tr>
						</table>
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, pageParam)%></div>
						<div class="ct mt10 pb50">
							<select name="cd1" id="cd1" style="width:150px;">
								<option value="" <%If cd1 = "" Then%>selected<%End If%>>선택</option>
								<option value="unm" <%If cd1 = "unm" Then%>selected<%End If%>>이름검색</option>
								<option value="uid" <%If cd1 = "uid" Then%>selected<%End If%>>ID검색</option>
								<option value="hp" <%If cd1 = "hp" Then%>selected<%End If%>>휴대전화검색</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" onkeydown="writeKeyDown();" />
							<button type="button" id=btnSearch onclick="goSearch();">조회</button>
							<button type="button" id=btnReset onclick="location='memOut.asp'">새로고침</button>
							<!-- <button type="button" onclick="unoPop('code_w.asp','코드등록',400,250)" class="btn01 frt mr50">신규등록</button> -->
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
