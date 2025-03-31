<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: totalOffPop.asp - 휴무신청(관리자)
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	yy							= SQLI(Request("yy"))
	mm							= SQLI(Request("mm"))
	dd							= SQLI(Request("dd"))
	op2							= SQLI(Request("op2"))			'1이면 /mem/totalOff_m.asp 으로 이동

	If yy = "" Then
		Call alertClose3("변수가 없습니다. 다시 시도 하세요.")
		Response.End
	End If

	vDate = CDate(yy &"/"& mm &"/01")

	If seq <> "" Then		'수정
		rso()
		SQL = "	SELECT uid, gubn, ddate, sign1, sign3, ampm, use_day, adm_chk, handover, note " _
			& "	FROM vact010 " _
			& "	WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			uid					= rs("uid")
			gubn				= rs("gubn")
			ddate				= rs("ddate")
			sign1				= rs("sign1")
			sign3				= rs("sign3")
			ampm				= rs("ampm")
			use_day				= rs("use_day")
			adm_chk				= rs("adm_chk")		'Y/N (인사팀 확인여부)
			handover			= rs("handover")
			note				= rs("note")
		End If
		uDept = cmnCd("부서",memInfo(uid, "dept"),"code_nm","")
	Else
		uid = USER_ID
		uDept = cmnCd("부서",USER_DEPT,"code_nm","")
	End If
	rsc()
'	Response.Write "<br>uid : "& memInfo(uid, "dept") &"<br>"

	If adm_chk = "Y" Then
		da = ""		'disabled
	End If
%>

