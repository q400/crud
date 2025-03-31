<!-- #include virtual = "/inc/header.asp" -->
<!-- #include virtual = "/inc/bsfCode.asp" -->
<%
'************************************************************************************
'* 화면명	: mem.asp - 고객관리 > 회원관리목록
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	uip							= Request.ServerVariables("REMOTE_ADDR")
	uip							= Left(uip,InStr(9,uip,"."))

	cid							= SQLI(Request("cid"))				'고객사코드
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	cd3							= SQLI(Request("cd3"))
	cd4							= SQLI(Request("cd4"))				'부서
	page						= SQLI(Request("page"))

	If cd3 <> "" Then cd2 = ""										'cd3이 ""이 아니면 cd2를 ""처리
	If cd1 = "" Then cd1 = "unm"
	If page = "" Then page = 1

	pageSize = 20													'페이지크기

	If cd2 <> "" Then												'검색조건이 있는 경우
		param = " WHERE "& cd1 &" LIKE '%"& cd2 &"%'"
	ElseIf cd3 <> "" Then
		param = " WHERE dept = '"& cd3 &"' "
	Else															'검색조건이 없는 경우
		param = " WHERE 1=1 "
	End If

	If cid <> "" Then param = param & " AND cid = '"& cid &"' "

	param4 = ""

	If cd4 <> "" Then
		param = param &" AND dept = '"& cd4 &"' "
		param4 = " AND idx LIKE '"& LEFT(cd4,1) &"%' "
	End If

	rso()
	SQL = "	SELECT * FROM memt010 "& param &" ORDER BY ddate DESC "
	rs.open SQL, dbcon, 3
		k = rs.recordcount
	rsc()

	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&cd4="& cd4
%>

