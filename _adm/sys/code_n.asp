<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: code_n.asp - 표준코드 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	cdSe						= SQLI(Request("code_se"))
	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색단어
	okYn						= SQLI(Request("okYn"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "code_nm"
	If page = "" Then page = 1

	If cdSe <> "" Then					'검색조건이 있는 경우
		param1 = " WHERE code_se = '"& cdSe &"'"
	Else								'검색조건이 없는 경우
		param1 = " WHERE 1=1"
	End If

	If cd1 = "cid" Then					'검색조건이 있는 경우
		param = " WHERE cid IN (SELECT cid FROM cmpt010 WHERE comp_nm LIKE '%"& cd2 &"%')"
	Else								'검색조건이 없는 경우
		param = " WHERE code_nm LIKE '%"& cd2 &"%'"
	End If

	If okYn <> "" Then					'승인여부
		param1 = param1 &" AND ok_yn = '"& okYn &"'"
	End If

	param2 = " ORDER BY code_se, seq "
	param = param1 & param2

	rso()
	SQL = " SELECT COUNT(*) FROM codt040 "& param1
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/30) + 1
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#code_se").change(function (){		//조회
		goSearch();
	});
	$("#okYn0,#okYn1,#okYn2").click(function (){
		goSearch();
	});
	$("#btnReset").click(function (){		//새로고침
		document.location = "code_n.asp";
	});
});
function goSearch(){
	$("#page").val("1");
	$("#fm1").attr({action:"code_n.asp", method:"POST"}).submit();
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

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > 서비스관리 > <a href="/_adm/sys/code_n.asp">표준코드 신청현황</a></td>
							</tr>
							<tr>
								<td>
									<div class="ib mb10">
										<span>
											<select name="code_se" id="code_se" style="width:200px;">
												<option value="" <%If cdSe = "" Then%>selected<%End If%>>전체</option>
<%
		rso()
		SQL = "	SELECT DISTINCT code_se FROM codt040 ORDER BY code_se "
		rs.open SQL, dbcon, 3
		Do Until rs.eof
%>
												<option value="<%=rs("code_se")%>" <%If rs("code_se") = cdSe Then%>selected<%End If%>><%=rs("code_se")%></option>
<%
			rs.MoveNext
		Loop
		rsc()
%>
											</select>
										</span>
										<span>
											<input type="radio" name="okYn" id=okYn0 value=""<%If okYn = "" Then%> checked<%End If%> /><label for=okYn0>전체</label>
											<input type="radio" name="okYn" id=okYn1 value="Y"<%If okYn = "Y" Then%> checked<%End If%> /><label for=okYn1>승인</label>
											<input type="radio" name="okYn" id=okYn2 value="N"<%If okYn = "N" Then%> checked<%End If%> /><label for=okYn2>미승인</label>
										</span>
									</div>
									<div class="ib mt20 mb5 frt"><%=FormatNumber(recordcount,0)%> 건</div>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0">
										<colgroup>
											<col style="width:13%;" /><!-- 구분 -->
											<col style="width:15%;" /><!-- 코드이름 -->
											<col /><!-- 등록업체 -->
											<col style="width:20%;" /><!-- 등록일시 -->
											<col style="width:15%;" /><!-- 처리일자 -->
											<col style="width:7%;" /><!-- 승인여부 -->
										</colgroup>
										<thead>
											<tr style="height:30px;">
												<th>구분</th>
												<th>코드이름</th>
												<th>등록업체</th>
												<th>등록일시</th>
												<th>처리일자</th>
												<th>승인여부</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
		rso()
		SQL = " SELECT TOP 30 * FROM codt040 "& param1 _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 30) &" seq FROM codt040 "& param1 _
			& " ORDER BY code_se) " _
			& " ORDER BY code_se "
'		Response.write SQL

		rs.open SQL, dbcon, 3
		rs.pagesize = 30
		j = recordcount

		If Not (rs.eof And rs.bof) Then
			rs.absolutepage = page
			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize + 1
			End If

			i = 1
			rs.MoveFirst
%>
<%
			Do Until rs.EOF
%>
											<tr height=30>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_nw.asp?seq=<%=rs("seq")%>','코드수정', 500, 380)"><%=rs("code_se")%></a>
												</td>
												<td class="pl20">
													<a href="javascript:;" onclick="unoPop('code_nw.asp?seq=<%=rs("seq")%>','코드수정', 500, 380)"><%=rs("code_nm")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_nw.asp?seq=<%=rs("seq")%>','코드수정', 500, 380)"><%=cmpInfo(rs("cid"), "comp_nm")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_nw.asp?seq=<%=rs("seq")%>','코드수정', 500, 380)"><%=rs("wdate")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_nw.asp?seq=<%=rs("seq")%>','코드수정', 500, 380)"><%=rs("pdate")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_nw.asp?seq=<%=rs("seq")%>','코드수정', 500, 380)"><%=rs("ok_yn")%></a>
												</td>
											</tr>
<%
				rs.MoveNext
				If Not rs.eof Then
%>
											<tr>
												<td height="1" bgcolor="#525d65" colspan=10></td>
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
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, "code_se="& cdSe &"&okYn="& okYn)%></div>
						<div class="ct mt10 pb50">
							<select name="cd1" id="cd1" style="width:150px;">
								<option value="" <%If cd1 = "" Then%>selected<%End If%>>선택</option>
								<option value="code_nm" <%If cd1 = "code_nm" Then%>selected<%End If%>>코드이름검색</option>
								<option value="cid" <%If cd1 = "cid" Then%>selected<%End If%>>업체검색</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" onkeydown="writeKeyDown();" />
							<button type="button" onclick="goSearch();">조회</button>
							<button type="button" onclick="unoPop('code_nw.asp?flag=N','코드등록', 500, 380)" class="btn01">신규등록</button>
							<button type="button" id=btnReset>새로고침</button>
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
