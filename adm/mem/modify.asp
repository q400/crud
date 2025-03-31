<!-- #include virtual = "/inc/header.asp" -->
<!-- #include virtual = "/lib/aes.asp" -->
<%
'************************************************************************************
'* 화면명	: modify.asp - 직원관리(관리자)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))
	cd3							= SQLI(Request("cd3"))			'팀
	cd4							= SQLI(Request("cd4"))			'부서
	cd5							= SQLI(Request("cd5"))			'퇴사자
	cd6							= SQLI(Request("cd6"))			'직급
	cd7							= SQLI(Request("cd7"))			'권한
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))
'	Response.Write "flag : "& flag &"<br>"

	pageParam = "cd1="& cd1 &"&cd2="& cd2 &"&cd3="& cd3 &"&cd4="& cd4 &"&cd5="& cd5 &"&cd6="& cd6 &"&cd7="& cd7

	If uid = "" Then
		Call AlertGo("ID가 선택되지 않았습니다.","mem.asp?page="& page &"&"& pageParam)
	End If

'	Set cx = New BsfCode

	rso()
	SQL = "	SELECT * "_
		& " FROM memt010 x LEFT JOIN memt020 y "_
		& " ON x.uid = y.uid "_
		& " WHERE x.uid = '"& uid &"' "
'	Response.Write "<br>"& SQL &"<br>"
	rs.open SQL, dbCon, 3
	If Not rs.eof Then
		unm						= rs("unm")
		pwd0					= rs("pwd")
		base_vaca				= rs("base_vaca")					'연차일수
		spcl_vaca				= rs("spcl_vaca")					'특차일수
		email					= rs("email")
		zip						= rs("zip")
		addr					= rs("addr")
		hp1						= rs("hp1")
		hp2						= rs("hp2")
		hp3						= rs("hp3")
		dept					= rs("dept")						'부서
		team					= rs("team")						'팀
		ulvl					= rs("ulvl")						'직급
		auth					= rs("auth")						'권한
		sdate					= rs("sdate")
		birth_yy				= rs("birth_yy")
		birth_mm				= rs("birth_mm")
		birth_dd				= rs("birth_dd")
		pic						= rs("pic")
		ot_pnt					= rs("ot_pnt")
		open_yn					= rs("open_yn")
		css						= rs("css")
		emgc_tel				= Trim(rs("emgc_tel"))
		emgc_rel				= Trim(rs("emgc_rel"))

		enterYY					= Left(sdate,4)
		enterMM					= Right(Left(sdate,6),2)
		enterDD					= Right(sdate,2)
		email1					= Left(email, InStr(email, "@")-1)
		email2					= Right(email, Len(email)-Len(email1)-1)
	End If
	rsc()

	param = " AND cid = '"& USER_COMP &"' "
	param4 = " AND idx LIKE '"& LEFT(dept,1) &"%' "

	If cd2 <> "" Then						'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' "
	ElseIf cd3 <> "" Then
		param = param &" AND team = '"& cd3 &"' "
	ElseIf cd4 <> "" Then
		param = param &" AND dept = '"& cd4 &"' "
	End If

	If cd5 <> "" Then param = param &" AND open_yn = 'N' "
	If cd6 <> "" Then param = param &" AND ulvl = "& cd6
	If cd7 <> "" Then param = param &" AND auth = "& cd7

	rso()
	SQL = " SELECT ( "_
		& "		SELECT TOP (1) uid "_
		& "		FROM memt010 "_
		& "		WHERE x.ddate > ddate "_
		& param _
		& "		ORDER BY ddate DESC) "_
		& " FROM memt010 x "_
		& " WHERE uid = '"& uid &"' "
	rs.open SQL, dbcon
	If Not rs.eof Then
		pvID = rs(0)	'이전
	End If
	rsc()

	rso()
	SQL = " SELECT ( "_
		& "		SELECT TOP (1) uid "_
		& "		FROM memt010 "_
		& "		WHERE x.ddate < ddate "_
		& param _
		& "		ORDER BY ddate) "_
		& " FROM memt010 x "_
		& " WHERE uid = '"& uid &"' "
	rs.open SQL, dbcon
	If Not rs.eof Then
		ntID = rs(0)	'다음
	End If
	rsc()
%>

