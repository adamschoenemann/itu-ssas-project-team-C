<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB"
%>

<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.util.Scanner" %>

<%

    // only allow POST method
    if (request.getMethod() != "POST") {
        response.sendRedirect("main");
        return;
    }

    if (request.getSession().getAttribute("user") != null) {
        response.sendRedirect("main");
        return;
    }

    String user = request.getParameter("username");
    String pwd = request.getParameter("password");

    // create new scanner, that checks the username input
	Scanner scanUser = new Scanner(user);
    boolean validInput = true;

    //System.out.println(!scanUser.hasNext("^[a-zA-Z0-9-_]+$"));

	// allow only alphanumeric usernames including dashes and underscores
	if(!scanUser.hasNext("^[a-zA-Z0-9-_]+$")){
        validInput = false;
	}

	// close the user scanner
	scanUser.close();

    Connection con = DB.getConnection();

    String selectUserIdAndSalt = "SELECT id, salt FROM users WHERE username=?;";
 	PreparedStatement ps = con.prepareStatement(selectUserIdAndSalt);
    ps.setString(1, user);
    ResultSet rs1 = ps.executeQuery();

    if (rs1.next() && validInput) {

    	// get salt of found user
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

        String selectUserId = "SELECT id FROM users WHERE username=? AND password=?;";
        PreparedStatement ps2 = con.prepareStatement(selectUserId);
        ps2.setString(1, user);
        ps2.setString(2, generatedPassword);
        ResultSet rs2 = ps2.executeQuery();

        if (rs2.next()) {
        	// Have a result; user is authenticated.
        	session.setAttribute("user", rs2.getString(1));
        	session.setAttribute("username", user);
        	//session.setAttribute("salt", salt);			// not sure if we need this
        	response.sendRedirect("main");
        } else {
        	// No result; user failed to authenticate; try again.
            session.setAttribute("login_failure", "Wrong password");
            String contextPath = request.getContextPath();
        	response.sendRedirect(contextPath);
        }

    } else {
    	// No result; user failed to authenticate; try again.
    	String contextPath = request.getContextPath();
    	session.setAttribute("login_failure", "Wrong username");
        response.sendRedirect(contextPath);
    }
%>
