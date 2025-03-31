<!-- #include virtual = "/inc/header.asp" -->
<%
'************************************************************************************
'* 화면명	: notice.asp - 공지사항
'************************************************************************************
'	Call checkLevel(USER_AUTH, 100, Request.ServerVariables("PATH_INFO"))

	bbs_id						= 100							'100-공지/200-인사발령/300-자료/400-사진자료/500-일간브리핑/900-작업
	cd1							= SQLI(Request("cd1"))			'검색조건
	cd2							= SQLI(Request("cd2"))			'검색단어
	page						= SQLI(Request("page"))
	flag						= SQLI(Request("flag"))

	If cd1 = "" Then cd1 = "title"
	If page = "" Then page = 1

	If cd2 <> "" Then					'검색조건이 있는 경우
		param = " WHERE "& cd1 &" LIKE '%"& cd2 &"%' AND bbs_id = "& bbs_id
	Else								'검색조건이 없는 경우
		param = " WHERE bbs_id = "& bbs_id
	End If

	'게시물 개수
	rso()
	SQL = " SELECT COUNT(*) FROM bbst010 "& param
	rs.open SQL, dbcon, 3
		recordcount = rs(0)
	rsc()

	totalpage = Int((recordcount-1)/15) + 1
	pageParam = "cd1="& cd1 &"&cd2="& cd2
%>

<script type="text/javascript">
$(document).ready(function(){
	$("#btnSearch").click(function (){		//조회
		goSearch();
	});
	$("#btnReset").click(function (){		//초기화
		document.location = "notice.asp";
	});
	$("#btnWrite").click(function (){		//글쓰기
		$("#fm1").attr({action:"notice_w.asp", method:"POST"}).submit();
	});
});
function goSearch(){
	$("#fm1").attr({action:"notice.asp", method:"post"}).submit();
}
function writeKeyDown(){
	if(event.keyCode == 13)	goSearch();
}
</script>


<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<table width=100% border="0" cellspacing="0" cellpadding="0" class="mt20">
				<tr>
					<td width=230 valign="top">
					</td>
					<td valign="top">
<svg width="30" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg"><!-- 메뉴01 -->
    <path fill="currentColor" d="M120 230h496c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8H120c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8zm0 424h496c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8H120c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8zm784 140H120c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8h784c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8zm0-424H120c-4.4 0-8 3.6-8 8v56c0 4.4 3.6 8 8 8h784c4.4 0 8-3.6 8-8v-56c0-4.4-3.6-8-8-8z"/>
</svg>
<svg width="30" viewBox="0 0 1024 1024" xmlns="http://www.w3.org/2000/svg"><!-- 타깃01 -->
    <path fill="currentColor" d="M952 474H829.8C812.5 327.6 696.4 211.5 550 194.2V72c0-4.4-3.6-8-8-8h-60c-4.4 0-8 3.6-8 8v122.2C327.6 211.5 211.5 327.6 194.2 474H72c-4.4 0-8 3.6-8 8v60c0 4.4 3.6 8 8 8h122.2C211.5 696.4 327.6 812.5 474 829.8V952c0 4.4 3.6 8 8 8h60c4.4 0 8-3.6 8-8V829.8C696.4 812.5 812.5 696.4 829.8 550H952c4.4 0 8-3.6 8-8v-60c0-4.4-3.6-8-8-8zM512 756c-134.8 0-244-109.2-244-244s109.2-244 244-244s244 109.2 244 244s-109.2 244-244 244z"/>
    <path fill="currentColor" d="M512 392c-32.1 0-62.1 12.4-84.8 35.2c-22.7 22.7-35.2 52.7-35.2 84.8s12.5 62.1 35.2 84.8C449.9 619.4 480 632 512 632s62.1-12.5 84.8-35.2C619.4 574.1 632 544 632 512s-12.5-62.1-35.2-84.8C574.1 404.4 544.1 392 512 392z"/>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 더하기01 -->
    <g fill="currentColor" fill-rule="evenodd" clip-rule="evenodd">
        <path d="M2 12C2 6.477 6.477 2 12 2s10 4.477 10 10s-4.477 10-10 10S2 17.523 2 12Zm10-8a8 8 0 1 0 0 16a8 8 0 0 0 0-16Z"/>
        <path d="M13 7a1 1 0 1 0-2 0v4H7a1 1 0 1 0 0 2h4v4a1 1 0 1 0 2 0v-4h4a1 1 0 1 0 0-2h-4V7Z"/>
    </g>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 더하기02 -->
    <g fill="currentColor">
        <path d="M12 6a1 1 0 0 1 1 1v4h4a1 1 0 1 1 0 2h-4v4a1 1 0 1 1-2 0v-4H7a1 1 0 1 1 0-2h4V7a1 1 0 0 1 1-1Z"/>
        <path fill-rule="evenodd" d="M5 22a3 3 0 0 1-3-3V5a3 3 0 0 1 3-3h14a3 3 0 0 1 3 3v14a3 3 0 0 1-3 3H5Zm-1-3a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1V5a1 1 0 0 0-1-1H5a1 1 0 0 0-1 1v14Z" clip-rule="evenodd"/>
    </g>
