<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: code_w.asp - 공통코드 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#opt1").change(function (){		//출근시간변경
		alert($("#opt1 option:selected").index());
	});
});
function goSave(){
	if($("#odrby").val() == ""){
		alert("순번을 입력하세요.");
		$("#odrby").focus();
		return;
	}else if($("#code_nm").val() == ""){
		alert("코드 이름을 입력하세요.");
		$("#code_nm").focus();
		return;
	}else{
		$("#fm1").attr({action:"code_x.asp", method:"post"}).submit();
	}
}
</script>
</head>


<form name="fm1" id="fm1" method="post">
<input type="hidden" name="flag" id="flag" value="W">
<div id="mainwrap3">
	<div>
		<table width=100% id="list1">
			<colgroup>
				<col style="width:120px;" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr>
					<td>구분</td>
					<td class="lf"><input type="text" name="code_se" id="code_se" value="<%=code_se%>" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>순번</td>
					<td class="lf"><input type="number" name="odrby" id="odrby" value="<%=odrby%>" step=5 min=100 style="width:100px;" /></td>
				</tr>
				<tr>
					<td>코드값</td>
					<td class="lf"><input type="text" name="code_id" id="code_id" value="<%=code_id%>" maxlength="6" style="width:100px;" /></td>
				</tr>
				<tr>
					<td>코드이름</td>
					<td class="lf"><input type="text" name="code_nm" id="code_nm" value="<%=code_nm%>" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>사용여부</td>
					<td class="lf">
						<input type="radio" name="use_yn" id=useYn1 value="Y"<%If use_yn = "Y" Then%> checked<%End If%> /><label for=useYn1>사용</label>
						<input type="radio" name="use_yn" id=useYn2 value="N"<%If use_yn = "N" Then%> checked<%End If%> /><label for=useYn2>미사용</label>
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
