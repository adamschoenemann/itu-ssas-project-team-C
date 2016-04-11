<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB"
    import = "org.apache.commons.lang.*"
%>

<%
	String user_id = (String) session.getAttribute("user");
    String contextPath = request.getContextPath();
    if (user_id == null) {
        response.sendRedirect(contextPath);
    }
	String username = (String) session.getAttribute("username");
    String csrfToken = (String) request.getAttribute("csrfPreventionToken");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PhotoShare</title>
<style>
* {
	font-family: helvetica-neue, helvetica, arial;
	font-size: 10pt;
}
ul {
    list-style-type: none;
}
</style>
</head>
<body>

<%-- DONE - TODO: username could be a script right now! --%>
<%-- DONE - TODO: html-escape all output to prevent XSS --%>
<h1>PhotoShare</h1>
<p>Hello, <%= StringEscapeUtils.escapeHtml( username ) %>!</p>
<form action="Logout" method="post">
    <input type="hidden" name="csrfPreventionToken" value='<%= csrfToken %>'/>
    <input type="submit" value="Log out" />
</form>
<form method="post" enctype="multipart/form-data" action="Uploader?csrfPreventionToken=<%= csrfToken %>">
	Add a picture:
	<input type="file" name="pic" accept="jpeg">
	<input type="submit" value="Upload!">
</form>
<ul>
<%
	Connection con = DB.getConnection();

    String selectImageIdFromPerms = "SELECT DISTINCT image_id FROM perms WHERE perms.user_id = ?;";
    PreparedStatement ps = con.prepareStatement(selectImageIdFromPerms);
    ps.setString(1, user_id);
    ResultSet image_ids = ps.executeQuery();


    String selectUsernameFromUsersJoinedImages =
    		"SELECT username FROM users INNER JOIN images WHERE users.id = images.owner AND images.id = ?;";
    PreparedStatement ps2 = con.prepareStatement(selectUsernameFromUsersJoinedImages);

    String selectUsernameFromUsersJoinedPerms =
    		"SELECT users.username FROM users INNER JOIN perms " +
    		"WHERE users.id = perms.user_id AND perms.image_id = ?;";
    PreparedStatement ps3 = con.prepareStatement(selectUsernameFromUsersJoinedPerms);

    String selectCommentAndUsernameFromUsersJoinedComments =
    		"SELECT comments.comment, users.username FROM comments INNER JOIN users " +
    	    "WHERE users.id = comments.user_id AND comments.image_id = ?;";
    PreparedStatement ps4 = con.prepareStatement(selectCommentAndUsernameFromUsersJoinedComments);

    while (image_ids.next()) {
    	String image_id = image_ids.getString(1);
        ps2.setString(1, image_id);
        ResultSet other = ps2.executeQuery();
    	other.next();
    	String other_name = other.getString(1);
    	  // pageContext.setAttribute("other_name", other.getString(1));
  %>
	<li> Posted by <%= StringEscapeUtils.escapeHtml( other_name ) %> :<br><br>
	   <img src="Downloader?image_id=<%= image_id %>" width="60%"><br>
	    Shared with:
<%
		// ps3: SELECT users.username FROM users INNER JOIN perms WHERE users.id = perms.user_id AND perms.image_id = ?;
		ps3.setString(1, image_id);
		ResultSet viewers = ps3.executeQuery();
		while (viewers.next()) {
			String sharee = viewers.getString(1);
			//pageContext.setAttribute("sharee",sharee);
			if (sharee.equals (username)) {
				continue;
			}

		// DONE - TODO: html-escape all output to prevent XSS
%>
		<%= StringEscapeUtils.escapeHtml( sharee ) %>
<%
		}
%>
		<br><br>
<%
		// ps4 = SELECT comments.comment, users.username FROM comments INNER JOIN user WHERE users.id = comments.user_id AND comments.image_id = ?
		ps4.setString(1, image_id);
        ResultSet comments = ps4.executeQuery();
        while (comments.next()) {
        	// DONE - TODO: html-escape all output to prevent XSS
%>
		From <%= StringEscapeUtils.escapeHtml( comments.getString(2) ) %>!: "<%= StringEscapeUtils.escapeHtml( comments.getString(1) ) %>" <br>
<%
        }
 %>
 <br>
   			<form action="Comment" method="post">
            <input type="hidden" name="csrfPreventionToken" value='<%= csrfToken %>'/>
        	<input type='text' name='comment'>
            <input type="submit" value="Post comment!">
            <%-- DONE - TODO: user_id should not be part of form (it's session info) --%>
            <%-- <input type="hidden" name="user_id" value='<%= user_id %>'> --%>
            <input type="hidden" name="image_id" value='<%= image_id %>'>
   		 </form>
   		<br>

   		<%-- DONE - TODO: only output Invite form if users own image --%>

   	<%
   		String hide;
   		if ( other_name.equals(username) ) {
   	%>
   		<form action="Invite" method="post">
            <input type="hidden" name="csrfPreventionToken" value='<%= csrfToken %>'/>
   			<input type='text' name='other'>
            <input type="submit" value="Share image!">
            <input type="hidden" name="image_id" value="<%= image_id %>">
   		</form>
   		<br>
	 </li>
	 <% } %>
<%
	}
%>
</ul>

</body>
</html>
