<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: index.asp
'************************************************************************************
%>
<%Response.AddHeader "P3P", "CP=ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC"%>
<%
	uip						= Request.ServerVariables("REMOTE_ADDR")
	uip						= Left(uip,InStr(9,uip,"."))
'	Response.Write "<br>value : "& uip &"<br>"

	If USER_ID = "" Then
		Call noAlertGo("login.asp")
		Response.End
	Else
		Call noAlertGo("main.asp")
		Response.End
	End If
%>

<script>
var url = "https://crud.kr/login_success.asp";
var user_id = "xxxx";
function success(position) {
	const latitude  = position.coords.latitude;
	const longitude = position.coords.longitude;
//	window.location = url + "?uid="+ <%=USER_ID%> +"&lat="+ latitude +"&lon="+ longitude;
}
function error(position) {
	//HTTPS가 아니거나 위치수집 동의를 안 할 경우
	alert('error');
}
if(!navigator.geolocation) {
	//Geolocation API를 지원하지 않는 브라우저일 경우
	alert('GPS를 지원하지 않습니다.');
} else {
	//Geolocation API를 지원하는 브라우저일 경우
	var optn = {enableHighAccuracy : true, timeout : 30000, maximumage: 0};
	navigator.geolocation.getCurrentPosition(success, error,optn);
}
</script>