</svg><svg width="30" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><!-- 열쇠01 -->
    <path fill="currentColor" d="M16.95 2.58a4.985 4.985 0 0 1 0 7.07c-1.51 1.51-3.75 1.84-5.59 1.01l-1.87 3.31l-2.99.31L5 18H2l-1-2l7.95-7.69c-.92-1.87-.62-4.18.93-5.73a4.985 4.985 0 0 1 7.07 0zm-2.51 3.79c.74 0 1.33-.6 1.33-1.34a1.33 1.33 0 1 0-2.66 0c0 .74.6 1.34 1.33 1.34z"/>
</svg>
<svg width="30" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><!-- 설정바퀴 -->
    <path fill="currentColor" d="M18 12h-2.18c-.17.7-.44 1.35-.81 1.93l1.54 1.54l-2.1 2.1l-1.54-1.54c-.58.36-1.23.63-1.91.79V19H8v-2.18c-.68-.16-1.33-.43-1.91-.79l-1.54 1.54l-2.12-2.12l1.54-1.54c-.36-.58-.63-1.23-.79-1.91H1V9.03h2.17c.16-.7.44-1.35.8-1.94L2.43 5.55l2.1-2.1l1.54 1.54c.58-.37 1.24-.64 1.93-.81V2h3v2.18c.68.16 1.33.43 1.91.79l1.54-1.54l2.12 2.12l-1.54 1.54c.36.59.64 1.24.8 1.94H18V12zm-8.5 1.5c1.66 0 3-1.34 3-3s-1.34-3-3-3s-3 1.34-3 3s1.34 3 3 3z"/>
</svg>
<svg width="30" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><!-- 집 -->
    <path fill="currentColor" d="m16 8.5l1.53 1.53l-1.06 1.06L10 4.62l-6.47 6.47l-1.06-1.06L10 2.5l4 4v-2h2v4zm-6-2.46l6 5.99V18H4v-5.97zM12 17v-5H8v5h4z"/>
</svg>
<svg width="30" viewBox="0 0 27 32" xmlns="http://www.w3.org/2000/svg"><!-- 플라스크 -->
    <path fill="currentColor" d="M17.5 1a.5.5 0 0 0 0-1h-9a.5.5 0 0 0 0 1h9zM.99 27.635c-1.074 1.511-.954 2.498-.664 3.06C.633 31.29 1.433 32 3.5 32h20c2.067 0 2.867-.71 3.174-1.306c.29-.562.41-1.549-.648-3.034l-6.219-9.95l-.088-.124C19.272 16.948 17 13.022 17 9.75V2.5a.5.5 0 0 0-.5-.5h-7a.5.5 0 0 0-.5.5v7.25c0 3.491-2.465 7.957-2.493 8.005L.99 27.635zm24.796 2.6c-.251.487-1.084.765-2.286.765h-20c-1.202 0-2.035-.278-2.286-.765c-.229-.444-.02-1.162.62-2.066l4.999-8.948l.007.004c.91.525 1.851 1.068 3.719 1.068s2.81-.542 3.719-1.066c.833-.48 1.619-.934 3.22-.934c.607 0 1.133.075 1.617.21l6.08 9.712c.611.858.82 1.576.591 2.02zM10 9.75V3h6v6.75c0 2.84 1.516 6.042 2.404 7.602a7.862 7.862 0 0 0-.905-.059c-1.869 0-2.81.542-3.719 1.066c-.833.48-1.619.934-3.22.934c-1.601 0-2.387-.454-3.219-.934l-.019-.011l.046-.082C7.393 18.226 10 13.58 10 9.75z"/>
