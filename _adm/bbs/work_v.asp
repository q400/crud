<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: work_v.asp - 작업게시판
'************************************************************************************
	Call checkLevel(USER_AUTH, 10, Request.ServerVariables("PATH_INFO"))

	bbs_id						= 500							'500-작업
	seq							= SQLI(Request("seq"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1

	If seq = "" Then
		Call noAlertGo("work.asp?page="& page &"&"& pageParam)
	End If

	rso()
	SQL = "	SELECT cid, title, uid, path, sttus, cnt, rgdt, contents "_
		& " FROM bbst050 "_
		& " WHERE bbs_id = "& bbs_id &" AND seq = "& seq
	rs.open SQL, dbcon, 3
	If Not rs.eof Then
		cid						= rs("cid")
		title					= rs("title")
		uid						= rs("uid")
		path					= rs("path")		'헤당경로
		sttus					= rs("sttus")		'작업진행상태
		cnt						= rs("cnt")
		rgdt					= rs("rgdt")
		contents				= rs("contents")
	End If
	rsc()

	SQL = " UPDATE bbst050 SET cnt = cnt + 1 WHERE bbs_id = "& SQLI(bbs_id) &" AND seq = "& seq
	dbcon.Execute SQL

	rso()
	SQL = "	SELECT COUNT(*) FROM bbst012 " _
		& " WHERE tbl_id = 'bbst050' " _
		& " AND seq = "& seq _
		& " AND uid = '"& USER_ID &"' "
	rs.open SQL, dbcon, 3
	If Not rs.eof Then
		intReadCnt = rs(0)
	End If

	If intReadCnt = 0 Then									'열람자 확인
		If USER_ID <> "" Then
			SQL = " INSERT INTO bbst012 (tbl_id, seq, uid) " _
				& "	VALUES ('bbst050', "& seq &", '"& USER_ID &"') "
			dbcon.Execute SQL
		End If
	End If
	rsc()

	pageParam = "cd1="& cd1 &"&cd2="& cd2
%>

<script type="text/javascript">
function goDelete(){				//삭제
	if (!confirm("정말 삭제하시겠습니까?")){
		return;
	}
	$("#flag").val("D");
	$("#fm1").attr({action:"work_x.asp", method:"post", target:"nullframe"}).submit();
}
function saveReply(){
	if ($("#note").val().length < 1){
		alert("최소 1자 이상은 입력하세요.");
		$("#note").focus();
	} else if ($("#note").val().length > 500){
		alert("내용이 너무 깁니다.");
		$("#note").focus();
	} else {
		$("#flag").val("R");
		$("#fm1").attr({action:"work_x.asp", method:"post", target:"nullframe"}).submit();
	}
}
function replyDelete(vIdx){
	if(!confirm("삭제하겠습니까?")){
		return;
	}
	$("#idx").val(vIdx);
	$("#flag").val("RD");
	$("#fm1").attr({action:"work_x.asp", method:"post", target:"nullframe"}).submit();
}
function writeKeyDown(){
	if(event.keyCode == 13)	saveReply();
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

<form name=fm1 id=fm1 method="post" enctype="multipart/form-data">
<input type="hidden" name="seq" id=seq value="<%=seq%>" />
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
<input type="hidden" name="flag" id=flag />
<input type="hidden" name="oldFile" id=oldFile value="<%=file1%>" />
<input type="hidden" name="idx" id=idx />

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
										<tr>
											<td height="2" bgcolor="#b2bdd5" colspan="17"></td>
										</tr>
										<tr height=40>
											<th>제목</th>
											<td class="pl10 fcy" colspan=5><b><%=title%></b></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan="9"></td>
										</tr>
										<tr height=40>
											<th width=150>작성자</th>
											<td class="pl10"><%=cmpInfo(cid,"comp_nm")%> > <%=memInfo(uid,"unm")%></td>
											<th width=150>등록일자</th>
											<td width=300 class="pl10"><%=rgdt%></td>
											<th width=150>조회수</th>
											<td width=150 class="pl10"><%=cnt%></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=9></td>
										</tr>
										<tr height=40>
											<th>헤당경로</th>
											<td class="pl10 fcy" colspan=5><a href="<%=path%>" target="_blank"><b><%=path%></b></a></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan="9"></td>
										</tr>
										<tr height=150>
											<td colspan=9 valign="top" style="padding:15 30 15 30;"><%=db2html(contents)%></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=9></td>
										</tr>
										<tr height="25">
											<th>진행상태</th>
											<td style="padding:10px 0;">
												<%=sttus%>
											</td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=9></td>
										</tr>
										<tr height=40>
											<td width="100" align="center">첨부파일</td>
											<td colspan=8>
												<div class="mt10 mb10">
<%
		If seq <> "" Then
			rso()
			SQL = " SELECT file_id, file_path, file_nm, file_sz, file_wd, ext "_
				& " FROM bbst051 " _
				& "	WHERE bbs_id = "& bbs_id &" AND seq = "& seq
			rs.open SQL, dbcon, 3

			While Not rs.eof
				ext = rs("ext")
				sz = rs("file_sz")
				change_file = ChangeFile(ext)
				ext_img = getFileImg(ext)
				If LCase(ext) = "gif" Or LCase(ext) = "jpg" Or LCase(ext) = "png" Or LCase(ext) = "bmp" Then
%>
													<span class="mr20 vt">
														<a href="javascript:Popup('/sys/imgPop01.asp?fileId=<%=rs("file_id")%>&bbsId=100&tblNm=bbst051',0,0,0,50,1,830);">
														<img src="<%=PATH_WORK%>/<%=rs("file_nm")%>" <%If rs("file_wd") < 200 Then%>width="<%=rs("file_wd")%>"<%Else%>width="200"<%End If%> class="vm"></a>
													</span>
<%				Else %>
													<span class="mr20 vt">
														<a href="/data/work/<%=rs("file_nm")%>" target="_blank" title="파일크기:<%=FormatNumber(Round(sz)/1000,0)%>KB"><img src="<%=ext_img%>" class="vm">
														<!-- <a href="/inc/dld0.asp?path=WORK&file=<%=rs("file_nm")%>" title="파일크기:<%=FormatNumber(Round(sz)/1000,0)%>KB"><img src="<%=ext_img%>" class="vm"> -->
														<%=rs("file_nm")%></a>
													</span>
<%
				End If
				rs.MoveNext
			Wend
			rsc()
		End If
%>
												</div>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td height="2" bgcolor="#b2bdd5"></td>
							</tr>
						</table>
						<div class="ct mt20">
<%
		If USER_ID = uid Or USER_ID = "q400" Then
%>
							<button type="button" onclick="goDelete()" class="btn01">삭제</button>
							<button type="button" onclick="location='work_w.asp?seq=<%=seq%>&page=<%=page%>&<%=pageParam%>&flag=M'" class="btn02">수정</button>
<%
		End If
%>
							<button type="button" onclick="location='work.asp?page=<%=page%>&<%=pageParam%>'" class="">목록</button>
						</div>
						<div class="mt10 mb10">
							<span class="blue fcb fb">열람자목록</span>
						</div>
						<div class="mt10 mb10 mr50">
<%
				rso()
				SQL = "	SELECT uid, rgdt FROM bbst012 WHERE tbl_id = 'bbst050' AND seq = "& seq &" ORDER BY rgdt "
				rs.open SQL, dbcon, 3
				While Not rs.eof
%>
							<span <%If USER_AUTH <= 10 Then%>onMouseover="ddrivetip('<%=rs("rgdt")%>',160)" onMouseout="hideddrivetip();"<%End If%> class="mr10"><%=memInfo(rs("uid"),"unm")%></span>
<%
					rs.MoveNext
				Wend
				rsc()
%>
						</div>
						<div class="mt10 mb10">
							<span class="blue fcb fb">한줄댓글</span>
						</div>
						<div class="mt10 mb10 mr50">
<%
				rso()
				SQL = "	SELECT idx, cid, rgid, rgdt, note FROM bbst013 WHERE bbs_id = '500' AND cid = '"& USER_COMP &"' AND seq = "& seq &" ORDER BY rgdt "
				rs.open SQL, dbcon, 3
				While Not rs.eof
					If rs("rgid") = "webmaster" Then
%>
							<p class="mr20 fc4"><%=rs("note")%></p>
<%
					Else
%>
							<p class="mr20 fcy"><%=rs("note")%></p>
<%
					End If
%>
							<p class="mt5 mr10 mb10 f12 fc2">
								└ <%=memInfo(rs("rgid"),"unm")%> [<%=rs("rgdt")%>]
<%
					If USER_ID = rs("rgid") Then
%>
								<img src="/img/icon/delete02.gif" class="vm pt" onclick="replyDelete('<%=rs("idx")%>');" title="삭제" />
<%
					End If
%>
							</p>
<%
					rs.MoveNext
				Wend
				rsc()
%>
						</div>
						<div class="mt10 mb10">
							<span class="blue fcb fb">댓글쓰기</span>
						</div>
						<div class="mt10 mb10 mr50">
							<input type="text" name="note" id="note" onkeydown="writeKeyDown();" style="width:90%;height:;" />
							<button type="button" id=btnReply onclick="saveReply()" class="">저장</button>
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
