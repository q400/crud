<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: work.asp - _adm 작업게시판
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	bbs_id						= 500							'500-작업
	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1

	param = " WHERE 1=1 "

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = param &" AND "& cd1 &" LIKE '%"& cd2 &"%' AND bbs_id = "& bbs_id
	Else								'검색조건이 없는 경우
		param = param &" AND bbs_id = "& bbs_id
	End If

	'게시물 개수
	rso()
	SQL = " SELECT COUNT(*) FROM bbst050 "& param
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
		document.location = "work.asp";
	});
	$("#btnWrite").click(function (){		//글쓰기
		document.location = "work_w.asp";
	});
});
function goSearch(){
	$("#fm1").attr({action:"work.asp", method:"post"}).submit();
}
function writeKeyDown(){
	if(event.keyCode == 13)	goSearch();
}
</script>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/adm_left.asp" -->
					</td>
					<td valign="top">

<form name="fm1" id=fm1>
<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
<input type="hidden" name="seq">
<input type="hidden" name="page" value="<%=page%>">

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">관리자 > 시스템관리 > 작업게시판</td>
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
								<td height="1" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td>
									<table width=100% border="0" cellspacing="0" cellpadding="0">
										<tr height=40>
											<th width="100">No.</th>
											<th width="250">고객사이름</th>
											<th>제목</th>
											<th width="340">해당경로</th>
											<th width="180">등록일자</th>
											<th width="100">진행상태</th>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=10></td>
										</tr>
<%
		rso()
		SQL = " SELECT TOP 15 * FROM bbst050 "& param _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 15) &" seq FROM bbst050 "& param _
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
				Set rs3 = Server.CreateObject("ADODB.Recordset")
				SQL = " SELECT ISNULL(COUNT(*),0) FROM bbst051 WHERE seq = "& rs("seq")
				rs3.open SQL, dbcon
					photoCnt = rs3(0)		'첨부파일 수
				rs3.close
				Set rs3 = Nothing
				Set rs5 = Server.CreateObject("ADODB.Recordset")
				SQL = " SELECT ISNULL(COUNT(*),0), MAX(rgdt) FROM bbst013 WHERE bbs_id = "& bbs_id &" AND seq = "& rs("seq") &" AND rgid <> 'webmaster'"
				rs5.open SQL, dbcon
					replyCnt5 = rs5(0)		'댓글 수
					replyDt5 = rs5(1)		'댓글 마지막 등록시간
				rs5.close
				Set rs5 = Nothing
				Set rs7 = Server.CreateObject("ADODB.Recordset")
				SQL = " SELECT ISNULL(COUNT(*),0), MAX(rgdt) FROM bbst013 WHERE bbs_id = "& bbs_id &" AND seq = "& rs("seq") &" AND rgid = 'webmaster'"
'				Response.Write "<br>"& SQL &"<br>"
				rs7.open SQL, dbcon
					replyCnt7 = rs7(0)		'개발자 댓글 수
					replyDt7 = rs7(1)		'개발자 댓글 마지막 등록시간
				rs7.close
				Set rs7 = Nothing
%>
										<tr height=34>
											<td class="ct mt5 mb5"><%=j%></td>
											<td class="ct">
												<a href="work_v.asp?seq=<%=rs("seq")%>&page=<%=page%>&<%=pageParam%>"><%=cmpInfo(rs("cid"),"comp_nm")%></a>
											</td>
											<td class="pl10">
												<a href="work_v.asp?seq=<%=rs("seq")%>&page=<%=page%>&<%=pageParam%>">
												<%=TrimText(rs("title"),40)%></a>
<%				If photoCnt <> 0 Then %>
												<img src="/img/icon/clip01.gif" class="vm" title="첨부파일" />
<%				End If %>
<%				If Date() - rs("rgdt") < 3 Then %>
												<img src="/img/icon/new05.gif" class="vm" title="신규" />
<%				End If %>
<%				If replyCnt5 <> 0 Then %>
												<b class="fc9 f12">ㆍ<%=replyCnt5%></b>
<%				End If %>
<%				If Date() - replyDt5 < 3 Then %>
												<img src="/img/icon/new01.gif" class="vm" title="신규" />
<%				End If %>
<%				If replyCnt7 <> 0 Then %>
												<b class="fc4 f12" onMouseover="ddrivetip('개발자 댓글 수',80)" onMouseout="hideddrivetip();">ㆍ<%=replyCnt7%></b>
<%				End If %>
<%				If Date() - replyDt7 < 3 Then %>
												<img src="/img/icon/new01.gif" class="vm" title="신규" />
<%				End If %>
											</td>
											<td class="lf pl10"><%=TrimText(rs("path"),30)%></td>
											<td class="ct"><%=Left(rs("rgdt"),10)%></td>
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
		If USER_AUTH < 200 Then
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
