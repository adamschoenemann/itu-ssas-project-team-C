<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import = "java.sql.*"
    import = "dk.itu.ssas.project.DB" 
%>
<%
	String user = session.getAttribute("user").toString();
	String username = session.getAttribute("username").toString();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>SSAS Photo Sharing Project</title>
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
<p>Hello, <%= username %>!
<p><form method="post" enctype="multipart/form-data" action="Uploader">
	Add a picture: 
	<input type="file" name="pic" accept="jpeg">
	<input type="submit" value="Upload!">
</form>
<ul>
<%
	Connection con = DB.getConnection();
    Statement st = con.createStatement();
    Statement st2 = con.createStatement();
    ResultSet image_ids = st.executeQuery(
    	"SELECT DISTINCT image_id FROM perms WHERE perms.user_id = " + user);
    while (image_ids.next()) {
    	  String image_id = image_ids.getString(1);       
    	  ResultSet other = st2.executeQuery(
              "SELECT username " +
              "FROM users INNER JOIN images " + 
              "WHERE users.id = images.owner " +
              "AND   images.id = " + image_id
    	  );
    	  other.next();
    	  String other_name = other.getString(1);
  %>
	<li> Posted by <%= other_name%>:<br><br>
	   <img src="Downloader?image_id=<%= image_id %>" width="60%"><br>
	    Shared with: 
<%         
		ResultSet viewers = st2.executeQuery(
			"SELECT users.username " +
		    "FROM users INNER JOIN perms " +
			"WHERE users.id = perms.user_id " +
		    "AND perms.image_id = " + image_id
		);
		while (viewers.next()) {
			String sharee = viewers.getString(1);
			if (sharee.equals (username)) {
				continue;
			}
%>
		<%= sharee %>
<% 
		}			
%>
		<br><br>
<%
		
		
        ResultSet comments = st2.executeQuery(
        	"SELECT comments.comment, users.username " + 
            "FROM comments INNER JOIN users " + 
            "WHERE users.id = comments.user_id " +
            "AND comments.image_id = " + image_id
        );	
        while (comments.next()) {
%>
		From <%= comments.getString(2) %>: "<%= comments.getString(1) %>"<br>
<%
        }
 %>
 <br>
   <form action="Comment" method="post">
        	<input type='text' name='comment'>
            <input type="submit" value="Post comment!">
            <input type="hidden" name="user_id" value='<%= user %>'>
            <input type="hidden" name="image_id" value='<%= image_id %>'>
   		 </form>	
   		<br>
   		<form action="Invite" method="post">
   			<input type='text' name='other'>
            <input type="submit" value="Share image!">
            <input type="hidden" name="image_id" value="<%= image_id %>">
   		</form>
   		<br>
	 </li>       
<%
	}
%>     
</ul>   

</body>
</html>