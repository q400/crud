<%
'************************************************************************************
'*  윈도우 명		: data_v.asp
'************************************************************************************
%>
<!-- #include virtual = "/inc/header.asp" -->
<%
	Call checkLevel(USER_AUTH, 900, Request.ServerVariables("PATH_INFO"))

	bbs_id					= 300						'100-공지/200-인사발령/300-자료/400-사진자료/500-브리핑
	seq						= SQLI(Request("seq"))
	cd1						= SQLI(Request("cd1"))
	cd2						= SQLI(Request("cd2"))		'검색단어
	page					= SQLI(Request("page"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1

	serverPath = Server.MapPath(PATH_DATA)
	webPath = PATH_DATA

	rso()
	SQL = "	SELECT	title, uid, cnt, rgdt, contents " _
		& " FROM bbst010 " _
		& " WHERE bbs_id = "& bbs_id &" AND cid = '"& USER_COMP &"' AND seq = "& seq
	rs.open SQL, dbcon, 3
	If Not rs.eof Then
		title				= rs("title")
		uid					= rs("uid")
		cnt					= rs("cnt")
		rgdt				= rs("rgdt")
		contents			= rs("contents")
	End If
	rsc()

	SQL = " UPDATE bbst010 SET cnt = cnt + 1 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
	dbcon.Execute SQL

	rso()
	SQL = "	SELECT	COUNT(*) FROM bbst012 WHERE bbs_id = "& bbs_id &" AND seq = "& seq &" AND uid = '"& USER_ID &"' "
	rs.open SQL, dbcon, 3
	If Not rs.eof Then
		intReadCnt = rs(0)
	End If

	If intReadCnt = 0 Then									'열람자 확인
		If USER_ID <> "" Then
			SQL = " INSERT INTO bbst012 (bbs_id, seq, uid) VALUES ("& bbs_id &", "& seq &", '"& USER_ID &"') "
			dbcon.Execute SQL
		End If
	End If
	rsc()
%>

<script type="text/javascript">
<!--
function goDelete(){				//삭제
	var f = document.fm1;
	if (!confirm("정말 삭제하시겠습니까?")){
		return;
	}
	f.flag.value = "D";
	f.target = "nullframe";
	f.action = "data_x.asp";
	f.submit();
}
function goReply(){
	var f = document.fm1;
	if (f.note.value.length < 10){
		alert("최소 10자 이상은 입력하세요.");
		f.note.focus();
	} else if (f.note.value.length > 500){
		alert("내용이 너무 깁니다. 줄이세요... -_-");
		f.note.focus();
	} else {
		f.flag.value = "R";
		f.target = "nullframe";
		f.action = "data_x.asp";
		f.submit();
	}
}
function opDelete(vidx){
	var f = document.fm1;
	if(!confirm("삭제하겠습니까?")){
		return;
	}
	f.idx.value = vidx;
	f.flag.value = "OPD";
	f.target = "nullframe";
	f.action = "data_x.asp";
	f.submit();
}
//-->
</script>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<table width="980" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="230" valign="top"><!-- #include virtual = "/inc/_left.asp" --></td>
					<td width="750" valign="top">

<form name="fm1" method="post" enctype="multipart/form-data">
<input type="hidden" name="bbs_id" value="<%=bbs_id%>">
<input type="hidden" name="seq" value="<%=seq%>">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="cd1" value="<%=cd1%>">
<input type="hidden" name="cd2" value="<%=cd2%>">
<input type="hidden" name="flag">
<input type="hidden" name="idx">

						<table width="750" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="22">자료관리 > 자료실</td>
							</tr>
							<tr>
								<td>
									<table width="750" border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td height="2" bgcolor="#b2bdd5" colspan="17"></td>
										</tr>
										<tr bgcolor="#f5f5f5" height="26">
											<th width="100">제목</th>
											<td width="650" style="padding-left:10;" colspan="5"><%=title%></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan="9"></td>
										</tr>
										<tr height="27">
											<th width="100">등록자</th>
											<td width="150" style="padding-left:10;"><%=meminfo(uid,"uname")%></td>
											<th width="100">등록일자</th>
											<td width="180" style="padding-left:10;"><%=rgdt%></td>
											<th width="100">조회수</th>
											<td width="120" style="padding-left:10;"><%=cnt%></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan="9"></td>
										</tr>
										<tr height="150">
											<td colspan="9" valign="top" style="padding:20 30 20 30;"><%=db2html(contents)%></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan="9"></td>
										</tr>
										<tr height="30">
											<th>첨부파일</th>
											<td colspan="8" style="padding:10px;">
<%
				If seq <> "" Then
					rso()
					SQL = " SELECT	photo_id, bbs_id, seq, file_path, file_nm, file_sz, file_wd FROM bbst011 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
					rs.open SQL, dbcon, 3
					While Not rs.eof
						file_ext = Right(rs("file_nm"), 3)
						change_file = ChangeFile(file_ext)
						ext_img = getFileImg(file_ext)
						If LCase(file_ext) = "gif" Or LCase(file_ext) = "jpg" Then
%>
												<a href="/data/download0.asp?path=DATA&file=<%=rs("file_nm")%>" title="파일크기:<%=FormatNumber(rs("file_sz")/1000,0)%>KB">
												<img src="<%=PATH_DATA%>/<%=rs("file_nm")%>" <%If rs("file_wd") < 500 Then%>width="<%=rs("file_wd")%>"<%Else%>width="500"<%End If%> align="absmiddle"></a>
												<br><br>
<%						Else %>
												<a href="/data/download0.asp?path=DATA&file=<%=rs("file_nm")%>" title="파일크기:<%=FormatNumber(rs("file_sz")/1000,0)%>KB"><img src="<%=ext_img%>" align="absmiddle">&nbsp;<%=rs("file_nm")%></a>
												<br>
<%
						End If
						rs.MoveNext
					Wend
					rsc()
				End If
%>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td height="5"></td>
							</tr>

							<tr>
								<td height="50">
									<table width="750" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td><img src="/img/btn/n_view.gif" title="열람자목록" /></td>
										</tr>
										<tr>
											<td>
												<table width="750" border="1" cellpadding="0" cellspacing="0" bordercolor="#b9b9c9" style="border-collapse:collapse;">
													<tr>
														<td style="padding:10px;">
<%
				rso()
				SQL = "	SELECT	uid FROM bbst012 WHERE bbs_id = "& bbs_id &" AND seq = "& seq &" ORDER BY rgdt "
				rs.open SQL, dbcon, 3
				While Not rs.eof
%>
															<%=meminfo(rs("uid"),"uname")%>&nbsp;
<%
					rs.MoveNext
				Wend
				rsc()
%>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table width="750" border="0" cellspacing="0" cellpadding="0">
										<tr height="60">
											<td align="right">
<%		If USER_ID = uid Or (USER_AUTH <> "" And USER_AUTH < 10) Then %>
												<a href="javascript:goDelete();"><img src="/img/btn/bn_delete.gif"></a>
												<a href="data_w.asp?seq=<%=seq%>&page=<%=page%>&cd1=<%=cd1%>&cd2=<%=cd2%>&flag=M"><img src="/img/btn/bn_modi.gif"></a>
<%		End If %>
												<a href="data.asp?page=<%=page%>&cd1=<%=cd1%>&cd2=<%=cd2%>"><img src="/img/btn/bn_list.gif"></a>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td height="50">
									<table width="750" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td><img src="/img/btn/n_line.gif" title="한줄의견"></td>
										</tr>
										<tr>
											<td>
												<table width="750" border="1" cellpadding="0" cellspacing="0" bordercolor="#b9b9c9" style="border-collapse:collapse;">
													<tr>
														<td style="padding:5;">
															<table width="750" border="0" cellpadding="0" cellspacing="0">
																<tr>
																	<td width="620">
																		<input type="text" name="note" style="width:612px;ime-mode:active;" class="bx">
																	</td>
																	<td width="130" align="center">
																		<a href="javascript:goReply();"><img src="/img/btn/bn_ok2.gif"></a>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
									<table width="750" border="0" cellpadding="0" cellspacing="0">
										<tr height="20">
											<td></td>
										</tr>
<%
				rso()
				SQL = "	SELECT	bbs_id, idx, seq, uid, rgdt, note FROM bbst013 WHERE bbs_id = "& bbs_id &" AND seq = "& seq &" ORDER BY rgdt "
				rs.open SQL, dbcon, 3
				While Not rs.eof
%>
										<tr height="22">
											<td width="300" style="padding-left:5px;"><b><font color="#b0b0b0"><%=rs("uid")%> [<%=meminfo(rs("uid"),"uname")%>]</font></b>
												<%If USER_ID = rs("uid") Then%>
												<a href="javascript:opDelete(<%=rs("idx")%>);"><img src="/img/bbs/1line_del.gif" align="absmiddle"></a>
												<%End If%>
											</td>
											<td style="padding-right:5;" align="right"><font color="#b0b0b0"><%=rs("rgdt")%></font></td>
										</tr>
										<tr>
											<td colspan="2" style="padding-left:30;"><%=rs("note")%></td>
										</tr>
<%
					rs.MoveNext
				Wend
				rsc()
%>
									</table>
								</td>
							</tr>
						</table>
</form>
						<br>
						<!-- 목록 -->
						<table width="750" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td valign="top" align="center">
									<table width="750" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td height="2" colspan="9" bgcolor="#b2bdd5"></td>
										</tr>
										<tr height=30 align="center">
											<th width="50">No.</th>
											<th>제목</th>
											<th width="90">작성자</th>
											<th width="90">등록일자</th>
											<th width="70">조회수</th>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan="9"></td>
										</tr>
										<tr>
											<td height="2" colspan="9" bgcolor="#f4f4f4"></td>
										</tr>
<%
	pagesize = 15			'페이지크기

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = " WHERE "& cd1 &" LIKE '%"& cd2 &"%' AND bbs_id = "& bbs_id
	Else								'검색조건이 없는 경우
		param = " WHERE bbs_id = "& bbs_id
	End If

	rso()
	SQL = "	SELECT	seq, title, uid, cnt, rgdt, contents FROM bbst010 "& param _
		& "	ORDER BY seq DESC "
	rs.open SQL, dbcon, 3
	rs.pagesize = 15

	j = rs.recordcount

	If Not (rs.eof And rs.bof) Then

		totalpage = rs.pagecount
		rs.absolutepage = page

		If page <> 1 Then
			j = j - (page - 1) * rs.pagesize
		End If

		i = 1
		Do Until rs.EOF Or i > rs.pagesize
			Set rs3 = Server.CreateObject("ADODB.Recordset")
			SQL = " SELECT	COUNT(*) FROM bbst011 WHERE bbs_id = "& bbs_id &" AND seq = "& rs("seq")
			rs3.open SQL, dbcon, 3
			If Not rs3.eof Then
				pCnt = rs3(0)
			End If
			rs3.close
			Set rs3 = Nothing

			Set rs1 = Server.CreateObject("ADODB.Recordset")
			SQL = "	SELECT	ISNULL(COUNT(*),0) FROM bbst013 WHERE bbs_id = "& bbs_id &" AND seq = "& rs("seq")
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
											<td align="center"><%=Left(rs("rgdt"),10)%></td>
											<td align="center"><%=rs("cnt")%></td>
										</tr>
										<tr>
											<td height="1" colspan="9" background="/img/dot.gif"></td>
										</tr>
<%
			rs.MoveNext
			i = i + 1
			j = j - 1
		Loop
	Else
%>
										<tr><td align="center" height="100" valign="middle" colspan="6">내용이 없습니다.</td></tr>
<%
	End If
	rsc()
%>
									</table>
								</td>
							</tr>
						</table>
</form>
						<div class="mt10 mb20">
							<div style="width:90%;" class="ct ib"><%=fnPagingGet(totalpage, page, 10, "cd1="&cd1&"&cd2="&cd2)%></div>
						</div>
						<div class="frt">
							<a href="data.asp?page=<%=page%>&cd1=<%=cd1%>&cd2=<%=cd2%>"><img src="/img/btn/bn_list.gif" /></a>
							<a href="data_w.asp"><img src="/img/btn/bn_write.gif" /></a>
						</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<!-- 하단부분 -->
			<!-- #include virtual = "/inc/admin_footer.asp" -->
		</td>
	</tr>
</table>
</body>
</html>
<div id="work" style="position:absolute; width:0; left:0; top:0; height:1; z-index:1; visibility:hidden;">
	<iframe name="nullframe" src="about:blank" scrolling="yes" frameborder="0" style="width:500; background-color:black;"></iframe>
</div>
<%	dbc() %>
