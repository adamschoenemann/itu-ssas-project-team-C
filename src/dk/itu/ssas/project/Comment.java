package dk.itu.ssas.project;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Comment
 */
@WebServlet("/Comment")
public class Comment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Comment() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 try
		 {
			 Connection con = DB.getConnection();
		 
			 Statement st = con.createStatement();
			 st.executeUpdate("INSERT INTO comments (image_id, user_id, comment) VALUES (" +
				 request.getParameter("image_id") + ", " + 
				 request.getParameter("user_id") + ", '" +
				 request.getParameter("comment") + "')");
			 response.sendRedirect("main.jsp");
		 }
		 catch (Exception e) 
		 {
			 throw new ServletException("SQL malfunction.", e);
		 }
	}

}
