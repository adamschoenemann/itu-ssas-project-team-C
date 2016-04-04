<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB"
%>

<%-- TODO: input validation has to be added --%>
<%-- TODO: session state validation --%>
<%-- TODO: set CSRF token in session --%>

<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>

<%
    String user = request.getParameter("username");   
    String pwd = request.getParameter("password");
   
    Connection con = DB.getConnection();
    // TODO: use parameterized statement
    Statement st1 = con.createStatement();
    
    ResultSet rs1 = st1.executeQuery("SELECT id,salt FROM users WHERE username='" + user + "'");
    
    if (rs1.next()) {
    	String salt = rs1.getString(2);
    	
    	// add salt to password
        String saltedPwd = pwd + salt;
    	
        // use SHA-512 to hash the salted password
        String generatedPassword = null;
        try {

            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(salt.getBytes("UTF-8"));
            byte[] bytes = md.digest(saltedPwd.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for(int i=0; i< bytes.length ;i++)
            {
                sb.append(Integer.toString((bytes[i] & 0xff) + 0x100, 16).substring(1));
            }
            generatedPassword = sb.toString();
        } 
        catch (NoSuchAlgorithmException e) 
        {
            e.printStackTrace();
        }
    	
        // only for debugging!!!
    	//System.out.println("salt from database:    " + salt);
    	//System.out.println("password + salt:       " + saltedPwd);
        //System.out.println("hash(password + salt): " + generatedPassword);
        
        Statement st2 = con.createStatement();
        
        ResultSet rs2 = st2.executeQuery("SELECT id FROM users WHERE username='"
        		+ user + "' AND " + "password='" + generatedPassword + "'");
        if (rs2.next()) {
        	// Have a result; user is authenticated.
        	session.setAttribute("user", rs2.getString(1));
        	session.setAttribute("username", user);
        	//session.setAttribute("salt", salt);	// not sure if we need this
        	response.sendRedirect("main.jsp");
        } else {
        	// No result; user failed to authenticate; try again.
            // TODO: use session state rather than request parameters for failure info
        	response.sendRedirect("index.jsp?login_failure=1");
        }
    	
    } else {
    	// No result; user failed to authenticate; try again.
        // TODO: use session state rather than request parameters for failure info
    	response.sendRedirect("index.jsp?login_failure=1");
    }
%>