</svg>
<svg width="30" viewBox="0 0 1200 1200" xmlns="http://www.w3.org/2000/svg"><!-- 사람01 -->
    <path fill="currentColor" d="M605.096 480c-135.542-2.098-239.082-111.058-239.999-240C367.336 105.667 477.133.942 605.096 0c135.662 5.13 239.036 108.97 240.001 240c-2.668 134.439-111.907 239.09-240.001 240zm194.043 49.788c170.592 1.991 257.094 151.63 257.881 301.269V1200H889.784l.001-324.254c-4.072-22.416-19.255-30.018-33.164-27.82c-13.022 2.059-24.929 12.701-25.56 27.82V1200h-464.67V875.746c-3.557-21.334-17.128-29.537-30.331-28.709c-14.138.889-27.853 12.135-28.393 28.709V1200h-164.68V831.057c-.98-159.475 99.901-300.087 259.137-301.269h397.015z"/>
</svg>
<svg width="30" viewBox="0 0 1200 1200" xmlns="http://www.w3.org/2000/svg"><!-- 사람02 -->
    <path fill="currentColor" d="M.008.015v1199.984H1200V987.564h-130.664V870.733H1200V658.377h-130.664V541.545H1200V329.282h-130.664V212.451H1200l-.016-212.45H0l.008.014zm534.665 209.56c95.784 0 173.373 77.68 173.373 173.466c0 67.881-38.969 126.625-95.78 155.109l222.013 132.926h2.696v187.473H232.28V671.076h2.784L456.982 538.15c-56.812-28.484-95.78-87.229-95.78-155.109c0-95.785 77.68-173.466 173.466-173.466h.005z"/>
</svg>
<svg width="30" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><!-- 사람03 -->
    <path fill="currentColor" d="M15.989 19.129C16 17 13.803 15.74 11.672 14.822c-2.123-.914-2.801-1.684-2.801-3.334c0-.989.648-.667.932-2.481c.12-.752.692-.012.802-1.729c0-.684-.313-.854-.313-.854s.159-1.013.221-1.793c.064-.817-.398-2.56-2.301-3.095c-.332-.341-.557-.882.467-1.424c-2.24-.104-2.761 1.068-3.954 1.93c-1.015.756-1.289 1.953-1.24 2.59c.065.78.223 1.793.223 1.793s-.314.17-.314.854c.11 1.718.684.977.803 1.729c.284 1.814.933 1.492.933 2.481c0 1.65-.212 2.21-2.336 3.124C.663 15.53 0 17 .011 19.129C.014 19.766 0 20 0 20h16s-.014-.234-.011-.871zM17 10V7h-2v3h-3v2h3v3h2v-3h3v-2h-3z"/>
</svg>
<svg width="30" viewBox="0 0 1664 1792" xmlns="http://www.w3.org/2000/svg"><!-- 사람04 -->
    <path fill="currentColor" d="M1028 644q0 107-76.5 183T768 903t-183.5-76T508 644q0-108 76.5-184T768 384t183.5 76t76.5 184zm-48 220q46 0 82.5 17t60 47.5t39.5 67t24 81t11.5 82.5t3.5 79q0 67-39.5 118.5T1056 1408H480q-66 0-105.5-51.5T335 1238q0-48 4.5-93.5T358 1046t36.5-91.5t63-64.5t93.5-26h5q7 4 32 19.5t35.5 21t33 17t37 16t35 9T768 951t39.5-4.5t35-9t37-16t33-17t35.5-21t32-19.5zm684-256q0 13-9.5 22.5T1632 640h-96v128h96q13 0 22.5 9.5t9.5 22.5v192q0 13-9.5 22.5t-22.5 9.5h-96v128h96q13 0 22.5 9.5t9.5 22.5v192q0 13-9.5 22.5t-22.5 9.5h-96v224q0 66-47 113t-113 47H160q-66 0-113-47T0 1632V160Q0 94 47 47T160 0h1216q66 0 113 47t47 113v224h96q13 0 22.5 9.5t9.5 22.5v192zm-256 1024V160q0-13-9.5-22.5T1376 128H160q-13 0-22.5 9.5T128 160v1472q0 13 9.5 22.5t22.5 9.5h1216q13 0 22.5-9.5t9.5-22.5z"/>
