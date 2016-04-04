<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB"
%>

<%-- TODO: same here, input validation has to be added --%>
<%-- OPTIONAL TODO: introduce a password policy --%>
<%-- TODO: session state validation --%>
<%-- TODO: set CSRF token in session --%>

<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.util.Scanner" %>


<%

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

	// characters allowed for the salt string
	String SALTCHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	
	StringBuffer saltBuffer = new StringBuffer();
	java.util.Random rnd = new java.util.Random();
	
	// build a random 16 chars salt
	while (saltBuffer.length() < 16){
		int index = (int) (rnd.nextFloat() * SALTCHARS.length());
		saltBuffer.append(SALTCHARS.substring(index, index+1));
	}
	String salt = saltBuffer.toString();	
    
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
    //System.out.println("password:              " + pwd);
    //System.out.println("password + salt:       " + saltedPwd);
    //System.out.println("hash(password + salt): " + generatedPassword);

    Connection con = DB.getConnection();
 	// TODO: use parameterized statement
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery("SELECT * FROM users WHERE username='"
    		+ user + "'");
    if (rs.next() || !validInput) {
    	// Have a result; username already taken.
        // TODO: use session state rather than request parameters for failure info
    	response.sendRedirect("index.jsp?create_failure=1");
    } else {
    	// No result, so we can create a new user
    	st.executeUpdate("INSERT INTO users (username, salt, password) values ('"
    			+ user + "', '" + salt + "', '" + generatedPassword + "')");
    	rs = st.executeQuery("SELECT * FROM users WHERE username='" + user + "'");
    	rs.next();
    	session.setAttribute("user", rs.getString(1));
    	session.setAttribute("username", user);
    	//session.setAttribute("salt", salt);			// not sure if we need this
    	response.sendRedirect("main.jsp");
    }
%>