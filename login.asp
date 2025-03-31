<!-- #include virtual = "/inc/mHeader.asp" -->
<%
'************************************************************************************
'* 화면명	: login.asp
'************************************************************************************
%>
<%
	uip							= Request.ServerVariables("REMOTE_ADDR")
	uip							= Left(uip,InStr(9,uip,"."))

	If USER_ID <> "" Then
		Call noAlertGo("/bbs/notice.asp")
		Response.End
	End If

	preURL						= SQLI(Request("preURL"))
'	Response.Write "value : "& Request.ServerVariables("REMOTE_ADDR") &"<br>"
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#uid").bind("keyup", function(){
		$(this).val($(this).val().toLowerCase());
		if($(this).val().length != 0){		//빈 값이 아닐때
			if($(this).val().replace(/[^ㄱ-ㅎ가-힣]/g,'').length == 0){	//한글변경이 없으면
			}else{
				alert("한글은 입력할 수 없습니다.");
				$("#uid").val("");
				event.preventDefault();
			}
		}
	});
	$("#passwd").keypress(function(event){
		if(event.which == 13){
			chkQr();
			//chkLogin();
		}
	});
});
function init(){
	var f = document.fm1;
	if (f.uid.value != ""){
		f.passwd.focus();
	} else {
		f.uid.focus();
	}
	getLocation();
}
window.onload = init;
function chkLogin(){ //로그인
	if (document.fm1.uid.value == ""){
		alert("아이디를 입력하세요.");
		document.fm1.uid.focus();
		return;
	}
	if (document.fm1.passwd.value == ""){
		alert("비밀번호를 입력하세요.");
		document.fm1.passwd.focus();
		return;
	}
	fm1.action = "<%=httpsRoot%>/login_x.asp";
	fm1.submit();
}
function chkQr(){ //QR코드 생성
	if (document.fm1.uid.value == ""){
		alert("아이디를 입력하세요.");
		document.fm1.uid.focus();
		return;
	}
	if (document.fm1.passwd.value == ""){
		alert("비밀번호를 입력하세요.");
		document.fm1.passwd.focus();
		return;
	}
	fm1.action = "/qr.asp?uid="+ $("#uid").val();
	fm1.submit();
}
function pop_find(){
	var sw = screen.width / 2;
	var sh = screen.height / 2;
	var ww = 300;
	var wh = 130;
	var px = sw - (ww / 2);
	var py = sh - (wh / 2);
	window.open('checkPassword.asp','','width='+ww+',height='+wh+',left='+px+',top='+py+',resizable=no,scrollbars=no,status=no,width=500,height=190')
}
function getLocation() {
	if (navigator.geolocation) { // GPS를 지원하면
		navigator.geolocation.getCurrentPosition(function(position) {
//			alert(position.coords.latitude + '/' + position.coords.longitude);
		}, function(error) {
			console.error(error);
		}, {
			enableHighAccuracy: false,
			maximumAge: 0,
			timeout: Infinity
		});
	} else {
		alert('GPS를 지원하지 않습니다');
	}
}
function my_device_info(info_array){
 var str = "";
 str += "\ndeviceuid : "+ info_array['deviceuid']; // 기기 고유번호
 str += "\napp_version : "+ info_array['app_version']; // 앱버젼
 str += "\napp_version_code : "+ info_array['app_version_code']; // 앱버젼코드  // 완전 웃김... 반드시 문자열로 변환해줘야  값이 전달된다...
 str += "\nappname : "+ info_array['appname']; // APP이름
 str += "\nappversion : "+ info_array['appversion']; // APP버전
 str += "\nplatform : "+ info_array['platform']; // 운영체제
 str += "\ndevicetoken : "+ info_array['devicetoken'];
 str += "\ndevicename : "+ info_array['devicename']; // 제조사명
 str += "\ndevicemodel : "+ info_array['devicemodel']; // 디바이스 모델넘버
 str += "\ndeviceversion : "+ info_array['deviceversion']; // 디바이스 버전
 str += "\npushalert : "+ info_array['pushalert']; // 알림
 str += "\npushsound : "+ info_array['pushsound']; // 알림사운드
 str += "\nhp_num : "+ info_array['hp_num']; // 핸드폰번호
 str += "\ndevelopment : "+ info_array['development']; // 개발자 및 배포판
	alert(str);
}
function getIP(json) {
//	document.write("IP address: ", json.ip);
}
</script>
<script type="application/javascript" src="https://ipinfo.io/?format=jsonp&callback=getIP"></script>
</head>