</svg>
<svg width="30" viewBox="0 0 1200 1200" xmlns="http://www.w3.org/2000/svg"><!-- 메뉴 -->
    <path fill="currentColor" d="M0 99.202v178.006h1200V99.202H0zm0 274.53v178.006h1200V373.732H0zm0 274.53v178.006h1200V648.262H0zm0 274.53v178.006h1200V922.792H0z"/>
</svg>
<svg width="30" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><!-- 다운로드 -->
    <path fill="currentColor" d="M13 11h-2V3H9v8H7l3 3l3-3zm4.4 4H2.6c-.552 0-.6.447-.6 1c0 .553.048 1 .6 1h14.8c.552 0 .6-.447.6-1c0-.553-.048-1-.6-1z"/>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 느낌표01 -->
    <g id="evaAlertCircleOutline0">
        <g id="evaAlertCircleOutline1">
            <g id="evaAlertCircleOutline2" fill="currentColor">
                <path d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2Zm0 18a8 8 0 1 1 8-8a8 8 0 0 1-8 8Z"/>
                <circle cx="12" cy="16" r="1"/>
                <path d="M12 7a1 1 0 0 0-1 1v5a1 1 0 0 0 2 0V8a1 1 0 0 0-1-1Z"/>
            </g>
        </g>
    </g>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 느낌표02 -->
    <g id="evaAlertCircleFill0">
        <g id="evaAlertCircleFill1">
            <path id="evaAlertCircleFill2" fill="currentColor" d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2Zm0 15a1 1 0 1 1 1-1a1 1 0 0 1-1 1Zm1-4a1 1 0 0 1-2 0V8a1 1 0 0 1 2 0Z"/>
        </g>
    </g>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 느낌표03 -->
    <g id="evaAlertCircleFill0">
        <g id="evaAlertCircleFill1">
            <path id="evaAlertCircleFill2" fill="currentColor" d="M12 2a10 10 0 1 0 10 10A10 10 0 0 0 12 2Zm0 15a1 1 0 1 1 1-1a1 1 0 0 1-1 1Zm1-4a1 1 0 0 1-2 0V8a1 1 0 0 1 2 0Z"/>
        </g>
    </g>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 느낌표04 -->
    <g id="evaAlertTriangleFill0">
        <g id="evaAlertTriangleFill1">
            <path id="evaAlertTriangleFill2" fill="currentColor" d="M22.56 16.3L14.89 3.58a3.43 3.43 0 0 0-5.78 0L1.44 16.3a3 3 0 0 0-.05 3A3.37 3.37 0 0 0 4.33 21h15.34a3.37 3.37 0 0 0 2.94-1.66a3 3 0 0 0-.05-3.04ZM12 17a1 1 0 1 1 1-1a1 1 0 0 1-1 1Zm1-4a1 1 0 0 1-2 0V9a1 1 0 0 1 2 0Z"/>
        </g>
    </g>
</svg>
<svg width="30" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg"><!-- 느낌표05 -->
    <path fill="#2196F3" d="M37 40H11l-6 6V12c0-3.3 2.7-6 6-6h26c3.3 0 6 2.7 6 6v22c0 3.3-2.7 6-6 6z"/>
    <g fill="#fff">
        <path d="M22 20h4v11h-4z"/>
        <circle cx="24" cy="15" r="2"/>
    </g>