<script type="text/javascript">
$(document).ready(function(){
		$("#btnDelete").hide();
<%
	If gubn = "반차" Or gubn = "반주휴" Then
%>
		menuDiv(1);
<%
	ElseIf gubn = "연차" Or gubn = "특차" Or gubn = "주휴" Or gubn = "" Then
%>
		menuDiv(3);
<%
	End If
	If seq <> "" Then
%>
		$("#btnDelete").show();
//		makeDt();
<%
	End If
%>
});
function goSave(){
	let f = document.fm1;
	if($("#gubn1").is(':checked')==false && $("#gubn3").is(':checked')==false && $("#gubn4").is(':checked')==false && $("#gubn5").is(':checked')==false){
		alert("구분을 선택하세요.");
		return;
	}
	if($("#gubn1").is(':checked')==true || $("#gubn5").is(':checked')==true){		//반차,반주휴
		if($("#ampm1").is(':checked')==false && $("#ampm2").is(':checked')==false){
			alert("오전/오후 중 하나를 선택하세요.");
			return;
		}
		if($("#sdate01").val() == ""){
			alert("사용일을 입력하세요.");
			$("#sdate01").focus();
			return;
		}
	}
	if($("#gubn3").is(':checked')==true || $("#gubn4").is(':checked')==true){		//연차,특차,주휴
<%
	If mm = "01" Or mm = "02" Or mm = "07" Or mm = "08" Or mm = "12" Then	'성수기
%>
		var len = 1;
<%
	Else
%>
		var len = document.fm1.rowCnt.options[document.fm1.rowCnt.selectedIndex].value;
<%
	End If
%>
		if(len == 0){
			alert("기간을 꼭 선택해야 합니다.");
			return;
		}
		if($("#sdate030").val() != undefined){
			var cnt = 0;
			for (j=0; j < len; j++){
				var dd = $("#sdate03"+ j).val();
				if(dd == ""){
					alert("사용일을 빠짐없이 입력하세요.");
					return;
				}
				for (k=0; k < len; k++){
					var dk = $("#sdate03"+ k).val();
					if(j != k){
						if(dd == dk){
							alert("신청일자 중 중복된 날이 있습니다.");
							$("#sdate03"+ k).focus();
							return;
						}
					}
				}
			}

			for (j=0; j < len; j++){
				var dd = $("#sdate03"+ j).val();
				$("#sdate03"+ j +"h").val(dd);
			}

			for(i=len ; i < 7;i++){
				$("#sdate03"+ j +"h").val("");
			}
		}
	}

	if(f.handover.value == ""){
		alert("업무인계자를 입력하세요.");
		f.handover.focus();
		return;
	}
	if(f.sign3.value == ""){
		alert("담당부서장을 입력하세요.");
		f.sign3.focus();
		return;
	}
	if(f.note.value == ""){
		alert("휴가사유를 입력하세요.");
		f.note.focus();
		return;
	}
	if(confirm("입력하시겠습니까?")){
<%
	If seq <> "" Then
%>
		$("#flag").val("M");
<%
	End If
%>
		$("#fm1").attr({action:"totalOff_x.asp", method:"POST"}).submit();
	}
}
function goDelete(){			//삭제
	if(!confirm("정말 삭제하시겠습니까?")){
		return;
	}
	$("#flag").val("D");
	$("#fm1").attr({action:"totalOff_x.asp", method:"POST"}).submit();
}
function boardDIV(menu){
	if(menu == 1){
		document.getElementById("show01").style.display = "";
		document.getElementById("show03").style.display = "none";
	} else if(menu == 3){
		document.getElementById("show01").style.display = "none";
		document.getElementById("show03").style.display = "";
	}
}
function menuDiv(menu){
	if(menu == 1){
		document.getElementById("show01").style.display = "";
		document.getElementById("show03").style.display = "none";
	} else if(menu == 3){
		document.getElementById("show01").style.display = "none";
		document.getElementById("show03").style.display = "";
	}
}
</script>
<script type="text/javascript" src="/lib/ui/jquery.ui.datepicker.js"></script>
<script type="text/javascript">
var clarecalendar = {
	monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월' ],
	dayNamesMin: ['일','월','화','수','목','금','토'],
	weekHeader: 'Wk',
	dateFormat: 'yy-mm-dd',			//날짜형식 = 2013-03-29
	autoSize: false,				//자동리사이즈 (false 이면 상위 정의에 따름)
	changeMonth: true,				//월변경 가능
	changeYear: true,				//연변경 가능
	showMonthAterYear: false,		//년 위에 월 표시
	//showOn: 'both',				//엘리먼트와 이미지 동시사용 (both, button)
	//buttonImageOnly: true,		//이미지 표시
	//buttonText: '달력',			//버튼 텍스트 표시
	//buttonImage: '/images/new/icon_calendar.gif', // 이미지 주소
	yearRange: 'c-0:c+99',			//1990~2020년 까지
	maxDate: '+1Y',					//오늘 부터 1년 후까지만. +0d 오늘 이전 날짜만 선택
	minDate: '-1Y'					//30일 이전까지만 선택 가능
}
$(function(){
	$('#sdate01').datepicker(clarecalendar);
	$('#sdate030').datepicker(clarecalendar);
});
function makeDt(){		//추가일자 layer
	let len = document.fm1.rowCnt.options[document.fm1.rowCnt.selectedIndex].value;
	txtbox = " ";

	for (i=0; i<len; i++){
		txtbox = txtbox + "<input type=\"text\" name=\"sdate03\" id=\"sdate03"+ i +"\" style=\"width:120px;\" class=\"ct pt\" maxlength=\"10\" "
			+ "onchange=\"chkDt(this.value, 'sdate03"+ i +"')\" placeholder=\"날짜선택\" readonly />&nbsp;"
	}

	document.getElementById("makeDtLayer").innerHTML = txtbox;
	$("#makeDtLayer").html(txtbox);

	setDate(len);
}
function setDate(len){
	for (j=0; j<len; j++){
		$("#sdate03"+ j).datepicker(clarecalendar);
	}
}
function chkDt(dt, opt){
	let cnt = 0;
	let len = document.fm1.rowCnt.options[document.fm1.rowCnt.selectedIndex].value;
	for(var i=0; i < len; i++){
		for(var j=0; j < len; j++){
			if(i != j){
				var val = $("#sdate03"+ i).val();
//				console.log("_____"+ val);
				if(val != "" && val == $("#sdate03"+ j).val()){
					cnt++;
				}
			}
		}
	}

	if(cnt > 0){
		alert("중복되는 휴무일이 존재합니다.");
		return;
	}else{		//동일 팀에서 같은 일자 휴무 제한
		let lmtCnt = "0";
		$.ajax({
			url: "/sys/chkOff.asp",
			type: "POST",
			data: {
				dt : dt,
				busy : "0"
			},
			dataType: "text",
			success: function(data){
				let dataArr = [];
				dataArr = data.split(",");
				console.log("chkDt ________"+ dataArr[0]);
				console.log("chkDt ________"+ dataArr[1]);
				if("<%=USER_TEAM%>" == "110" || "<%=USER_TEAM%>" == "115") lmtCnt = "1";	//눈,코 2명까지 허용
				if("<%=USER_TEAM%>" == "140") lmtCnt = "100";	//마취 제외
				if(dataArr[0] > lmtCnt){		//제한 인원보다 크면
					alert("해당 일자에 먼저 신청한 분이 계십니다.\n다른 날을 선택하세요.");
					$("#"+ opt).val("");
//					$("#"+ opt).focus();
					return;
				}
			}
		});
	}
}
function chkDt3(dt){	//반차, 반주휴 - 원장별 월 휴무 2일까지만 허용
		let lmtCnt = "0";
		$.ajax({
			url: "/sys/chkOff.asp",
			type: "POST",
			data: {
				dt : dt,
				mm : "<%=mm%>",
				busy : "1"
			},
			dataType: "text",
			success: function(data){
				let dataArr = [];
				dataArr = data.split(",");
				console.log("chkDt3 ________"+ dataArr[0]);
				console.log("chkDt3 ________"+ dataArr[1]);
				if("<%=USER_TEAM%>" == "110" || "<%=USER_TEAM%>" == "115") lmtCnt = "1";	//눈,코 2명까지 허용
				if("<%=USER_TEAM%>" == "140") lmtCnt = "100";	//마취 제외
				if(dataArr[0] > lmtCnt){	//팀 휴무 제한 인원보다 크면
					alert("해당 일자에 먼저 신청한 분이 계십니다.\n다른 날을 선택하세요.");
					$("#sdate01").val("");
					return;
				}
				if(dataArr[1] > 1){		//개인 월별 휴무 제한(2일)보다 크면
					alert("성수기에는 해당 월 휴무 2회까지만 가능합니다.\n인사팀에 문의하세요.");
					simsClosePopup();
				}
			}
		});
}
function chkDt5(dt){	//하루만 적용 (성수기) - 원장별 월 휴무 2일까지만 허용
		let lmtCnt = "0";
		$.ajax({
			url: "/sys/chkOff.asp",
			type: "POST",
			data: {
				dt : dt,
				mm : "<%=mm%>",
				busy : "1"
			},
			dataType: "text",
			success: function(data){
				let dataArr = [];
				dataArr = data.split(",");
				console.log("chkDt5 ________"+ dataArr[0]);
				console.log("chkDt5 ________"+ dataArr[1]);
				if("<%=USER_TEAM%>" == "110" || "<%=USER_TEAM%>" == "115") lmtCnt = "1";	//눈,코 2명까지 허용
				if("<%=USER_TEAM%>" == "140") lmtCnt = "100";	//마취 제외
				if(dataArr[0] > lmtCnt){	//팀 휴무 제한 인원보다 크면
					alert("해당 일자에 먼저 신청한 분이 계십니다.\n다른 날을 선택하세요.");
					$("#sdate030").val("");
					return;
				}
				if(dataArr[1] > 1){		//개인 월별 휴무 제한(2일)보다 크면
					alert("성수기에는 해당 월 휴무 2회까지만 가능합니다.\n인사팀에 문의하세요.");
//					$("#sdate030").val("");
					simsClosePopup();
				}
			}
		});
}
function callBack01(val, opt){	//callBack01
	if(opt == "S"){
		var dataArr = [];
		dataArr = val.split(":");
		$("#handover").val(dataArr[1]);
	}else{
	}
}
function callBack02(val, opt){	//callBack02
	if(opt == "S"){
		var dataArr = [];
		dataArr = val.split(":");
		$("#sign3").val(dataArr[0]);
		$("#sign3Nm").val(dataArr[1]);
	}else{
	}
}
</script>


