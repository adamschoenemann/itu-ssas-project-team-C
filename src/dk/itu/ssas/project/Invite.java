package dk.itu.ssas.project;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Invite
 */
@WebServlet("/Invite")
public class Invite extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Invite() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException 
	{
		try
		{
			Connection con = DB.getConnection();
			String sql = 
				"INSERT INTO perms (image_id, user_id) " + 
				"SELECT " + request.getParameter("image_id") + ", users.id " +
		    	"FROM users " +
			    "WHERE users.username = '" + request.getParameter("other") + "'";
			System.out.println(sql);
			Statement st = con.createStatement();
			st.executeUpdate(sql);
					
			response.sendRedirect("main.jsp");
		}
		catch (SQLException e) 
		{
			throw new ServletException("SQL malfunction.", e);
		}
	}
}
