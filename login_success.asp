<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: login_success.asp
'************************************************************************************
%>
<%
	uid							= SQLI(Request("uid"))
	lat							= SQLI(Request("lat"))
	lon							= SQLI(Request("lon"))
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
			chkLogin();
		}
	});
});
</script>
</head>


<body>

<form name="fm1" id=fm1 method="post">

<div style="width:100%;" class="ct">
	<div style="width:260px;margin:0 auto; margin-top:150px;">
		<span class="ff fb f50 ls"><span title="CREATE">C</span>.<span title="READ">R</span>.<span title="UPDATE">U</span>.<span title="DELETE">D.</span></span>
	</div>
	<div style="width:260px;margin:0 auto;" class="mt30 mb10">
		회원ID: <%=uid%>
	</div>
	<div style="width:360px;margin:0 auto;" class="mb10">
		확인시간: <%=Now()%>
	</div>
	<div style="width:260px;margin:0 auto;" class="mb10">
		위도: <%=lat%> / 경도: <%=lon%>
	</div>
	<div style="width:260px;margin:0 auto;" class="mt20">
<%
	If USER_AUTH <> "" And CInt(USER_AUTH) <= 10 Then
		link = "/_adm/index.asp"
	Else
		link = "/main.asp"
	End If
%>
 		<button type="button" onclick="location.href='<%=link%>'" class="btn01 mb3" style="width:100%;">확인</button>
	</div>
</div>
</form>
</body>
</html>