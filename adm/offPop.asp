<!-- #include virtual = "/inc/headerPop.asp" -->
<%
'************************************************************************************
'* 화면명	: offPop.asp - 휴가사용목록 popup
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	uid							= SQLI(Request("uid"))
	flag						= SQLI(Request("flag"))
	vYear						= SQLI(Request("vYear"))
'	Response.Write "vYear : "& vYear &"<br>"

	Select Case flag
		Case "B" : xday = memVaca9(uid,"B") : title = "초기휴가일수"
		Case "U" : xday = memVaca9(uid,"U") : title = "사용일수"
		Case "R" : xday = memVaca9(uid,"R") : title = "남은일수"
		Case "late" : xday = memInfo(uid,"late") : title = "지각횟수"
		Case "T" : xday = memVaca9(uid,"T") : title = "전체"
	End Select
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSearch,#xname,#xid").click(function (){		//직원찾기
		unoPop('/sys/sancPop.asp?opt=S&callBack=01','직원찾기','500','600');
	});
	$("#sign3Nm").click(function (){		//부서장찾기
		unoPop('/sys/sancPop.asp?opt=S&callBack=02','직원찾기','500','600');
	});
	$("#btnSave").click(function (){		//저장
		if($("#sign3").val() == ""){
			alert("담당부서장을 입력하세요.");
			$("#sign3").focus();
			return;
		}
		if(confirm("입력하시겠습니까?")){
<%
	If seq <> "" Then
%>
			$("#op1").val("M");
<%
	End If
%>
			$("#fm1").attr({action:"flex_x.asp", method:"post"}).submit();
		}
	});
	$("#btnDelete").click(function (){		//삭제
		if(!confirm("정말 삭제하시겠습니까?")){
			return;
		}
		$("#op1").val("D");
		$("#fm1").attr({action:"off_x.asp", method:"post"}).submit();
	});
	$("#btnClose").click(function (){		//닫기
		simsClosePopup();
	});
});
function goSave(){
	var f = document.fm1;
	if (!f.appday.value){
		alert("적용 숫자를 입력하세요.");
		return;
	}
	f.action = "vaca_x.asp";
	f.submit();
}
function changeYY(){
	var f = document.fm1;
	f.action = "offPop.asp";
	f.submit();
}
function goDelete(vGubn, vSeq, vIdx){	//삭제
	if (confirm("삭제합니까?")){
		document.fm1.gubn.value = vGubn;
		document.fm1.seq.value = vSeq;
		document.fm1.idx.value = vIdx;
		document.fm1.action = "off_x.asp";
		document.fm1.method = "post";
		document.fm1.submit();
	}
}
</script>


<form name="fm1" id="fm1" method="post">
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="idx" id="idx" />
<input type="hidden" name="uid" id="uid" value="<%=uid%>" />
<input type="hidden" name="flag" id="flag" value="<%=flag%>" />
<input type="hidden" name="gubn" id="gubn" />

<div>
	<div class="mt20">
		<div class="ml5">
			<select name="vYear" id="vYear" style="width:120px;" onchange="changeYY();">
<%
	For yy = Year(Date()) To 2021 Step -1
%>
				<option value="<%=yy%>" <%If vYear = CStr(yy) Then%>selected<%End If%>><%=yy%></option>
<%
	Next
%>
			</select>
		</div>
		<table width=100% id="list2">
			<colgroup>
				<col style="width:150px;" />
				<col style="width:150px;" />
				<col /><!-- 제목 -->
			</colgroup>
			<thead>
				<tr style="height:30px;">
					<th>해당일자</th>
					<th>내용</th>
					<th>승인</th>
				</tr>
			</thead>
			<tbody>
<%
		rso()
		SQL = " SELECT y.idx, y.vdate, x.gubn, x.seq, x.adm_chk "_
			& " FROM vact010 x INNER JOIN vact011 y "_
			& " ON x.seq = y.seq "_
			& " WHERE x.uid = '"& uid &"' "_
			& " AND LEFT(vdate,4) = '"& vYear &"'"_
			& " ORDER BY y.vdate DESC "
'		Response.Write SQL &"<br>"
		rs.open SQL, dbcon
		If Not (rs.eof And rs.bof) Then
			While Not rs.eof
%>
				<tr height=26>
					<td><%=rs("vdate")%></td>
					<td><%=rs("gubn")%></td>
					<td title="<%=rs("idx")%>">
<%
				If rs("adm_chk") = "N" Then
%>
						<a href="javascript:goDelete('VX',<%=rs("seq")%>,<%=rs("idx")%>);"><span class="fc7">삭제</span></a>
<%
				Else
%>
						승인
<%
				End If
%>
					</td>
				</tr>
<%
				rs.MoveNext
			Wend
		Else
%>
				<tr>
					<td class="ct vm" style="height:100px;" colspan=10>내용이 없습니다.</td>
				</tr>
<%
		End If
		rsc()
%>
			</tbody>
		</table>
		<div class="ct mt10">
			<button type="button" id=btnClose class="">창닫기</button>
		</div>
	</div>
</div>
</form>
</body>
</html>
<%	dbc() %>