</svg>
<svg width="30" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><!-- 느낌표06 -->
    <path fill="currentColor" d="m91.17 81.374l.006-.004l-.139-.24c-.068-.128-.134-.257-.216-.375l-37.69-65.283c-.611-1.109-1.776-1.87-3.133-1.87c-1.47 0-2.731.887-3.285 2.153l-.004-.002L9.312 80.529l.036.021a3.553 3.553 0 0 0-.82 2.257a3.59 3.59 0 0 0 3.588 3.59h75.767a3.59 3.59 0 0 0 3.589-3.589c0-.511-.11-.994-.302-1.434zm-41.135-1.757c-2.874 0-5.201-2.257-5.201-5.13c0-2.874 2.326-5.2 5.201-5.2c2.803 0 5.13 2.325 5.13 5.2a5.123 5.123 0 0 1-5.13 5.13zm5.13-45.367v28.299h-.002l.002.016c0 1.173-.95 2.094-2.094 2.094l-.014-.001v.001h-6.093c-1.174 0-2.123-.921-2.123-2.094l.002-.016h-.002V34.326c-.001-.026-.008-.051-.008-.077c0-1.117.865-1.996 1.935-2.078v-.016h6.288v.001c1.149.007 2.074.897 2.103 2.039h.005v.055h.001z"/>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 물음표01 -->
    <path fill="currentColor" d="M12.086 6.496h-.035a3.83 3.83 0 0 0-2.512.935l.005-.004a2.959 2.959 0 0 0-1.191 2.461v-.004h2.073a1.319 1.319 0 0 1 .5-1.135l.003-.002c.282-.27.665-.437 1.087-.437h.001l.075-.002c.383 0 .731.153.985.402c.255.257.412.611.412 1.001l-.001.046v-.002l.001.043c0 .392-.15.75-.396 1.017l.001-.001l-1.247 1.251a2.474 2.474 0 0 0-.545.863l-.006.017c-.109.222 0 .56 0 1.018v.861h1.412v-.589c.009-.407.162-.777.411-1.061l-.002.002c.08-.091.235-.203.367-.334s.32-.286.505-.463s.353-.32.467-.437c.171-.178.336-.368.49-.566l.012-.016a2.59 2.59 0 0 0 .569-1.626l-.002-.092v.004a2.898 2.898 0 0 0-.958-2.317l-.003-.002a3.644 3.644 0 0 0-2.488-.829h.008zm-.128 9.136h-.018c-.354 0-.675.144-.907.377a1.208 1.208 0 0 0-.386.887v.013v-.001v.012c0 .349.152.662.393.878l.001.001c.237.227.559.367.914.367h.02h-.001h.019c.354 0 .675-.144.906-.376c.238-.223.386-.539.386-.889v-.021c0-.349-.152-.663-.393-.879L12.891 16a1.309 1.309 0 0 0-.912-.368h-.022z"/>
    <path fill="currentColor" d="M12 0C5.373 0 0 5.373 0 12s5.373 12 12 12s12-5.373 12-12S18.627 0 12 0zm0 21.882c-5.458 0-9.882-4.425-9.882-9.882S6.543 2.118 12 2.118c5.458 0 9.882 4.425 9.882 9.882c0 5.458-4.425 9.882-9.882 9.882z"/>
</svg>
<svg width="30" viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg"><!-- 달력01 -->
    <path fill="currentColor" d="M37 38H13c-1.7 0-3-1.3-3-3V13c0-1.7 1.1-3 2.5-3H14v2h-1.5c-.2 0-.5.4-.5 1v22c0 .6.4 1 1 1h24c.6 0 1-.4 1-1V13c0-.6-.3-1-.5-1H36v-2h1.5c1.4 0 2.5 1.3 2.5 3v22c0 1.7-1.3 3-3 3z"/>
    <path fill="currentColor" d="M17 14c-.6 0-1-.4-1-1V9c0-.6.4-1 1-1s1 .4 1 1v4c0 .6-.4 1-1 1zm16 0c-.6 0-1-.4-1-1V9c0-.6.4-1 1-1s1 .4 1 1v4c0 .6-.4 1-1 1zm-13-4h10v2H20zm-8 6h26v2H12zm22 4h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm16 4h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm20 4h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm16 4h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2zm-4 0h2v2h-2z"/>
