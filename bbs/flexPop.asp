<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: flexPop.asp - 탄력근무 등록
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	idx							= SQLI(Request("idx"))
	vdt							= SQLI(Request("vdt"))
	opt							= SQLI(Request("opt"))
'	Response.Write "opt : "& opt &"<br>"

	arrChk = Split(vdt, ",")

	If vdt = "" Then
		Call alertClose5("유효한 선택일자가 없습니다.")
		Response.End
	End If

	If opt = "" Then opt = "W"

	If seq <> "" Then		'수정
		opt = "M"
		rso()
		SQL = "	SELECT x.uid, x.sign1, x.sign3, x.adm_chk " _
			& "	FROM vact010 x " _
			& "	WHERE x.seq = "& seq
'		Response.Write "<br>SQL : "& SQL &"<br>"
		rs.open SQL, dbcon
		If Not rs.eof Then
			uid				= rs("uid")
			sign1				= rs("sign1")
			sign3				= rs("sign3")
			adm_chk				= rs("adm_chk")				'Y/N (인사팀 확인여부)
		End If
		rsc()
		rso()
		SQL = "	SELECT stime, etime " _
			& "	FROM vact011 y " _
			& "	WHERE y.seq = "& seq _
			& "	AND y.idx = "& idx
		rs.open SQL, dbcon
		If Not rs.eof Then
			stime				= rs("stime")				'탄력근무시작시간 코드
			etime				= rs("etime")				'탄력근무종료시간 코드
		End If
		rsc()
		uDept = cmnCd1("부서",memInfo(uid, "dept"),"")
		nmList = uid +":"+ memInfo(uid, "unm")				'해당자 목록
	Else		'신규입력
		uid = USER_ID
		sign3 = ""
		uDept = cmnCd("부서",USER_DEPT,"","")
		nmList = ""											'해당자 목록
	End If

	stime0 = cmnCd2(USER_TEAM, "opt1")		'cmnTm(memInfo(uid, "team"), "opt1")		'소속 팀의 기준출근시간 CODE 가져오기
	etime0 = cmnCd2(USER_TEAM, "opt2")		'cmnTm(memInfo(uid, "team"), "opt2")		'소속 팀의 기준퇴근시간 CODE 가져오기

	If stime = "" Then
		stime = stime0
	End If
'	Response.Write "stime0 : "& stime0 &"<br>"

	If etime = "" Then
		etime = etime0
	End If

	If adm_chk = "Y" Then
		da = "disabled"
	End If
'	Response.Write "<br>uid : "& uid &"<br>"
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSearch,#ids").click(function (){		//직원찾기
		unoPop('/sys/sancPop.asp?opt=M','직원찾기','500','600');
	});
//	$("#btnSearch,#xname,#xid").click(function (){		//직원찾기
//		unoPop('/sys/sancPop.asp?opt=S&callBack=01','직원찾기','500','600');
//	});
	$("#sign3Nm").click(function (){		//부서장찾기
		unoPop('/sys/sancPop.asp?opt=S&callBack=02','직원찾기','500','600');
	});
	$("#stime").change(function (){			//탄력근무시간변경
		let inx = $("#stime option:selected").index() + 18;
		$("#etime option:eq("+ inx +")").attr("selected", "selected");
//		console.log("inx ________"+ inx);
	});
	$("#btnSave").click(function (){		//저장
		if($("#opt").val() == "M"){
			msg = "수정합니까?";
		}else{
			msg = "등록합니까?";
		}
		if($("#sign3").val() == ""){
			alert("담당부서장을 입력하세요.");
			$("#sign3").focus();
			return;
		}
		if(confirm(msg)){
//			alert($("#opt").val());
			$("#fm1").attr({action:"flex_x.asp", method:"post"}).submit();
		}
	});
	$("#btnDelete").click(function (){		//삭제
		if(!confirm("정말 삭제하시겠습니까?")){
			return;
		}
		$("#opt").val("D");
		$("#fm1").attr({action:"flex_x.asp", method:"post"}).submit();
	});
	$("#btnClose").click(function (){		//닫기
		simsClosePopup();
	});
});
function callBack(val){		//callBack
	let val0 = val + "";
	console.log("val0 = "+ val0);
//	let val2 = val0.replaceAll(",", "\n");
	$("#ids").val(val0);
}
function callBack01(val, opt){		//callBack 01
	var dataArr = [];
	dataArr = val.split(":");
	$("#xid").val(dataArr[0]);
	$("#xname").val(dataArr[1]);
}
function callBack02(val, opt){		//callBack 02
	var dataArr = [];
	dataArr = val.split(":");
	$("#sign3").val(dataArr[0]);
	$("#sign3Nm").val(dataArr[1]);
}
function menudiv(menu){
	if(menu == 1){
		document.getElementById("show01").style.display = "";
		document.getElementById("show03").style.display = "none";
	}else if(menu == 3){
		document.getElementById("show01").style.display = "none";
		document.getElementById("show03").style.display = "";
	}
}
</script>


