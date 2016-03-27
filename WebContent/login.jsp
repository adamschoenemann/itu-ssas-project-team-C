<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB"
%>

<%-- TODO: input validation has to be added --%>
<%-- TODO: session state validation --%>
<%-- TODO: set CSRF token in session --%>

<%
    String user = request.getParameter("username");   
    String pwd = request.getParameter("password");
   
    Connection con = DB.getConnection();
    // TODO: use parameterized statement
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT id FROM users WHERE username='"
    		+ user + "' AND " + "password='" + pwd + "'");
    if (rs.next()) {
    	// Have a result; user is authenticated.
    	session.setAttribute("user", rs.getString(1));
    	session.setAttribute("username", user);
    	response.sendRedirect("main.jsp");
    } else {
    	// No result; user failed to authenticate; try again.
        // TODO: use session state rather than request parameters for failure info
    	response.sendRedirect("index.jsp?login_failure=1");
    }
%>
