<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: code.asp - 공통코드 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	code_se						= SQLI(Request("code_se"))
	useYn						= SQLI(Request("useYn"))
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If page = "" Then page = 1

	If code_se <> "" Then				'검색조건이 있는 경우
		param1 = " WHERE code_se = '"& code_se &"'"
	Else								'검색조건이 없는 경우
		param1 = " WHERE 1=1"
	End If

	If useYn <> "" Then					'사용여부
		param1 = param1 &" AND use_yn = '"& useYn &"'"
	End If

	param2 = " ORDER BY code_se, idx "
	param = param1 & param2

	rso()
	SQL = " SELECT COUNT(*) FROM codt010 "& param1
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
	$("#useYn0,#useYn1,#useYn2").click(function (){
		goSearch();
	});
	$("#btnReset").click(function (){		//새로고침
		document.location = "code.asp";
	});
});
function goSearch(){
	$("#page").val("1");
	$("#fm1").attr({action:"code.asp", method:"post"}).submit();
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
<input type="hidden" name="bbs_id" id="bbs_id" value="<%=bbs_id%>" />
<input type="hidden" name="seq" id="seq" />
<!-- <input type="hidden" name="page" id="page" value="<%=page%>" /> -->

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > 시스템관리 > <a href="/_adm/sys/code.asp">코드관리</a></td>
							</tr>
							<tr>
								<td>
									<div class="ib mb10">
										<span>
											<select name="code_se" id="code_se" style="width:200px;">
												<option value="" <%If dept = "" Then%>selected<%End If%>>전체</option>
<%
		rso()
		SQL = "	SELECT DISTINCT code_se FROM codt010 WHERE use_yn = 'Y' ORDER BY code_se "
		rs.open SQL, dbcon, 3
		Do Until rs.eof
%>
												<option value="<%=rs("code_se")%>" <%If rs("code_se") = code_se Then%>selected<%End If%>><%=rs("code_se")%></option>
<%
			rs.MoveNext
		Loop
		rsc()
%>
											</select>
										</span>
										<span>
											<input type="radio" name="useYn" id=useYn0 value=""<%If useYn = "" Then%> checked<%End If%> /><label for=useYn0>전체</label>
											<input type="radio" name="useYn" id=useYn1 value="Y"<%If useYn = "Y" Then%> checked<%End If%> /><label for=useYn1>사용</label>
											<input type="radio" name="useYn" id=useYn2 value="N"<%If useYn = "N" Then%> checked<%End If%> /><label for=useYn2>미사용</label>
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
<%
		rso()
		SQL = " SELECT TOP 30 * FROM codt010 "& param1 _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 30) &" seq FROM codt010 "& param1 _
			& " ORDER BY code_id, code_se) " _
			& " ORDER BY code_id, code_se "
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
									<table width=100% border="0" cellspacing="0" cellpadding="0">
										<colgroup>
											<col style="width:20%;" /><!-- 구분 -->
											<col style="width:10%;" /><!-- 코드값 -->
											<col style="width:10%;" /><!-- 사용여부 -->
											<col /><!-- 코드이름 -->
											<col style="width:8%;" /><!-- 정렬순서 -->
<%
			If rs("code_se") = "팀" Then
%>
											<col style="width:8%;" /><!-- 평일출근시간 -->
											<col style="width:8%;" /><!-- 평일퇴근시간 -->
											<col style="width:8%;" /><!-- 주말출근시간 -->
											<col style="width:8%;" /><!-- 주말퇴근시간 -->
<%
			End If
%>
										</colgroup>
										<thead>
											<tr style="height:30px;">
												<th>구분</th>
												<th>코드값</th>
												<th>사용여부</th>
												<th>코드이름</th>
												<th>정렬순서</th>
<%
			If rs("code_se") = "팀" Then
%>
												<th>평일출근시간</th>
												<th>평일퇴근시간</th>
												<th>주말출근시간</th>
												<th>주말퇴근시간</th>
<%
			End If
%>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
<%
			Do Until rs.EOF
%>
											<tr height=30>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"><%=rs("code_se")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"><%=rs("code_id")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"><%=rs("use_yn")%></a>
												</td>
												<td class="pl20">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"><%=rs("code_nm")%></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"><%=rs("odrby")%></a>
												</td>
<%
				If rs("code_se") = "팀" Then
%>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"></a>
												</td>
												<td class="ct">
													<a href="javascript:;" onclick="unoPop('code_v.asp?seq=<%=rs("seq")%>','코드수정', 520, 400)"></a>
												</td>
<%
				End If
%>
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
%>
										</tbody>
									</table>
<%
		Else
%>
									<table width=100% border="0" cellspacing="0" cellpadding="0">
										<colgroup>
											<col style="width:20%;" /><!-- 구분 -->
											<col style="width:10%;" /><!-- 정렬순서 -->
											<col style="width:10%;" /><!-- 사용여부 -->
											<col /><!-- 코드이름 -->
										</colgroup>
										<thead>
											<tr style="height:30px;">
												<th>구분</th>
												<th>정렬순서</th>
												<th>사용여부</th>
												<th>코드이름</th>
											</tr>
											<tr>
												<td height="1" bgcolor="#b2bdd5" colspan=10></td>
											</tr>
										</thead>
										<tbody>
											<tr height="100">
												<td class="ct vm" colspan=10>내용이 없습니다..</td>
											</tr>
										</tbody>
									</table>
<%
		End If
		rsc()
%>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
						</table>
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, "code_se="& code_se &"&useYn="& useYn)%></div>
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
							<button type="button" onclick="unoPop('code_nw.asp?flag=N','코드등록', 520, 400)" class="btn01">신규등록</button>
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