<form name="fm1" id="fm1" method="post">
<input type="hidden" name="seq" id="seq" value="<%=seq%>" />
<input type="hidden" name="idx" id="idx" value="<%=idx%>" />
<input type="hidden" name="opt" id="opt" value="<%=opt%>" /><!-- 등록,수정,삭제,재가 구분 -->
<div>
	<div class="mt10 ml5">
		<!-- <span>선택한 일자 중 <b class="fcy">과거</b> 일자는 제외합니다.</span> -->
	</div>
	<div class="mt10">
		<table width=100% id="list2">
			<colgroup>
				<col style="width:160px;" />
				<col /><!-- 제목 -->
			</colgroup>
			<tbody>
				<tr height="24">
					<th>해당부서</th>
					<td><%=uDept%></td>
				</tr>
				<tr height="24">
					<th>근무자선택</th>
					<td>
						<textarea name="ids" id="ids" class="vm" style="width:80%;height:100px;"><%=nmList%></textarea>
						<!--
						<input type="text" name="xname" id="xname" style="width:150px;" value="<%=memInfo(uid, "unm")%>" readonly />
						<input type="text" name="xid" id="xid" style="width:150px;" value="<%=uid%>" readonly />
						-->
						<button type="button" id=btnSearch class="vm">찾기</button>
					</td>
				</tr>
				<tr>
					<th>적용일자</th>
					<td>
<%
	For i = LBound(arrChk) To UBound(arrChk)
		If Weekday(arrChk(i)) = 1 Or Weekday(arrChk(i)) = 7 Then flag = flag + 1
		Select Case Weekday(arrChk(i))
			Case "1" : yoil = "(일)"
			Case "2" : yoil = "(월)"
			Case "3" : yoil = "(화)"
			Case "4" : yoil = "(수)"
			Case "5" : yoil = "(목)"
			Case "6" : yoil = "(금)"
			Case "7" : yoil = "<font color='red'>(토)</font>"
			Case Else : yoil = ""
		End Select
%>
						<div><input type="text" name="vdt" id="vdt" value="<%=arrChk(i)%>" style="width:150px;" class="ct pt sel5" maxlength="10" readonly /> <%=yoil%></div>
<%
	Next
%>
					</td>
				</tr>
				<tr>
					<th>기준근무시간</th>
					<td>
						<select name="stime0" id="stime0" style="width:100px;" disabled>
							<%=cmnCdList0("시간",stime0,"")%>
						</select>
						~
						<select name="etime0" id="etime0" style="width:100px;" disabled>
							<%=cmnCdList0("시간",etime0,"")%>
						</select>
					</td>
				</tr>
				<tr>
					<th>적용근무시간</th>
					<td>
						<input type="text" name="stime" id="opt1" placeholder="시간선택" class="timepicker sel3" style="width:93px;" value="<%=Left(stime,2) &":"& Right(stime,2)%>" />
						~
						<input type="text" name="etime" id="opt2" placeholder="시간선택" class="timepicker sel3" style="width:96px;" value="<%=Left(etime,2) &":"& Right(etime,2)%>" />
					</td>
				</tr>
				<tr>
					<th>담당부서장</th>
					<td>
						<input type="hidden" name="sign3" id="sign3" value="<%=sign3%>" />
<%
	If seq = "" Then
%>
						<input type="text" name="sign3Nm" id="sign3Nm" value="<%=memInfo(sign3,"unm")%>" readonly style="width:150px;" class="ct">
						<!-- <input type="text" name="sign3Nm" style="width:100px;" class="ct" readonly onclick="unoPop('vaca_pop.asp?gubn=S','결재대상선택','320','300');"> -->
<%
	Else
		If Right(sign3,3) = "gif" Then		'수정일때 서명이 되어 있는 경우
%>
						결재완료
<%
		Else								'서명이 안된 경우
%>
						<input type="text" name="sign3Nm" value="<%=memInfo(sign3,"unm")%>" readonly style="width:150px;" class="ct">
<%
		End If
	End If
%>
					</td>
				</tr>
				<tr>
					<th>인사팀장</th>
					<td>
<%
	If seq = "" Then
%>
						<input type="text" name="sign1" style="width:150px;" class="ct" readonly value="인사팀장" />
<%
	Else
		If Right(sign1,3) = "gif" Then		'수정일때 서명이 되어 있는 경우
%>
						결재완료
<%
		Else								'서명이 안된 경우
%>
						<input type="text" name="sign1" value="<%=sign1%>" readonly style="width:150px;" class="ct">
<%
		End If
	End If
%>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="ct mt10">
<%
'	If adm_chk <> "Y" Then		'인사팀장 재가 전
%>
			<button type="button" id=btnSave class="btn03">등록</button>
<%
		If seq <> "" Then	'수정
%>
			<button type="button" id=btnDelete class="btn01">삭제</button>
<%
		End If
'	End If
%>
			<button type="button" id=btnClose class="">창닫기</button>
		</div>
	</div>
</div>
</form>
</body>
</html>
<%	dbc() %>
