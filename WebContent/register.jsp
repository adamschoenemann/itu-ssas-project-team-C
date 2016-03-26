<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB" 
%>

<%-- TODO: same here, input validation has to be added --%>
<%-- TODO: introduce a password policy --%>
<%-- TODO: don't save the password without salt and in plain text --%>

<% 
	String user = request.getParameter("username");   
    String pwd = request.getParameter("password");
   
    Connection con = DB.getConnection();
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM users WHERE username='"
    		+ user + "'");
    if (rs.next()) {
    	// Have a result; username already taken.  	
    	response.sendRedirect("index.jsp?create_failure=1");       
    } else {
    	// No result; user failed to authenticate; try again.
    	st.executeUpdate("INSERT INTO users (username, password) values ('"
    			+ user + "', '" + pwd + "')");
    	rs = st.executeQuery("SELECT * FROM users WHERE username='" + user + "'");
    	rs.next();
    	session.setAttribute("user", rs.getString(1));
    	session.setAttribute("username", user);
    	response.sendRedirect("main.jsp");
    }
%>