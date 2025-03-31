<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: log.asp - 접속로그
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색어
	unm							= SQLI(Request("unm"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If page = "" Then page = 1

	param = " WHERE 1=1 "

	If cd2 <> "" Then						'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' "
	End If

	rso()
	SQL = " SELECT COUNT(*) " _
		& " FROM logt010 m011 " _
		& "	LEFT JOIN memt010 m010 " _
		& "		ON m010.uid = m011.uid " _
		& param
'	Response.write SQL
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/20) + 1

	pageParam = "cd1="& cd1 &"&cd2="& cd2
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#cd2").keypress(function(event){
		if(event.which == 13){
			goSearch();
		}
	});
	$("#btnDelete").click(function (){		//선택삭제
		if($("input:checkbox[name=cbox]:checked").length == 0){
			alert("최소 1개는 선택해야 합니다.");
			return;
		}else{
			if(confirm("선택 항목을 삭제합니까?")){
				$("#flag").val("D");
				$("#fm1").attr({action:"log_x.asp", method:"post"}).submit();
			}
		}
	});
	$("#chkAll").change(function(){		//#chkAll 요소의 상태가 변한 경우
		var is_check = $(this).is(":checked");	//전체선택 체크박스의 체크상태 판별
		$(".cbox").prop("checked", is_check);	//하위 체크박스에 체크상태 적용
	});
});
function goSearch(){
	$("#page").val() == 1;
	$("#fm1").attr({action:"log.asp", method:"post"}).submit();
}
</script>


<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/adm_left.asp" -->
					</td>
					<td valign="top">

<form name="fm1" id="fm1">
<input type="hidden" name="seq" id="seq" />
<input type="hidden" name="flag" id="flag" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > 시스템관리 > 접속로그</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span>
										</span>
										<span class="frt"><%=FormatNumber(recordcount,0)%> 건</span>
									</div>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0">
										<colgroup>
											<col style="width:5%;" /><!-- 선택 -->
											<col style="width:15%;" /><!-- 접속계정 -->
											<col style="width:15%;" /><!-- 이름 -->
											<col style="width:15%;" /><!-- IP 주소 -->
											<col /><!-- 접속시간 -->
										</colgroup>
										<thead>
											<tr style="height:30px;">
												<th><input type="checkbox" name="chkAll" id="chkAll" /></th>
												<th>접속계정</th>
												<th>이름</th>
												<th>IP 주소</th>
												<th>접속시간</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		rso()
		SQL = " SELECT TOP 20 * "_
			& " FROM logt010 m011 "_
			& " LEFT JOIN memt010 m010 "_
			& "		ON m010.uid = m011.uid "& param _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 20) &" seq FROM logt010 m011 " _
			& "	LEFT JOIN memt010 m010 " _
			& "		ON m010.uid = m011.uid "& param _
			& " ORDER BY conn_tm DESC) " _
			& " ORDER BY conn_tm DESC "
'		Response.write SQL

		rs.open SQL, dbcon, 3
		rs.pagesize = 20
		j = recordcount

		If Not (rs.eof And rs.bof) Then
			rs.absolutepage = page
			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize + 1
			End If

			i = 1
			rs.MoveFirst
			Do Until rs.EOF
%>
											<tr height=30>
												<td class="ct">
													<input type="checkbox" name="cbox" id="cbox<%=i%>" class="cbox" value="<%=rs("seq")%>" />
												</td>
												<td class="ct">
													<a href="/adm/modify.asp?uid=<%=rs("uid")%>"><%=rs("uid")%></a>
												</td>
												<td class="ct">
													<a href="/adm/modify.asp?uid=<%=rs("uid")%>"><%=memInfo(rs("uid"),"unm")%></a>
												</td>
												<td class="ct">
													<%=rs("conn_ip")%>
												</td>
												<td class="pl20">
													<%=rs("conn_tm")%>
												</td>
											</tr>
<%
				rs.MoveNext
				If Not rs.eof Then
%>
											<tr>
												<td height="1" colspan="9" background="/img/dot.gif"></td>
											</tr>
<%
				End If
				j = j - 1
			Loop
		Else
%>
											<tr height="100">
												<td class="ct vm" colspan=10>내용이 없습니다..</td>
											</tr>
<%
		End If
		rsc()
%>
										</tbody>
									</table>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
						</table>
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, pageParam)%></div>
						<div class="ct mt10 pb50">
							<select name="cd1" id="cd1" style="width:180px;">
								<option value="" <%If cd1 = "" Then%>selected<%End If%>>선택</option>
								<option value="m010.unm" <%If cd1 = "m010.unm" Then%>selected<%End If%>>이름검색</option>
								<option value="m010.uid" <%If cd1 = "m010.uid" Then%>selected<%End If%>>ID검색</option>
								<option value="m011.conn_ip" <%If cd1 = "m011.conn_ip" Then%>selected<%End If%>>접속IP검색</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" onkeydown="writeKeyDown();" />
							<button type="button" onclick="goSearch();">조회</button>
							<button type="button" onclick="location='log.asp'">초기화</button>
							<button type="button" id=btnDelete class="btn01">선택삭제</button>
						</div>
</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
