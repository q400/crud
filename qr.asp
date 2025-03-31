<!-- #include virtual = "/inc/mHeader.asp" -->
<!-- #include virtual = "/lib/aes.asp" -->
<%
'************************************************************************************
'* 화면명	: qr.asp
'************************************************************************************
%>
<%
	uid							= LCase(Replace(Request("uid"),"'","''"))
	att							= Replace(Request("att"),"'","''")				'출근/퇴근 구분

	If uid = "" Then
		Call JSalert("아이디가 없습니다.")
		Response.End
	End If

	pwd							= Request("passwd")
	preURL						= SQLI(Request("preURL"))
	uid_len						= Len(uid)
	encrypted					= AESEncrypt(uid, pwd)							'암호화 값

	If uid_len > 19 Then
		Call JSalert("아이디는 20자 이내로 입력하세요.")
		Response.End
	End If

	rso()
	SQL = " SELECT * FROM memt010 WHERE uid = '"& uid &"' AND open_yn = 'Y' "
	rs.open SQL, dbcon
'	Response.Write "<br>"& SQL &"<br>"
	If rs.eof Then
		Call JSAlert("아이디가 존재하지 않거나 미승인 상태입니다.")
		Response.End
	Else
		If encrypted <> rs("pwd") Then
			Call JSAlert("비밀번호가 일치하지 않습니다.")
			Response.End
		Else
			Session.Contents("USER_ID")			= uid
			Session.Contents("USER_NAME")		= rs("unm")
			Session.Contents("USER_COMP")		= rs("cid")
			cid									= rs("cid")
			Session.Contents("USER_HP")			= rs("hp1") & rs("hp2") & rs("hp3")
			hp									= rs("hp2") & rs("hp3")
			Session.Contents("USER_ULVL")		= rs("ulvl")
			Session.Contents("USER_AUTH")		= CInt(Right(rs("auth"),4))			'우측 4자리 숫자로 변환
			Session.Contents("USER_DEPT")		= rs("dept")
			Session.Contents("USER_TEAM")		= rs("team")
			Session.Contents("USER_PIC")		= rs("pic")

			If Session.Contents("USER_AUTH") > 10 Then
				SQL = " INSERT INTO logt010 (uid, conn_ip, conn_tm) VALUES ('"& uid &"', '"& Request.ServerVariables("REMOTE_ADDR") &"', getdate()) "
				dbcon.Execute SQL
			End If
		End If
	End If
	rsc()

	rso()
	SQL = " SELECT TOP 1 getdate() tm, " _
		& "			CONVERT(CHAR(19),getdate(),120) d0, " _
		& "			CONVERT(CHAR(8),getdate(),112) d1, " _
		& "			REPLACE(CONVERT(CHAR(8),getdate(),108),':','') d2, " _
		& "			CONVERT(CHAR(10),getdate(),23) d3, " _
		& "			CONVERT(CHAR(8),getdate(),108) d4 " _
		& " FROM cmpt010 "
	rs.open SQL, dbcon
	If Not rs.eof Then
		tm						= rs("tm") '시간
		d0						= rs("d0") 'yyyy-MM-dd hh:mm:ss
		d1						= rs("d1") 'yyyyMMdd
		d2						= rs("d2") 'hhmmss
		d3						= rs("d3") 'yyyy-MM-dd
		d4						= rs("d4") 'hh:mm:ss
	End If
	rsc()
%>

<html>
<head>
<script type="text/javascript" src="/inc/js/jquery.min.js"></script>
<script type="text/javascript" src="/inc/js/qrcode.js"></script>
</head>

<body>
<div style="border:0px solid #000; width:100%; margin:0 auto;">
	<div id="qrcode" style="margin:0 auto; background-color:#fff;" class="ct"></div>
</div>
<div style="width:100%;" class="ct">
	<div style="margin:0 auto;" class="mt20">
		<svg width="30" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg" onclick="location='/'" class="pt"><!-- 집 -->
			<path fill="currentColor" d="m16 8.5l1.53 1.53l-1.06 1.06L10 4.62l-6.47 6.47l-1.06-1.06L10 2.5l4 4v-2h2v4zm-6-2.46l6 5.99V18H4v-5.97zM12 17v-5H8v5h4z"/>
		</svg>
	</div>
</div>
</body>

<script type="text/javascript">
var latitude;
var longitude;

sessionStorage.setItem("authId", "<%=uid%>");

var storageData = sessionStorage.getItem("authId");
//console.log("___________ "+ storageData);
$(document).ready(function(){
	function success(position) {
		latitude  = position.coords.latitude;
		longitude = position.coords.longitude;
		console.log("__________ latitude = "+ latitude);
		console.log("__________ longitude = "+ longitude);
		//window.location = url + "?uid=<%=USER_ID%>&lat="+ latitude +"&lon="+ longitude;

		var qrcode = new QRCode(document.getElementById("qrcode"), {
			text: "https:crud.kr/qr_x.asp?uid=<%=uid%>&att=<%=att%>&cid=<%=cid%>&hp=<%=hp%>&d1=<%=d3%>&d2=<%=d4%>&ip=<%=Request.ServerVariables("REMOTE_ADDR")%>&lat="+ latitude +"&lon="+ longitude,
			width: 128,
			height: 128,
			colorDark : "#000000",
			colorLight : "#ffffff",
			correctLevel : QRCode.CorrectLevel.H
		});

		$("#qrcode > img").css({"margin":"auto","padding":"10px 0"});
	}
	function error(position) {
		//HTTPS가 아니거나 위치수집 동의를 안 할 경우
		alert('HTTPS가 아니거나 위치수집 동의가 되어있지 않습니다.');
	}

	if(!navigator.geolocation) {
		//Geolocation API를 지원하지 않는 브라우저일 경우
		alert('GPS를 지원하지 않습니다.');
	} else {
		//Geolocation API를 지원하는 브라우저일 경우
		var optn = {enableHighAccuracy : true, timeout : 30000, maximumage: 0};
		navigator.geolocation.getCurrentPosition(success, error, optn);
	}
})
</script>
</html>
<%	dbc() %>