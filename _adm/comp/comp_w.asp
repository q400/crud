<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: comp_w.asp - 사용신청
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "comp_nm"
	If page = "" Then page = 1
	If flag = "" Then flag = "M"

	serverPath = Server.MapPath(PATH_REQUEST)
	webPath = PATH_REQUEST

	If seq <> "" Then
		rso()
		SQL = " SELECT ISNULL(c.cid, '') cid, comp_nm, induty_cl, mngr_id, mngr_nm, mngr_tel, mngr_eml, " _
			& "        (SELECT COUNT(*) FROM memt010 m WHERE m.cid = c.cid) emp_cnt, scrty_cmp, sttus, use_yn, ddate, opt1, opt2, contents " _
			& " FROM cmpt010 c " _
			& " WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cid					= rs("cid")
			comp_nm				= rs("comp_nm")
			induty_cl			= rs("induty_cl")
			mngr_id				= rs("mngr_id")
			mngr_nm				= rs("mngr_nm")
			mngr_tel			= rs("mngr_tel")
			mngr_eml			= rs("mngr_eml")
			emp_cnt				= rs("emp_cnt")
			scrty_cmp			= rs("scrty_cmp")
			sttus				= rs("sttus")
			use_yn				= rs("use_yn")
			ddate				= rs("ddate")
			opt1				= rs("opt1")					'기본출근시간
			opt2				= rs("opt2")					'기본퇴근시간
			contents			= rs("contents")
		End If
		rsc()
	Else
		Call AlertGo("상세정보가 없습니다.","comp.asp")
		Response.End
	End If

	rso()
	SQL = " SELECT RIGHT(CONCAT('00', (ISNULL(MAX(RIGHT(cid, 3)) + 1, '1'))), 3) as mxNum " _
		& " FROM cmpt010 " _
		& " WHERE cid NOT IN ('00000','ZZ999')"
	rs.open SQL, dbcon
	If Not rs.eof Then
		mxNum					= rs("mxNum")					'cid 생성
	End If
	rsc()
%>

<script type="text/javascript">
$(document).ready(function(){
	let tel = $('#mngr_tel').val().replaceAll('-', '');

	$('#smsSend').click(function(){ //SMS발송
		if($('#induty_cl').val() == ''){
			alert('먼저 업종코드를 선택하세요.');
			$('#induty_cl').focus();
			return false;
		}
		$('.sms').show();
//		$('#fm2').attr({action:"/inc/sms/sendSMS.asp?tel="+ tel, method:"post", target:"_blank"}).submit();
	});

	$('#smsNate').click(function(){ //SMS발송(네이트)
		if($('#induty_cl').val() == ''){
			alert('먼저 업종코드를 선택하세요.');
			$('#induty_cl').focus();
			return false;
		}
		$('#fm2').attr({action:"https://sms.nate.com/web2009/html/sms.jsp?tel="+ tel, method:"post", target:"_blank"}).submit();
	});

	$('#opt1').timepicker({ //출근시간
		timeFormat: 'H:i',
		dynamic: false,
		interval: 30
	});

	$('#opt2').timepicker({ //퇴근시간
		timeFormat: 'H:i',
		dynamic: false,
		interval: 30
	});
});
function goSave(){
	if(fnValidation($("#fm1"))) return; //유효성 체크
	$("#fm1").attr({action:"comp_x.asp", method:"POST", target:""}).submit();
}
function goDelete(){ //삭제
	if (!confirm("관련된 회원정보, 매칭코드정보, 업체정보를 모두 삭제합니까?")){
		return;
	}
	$("#flag").val("D");
	$("#fm1").attr({action:"comp_x.asp", method:"POST", target:""}).submit();
}
</script>


<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/adm_left.asp" -->
					</td>
					<td class="vt">