</svg>
<svg width="30" viewBox="0 0 256 256" xmlns="http://www.w3.org/2000/svg"><!-- 달력02 -->
    <g id="galaCalendar0" fill="none" stroke="currentColor" stroke-dasharray="none" stroke-miterlimit="4" stroke-width="16">
        <path id="galaCalendar1" stroke-linecap="butt" stroke-linejoin="miter" stroke-opacity="1" d="M 31.999978,31.999961 H 224.00004"/>
        <path id="galaCalendar2" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="m 15.999975,47.999965 -3e-6,176.000055"/>
        <path id="galaCalendar3" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="M 240.00002,47.999965 V 224.00002"/>
        <path id="galaCalendar4" stroke-linecap="round" stroke-linejoin="round" d="m 31.999978,31.999961 c -8.836576,0 -16.000003,7.163446 -16.000003,16.000004"/>
        <path id="galaCalendar5" stroke-linecap="round" stroke-linejoin="round" d="m 224.00004,31.999961 c 8.83657,-4e-6 15.99998,7.163443 15.99998,16.000004"/>
        <path id="galaCalendar6" stroke-linecap="butt" stroke-linejoin="miter" stroke-opacity="1" d="M 224.00004,240.00002 H 31.999978"/>
        <path id="galaCalendar7" stroke-linecap="round" stroke-linejoin="round" d="m 224.00004,240.00002 a 16.000004,16.000004 0 0 0 15.99998,-16"/>
        <path id="galaCalendar8" stroke-linecap="round" stroke-linejoin="round" d="m 31.999978,240.00002 a 16.000004,16.000004 0 0 1 -16.000011,-16"/>
        <path id="galaCalendar9" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="M 128.00001,47.999965 V 15.999962"/>
        <path id="galaCalendara" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="M 160.00003,47.999965 V 15.999962"/>
        <path id="galaCalendarb" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="M 192.00002,47.999965 V 15.999962"/>
        <path id="galaCalendarc" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="M 95.999985,47.999965 V 15.999962"/>
        <path id="galaCalendard" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="M 64.000001,47.999965 V 15.999962"/>
        <path id="galaCalendare" stroke-linecap="round" stroke-linejoin="round" stroke-opacity="1" d="M 15.999975,95.999972 H 240.00002"/>
    </g>
</svg>
<svg width="30" viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg"><!-- 이전01 -->
    <path fill="currentColor" d="M25 42c-9.4 0-17-7.6-17-17S15.6 8 25 8s17 7.6 17 17s-7.6 17-17 17zm0-32c-8.3 0-15 6.7-15 15s6.7 15 15 15s15-6.7 15-15s-6.7-15-15-15z"/>
    <path fill="currentColor" d="M25.3 34.7L15.6 25l9.7-9.7l1.4 1.4l-8.3 8.3l8.3 8.3z"/>
    <path fill="currentColor" d="M17 24h17v2H17z"/>
</svg>
<svg width="30" viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg"><!-- 다음01 -->
    <path fill="currentColor" d="M25 42c-9.4 0-17-7.6-17-17S15.6 8 25 8s17 7.6 17 17s-7.6 17-17 17zm0-32c-8.3 0-15 6.7-15 15s6.7 15 15 15s15-6.7 15-15s-6.7-15-15-15z"/>
    <path fill="currentColor" d="M25.3 34.7L15.6 25l9.7-9.7l1.4 1.4l-8.3 8.3l8.3 8.3z"/>
    <path fill="currentColor" d="M17 24h17v2H17z"/>
</svg>
<svg width="30" viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg"><!-- 다운로드01 -->
    <path fill="currentColor" d="M25 42c-9.4 0-17-7.6-17-17S15.6 8 25 8s17 7.6 17 17s-7.6 17-17 17zm0-32c-8.3 0-15 6.7-15 15s6.7 15 15 15s15-6.7 15-15s-6.7-15-15-15z"/>
    <path fill="currentColor" d="m25 34.4l-9.7-9.7l1.4-1.4l8.3 8.3l8.3-8.3l1.4 1.4z"/>
    <path fill="currentColor" d="M24 16h2v17h-2z"/>
</svg>
<svg width="30" viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg"><!-- 업로드01 -->
    <path fill="currentColor" d="M25 42c-9.4 0-17-7.6-17-17S15.6 8 25 8s17 7.6 17 17s-7.6 17-17 17zm0-32c-8.3 0-15 6.7-15 15s6.7 15 15 15s15-6.7 15-15s-6.7-15-15-15z"/>
    <path fill="currentColor" d="M33.3 26.7L25 18.4l-8.3 8.3l-1.4-1.4l9.7-9.7l9.7 9.7z"/>
    <path fill="currentColor" d="M24 17h2v17h-2z"/>
