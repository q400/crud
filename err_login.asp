<html>
<head>
<title>�α��� ����</title>
</head>

<body>
<script>
	tmp = window.location;					//ȣ��� ����â�� �ּ� ex) http://kr.yahoo.com/1.html?a=1&b=1;
	tmp = String(tmp).split('?');			//���İ� �迭�� ���
	tmp = tmp[1].split('&');				//������ ������ �迭�� ���
for (k in tmp) {							//������ ���
	tmp2 = tmp[k].split('=');				//Ű�� ���и�
	eval("var "+tmp2[0]+"=tmp2[1]");
	//document.write(tmp2[0]+' = '+tmp2[1]+'<BR> ');
	if (tmp2[0] == "pType") {
		switch (tmp2[1]) {
			case "NotFind":
				alert("���̵� ã�� �� �����ϴ�. 010-5554-9462(����� ����)���� ���� �ٶ��ϴ�.");
				break;
			case "InvalidPassword":
				alert("��й�ȣ�� ���� �ʽ��ϴ�.");
				break;
			default :
				alert("�߸��� ��û�Դϴ�. �α��� �������� ���ư��ϴ�.");
				break;
		}//switch
		location.href = "login.asp";
	}
}
</script>
</body>
</html>