<form name="fm1" id="fm1" method="post">
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
<input type="hidden" name="seq" id="seq" value="<%=seq%>" />
<input type="hidden" name="flag" id="flag" /><!-- 등록,수정,삭제,재가 구분 -->
<input type="hidden" name="op2" id="op2" value="<%=op2%>" /><!-- 1이면 /mem/totalOff_m.asp 으로 이동 -->
<div>
	<div class="mt20">
		<table width=100% id="list2">
			<colgroup>
				<col style="width:150px;" />
				<col /><!-- 제목 -->
			</colgroup>
			<!--
			<thead>
				<tr style="height:30px;">
					<th class="">번호</th>
					<th class="">제목</th>
				</tr>
			</thead>
			//-->
			<tbody>
				<tr height=40>
					<th>이름</th>
					<td><%=memInfo(uid, "unm")%></td>
				</tr>
				<tr height=40>
					<th>부서</th>
					<td><%=uDept%></td>
				</tr>
				<tr height=40>
					<th>휴무구분</th>
					<td>
						<input type="radio" name="gubn" id="gubn1" value="반차" <%If gubn = "반차" Then%>checked<%End If%> onclick="boardDIV(1);" class="vm" <%=da%> />
						<label for="gubn1">반차</label>
						<input type="radio" name="gubn" id="gubn3" value="연차" <%If gubn = "연차" Or gubn = "" Then%>checked<%End If%> onclick="boardDIV(3);" class="vm" <%=da%> />
						<label for="gubn3">연차</label>
