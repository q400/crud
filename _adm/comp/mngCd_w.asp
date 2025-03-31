<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: mngCd_w.asp - 코드등록신청
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))
%>

<script type="text/javascript">
$(document).ready(function(){
	$('#opt1').change(function (){		//출근시간변경
		alert($('#opt1 option:selected').index());
	});
});
function goSave(){
	if($('#idx').val() == ''){
		alert('순번을 입력하세요.');
		$('#idx').focus();
		return;
	}else if($('#code_nm').val() == ''){
		alert('코드 이름을 입력하세요.');
		$('#code_nm').focus();
		return;
	}else{
		$('#fm1').attr({action:'code_x.asp', method:'POST'}).submit();
	}
}
</script>
</head>


<form name="fm1" id="fm1">
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
					<td class="lf"><input type="text" name="gubn" id="gubn" value="<%=gubn%>" style="width:200px;" /></td>
				</tr>
				<tr>
					<td>순번</td>
					<td class="lf"><input type="number" name="idx" id="idx" value="<%=idx%>" step=5 min=100 style="width:100px;" /></td>
				</tr>
				<tr>
					<td>코드이름</td>
					<td class="lf"><input type="text" name="code_nm" id="code_nm" value="<%=code_nm%>" style="width:200px;" /></td>
				</tr>
				<tr id="sub01" style="display:none;">
					<td>근무시간</td>
					<td class="lf">
						<select name="opt1" id="opt1" style="width:100px;">
							<option value="" <%If opt1 = "" Then%>selected<%End If%>>전체</option>
<%
			rso()
			SQL = "	SELECT idx, code_nm FROM codt010 WHERE gubn = '시간' ORDER BY idx ASC "
			rs.open SQL, dbcon, 3
			Do Until rs.eof
%>
							<option value="<%=rs("idx")%>" <%If CStr(rs("idx")) = opt1 Then%>selected<%End If%>><%=rs("code_nm")%></option>
<%
				rs.MoveNext
			Loop
			rsc()
%>
						</select>
						<select name="opt2" id="opt2" style="width:100px;">
							<option value="" <%If opt2 = "" Then%>selected<%End If%>>전체</option>
<%
			rso()
			SQL = "	SELECT idx, code_nm FROM codt010 WHERE gubn = '시간' ORDER BY idx ASC "
			rs.open SQL, dbcon, 3
			Do Until rs.eof
%>
							<option value="<%=rs("idx")%>" <%If CStr(rs("idx")) = opt2 Then%>selected<%End If%>><%=rs("code_nm")%></option>
<%
				rs.MoveNext
			Loop
			rsc()
%>
						</select>
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
