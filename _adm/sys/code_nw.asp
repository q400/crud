<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: code_nw.asp - 표준코드 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))
	flag						= SQLI(Request("flag"))

	If seq <> "" Then
		rso()
		SQL = "SELECT * FROM codt040 WHERE seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cid					= rs("cid")
			cnm					= cmpInfo(rs("cid"), "comp_nm")
			cdSe				= rs("code_se")
			cdNm				= rs("code_nm")
			okYn				= rs("ok_yn")
			wdate				= rs("wdate")
			pdate				= rs("pdate")
		End If
		rsc()

		Select Case cdSe
			Case "부서" : val = "AD"
			Case "팀" : val = "AG"
			Case "직급" : val = "AJ"
		End Select

		rso()
		SQL = "SELECT RIGHT(MAX(code_id), 4) + 5 FROM codt010 WHERE code_se = '"& cdSe &"' AND RIGHT(code_id, 4) <> '9990'"
		rs.open SQL, dbcon
		If Not rs.eof Then
			maxCd				= val & rs(0)
		End If
		rsc()
	End If
	'부서 AD / 팀 AG / 직급 AJ
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#opt1").change(function (){		//출근시간변경
		alert($("#opt1 option:selected").index());
	});
});
function goSave(){
	$("#flag").val("W");
//	console.log("_________ " + $('#okYn1').is(':checked'));
//	if($('#okYn1').is(':checked') == true){		//승인
		if($("#code_se").val() == ""){
			alert("구분을 입력하세요.");
			$("#code_se").focus();
			return;
		}else if($("#code_nm").val() == ""){
			alert("코드 이름을 입력하세요.");
			$("#code_nm").focus();
			return;
		}else{
			$("#fm1").attr({action:"code_nx.asp", method:"POST"}).submit();
		}
//	}else{		//미승인
//		if(confirm("변경사항이 없습니다.")){
//			simsClosePopup();
//		}
//	}
}
function goDelete(){
	if(confirm("선택 사항을 삭제할까요?")){
		$("#flag").val("D");
		$("#fm1").attr({action:"code_nx.asp", method:"POST"}).submit();
	}
}
</script>
</head>


<form name="fm1" id="fm1">
<input type="hidden" name="seq" id="seq" value="<%=seq%>" />
<input type="hidden" name="flag" id="flag" value="" />
<div id="mainwrap3">
	<div class="mt10">
		<table width=100% id="list1">
			<colgroup>
				<col style="width:120px;" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr>
					<td>구분</td>
					<td class="lf"><input type="text" name="code_se" id="code_se" value="<%=cdSe%>" style="width:200px;" <%If flag <> "N" Then%>readonly<%End If%> /></td>
				</tr>
				<tr>
					<td>코드값</td>
					<td class="lf"><input type="text" name="code_id" id="code_id" value="<%=maxCd%>" maxlength="6" style="width:100px;" class="sel5" <%If flag <> "N" Then%>readonly<%End If%> /></td>
				</tr>
				<tr>
					<td>코드이름</td>
					<td class="lf"><input type="text" name="code_nm" id="code_nm" value="<%=cdNm%>" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>승인여부</td>
					<td class="lf">
						<input type="radio" name="ok_yn" id=okYn1 value="Y"<%If okYn = "Y" Or flag = "N" Then%> checked<%End If%> /><label for=okYn1>승인</label>
						<input type="radio" name="ok_yn" id=okYn2 value="N"<%If okYn = "N" Then%> checked<%End If%> /><label for=okYn2>미승인</label>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="ct mt10">
		<button type="button" onclick="goSave()" class="btn03">저장</button>
		<button type="button" onclick="goDelete()" class="btn01">삭제</button>
		<button type="button" onclick="simsClosePopup()" class="">창닫기</button>
	</div>
</div>
</form>
</body>
</html>
<%	dbc() %>
