<!-- #include virtual = "/inc/header3.asp" -->
<%
'************************************************************************************
'* 화면명	: manual.asp - 메뉴얼
'************************************************************************************
'	Call checkLevel(USER_AUTH, 900, Request.ServerVariables("PATH_INFO"))
%>

<style type="text/css">
br {}
</style>
<script type="text/javascript">
$(document).ready(function(){
	$("#code_se").change(function (){		//조회
		goSearch();
	});
	$("#useYn0,#useYn1,#useYn2").click(function (){
		goSearch();
	});
	$("#btnReset").click(function (){		//새로고침
		document.location = "code.asp";
	});
	$("img").click(function(){
		var imgElements = $(this).attr("src");
//		console.log("_________ "+ imgElements);
		unoPop(imgElements, "크게보기", 1370, 900);
//		location.href = "https:crud.kr"+ imgElements;
	});
});
function goSearch(){
	$("#page").val("1");
	$("#fm1").attr({action:"code.asp", method:"post"}).submit();
}
</script>


<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td valign="top">

<form name="fm1" id="fm1">
<input type="hidden" name="bbs_id" id="bbs_id" value="<%=bbs_id%>" />
<input type="hidden" name="seq" id="seq" />
<!-- <input type="hidden" name="page" id="page" value="<%=page%>" /> -->

						<table width=90% border="0" cellspacing="0" cellpadding="0" style="margin: 0 auto;" class="">
							<tr>
								<td colspan=2 class="" id="00">
									<span class="f25 fb mr50">CRUD 근태관리 HR 시스템 메뉴얼</span>
									<a href="https://crud.kr" target="_blank" class="hint--info hint--right" aria-label="새창열기">https://crud.kr</a>
								</td>
							</tr>
							<tr>
								<td colspan=2>
									<div class="ib frt"><span class="hint--info hint--left" aria-label="2025.04.01 버전">0.9 버전</span></div>
								</td>
							</tr>
							<tr>
								<td colspan=2>
									<div class="">
										<div class="mb5">INDEX</div>
										<div class="mb5">0. 처음</div>
										<div class="ml50 mb3"><a href="#01" class="hint--info hint--right" aria-label="바로가기">0.1 사용목적</a></div>
										<div class="ml50 mb3"><a href="#02" class="hint--info hint--right" aria-label="바로가기">0.2 사용신청</a></div>
										<div class="ml50 mb3"><a href="#03" class="hint--info hint--right" aria-label="바로가기">0.3 사용자등록</a></div>
										<div class="ml50 mb3"><a href="#04" class="hint--info hint--right" aria-label="바로가기">0.4 로그인</a></div>
										<div class="ml50 mb3"><a href="#05" class="hint--info hint--right" aria-label="바로가기">0.5 QR코드</a></div>
										<div class="ml50 mb5"><a href="#06" class="hint--info hint--right" aria-label="바로가기">0.6 메인</a></div>
										<div class="mt5 mb5">1. 신청정보</div>
										<div class="ml50 mb3"><a href="#11" class="hint--info hint--right" aria-label="바로가기">1.1 공지사항</a></div>
										<div class="ml50 mb3"><a href="#12" class="hint--info hint--right" aria-label="바로가기">1.2 통합휴무신청</a></div>
										<div class="ml50 mb3"><a href="#13" class="hint--info hint--right" aria-label="바로가기">1.3 휴무신청현황</a></div>
										<div class="ml50 mb3"><a href="#14" class="hint--info hint--right" aria-label="바로가기">1.4 OTP사용신청</a></div>
										<div class="ml50 mb5"><a href="#15" class="hint--info hint--right" aria-label="바로가기">1.5 탄력근무관리</a></div>
										<div class="mt5 mb5">2. 인사정보</div>
										<div class="ml50 mb3"><a href="#21" class="hint--info hint--right" aria-label="바로가기">2.1 직원목록</a></div>
										<div class="ml50 mb3"><a href="#22" class="hint--info hint--right" aria-label="바로가기">2.2 신입직원현황</a></div>
										<div class="ml50 mb3"><a href="#23" class="hint--info hint--right" aria-label="바로가기">2.3 인사발령</a></div>
										<div class="ml50 mb3"><a href="#24" class="hint--info hint--right" aria-label="바로가기">2.4 지각현황</a></div>
										<div class="ml50 mb5"><a href="#25" class="hint--info hint--right" aria-label="바로가기">2.5 생일자현황</a></div>
										<div class="mt5 mb5">3. 관리자</div>
										<div class="ml50 mb3"><a href="#31" class="hint--info hint--right" aria-label="바로가기">3.1 직원관리</a></div>
										<div class="ml50 mb3"><a href="#32" class="hint--info hint--right" aria-label="바로가기">3,2 휴무내역표</a></div>
										<div class="ml50 mb3"><a href="#33" class="hint--info hint--right" aria-label="바로가기">3.3 휴무신청현황</a></div>
										<div class="ml50 mb3"><a href="#34" class="hint--info hint--right" aria-label="바로가기">3.4 OTP현황</a></div>
										<div class="ml50 mb3"><a href="#35" class="hint--info hint--right" aria-label="바로가기">3.5 탄력근무현황</a></div>
										<div class="ml50 mb5"><a href="#36" class="hint--info hint--right" aria-label="바로가기">3.6 OT정산</a></div>
										<div class="mt5 mb5">4. 설정정보</div>
										<div class="ml50 mb3"><a href="#41" class="hint--info hint--right" aria-label="바로가기">4.1 전체공지</a></div>
										<div class="ml50 mb3"><a href="#42" class="hint--info hint--right" aria-label="바로가기">4.2 작업게시판</a></div>
										<div class="ml50 mb3"><a href="#43" class="hint--info hint--right" aria-label="바로가기">4.3 출퇴근기준시간설정</a></div>
										<div class="ml50"><a href="#44" class="hint--info hint--right" aria-label="바로가기">4.4 환경설정</a></div>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:150px;" id="01">&nbsp;</td>
							</tr>
							<tr>
								<td colspan=2>
									<div class="ib fcy">0. 처음 > 0.1 사용목적</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td colspan=2>
									<div class="ml50" style="line-height:28px;">
										이 프로그램의 사용 목적은 소속 직원들의 근태관리를 기본으로 하며 정확한 데이터를 기반으로<br/>
										직원들의 복지 추구와 함께 인사비용의 투명성 확립을 목표로 합니다.<br/><br/>
										아래는 주요 기능입니다.<br/>
									        ① 연차, 반차, 주휴, 반주휴<span class="fc3">*</span> 구분<br/>
									        ② 부서별/개인별 탄력근무<span class="fc3">*</span>제, 공휴일 대체휴무<span class="fc3">*</span>(일괄지정) 기능<br/>
									        ③ QR코드를 이용한 출퇴근 기록 기능<br/>
											④ 초과 근무(OT) 포인트 계산, 그에 따른 수당 산정 및 포인트 사용 기능<br/>
											⑤ 직원 근무지원, 주먹구구식이 아닌 데이터에 근거한 복지 향상<br/>
											⑥ 병원 등 주말 근무가 필요하지만 주 5일 근무를 실천하고자 하는 직업군의 경우 적합<br/><br/>
										이 프로그램은 ASP(Application Service Provider - 어플리케이션 서비스 임대) 형태로 웹을 통해<br/>
										저렴한 일정 비용으로 사용할 수 있는 애플리케이션 아웃소싱의 개념입니다. (예: gmail 등 웹메일과 다양한 cloud 서비스)<br/><br/>
										<span class="fc3">*</span>주휴ㆍ반주휴 – 토요일 근무 대신 그에 상응하여 사용하는 주중(월~금) 연차 또는 반차<br/>
										<span class="fc3">*</span>탄력근무 – 기본 출퇴근 시간에서 변형하여 새로 정의하는 출퇴근 시간<br/>
										<span class="fc3">*</span>대체휴무 – 주휴와 동일<br/><br/>
										<span class="fc9">상담전화 010.5554.9462 김수현 팀장</span><br/><br/>
										행위자(Actor) 구분<br/>
										운영자 – 시스템을 관리하는 서비스 제공자<br/>
										관리자 – 각 서비스 사용 업체의 인사 책임자<br/>
										사용자 – 각 서비스 사용 업체의 근무자
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="02">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">0. 처음 > 0.2 사용신청</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600">
									<img src="/img/manual/00_사용신청02.jpg" width="600" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 관리자는 서비스 사용을 위해 사용신청서를 작성합니다.<br/>
										2. 관리자는 필수 값<span class="fc4">*</span> 빠짐 없이 정보를 입력합니다.<br/>
										3. 관리자는 저장을 click하여 신청을 완료합니다.<br/>
										4. 운영자의 승인이 완료되면 e메일이나 연락처 등으로 안내가 진행됩니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="03">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">0. 처음 > 0.3 사용자등록</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600">
									<img src="/img/manual/00_사용자등록02.jpg" width="600" style="" />
									<img src="/img/manual/00_사용자등록031.jpg" width="600" style="margin: -200px 0 0 100px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 승인 완료 후 운영자로부터 전달받은 5자리 고객사 코드 값을 입력하고 사용자(일반) 등록을 진행합니다.<br/>
										2. 사용자는 필수 값 누락 없이 정보를 입력합니다.<br/>
										3. 사용자는 등록을 click하여 등록을 완료합니다.<br/>
										4. 관리자 승인과 함께 서비스 사용이 가능합니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="04">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">0. 처음 > 0.4 로그인</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600">
									<img src="/img/manual/00_login02.jpg" width="600" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 승인 완료가 되면 사용신청 시 등록한 ID와 비밀번호를 사용하여 로그인이 가능합니다. (관리자ㆍ사용자 동일)<br/>
										2. 사용자는 출근ㆍ퇴근 정보 기록을 위하여 QR코드를 생성하여 출결 처리를 합니다.<br/>
										3. 프로그램 사용에 대한 설명 화면으로 이동합니다.<br/>
										4. 관리자에 의해 서비스 환경 설정이 준비되면 일반 사용자 등록을 시작합니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="05">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">0. 처음 > 0.5 QR코드</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/00_login03.jpg" width="200" class="vt" style="" /><br/>
									<img src="/img/manual/00_login04.jpg" width="130" class="vt mt50" style="" />
									<img src="/img/manual/00_login05.jpg" width="200" class="vt" style="margin-left: 100px;" />
									<img src="/img/manual/00_login06.jpg" width="200" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자는 출근ㆍ퇴근 구분 선택 후 QR코드 생성을 하여 사업장 출입구에 구비된 단말기의 QR코드 스캔 기능을 사용, 출근ㆍ퇴근 기록을 합니다.<br/>
										2. 관리자는 출입구에 여분의 모바일 단말기를 배치하여 사용자(직원) 출결 처리를 할 수 있게 합니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="06">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">0. 처음 > 0.6 메인</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/00_main02.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 로그인 사용자의 잔여 연차 수, OTP현황 정보 등을 보여줍니다. 회원정보수정, 로그아웃이 가능합니다.<br/>
										2. 사용자ㆍ관리자가 사용하는 메뉴 모음입니다.<br/>
										<span class="ml20">사용자 권한에 따라 메뉴 구성이 달라집니다.</span><br/>
										<span class="ml20">일반 사용자에게 [관리자],[설정정보] 메뉴는 보이지 않습니다.</span><br/>
										3. 주요 메뉴들에 대한 대시보드입니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="11">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">1. 신청정보 > 1.1 공지사항</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/01_01 공지사항.jpg" width="600" class="vt" style="" /><br/>
									<img src="/img/manual/01_01 공지사항_글쓰기.jpg" width="500" class="vt" style="margin: -200px 0 0 160px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 관리자가 사용자(직원)들에게 공지하는 내용을 나타냅니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="12">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">1. 신청정보 > 1.2 통합휴무신청</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/01_02 통합휴무신청01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자가 반차, 연차, OT포인트 사용 등 휴무관련 신청을 합니다.<br/>
										2. 휴무신청 버튼을 클릭하여 신청할 수 있습니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">1. 신청정보 > 1.2 통합휴무신청(계속)</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/01_02 통합휴무신청021.jpg" width="400" class="vt" style="" /><br/>
									<img src="/img/manual/01_02 통합휴무신청051.jpg" width="400" class="vt" style="margin: -150px 0 0 260px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 반차ㆍ연차ㆍ주휴ㆍ반주휴 선택을 합니다.<br/>
										<span class="ml20">주휴ㆍ반주휴는 토요일 근무를 대체하여 연차ㆍ반차처럼 사용하는 개념입니다.</네무><br/>
										2. 업무인계자와 담당결재자를 지정합니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="13">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">1. 신청정보 > 1.3 휴무신청현황</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/01_03 휴무신청현황01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 팀별, 상태별 조회가 가능합니다.<br/>
										2. 휴가 구분과 신청자 이름이 표시됩니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="14">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">1. 신청정보 > 1.4 OTP사용신청</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/01_04 OTP사용신청01.jpg" width="400" class="vt" style="" /><br/>
									<img src="/img/manual/01_04 OTP사용신청02.jpg" width="400" class="vt" style="margin: -150px 0 0 260px; border: #06fe1f 1px dashed;" /><br/>
									<img src="/img/manual/01_04 OTP사용신청03.jpg" width="400" class="vt" style="margin: -150px 0 0 0px; border: #06fe1f 1px dashed;" /><br/>
									<img src="/img/manual/01_04 OTP사용신청04.jpg" width="400" class="vt" style="margin: -150px 0 0 260px; border: #06fe1f 1px dashed;" /><br/>
									<img src="/img/manual/01_04 OTP사용신청05.jpg" width="400" class="vt" style="margin: -150px 0 0 0px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자가 OTP(OverTime Point) 사용을 위한 신청 기능입니다.<br/>
										2. 담당 부서장을 찾아 입력합니다.<br/>
										3. 사용할 날자를 입력합니다.<br/>
										4. 사용할 OTP 수량을 선택합니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="15">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">1. 신청정보 > 1.5 탄력근무관리</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/01_05 탄력근무관리01.jpg" width="600" class="vt" style="" /><br/>
									<img src="/img/manual/01_05 탄력근무관리03.jpg" width="400" class="vt" style="margin: -150px 0 0 260px; border: #06fe1f 1px dashed;" /><br/>
									<img src="/img/manual/01_05 탄력근무관리04.jpg" width="400" class="vt" style="margin: -100px 0 0 0px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 부서장에게만 권한이 주어지는 메뉴입니다.<br/>
										2. 부서장이 탄력근무를 적용할 일자나 주간을 선택합니다.<br/>
										<span class="ml30">예) 월요일 일괄 적용</span><br/>
										3. 근무설정을 클릭합니다.<br/>
										4. 탄력근무 적용은 동일 부서 내 복수 근무자에게 가능합니다.<br/>
										5. 탄력 근무를 적용할 시간을 설정하고 등록합니다.<br/>
										6. 결재에 의한 별도의 재가가 요구되지 않습니다. 부서장의 책임감 및 권한이 필요합니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">1. 신청정보 > 1.5 탄력근무관리(계속)</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/01_05 탄력근무관리05.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 적용된 탄력근무를 확인할 수 있습니다.<br/>
										<span class="ml30">예) 월요일 일괄 적용</span>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="21">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">2. 인사정보 > 2.1 직원목록</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/02_01 직원목록01.jpg" width="600" class="vt" style="" /><br/>
									<img src="/img/manual/02_01 직원목록02.jpg" width="500" class="vt" style="margin: -200px 0 0 160px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 현재 활동 중인 직원(사용자) 목록입니다.<br/>
										2. 사용 승인된 본인의 경우 개인정보를 수정할 수 있습니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="22">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">2. 인사정보 > 2.2 신입직원현황</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/02_02 신입직원현황01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 신입 직원 현황을 달력 형태로 보여줍니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="23">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">2. 인사정보 > 2.3 인사발령</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/02_03 인사발령01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 인사 발령 정보를 보여줍니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="24">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">2. 인사정보 > 2.4 지각현황</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/02_04 지각현황01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 직원들의 지각 정보를 보여줍니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="25">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">2. 인사정보 > 2.5 생일자현황</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/02_05 생일자현황01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 월별 생일자를 보여줍니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="31">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.1 직원관리</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_01 직원관리01.jpg" width="600" class="vt" style="" /><br/>
									<img src="/img/manual/03_01 직원관리02.jpg" width="500" class="vt" style="margin: -200px 0 0 160px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 관리자 권한에게 제공되는 직원관리 기능입니다.<br/>
										2. 사용자의 비밀번호 분실 시 비밀번호를 초기화 할 수 있습니다.<br/>
										<span class="ml20">보안상 비밀번호의 복호화는 불가합니다.</span>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.1 직원관리(계속)</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_01 직원관리03.jpg" width="500" class="vt" style="" /><br/>
									<img src="/img/manual/03_01 직원관리04.jpg" width="500" class="vt" style="margin: -100px 0 0 160px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자 개인에 대한 부가정보 관리가 가능합니다.<br/>
										2. 사용자 부가정보 관리에 따른 직원인사카드 기능이 제공됩니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="32">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.2 휴무내역표</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_02 휴무내역표01.jpg" width="600" class="vt" style="" />
									<img src="/img/manual/03_02 휴무내역표02.jpg" width="250" class="vt" style="margin: -200px 0 0 140px; border: #06fe1f 1px dashed;" />
									<img src="/img/manual/03_02 휴무내역표03.jpg" width="250" class="vt" style="margin: -358px 0 0 410px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자의 휴무 현황을 보여줍니다.<br/>
										2. 사용자의 휴가 사용일자와 내용을 볼 수 있습니다.<br/>
										3. 사용자의 지각일자와 시간을 볼 수 있습니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="33">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.3 휴무신청현황</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_03 휴무신청현황01.jpg" width="600" class="vt" style="" />
									<img src="/img/manual/03_03 휴무신청현황02.jpg" width="500" class="vt" style="margin: -200px 0 0 140px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자의 휴무신청 현황을 목록 형태로 볼 수 있습니다.<br/>
										2. 휴무신청 상세 내용을 확인할 수 있습니다.
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.3 휴무신청현황(계속)</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_03 휴무신청현황03.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자의 휴무신청 현황을 달력 형태로 볼 수 있습니다.<br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="34">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.4 OTP현황</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_04 OTP현황01.jpg" width="600" class="vt" style="" />
									<img src="/img/manual/03_04 OTP현황02.jpg" width="500" class="vt" style="margin: -200px 0 0 140px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자의 OTP 사용 현황을 보여줍니다.<br/>
										2. 관리자가 일괄적으로 OTP를 가감할 수 있습니다.<br/>
										3. OTP 상세 내역을 볼 수 있습니다.<br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="35">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.5 탄력근무현황</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_05 탄력근무현황01.jpg" width="600" class="vt" style="" />
									<img src="/img/manual/03_05 탄력근무현황03.jpg" width="500" class="vt" style="margin: -200px 0 0 140px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자의 탄력근무 신청 현황을 제공합니다.<br/>
										2. 탄력근무 적용은 동일 부서 내 복수 직원(사용자)에게 가능합니다.<br/>
										3. 탄력 근무를 적용할 시간을 설정하고 등록합니다.<br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.5 탄력근무현황(계속)</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_05 탄력근무현황02.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 사용자의 탄력근무 신청 현황을 달력 형태로 제공합니다.<br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="36">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">3. 관리자 > 3.6 OT정산</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/03_06 OTP정산02.jpg" width="500" class="vt" style="" /><br/>
									<img src="/img/manual/03_06 OTP정산03.jpg" width="60" class="vt" style="margin: 0px 0 0 100px; border: #06fe1f 1px dashed;" />
									<img src="/img/manual/03_06 OTP정산04.jpg" width="150" class="vt" style="margin: 0px 0 0 220px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 부서별 OT(초과근무) 정산 값을 제공합니다.<br/>
										2. 1열 – 기준출근시간<br/>
										<span class="ml20">2열 – 실제출근시간</span><br/>
										<span class="ml20">3열 – 기준퇴근시간</span><br/>
										<span class="ml20">4열 – 실제퇴근시간</span><br/>
										<span class="ml20">5열 – 퇴근시간 기준 초과근무시간</span><br/>
										3. 초과근무시간을 계산하고 포인트로 환산합니다.<br/>
										<span class="ml20">출력 후 당사자에게 고지, 확인 서명을 받을 수 있습니다.</span><br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="41">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">4. 설정정보 > 4.1 전체공지</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/04_01 전체공지01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 운영자가 관리자에게 전달하는 내용을 게시합니다.<br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="42">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">4. 설정정보 > 4.2 작업게시판</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/04_02 작업게시판01.jpg" width="600" class="vt" style="" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 관리자가 프로그램 사용중 불편한 점이나 개선점, 기능 등을 운영자에게 요청하고하고 피드백 받을 수 있습니다.<br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="43">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">4. 설정정보 > 4.3 출퇴근기준시간설정</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/04_03 출퇴근기준시간설정01.jpg" width="600" class="vt" style="" />
									<img src="/img/manual/04_03 출퇴근기준시간설정02.jpg" width="340" class="vt" style="margin: -230px 0 0 300px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 팀별 출퇴근 기준정보를 설정합니다.<br/>
										2. 기준시간이 변경되면 사용자들의 기존 OTP나 지각현황의 정보에 영향을 미칠 수 있습니다.<br/>
									</div>
								</td>
							</tr>

							<tr>
								<td style="height:100px;" id="44">&nbsp;</td>
							</tr>
								<td colspan=2>
									<div class="fcy">4. 설정정보 > 4.4 환경설정</div>
									<div class="ib mb30 frt"><a href="#00" class="hint--info hint--left" aria-label="처음으로">▲ TOP</a></div>
								</td>
							</tr>
							<tr>
								<td width="600" class="vt">
									<img src="/img/manual/04_04 환경설정01.jpg" width="600" class="vt" style="" /><br/>
									<img src="/img/manual/04_04 환경설정02.jpg" width="340" class="vt" style="margin: 0px 0 0 0px; border: #06fe1f 1px dashed;" />
									<img src="/img/manual/04_04 환경설정03.jpg" width="340" class="vt" style="margin: -150px 0 0 300px; border: #06fe1f 1px dashed;" />
								</td>
								<td class="vt">
									<div class="ml20" style="line-height:28px;">
										1. 관리자가 솔루션을 운영하는데 필요한 환경을 설정합니다.<br/>
										2. 기본적으로는 표준정보에 존재하는 정보를 선택하여 사용할 수 있습니다.<br/>
										3. 표준정보에 없는 단위정보는 신규등록을 신청합니다.<br/>
										<span class="ml20">그에 대한 피드백은 1~2 영업일 정도 소요됩니다.</span><br/>
										4. 주휴ㆍ반주휴 옵션 사용 여부를 설정합니다.
									</div>
								</td>
							</tr>


							<tr>
								<td style="height:200px;">&nbsp;</td>
							</tr>
						</table>
</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