<%
	If cmpInfo(USER_COMP, "juhu_yn") = "Y" Then
%>
						<input type="radio" name="gubn" id="gubn4" value="주휴" <%If gubn = "주휴" Then%>checked<%End If%> onclick="boardDIV(3);" class="vm" <%=da%> />
						<label for="gubn4">주휴</label>
						<input type="radio" name="gubn" id="gubn5" value="반주휴" <%If gubn = "반주휴" Then%>checked<%End If%> onclick="boardDIV(1);" class="vm" <%=da%> />
						<label for="gubn5">반주휴</label>
<%
	End If
%>
					</td>
				</tr>
				<tr>
					<th>적용일자</th>
					<td>
						<div id="show01" style="display:none;"><!-- 반차/반주휴 -->
							<div>
								<input type="radio" name="ampm" id="ampm1" value="오전"<%If ampm = "오전" Then%> checked<%End If%> class="vm" />
								<label for="ampm1">오전</label>
								<input type="radio" name="ampm" id="ampm2" value="오후"<%If ampm = "오후" Then%> checked<%End If%> class="vm" />
								<label for="ampm2">오후</label>
								&nbsp;&nbsp;&nbsp;
								해당일자<font style="color:#55aa00;">(필수)</font>
<%
	If seq <> "" Then
		rso()
		SQL = "	SELECT idx, vdate FROM vact011 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
%>
								<input type="text" name="sdate01" id="sdate01" value="<%=rs("vdate")%>" style="width:150px;" class="ct pt" maxlength="10" onchange="chkDt3(this.value, 'sdate01')" readonly />
<%
		End If
		rsc()
	Else
%>
								<input type="text" name="sdate01" id="sdate01" value="" style="width:150px;" class="ct pt" maxlength="10" onchange="chkDt3(this.value, 'sdate01')" readonly />
<%
	End If
%>
							</div>
						</div>
						<div id="show03" style="display:none;"><!-- 연차/주휴 -->
							<div class="mt5 mb5">
<%
	If mm = "01" Or mm = "02" Or mm = "07" Or mm = "08" Or mm = "12" Then	'성수기
%>
								<input type=hidden name="rowCnt" id="rowCnt" value=1 />
								<input type="text" name="sdate03" id="sdate030" style="width:120px;" class="ct pt" maxlength="10" onchange="chkDt5(this.value, 'sdate030')" placeholder="날짜선택" readonly />
<%
	Else	'비수기
