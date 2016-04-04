<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- TODO: session state validation --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>SSAS TeamC Photo Sharing Webapp</title>
	</head>
<body>
	<h1>SSAS TeamC Photo Sharing Webapp</h1>
	
	<h2>Existing users:</h2>
	
	<% if (request.getParameter("login_failure") != null) { %>
	<h3>Login failure. Try again?</h3>
	<% } %>
	
	<form method="post" action="login.jsp">
        <input type="hidden" name="csrfPreventionSalt" value='<%= request.getAttribute("csrfPreventionSalt") %>'/>
        Username: <input type="text" name="username"><br>
                <%-- TODO: use password type field --%>
        Password: <input type="password" name="password"><br>
        <input type="reset" value="Reset">
        <input type="submit" value="Login">
    </form>
	
	<h2>---------------------------------</h2>
	
	<h2>New users:</h2>
	
	<% if (request.getParameter("create_failure") != null) { %>
	<h3>Username already taken. Try again?</h3>
	<% } %>
	
	<form method="post" action="register.jsp">
        <input type="hidden" name="csrfPreventionSalt" value='<%= request.getAttribute("csrfPreventionSalt") %>'/>
        Username: <input type="text" name="username" /><br>
        Password: <input type="password" name="password" /><br>
        <input type="reset" value="Reset">
        <input type="submit" value="Create">
    </form>
	
	<h3>password policy:</h3>
	<h4>- contain at least one digit</h4>
	<h4>- contain at least one lower case character</h4>
	<h4>- contain at least one upper case character</h4>
	<h4>- contain at least on special character from [ @ # $ % ! . ]</h4>
	<h4>- between 8 and 40 characters long</h4>

>>>>>>> e3389d29cbc5b56e993997a26e28d0712fc99231
</body>
</html>