<body onLoad="init();">

<form name="fm1" id=fm1 method="post">
<input type="hidden" name="preURL" id="preURL" value="<%=preURL%>" />
<input type="hidden" name="mode" id="mode" value="login_prc" />

<div style="width:100%;" class="ct">
	<div style="width:260px;margin:0 auto; margin-top:150px;">
		<span class="ff fb f50 ls"><span title="CREATE">C</span>.<span title="READ">R</span>.<span title="UPDATE">U</span>.<span title="DELETE">D.</span></span>
	</div>
	<div style="width:260px;margin:0 auto;" class="mt30 mb3">
		<input type="text" name="uid" id=uid maxlength="20" style="width:255px;" tabindex="1" value="<%=Trim(Request.Cookies("OK_ID"))%>" autocomplete="" placeholder="아이디" />
	</div>
	<div style="width:260px;margin:0 auto;">
		<input type="password" name="passwd" id=passwd maxlength="20" style="width:255px;" tabindex="2" autocomplete="newpassword" placeholder="비밀번호" />
	</div>
	<div style="width:260px;margin:0 auto;" class="mt5">
		<button type="button" onclick="chkLogin()" class="btn01 mb3" style="width:100%;">로그인</button>
	</div>
	<div style="width:260px;margin:0 auto;" class="mt5">
		<div style="width:260px;">
			<div class="di" style="margin-left:-20px;">
				<input type="radio" name="att" id="in" value="in" checked /><label for="in" class="vm pt">출근</label>
				<input type="radio" name="att" id="out" value="out" /><label for="out" class="vm pt">퇴근</label>
			</div>
			<div class="di">
				<button type="button" onclick="chkQr()" class="btn03 mb3 frt hint--info hint--top" aria-label="출퇴근 기록을 위한 QR코드를 생성합니다." style="width:50%;">QR코드 생성</button>
			</div>
		</div>
	</div>
	<div style="width:260px;margin:0 auto;" class="mt5">
		<div style="width:260px;">
			<button type="button" onclick="location.href='<%=httpsRoot%>/sys/info01.asp'" class="btn04" style="width:49%;">사용안내</button>
			<button type="button" onclick="location.href='<%=httpsRoot%>/bbs5/rqst_w.asp'" style="width:49%;" class="hint--info hint--top" aria-label="서비스 사용신청을 합니다.">사용신청</button>
		</div>
	</div>
	<div style="width:260px;margin:0 auto;" class="mt5">
		<div style="width:260px;">
			<button type="button" onclick="location.href='<%=httpsRoot%>/mem/preJoin.asp'" style="width:100%;" class="hint--info hint--top btn03" aria-label="신규 사용자를 등록합니다.">사용자등록</button>
		</div>
		<!-- <a href="javascript:app_get_device_info('my_device_info')">디바이스 정보 알아내기</a> -->
		<!-- <button type="button" onclick="location='/login_success.asp'" class="btn01 mb3" style="width:100%;">인덱스</button> -->
	</div>
</div><!--
<div style="width:100%;" class="ct">
	<div style="width:500px; height:300px; margin:0 auto; margin-top:50px; border:1px #fff dotted;">
		<span class="ct">광고영역</span>
	</div>
</div> -->
</form>
</body>
</html>