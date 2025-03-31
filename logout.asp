<%
	Response.Cookies ("USER")("ID") = ""
	Response.Cookies ("USER")("NAME") = ""
	Response.Cookies ("USER")("HP") = ""
	Response.Cookies ("USER")("PART") = ""
	Response.Cookies ("USER")("LEVEL") = ""
	Response.Cookies ("USER")("AUTH") = ""
	Response.Cookies ("OK")("ID") = ""
	Response.Cookies ("USER").Expires = "July 31, 1980"

	Session.Contents.RemoveAll:
	Session.Abandon

	Response.Redirect "/"
%>