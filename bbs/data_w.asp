<%
'************************************************************************************
'*  윈도우 명		: data_w.asp
'************************************************************************************
%>
<!-- #include virtual = "/inc/header.asp" -->
<%
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	bbs_id						= 2								'1-공지/2-자료실/10-회의록/30-사진/50-종합자료
	seq							= SQLI(Request("seq"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1
	If flag = "" Then flag = "W"

	serverPath = Server.MapPath(PATH_DATA)
	webPath = PATH_DATA

	If seq <> "" Then
		rso()
		SQL = "SELECT * FROM _cbbst010 WHERE bbs_id = "& bbs_id &" AND seq = "& seq
		rs.open SQL, dbcon
		If flag = "M" Then
			uid				= rs("uid")
			title			= rs("title")
			ddate			= rs("ddate")
			contents		= rs("contents")
		End If
		rsc()
	End If
%>

<script type="text/javascript">
<!--
function goSave(){
	var f = document.fm1;
	if (f.title.value == ""){
		alert("제목을 입력하세요.");
		f.title.focus();
		return;
	}
	if (f.contents.value == ""){
		alert("내용을 입력하세요.");
		f.contents.focus();
		return;
	}
	f.action = "data_x.asp";
	f.method = "post";
	f.target = "nullframe";
	f.submit();
}
function delPic(){
	vCheckCnt = 0
	if (document.fm1.cbox.length > 1){			//체크박스가 여러개 있을때
		for ( var i=0 ; i < document.fm1.cbox.length ; i++ ){
			if ( document.fm1.cbox[i].checked == true ){
				vCheckCnt++;
			}
		}
	} else {									//체크박스가 하나일때
		if (document.fm1.cbox.checked == true){
			vCheckCnt++;
		}
	}
	if (vCheckCnt == 0){
		alert("삭제할 사진을 선택하세요.");
		return;
	}
	if (confirm("선택한 사진을 삭제할까요?")){
		document.fm1.flag.value = "delpic";
		document.fm1.action = "data_x.asp";
		document.fm1.method = "post";
		document.fm1.target = "nullframe";
		document.fm1.submit();
	}
}
function make(){
	var len = document.fm1.filecnt.options[document.fm1.filecnt.selectedIndex].value;
	txtbox = " ";
	for (i=0; i<len; i++){
		txtbox = txtbox + "<input type='file' name='upFile' class='bx' style='width:550;'><br>";
	}
	layer1.innerHTML = txtbox;
}
//-->
</script>


<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
	<tr height="100%">
		<td valign="top">
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
<input type="hidden" name="flag" value="<%=flag%>">

						<table width="750" border="0" cellspacing="0" cellpadding="0">
							<tr height="22">
								<td colspan="2">자료관리 > 자료실</td>
							</tr>
							<tr>
								<td colspan="2" height="1" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td colspan="2" height="2" bgcolor="#f4f4f4"></td>
							</tr>
							<tr>
								<td colspan="2" height="5"></td>
							</tr>
							<tr>
								<th width="150">제목</th>
								<td width="600">
									<input type="text" name="title" class="bx" style="width:550px;" value="<%=title%>" />
								</td>
							</tr>
							<tr>
								<th>내용</th>
								<td width="600">
									<textarea name="contents" class="tarea" style="width:550px;height:150px;"><%=contents%></textarea>
								</td>
							</tr>
							<tr>
								<td colspan="2" height="3"></td>
							</tr>
<%
		If seq <> "" Then
			rso()
			SQL = " SELECT	photo_id, bbs_id, seq, file_path, file_nm, file_sz, file_wd FROM _cbbst011 " _
				& " WHERE	bbs_id = "& bbs_id &" AND seq = "& seq
			rs.open SQL, dbcon, 3

			pCnt = rs.RecordCount
			If pCnt <> 0 Then
%>
							<tr height="25">
								<th>첨부파일</th>
								<td width="600">
<%
				While Not rs.eof
					file_ext = Right(rs("file_nm"), 3)
					change_file = ChangeFile(file_ext)
					ext_img = getFileImg(file_ext)
%>
									<a href="/data/download0.asp?path=notice&file=<%=rs("file_nm")%>" title="파일크기:<%=FormatNumber(rs("file_sz")/1000,0)%>KB"><img src="<%=ext_img%>" align="absmiddle">&nbsp;<%=rs("file_nm")%></a>
									<input type="checkbox" name="cbox" value="<%=rs("photo_id")%>"><br>
<%
					rs.MoveNext
				Wend
%>
								</td>
							</tr>
<%
			End If
			rsc()
		End If
		If file_cnt = 0 Then
%>
							<tr height="25">
								<th>파일첨부</th>
								<td width="600" style="padding:3 0 3 0;">
									<select name="filecnt" onChange="make();" style="width:50;">
									<option value="0">0</option>
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									</select>
									<br>
									<span id="layer1"></span>
								</td>
							</tr>
<%		End If %>
							<tr>
								<td colspan="2" height="2" bgcolor="#f4f4f4"></td>
							</tr>
							<tr>
								<td colspan="2" height="1" bgcolor="#b2bdd5"></td>
							</tr>
							<tr>
								<td colspan="2" height="5"></td>
							</tr>
							<tr>
								<td colspan="2" align="right">
									<a href="data.asp?page=<%=page%>&cd1=<%=cd1%>&cd2=<%=cd2%>"><img src="/img/btn/bn_list.gif"></a>
									<a href="javascript:goSave();"><img src="/img/btn/bn_ok.gif"></a>
								</td>
							</tr>
						</table>
</form>
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
<div id="work" style="position:absolute; width:0; left:0; top:0; height:1; z-index:1; visibility:hidden;">
	<iframe name="nullframe" src="about:blank" scrolling="yes" frameborder="0" style="width:500; background-color:black;"></iframe>
</div>
<%	dbc() %>
