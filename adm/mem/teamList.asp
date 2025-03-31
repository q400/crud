<!-- #include virtual = "/_db.asp" -->
<%
'************************************************************************************
'* 화면명	: teamList.asp - 팀 목록 (ajax)
'************************************************************************************
	dept						= Request("dept")			'부서

	dbo()
	rso()
	SQL = "	SELECT x.idx, x.code_id, y.code_nm " _
		& " FROM codt020 x LEFT OUTER JOIN codt010 y ON x.code_id = y.code_id " _
		& " WHERE y.code_se = '팀' " _
		& " AND x.cid = '"& USER_COMP &"' " _
		& " AND up_cd = '"& dept &"' " _
		& " ORDER BY idx ASC "
'	SQL = "	SELECT idx, code_nm FROM codt010 WHERE gubn = '팀' AND idx LIKE '"& LEFT(dept, 1) &"%' ORDER BY idx ASC "
	Response.Write "<br>"& SQL &"<br>"
	rs.open SQL, dbcon, 3
	Do Until rs.eof
'		Response.Write "<select name='team' id='team' style='width:180px;'>"
		Response.Write "<option value='"& rs("code_id") &"'>"& rs("code_nm") &"</option>"
'		Response.Write "</select>"
		rs.MoveNext
	Loop
	rsc()
'	AND idx LIKE '"& LEFT(dept,1) &"%'
'	Response.Write " AND idx LIKE '"& LEFT(idx, 1) &"%' "
'	Response.Write "data : "& idx &","& codeNm
	dbc()
%>