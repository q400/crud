<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: insa_v.asp - 인사발령
'************************************************************************************
	Call checkLevel(USER_AUTH, 900, Request.ServerVariables("PATH_INFO"))

	bbs_id						= 200							'100-공지/200-인사발령/300-자료/400-사진자료/500-브리핑
	seq							= SQLI(Request("seq"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1

	If seq = "" Then
		Call noAlertGo("insa.asp?page="& page &"&"& pageParam)
	End If

	rso()
	SQL = "	SELECT cid, title, uid, noti_yn, atm_yn, cnt, rgdt, contents "_
		& " FROM bbst010 "_
		& " WHERE bbs_id = "& bbs_id &" AND cid = '"& USER_COMP &"' AND seq = "& seq
	rs.open SQL, dbcon, 3
	If Not rs.eof Then
		cid						= rs("cid")
		title					= rs("title")
		uid						= rs("uid")
		noti_yn					= rs("noti_yn")
		atm_yn					= rs("atm_yn")
		cnt						= rs("cnt")
		rgdt					= rs("rgdt")
		contents				= rs("contents")
	End If
	rsc()

	If flag <> "W" and cid <> USER_COMP Then Call AlertGo("정보가 없습니다.", "/bbs/insa.asp")

	SQL = " UPDATE bbst010 SET cnt = cnt + 1 WHERE bbs_id = "& SQLI(bbs_id) &" AND seq = "& seq
	dbcon.Execute SQL

	rso()
	SQL = "	SELECT COUNT(*) FROM bbst012 " _
		& " WHERE tbl_id = 'bbst010' " _
		& " AND seq = "& seq _
		& " AND uid = '"& USER_ID &"' "
	rs.open SQL, dbcon, 3
	If Not rs.eof Then
		intReadCnt = rs(0)
	End If

	If intReadCnt = 0 Then									'열람자 확인
		If USER_ID <> "" Then
			SQL = " INSERT INTO bbst012 (tbl_id, seq, uid) " _
				& "	VALUES ('bbst010', "& seq &", '"& USER_ID &"') "
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
	$("#fm1").attr({action:"insa_x.asp", method:"post", target:"nullframe"}).submit();
}
function goReply(){
	if ($("#note").val().length < 10){
		alert("최소 10자 이상은 입력하세요.");
		$("#note").focus();
	} else if ($("#note").val().length > 500){
		alert("내용이 너무 깁니다.");
		$("#note").focus();
	} else {
		$("#flag").val("R");
		$("#fm1").attr({action:"insa_x.asp", method:"post", target:"nullframe"}).submit();
	}
}
function opDelete(vSeq){
	var f = document.fm1;
	if(!confirm("삭제하겠습니까?")){
		return;
	}
	$("#re_seq").val(vSeq);
	$("#flag").val("D1");
	$("#fm1").attr({action:"insa_x.asp", method:"post", target:"nullframe"}).submit();
}
</script>


<table width=100% border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
						<!-- #include virtual = "/inc/_left.asp" -->
					</td>
					<td valign="top">

<form name=fm1 id=fm1 method="post" enctype="multipart/form-data">
<input type="hidden" name="seq" id=seq value="<%=seq%>" />
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
<input type="hidden" name="flag" id=flag />
<input type="hidden" name="oldFile" id=oldFile value="<%=file1%>" />
<input type="hidden" name="re_seq" id=re_seq />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">인사정보 > 인사발령</td>
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
											<td class="pl10"><%=memInfo(uid,"unm")%></td>
											<th width=150>등록일자</th>
											<td width=300 class="pl10"><%=rgdt%></td>
											<th width=150>조회수</th>
											<td width=150 class="pl10"><%=cnt%></td>
										</tr>
										<tr>
											<td height="1" bgcolor="#b2bdd5" colspan=9></td>
										</tr>
										<tr height=150>
											<td colspan=9 valign="top" style="padding:15 30 15 30;"><%=db2html(contents)%></td>
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
				& " FROM bbst011 " _
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
														<a href="javascript:Popup('/sys/imgPop01.asp?fileId=<%=rs("file_id")%>&bbsId=100&tblNm=bbst011',0,0,0,50,1,830);">
														<img src="<%=PATH_INSA%>/<%=rs("file_nm")%>" <%If rs("file_wd") < 200 Then%>width="<%=rs("file_wd")%>"<%Else%>width="200"<%End If%> class="vm"></a>
													</span>
<%				Else %>
													<span class="mr20 vt">
														<a href="/data/insa/<%=rs("file_nm")%>" target="_blank" title="파일크기:<%=FormatNumber(Round(sz)/1000,0)%>KB"><img src="<%=ext_img%>" class="vm">
														<!-- <a href="/inc/dld0.asp?path=INSA&file=<%=rs("file_nm")%>" title="파일크기:<%=FormatNumber(Round(sz)/1000,0)%>KB"><img src="<%=ext_img%>" class="vm"> -->
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
<%		If USER_ID = uid Or (USER_AUTH <> "" And USER_AUTH <= 10) Then %>
							<button type="button" onclick="goDelete()" class="btn01">삭제</button>
							<button type="button" onclick="location='insa_w.asp?seq=<%=seq%>&page=<%=page%>&<%=pageParam%>&flag=M'" class="btn02">수정</button>
<%		End If %>
							<button type="button" onclick="location='insa.asp?page=<%=page%>&<%=pageParam%>'" class="">목록</button>
						</div>
						<div class="mt10 mb10">
							<span class="blue fcb fb">열람자목록</span>
						</div>
						<div class="mt10 mb10">
<%
				rso()
				SQL = "	SELECT uid, rgdt FROM bbst012 WHERE tbl_id = 'bbst010' AND seq = "& seq &" ORDER BY rgdt "
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
</form>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
