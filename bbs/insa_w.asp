<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: insa_w.asp - 인사발령
'************************************************************************************
	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	bbs_id						= 200							'100-공지/200-인사발령/300-자료/400-사진자료/500-브리핑
	seq							= SQLI(Request("seq"))
	cd1							= SQLI(Request("cd1"))
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1
	If flag = "" Then flag = "W"

	serverPath = Server.MapPath(PATH_INSA)
	webPath = PATH_INSA

	If flag <> "W" Then
		rso()
		SQL = " SELECT * FROM bbst010 " _
			& " WHERE bbs_id = "& bbs_id &" AND cid = '"& USER_COMP &"' AND seq = "& seq
		rs.open SQL, dbcon
		If Not rs.eof Then
			cid					= rs("cid")
			title				= rs("title")
			uid					= rs("uid")
			noti_yn				= rs("noti_yn")
			atm_yn				= rs("atm_yn")
			rgdt				= rs("rgdt")
			contents			= rs("contents")
		End If
		rsc()
	End If

	If flag <> "W" and cid <> USER_COMP Then Call AlertGo("정보가 없습니다.", "/bbs/insa.asp")
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSave").click(function (){		//저장
		goSave();
	});
	$("#btnList").click(function (){		//목록
		$("#fm1").attr({action:"insa.asp", method:"post", target:""}).submit();
	});
});
function goSave(){
	if(fnValidation($("#fm1"))) return;		//유효성 체크
	$("#fm1").attr({action:"insa_x.asp", method:"post", target:""}).submit();
}
function delFile(){
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
		document.fm1.flag.value = "delFile";
		document.fm1.action = "insa_x.asp";
		document.fm1.method = "post";
		document.fm1.target = "nullframe";
		document.fm1.submit();
	}
}
function make(){
	var len = document.fm1.filecnt.options[document.fm1.filecnt.selectedIndex].value;
	txtbox = " ";
	for (i=0; i<len; i++){
		txtbox = txtbox + "<input type='file' name='upFile' class='' style='width:550px;'><br>";
	}
	layer1.innerHTML = txtbox;
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

<form name="fm1" id=fm1 method="post" enctype="multipart/form-data">
<input type="hidden" name="seq" id=seq value="<%=seq%>" />
<input type="hidden" name="cd1" id=cd1 value="<%=cd1%>" />
<input type="hidden" name="cd2" id=cd2 value="<%=cd2%>" />
<input type="hidden" name="page" id=page value="<%=page%>" />
<input type="hidden" name="flag" id=flag value="<%=flag%>" />

						<table width=100% border="0" cellspacing="0" cellpadding="0" class="pr50">
							<tr>
								<td class="pb20">인사정보 > 인사발령</td>
							</tr>
							<tr>
								<td>
									<div class="mt10 mb10">
										<span>
										</span>
										<span class="frt"></span>
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
											<th width=180><label>제목</label><em class="fc4 ml5">*</em></th>
											<td height=50>
												<input type="text" name="title" id="title" maxlength="200" style="width:95%;" value="<%=title%>" />
											</td>
										</tr>
										<!--
										<tr>
											<td class="rg pr10" colspan="2">
												<input type="checkbox" name="sms" id="sms" value="Y" onClick="mpop5('sms.asp','ev','center',610,500);" class="vm" />
												<label for="sms">문자발송</label>
											</td>
										</tr>
										<tr>
											<th><label>상단공지</label></th>
											<td>
												<input type="checkbox" name="noti_yn" id=noti_yn value="Y" class="mr10" <%If noti_yn = "Y" Then%>checked<%End If%> />
												<label for=noti_yn>게시판 상단에 별도의 공간을 두고 보여집니다.</label>
											</td>
										</tr>
										//-->
										<tr>
											<th><label>상시공지</label></th>
											<td>
												<input type="checkbox" name="atm_yn" id=atm_yn value="Y" class="mr10" <%If atm_yn = "Y" Then%>checked<%End If%> />
												<label for=atm_yn>왼쪽 하단에 항상 보여집니다.</label>
											</td>
										</tr>
										<tr>
											<th><label>내용</label><em class="fc4 ml5">*</em></th>
											<td>
												<textarea name="contents" id="contents" class="" style="width:95%;height:120px;"><%=contents%></textarea>
											</td>
										</tr>
<%
		If seq <> "" Then
			rso()
			SQL = " SELECT file_id, seq, file_path, file_nm, file_sz, file_wd, ext "_
				& " FROM bbst011 " _
				& "	WHERE bbs_id = "& bbs_id &" AND seq = "& seq
			rs.open SQL, dbcon, 3

			pCnt = rs.RecordCount
			If pCnt <> 0 Then
%>
										<tr height=34>
											<th>첨부파일</th>
											<td class="pt10">
<%
				While Not rs.eof
					ext = rs("ext")
					sz = rs("file_sz")
					change_file = ChangeFile(ext)
					ext_img = getFileImg(ext)
%>
												<a href="/data/insa/<%=rs("file_nm")%>" target="_blank" title="파일크기 : <%=FormatNumber(Round(sz),0)%>KB">
												<!-- <a href="/inc/dld0.asp?path=INSA&file=<%=rs("file_nm")%>" title="파일크기 : <%=FormatNumber(Round(sz),0)%>KB"> -->
												<img src="<%=ext_img%>" class="vm">&nbsp;<%=rs("file_nm")%></a>
												<input type="checkbox" name="cbox" value="<%=rs("file_id")%>"><br>
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
											<td style="padding:5px 0;">
												<select name="filecnt" onchange="make();" style="width:70px;">
													<option value="0">0</option>
													<option value="1">1</option>
													<option value="2">2</option>
													<option value="3">3</option>
												</select>
												<span id="layer1" class="db mt5 mb3"></span>
											</td>
										</tr>
<%		End If %>
										<tr>
											<td colspan="2" height="1" bgcolor="#b2bdd5"></td>
										</tr>
										<tr>
											<td colspan="2" height="5"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
						<div class="mt10 ct pb50">
							<button type="button" id=btnSave class="btn01">저장</button>
							<button type="button" id=btnList onclick="location='insa.asp?page=<%=page%>&cd1=<%=cd1%>&cd2=<%=cd2%>'" class="">목록</button>
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