<script type="text/javascript" src="/inc/js/join_mod.js"></script>
<script type="text/javascript" src="/inc/js/comscript.js"></script>
<script type="text/javascript">
$(document).ready(function(){
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

function controlKey(){
	var direction = event.keyCode;
	switch(direction){
		case 39:			//우측방향키
			/*
			<%If answer="" Then%>
			openReWin(<%=seq%>,'R');
			<%Else%>
			openReWin(<%=seq%>,'RM');
			<%End If%>
			*/
			break;
		case 37:			//좌측방향키
			/*
			document.location = "counsel.asp?page=<%=page%>&<%=pageParam%>";
			*/
			break;
		case 38:			//위쪽방향키
			controlVw(1);
			break;
		case 40:			//아래쪽방향키
			controlVw(-1);
			break;
		case 46:			//Delete
			/*
			goDelete();
			*/
			break;
		default:
			break;
	}
}
function controlVw(vIdx){
	if (vIdx == 1){
		document.location = "?uid=<%=ntID%>&page=<%=page%>&<%=pageParam%>";
	} else if (vIdx == -1){
		document.location = "?uid=<%=pvID%>&page=<%=page%>&<%=pageParam%>";
	}
}
function goSave(){
	var f = document.fm1;
	if(!f.dept.value){		//부서체크
		alert("소속부서를 선택하세요.");
		return;
	}
	if(!f.hp1.value||!f.hp2.value||!f.hp3.value){	//휴대전화번호 체크
		alert("휴대전화번호를 입력해 주세요.");
		f.hp3.focus();
		return;
	}
	if(f.hp1.value){
		if(!IsNumber(f.hp1.name)){
			alert("휴대전화번호는 숫자여야 합니다.");
			f.hp1.focus();
			return;
		}
	}
	if(f.hp2.value){
		if(!IsNumber(f.hp2.name)){
			alert("휴대전화번호는 숫자여야 합니다.");
			f.hp2.focus();
			return;
		}
	}
	if(f.hp3.value){
		if(!IsNumber(f.hp3.name)){
			alert("휴대전화번호는 숫자여야 합니다.");
			f.hp3.focus();
			return;
		}
	}
	/*
	if(f.emgc_tel.value == ""){		//비상연락처
		alert("비상연락처를 입력하세요.");
		f.emgc_tel.focus();
		return;
	}
	if(f.emgc_rel.value == ""){		//비상연락관계
		alert("비상연락관계를 입력하세요.");
		f.emgc_rel.focus();
		return;
	}
	*/
	$("#fm1").attr({action:"modify_x.asp", method:'post'}).submit();
}
function pwdReset(){
	if(confirm("비밀번호를 12345로 리셋합니다.")){
		$("#flag").val("RESET");
		$("#fm1").attr({action:"modify_x.asp?uid=<%=uid%>&<%=pageParam%>&page=<%=page%>", method:"POST", target:""}).submit();
	}
}
function insaCard(uid){		//인사카드
	Popup("/adm/card/card.asp?uid="+ uid,900,1000,0,0,0,1,10);
}
</script>


<body onKeyDown="controlKey();">
<table id="tbl" width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr height="100%">
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td valign="top">

<form name="fm1" id=fm1 method="post" enctype="multipart/form-data">
<input type="hidden" name="uid" id=uid value="<%=uid%>">
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>">
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>">
<input type="hidden" name="cd3" id=cd3 value="<%=cd3%>">
<input type="hidden" name="cd4" id=cd4 value="<%=cd4%>">
<input type="hidden" name="cd5" id=cd5 value="<%=cd5%>">
<input type="hidden" name="cd6" id=cd6 value="<%=cd6%>">
<input type="hidden" name="cd7" id=cd7 value="<%=cd7%>">
<input type="hidden" name="page" id=page value="<%=page%>">
<input type="hidden" name="flag" id=flag value="<%=flag%>">

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > 직원관리 > 직원상세정보</td>
							</tr>
							<tr>
								<td>
									<div class=""></div>
									<div class="ib mb5 frt">
										<button type="button" onclick="unoPop('../card/addInfoPop1.asp?uid=<%=uid%>','<%=unm%>(<%=uid%>) 부가정보등록',1000,500);" class="btn02">부가정보등록</button>
										<button type="button" onclick="insaCard('<%=uid%>')" class="btn03">인사카드</button>
									</div>
								</td>
							</tr>
							<tr>
								<td colspan=2 height="2" bgcolor="#727d85"></td>
							</tr>
							<tr>
								<td colspan=2>
									<table width="100%" id="list2">
										<colgroup>
											<col style="width:200px;" />
											<col />
										</colgroup>
										<tbody>
											<tr height=30>
												<th>아이디</th>
												<td>
													<b class="ff f17 fc9 ls"><%=uid%></b>
													<input type="text" name="ot_pnt" id=ot_pnt style="width:30px;display:none;" value="<%=ot_pnt%>" class="bx ct" maxlength=2 /><!-- 초과근무 point - "정수"로만 입력 -->
<%
			If uid = "q400" Then
%>
													<span class="ml30">
														<input type="radio" name="css" id="css1" value="main"<%If css = "main" Then%> checked<%End If%> class="vm" />
														<label for="css1" class="vm pt">기본</label>
														<input type="radio" name="css" id="css2" value="dark01"<%If css = "dark01" Then%> checked<%End If%> class="vm" />
														<label for="css2" class="vm pt">DARK</label>
													</span>
<%
			End If
%>
												</td>
											</tr>
											<tr height=30>
												<th>이름</th>
												<td>
													<input type="text" name="unm" id=unm style="width:180px;" value="<%=unm%>" />
												</td>
											</tr>
											<tr height=30>
												<th>비밀번호 초기화</th>
												<td>
													<button type="button" onclick="pwdReset()">초기화</button>
												</td>
											</tr>
											<tr height=30>
												<th>정보공개여부</th>
												<td>
													<span class="">
														<input type="radio" name="open_yn" id="open_y" value="Y"<%If open_yn = "Y" Then%> checked<%End If%> class="vm" />
														<label for="open_y" class="vm pt">공개</label>
														<input type="radio" name="open_yn" id="open_n" value="N"<%If open_yn = "N" Then%> checked<%End If%> class="vm" />
														<label for="open_n" class="vm pt">비공개</label>
													</span>
												</td>
											</tr>
											<tr height=30>
												<th>휴가잔여일수</th>
												<td>
													<b class="fc9"><%=memVaca(uid)%></b> 일
													<span class="ml50">
														연차 :
														<select name="base_vaca" style="width:80px;" title="연월차지정">
<%
			For P = 0 To 26 Step 0.5
%>
															<option value="<%=P%>" <%If P = CDbl(base_vaca) Then%>selected<%End If%>><%=P%></option>
<%
			Next
%>
														</select>
														&nbsp;
														특차 :
														<select name="spcl_vaca" style="width:80px;" title="특차지정">
<%
			For U = 0 To 26
%>
															<option value="<%=U%>" <%If U = spcl_vaca Then%>selected<%End If%>><%=U%></option>
<%
			Next
%>
														</select>
													</span>
												</td>
											</tr>
											<tr height=30>
												<th>생일</th>
												<td>
													<select name="birthYY" id="birthYY" style="width:80px;">
<%
			For yy = Year(Date()) To 1950 Step -1
%>
														<option value="<%=yy%>" <%If birth_yy = CStr(yy) Then%>selected<%End If%>><%=yy%></option>
<%
			Next
%>
													</select> 년
													&nbsp;
													<select name="birthMM" style="width:60px;">
<%
			For K = 1 To 12
%>
														<option value="<%=setP(K)%>" <%If birth_mm = setP(K) Then%>selected<%End If%>><%=setP(K)%></option>
<%
			Next
%>
													</select> 월
													&nbsp;
													<select name="birthDD" style="width:60px;">
<%
			For J = 1 To 31
%>
														<option value="<%=setP(J)%>" <%If birth_dd = setP(J) Then%>selected<%End If%>><%=setP(J)%></option>
<%
			Next
%>
													</select> 일
												</td>
											</tr>
											<tr height=30>
												<th>소속부서/팀/직급/권한</th>
												<td>
													<select name="dept" id="dept" style="width:180px;">
														<option value="" selected>부서선택</option>
														<%=cmnCdList("부서",dept,"","","")%>
													</select>
													<select name="team" id="team" style="width:180px;">
														<option value="" selected>팀선택</option>
														<%=cmnCdList("팀",team,dept,"","")%>
													</select>
													<select name="ulvl" id="ulvl" style="width:180px;">
														<option value="" selected>직급선택</option>
														<%=cmnCdList("직급",ulvl,"","","")%>
													</select>
													<select name="auth" id="auth" style="width:180px;">
														<option value="" selected>권한선택</option>
														<%=cmnCdList("권한",auth,"","","")%>
													</select>
												</td>
											</tr>
											<tr height=30>
												<th>입사일자</th>
												<td>
													<select name="enterYY" id="enterYY" style="width:80px;">
<%
			For p = Year(Date()) To 2000 Step -1
%>
														<option value="<%=p%>" <%If Int(enterYY) = p Then%>selected<%End If%>><%=p%></option>
<%
			Next
%>
													</select> 년
													&nbsp;
													<select name="enterMM" id="enterMM" style="width:60px;">
<%
			For k = 1 To 12
%>
														<option value="<%=setP(k)%>" <%If enterMM = setP(k) Then%>selected<%End If%>><%=setP(k)%></option>
<%
			Next
%>
													</select> 월
													&nbsp;
													<select name="enterDD" id="enterDD" style="width:60px;">
<%
			For j = 1 To 31
%>
														<option value="<%=setP(j)%>" <%If enterDD = setP(j) Then%>selected<%End If%>><%=setP(j)%></option>
<%
			Next
%>
													</select> 일
												</td>
											</tr>
											<tr height=30>
												<th>휴대전화</th>
												<td>
													<select name="hp1" id="hp1" style="width:80px;">
														<option value="" selected>선택</option>
														<option value="010" <%If hp1 = "010" Then%>selected<%End If%>>010</option>
														<option value="011" <%If hp1 = "011" Then%>selected<%End If%>>011</option>
														<option value="016" <%If hp1 = "016" Then%>selected<%End If%>>016</option>
														<option value="017" <%If hp1 = "017" Then%>selected<%End If%>>017</option>
														<option value="018" <%If hp1 = "018" Then%>selected<%End If%>>018</option>
														<option value="019" <%If hp1 = "019" Then%>selected<%End If%>>019</option>
													</select>
													-
													<input type="text" name="hp2" value="<%=hp2%>" style="width:80px;" maxlength="4" onkeypress="onlyNumber();" />
													-
													<input type="text" name="hp3" value="<%=hp3%>" style="width:80px;" maxlength="4" onkeypress="onlyNumber();" />
												</td>
											</tr>
											<tr height=30>
												<th>비상연락망</th>
												<td>
													<input type="text" name="emgc_tel" value="<%=emgc_tel%>" style="width:180px;" maxlength="50" placeholder="입력예 010-0000-0000" />
												</td>
											</tr>
											<tr height=30>
												<th>비상연락관계</th>
												<td>
													<input type="text" name="emgc_rel" value="<%=emgc_rel%>" style="width:180px;" maxlength="50" />
												</td>
											</tr>
											<tr height=30>
												<th>이메일</th>
												<td>
													<input type="text" name="email1" style="width:180px;" maxlength="30" value="<%=email1%>">
													@
													<input type="text" name="email2" style="width:180px;" maxlength="50" value="<%=email2%>">
													<select name="email3" style="width:180px;" onChange="selectMail(this.form);">
														<option value="">선택</option>
														<%=cmnCdList0("이메일","daum.net","")%>
													</select>
												</td>
											</tr>
											<!--
											<tr height=30>
												<th>계좌정보</th>
												<td>
													<select name="bank" id="bank" style="width:130px;">
														<option value="">선택</option>
													</select>
													<input type="text" name="acc" id="acc" style="width:200px;" maxlength="30" value="<%=acc%>" />
												</td>
											</tr>
											-->
<script>
document.domain = "https:crud.kr";
function jusoCallBack(zipNo,roadFullAddr){
	if(roadFullAddr.indexOf('?') == -1){
		$("#zip").val(zipNo);
		$("#addr").val(roadFullAddr);
	}else{
		alert('주소 정보를 가져오는데 문제가 발생했습니다.\n새로고침(F5) 후 다시 주소를 선택 바랍니다.');
		document.location.reload();
	}
}
function goPopup(){
	// 주소검색을 수행할 팝업 페이지를 호출합니다.
	// 호출된 페이지(jusopopup.asp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
	var pop = window.open("/mem/jusoPopup.asp","pop","width=570,height=420, scrollbars=yes, resizable=yes");

	// 모바일 웹인 경우, 호출된 페이지(jusopopup.asp)에서 실제 주소검색URL(http://www.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
    //var pop = window.open("/jusoPopup.asp","pop","scrollbars=yes, resizable=yes");
}
</script>
											<!--
											<tr height=30>
												<th>거주지주소</th>
												<td>
													<div class="mt5">
														<input type="text" name="zip" id=zip value="<%=zip%>" style="width:80px;" maxlength=6 />
														<button type="button" onclick="goPopup()">우편번호검색</button>
													</div>
													<div class="mt5 mb5">
														<input type="text" name="addr" id=addr value="<%=addr%>" style="width:90%;" />
													</div>
												</td>
											</tr>
											<tr height=30>
												<th>특이사항</th>
												<td>
													<textarea name="etc" id="etc" style="width:95%;height:100px;"><%=etc%></textarea>
												</td>
											</tr>
											-->
<%		If USER_AUTH <= 10 Then %>
											<tr height=30>
												<th>사진관리</th>
												<td>
<%
				If pic <> "" Then
%>
													<a href="javascript:;" onclick="unoPop('/mem/picPop.asp?img=<%=PATH_PIC%>/<%=pic%>','<%=unm%>',250,320);">
													<img src="<%=PATH_PIC%>/s<%=pic%>" width=50 class="vb" /></a>
<%
				End If
%>
													<input type="file" name="upFile" style="width:40%;" />&nbsp;(가로 150px 권장)
												</td>
											</tr>
<%		End If %>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td colspan=2 height=2 bgcolor="#727d85"></td>
							</tr>
						</table>
						<div class="mt10 ct">
							<button type="button" onclick="goSave()" class="btn01">저장</button>
							<button type="button" onclick="document.location='mem.asp?<%=pageParam%>&page=<%=page%>'">목록</button>
						</div>
</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
