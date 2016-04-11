<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String csrfToken = request.getAttribute("csrfPreventionToken").toString();
if (session.getAttribute("user") != null) {
    response.sendRedirect("main");
}
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>PhotoShare</title>
	</head>
    <style>
    pre {
        display: inline;
    }
    </style>
<body>
	<h1>PhotoShare</h1>

	<h2>Existing users:</h2>

	<% if (session.getAttribute("login_failure") != null) {
		session.setAttribute("login_failure", null); %>
	<h3>Login failure. Try again?</h3>
	<% } %>

	<form method="post" action="login">
        <input type="hidden" name="csrfPreventionToken" value='<%= csrfToken %>'/>
        Username: <input type="text" name="username"><br>
        Password: <input type="password" name="password"><br>
        <input type="reset" value="Reset">
        <input type="submit" value="Login">
    </form>

	<h2>---------------------------------</h2>

	<h2>New users:</h2>

	<% if (session.getAttribute("create_failure") != null) { %>
	<h3><%= session.getAttribute("create_failure") %>. Try again?</h3>
	<%   session.setAttribute("create_failure", null);
	   } %>

	<form method="post" action="register">
        <input type="hidden" name="csrfPreventionToken" value='<%= csrfToken %>'/>
        Username: <input type="text" name="username" /><br>
        Password: <input type="password" name="password" /><br>
        <input type="reset" value="Reset">
        <input type="submit" value="Create">
    </form>

	<h3>Username policy:</h3>
	<ul>
	<li>contain only letters, digits, dashes and underscores</li>
    </ul>
	<h3>Password policy:</h3>
	<ul>
	<li>contain at least one digit</li>
	<li>contain at least one lower case character</li>
	<li>contain at least one upper case character</li>
	<li>contain at least one special character e.g &nbsp;<pre>@ # $ % ! . </pre></li>
	<li>between 8 and 40 characters long</li>
    </ul>
</body>
</html>
