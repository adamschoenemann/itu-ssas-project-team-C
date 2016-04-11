<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB"
%>


<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.security.NoSuchAlgorithmException" %>
<%@ page import="java.util.Scanner" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>

<%

    if (request.getSession().getAttribute("user") != null) {
        response.sendRedirect("main");
        return;
    }
    // only allow POST method
    if (request.getMethod() != "POST") {
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
	if(!scanUser.hasNext("^[a-zA-Z0-9_-]+$")){
        validInput = false;
	}

	// close the user scanner
	scanUser.close();

	Pattern pattern;
	Matcher matcher;

	// password policy
	// ---------------
	// contain at least one digit
	// contain at least one lower case character
	// contain at least one upper case character
	// contain at least on special character from [ @ # $ % ! . ]
	// between 8 and 40 characters long

    final String SPECIAL_CHAR_PATTERN = "[^A-Za-z0-9]";
	final String PASSWORD_PATTERN =
        "((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*" + SPECIAL_CHAR_PATTERN +
        ").{8,40})";

	pattern = Pattern.compile(PASSWORD_PATTERN);
	matcher = pattern.matcher(pwd);

	boolean validPassword = matcher.matches();

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
    String selectUserFromUsers = "SELECT * FROM users WHERE username=?;";
	PreparedStatement ps = con.prepareStatement(selectUserFromUsers);
	ps.setString(1, user);
 	ResultSet rs = ps.executeQuery();

    if (rs.next() || !validInput || !validPassword) {
    	// Have a result; username already taken. Or invalid user name or password.
        session.setAttribute("create_failure", validInput ? validPassword ? "Username already taken" : "Password not valid" : "User name not valid");
        String contextPath = request.getContextPath();
    	response.sendRedirect(contextPath);
    } else {
    	// No result, so we can create a new user
    	String addNewUser = "INSERT INTO users (username, salt, password) values (?, ?, ?);";
    	PreparedStatement ps2 = con.prepareStatement(addNewUser);
    	ps2.setString(1, user);
    	ps2.setString(2, salt);
    	ps2.setString(3, generatedPassword);
    	ps2.executeUpdate();

        PreparedStatement ps3 = con.prepareStatement(
            "SELECT id FROM users ORDER BY id DESC LIMIT 1"
        );
        ResultSet rs3 = ps3.executeQuery();
        rs3.next();
        String userId = rs3.getString("id");


    	session.setAttribute("user", userId);
    	session.setAttribute("username", user);
    	//session.setAttribute("salt", salt);			// not sure if we need this
    	response.sendRedirect("main");
    }
%>