</svg>
<svg width="30" viewBox="0 0 50 50" xmlns="http://www.w3.org/2000/svg"><!-- 종01 -->
    <path fill="currentColor" d="M42 36c-6.5 0-7.4-6.3-8.2-11.9C32.9 17.9 32.1 12 25 12s-7.9 5.9-8.8 12.1C15.4 29.7 14.5 36 8 36v-2c4.6 0 5.3-3.9 6.2-10.1c.9-6.2 2-13.9 10.8-13.9s9.9 7.7 10.8 13.9C36.7 30.1 37.4 34 42 34v2z"/>
    <path fill="currentColor" d="M25 40c-2.8 0-5-2.2-5-5h2c0 1.7 1.3 3 3 3s3-1.3 3-3h2c0 2.8-2.2 5-5 5z"/>
    <path fill="currentColor" d="M8 34h34v2H8zm19-24c0 1.1-.9 1.5-2 1.5s-2-.4-2-1.5s.9-2 2-2s2 .9 2 2z"/>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 메뉴01 -->
    <g id="feAppMenu0" fill="none" fill-rule="evenodd" stroke="none" stroke-width="1">
        <g id="feAppMenu1" fill="currentColor">
            <path id="feAppMenu2" d="M16 16h4v4h-4v-4Zm-6 0h4v4h-4v-4Zm-6 0h4v4H4v-4Zm12-6h4v4h-4v-4Zm-6 0h4v4h-4v-4Zm-6 0h4v4H4v-4Zm12-6h4v4h-4V4Zm-6 0h4v4h-4V4ZM4 4h4v4H4V4Z"/>
        </g>
    </g>
</svg>
<svg width="30" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg"><!-- 메뉴02 -->
    <path fill="#D1C4E9" d="M38 7H10c-1.1 0-2 .9-2 2v6c0 1.1.9 2 2 2h28c1.1 0 2-.9 2-2V9c0-1.1-.9-2-2-2zm0 12H10c-1.1 0-2 .9-2 2v6c0 1.1.9 2 2 2h28c1.1 0 2-.9 2-2v-6c0-1.1-.9-2-2-2zm0 12H10c-1.1 0-2 .9-2 2v6c0 1.1.9 2 2 2h28c1.1 0 2-.9 2-2v-6c0-1.1-.9-2-2-2z"/>
    <circle cx="38" cy="38" r="10" fill="#43A047"/>
    <path fill="#DCEDC8" d="M42.5 33.3L36.8 39l-2.7-2.7l-2.1 2.2l4.8 4.8l7.8-7.8z"/>
</svg>
<svg width="30" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg"><!-- 메뉴03 -->
    <path fill="currentColor" d="M81.232 15.389H18.769a3.407 3.407 0 0 0-3.407 3.407v3.143a3.407 3.407 0 0 0 3.407 3.407h62.463a3.407 3.407 0 0 0 3.407-3.407v-3.143a3.407 3.407 0 0 0-3.407-3.407zm0 19.755H18.769a3.407 3.407 0 0 0-3.407 3.407v3.143a3.407 3.407 0 0 0 3.407 3.407h62.463a3.407 3.407 0 0 0 3.407-3.407v-3.143a3.408 3.408 0 0 0-3.407-3.407zm0 19.755H18.769a3.407 3.407 0 0 0-3.407 3.407v3.143a3.407 3.407 0 0 0 3.407 3.407h62.463a3.407 3.407 0 0 0 3.407-3.407v-3.143a3.408 3.408 0 0 0-3.407-3.407zm0 19.755H18.769a3.407 3.407 0 0 0-3.407 3.407v3.143a3.407 3.407 0 0 0 3.407 3.407h62.463a3.407 3.407 0 0 0 3.407-3.407v-3.143a3.408 3.408 0 0 0-3.407-3.407z"/>
</svg>
<svg width="30" viewBox="0 0 2048 2048" xmlns="http://www.w3.org/2000/svg"><!-- 체크01 -->
    <path fill="currentColor" d="m1902 196l121 120L683 1657L25 999l121-121l537 537L1902 196z"/>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 이미지첨부01 -->
    <path fill="currentColor" d="M23 4v2h-3v3h-2V6h-3V4h3V1h2v3h3zm-8.5 7a1.5 1.5 0 1 0-.001-3.001A1.5 1.5 0 0 0 14.5 11zm3.5 3.234l-.513-.57a2 2 0 0 0-2.976 0l-.656.731L9 9l-3 3.333V6h7V4H6a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-7h-2v3.234z"/>
</svg>
<svg width="30" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><!-- 더하기01 -->
    <path fill="none" stroke="currentColor" stroke-width="2" d="M12 22V2M2 12h20"/>
</svg>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<!-- footer -->
<!-- #include virtual = "/inc/_footer.asp" -->