<form name="fm1" id=fm1 method="POST" enctype="multipart/form-data">
<input type="hidden" name="seq" id=seq value="<%=seq%>" />
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
<input type="hidden" name="flag" id=flag value="<%=flag%>" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > <a href="/_adm/comp/comp.asp">고객관리</a> > 고객사관리 상세</td>
							</tr>
							<tr>
								<td>
									<div class="">
										<span></span>
									</div>
									<div class="ib mb5 frt">
										<button type="button" onclick="unoPop('setPop.asp?cid=<%=cid%>&code_se=부서','부서관리',620,600)" class="">부서관리</button>
										<button type="button" onclick="unoPop('setPop.asp?cid=<%=cid%>&code_se=팀','팀관리',620,600)" class="">팀관리</button>
										<button type="button" onclick="unoPop('setPop.asp?cid=<%=cid%>&code_se=직급','직급관리',620,600)" class="">직급관리</button>
										<button type="button" onclick="unoPop('setPop.asp?cid=<%=cid%>&code_se=권한','권한관리',620,600)" class="">권한관리</button>
									</div>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0">
										<tr>
											<th width=200><label>고객사</label><em class="fc4 ml5">*</em></th>
											<td height=40>
												<input type="text" name="comp_nm" id="comp_nm" maxlength="50" style="width:400px;" value="<%=comp_nm%>" />
											</td>
										</tr>
										<tr>
											<th><label>업종코드</label><em class="fc4 ml5">*</em></th>
											<td height=40>
												<select name="induty_cl" id="induty_cl" style="width:400px;">
													<option value="" <%If induty_cl = "" Then%>selected<%End If%>>선택</option>
													<option value="A" <%If induty_cl = "A" Then%>selected<%End If%>>농업, 임업 및 어업</option>
													<option value="B" <%If induty_cl = "B" Then%>selected<%End If%>>광업</option>
													<option value="C" <%If induty_cl = "C" Then%>selected<%End If%>>제조업</option>
													<option value="D" <%If induty_cl = "D" Then%>selected<%End If%>>전기,가스, 증기 및 공기조절 공급업</option>
													<option value="E" <%If induty_cl = "E" Then%>selected<%End If%>>수도, 하수 및 폐기물 처리, 원료 재생업</option>
													<option value="F" <%If induty_cl = "F" Then%>selected<%End If%>>건설업</option>
													<option value="G" <%If induty_cl = "G" Then%>selected<%End If%>>도매 및 소매업</option>
													<option value="H" <%If induty_cl = "H" Then%>selected<%End If%>>운수 및 창고업</option>
													<option value="I" <%If induty_cl = "I" Then%>selected<%End If%>>숙박 및 음식점업</option>
													<option value="J" <%If induty_cl = "J" Then%>selected<%End If%>>정보통신업</option>
													<option value="K" <%If induty_cl = "K" Then%>selected<%End If%>>금융 및 보험업</option>
													<option value="L" <%If induty_cl = "L" Then%>selected<%End If%>>부동산업</option>
													<option value="M" <%If induty_cl = "M" Then%>selected<%End If%>>전문, 과학 및 기술서비스업</option>
													<option value="N" <%If induty_cl = "N" Then%>selected<%End If%>>사업시설 관리, 사업 지원 및 임대 서비스업</option>
													<option value="O" <%If induty_cl = "O" Then%>selected<%End If%>>공공행정, 국방 및 사회보장 행정</option>
													<option value="P" <%If induty_cl = "P" Then%>selected<%End If%>>교육서비스</option>
													<option value="Q" <%If induty_cl = "Q" Then%>selected<%End If%>>보건업 및 사회복지 서비스업</option>
													<option value="R" <%If induty_cl = "R" Then%>selected<%End If%>>예술, 스포츠 및 여가관련 서비스업</option>
													<option value="S" <%If induty_cl = "S" Then%>selected<%End If%>>협회 및 단체, 수리 및 기타 개인 서비스업</option>
													<option value="T" <%If induty_cl = "T" Then%>selected<%End If%>>가구 내 고용활동, 자가소비 생산활동</option>
													<option value="U" <%If induty_cl = "U" Then%>selected<%End If%>>국제 및 외국기관</option>
												</select>
											</td>
										</tr>
										<tr>
											<th><label>고객코드</label><em class="fc4 ml5">*</em></th>
											<td height=40>
												<input type="text" name="cid" id="cid" maxlength="5" style="width:200px;" value="<%=cid%>" readonly />