%>
								<select name="rowCnt" id="rowCnt" onchange="makeDt();" style="width:80px;" <%=da%>>
									<option value="" selected>선택</option>
									<option value="1"<%If use_day = 1 Then%> selected<%End If%>>하루</option>
									<option value="2"<%If use_day = 2 Then%> selected<%End If%>>2 일</option>
									<option value="3"<%If use_day = 3 Then%> selected<%End If%>>3 일</option>
									<option value="4"<%If use_day = 4 Then%> selected<%End If%>>4 일</option>
									<option value="5"<%If use_day = 5 Then%> selected<%End If%>>5 일</option>
								</select>
								<span class="se ml20">※ 일요일/공휴일을 제외한 휴가일수를 선택하세요.</span>
								<div id="makeDtLayer" class="mt5 mb5"></div>
<%
	End If
	If seq <> "" Then
		cntt = 0
		rso()
		SQL = "	SELECT idx, vdate FROM vact011 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			While Not rs.eof
%>
								<input type="text" name="sdate03" id="sdate03<%=cntt%>" value="<%=rs("vdate")%>" style="width:120px;" class="ct pt" maxlength="10" placeholder="날짜선택" readonly />
<%
				cntt = cntt + 1
				rs.MoveNext
			Wend
		End If
		rsc()
	End If
%>
							</div>
						</div>
					</td>
				</tr>
				<tr height=40>
					<th>업무인계자</th>
					<td>
						<input type="text" name="handover" id="handover" value="<%=handover%>" style="width:180px;" class="ct" <%=da%> onclick="unoPop('/sys/sancPop.asp?opt=S&callBack=01','업무인계자 선택','500','500');" />
						<button type="button" id=btnSelect onclick="unoPop('/sys/sancPop.asp?opt=S&callBack=01','업무인계자 선택','500','500');">선택</button>
					</td>
				</tr>
				<tr height=40>
					<th>담당부서장</th>
					<td>
<%
	If seq = "" Then
%>
						<input type="text" name="sign3Nm" id="sign3Nm" style="width:180px;" class="ct" readonly onclick="unoPop('/sys/sancPop.asp?opt=S&callBack=02','담당부서장 선택','500','500');">
<%
	Else
		If Right(sign3,3) = "gif" Then		'수정일때 서명이 되어 있는 경우
%>
						결재완료
<%
		Else								'서명이 안된 경우
%>
						<input type="text" name="sign3Nm" id="sign3Nm" value="<%=memInfo(sign3,"unm")%>" readonly style="width:180px;" class="ct">
<%
		End If
	End If
%>
						<button type="button" id=btnSelect onclick="unoPop('/sys/sancPop.asp?opt=S&callBack=02','담당부서장 선택','500','500');">선택</button>
						<input type="hidden" name="sign3" id="sign3" value="<%=sign3%>" />
					</td>
				</tr>
				<tr height=40>
					<th>인사팀장</th>
					<td>
<%
	If seq = "" Then
%>
						<input type="text" name="sign1" style="width:180px;" class="ct" readonly value="인사팀장" />
<%
	Else
		If Right(sign1,3) = "gif" Then		'수정일때 서명이 되어 있는 경우
%>
						결재완료
<%
		Else								'서명이 안된 경우
%>
						<input type="text" name="sign1" value="<%=sign1%>" readonly style="width:180px;" class="ct">
<%
		End If
	End If
%>
					</td>
				</tr>
				<tr height=40>
					<th>사유</th>
					<td><input type="text" name="note" value="<%=note%>" style="width:90%;" <%=da%> /></td>
				</tr>
			</tbody>
		</table>
		<div class="ct mt10">
<%
	If adm_chk <> "Y" Then		'인사팀장 재가 전
%>
			<button type="button" id=btnSave onclick="goSave();" class="btn02">신청</button>
			<button type="button" id=btnDelete onclick="goDelete();" class="btn01">삭제</button>
<%
	End If
%>
			<button type="button" id=btnClose onclick="simsClosePopup();">창닫기</button>
		</div>
	</div>
</div>
</form>
</body>
</html>
<%	dbc() %>
