<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: mngDeptPop.asp - 고객별 부서코드 관리 (POPUP)
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	code_se						= SQLI(Request("code_se"))
	useYn						= SQLI(Request("useYn"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If page = "" Then page = 1

	If code_se <> "" Then					'검색조건이 있는 경우
		param1 = " WHERE code_se = '"& code_se &"'"
	Else								'검색조건이 없는 경우
		param1 = " WHERE 1=1"
	End If

	If useYn <> "" Then					'사용여부
		param1 = param1 &" AND use_yn = '"& useYn &"'"
	End If

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
	var cnt0 = $('#pDept2 option').size();				//최초 #pDept2 item 개수

	$('#code_se').change(function (){					//조회
		goSearch();
	});
	$('#useYn0,#useYn1,#useYn2').click(function (){
		goSearch();
	});
	$('#toRight').click(function (){
		var option = "<option value="+ $('#pDept1 option:selected').val() +">"+ $('#pDept1 option:selected').text() +"</option>";
		$('#pDept2').append(option);
	});
	$('#toLeft').click(function (){
		var option = "<option value="+ $('#pDept2 option:selected').val() +">"+ $('#pDept2 option:selected').text() +"</option>";
		$('#pDept1').append(option);
	});
	$('#new').click(function (){
		unoPop('mngCd_w.asp','코드등록신청',420,250);
	});
	$('#save').click(function (){
		var cnt1 = $('#pDept2 option').size();			//저장 시점의 #pDept2 item 개수
		console.log('__________ cnt0 = '+ cnt0 +'_____ cnt1 = '+ cnt1);
		if(confirm('저장할깝쇼?')){
//			$('#fm1').attr({action:'mngPop_x.asp', method:'POST'}).submit();
		} else {
			return;
		}
	});
	$('#close').click(function (){
		simsClosePopup();
	});
});
function goSearch(){
	$('#page').val('1');
	$('#fm1').attr({action:'mngDeptPop.asp', method:'POST'}).submit();
}
</script>


<form name="fm1" id="fm1">
<input type="hidden" name="opt" id="opt" value="dept" />

<div id="mainwrap3">
	<div>
		<table width=100% id=list10>
			<colgroup>
				<col style="width:45%;" />
				<col width="*" />
				<col style="width:45%;" />
			</colgroup>
			<tbody>
				<tr>
					<td>표준부서</td>
					<td class=""></td>
					<td>선택부서</td>
				</tr>
				<tr>
					<td>
						<select name="pDept1" id="pDept1" style="width:200px;height:200px;" size=10>
							<%=cmnCdList("", "부서", dept)%>
						</select>
					</td>
					<td class="">
						<button type="button" id="toRight" class="mb5">>></button>
						<button type="button" id="toLeft" class=""><<</button>
					</td>
					<td>
						<select name="pDept2" id="pDept2" style="width:200px;height:200px;" size=10>
							<%=cmnCdList(USER_COMP, "부서", dept)%>
						</select>
					</td>
				</tr>
			</tbody>
		</table>
		<!-- <div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, "code_se="& code_se &"&useYn="& useYn)%></div> -->
		<div class="ct mt10 pb50">
			<!--
			<select name="cd1" id="cd1" style="width:150px;">
				<option value="" <%If cd1 = "" Then%>selected<%End If%>>선택</option>
				<option value="unm" <%If cd1 = "unm" Then%>selected<%End If%>>이름검색</option>
				<option value="uid" <%If cd1 = "uid" Then%>selected<%End If%>>ID검색</option>
				<option value="hp" <%If cd1 = "hp" Then%>selected<%End If%>>휴대전화검색</option>
			</select>
			<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" onkeydown="writeKeyDown();" />
			<button type="button" onclick="goSearch();">조회</button>
			<button type="button" onclick="location='mem_a.asp'">새로고침</button>
			//-->
			<button type="button" id="new" class="btn01">신규등록신청</button>
			<button type="button" id="save" class="btn02">저장</button>
			<button type="button" id="close">창닫기</button>
		</div>
	</div>
</div>
</form>