<script type="text/javascript" src="/inc/js/comscript.js"></script>
<script type="text/javascript">
<!--
$(document).ready(function(){
<%	If cd1 = "dept" Then %>
	$('#sub1').hide();
	$('#sub4').show();
<%	Else %>
	$('#sub1').show();
	$('#sub4').hide();
<%	End If %>
	$('#cid').change(function (){			//고객사 선택
		$('#cid').val($('#cid option:selected').val());
		$('#fm1').attr({action:'mem.asp', method:'POST', target:''}).submit();
	});
});
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
		var msg = "++ 선택한 직원, 총 "+ selectedCount +"명 ++     \n\n----------------------------------------     \n\n"+ seq
		+"\n\n----------------------------------------     \n\n\n위 직원(들)에게 SMS를 발송하시겠습니까?"
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
	document.fm1.action = "mem.asp";
	document.fm1.submit();
}
function chkDel(vID,vcd1,vcd2,vcd3){
	if(confirm("삭제?")){
		document.fm1.action = "mem_dx.asp?uid="+ vID +"&<%=pageParam%>";
		document.fm1.method = "post";
		document.fm1.target = "nullframe";
		document.fm1.submit();
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


<table width=100% border="0" cellpadding="0" cellspacing="0">
	<tr height="100%">
		<td class="vt">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/adm_left.asp" -->
					</td>
					<td valign="top">

<form name=fm1 id=fm1>
<input type="hidden" name="page" value="<%=page%>">

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > 고객관리 > 회원관리</td>
							</tr>
							<tr>
								<td>
									<div class="ib mb10">
										<select name="cid" id="cid" style="width:250px;"><!-- 고객사 -->
											<option value="" <%If cid = "" Then%>selected<%End If%>>선택</option>
<%
			rso()
			SQL = "	SELECT cid, comp_nm FROM cmpt010 WHERE 1=1 AND use_yn = 'Y' ORDER BY ddate ASC "
			rs.open SQL, dbCon, 3
			Do Until rs.eof
%>
											<option value="<%=rs("cid")%>"<%If rs("cid") = cid Then%>selected<%End If%>><%=rs("comp_nm")%></option>
<%
				rs.MoveNext
			Loop
			rsc()
%>
										</select>
										<select name="cd4" id="cd4" style="width:200px;" onchange="goSearch();"><!-- 부서 -->
											<option value="" selected>부서전체</option>
											<%=cmnCdList("부서",cd4,"","",cid)%>
										</select>
									</div>
									<div class="ib mt20 mb5 frt"><%=FormatNumber(k,0)%> 건</div>
								</td>
							</tr>
							<tr>
								<td colspan=2 height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td colspan=2>
									<table width=100% border="0" cellspacing="0" cellpadding="0" style="min-width: 1000px;">
										<tr height="40">
											<th width=5%>No.</th>
											<th width=10%>이름</th>
											<th width=12%>아이디</th>
											<th width=10%>연락처</th>
											<th width=15%>소속</th>
											<th width=9%>코드값</th>
											<th width=9%>소속부서</th>
											<th width=9%>소속팀</th>
											<th width=7%>직급</th>
											<th width=8%>권한</th>
											<th>등록일자</th>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=12></td>
										</tr>
<%
		Call rso()
		SQL = "	SELECT * FROM memt010 "& param &" ORDER BY ddate DESC "
		rs.open SQL, dbcon, 3

		rs.pageSize = 20
		j = rs.recordcount

		If Not (rs.eof And rs.bof) Then

			totalpage = rs.pagecount
			rs.absolutepage = page

			If page <> 1 Then
				j = j - (page - 1) * rs.pageSize
			End If

			i = 1
			Do Until rs.EOF Or i > rs.pageSize

				If rs("open_yn") = "N" Then %>
										<tr bgcolor="#3B2D1B" height=34 class="ct pt" onclick="location='mem_u.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>'">
<%				Else %>
										<tr height=34 class="ct pt" onclick="location='mem_u.asp?uid=<%=rs("uid")%>&<%=pageParam%>&page=<%=page%>'">
<%				End If %>
											<td><%=j%><!-- <input type="checkbox" name="chk" value="<%=rs("uid")%>:<%=rs("unm")%>"> --></td>
											<!-- <td> -->
<%'				If rs("pic") = "" Then %>
												<!-- <img src="<%=PATH_PIC%>/pic40.png" width=20 /></td> -->
<%'				Else %>
												<!-- <a href="javascript:;" onclick="unoPop('/mem/picPop.asp?img=<%=PATH_PIC%>/<%=rs("pic")%>','<%=rs("unm")%>',250,320);">
												<img src="<%=PATH_PIC%>/ss<%=rs("pic")%>" /></a></td> -->
<%'				End If %>
											<td><%=rs("unm")%></td>
											<td><%=rs("uid")%></td>
											<td><%=rs("hp1") &"-"& rs("hp2") &"-"& rs("hp3")%></a></td>
											<td><%=cmpInfo(rs("cid"), "comp_nm")%></td>
											<td><%=rs("cid")%></td>
											<td><%=cmnCd("부서",rs("dept"),"",rs("cid"))%></td>
											<td><%=cmnCd("팀",rs("team"),"",rs("cid"))%></td>
											<td><%=cmnCd("직급",rs("ulvl"),"",rs("cid"))%></td>
											<td><%=cmnCd("권한",rs("auth"),"",rs("cid"))%></td>
											<td><%=Left(rs("ddate"),10)%></td>
										</tr>
										<tr>
											<td height="1" colspan=12 background="/img/dot.png"></td>
										</tr>
<%
				rs.MoveNext
				i = i + 1
				j = j - 1
			Loop
		Else
%>
										<tr><td align="center" height="100" valign="middle" colspan=12>조회 내용이 없습니다.</td></tr>
<%
		End If
		Call rsc()
%>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan=2 height="2" bgcolor="#b2bdd5"></td>
							</tr>
						</table>
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, pageParam)%></div>
<script type="text/javascript">
<!--
function selectSub(cat){
	//alert(cat.selectedIndex);
	if(cat.selectedIndex == '4'){
		$("#sub1").hide();
		$("#sub4").show();
	} else {
		$("#sub1").show();
		$("#sub4").hide();
	}
}
// -->
</script>
						<div class="ct mt10 pb50">
							<select name="cd1" id=cd1 style="width:150px;" onchange="selectSub(this);">
								<option value="" <%If cd1 = "" Then%>selected<%End If%>>선택</option>
								<option value="unm" <%If cd1 = "unm" Then%>selected<%End If%>>이름</option>
								<option value="uid" <%If cd1 = "uid" Then%>selected<%End If%>>ID</option>
								<option value="hp3" <%If cd1 = "hp3" Then%>selected<%End If%>>휴대전화끝4자리</option>
								<option value="dept" <%If cd1 = "dept" Then%>selected<%End If%>>부서</option>
							</select>
							<span id="sub1">
								<input type="text" name=cd2 <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" />
							</span>
							<span id="sub4">
								<select name="cd3" id=cd3 style="width:200px;">
									<option selected value="">선택</option>
									<%=cmnCdList("부서",cd3,"","",cid)%>
								</select>
							</span>
							<button type="button" onclick="goSearch();">조회</button>
							<button type="button" onclick="location='mem.asp'">새로고침</button>
						</div>
					</td>
				</tr>
			</table>
</form>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
