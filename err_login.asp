<html>
<head>
<title>로그인 에러</title>
</head>

<body>
<script>
	tmp = window.location;					//호출된 현재창의 주소 ex) http://kr.yahoo.com/1.html?a=1&b=1;
	tmp = String(tmp).split('?');			//이후가 배열에 담김
	tmp = tmp[1].split('&');				//변수를 각각을 배열로 담고
for (k in tmp) {							//변수값 출력
	tmp2 = tmp[k].split('=');				//키와 값분리
	eval("var "+tmp2[0]+"=tmp2[1]");
	//document.write(tmp2[0]+' = '+tmp2[1]+'<BR> ');
	if (tmp2[0] == "pType") {
		switch (tmp2[1]) {
			case "NotFind":
				alert("아이디를 찾을 수 없습니다. 010-5554-9462(김수현 부장)으로 문의 바랍니다.");
				break;
			case "InvalidPassword":
				alert("비밀번호가 맞지 않습니다.");
				break;
			default :
				alert("잘못된 요청입니다. 로그인 페이지로 돌아갑니다.");
				break;
		}//switch
		location.href = "login.asp";
	}
}
</script>
</body>
</html>