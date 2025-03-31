<%
'************************************************************************************
'*  윈도우 명		: data.asp
'************************************************************************************
%>
<!-- #include virtual = "/inc/header.asp" -->
<%
	Call checkLevel(USER_AUTH, 900, Request.ServerVariables("PATH_INFO"))

	bbs_id					= 2								'1-공지/2-자료실/10-회의록/30-사진/50-종합자료
	cd1						= SQLI(Request("cd1"))
	cd2						= SQLI(Request("cd2"))		'검색단어
	page					= SQLI(Request("page"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = " WHERE "& cd1 &" LIKE '%"& cd2 &"%' AND bbs_id = "& bbs_id
	Else								'검색조건이 없는 경우
		param = " WHERE bbs_id = "& bbs_id
	End If

	'게시물 개수
	rso()
	SQL = " SELECT	COUNT(*) FROM _cbbst010 "& param
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/15) + 1
%>

<script type="text/javascript">
<!--
function goSearch(){
	document.fm1.page.value = "1";
	document.fm1.action = "data.asp";
	document.fm1.submit();
}
//-->
</script>


<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr height="100%">
		<td valign="top">
			<table width=1130 border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width=230 valign="top"><!-- #include virtual = "/inc/_left.asp" --></td>
					<td class="vt">

<form name="fm1" method="post">
<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
<input type="hidden" name="seq">
<input type="hidden" name="ans_seq">
<input type="hidden" name="page" value="<%=page%>">

						<table width=900 border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td class="pb10">자료관리 > 자료실</td>
							</tr>
							<tr>
								<td valign="top" align="center">
									<table width=100% border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td height="2" colspan="9" bgcolor="#b2bdd5"></td>
										</tr>
										<tr height="40" align="center">
											<td width="50"><b>번호</b></td>
											<td><b>제목</b></td>
											<td width="90"><b>등록자</b></td>
											<td width="90"><b>등록일자</b></td>
											<td width="70"><b>조회</b></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan="9"></td>
										</tr>
										<tr>
											<td height="2" colspan="9" bgcolor="#f4f4f4"></td>
										</tr>
<%
		rso()
		SQL = " SELECT	TOP 15 * FROM _cbbst010 "& param _
			& " AND seq NOT IN (SELECT TOP "& ((page-1) * 15) &" seq FROM _cbbst010 "& param _
			& " ORDER BY seq DESC) ORDER BY seq DESC "
		rs.open SQL, dbcon, 3
		rs.pagesize = 15
		j = recordcount

		If Not (rs.eof And rs.bof) Then
			rs.absolutepage = page
			If page <> 1 Then
				j = j - (page - 1) * rs.pagesize
			End If

			i = 1
			rs.MoveFirst
			Do Until rs.EOF
				Set rs3 = Server.CreateObject("ADODB.Recordset")
				SQL = " SELECT	COUNT(*) FROM _cbbst011 WHERE bbs_id = "& bbs_id &" AND seq = "& rs("seq")
				rs3.open SQL, dbcon, 3
				If Not rs3.eof Then
					pCnt = rs3(0)
				End If
				rs3.close
				Set rs3 = Nothing

				Set rs1 = Server.CreateObject("ADODB.Recordset")
				SQL = "	SELECT	ISNULL(COUNT(*),0) FROM _cbbst013 WHERE bbs_id = "& bbs_id &" AND seq = "& rs("seq")
				rs1.open SQL, dbcon
				If Not rs1.eof Then
					k = rs1(0)			'답변글 갯수
				End If
				rs1.close
				Set rs1 = Nothing

				If k <> 0 Then
					k = "<font style='font-size:11px;color:#ff6c00;font-weight:bold;'>ㆍ"& k &"</font>"
				Else
					k = ""
				End If
%>
										<tr height="30">
											<td align="center"><%=j%></td>
											<td>&nbsp;&nbsp;
												<a href="data_v.asp?seq=<%=rs("seq")%>&page=<%=page%>&cd1=<%=cd1%>&cd2=<%=cd2%>"><%=TrimText(rs("title"),40)%></a>
												<%If pCnt <> 0 Then%>
												<img src="/img/file.gif" width="9" height="9" align="absmiddle">
												<%End If%>
												<%=k%>
											</td>
											<td align="center"><%=meminfo(rs("uid"),"uname")%></td>
											<td align="center"><%=Left(rs("ddate"),10)%></td>
											<td align="center"><%=rs("cnt")%></td>
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
											<td align="center" valign="middle" colspan="6">내용이 없습니다.</td>
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
</form>
						<div class="mt10 mb20">
							<div style="width:90%;" class="ct ib"><%=fnPagingGet(totalpage, page, 10, "cd1="&cd1&"&cd2="&cd2)%></div>
							<div class="frt ib"><a href="data_w.asp"><img src="/img/btn/bn_write.gif" title="쓰기" /></a></div>
						</div>
						<div class="ct vm">
							<select name="cd1" id="cd1" style="width:70x;" class="vt">
								<option value="title" <%If cd1 = "" Or cd1 = "title" Then%>selected<%End If%>>제목</option>
								<option value="contents" <%If cd1 = "contents" Then%>selected<%End If%>>본문</option>
							</select>
							<input type="text" name="cd2" <%If cd2 <> "" Then%>value="<%=cd2%>"<%End If%> class="bx" style="width:120px;" />
							<a href="javascript:goSearch();"><img src="/img/btn/bn_search.gif" class="vt" title="조회" /></a>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td><!-- #include virtual = "/inc/admin_footer.asp" --></td>
	</tr>
</table>
</body>
</html>
<%	dbc() %>
