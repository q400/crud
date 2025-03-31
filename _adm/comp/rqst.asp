<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: /_adm/comp/rqst.asp - 사용신청
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "comp_nm"
	If page = "" Then page = 1

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = " WHERE "& cd1 &" LIKE '%"& cd2 &"%'"
	Else								'검색조건이 없는 경우
		param = " WHERE 1=1"
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
		document.location = "rqst.asp";
	});
	$("#btnWrite").click(function (){		//글쓰기
		document.location = "rqst_w.asp";
	});
});
function goSearch(){
	$("#fm1").attr({action:"rqst.asp", method:"post"}).submit();
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
					<td class="vt">

<form name="fm1" id=fm1>
<input type="hidden" name="seq">
<input type="hidden" name="page" value="<%=page%>">

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20"><a href="/_adm/">관리자</a> > 서비스관리 > 사용신청현황</td>
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
											<th>고객사이름</th>
											<th width="150">담당자이름</th>
											<th width="150">담당자연락처</th>
											<th width="180">등록일자</th>
											<th width="80">상태</th>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=10></td>
										</tr>
<%
		rso()
		SQL = " SELECT TOP 15 * FROM cmpt010 "& param _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 15) &" seq FROM cmpt010 "& param _
			& " ORDER BY seq DESC) ORDER BY seq DESC "
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
												<a href="rqst_w.asp?seq=<%=rs("seq")%>&flag=M&page=<%=page%>&<%=pageParam%>"><%=rs("cid")%>
											</td>
											<td class="pl10">
												<a href="rqst_w.asp?seq=<%=rs("seq")%>&flag=M&page=<%=page%>&<%=pageParam%>"><%=rs("comp_nm")%></a>
<%				If Date() - rs("ddate") < 3 Then %>
												<img src="/img/icon/new05.gif" class="vm" title="신규" />
<%				End If %>
											</td>
											<td class="ct"><%=rs("mngr_nm")%></td>
											<td class="ct"><%=rs("mngr_tel")%></td>
											<td class="ct"><%=Left(rs("ddate"),10)%></td>
											<td class="ct">
<%				If rs("sttus") = "완료" Then %>
												<a href="comp_w.asp?seq=<%=rs("seq")%>&flag=M&page=<%=page%>&<%=pageParam%>" class="hint--info hint--top" aria-label="해당 고객사 관리 이동">
												<%=rs("sttus")%></a>
<%				Else %>
												<%=rs("sttus")%></a>
<%				End If %>
											</td>
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
							<select name="cd1" id="cd1" style="width:130px;">
								<option value="comp_nm" <%If cd1 = "" Or cd1 = "comp_nm" Then%>selected<%End If%>>고객사이름</option>
								<option value="contents" <%If cd1 = "contents" Then%>selected<%End If%>>본문</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> style="width:200px;" onkeydown="writeKeyDown();" />
							<button type="button" id=btnSearch>조회</button>
							<button type="button" id=btnReset>새로고침</button>
<%
		If USER_AUTH <> "" And USER_AUTH <= 10 Then
%>
							<button type="button" onclick="location='/_adm/'">취소</button>
<%
		End If
%>
<!-- 							<button type="button" id=btnWrite class="btn01">글쓰기</button> -->
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