<!-- 												<button type="button" id="makeCd" class="">코드생성</button> -->
											</td>
										</tr>
										<!--
										<tr>
											<td class="rg pr10" colspan="2">
												<input type="checkbox" name="sms" id="sms" value="Y" onClick="mpop5('sms.asp','ev','center',610,500);" class="vm" />
												<label for="sms">문자발송</label>
											</td>
										</tr>
										//-->
										<tr>
											<th><label>담당자 이름</label><em class="fc4 ml5">*</em></th>
											<td height=40>
												<input type="text" name="mngr_nm" id="mngr_nm" maxlength="20" style="width:200px;" value="<%=mngr_nm%>" />
											</td>
										</tr>
										<tr>
											<th><label>담당자 연락처</label><em class="fc4 ml5">*</em></th>
											<td height=40>
												<input type="text" name="mngr_tel" id="mngr_tel" maxlength="20" style="width:200px;" value="<%=mngr_tel%>" />
												<button type="button" id="smsSend" class="">SMS발송</button>
												<button type="button" id="smsNate" class="">네이트문자</button>
											</td>
										</tr>
										<tr>
											<th><label>담당자 E-mail</label></th>
											<td height=40>
												<input type="text" name="mngr_eml" id="mngr_eml" maxlength="70" style="width:300px;" value="<%=mngr_eml%>" />
											</td>
										</tr>
										<tr>
											<th><label>관리인원 수</label></th>
											<td height=40>
												<input type="text" name="emp_cnt" id="emp_cnt" maxlength="3" style="width:100px;" value="<%=emp_cnt%>" readonly="readonly" /> 명
											</td>
										</tr>
										<tr>
											<th><label>보안업체</label></th>
											<td height=40>
												<select name="scrty_cmp" id="scrty_cmp" style="width:200px;">
													<option value="" selected>선택</option>
<%
			rso()
			SQL = "	SELECT code_id, code_nm FROM codt010 WHERE code_se = '보안업체' AND use_yn = 'Y' ORDER BY code_id ASC "
			rs.open SQL, dbCon, 3
			Do Until rs.eof
%>
													<option value="<%=rs("code_id")%>"<%If rs("code_id") = scrty_cmp Then%>selected<%End If%>><%=rs("code_nm")%></option>
<%
				rs.MoveNext
			Loop
			rsc()
%>
												</select>
											</td>
										</tr>
										<tr>
											<th><label>상태</label></th>
											<td height=40>
												<input type="radio" name="sttus" id="sttus1" value="신청" <%If sttus = "신청" Or sttus = "" Then%>checked<%End If%> class="vm" />
												<label for="sttus1">신청</label>
												<input type="radio" name="sttus" id="sttus2" value="반려" <%If sttus = "반려" Then%>checked<%End If%> class="vm" />
												<label for="sttus2">반려</label>
												<input type="radio" name="sttus" id="sttus3" value="완료" <%If sttus = "완료" Then%>checked<%End If%> class="vm" />
												<label for="sttus3">완료</label>
											</td>
										</tr>
										<tr>
											<th><label>기본출근시간</label></th>
											<td height=40>
												<input type="text" name="opt1" id="opt1" maxlength="5" placeholder="09:00" style="width:100px;" value="<%=opt1%>" />
											</td>
										</tr>
										<tr>
											<th><label>기본퇴근시간</label></th>
											<td height=40>
												<input type="text" name="opt2" id="opt2" maxlength="5" placeholder="18:00" style="width:100px;" value="<%=opt2%>" />
											</td>
										</tr>
										<tr>
											<th><label>사용여부</label></th>
											<td height=40>
												<input type="radio" name="use_yn" id="use_yn1" value="Y" <%If use_yn = "Y" Or use_yn = "" Then%>checked<%End If%> class="vm" />
												<label for="use_yn1">사용</label>
												<input type="radio" name="use_yn" id="use_yn2" value="N" <%If use_yn = "N" Then%>checked<%End If%> class="vm" />
												<label for="use_yn2">미사용</label>
											</td>
										</tr>
										<tr>
											<th><label>하고싶은 말씀</label></th>
											<td height=100>
												<textarea name="contents" id="contents" class="" style="width:500px;height:100px;"><%=contents%></textarea>
											</td>
										</tr>
										<tr>
											<td colspan="2" height="1" bgcolor="#b2bdd5"></td>
										</tr>
										<tr>
											<td colspan="2" height="5"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<div class="mt10 ct pb50">
							<button type="button" onclick="goSave()" class="btn04">저장</button>
<%
		If USER_AUTH <> "" And USER_AUTH <= 10 Then
%>
							<button type="button" onclick="goDelete()" class="btn01">삭제</button>
							<button type="button" onclick="location='comp.asp?page=<%=page%>&cd1=<%=cd1%>&cd2=<%=cd2%>'" class="">목록</button>
<%
		Else
%>
							<button type="button" onclick="location='/'" class="">취소</button>
<%
		End If
%>
						</div>
</form>
<form name="fm2" id=fm2 method="post"></form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
