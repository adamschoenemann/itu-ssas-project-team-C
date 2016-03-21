package dk.itu.ssas.project;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



/**
 * Servlet implementation class Downloader
 */
@WebServlet("/Downloader")
public class Downloader extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Downloader() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try 
		{
			Connection con = DB.getConnection();
			String image_id = request.getParameter("image_id");
			Statement st = con.createStatement();
			ResultSet image = st.executeQuery("SELECT jpeg FROM images WHERE id = " + image_id);
			image.next();
			byte[] content = image.getBytes("jpeg");
			response.setContentType("image/jpeg");
			response.setContentLength(content.length);
			response.getOutputStream().write(content);		
		}
		catch (SQLException e) {
			throw new ServletException("SQL malfunction.", e);
		}
	}
}
