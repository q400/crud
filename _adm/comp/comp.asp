<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: comp.asp - 고객사 관리
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "comp_nm"
	If page = "" Then page = 1

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = " WHERE "& cd1 &" LIKE '%"& cd2 &"%' AND sttus = '완료'"
	Else								'검색조건이 없는 경우
		param = " WHERE sttus = '완료'"
	End If

	'게시물 개수
	rso()
	SQL = " SELECT COUNT(*) FROM cmpt010 "& param
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/15) + 1
	pageParam = "cd1="& cd1 &"&cd2="& cd2
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSearch").click(function (){		//조회
		goSearch();
	});
	$("#btnReset").click(function (){		//새로고침
		document.location = "comp.asp";
	});
	$("#btnWrite").click(function (){		//글쓰기
		$("#fm1").attr({action:"comp_w.asp", method:"POST"}).submit();
	});
});
function goSearch(){
	$("#fm1").attr({action:"comp.asp", method:"post"}).submit();
}
function writeKeyDown(){
	if(event.keyCode == 13)	goSearch();
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

<form name="fm1" id=fm1>
<input type="hidden" name="page" value="<%=page%>">

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > 고객관리 > 고객사관리</td>
							</tr>
							<tr>
								<td>
									<div class="">
										<span></span>
									</div>
									<div class="ib mb5 frt"><%=FormatNumber(recordcount,0)%> 건</div>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0">
										<tr height=40>
											<th width="100">No.</th>
											<th width="150">고객사코드</th>
											<th>고객사 이름</th>
											<th width="150">담당자</th>
											<th width="100">직원수</th>
											<th width="180">신청일자</th>
											<th width="100">사용여부</th>
											<th width="80">상태</th>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=10></td>
										</tr>
<%
		rso()
		SQL = " SELECT TOP 15 * FROM cmpt010 "& param _
			& " AND cid NOT IN (SELECT TOP "& ((page-1) * 15) &" cid FROM cmpt010 "& param _
			& " ORDER BY ddate DESC) ORDER BY ddate DESC "
		rs.open SQL, dbcon, 3
		rs.pagesize = 15
		j = recordcount

		If Not (rs.eof And rs.bof) Then
			rs.absolutepage = page
			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize
			End If

			rs.MoveFirst
			Do Until rs.EOF
%>
										<tr height=34>
											<td class="ct mt5 mb5"><%=j%></td>
											<td class="ct">
												<a href="comp_w.asp?seq=<%=rs("seq")%>&page=<%=page%>&<%=pageParam%>"><%=rs("cid")%></a>
											</td>
											<td class="pl10">
												<a href="comp_w.asp?seq=<%=rs("seq")%>&page=<%=page%>&<%=pageParam%>"><%=rs("comp_nm")%></a>
											</td>
											<td class="ct"><%=rs("mngr_nm")%></td>
											<td class="ct"><%=dataCnt("emp",rs("cid"))%></td>
											<td class="ct"><%=Left(rs("ddate"),10)%></td>
											<td class="ct"><%=rs("use_yn")%></td>
											<td class="ct"><%=rs("sttus")%></td>
										</tr>
<%							rs.MoveNext
							If Not rs.eof Then %>
										<tr>
											<td height="1" colspan="9" background="/img/dot.gif"></td>
										</tr>
<%							End If
					j = j - 1
			Loop
		Else
%>
										<tr height="100">
											<td class="ct vm" colspan=10>내용이 없습니다.</td>
										</tr>
<%
		End If
		rsc()
%>
									</table>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td height="5"></td>
							</tr>
						</table>
						<div class="ct mt10"><%=fnPagingGet(totalpage, page, 10, pageParam)%></div>
						<div class="ct mt10 pb50 pr50">
							<select name="cd1" id="cd1" style="width:100px;">
								<option value="title" <%If cd1 = "" Or cd1 = "title" Then%>selected<%End If%>>제목</option>
								<option value="contents" <%If cd1 = "contents" Then%>selected<%End If%>>본문</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" onkeydown="writeKeyDown();" />
							<button type="button" id=btnSearch>조회</button>
							<button type="button" id=btnReset>새로고침</button>
<%
		If USER_AUTH < 10 Then
%>
							<button type="button" id=btnWrite class="btn01">글쓰기</button>
<%
		End If
%>
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
