<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: ip.asp - 허용IP관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	gubn						= SQLI(Request("gubn"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If page = "" Then page = 1

	If gubn <> "" Then					'검색조건이 있는 경우
		param1 = " WHERE gubn = '"& gubn &"'"
	Else								'검색조건이 없는 경우
		param1 = " WHERE 1=1"
	End If

	param2 = " ORDER BY gubn "
	param = param1 & param2

	rso()
	SQL = " SELECT COUNT(*) FROM ipdt010 "& param1
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/20) + 1
%>

<script type="text/javascript">
<!--
function goSearch(){
	$("#page").val() == 1;
	$("#fm1").attr({action:"ip.asp", method:"post"}).submit();
}
//-->
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

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > 시스템관리 > 허용IP관리</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span></span>
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
											<col style="width:5%;" /><!-- 순번 -->
											<col style="width:20%;" /><!-- IP대역 -->
											<col style="width:20%;" /><!-- 구분 -->
											<col style="width:10%;" /><!-- 사용여부 -->
											<col /><!-- 등록일자 -->
										</colgroup>
										<thead>
											<tr style="height:30px;">
												<th>순번</th>
												<th>IP대역</th>
												<th>구분</th>
												<th>사용여부</th>
												<th>등록일자</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		rso()
		SQL = " SELECT TOP 20 * FROM ipdt010 "& param1 _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 20) &" seq FROM ipdt010 "& param1 _
			& " ORDER BY gubn) " _
			& " ORDER BY gubn "
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
											<tr height=34>
												<td class="ct"><%=rs("seq")%></td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('ip_v.asp?seq=<%=rs("seq")%>','접근허용IP수정',400,250)"><%=rs("ip")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('ip_v.asp?seq=<%=rs("seq")%>','접근허용IP수정',400,250)"><%=rs("gubn")%></a>
												</td>
												<td class="ct"><%=rs("use_yn")%></td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('ip_v.asp?seq=<%=rs("seq")%>','접근허용IP수정',400,250)"><%=rs("ddate")%></a>
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
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, "gubn="&gubn)%></div>
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
							<button type="button" onclick="location='mem_a.asp'">초기화</button>
							//-->
							<button type="button" onclick="unoPop('ip_w.asp','접근허용IP등록',400,250)" class="btn01">신규등록</button>
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
