<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명 :	setPop.asp (POPUP)
'* 고객사별 부서·직급·팀 설정 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	cid							= SQLI(Request("cid"))
	dept						= SQLI(Request("dept"))				'부서
	cdSe						= SQLI(Request("code_se"))
	useYn						= SQLI(Request("useYn"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If page = "" Then page = 1

	If cdSe <> "" Then												'검색조건이 있는 경우
		param1 = " WHERE code_se = '"& cdSe &"'"
	Else															'검색조건이 없는 경우
		param1 = " WHERE 1=1"
	End If

	If useYn <> "" Then												'사용여부
		param1 = param1 &" AND use_yn = '"& useYn &"'"
	End If

	Select Case cdSe
		Case "부서" : val = "dept"
		Case "직급" : val = "ulvl"
		Case "팀" : val = "team"
	End Select

	param2 = " ORDER BY code_se, code_id "
	param = param1 & param2

	rso()
	SQL = " SELECT COUNT(*) FROM codt010 "& param1
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/20) + 1
%>

<script type="text/javascript">
$(document).ready(function(){
	$('#cdSe, #dept').change(function (){ //조회
		goSearch();
	});
	$('#useYn0,#useYn1,#useYn2').click(function (){
		goSearch();
	});

	$('#new').click(function (){
		//unoPop('setPop_w.asp','코드등록신청',420,250);
		$('#fm1').attr({action:'setNew_w.asp', method:'POST'}).submit();
	});

	$('#toRight').click(function (){
		var flag = false;
		var option = "";
		var cnt = $('#arrVal2 option').size(); //#arrVal2 item 개수
		var val1 = $('#arrVal1 option:selected').val(); //좌측 선택값

		if(val1 == undefined){
			alert("표준정보에서 적용할 값을 선택하세요.");
			return;
		}
		if(cnt == 0){
			option = "<option value="+ $('#arrVal1 option:selected').val() +">"+ $('#arrVal1 option:selected').text() +"</option>";
			flag = true;
		}

		for(var i = 0; i < cnt; i++){
			var val2 = $('#arrVal2 option:eq('+ i +')').val(); //우측 값

			if (val1 != val2){ //중복 아니면 push
				option = "<option value="+ $('#arrVal1 option:selected').val() +">"+ $('#arrVal1 option:selected').text() +"</option>";
				flag = true;
			}else{
				option = "";
				alert('이미 존재하는 항목입니다.');
				break;
			}
		}
		//console.log('__________ option = '+ option);

		if(flag) $('#arrVal2').append(option);
	});

	$('#toLeft').click(function (){
		var val2 = $('#arrVal2 option:selected').val(); //우측 선택값

		if(val2 == undefined){
			alert("현재 선택정보에서 제외할 값을 선택하세요.");
			return;
		}
		if ($("#code_se").val() == "부서") {
			alert("저장하면 선택된 부서의 모든 팀 정보가 삭제되어 복구가 불가능합니다.");
		}

		$('#arrVal2 option:selected').remove();
	});

	$('#save').click(function (){ //저장
		var dataArr = [];
		var cnt1 = $('#arrVal2 option').size(); //저장 시점의 #arrVal2 item 개수

		for(var i = 0; i < cnt1; i++){
			var opt = $('#arrVal2 option:eq('+ i +')').val();
			dataArr.push(opt);
		}

		$('#arrVal3').val(dataArr);

		$('#fm1').attr({action:'setPop_x.asp', method:'POST'}).submit();
	});

	$('#close').click(function (){
		simsClosePopup();
	});
});
function goSearch(){
	$('#page').val('1');
	$('#fm1').attr({action:'setPop.asp', method:'POST'}).submit();
}
</script>


<form name="fm1" id="fm1">
<input type="hidden" name="cid" id="cid" value="<%=cid%>" />
<input type="hidden" name="code_se" id="code_se" value="<%=cdSe%>" />
<input type="hidden" name="arrVal3" id="arrVal3" />
<div id="mainwrap3">
	<div>
		<div class="ml20 mt10"><span class="fb"><%=cdSe%>관리</span></div>
		<div class="ml20 mt10">
<%
	If val = "team" Then
%>
			<select name="dept" id="dept" style="width:230px;" class="sel3">
				<option value="">부서선택</option>
				<%=cmnCdList("부서",dept,"","1",cid)%>
			</select>
<%
	End If
%>
			<button type="button" id="new" class="btn01 frt mr20 mb5">신규등록</button>
		</div>
		<table width=100% id=list11>
			<colgroup>
				<col style="width:45%;" />
				<col width="*" />
				<col style="width:45%;" />
			</colgroup>
			<tbody>
				<tr>
					<td>표준정보</td>
					<td></td>
					<td class="mt10 mb5 ml10 hint--info hint--top" aria-label="<%=cmpInfo(cid,"comp_nm")%>">"<%=TrimText(cmpInfo(cid,"comp_nm"),8)%>" 선택정보</td>
				</tr>
				<tr>
					<td><!--
						<select name="cmpSeCd" id="cmpSeCd" class="mb5" style="width:230px;">
							<option value="00" selected>전체</option>
							<option value="10">일반</option>
							<option value="20">병원</option>
							<option value="50">연구소</option>
							<option value="99">기타</option>
						</select> -->
						<select name="arrVal1" id="arrVal1" style="width:230px;height:340px;" size=10 class="scroll-hide">
							<%=cmnCdList0(cdSe,val,"1")%>
						</select>
					</td>
					<td class="">
						<button type="button" id="toRight" class="mb5">>></button>
						<button type="button" id="toLeft" class=""><<</button>
					</td>
					<td>
						<select name="arrVal2" id="arrVal2" style="width:230px;height:340px;" size=10 class="scroll-hide">
							<%=cmnCdList(cdSe,val,dept,"1",cid)%>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="ct mt10 pb30">
<%
	If val <> "team" Or dept <> "" Then
%>
			<button type="button" id="save" class="btn02">저장</button>
<%
	End If
%>
			<button type="button" id="close">창닫기</button>
		</div>
	</div>
</div>
</form>
