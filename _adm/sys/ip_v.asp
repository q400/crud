<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: ip_v.asp - 허용IP관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	seq							= SQLI(Request("seq"))

	rso()
	SQL = " SELECT * FROM ipdt010 WHERE seq = "& seq
	rs.open SQL, dbcon, 3
	If Not (rs.eof And rs.bof) Then
		ip						= rs("ip")
		gubn					= rs("gubn")
		useYn					= rs("use_yn")
	End If
	rsc()
%>

<script type="text/javascript">
function goSave(){
	if($("#ip").val() == ""){
		alert("IP를 입력하세요.");
		$("#ip").focus();
		return;
	}else{
		$("#flag").val("M");
		$("#fm1").attr({action:"ip_x.asp", method:"post"}).submit();
	}
}
function goDelete(){			//삭제
	if(!confirm("정말 삭제하시겠습니까?")){
		return;
	}
	$("#flag").val("D");
	$("#fm1").attr({action:"ip_x.asp", method:"post", target:""}).submit();
}
</script>
</head>


<form name="fm1" id="fm1" method="post">
<input type="hidden" name="seq" id="seq" value="<%=seq%>" />
<input type="hidden" name="flag" id="flag" />
<div id="mainwrap3">
	<div>
		<table width=100% id="list1">
			<colgroup>
				<col style="width:120px;" />
				<col width="*" />
			</colgroup>
			<tbody>
				<tr>
					<td>IP</td>
					<td class="lf">
						<input type="text" name="ip" id="ip" value="<%=ip%>" maxlength=12 style="width:200px;" />
					</td>
				</tr>
				<tr>
					<td>구분</td>
					<td class="lf">
						<select name="gubn" id="gubn" style="width:200px;"><!-- 고객사 -->
							<option value="">선택</option>
<%
			rso()
			SQL = "	SELECT cid, comp_nm FROM cmpt010 WHERE 1=1 AND use_yn = 'Y' ORDER BY ddate ASC "
			rs.open SQL, dbCon, 3
			Do Until rs.eof
%>
							<option value="<%=rs("cid")%>"<%If rs("cid") = USER_COMP Then%>selected<%End If%>><%=rs("comp_nm")%></option>
<%
				rs.MoveNext
			Loop
			rsc()
%>
						</select>
					</td>
				</tr>
				<tr>
					<td>사용여부</td>
					<td class="lf">
						<input type="radio" name="use_yn" id=useYn1 value="Y"<%If useYn = "Y" Then%> checked<%End If%> /><label for=useYn1>사용</label>
						<input type="radio" name="use_yn" id=useYn2 value="N"<%If useYn = "N" Then%> checked<%End If%> /><label for=useYn2>미사용</label>
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
