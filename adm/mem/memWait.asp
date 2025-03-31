<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: /adm/memWait.asp - 대기(신입)직원관리(관리자)
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

	param = " WHERE open_yn = 'N' "
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
	SQL = "	SELECT * FROM memt010 "& param &" ORDER BY ddate DESC "
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
	document.fm1.action = "memWait.asp";
	document.fm1.submit();
}
function goDelete(vID){
	if(confirm("삭제합니까?")){
		$("#fm1").attr({action:"mem_x.asp?flag=DD&uid="+ vID +"&<%=pageParam%>&page=<%=page%>", method:"POST", target:"nullframe"}).submit();
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
function makeAdmin(vID){
	if(confirm("관리자 권한을 변경하시겠습니까?")){
		$("#fm1").attr({action:"mem_x.asp?flag=A&uid="+ vID +"&<%=pageParam%>&page=<%=page%>", method:"POST", target:"nullframe"}).submit();
	}
}
function goActive(vID){
	if(confirm("활성화 상태를 변경하시겠습니까?")){
		$("#fm1").attr({action:"mem_x.asp?flag=B&uid="+ vID +"&<%=pageParam%>&page=<%=page%>", method:"POST", target:"nullframe"}).submit();
	}
}
function chkOut(){
	document.fm1.page.value = 1;
	document.fm1.action = "mem.asp";
	document.fm1.submit();
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
								<td class="pb20">관리자 > 대기(신입)직원관리</td>
							</tr>
							<tr>
								<td>
									<div class="ib mb5">
										<button type="button" onclick="location='mem.asp'" class="btn03">직원목록</button>
										<button type="button" onclick="location='memOut.asp'">퇴사자목록</button>
										&nbsp;
										<select name="cd4" id="cd4" style="width:160px;" onchange="goSearch();"><!-- 부서 -->
											<option value="" selected>부서전체</option>
											<%=cmnCdList("부서", cd4, "", "")%>
										</select>
										<select name="cd3" id="cd3" style="width:160px;" onchange="goSearch();"><!-- 팀 -->
											<option value="" selected>팀전체</option>
											<%=cmnCdList("팀", cd3, cd4, "")%>
										</select>
										<select name="cd6" id="cd6" style="width:160px;" onchange="goSearch();"><!-- 직급 -->
											<option value="" selected>직급전체</option>
											<%=cmnCdList("직급", cd6, "", "")%>
										</select>
										<select name="cd7" id="cd7" style="width:160px;" onchange="goSearch();"><!-- 권한 -->
											<option value="" selected>권한전체</option>
											<%=cmnCdList("권한", cd7, "", "")%>
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
											<th width=5%>사진</th>
											<th width=15%>이름</th>
											<th width=15%>아이디</th>
											<th width=15%>연락처</th>
											<th width=10%>소속부서</th>
											<th width=10%>직급</th>
											<th width=10%>권한</th>
											<th>등록일자</th>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=10></td>
										</tr>
<%
		rso()
		SQL = "	SELECT * FROM memt010 WITH (INDEX (PK_memt010)) "& param &" ORDER BY ddate DESC "
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
												<svg width="30" viewBox="0 0 1664 1792" xmlns="http://www.w3.org/2000/svg"><!-- 사람04 -->
													<path fill="currentColor" d="M1028 644q0 107-76.5 183T768 903t-183.5-76T508 644q0-108 76.5-184T768 384t183.5 76t76.5 184zm-48 220q46 0 82.5 17t60 47.5t39.5 67t24 81t11.5 82.5t3.5 79q0 67-39.5 118.5T1056 1408H480q-66 0-105.5-51.5T335 1238q0-48 4.5-93.5T358 1046t36.5-91.5t63-64.5t93.5-26h5q7 4 32 19.5t35.5 21t33 17t37 16t35 9T768 951t39.5-4.5t35-9t37-16t33-17t35.5-21t32-19.5zm684-256q0 13-9.5 22.5T1632 640h-96v128h96q13 0 22.5 9.5t9.5 22.5v192q0 13-9.5 22.5t-22.5 9.5h-96v128h96q13 0 22.5 9.5t9.5 22.5v192q0 13-9.5 22.5t-22.5 9.5h-96v224q0 66-47 113t-113 47H160q-66 0-113-47T0 1632V160Q0 94 47 47T160 0h1216q66 0 113 47t47 113v224h96q13 0 22.5 9.5t9.5 22.5v192zm-256 1024V160q0-13-9.5-22.5T1376 128H160q-13 0-22.5 9.5T128 160v1472q0 13 9.5 22.5t22.5 9.5h1216q13 0 22.5-9.5t9.5-22.5z"/>
												</svg>
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
												<a href="memWaitVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><b class="fcy"><%=rs("unm")%></b></a>
<%
				If USER_ID = "q400" Then
%>
												<img src="/img/icon/delete02.gif" class="vm pt" onclick="goDelete('<%=rs("uid")%>');" title="삭제" />
<%
				End If
%>
											</td>
											<td>
												<a href="memWaitVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=rs("uid")%></a>
											</td>
											<td>
												<a href="memWaitVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=rs("hp1") &"-"& rs("hp2") &"-"& rs("hp3")%></a>
											</td>
											<td>
												<a href="memWaitVw.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>"><%=cmnCd1("부서", rs("dept"), "")%></a>
											</td>
											<td>
												<a href="javascript:;" onclick="unoPop('latePop.asp?uid=<%=rs("uid")%>','지각관리',550,430);"><%=cmnCd1("직급", rs("ulvl"), "")%></a>
											</td>
											<td>
<%				If USER_AUTH <= 10 Then %>
												<a href="javascript:makeAdmin('<%=rs("uid")%>');" title="관리자해제" /><%=auth%></a>
<%				Else %>
												<a href="javascript:makeAdmin('<%=rs("uid")%>');" title="관리자지정" /><%=auth%></a>
<%				End If %>
											</td>
											<td>
												<a href="javascript:goActive('<%=rs("uid")%>');" title="활성화등록" /><%=rs("ddate")%></a>
											</td>
										</tr>
<%
							rs.MoveNext
							If Not rs.eof Then
%>
										<tr>
											<td height="1" colspan="9" background="/img/dot.png"></td>
										</tr>
<%
							End If
					i = i + 1
					j = j - 1
			Loop
		Else
%>
										<tr><td align="center" height="100" valign="middle" colspan=10>조회 내용이 없습니다.</td></tr>
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
							<button type="button" id=btnReset onclick="location='memWait.asp'">새로고침</button>
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
