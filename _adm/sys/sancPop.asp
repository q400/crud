<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: sancPop.asp - 결재대상선택
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	opt							= SQLI(Request("opt"))			'S-단일선택 / M-다중선택
	dept						= SQLI(Request("dept"))			'소속부서
	team						= SQLI(Request("team"))			'소속팀
	scNm						= SQLI(Request("scNm"))
	cb							= SQLI(Request("callBack"))		'01,02,03...

	If dept = "" Then dept = USER_DEPT
	If team = "" Then team = USER_TEAM
	If team = "99" Then				'전체조회 -> 이름 필수 입력
			param = "AND unm LIKE '%"& scNm &"%'"
	Else
		If scNm = "" Then			'부서조회
			param = "AND team = '"& team &"'"
		Else						'부서+이름조회
			param = "AND team = '"& team &"' AND unm LIKE '%"& scNm &"%'"
		End If
	End If

	param = param &" AND open_yn = 'Y' "
'	Response.Write "param : "& param &"<br>"
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#scNm").focus();

	if($("#team").val() == "99"){		//전체조회 -> 이름 필수 입력
		if($("#scNm").val() == ""){		//이름 미입력
			$("#btnSave").hide();
		}
	}
	$("#btnSave").show();
<%
	If opt = "S" Then			'단일선택
%>
	$("input[name='chk']").click(function (){		//저장
		setValue($("input[name=chk]:checked").val());
	});
<%
	End If
%>
});
function goSearch(){
	if($("#team").val() == "99"){		//전체조회 -> 이름 필수 입력
		if($("#scNm").val() == ""){
			alert("찾을 사람을 입력하여 주세요.");
			$("#scNm").focus();
//			$("#list2 > tbody > tr > td").empty();
			$("#list2 > tbody").html("<tr height=100><td colspan=5 class='ct vm'>찾을 사람의 이름을 한 글자 이상 입력하세요.</td></tr>");
			$("#btnSave").hide();
			return;
		}
	}
	$("#fm1").attr({action:"sancPop.asp", method:"post"}).submit();
}
function setSanc(){
	let arrVal = [];	//배열값
<%
	If opt = "S" Then			'단일선택
		If cb = "01" Then
%>
	if($("input[name=chk]:checked").length == 1){
		parent.callBack01($("input[name=chk]:checked").val(), "<%=opt%>");
	}else if($("input[name=chk]:checked").length == 0){
		alert("최소 1명을 선택해야 합니다.");
		return;
	}else{
		alert("1명만 선택 가능합니다.");
		return;
	}
<%
		ElseIf cb = "02" Then
%>
	if($("input[name=chk]:checked").length == 1){
		parent.callBack02($("input[name=chk]:checked").val(), "<%=opt%>");
//		parent.$("#sign3").val($("input[name=chk]:checked").val());
	}else if($("input[name=chk]:checked").length == 0){
		alert("최소 1명을 선택해야 합니다.");
		return;
	}else{
		alert("1명만 선택 가능합니다.");
		return;
	}
<%
		End If
	Else		'다중선택
%>
	if($("input[name=chk]:checked").length >= 1){
		$("input:checkbox[name='chk']:checked").each(function(e){
			let value = $("input:checkbox[name='chk']:checked").eq(e).val();	//선택요소
			arrVal.push(value);
		})
		parent.callBack(arrVal);
	}else if($("input[name=chk]:checked").length == 0){
		alert("최소 1명을 선택해야 합니다.");
		return;
	}
<%
	End If
%>
	simsClosePopup();
}
function setValue(v){
<%
	If cb = "01" Then
%>
	parent.callBack01(v+"", "<%=opt%>");
<%
	ElseIf cb = "02" Then
%>
	parent.callBack02(v+"", "<%=opt%>");
<%
	End If
%>
	simsClosePopup();
}
</script>


<form name=fm1 id=fm1 method="post">
<input type="hidden" name="opt" id="opt" value="<%=opt%>" />
<input type="hidden" name="callBack" id="callBack" value="<%=cb%>" />
<table width=100% align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="ct">
			<div class="mt20 mb10 vm">
				<select name="team" id="team" style="width:150px;" onchange="goSearch();">
					<option value="99" <%If team = "99" Then%>selected<%End If%>>전체</option>
<%
			rso()
			SQL = "	SELECT idx, code_nm FROM codt010 WHERE gubn = '팀' ORDER BY idx ASC "
			rs.open SQL, dbcon, 3
			Do Until rs.eof
%>
					<option value="<%=rs("idx")%>" <%If CStr(rs("idx")) = CStr(team) Then%>selected<%End If%>><%=rs("code_nm")%></option>
<%
				rs.MoveNext
			Loop
			rsc()
%>
				</select>
				<input type="text" size="10" name="scNm" id="scNm" value="<%=scNm%>" class="" />
				<button type="button" id=btnSearch onclick="goSearch();" class="btn01">조회</button>
				<button type="button" id=btnClose onclick="simsClosePopup();">창닫기</button>
			</div>
		</td>
	</tr>
	<tr>
		<td class="vt pl10 pr10">
			<table width=100% id="list1">
				<colgroup>
					<col style="width:7%;" />
					<col style="width:23%;" />
					<col /><!-- 아이디 -->
					<col style="width:30%;" />
				</colgroup>
				<thead>
					<tr style="height:30px;">
						<th></th>
						<th>이름</th>
						<th>아이디</th>
						<th>직급</th>
					</tr>
				</thead>
				<tbody>
<%
		rso()
		SQL = "	SELECT * "_
			& " FROM memt010 "_
			& " WHERE 1=1 "_
			& param _
			& " ORDER BY unm ASC "
'		Response.Write "<br>"& SQL &"<br>"
		rs.open SQL, dbcon, 3

		i = 1
		If rs.Recordcount >= 1 Then
'			If opt = "S" Then
				While Not rs.eof
%>
					<tr>
						<td>
							<input type="checkbox" name="chk" id="chk<%=i%>" value="<%=rs("uid")%>:<%=rs("unm")%>">
						</td>
						<td><label for="chk<%=i%>"><%=rs("unm")%></label></td>
						<td><label for="chk<%=i%>"><%=rs("uid")%></label></td>
						<td><label for="chk<%=i%>"><%=cmnCode("직급",rs("ulvl"))%></label></td>
					</tr>
<%
					i = i + 1
					rs.MoveNext
				Wend
'			End If
		Else
%>
					<tr height=50>
						<td colspan=5 class="ct vm">찾는 사람이 없습니다.</td>
					</tr>
<%
		End If
		rsc()
%>
					<!--
					<tr height=50>
						<td colspan=5 class="ct vm">찾을 사람의 이름을 입력하세요.</td>
					</tr>
					-->
				</tbody>
			</table>
			<div class="mt20 mb50 ct vm">
				<button type="button" id=btnSave onclick="setSanc();" class="btn02">적용</button>
			</div>
		</td>
	</tr>
</table>
</form>
<%
	dbc()
%>